import 'package:amplitude_flutter/amplitude.dart';
import 'package:dopamine_defense_1/amplitude_config.dart';
import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/pages/feedback_page.dart';
import 'package:dopamine_defense_1/pages/home_page.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:dopamine_defense_1/pages/ranking_page.dart';
import 'package:dopamine_defense_1/pages/score_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/pages/time_select_page.dart';
import 'package:dopamine_defense_1/providers/auth/auth_provider.dart';
import 'package:dopamine_defense_1/providers/auth/auth_state.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/sign_in/sign_in_provider.dart';
import 'package:dopamine_defense_1/providers/sign_in/sign_in_state.dart';
import 'package:dopamine_defense_1/providers/read/read_list_provider.dart';
import 'package:dopamine_defense_1/providers/read/read_list_state.dart';
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
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/store.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;
import 'store_config.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  AmplitudeConfig().init();

  await dotenv.load(fileName: ".env");
  await sp.Supabase.initialize(
    url: 'https://ebneycbqwtuhyxggghia.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const sp.FlutterAuthClientOptions(
      authFlowType: sp.AuthFlowType.implicit,
    ),
  );
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: dotenv.env['APPLE_API_KEY']!,
    );
  } else if (Platform.isAndroid) {}

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("6fa0c0f8-9a52-4cc0-80db-7cff7d735cec");
  //TODO: 정확히 언제 (어떤 기준으로) 알림 허용 메시지가 뜨는지 알아보기
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  // Uri? uri = await AppLinks().getInitialAppLink();
  // if (uri != null) {
  //   print('main${uri.queryParameters['code']}');
  // }
}

final supabaseClient = sp.Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        StateNotifierProvider<TodayProvider, TodayState>(
          create: (context) => TodayProvider(),
        ),
        StateNotifierProvider<ReadListProvider, ReadListState>(
          create: (context) => ReadListProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Pretendard",
          colorScheme: const ColorScheme.light(
            primary: orangePoint, // 기본 색상
          ),
        ),
        initialRoute: '/loading',
        routes: {
          LoginPage.routeName: (context) => const LoginPage(),
          HomePage.routeName: (context) => const HomePage(),
          LoadingPage.routeName: (context) => const LoadingPage(),
          ScorePage.routeName: (context) => const ScorePage(),
          SubscribePage.routeName: (context) => const SubscribePage(),
          SummaryPage.routeName: (context) => const SummaryPage(),
          FeedbackPage.routeName: (context) => const FeedbackPage(),
          RankingPage.routeName: (context) => const RankingPage(),
          TimeSelectPage.routeName: (context) => const TimeSelectPage(),
        },
      ),
    );
  }
}
