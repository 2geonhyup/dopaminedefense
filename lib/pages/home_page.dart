import 'dart:async';
import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:dopamine_defense_1/widgets/push_time_dialog.dart';
import 'package:dopamine_defense_1/widgets/re_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile/profile_provider.dart';
import '../providers/profile/profile_state.dart';
import '../providers/read/read_list_provider.dart';
import '../providers/read/read_list_state.dart';
import '../utils/error_dialog.dart';
import 'home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _lastCheckedDate = DateTime.now();

  Timer? _timer;

  void _showPushTimeDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 구독했는데 푸쉬 알림 시간 설정 안한 경우
      if (context.read<ProfileState>().user.push == '' &&
          context.read<ProfileState>().user.entitlementIsActive) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const PushTimeDialog();
          },
        ).then(
            //선택 안했을 경우, 오전 8시로 설정
            (value) => context.read<ProfileProvider>().setTime(push: '08:00'));
      }
    });
  }

  // 날이 바뀌면 오늘의 정보를 업데이트
  void _checkDate() {
    DateTime now = DateTime.now();
    if (DateTime(now.year, now.month, now.day) !=
        DateTime(_lastCheckedDate.year, _lastCheckedDate.month,
            _lastCheckedDate.day)) {
      _getToday();
    }
    _lastCheckedDate = now;
  }

  // 오늘의 정보 가져오기
  void _getToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TodayProvider>()
          .getToday(user: context.read<ProfileState>().user);
    });
  }

  // 유저 읽음 리스트 가져오기
  void _getRead() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ReadListProvider>()
          .getRead(userId: context.read<ProfileState>().user.id);
    });
  }

  @override
  void initState() {
    super.initState();

    _timer =
        Timer.periodic(const Duration(minutes: 1), (Timer t) => _checkDate());

    _getToday();
    _getRead();
    _showPushTimeDialog();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void errorDialogListener(ProfileState state) {
    if (state.profileStatus == ProfileStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            )),
            child: const HomeLayout()),
      ),
    );
  }
}

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodayState todayState = context.watch<TodayState>();
    final ReadListState readListState = context.watch<ReadListState>();
    // _getRead 함수 실행 결과 (시작, 로딩 중, 로딩 완료, 에러)
    final ReadListStatus readListStatus = readListState.readListStatus;
    // _getToday 함수 실행 결과 (시작, 로딩 중, 로딩 완료, 에러)
    final TodayStatus todayStatus = todayState.todayStatus;

    // 오늘 제출 했는지 판단
    final bool todaySubmit = readListState.reads
        .any((element) => element.defenseId == todayState.todayDefense.id);

    // 에러 발생
    if (readListStatus == ReadListStatus.error ||
        todayStatus == TodayStatus.error) {
      // 다시 로딩 버튼
      return const ReloadingScreen(text: "죄송합니다. 다시 로딩해주세요.");
    }

    return Stack(
      children: [
        const Positioned(
          top: 60,
          right: 24,
          child: PopUpMenuWidget(),
        ),
        //십자선
        const Positioned(
          left: 61,
          top: 0,
          child: SizedBox(
            height: 113,
            child: VerticalDivider(
              thickness: 0.5,
              color: greyA,
            ),
          ),
        ),
        const Positioned(
          left: 61,
          top: 232,
          child: SizedBox(
            height: 234,
            child: VerticalDivider(
              thickness: 0.5,
              color: greyA,
            ),
          ),
        ),
        const Positioned(
          top: 241,
          left: 0,
          right: 0,
          child: Divider(
            thickness: 0.5,
            color: greyA,
          ),
        ),
        //아이콘
        Positioned(
            top: 110,
            left: 24,
            child: Container(
              color: Colors.transparent,
              child: Image.asset(
                "assets/images/logo.png",
                width: 232,
                height: 128,
              ),
            )),
        // 아래 위젯은 바닥기준 중앙 정렬

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              //오늘의 디펜스 카드
              TodayDefenseCard(
                todayState: todayState,
              ),
              const SizedBox(
                height: 20,
              ),
              //읽어보기
              ReadNavigateButton(
                readListStatus: readListStatus,
                todaySubmit: todaySubmit,
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
