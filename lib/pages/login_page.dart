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

  @override
  Widget build(BuildContext context) {
    final signInState = context.watch<SignInState>();
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/images/splash_icon.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "DOPAMINE",
                    style: TextStyle(
                        fontSize: 50,
                        color: pointColor,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "DEFENSE",
                    style: TextStyle(
                        fontSize: 59,
                        color: pointColor,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Container(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        signInState.signInStatus == SignInStatus.submitting
                            ? null
                            : _submit,
                    child: const Text('Kakao login'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
