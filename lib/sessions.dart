import 'package:choose_food/main.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart' show SupabaseClient;
import 'common.dart';
import 'generated_code/openapi.models.swagger.dart' show Session;

class Sessions {
  SupabaseClient supabaseClient = Get.find();

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
