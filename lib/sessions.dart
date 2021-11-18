import 'package:choose_food/main.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase/supabase.dart' show SupabaseClient, User;
import 'common.dart';
import 'generated_code/openapi.models.swagger.dart'
    show Decision, Participant, Session;

part 'sessions.g.dart';

class Sessions {
  SupabaseClient supabaseClient = Get.find();

  Future<Participant> joinSession(Session session, User user) async {
    var par = Participant(sessionId: session.id!, userId: user.id);

    return Participant.fromJson((await supabaseClient
            .from(TableNames.participant)
            .upsert(excludeNull(par.toJson()))
            .execute())
        .data);
  }

  Future<void> concludeSession(
    String sessionId,
  ) async {
    await supabaseClient
        .from(TableNames.session)
        .update(excludeNull(Session(
                id: sessionId, concludedTime: DateTime.now().toIso8601String())
            .toJson()))
        .execute();
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
