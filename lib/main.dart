import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/pages/home_page.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:dopamine_defense_1/pages/main_page.dart';
import 'package:dopamine_defense_1/pages/splash_page.dart';
import 'package:dopamine_defense_1/pages/summary_page_record.dart';
import 'package:dopamine_defense_1/providers/auth/auth_provider.dart';
import 'package:dopamine_defense_1/providers/auth/auth_state.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/sign_in/sign_in_provider.dart';
import 'package:dopamine_defense_1/providers/sign_in/sign_in_state.dart';
import 'package:dopamine_defense_1/providers/read/read_provider.dart';
import 'package:dopamine_defense_1/providers/read/read_state.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:dopamine_defense_1/repositories/auth_repository.dart';
import 'package:dopamine_defense_1/repositories/defense_repository.dart';
import 'package:dopamine_defense_1/repositories/feedback_repository.dart';
import 'package:dopamine_defense_1/repositories/profile_repository.dart';
import 'package:dopamine_defense_1/repositories/read_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

void main() async {
  await sp.Supabase.initialize(
    authOptions:
        sp.FlutterAuthClientOptions(authFlowType: sp.AuthFlowType.pkce),
    url: 'https://ebneycbqwtuhyxggghia.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVibmV5Y2Jxd3R1aHl4Z2dnaGlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODkxNDA2NjgsImV4cCI6MjAwNDcxNjY2OH0.PT_lFBBhwbxI_fRl6HRu8BepdfBqI9j_rgShnJWYG8c',
  );

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
}

final supabaseClient = sp.Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
            create: (context) =>
                AuthRepository(supabaseClient: supabaseClient)),
        Provider<ProfileRepository>(
            create: (context) =>
                ProfileRepository(supabaseClient: supabaseClient)),
        Provider<DefenseRepository>(
            create: (context) =>
                DefenseRepository(supabaseClient: supabaseClient)),
        Provider<ReadRepository>(
            create: (context) =>
                ReadRepository(supabaseClient: supabaseClient)),
        Provider<FeedbackRepository>(
            create: (context) =>
                FeedbackRepository(supabaseClient: supabaseClient)),
        StreamProvider<sp.AuthState?>(
            create: (context) => context.read<AuthRepository>().authState,
            initialData: null),
        StateNotifierProvider<AuthProvider, AuthState>(
          create: (context) => AuthProvider(),
        ),
        StateNotifierProvider<SignInProvider, SignInState>(
          create: (context) => SignInProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context) => ProfileProvider(),
        ),
        StateNotifierProvider<ReadListProvider, ReadListState>(
          create: (context) => ReadListProvider(),
        ),
        StateNotifierProvider<TodayProvider, TodayState>(
          create: (context) => TodayProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Pretendard",
          colorScheme: ColorScheme.light(
            primary: pointColor, // 기본 색상
          ),
        ),
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName: (context) => const SplashPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          MainPage.routeName: (context) => const MainPage(),
          HomePage.routeName: (context) => const HomePage(),
          LoadingPage.routeName: (context) => const LoadingPage(),
        },
      ),
    );
  }
}
