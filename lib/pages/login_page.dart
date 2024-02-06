import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../amplitude_config.dart';
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
      if (mounted) {
        errorDialog(context, e);
      }
    }
  }

  void _appleSubmit() async {
    try {
      await context.read<SignInProvider>().appeSignIn();
    } on CustomError catch (e) {
      if (mounted) {
        errorDialog(context, e);
      }
    }
  }

  @override
  void initState() {
    //앰플리튜드 로그인 화면
    AmplitudeConfig.amplitude.logEvent("login-page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signInState = context.watch<SignInState>();
    return PopScope(
        canPop: false,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/paper-texture.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          Image.asset(
                            'assets/images/login-title.png',
                            width: 204.5,
                            height: 254,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: InkWell(
                          onTap: signInState.signInStatus ==
                                  SignInStatus.submitting
                              ? null
                              : _appleSubmit,
                          child: SizedBox(
                              width: 342,
                              height: 52,
                              child: Image.asset(
                                  'assets/images/apple-login.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: InkWell(
                          onTap: signInState.signInStatus ==
                                  SignInStatus.submitting
                              ? null
                              : _submit,
                          child: SizedBox(
                              width: 342,
                              height: 52,
                              child: Image.asset(
                                  'assets/images/kakao-login.png'))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
