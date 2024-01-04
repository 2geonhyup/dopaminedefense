import 'dart:async';

import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/pages/reading_page.dart';
import 'package:dopamine_defense_1/pages/summary_page_record.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/defense.dart';
import '../providers/profile/profile_state.dart';
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
      _getToday();
    }
    _lastCheckedDate = now;
  }

  void _getToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TodayProvider>()
          .getToday(user: context.read<ProfileState>().user);
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
    todayProv = context.read<TodayProvider>();
    _removeListener =
        todayProv.addListener(errorDialogListener, fireImmediately: false);
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _checkDate());
    _getToday();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayState = context.watch<TodayState>();
    DefenseModel todayDefense = todayState.todayDefense;
    return Scaffold(
      backgroundColor: Colors.white,
      body: todayState.todayStatus == TodayStatus.success
          ? Column(
              children: [
                SizedBox(
                  height: 120,
                ),
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
                  height: 50,
                ),
                SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                          value: 0.64,
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
                                "64%",
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
                SizedBox(
                  width: 280,
                  height: 80,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReadingPage(
                                    todayDefense: todayDefense!,
                                  )));
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "읽어보기",
                              style: buttonTextStyle,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        ),
                        SizedBox(
                          width: 3,
                        )
                      ],
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: pointColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
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
