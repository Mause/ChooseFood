import 'package:get/get.dart' show Get, Inst;
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase/supabase.dart' show SupabaseClient, User;

import 'common.dart' show TypedExecuteExtension, excludeNull, nullIntKey;
import 'generated_code/openapi.models.swagger.dart'
    show $SessionExtension, Decision, Participant, Session;
import 'main.dart' show ColumnNames, TableNames;

part 'sessions.g.dart';

class Sessions {
  SupabaseClient supabaseClient = Get.find();

  Future<Participant> joinSession(Session session, User user) async {
    var par =
        Participant(id: nullIntKey, sessionId: session.id, userId: user.id);

    var res = await supabaseClient
        .from(TableNames.participant)
        .upsert(excludeNull(par.toJson()))
        .typedExecute(Participant.fromJson);

    if (res.error != null) throw res.error!;

    return res.data![0];
  }

  Future<List<String>> concludeSession(
    Session session,
  ) async {
    session = session.copyWith(concludedTime: DateTime.now().toIso8601String());

    await supabaseClient
        .from(TableNames.session)
        .update(excludeNull(session.toJson()))
        .eq(ColumnNames.session.id, session.id)
        .typedExecute(Session.fromJson);

    return summariseSession(session.id);
  }

  Future<List<String>> summariseSession(String sessionId) async {
    var participants = (await supabaseClient
            .from(TableNames.participant)
            .select("""
              ${ColumnNames.participant.userId},
              ${ColumnNames.participant.createdAt},
              ${ColumnNames.participant.id},
              ${ColumnNames.participant.sessionId},
              decision ( * )
              """)
            .eq(ColumnNames.participant.sessionId, sessionId)
            .typedExecute(ParticipantWithDecisions.fromJson))
        .data!;

    var places = participants
        .map((p) => p.decision.map((d) => d.placeReference))
        .expand((decision) => decision)
        .toSet();

    var agreements = places
        .where((place) => participants.every((participant) => participant
            .decision
            .firstWhere((element) => place == element.placeReference)
            .decision))
        .toList();

    return agreements;
  }
}

@JsonSerializable()
class ParticipantWithDecisions extends Participant {
  final List<Decision> decision;

  ParticipantWithDecisions(
      {required this.decision,
      required String createdAt,
      required int id,
      required String sessionId,
      required String userId})
      : super(
            createdAt: createdAt, id: id, sessionId: sessionId, userId: userId);

  factory ParticipantWithDecisions.fromJson(Map<String, dynamic> json) =>
      _$ParticipantWithDecisionsFromJson(json);

  @override
  toJson() => _$ParticipantWithDecisionsToJson(this);
}
