import 'package:choose_food/main.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart' show SupabaseClient, User;

import 'common.dart' show execute;
import 'generated_code/openapi.models.swagger.dart'
    show Participant, Session, Users;

class Sessions {
  SupabaseClient supabaseClient = Get.find();
  User? user = Get.find();

  Future<Participant> joinSession(Session session) async {
    var par = Participant(sessionId: session.id!, userId: user!.id);

    return Participant.fromJson((await supabaseClient
            .from(TableNames.participant)
            .upsert(par.toJson())
            .execute())
        .data);
  }

  Future<Users?> getUser() async {
    var uid = supabaseClient.auth.currentSession?.user?.id;
    if (uid == null) return null;

    return (await execute<Users>(
            supabaseClient.from(TableNames.users).select().eq("id", uid),
            Users.fromJson))
        .datam[0];
  }
}
