import 'package:choose_food/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'info.dart';

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
  late List<Widget> children;
  late int selectedIndex;

  @override
  void activate() {
    super.activate();
    selectedIndex = widget.selectedIndex;
    children = widget.children;
  }

  void _handleNav(int value) {
    setState(() {
      selectedIndex = value;
    });
    switch (value) {
      case 0:
        Navigator.pushNamed(context, MyHomePage.routeName);
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
          children: children,
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
                icon: Icon(CupertinoIcons.person), label: 'Login'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.placemark), label: 'Get Places'),
            NavigationDestination(
                icon: Icon(CupertinoIcons.info), label: "Info"),
          ]),
    );
  }
}