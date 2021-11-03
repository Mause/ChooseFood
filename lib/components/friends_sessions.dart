import 'package:choose_food/common.dart' show BasePage;
import 'package:choose_food/main.dart' show TableNames;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Expanded,
        Key,
        ListView,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:get/get.dart' show Get, Inst;
import 'package:logger/logger.dart' show Logger;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase/supabase.dart' show SupabaseClient;

var log = Logger();

class FriendsSessions extends StatefulWidget {
  static const routeName = "/friends";

  const FriendsSessions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FriendsSessionsState();
}

class FriendsSessionsState extends State<FriendsSessions> {
  SupabaseClient supabaseClient = Get.find();

  List<Widget> sessions = [];

  @override
  void initState() {
    super.initState();

    ((supabaseClient.from(TableNames.session).select().execute().then(
        (sessions) {
      if (sessions.error != null) {
        handleError(sessions.error);
      }
      setState(() {
        this.sessions = (sessions.data as List<dynamic>)
            .map((e) => Text((e as Map<String, dynamic>)['id']))
            .toList();
      });
    }, onError: handleError)));
  }

  handleError(error) {
    log.e("Failed to load sessions", error);
    Sentry.captureException(error, hint: "Failed to load sessions");
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(selectedIndex: 1, children: [
      Expanded(child: ListView(children: sessions, primary: true))
    ]);
  }
}
