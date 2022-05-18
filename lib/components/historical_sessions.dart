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
        Column,
        Expanded,
        Key,
        ListView,
        StatelessWidget,
        Text,
        Widget;
import 'package:get/get.dart'
    show
        ExtensionDialog,
        ExtensionSnackbar,
        Get,
        GetView,
        GetxController,
        Inst,
        RxStatus,
        StateExt,
        StateMixin;
import 'package:loader_overlay/loader_overlay.dart'
    show OverlayControllerWidgetExtension;
import 'package:supabase/supabase.dart' show SupabaseClient;

import '../generated_code/openapi.models.swagger.dart' show Session;
import '../sessions.dart';

class HistoricalSessionsController extends GetxController
    with StateMixin<List<Session>> {
  final SupabaseClient supabaseClient = Get.find();

  List<Session>? sessions;

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  Future<void> loadSessions() async {
    change([], status: RxStatus.loading());

    var sessions = await supabaseClient
        .from(TableNames.session)
        .select()
        .not(ColumnNames.session.concludedTime, "is", null)
        .typedExecute(Session.fromJson);
    if (sessions.error != null) {
      Get.snackbar(sessions.error!.message, sessions.error!.details.toString(),
          instantInit: false);
      return;
    }

    change(sessions.datam, status: RxStatus.success());

    Get.snackbar(
        'Sessions loaded', 'Loaded ${this.sessions?.length ?? -1}\n$sessions',
        instantInit: false);
  }
}

class HistoricalSessions extends GetView<HistoricalSessionsController> {
  static const routeName = "/historical";

  const HistoricalSessions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(selectedIndex: 2, children: [
      Expanded(
        child: controller.obx(
            (sessions) => ListView(
                children:
                    sessions!.map((session) => SessionCard(session)).toList(),
                primary: true),
            onLoading:
                const LabelledProgressIndicator("Loading historical sessions")),
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
