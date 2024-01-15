import 'dart:async';

import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/user.dart';
import 'package:dopamine_defense_1/pages/ranking_page.dart';
import 'package:dopamine_defense_1/pages/reading_page.dart';
import 'package:dopamine_defense_1/pages/score_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/pages/summary_page_record.dart';
import 'package:dopamine_defense_1/pages/time_select_page.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/defense.dart';
import '../models/read.dart';
import '../providers/auth/auth_provider.dart';
import '../providers/profile/profile_state.dart';
import '../providers/read/read_provider.dart';
import '../providers/read/read_state.dart';
import '../repositories/defense_repository.dart';
import '../utils/error_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _lastCheckedDate = DateTime.now();
  Timer? _timer;

  late final TodayProvider todayProv;
  late final void Function() _removeListener;

  void _checkDate() {
    DateTime now = DateTime.now();
    // 날짜만 비교하기 위해 시간은 무시합니다.
    if (DateTime(now.year, now.month, now.day) !=
        DateTime(_lastCheckedDate.year, _lastCheckedDate.month,
            _lastCheckedDate.day)) {
      print("new day");
      _getToday();
    }
    _lastCheckedDate = now;
  }

  // Future<void> customerInfo() async {
  //   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //   print(customerInfo);
  // }

  void _getToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TodayProvider>()
          .getToday(user: context.read<ProfileState>().user);
    });
  }

  void getRead() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ReadListProvider>()
          .getRead(userId: context.read<ProfileState>().user.id);
    });
  }

  void errorDialogListener(TodayState state) {
    if (state.todayStatus == TodayStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  void initState() {
    super.initState();
    // customerInfo();
    todayProv = context.read<TodayProvider>();
    _removeListener =
        todayProv.addListener(errorDialogListener, fireImmediately: false);
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _checkDate());
    _getToday();
    getRead();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = context.read<ProfileState>().user;
    final todayState = context.watch<TodayState>();
    DefenseModel todayDefense = todayState.todayDefense;
    ReadModel todayRead = context.watch<ReadListState>().reads.lastWhere(
        (element) => element.defenseId == todayDefense.id,
        orElse: () => ReadModel.initial());
    ReadStatus todayReadCheck = todayRead.readStatus;
    if (todayState.todayStatus == TodayStatus.loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  todayReadCheck == ReadStatus.end
                      ? SizedBox(
                          height: 30,
                        )
                      : SizedBox.shrink(),
                  Center(
                    child: Text(getDateWithWeekday(), style: informationStyle),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Center(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(text: "오늘의 ", style: titleStyle),
                              TextSpan(
                                  text: "디펜스",
                                  style: titleStyle.copyWith(color: pointColor))
                            ]),
                          ),
                        ),
                        Text(
                          createTagString(todayDefense.tag),
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            strokeCap: StrokeCap.round,
                            value:
                                todayState.todayRate[DateTime.now().hour] / 100,
                            backgroundColor: widgetGrey, // 배경색
                            valueColor: AlwaysStoppedAnimation<Color>(
                                pointColor), // 진행 색상
                            strokeWidth: 20, // 두께
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${todayState.todayRate[DateTime.now().hour]}%",
                                  style: titleStyle.copyWith(height: 1.2),
                                ),
                                Text(
                                  "가 읽었어요",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 80,
                  ),
                  HomeNavigateButton(
                      todayReadCheck: todayReadCheck,
                      user: user,
                      todayDefense: todayDefense),
                  todayReadCheck == ReadStatus.end
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SummaryPage(
                                              todayDefense: todayDefense,
                                            )));
                              },
                              child: Text(
                                "다시 읽기",
                                style: informationStyle.copyWith(
                                    shadows: [
                                      Shadow(
                                          color: fontGrey,
                                          offset: Offset(0, -5))
                                    ],
                                    color: Colors.transparent,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline,
                                    decorationColor: fontGrey),
                              )),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              Positioned(
                right: 30,
                top: 40,
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                    color: fontGrey,
                  ),
                  onSelected: (String result) {
                    // 선택한 옵션에 따라 동작 처리
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      onTap: () {
                        context.read<AuthProvider>().signout();
                      },
                      value: '로그아웃',
                      child: Text('로그아웃'),
                    ),
                    PopupMenuItem<String>(
                      onTap: () async {
                        final url =
                            Uri.parse('http://pf.kakao.com/_zmTAG/chat');
                        if (await canLaunchUrl(url)) {
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      value: '문의하기',
                      child: Text('문의하기'),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class HomeNavigateButton extends StatelessWidget {
  const HomeNavigateButton({
    super.key,
    required this.todayReadCheck,
    required this.user,
    required this.todayDefense,
  });

  final ReadStatus todayReadCheck;
  final UserModel user;
  final DefenseModel todayDefense;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 80,
      child: TextButton(
        onPressed: () {
          if (todayReadCheck == ReadStatus.process) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScorePage(
                          todayDefense: todayDefense,
                        )));
            return;
          }

          if (user.trial &&
              !user.entitlementIsActive &&
              todayReadCheck == ReadStatus.initial) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SubscribePage())); // 어제했는데 구독 안하고 오늘 것 안 읽은 경우
          } else if (todayReadCheck == ReadStatus.initial) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SummaryPage(
                          todayDefense: todayDefense,
                        ))); // 오늘 아직 참여안한경우(구독자든 비구독자든)
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScorePage(
                          todayDefense: todayDefense,
                        ))); // 오늘 참여한 경우
          }
        },
        child: Row(
          children: [
            todayReadCheck == ReadStatus.end
                ? SizedBox.shrink()
                : SizedBox(
                    width: 28,
                  ),
            Expanded(
              child: Center(
                child: Text(
                  todayReadCheck == ReadStatus.process
                      ? "채점 중..."
                      : todayReadCheck == ReadStatus.end
                          ? "결과 보기"
                          : "시작하기",
                  style: buttonTextStyle,
                ),
              ),
            ),
            todayReadCheck == ReadStatus.end
                ? SizedBox.shrink()
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 25,
                  ),
          ],
        ),
        style: TextButton.styleFrom(
            backgroundColor: pointColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}

String createTagString(List tags) {
  String combinedString = '';
  for (String str in tags) {
    combinedString += ('# $str '); // 공백을 추가하여 문자열을 연결
  }

  combinedString = combinedString.trim(); // 마지막 공백 제거
  return combinedString;
}
