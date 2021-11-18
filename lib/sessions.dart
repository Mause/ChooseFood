import 'package:choose_food/main.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart' show SupabaseClient, User;
import 'common.dart';
import 'generated_code/openapi.models.swagger.dart' show Participant, Session;

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

  Future<List<String?>> concludeSession(
    String sessionId,
  ) async {
    await supabaseClient
        .from(TableNames.session)
        .update(excludeNull(Session(
                id: sessionId, concludedTime: DateTime.now().toIso8601String())
            .toJson()))
        .execute();

    var participants = (await execute<ParticipantWithDecisions>(
            supabaseClient
                .from(TableNames.participant)
                .select("userId, decision ( * )")
                .eq(ColumnNames.participant.sessionId, sessionId),
            ParticipantWithDecisions.fromJson))
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
