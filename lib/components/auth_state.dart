import 'package:choose_food/components/login_dialog.dart';
import 'package:choose_food/main.dart';
import 'package:flutter/widgets.dart' show Navigator, StatefulWidget;
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show Session, SupabaseAuthState;

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginDialog.routeName, (route) => false);
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MyHomePage.routeName, (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    Get.snackbar('Error occurred', message);
  }
}
