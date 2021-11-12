import 'package:flutter/material.dart'
    show
        AlertDialog,
        ButtonBar,
        ElevatedButton,
        InputDecoration,
        ListTile,
        TextFormField;
import 'package:flutter/widgets.dart'
    show
        AutovalidateMode,
        Axis,
        BuildContext,
        Column,
        Form,
        FormState,
        GlobalKey,
        Key,
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

  Future<void> stepTwo(String value) async {
    token = value;
    var res = await supabaseClient.auth.verifyOTP(phone!, token!);
    if (res.error != null) {
      log.e(res.error!.message);
    } else {
      forwardStep();
    }
  }

  void forwardStep() {
    setState(() {
      currentStep++;
    });
  }

  Future<void> stepOne(String value) async {
    phone = value;
    var res = await supabaseClient.auth.signIn(phone: phone);
    if (res.error != null) {
      log.e(res.error!.message);
    } else {
      forwardStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Widget buildStep(String title, Widget input) => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(children: [
          ListTile(title: Text(title)),
          input,
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              child: const Text('Next'))
        ]));

    var steps = <Widget>[
      buildStep(
          'Phone',
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber value) {},
            onSaved: (PhoneNumber phoneNumber) async =>
                await stepOne(phoneNumber.phoneNumber!),
            inputDecoration: const InputDecoration(labelText: 'Phone number'),
          )),
      buildStep(
          'Login code',
          TextFormField(
              validator: valid,
              autovalidateMode: AutovalidateMode.always,
              onSaved: (String? loginCode) async => await stepTwo(loginCode!),
              decoration: const InputDecoration(
                labelText: 'Login code',
              ))),
      Column(children: [
        const ListTile(title: Text('Welcome!')),
        Text(
            "welcome!: ${supabaseClient.auth.currentSession?.user?.phone} ${supabaseClient.auth.currentSession?.accessToken}"),
        ButtonBar(
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Ok"))
          ],
        )
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
