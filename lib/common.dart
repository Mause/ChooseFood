import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart'
    show
        AlertDialog,
        AppBar,
        BoxConstraints,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Column,
        Container,
        Icon,
        Key,
        ListBody,
        MainAxisAlignment,
        NavigationBar,
        NavigationDestination,
        NavigationDestinationLabelBehavior,
        Navigator,
        Row,
        Scaffold,
        SingleChildScrollView,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        Widget;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:get/get.dart' show Get, Inst;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';
import 'package:loader_overlay/loader_overlay.dart'
    show OverlayControllerWidgetExtension;
import 'package:supabase/supabase.dart'
    show
        PostgrestBuilder,
        PostgrestError,
        PostgrestResponse,
        SupabaseClient,
        User;

import 'main.dart';
import 'info.dart';
import 'components/friends_sessions.dart' show FriendsSessions;
import 'components/historical_sessions.dart' show HistoricalSessions;

const title = "Choose Food";
var log = Logger();

class BasePage extends StatefulWidget {
  final List<Widget> children;
  final int selectedIndex;

  const BasePage(
      {Key? key, required this.selectedIndex, required this.children})
      : super(key: key);

  @override
  createState() => _BasePage();
}

class _BasePage extends State<BasePage> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  void _handleNav(int value) {
    setState(() {
      selectedIndex = value;
    });
    switch (value) {
      case 0:
        Navigator.pushNamed(context, MyHomePage.routeName);
        break;
      case 1:
        Navigator.pushNamed(context, FriendsSessions.routeName);
        break;
      case 2:
        Navigator.pushNamed(context, HistoricalSessions.routeName);
        break;
      case 3:
        Navigator.pushNamed(context, InfoPage.routeName);
        break;
      default:
        log.e("fell through", value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(title),
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
          children: widget.children,
        ),
      ),
      bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: _handleNav,
          selectedIndex: selectedIndex,
          destinations: const [
            NavigationDestination(
                icon: Icon(CupertinoIcons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.person_2), label: 'Friends sessions'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.time), label: 'Past sessions'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.info), label: "Info"),
          ]),
    );
  }
}

Future<MyPostgrestResponse<T>> execute<T>(PostgrestBuilder builder,
    T Function(Map<String, dynamic> e) fromJson) async {
  var response = await builder.execute();

  return MyPostgrestResponse(
      datam: ((response.data as List<dynamic>?) ?? [])
          .map((e) => e as Map<String, dynamic>)
          .map((e) => fromJson(e))
          .toList(),
      error: response.error);
}

extension TypedExecuteExtension on PostgrestBuilder {
  Future<MyPostgrestResponse<T>> typedExecute<T>(
      T Function(Map<String, dynamic> e) fromJson) async {
    return execute<T>(this, fromJson);
  }
}

class MyPostgrestResponse<T> extends PostgrestResponse {
  @override
  get data => datam;

  List<T> datam;

  MyPostgrestResponse(
      {required this.datam, int? count, PostgrestError? error, int? status})
      : super(count: count, error: error, status: status);
}

Widget Function(BuildContext) makeErrorDialog(String error,
    {dynamic title = 'Login failed'}) {
  return (BuildContext context) => AlertDialog(
      title: Text(title.toString()),
      content: SingleChildScrollView(child: ListBody(children: [Text(error)])));
}

Map<String, dynamic> excludeNull(Map<String, dynamic> map) =>
    Map.from(map)..removeWhere((key, value) => value == null);

class LabelledProgressIndicator extends StatelessWidget {
  final String label;

  const LabelledProgressIndicator(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 36.0,
        minHeight: 36.0,
      ),
      child: Row(
        children: [const CircularProgressIndicator(), Text(label)],
      ),
    );
  }
}

extension LabelledProgressIndicatorExtension on BuildContext {
  onNextFrame(void Function() callback) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      callback();
    });
  }

  progress(String label, {instantInit = false}) {
    if (instantInit) {
      loaderOverlay.show(widget: LabelledProgressIndicator(label));
    } else {
      onNextFrame(() {
        loaderOverlay.show(widget: LabelledProgressIndicator(label));
      });
    }
  }

  hideProgress() {
    onNextFrame(() {
      loaderOverlay.hide();
    });
  }
}

User? getAccessToken() {
  SupabaseClient supabaseClient = Get.find();

  var accessToken = supabaseClient.auth.currentSession?.accessToken;
  if (accessToken == null) return null;

  var decode = Jwt.parseJwt(accessToken);

  decode['id'] = decode['sub'];
  decode['created_at'] = decode['updated_at'] = "0";

  return User.fromJson(decode);
}
