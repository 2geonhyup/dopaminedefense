import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/pages/feedback_page.dart';
import 'package:dopamine_defense_1/pages/home_page.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:dopamine_defense_1/pages/main_page.dart';
import 'package:dopamine_defense_1/pages/ranking_page.dart';
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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/store.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;
import 'store_config.dart';
import 'dart:io';

void main() async {
  await dotenv.load(fileName: ".env");
  await sp.Supabase.initialize(
    authOptions:
        sp.FlutterAuthClientOptions(authFlowType: sp.AuthFlowType.pkce),
    url: 'https://ebneycbqwtuhyxggghia.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: dotenv.env['APPLE_API_KEY']!,
    );
  } else if (Platform.isAndroid) {}

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("6fa0c0f8-9a52-4cc0-80db-7cff7d735cec");
  OneSignal.Notifications.requestPermission(true);
  WidgetsFlutterBinding.ensureInitialized();

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
          HomePage.routeName: (context) => const HomePage(),
          LoadingPage.routeName: (context) => const LoadingPage(),
        },
      ),
    );
  }
}

// Future<void> _configureSDK() async {
//   // Enable debug logs before calling `configure`.
//   await Purchases.setLogLevel(LogLevel.debug);
//   PurchasesConfiguration configuration;
//   configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
//     ..appUserID = null
//     ..observerMode = false;
//
//   await Purchases.configure(configuration);
// }
