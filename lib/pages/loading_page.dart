import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/pages/time_select_page.dart';
import 'package:flutter/material.dart';
import 'package:dopamine_defense_1/main.dart';
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

  @override
  void initState() {
    super.initState();
    profileProv = context.read<ProfileProvider>();
    _removeListener = profileProv.addListener(errorDialogListener,
        fireImmediately:
            false); // fire immediately를 false로 설정해서 에러 시 빌드 후 에러창 뜨게 함
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<AuthState>().user!.email!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile(uid: uid);
    });

    print("로딩에서 getprofile함!");
  }

  void errorDialogListener(ProfileState state) {
    if (state.profileStatus == ProfileStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileState>();

    if (profileState.profileStatus == ProfileStatus.loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
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
