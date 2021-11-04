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
// ignore: import_of_legacy_library_into_null_safe
import 'package:supabase_client/api.dart' show Session;

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
        this.sessions = Session.listFromJson(sessions.data)
            .map((e) => Text(e.id!))
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
