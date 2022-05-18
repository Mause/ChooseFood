import 'package:choose_food/components/login_dialog.dart' show LoginDialog;
import 'package:choose_food/main.dart' show MyHomePage;
import 'package:flutter/widgets.dart' show StatefulWidget;
import 'package:get/get.dart' show ExtensionSnackbar, Get, GetNavigation;
import 'package:supabase_flutter/supabase_flutter.dart'
    show Session, SupabaseAuthState;

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Get.offNamedUntil(LoginDialog.routeName, (route) => false);
    }
  }

  @override
  Future<void> onAuthenticated(Session session) async {
    if (mounted) {
      await Get.offNamedUntil(MyHomePage.routeName, (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    Get.snackbar('Error occurred', message);
  }
}
