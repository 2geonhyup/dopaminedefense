import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth/auth_state.dart';
import '../providers/profile/profile_provider.dart';
import '../providers/profile/profile_state.dart';
import '../utils/error_dialog.dart';
import 'home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  static const routeName = '/loading';

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final ProfileProvider profileProv;
  late final void Function() _removeListener;
  void _getProfile() {
    final String uid = context.read<AuthState>().user!.email!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile(uid: uid);
    });
  }

  @override
  void initState() {
    profileProv = context.read<ProfileProvider>();
    _removeListener = profileProv.addListener(errorDialogListener,
        fireImmediately:
            false); // fire immediately를 false로 설정해서 에러 시 빌드 후 에러창 뜨게 함
    super.initState();
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void errorDialogListener(ProfileState state) {
    if (state.profileStatus == ProfileStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final profileState = context.watch<ProfileState>();

    print("loading");
    if (authState.user != null) {
      _getProfile();
    }
    if (authState.authStatus == AuthStatus.authenticated &&
        profileState.profileStatus == ProfileStatus.loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
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
