import 'package:dopamine_defense_1/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
      child: Text(
        "로그아웃",
      ),
      onPressed: () {
        context.read<AuthProvider>().signout();
      },
    ));
  }
}
