import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_state.dart';

import 'loading_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const routeName = '/splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    print("13");

    if (authState.authStatus == AuthStatus.authenticated) {
      // build 내에서 네비게이션을 하기 때문에, safe한 동작을 위해 addpostframecallback을 사용
      // 이렇게 하면, 현재 build 작업이 끝난 후에 해당 동작을 실행할 수 있음
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, LoadingPage.routeName);
      });
    } else if (authState.authStatus == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, LoginPage.routeName);
      });
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// WidgetsBinding.instance.addPostFrameCallback((_) {
// Navigator.pushNamed(context, LoginPage.routeName);
// });
