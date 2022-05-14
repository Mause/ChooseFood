import 'dart:async' show Future;

import 'package:choose_food/common.dart'
    show BasePage, MyPostgrestResponse, TypedExecuteExtension, getAccessToken;
import '../common/auth_required_state.dart' show AuthRequiredState;
import '../main.dart' show ColumnNames, RpcNames, TableNames;
import 'package:choose_food/main.dart' show ColumnNames, RpcNames, TableNames;
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
        RefreshIndicator,
        TextButton,
        showDialog;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/widgets.dart'
    show
        Axis,
        BuildContext,
        Column,
        Expanded,
        Key,
        ListView,
        SingleChildScrollView,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        Widget;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart' show Get, Inst, ExtensionSnackbar;
import 'package:google_maps_webservice/places.dart' show GoogleMapsPlaces;
import 'package:intl_phone_number_input/intl_phone_number_input_test.dart';
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, $checkedCreate;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:logger/logger.dart' show Logger;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase/supabase.dart' show SupabaseClient;

import '../common.dart' show LabelledProgressIndicatorExtension;
import '../generated_code/openapi.models.swagger.dart'
    show Decision, Session, Point, Users;
import '../sessions.dart' show Sessions;

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

class FriendsSessionsState extends AuthRequiredState<FriendsSessions> {
  SupabaseClient supabaseClient = Get.find();

  List<Widget> sessions = [];

  List<Users>? yourFriends;

  List<Session>? friendsSessions;

  num? numberOfContacts;

  @override
  void onAuthenticated(session) {
    reload();
  }

  Future<void> reload() async {
    context.progress("Loading...");
    await Future.wait([initSessions(), loadFriends()]).whenComplete(() {
      context.loaderOverlay.hide();
    });
  }

  Future<void> loadFriends() async {
    context.progress("Loading friends");
    if (await FlutterContacts.requestPermission(readonly: true)) {
      FlutterContacts.config.includeNonVisibleOnAndroid = true;

      log.i("Loading friends");
      var possibles = await FlutterContacts.getContacts(
          withPhoto: true, withProperties: true);
      log.i("Loaded contacts: ${possibles.length}");
      setState(() {
        numberOfContacts = possibles.length;
      });

      var numbers = possibles
          .expand((element) =>
              element.phones.map((e) => NamePhone(element.name, e)))
          .toList();
      log.i("Numbers to parse: ${numbers.length}");

      List<NamePhone> contacts =
          (await Future.wait(numbers.map(formatNumbers).toList()))
              .where((NamePhone? element) => element != null)
              .map((e) => e!)
              .toList();
      log.i("Parsed ${contacts.length} contacts");

      var yourFriends = (await supabaseClient.rpc(RpcNames.getMatchingUsers,
              params: {
            "phones": contacts.map((e) => e.phone.number).toList()
          }).typedExecute(Users.fromJson))
          .datam;
      setState(() {
        this.yourFriends = yourFriends;
      });

      var friendsSessions = (await supabaseClient
              .from(TableNames.participant)
              .select()
              .in_("userId", yourFriends.map((e) => e.id).toList())
              .typedExecute(Session.fromJson))
          .datam;
      setState(() {
        this.friendsSessions = friendsSessions;
      });
    }
  }

  Future<NamePhone?> formatNumbers(NamePhone e) async {
    PhoneNumberTest phoneNumberTest;
    try {
      phoneNumberTest = await PhoneNumberTest.getRegionInfoFromPhoneNumber(
          e.phone.normalizedNumber.isEmpty
              ? e.phone.number
              : e.phone.normalizedNumber,
          'AU');
    } on PlatformException {
      log.e('failed to parse "${e.phone}" for ${e.name}');
      return null;
    }

    return NamePhone(e.name, Phone((phoneNumberTest).phoneNumber!));
  }

  Future<void> initSessions() async {
    MyPostgrestResponse<SessionWithDecisions> sessions;

    context.loaderOverlay.show();

    try {
      sessions = await supabaseClient
          .from(TableNames.session)
          .select("""
              id,
              decision(
                decision,
                placeReference,
                participantId
              )
              """)
          .is_(ColumnNames.session.concludedTime, null)
          .typedExecute(SessionWithDecisions.fromJson);
    } catch (e, s) {
      return await handleError(e, s);
    }

    if (sessions.error != null) {
      return await handleError(sessions.error, null);
    }

    setState(() {
      this.sessions = sessions.datam
          .map((e) => SessionCard(sessionWithDecisions: e))
          .toList();
    });
    context.loaderOverlay.hide();
  }

  Future<void> handleError(dynamic error, StackTrace? stackTrace) async {
    log.e("Failed to load sessions", error, stackTrace);
    await Sentry.captureException(error, hint: "Failed to load sessions");

    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    var openSessions =
        friendsSessions?.where((e) => e.concludedTime == null).length;

    return BasePage(selectedIndex: 1, children: [
      ListTile(title: Text('You have ${numberOfContacts ?? "?"} contacts')),
      ListTile(title: Text('You have ${yourFriends?.length ?? "?"} friends')),
      ListTile(
          title: Text(
              'Your friends have ${friendsSessions?.length ?? "?"} sessions')),
      ListTile(title: Text('${openSessions ?? "?"} of which are open')),
      Expanded(
          child: RefreshIndicator(
              onRefresh: reload,
              child: ListView(children: sessions, primary: true)))
    ]);
  }
}

@JsonSerializable()
class SessionWithDecisions extends Session {
  List<Decision> decision;

  SessionWithDecisions(
      {required this.decision,
      String? id,
      String? concludedTime,
      String? createdAt,
      Point? point})
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
                onPressed: () async {
                  var accessToken = getAccessToken();
                  if (accessToken == null) {
                    Get.snackbar(
                        "Cannot join session", "You are not logged in");
                  } else {
                    await Sessions()
                        .joinSession(sessionWithDecisions, accessToken);
                  }
                },
                child: const Text('Join')),
            TextButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => DecisionDialog(
                          sessionWithDecisions: sessionWithDecisions));
                },
                child: const Text('View details'))
          ])
        ],
      ),
    );
  }
}

class DecisionDialog extends StatefulWidget {
  final SessionWithDecisions sessionWithDecisions;

  const DecisionDialog({Key? key, required this.sessionWithDecisions})
      : super(key: key);

  @override
  State<DecisionDialog> createState() => _DecisionDialogState();
}

class _DecisionDialogState extends State<DecisionDialog> {
  var placeNames = {};
  var userNames = {};

  @override
  void initState() {
    super.initState();

    context.progress("Loading");
    loadData().then((void t) {
      context.loaderOverlay.hide();
    }, onError: (error) {
      log.e(error);
    });
  }

  Future<void> loadData() async {
    SupabaseClient supabaseClient = Get.find();
    GoogleMapsPlaces places = Get.find();

    log.d("Loading place names");
    placeNames = (await Future.wait(widget.sessionWithDecisions.decision
            .map((e) => places.getDetailsByPlaceId(e.placeReference!))))
        .toMap((e) => e.result.reference!, (e) => e.result.name);

    log.d("Loading user names");
    userNames = (await supabaseClient
            .from(TableNames.users)
            .select("name")
            .in_(
                "id",
                widget.sessionWithDecisions.decision
                    .map((e) => e.participantId)
                    .toList())
            .typedExecute(Users.fromJson))
        .datam
        .toIndexMap((e) => e.id);
    log.d("Loaded: userNames: $userNames, placeNames: $placeNames");
  }

  @override
  Widget build(context) {
    log.d("rendering");
    return AlertDialog(
        title: Text(widget.sessionWithDecisions.id!),
        content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: const [
                  DataColumn(label: Text("Place Name")),
                  DataColumn(label: Text("Decision")),
                  DataColumn(label: Text("Participant Name"))
                ],
                rows: widget.sessionWithDecisions.decision
                    .map((e) => DataRow(cells: [
                          DataCell(Text(
                              placeNames[e.placeReference!] ?? 'Loading...')),
                          DataCell(Text(e.decision == true ? 'Yes' : 'No')),
                          DataCell(
                              Text(userNames[e.participantId!] ?? 'Loading...'))
                        ]))
                    .toList())));
  }
}

extension MapMap<T> on Iterable<T> {
  Map<K, T> toIndexMap<K>(K Function(T e) getKey) {
    return toMap<K, T>(getKey, (e) => e);
  }

  Map<K, V> toMap<K, V>(K Function(T e) getKey, V Function(T e) getValue) {
    Map<K, V> result = {};
    for (var res in this) {
      result[getKey(res)] = getValue(res);
    }
    return result;
  }
}

class NamePhone {
  Name name;
  Phone phone;

  NamePhone(this.name, this.phone);
}
