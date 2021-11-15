import 'package:flutter/material.dart'
    show AlertDialog, InputDecoration, Step, Stepper, TextFormField;
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
import 'package:jwt_decode/jwt_decode.dart' show Jwt;

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
    var keys = [
      GlobalKey<FormState>(debugLabel: 'phone-form'),
      GlobalKey<FormState>(debugLabel: 'login-code-form')
    ];

    Step buildStep(String title, Widget input, Key _formKey) {
      return Step(
          title: Text(title),
          content: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: [input])));
    }

    var steps = [
      buildStep(
          'Phone',
          InternationalPhoneNumberInput(
            key: const Key('phone'),
            onInputChanged: (PhoneNumber value) {},
            onSaved: (PhoneNumber phoneNumber) async =>
                await stepOne(phoneNumber.phoneNumber!),
            inputDecoration: const InputDecoration(labelText: 'Phone number'),
          ),
          keys[0]),
      buildStep(
          'Login code',
          TextFormField(
              key: const Key('login-code'),
              validator: valid,
              autovalidateMode: AutovalidateMode.always,
              onSaved: (String? loginCode) async => await stepTwo(loginCode!),
              decoration: const InputDecoration(
                labelText: 'Login code',
              )),
          keys[1]),
      Step(
          title: const Text('Welcome!'),
          content: Column(children: [
            Text("welcome!: ${buildAccessToken()?.phone}"),
          ]))
    ];

    return AlertDialog(
        content: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox.square(
          child: Stepper(
              currentStep: currentStep,
              steps: steps,
              onStepContinue: () {
                var _formKey = keys[currentStep];
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              }),
          dimension: 400),
    ));
  }

  User? buildAccessToken() {
    var accessToken = supabaseClient.auth.currentSession?.accessToken;
    if (accessToken == null) return null;

    var decode = Jwt.parseJwt(accessToken);

    decode['id'] = decode['sub'];
    decode['created_at'] = decode['updated_at'] = "0";

    return User.fromJson(decode);
  }

  String? valid(String? value) {
    return value?.isEmpty == true ? 'Please enter' : null;
  }
}
