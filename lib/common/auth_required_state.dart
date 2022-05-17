import 'package:flutter/widgets.dart' show StatefulWidget;
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseAuthRequiredState;

import '../components/login_dialog.dart' show LoginDialog;

class AuthRequiredState<T extends StatefulWidget>
    extends SupabaseAuthRequiredState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Get.offNamedUntil(LoginDialog.routeName, (route) => false);
    }
  }
}
