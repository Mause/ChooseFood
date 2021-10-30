import 'dart:async' show Future;

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
        Axis,
        BuildContext,
        EdgeInsets,
        Expanded,
        FutureBuilder,
        Image,
        Key,
        ListBody,
        ListView,
        MediaQuery,
        Padding,
        Row,
        SingleChildScrollView,
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

import 'common.dart' show BasePage, title;
import 'info.dart' show InfoPage;
import 'platform_colours.dart' show getThemeData;

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

  GoogleMapsPlaces places =
      GoogleMapsPlaces(apiKey: EnvironmentConfig.googleApiKey);

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
      showDialog(context: context, builder: makeErrorDialog(e.toString()));
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
    var locations = results
        .map(
          (e) => LocationCard(location: e),
        )
        .toList();

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
        const Text(
          'You have clicked the button this many times:',
        ),
        Text(
          '$_counter',
          style: Theme.of(context).textTheme.headline4,
        ),
        const Text('Matching locations'),
        Expanded(child: ListView(children: locations, primary: true)),
      ],
    );
  }
}

class LocationCard extends StatelessWidget {
  final PlacesSearchResult location;

  const LocationCard({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Image.network(GoogleMapsPlaces().buildPhotoUrl(
                maxWidth: MediaQuery.of(context).size.width.truncate(),
                photoReference: location.photos[0].photoReference)),
          ),
          Wrap(direction: Axis.horizontal, children: [Text(location.name)]),
          Wrap(direction: Axis.horizontal, children: [
            elevatedButton('No', () {}),
            elevatedButton('Yes', () {})
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
