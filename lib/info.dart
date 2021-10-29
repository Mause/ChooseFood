import 'package:flutter/cupertino.dart'
    show BuildContext, Key, State, StatefulWidget, Widget;
import 'package:flutter/material.dart' show AboutListTile, Text;
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import 'package:loader_overlay/loader_overlay.dart'
    show OverlayControllerWidgetExtension;
import 'package:sentry_flutter/sentry_flutter.dart' show Sentry;

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
  List<Widget> rows = [];

  @override
  void initState() {
    context.loaderOverlay.show();
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) {
      context.loaderOverlay.hide();
      setState(() {
        rows = [
          AboutListTile(
              applicationName: packageInfo.appName,
              applicationVersion: packageInfo.version)
        ];
      });
    }, onError: (error) async {
      await Sentry.captureException(error);
      setState(() {
        context.loaderOverlay.hide();
        rows = [Text(error.toString())];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 3,
      children: rows,
    );
  }
}
