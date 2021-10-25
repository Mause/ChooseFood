import 'package:flutter/cupertino.dart'
    show BuildContext, Center, Column, Key, State, StatefulWidget, Widget;
import 'package:flutter/material.dart' show AppBar, Scaffold, Text, Theme;
import 'package:package_info_plus/package_info_plus.dart';

import 'common.dart' show title;

class InfoPage extends StatefulWidget {
  static const routeName = "/info";

  const InfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InfoPage();
  }
}

class _InfoPage extends State<InfoPage> {
  List<Text> rows = [];

  _InfoPage() {
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        rows = [
          text("appName", packageInfo.appName),
          text('version', packageInfo.version),
        ];
      });
    });
  }

  Text text(String label, dynamic value) {
    return Text('$label: $value', style: Theme.of(context).textTheme.headline6);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center(
            child: Column(
          children: rows,
        )));
  }
}
