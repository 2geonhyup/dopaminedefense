import 'package:dopamine_defense_1/widgets/name_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/custom_error.dart';
import '../providers/sign_in/sign_in_provider.dart';
import '../providers/sign_in/sign_in_state.dart';
import '../utils/error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _submit() async {
    try {
      await context.read<SignInProvider>().signIn();
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  void _appleSubmit() async {
    try {
      await context.read<SignInProvider>().appeSignIn();
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signInState = context.watch<SignInState>();
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: pointColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "도파민 디펜스",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: InkWell(
                        onTap:
                            signInState.signInStatus == SignInStatus.submitting
                                ? null
                                : _submit,
                        child: Container(
                            width: 300,
                            height: 45,
                            child:
                                Image.asset('assets/images/kakao_login.png'))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: InkWell(
                        onTap:
                            signInState.signInStatus == SignInStatus.submitting
                                ? null
                                : _appleSubmit,
                        child: Container(
                            width: 300,
                            height: 48,
                            child: Image.asset(
                                'assets/images/appleid_button.png'))),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
