import 'package:flutter/cupertino.dart'
    show BuildContext, Key, State, StatefulWidget, Widget;
import 'package:flutter/material.dart' show Text, Theme;
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import 'common.dart' show BasePage;

class InfoPage extends StatefulWidget {
  static const routeName = "/info";

  const InfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InfoPage();
  }
}

class _InfoPage extends State<InfoPage> {
  List<Text> rows = [const Text("loading...")];

  @override
  void activate() {
    super.activate();
    PackageInfo.fromPlatform().then((packageInfo) {
      setState(() {
        rows = [
          text("appName", packageInfo.appName),
          text('version', packageInfo.version),
        ];
      });
    }, onError: (error) {
      setState(() {
        rows = [Text(error.toString())];
      });
    });
  }

  Text text(String label, dynamic value) {
    return Text('$label: $value', style: Theme.of(context).textTheme.headline6);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 3,
      children: rows,
    );
  }
}
