import 'package:choose_food/main.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart' show SupabaseClient, User;
import 'package:json_annotation/json_annotation.dart';
import 'common.dart';
import 'generated_code/openapi.models.swagger.dart'
    show Decision, Participant, Session;

part 'sessions.g.dart';

class Sessions {
  SupabaseClient supabaseClient = Get.find();

  Future<Participant> joinSession(Session session, User user) async {
    var par = Participant(sessionId: session.id!, userId: user.id);

    var res = await supabaseClient
        .from(TableNames.participant)
        .upsert(excludeNull(par.toJson()))
        .typedExecute(Participant.fromJson);

    if (res.error != null) throw res.error!;

    return res.datam[0];
  }

  Future<List<String>> concludeSession(
    String sessionId,
  ) async {
    await supabaseClient
        .from(TableNames.session)
        .update(excludeNull(Session(
                id: sessionId, concludedTime: DateTime.now().toIso8601String())
            .toJson()))
        .typedExecute(Session.fromJson);

    return summariseSession(sessionId);
  }

  Future<List<String>> summariseSession(String sessionId) async {
    var participants = (await supabaseClient
            .from(TableNames.participant)
            .select("userId, decision ( * )")
            .eq(ColumnNames.participant.sessionId, sessionId)
            .typedExecute(ParticipantWithDecisions.fromJson))
        .datam;

    var places = participants
        .map((p) => p.decision.map((d) => d.placeReference))
        .expand((decision) => decision)
        .map((pid) => pid!)
        .toSet();

    var agreements = places
        .where((place) => participants.every((participant) => participant
            .decision
            .firstWhere((element) => place == element.placeReference)
            .decision!))
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
