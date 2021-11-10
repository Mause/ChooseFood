import 'package:flutter/material.dart'
    show
        AlertDialog,
        InputDecoration,
        Step,
        Stepper,
        TextFormField,
        StepperType;
import 'package:flutter/widgets.dart'
    show Key, StatefulWidget, State, Widget, BuildContext, Text;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var value = ''.reactive;

    var stepper = Stepper(
        steps: [
          Step(
              title: const Text('Phone'),
              content: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                ),
                onChanged: value.call,
              )),
          Step(
              title: const Text('Login code'),
              content: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Login code',
                ),
                onChanged: value.call,
              ))
        ],
        type: StepperType.vertical,
        onStepContinue: () async {
          if (phone == null) {
            phone = value.value;
            await supabaseClient.auth.signIn(phone: phone);
          } else if (token == null) {
            token = value.value;
            await supabaseClient.auth.verifyOTP(phone!, token!);
          }
        });

    return AlertDialog(content: stepper);
  }
}
