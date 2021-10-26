import 'dart:math';

import 'package:android_metadata/android_metadata.dart' show AndroidMetadata;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'
    show FacebookAuth;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart' show Logger;
import 'package:google_maps_webservice/places.dart'
    show GoogleMapsPlaces, Location, PlacesSearchResult;
import 'package:geolocator/geolocator.dart'
    show GeolocatorPlatform, LocationPermission, Position;
import 'dart:async' show Future;

import 'platform_colours.dart' show getThemeData;
import 'info.dart' show InfoPage;
import 'common.dart' show title;

var log = Logger();

void main() {
  FacebookAuth.instance.autoLogAppEventsEnabled(true);

  runApp(const MyApp());
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
              routes: {
                InfoPage.routeName: (context) => const InfoPage(),
              },
            ));
  }
}

class MyHomePage extends StatefulWidget {
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
    },
        onError: (error, stackTrace) async =>
            log.e("Failed to get google maps api key", error, stackTrace));
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
      log.e("timed out", e, s);
      return;
    }
    var location =
        Location(lat: geoposition.latitude, lng: geoposition.longitude);

    var response =
        await places.searchNearbyWithRadius(location, 3000, type: "restaurant");
    if (response.errorMessage != null) {
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
    log.w('Calling express login');
    var loginResult = await FacebookAuth.instance.expressLogin();

    log.w("loginResult",
        {"status": loginResult.status, "message": loginResult.message});

    setState(() {
      userId = loginResult.accessToken?.userId;
    });
  }

  void _handleNav(int value) {
    switch (value) {
      case 0:
        _incrementCounter();
        break;
      case 1:
        _login().whenComplete(() => log.i("complete login"));
        break;
      case 2:
        getPlaces().whenComplete(() => log.i("complete get Places"));
        break;
      case 3:
        Navigator.pushNamed(context, InfoPage.routeName);
        break;
      default:
        log.e("fell through", value);
    }
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    var locations = results
        .sublist(0, min(results.length, 10))
        .map((e) => Text(e.name, style: Theme.of(context).textTheme.headline4));

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text('Matching locations'),
            ...locations,
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: _handleNav,
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(
                icon: Icon(CupertinoIcons.add), label: 'Increment'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.person), label: 'Login'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.placemark), label: 'Get Places'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.info), label: "Info"),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
