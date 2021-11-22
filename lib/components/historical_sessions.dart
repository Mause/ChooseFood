import 'package:choose_food/common.dart';
import 'package:choose_food/main.dart';
import 'package:flutter/material.dart'
    show
        ButtonBar,
        Card,
        DataCell,
        DataColumn,
        DataRow,
        DataTable,
        ListTile,
        TextButton;
import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Key,
        Column,
        Text,
        ListView,
        State,
        StatefulWidget,
        StatelessWidget,
        Widget;
import 'package:get/get.dart' show Get, Inst;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:loader_overlay/loader_overlay.dart'
    show OverlayControllerWidgetExtension;
import 'package:supabase/supabase.dart' show SupabaseClient;

import '../generated_code/openapi.models.swagger.dart' show Session;
import '../common.dart'
    show BasePage, LabelledProgressIndicatorExtension, execute;
import '../sessions.dart';

class HistoricalSessions extends StatefulWidget {
  static const routeName = "/historical";

  const HistoricalSessions({Key? key}) : super(key: key);

  @override
  State<HistoricalSessions> createState() => _HistoricalSessionsState();
}

class _HistoricalSessionsState extends State<HistoricalSessions> {
  final SupabaseClient supabaseClient = Get.find();

  List<Session>? sessions;

  @override
  void initState() {
    super.initState();

    context.progress("Loading historical sessions");
    loadSessions().whenComplete(() => context.loaderOverlay.hide());
  }

  Future<void> loadSessions() async {
    var sessions = await execute<Session>(
        supabaseClient
            .from(TableNames.session)
            .select()
            .not(ColumnNames.session.concludedTime, "is", null),
        Session.fromJson);
    if (sessions.error != null) {
      Get.snackbar(sessions.error!.message, sessions.error!.details.toString(),
          instantInit: false);
      return;
    }
    this.sessions = sessions.datam;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(selectedIndex: 2, children: [
      ListView(
        children:
            (sessions ?? []).map((session) => SessionCard(session)).toList(),
      )
    ]);
  }
}

class SessionCard extends StatelessWidget {
  final Session session;

  const SessionCard(this.session, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        ListTile(
          title: Text(session.id!),
          subtitle: Text('Concluded time: ${session.concludedTime}'),
        ),
        ButtonBar(children: [
          TextButton(
              onPressed: () async {
                context.progress("Loading summary");
                var summary = await Sessions().summariseSession(session.id!);
                context.loaderOverlay.hide();

                await Get.defaultDialog(
                    title: "Session summary",
                    content: DataTable(
                        columns: const [DataColumn(label: Text('Place ID'))],
                        rows: summary
                            .map((placeId) =>
                                DataRow(cells: [DataCell(Text(placeId))]))
                            .toList()));
              },
              child: const Text('Show agreements'))
        ]),
      ],
    ));
  }
}
