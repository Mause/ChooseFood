import 'dart:async' show Future;
import 'dart:collection';

import 'package:choose_food/components/friends_sessions.dart';
import 'package:choose_food/environment_config.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        ButtonBar,
        Card,
        ElevatedButton,
        Ink,
        ListTile,
        Theme,
        ThemeData,
        showDialog;
import 'package:flutter/widgets.dart'
    show
        Axis,
        BoxFit,
        BuildContext,
        Column,
        EdgeInsets,
        FutureBuilder,
        Key,
        ListBody,
        MediaQuery,
        NetworkImage,
        Padding,
        SingleChildScrollView,
        SizedBox,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        Widget,
        Wrap,
        runApp;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'
    show FacebookAuth, LoginStatus;
import 'package:geolocator/geolocator.dart'
    show GeolocatorPlatform, LocationPermission, Position;
import 'package:google_maps_webservice/places.dart'
    show GoogleMapsPlaces, Location, PlacesSearchResult;
import 'package:loader_overlay/loader_overlay.dart'
    show LoaderOverlay, OverlayControllerWidgetExtension;
import 'package:logger/logger.dart' show Logger;
import 'package:sentry_flutter/sentry_flutter.dart'
    show Sentry, SentryFlutter, SentryNavigatorObserver;
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

import 'common.dart' show BasePage, title;
import 'info.dart' show InfoPage;
import 'platform_colours.dart' show getThemeData;

var log = Logger();

Future<void> main() async {
  if (EnvironmentConfig.sentryDsn == 'https://...') {
    log.w("Running without sentry");
    runApp(const MyApp());
  } else {
    await SentryFlutter.init((options) {
      options.dsn = EnvironmentConfig.sentryDsn;
    }, appRunner: () => runApp(const MyApp()));
  }
}

Widget Function(BuildContext) makeErrorDialog(String error) {
  return (BuildContext context) => AlertDialog(
      title: const Text('Login failed'),
      content: SingleChildScrollView(child: ListBody(children: [Text(error)])));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.isLogEnable = true;
    Get.put(SupabaseClient(
        EnvironmentConfig.supabaseUrl, EnvironmentConfig.supabaseKey));
    Get.put(GoogleMapsPlaces(apiKey: EnvironmentConfig.googleApiKey));

    return FutureBuilder<ThemeData>(
        future: getThemeData(),
        builder: (context, snapshot) => GetMaterialApp(
              title: title,
              theme: snapshot.data ?? ThemeData(),
              home: const LoaderOverlay(child: MyHomePage(title: title)),
              navigatorObservers: [
                SentryNavigatorObserver(),
              ],
              routes: {
                InfoPage.routeName: (context) => const InfoPage(),
                FriendsSessions.routeName: (context) => const FriendsSessions()
              },
            ));
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

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? userId;
  int index = 0;
  List<PlacesSearchResult> results = [];
  String? sessionId;

  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  GoogleMapsPlaces places = Get.find();
  SupabaseClient supabaseClient = Get.find();

  getPlaces() async {
    context.loaderOverlay.show();
    var session =
        await supabaseClient.from(TableNames.session).insert({}).execute();
    if (session.error != null) {
      log.e(session.error!.message);
    }
    setState(() {
      sessionId = ((session.data as List<dynamic>)[0]
          as LinkedHashMap<String, dynamic>)['id'];
    });

    log.i("started new session: $sessionId");

    var locationServiceEnabled =
        await geolocatorPlatform.isLocationServiceEnabled();
    log.i({"locationServiceEnabled": locationServiceEnabled});
    if (!locationServiceEnabled) {
      log.e("Location service not enabled");
      return;
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
        log.e("Location permission not given");
        return;
      }
    } catch (e, s) {
      log.e("Failed to request permission, trying anyway", e, s);
    }

    Position geoposition;
    try {
      geoposition = await geolocatorPlatform.getCurrentPosition(
          timeLimit: const Duration(seconds: 10));
    } catch (e, s) {
      showDialog(context: context, builder: makeErrorDialog(e.toString()));
      await Sentry.captureException(e, stackTrace: s);
      log.e("location request timed out", e, s);
      return;
    }
    var location =
        Location(lat: geoposition.latitude, lng: geoposition.longitude);

    var response =
        await places.searchNearbyWithRadius(location, 3000, type: "restaurant");
    if (response.errorMessage != null) {
      await Sentry.captureMessage(response.errorMessage);
      log.e(response.errorMessage);
    } else {
      log.i("found places ${response.results.length}");
    }

    setState(() {
      results = response.results;
      context.loaderOverlay.hide();
    });
  }

  Future<void> _login() async {
    log.w('Calling login');

    var accessToken = await FacebookAuth.i.accessToken;
    if (accessToken == null) {
      var loginResult =
          await FacebookAuth.instance.login(permissions: ["email"]);
      log.w({"status": loginResult.status, "message": loginResult.message});
      if (loginResult.status != LoginStatus.success) {
        await Sentry.captureMessage(loginResult.message!);
        await showDialog(
            context: context, builder: makeErrorDialog(loginResult.message!));
      }
      accessToken = loginResult.accessToken;
    }

    if (accessToken == null) {
      await Sentry.captureMessage('failed to login');
      log.e("failed to login");
      return;
    }

    setState(() {
      userId = accessToken?.userId;
    });

    log.i("login complete?");
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
            elevatedButton('Login', _login),
            elevatedButton('Increment', _incrementCounter),
            elevatedButton('Get places', getPlaces),
          ],
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
        location ?? const Text('No locations loaded yet'),
        //Expanded(child: ListView(children: locations, primary: true)),
      ],
    );
  }

  Future<void> createDecision(String reference, bool state) async {
    await supabaseClient.from(TableNames.decision).insert({
      "sessionId": sessionId!,
      "placeReference": reference,
      "decision": state
    }).execute();
  }
}

class TableNames {
  static const String decision = "decision";
  static const String session = "session";
  static const String participant = "participant";
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

Padding elevatedButton(String label, void Function() onPressed) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(
      child: Text(label),
      onPressed: onPressed,
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
