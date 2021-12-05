import 'package:flutter/material.dart' show Scaffold, CircularProgressIndicator;
import 'package:flutter/widgets.dart'
    show BuildContext, Center, Key, StatefulWidget, Widget;

import 'auth_state.dart' show AuthState;

class SplashPage extends StatefulWidget {
  static var routeName = '/splash';

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends AuthState<SplashPage> {
  @override
  void initState() {
    recoverSupabaseSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
