import 'package:flutter/material.dart'
    show AlertDialog, ElevatedButton, InputDecoration, ListTile, TextFormField;
import 'package:flutter/widgets.dart'
    show
        AutovalidateMode,
        Axis,
        BuildContext,
        Column,
        Form,
        FormFieldState,
        FormState,
        GlobalKey,
        Key,
        Navigator,
        SingleChildScrollView,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    show InternationalPhoneNumberInput, PhoneNumber;
import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

var log = Logger();

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
      var res = await supabaseClient.auth.signIn(phone: phone);
      if (res.error != null) {
        log.e(res.error!.message);
      } else {
        setState(() {
          currentStep++;
        });
      }
    } else if (currentStep == 1) {
      token = value;
      var res = await supabaseClient.auth.verifyOTP(phone!, token!);
      if (res.error != null) {
        log.e(res.error!.message);
      } else {
        setState(() {
          currentStep++;
        });
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var fieldKey = GlobalKey<FormFieldState>();

    Widget buildStep(String title, Widget input) => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(children: [
          ListTile(title: Text(title)),
          input,
          ElevatedButton(
              onPressed: () {
                var res = _formKey.currentState?.validate();
                log.d("res: $res");
                submitted(fieldKey.currentState?.value!);
              },
              child: const Text('Next'))
        ]));

    var steps = <Widget>[
      buildStep(
          'Phone',
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber phone) {
              log.d(phone);
            },
            validator: valid,
            key: fieldKey,
            inputDecoration: const InputDecoration(labelText: 'Phone number'),
          )),
      buildStep(
          'Login code',
          TextFormField(
              validator: valid,
              autovalidateMode: AutovalidateMode.always,
              key: fieldKey,
              decoration: const InputDecoration(
                labelText: 'Login code',
              ))),
      Column(children: [
        const ListTile(title: Text('Welcome!')),
        Text(
            "welcome!: ${supabaseClient.auth.currentSession?.user?.phone} ${supabaseClient.auth.currentSession?.accessToken}")
      ])
    ][currentStep];

    return AlertDialog(
        content: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox.square(child: steps, dimension: 400),
    ));
  }

  String? valid(String? value) {
    return value?.isEmpty == true ? 'Please enter' : null;
  }
}
