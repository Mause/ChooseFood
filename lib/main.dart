import 'package:android_metadata/android_metadata.dart' show AndroidMetadata;
import 'package:choose_food/environment_config.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        Card,
        ElevatedButton,
        MaterialApp,
        Theme,
        ThemeData,
        showDialog;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Expanded,
        FutureBuilder,
        Image,
        Key,
        ListBody,
        ListView,
        MediaQuery,
        Row,
        SingleChildScrollView,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        Widget,
        runApp;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'
    show FacebookAuth, LoginStatus;
import 'package:loader_overlay/loader_overlay.dart'
    show LoaderOverlay, OverlayControllerWidgetExtension;
import 'package:logger/logger.dart' show Logger;
import 'package:google_maps_webservice/places.dart'
    show GoogleMapsPlaces, Location, PlacesSearchResult;
import 'package:geolocator/geolocator.dart'
    show GeolocatorPlatform, LocationPermission, Position;
import 'package:sentry_flutter/sentry_flutter.dart'
    show Sentry, SentryFlutter, SentryNavigatorObserver;
import 'dart:async' show Future;

import 'platform_colours.dart' show getThemeData;
import 'info.dart' show InfoPage;
import 'common.dart' show BasePage, title;

var log = Logger();

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn = EnvironmentConfig.sentryDsn;
  }, appRunner: () => runApp(const MyApp()));
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
    return FutureBuilder<ThemeData>(
        future: getThemeData(),
        builder: (context, snapshot) => MaterialApp(
              title: title,
              theme: snapshot.data ?? ThemeData(),
              home: const LoaderOverlay(child: MyHomePage(title: title)),
              navigatorObservers: [
                SentryNavigatorObserver(),
              ],
              routes: {
                InfoPage.routeName: (context) => const InfoPage(),
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? userId;
  List<PlacesSearchResult> results = [];

  GoogleMapsPlaces places = GoogleMapsPlaces();

  _MyHomePageState() {
    AndroidMetadata.metaDataAsMap.then((value) {
      places =
          GoogleMapsPlaces(apiKey: value!['com.google.android.geo.API_KEY']);
    }, onError: (error, stackTrace) async {
      await Sentry.captureException(error, stackTrace: stackTrace);
      log.e("Failed to get google maps api key", error, stackTrace);
    });
  }

  getPlaces() async {
    context.loaderOverlay.show();
    var geolocatorPlatform = GeolocatorPlatform.instance;
    var locationServiceEnabled =
        await geolocatorPlatform.isLocationServiceEnabled();
    var permission = await geolocatorPlatform.requestPermission();
    log.i({
      "message": "checking location",
      "locationServiceEnabled": locationServiceEnabled,
      "permission": permission
    });
    if (!(locationServiceEnabled && isAllowed(permission))) {
      log.e("Location permission not given");
      return;
    }

    Position geoposition;
    try {
      geoposition = await geolocatorPlatform.getCurrentPosition(
          timeLimit: const Duration(seconds: 10));
    } catch (e, s) {
      await Sentry.captureException(e, stackTrace: s);
      log.e("timed out", e, s);
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
      log.i("found places", response.results.length);
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
    var locations = results
        .map(
          (e) => Card(
            child: Row(
              children: [
                Expanded(
                  child: Image.network(places.buildPhotoUrl(
                      maxWidth: MediaQuery.of(context).size.width.truncate(),
                      photoReference: e.photos[0].photoReference)),
                ),
                Text(e.name),
              ],
            ),
          ),
        )
        .toList();

    return BasePage(
      selectedIndex: 0,
      children: <Widget>[
        ElevatedButton(
          child: const Text('Login'),
          onPressed: () {
            _login().whenComplete(() => log.i("login complete?"));
          },
        ),
        ElevatedButton(
          child: const Text('Increment'),
          onPressed: _incrementCounter,
        ),
        ElevatedButton(child: const Text('Get places'), onPressed: getPlaces),
        const Text(
          'You have clicked the button this many times:',
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
        const Text('Matching locations'),
        ListView(children: locations),
      ],
    );
  }
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
