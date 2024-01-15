// import 'package:dopamine_defense_1/constants.dart';
// import 'package:dopamine_defense_1/main.dart';
// import 'package:dopamine_defense_1/pages/onboarding_page.dart';
// import 'package:dopamine_defense_1/pages/setting_page.dart';
// import 'package:dopamine_defense_1/pages/splash_page.dart';
// import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
// import 'package:dopamine_defense_1/providers/read/read_state.dart';
// import 'package:dopamine_defense_1/widgets/name_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/auth/auth_provider.dart';
// import '../providers/profile/profile_state.dart';
// import '../utils/error_dialog.dart';
// import 'course_page.dart';
// import 'home_page.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);
//   static const String routeName = '/main';
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   late final ProfileProvider profileProv;
//   late final void Function() _removeListener;
//   int _selectedIndex = 0;
//   static const List<Widget> _widgetOptions = <Widget>[
//     HomePage(),
//     CoursePage(),
//     SettingPage()
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     profileProv = context.read<ProfileProvider>();
//     _removeListener = profileProv.addListener(errorDialogListener,
//         fireImmediately:
//             false); // fire immediately를 false로 설정해서 에러 시 빌드 후 에러창 뜨게 함
//     _getProfile();
//   }
//
//   void _getProfile() {
//     final String uid = supabaseClient.auth.currentUser!.email!;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProfileProvider>().getProfile(uid: uid);
//     });
//     print("메인에서 getprofile함!");
//   }
//
//   void errorDialogListener(ProfileState state) {
//     if (state.profileStatus == ProfileStatus.error) {
//       errorDialog(context, state.error);
//     }
//   }
//
//   @override
//   void dispose() {
//     _removeListener();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final profileState = context.watch<ProfileState>();
//
//     if (profileState.profileStatus == ProfileStatus.loading) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else if (profileState.profileStatus == ProfileStatus.error) {
//       return Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '네트워크 오류가 발생했습니다. 앱을 다시 켜주세요.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20.0,
//                 color: Colors.red,
//               ),
//             ),
//             TextButton(
//               child: Text(
//                 "로그아웃",
//               ),
//               onPressed: () {
//                 context.read<AuthProvider>().signout();
//               },
//             )
//           ],
//         ),
//       );
//     }
//
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//           bottomNavigationBar: BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: '홈',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.school),
//                 label: '코스',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.settings),
//                 label: '설정',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: pointColor,
//             onTap: _onItemTapped,
//           ),
//           // appBar: nameAppBar(),
//           body: _widgetOptions.elementAt(_selectedIndex)),
//     );
//   }
// }
//
// bool isProfileCompleted({required ProfileState profileState}) {
//   return profileState.user.grade != '' &&
//       profileState.user.name != '' &&
//       profileState.user.level != '';
// }
