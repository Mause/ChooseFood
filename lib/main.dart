import 'dart:async' show Future, FutureOr;

import 'package:choose_food/components/friends_sessions.dart';
import 'package:choose_food/components/historical_sessions.dart';
import 'package:choose_food/environment_config.dart';
import 'package:choose_food/generated_code/openapi.enums.swagger.dart'
    show PointType;
import 'package:flutter/material.dart'
    show ButtonBar, Card, ElevatedButton, Ink, ListTile, ThemeData, showDialog;
import 'package:flutter/widgets.dart'
    show
        Axis,
        BoxFit,
        BuildContext,
        Column,
        EdgeInsets,
        FutureBuilder,
        Key,
        MediaQuery,
        NetworkImage,
        Padding,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        Widget,
        Wrap,
        runApp;
import 'package:geolocator/geolocator.dart'
    show GeolocatorPlatform, LocationPermission, LocationSettings, Position;
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart'
    show GoogleMapsPlaces, Location, PlacesSearchResult;
import 'package:loader_overlay/loader_overlay.dart'
    show GlobalLoaderOverlay, OverlayControllerWidgetExtension;
import 'package:logger/logger.dart' show Logger;
import 'package:material_you_colours/material_you_colours.dart'
    show getMaterialYouThemeData;
import 'package:sentry_flutter/sentry_flutter.dart'
    show Sentry, SentryFlutter, SentryNavigatorObserver, SentryEvent;
import 'package:sentry_logging/sentry_logging.dart' show LoggingIntegration;
import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, SupabaseClient;

import 'common.dart'
    show
        BasePage,
        LabelledProgressIndicatorExtension,
        TypedExecuteExtension,
        excludeNull,
        getAccessToken,
        makeErrorDialog,
        title;
import 'common/auth_required_state.dart' show AuthRequiredState;
import 'components/login_dialog.dart';
import 'generated_code/openapi.models.swagger.dart'
    show Session, Point, Decision, Participant;
import 'info.dart' show InfoPage;
import 'sessions.dart' show Sessions;

var log = Logger();

Future<void> main() async {
  if (EnvironmentConfig.sentryDsn == 'https://...') {
    log.w("Running without sentry");
    await _runApp();
  } else {
    await SentryFlutter.init((options) {
      options.dsn = EnvironmentConfig.sentryDsn;
      options.beforeSend = beforeSend;
      options.addIntegration(LoggingIntegration());
    }, appRunner: _runApp);
  }
}

Future<void> _runApp() async {
  await Supabase.initialize(
      url: EnvironmentConfig.supabaseUrl,
      anonKey: EnvironmentConfig.supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.isLogEnable = true;

    Get.put(Supabase.instance.client);
    Get.put(GoogleMapsPlaces(apiKey: EnvironmentConfig.googleApiKey));

    return FutureBuilder<ThemeData>(
        future: getMaterialYouThemeData(),
        builder: (context, snapshot) => GlobalLoaderOverlay(
                child: GetMaterialApp(
              title: title,
              theme: snapshot.data ?? ThemeData(),
              initialRoute: MyHomePage.routeName,
              navigatorObservers: [
                SentryNavigatorObserver(),
              ],
              routes: {
                MyHomePage.routeName: (context) =>
                    const MyHomePage(title: title),
                LoginDialog.routeName: (context) => const LoginDialog(),
                InfoPage.routeName: (context) => const InfoPage(),
                FriendsSessions.routeName: (context) => const FriendsSessions(),
                HistoricalSessions.routeName: (context) =>
                    const HistoricalSessions(),
              },
            )));
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = "/";

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends AuthRequiredState<MyHomePage> {
  String? userId;
  int index = 0;
  List<PlacesSearchResult> results = [];
  String? sessionId;

  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  GoogleMapsPlaces places = Get.find();
  SupabaseClient supabaseClient = Get.find();

  Participant? participant;

  @override
  void onAuthenticated(session) {
    loadExistingSession();
  }

  Future<void> loadExistingSession() async {
    context.progress("Loading existing session");

    var response = await supabaseClient
        .from(TableNames.session)
        .select()
        .is_(ColumnNames.session.concludedTime, null)
        .typedExecute(Session.fromJson);
    if (response.error != null) {
      throw await makeError(response.error);
    }

    setState(() {
      sessionId = response.datam.isEmpty ? null : response.datam[0].id;
    });

    if (response.datam.isNotEmpty) {
      await loadPlaces(toLocation(response.datam[0].point!));
    } else {
      context.loaderOverlay.hide();
    }
  }

  Location toLocation(Point point) {
    var coordinates = point.coordinates!;
    var location = Location(lat: coordinates[0], lng: coordinates[1]);
    return location;
  }

  getPlaces() async {
    context.progress("Determining location...");
    var location = await getLocation();

    context.progress("Creating session...");
    await createSession(location);

    await loadPlaces(location);
  }

  Future<void> loadPlaces(Location location) async {
    context.progress("Loading places...");
    var response =
        await places.searchNearbyWithRadius(location, 3000, type: "restaurant");
    if (response.errorMessage != null) {
      throw await makeError(response.errorMessage!);
    } else {
      log.i("found places ${response.results.length}");
    }

    setState(() {
      results = response.results;
      context.loaderOverlay.hide();
    });
  }

  Future<Location> getLocation() async {
    var locationServiceEnabled =
        await geolocatorPlatform.isLocationServiceEnabled();
    log.i({"locationServiceEnabled": locationServiceEnabled});
    if (!locationServiceEnabled) {
      throw makeError("Location service not enabled");
    }
    try {
      var permission = await geolocatorPlatform
          .requestPermission()
          .timeout(const Duration(minutes: 1));
      log.i({
        "message": "checking location",
        "locationServiceEnabled": locationServiceEnabled,
        "permission": permission
      });
      if (!isAllowed(permission)) {
        throw await makeError("Location permission not given");
      }
    } catch (e, s) {
      log.e("Failed to request permission, trying anyway", e, s);
    }

    Position geoposition;
    try {
      geoposition = await geolocatorPlatform.getCurrentPosition(
          locationSettings:
              const LocationSettings(timeLimit: Duration(seconds: 10)));
    } catch (e, s) {
      throw await makeError("Location request timed out", e: e, s: s);
    }
    var location =
        Location(lat: geoposition.latitude, lng: geoposition.longitude);
    return location;
  }

  Future<ArgumentError> makeError(dynamic message,
      {dynamic e, StackTrace? s}) async {
    await Sentry.captureException(e, stackTrace: s, hint: message);
    context.loaderOverlay.hide();
    await showDialog(
        context: context,
        builder: makeErrorDialog(e.toString(), title: message));
    log.e(message, e, s);
    return ArgumentError(message);
  }

  Future<void> createSession(Location location) async {
    var response = await supabaseClient
        .from(TableNames.session)
        .insert(excludeNull(Session(
            point: Point(
                type: PointType.point,
                coordinates: [location.lat, location.lng])).toJson()))
        .typedExecute(Session.fromJson);
    if (response.error != null) {
      log.e(response.error);
      throw ArgumentError(response.error);
    }

    var session = response.data[0];

    participant = await Sessions().joinSession(session, getAccessToken()!);

    setState(() {
      sessionId = session.id;
    });

    log.i("started new session: $sessionId");
  }

  Future<void> _login() async {
    await showDialog(
        context: context, builder: (context) => const LoginDialog());

    // log.w('Calling login');

    // var accessToken = await FacebookAuth.i.accessToken;
    // if (accessToken == null) {
    //   var loginResult =
    //       await FacebookAuth.instance.login(permissions: ["email"]);
    //   log.w({"status": loginResult.status, "message": loginResult.message});
    //   if (loginResult.status != LoginStatus.success) {
    //     await Sentry.captureMessage(loginResult.message!);
    //     await showDialog(
    //         context: context, builder: makeErrorDialog(loginResult.message!));
    //   }
    //   accessToken = loginResult.accessToken;
    // }

    // if (accessToken == null) {
    //   throw await makeError('Failed to login');
    // }

    // setState(() {
    //   userId = accessToken?.userId;
    // });

    // log.i("login complete?");
  }

  @override
  Widget build(BuildContext context) {
    LocationCard? location;

    if (results.isNotEmpty) {
      location = LocationCard(
          location: results[index],
          callback: (location, state) async {
            await createDecision(location.reference, state);
            setState(() {
              index++;
            });
          });
    }

    return BasePage(
      selectedIndex: 0,
      children: <Widget>[
        Wrap(
          direction: Axis.horizontal,
          children: [
            getAccessToken() == null
                ? elevatedButton('Login', _login)
                : elevatedButton('Logout', () async {
                    context.progress('Logging out');
                    await supabaseClient.auth.signOut();
                    context.loaderOverlay.hide();
                  }),
            elevatedButton('Conclude session', concludeSession,
                enabled: sessionId != null),
            elevatedButton('Get places', getPlaces,
                enabled: getAccessToken() != null),
          ],
        ),
        Text(
          getAccessToken() != null
              ? 'Logged in: ${getAccessToken()?.phone ?? "Unknown"}'
              : 'Logged out',
        ),
        Text(sessionId == null
            ? 'No session started yet'
            : 'Session ID: $sessionId'),
        location ?? const Text('No locations loaded yet'),
        //Expanded(child: ListView(children: locations, primary: true)),
      ],
    );
  }

  Future<void> createDecision(String reference, bool state) async {
    await supabaseClient
        .from(TableNames.decision)
        .insert(excludeNull(Decision(
                sessionId: sessionId!,
                participantId: participant!.id,
                placeReference: reference,
                decision: state)
            .toJson()))
        .typedExecute(Decision.fromJson);
  }

  Future<void> concludeSession() async {
    context.progress('Closing session');

    await Sessions().concludeSession(sessionId!);

    setState(() {
      sessionId = null;
      results = [];
      index = 0;
    });
    context.loaderOverlay.hide();
  }
}

class SessionFieldNames {
  final String concludedTime = "concludedTime";
  final String id = 'id';

  const SessionFieldNames();
}

class ColumnNames {
  static const session = SessionFieldNames();
  static const decision = DecisionFieldNames();
  static const participant = ParticipantFieldNames();
}

class ParticipantFieldNames {
  final String sessionId = "sessionId";
  final userId = "userId";
  final createdAt = "created_at";
  final id = "id";

  const ParticipantFieldNames();
}

class DecisionFieldNames {
  final String id = "id";
  final String decision = "decision";
  final String placeReference = "placeReference";
  final String participantId = "participantId";

  const DecisionFieldNames();
}

class TableNames {
  static const String decision = "decision";
  static const String session = "session";
  static const String participant = "participant";
  static const String users = "users";
}

class RpcNames {
  static const String getMatchingUsers = "get_matching_users";
}

class LocationCard extends StatelessWidget {
  final PlacesSearchResult location;
  final GoogleMapsPlaces places = Get.find();
  final void Function(PlacesSearchResult searchResult, bool state) callback;

  LocationCard({Key? key, required this.location, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Text(location.name)),
          SizedBox(
            height: 200.0,
            child: Ink.image(
              image: NetworkImage(
                places.buildPhotoUrl(
                    maxWidth: MediaQuery.of(context).size.width.truncate(),
                    photoReference: location.photos[0].photoReference),
              ),
              fit: BoxFit.cover,
            ),
          ),
          ButtonBar(children: [
            elevatedButton('No', () {
              callback(location, false);
            }),
            elevatedButton('Yes', () {
              callback(location, true);
            })
          ])
        ],
      ),
    );
  }
}

Padding elevatedButton(String label, void Function() onPressed,
    {bool enabled = true}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(
      child: Text(label),
      onPressed: enabled ? onPressed : null,
    ),
  );
}

bool isAllowed(LocationPermission index) {
  switch (index) {
    case LocationPermission.always:
    case LocationPermission.whileInUse:
      return true;
    default:
      return false;
  }
}

FutureOr<SentryEvent?> beforeSend(SentryEvent event, {hint}) {
  return event.tags?['os.rooted'] == 'yes' ? null : event;
}
