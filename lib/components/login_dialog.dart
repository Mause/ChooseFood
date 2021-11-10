import 'package:flutter/material.dart'
    show AlertDialog, InputDecoration, Step, Stepper, TextFormField;
import 'package:flutter/widgets.dart'
    show
        Axis,
        BuildContext,
        Key,
        Navigator,
        SingleChildScrollView,
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

  @override
  Widget build(BuildContext context) {
    var value = ''.reactive;

    Step step(String title, String label) => Step(
        title: Text(title),
        content: TextFormField(
          decoration: InputDecoration(
            labelText: label,
          ),
          onChanged: (v) => value.value = v,
        ));

    var stepper = Stepper(
        currentStep: currentStep,
        steps: [
          step('Phone', 'Phone number'),
          step('Login code', 'Login code'),
          const Step(title: Text('Welcome!'), content: Text("welcome!")),
        ],
        onStepContinue: () async {
          if (currentStep == 0) {
            phone = value.value;
            await supabaseClient.auth.signIn(phone: phone);
            setState(() {
              currentStep++;
            });
          } else if (currentStep == 1) {
            token = value.value;
            await supabaseClient.auth.verifyOTP(phone!, token!);
            setState(() {
              currentStep++;
            });
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        });

    return AlertDialog(
        content: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: stepper,
    ));
  }
}
