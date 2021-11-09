import 'package:choose_food/common.dart'
    show BasePage, MyPostgrestResponse, execute;
import 'package:choose_food/main.dart' show ColumnNames, TableNames;
import 'package:flutter/material.dart'
    show
        AlertDialog,
        ButtonBar,
        Card,
        DataCell,
        DataColumn,
        DataRow,
        DataTable,
        ListTile,
        TextButton,
        showDialog;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Column,
        Expanded,
        Key,
        ListView,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        Widget;
import 'package:get/get.dart' show Get, Inst;
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart' show Logger;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase/supabase.dart' show SupabaseClient;

import '../generated_code/openapi.models.swagger.dart'
    show Decision, Session, Point;

part 'friends_sessions.g.dart';

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
    MyPostgrestResponse<SessionWithDecisions> sessions;

    context.loaderOverlay.show();

    try {
      sessions = await execute<SessionWithDecisions>(
          supabaseClient.from(TableNames.session).select("""
              id,
              decision(
                decision,
                placeReference,
                participantId
              )
              """).is_(ColumnNames.session.concludedTime, null),
          SessionWithDecisions.fromJson);
    } catch (e, s) {
      handleError(e, s);
      return;
    }

    if (sessions.error != null) {
      handleError(sessions.error, null);
    }

    setState(() {
      this.sessions = sessions.datam
          .map((e) => SessionCard(sessionWithDecisions: e))
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

@JsonSerializable()
class SessionWithDecisions extends Session {
  List<Decision> decision;

  SessionWithDecisions(this.decision, String? id, String? concludedTime,
      String? createdAt, Point? point)
      : super(
            id: id,
            concludedTime: concludedTime,
            createdAt: createdAt,
            point: point);

  @override
  factory SessionWithDecisions.fromJson(Map<String, dynamic> json) =>
      _$SessionWithDecisionsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SessionWithDecisionsToJson(this);
}

class SessionCard extends StatelessWidget {
  final SessionWithDecisions sessionWithDecisions;

  const SessionCard({Key? key, required this.sessionWithDecisions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(title: Text(sessionWithDecisions.id!)),
          ButtonBar(children: [
            TextButton(
                onPressed: () {
                  Sentry.captureMessage(
                      'User wishes to join ${sessionWithDecisions.id}');
                },
                child: const Text('Join')),
            TextButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) =>
                          buildDialog(context, sessionWithDecisions));
                },
                child: const Text('View details'))
          ])
        ],
      ),
    );
  }
}

Widget buildDialog(context, SessionWithDecisions sessionWithDecisions) =>
    AlertDialog(
        title: Text(sessionWithDecisions.id!),
        content: DataTable(
            columns: const [
              DataColumn(label: Text("Place Reference")),
              DataColumn(label: Text("Decision")),
              DataColumn(label: Text("Participant ID"))
            ],
            rows: sessionWithDecisions.decision
                .map((e) => DataRow(cells: [
                      DataCell(Text(
                        e.placeReference!,
                      )),
                      DataCell(Text(e.decision!.toString())),
                      DataCell(Text(e.participantId!.toString()))
                    ]))
                .toList()));
