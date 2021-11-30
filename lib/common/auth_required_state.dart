import '../components/login_dialog.dart' show LoginDialog;
import 'package:flutter/widgets.dart' show Navigator, StatefulWidget;
import 'package:supabase_flutter/supabase_flutter.dart'
    show SupabaseAuthRequiredState;

class AuthRequiredState<T extends StatefulWidget>
    extends SupabaseAuthRequiredState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginDialog.routeName, (route) => false);
    }
  }
}
