import 'package:flutter/material.dart'
    show AlertDialog, Card, InputDecoration, ListTile, TextFormField;
import 'package:flutter/widgets.dart'
    show
        Axis,
        BuildContext,
        Column,
        Key,
        Navigator,
        SingleChildScrollView,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  SupabaseClient supabaseClient = Get.find();
  String? phone;
  String? token;

  var currentStep = 0;

  void submitted(String value) async {
    if (currentStep == 0) {
      phone = value;
      await supabaseClient.auth.signIn(phone: phone);
      setState(() {
        currentStep++;
      });
    } else if (currentStep == 1) {
      token = value;
      await supabaseClient.auth.verifyOTP(phone!, token!);
      setState(() {
        currentStep++;
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Card step(String title, String label) => Card(
            child: Column(children: [
          ListTile(title: Text(title)),
          TextFormField(
              decoration: InputDecoration(
                labelText: label,
              ),
              onFieldSubmitted: submitted)
        ]));

    var currentstepper = <Widget>[
      step('Phone', 'Phone number'),
      step('Login code', 'Login code'),
      Card(
          child: Column(children: const [
        ListTile(title: Text('Welcome!')),
        Text("welcome!")
      ])),
    ][currentStep];

    return AlertDialog(
        content: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox.shrink(child: currentstepper),
    ));
  }
}
