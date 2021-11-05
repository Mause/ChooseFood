import 'package:choose_food/common.dart'
    show BasePage, MyPostgrestResponse, execute;
import 'package:loader_overlay/loader_overlay.dart';
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
import '../generated_code/openapi.models.swagger.dart' show Session;

var log = Logger();

class FriendsSessions extends StatefulWidget {
  static const routeName = "/friends";

  const FriendsSessions({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FriendsSessionsState();
}

List<Map<String, dynamic>> toMapList(dynamic data) =>
    (data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();

class FriendsSessionsState extends State<FriendsSessions> {
  SupabaseClient supabaseClient = Get.find();

  List<Widget> sessions = [];

  @override
  void initState() {
    super.initState();

    initSessions();
  }

  void initSessions() async {
    MyPostgrestResponse<Session> sessions;

    context.loaderOverlay.show();

    try {
      sessions = await execute<Session>(
          supabaseClient
              .from(TableNames.session)
              .select("id, decision(decision)"),
          Session.fromJson);
    } catch (e, s) {
      handleError(e, s);
      return;
    }

    if (sessions.error != null) {
      handleError(sessions.error, null);
    }

    setState(() {
      this.sessions = toMapList(sessions.data)
          .map((e) => Text(e['id'] +
              "(" +
              toMapList(e['decision']).map((e) => e['decision']).join(", ") +
              ")"))
          .toList();
    });
    context.loaderOverlay.hide();
  }

  handleError(error, StackTrace? stackTrace) {
    log.e("Failed to load sessions", error, stackTrace);
    Sentry.captureException(error, hint: "Failed to load sessions");

    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(selectedIndex: 1, children: [
      Expanded(child: ListView(children: sessions, primary: true))
    ]);
  }
}
