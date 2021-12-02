import 'dart:async';

import 'package:choose_food/main.dart' show MyHomePage;
import 'package:flutter/material.dart'
    show
        InputDecoration,
        ListTile,
        Scaffold,
        Step,
        Stepper,
        TextFormField,
        TextStyle,
        Theme;
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
        ListView,
        SingleChildScrollView,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    show InternationalPhoneNumberInput, PhoneNumber;
import 'package:loader_overlay/loader_overlay.dart'
    show OverlayControllerWidgetExtension;
import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

import '../common.dart' show getAccessToken, LabelledProgressIndicatorExtension;

var log = Logger();

class LoginDialog extends StatefulWidget {
  static var routeName = "/login";

  const LoginDialog({Key? key}) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  SupabaseClient supabaseClient = Get.find();
  String? phone;
  String? token;
  String? error;

  var currentStep = 0;

  Future<void> stepTwo(String value) async {
    token = value;
    var res = await supabaseClient.auth.verifyOTP(phone!, token!);
    if (res.error != null) {
      error = res.error!.message;
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
      error = res.error!.message;
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
          subtitle: error == null
              ? null
              : Text(error!,
                  style: TextStyle(color: Theme.of(context).errorColor)),
          content: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: [input])));
    }

    var steps = [
      buildStep(
          'Phone',
          ListView(children: [
            const ListTile(
                title: Text(
                    'To login, please enter your mobile phone number below')),
            InternationalPhoneNumberInput(
              key: const Key('phone'),
              onInputChanged: (PhoneNumber value) {},
              onSaved: (PhoneNumber phoneNumber) async =>
                  await stepOne(phoneNumber.phoneNumber!),
              inputDecoration: const InputDecoration(labelText: 'Phone number'),
            )
          ]),
          keys[0]),
      buildStep(
          'Login code',
          ListView(
            children: [
              const ListTile(
                  title: Text(
                      'You have been sent a text message with a 6 digit code, please enter it below')),
              TextFormField(
                  key: const Key('login-code'),
                  validator: valid,
                  autovalidateMode: AutovalidateMode.always,
                  onSaved: (String? loginCode) async =>
                      await stepTwo(loginCode!),
                  decoration: const InputDecoration(
                    labelText: 'Login code',
                  ))
            ],
          ),
          keys[1]),
      Step(
          title: Text("Welcome ${getAccessToken()?.phone}"),
          content: Column(
              children: const [Text('You are now logged in. Eat well 💜')]))
    ];

    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox.square(
          child: Stepper(
              currentStep: currentStep,
              steps: steps,
              onStepContinue: () async {
                if (currentStep == 2) {
                  Get.toNamed(MyHomePage.routeName);
                } else {
                  context.progress("Loading");
                  var _formKey = keys[currentStep];
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                  context.loaderOverlay.hide();
                }
              }),
          dimension: 400),
    ));
  }

  String? valid(String? value) {
    return value?.isEmpty == true ? 'Please enter' : null;
  }
}
