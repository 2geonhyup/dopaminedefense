import 'dart:async';

import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/models/read.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/read/read_provider.dart';
import 'package:dopamine_defense_1/providers/read/read_state.dart';
import 'package:dopamine_defense_1/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../repositories/defense_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ProfileState profileState = context.watch<ProfileState>();
    return ListView(
      children: [
        SizedBox(
          height: 40,
        ),
        TodayDefenseCard(),
        ReadingAnalysisCard(user: profileState.user),
        Divider(),
        AttendanceCheckCard(user: profileState.user),
      ],
    );
  }
}

class TodayDefenseCard extends StatefulWidget {
  const TodayDefenseCard({Key? key}) : super(key: key);

  @override
  State<TodayDefenseCard> createState() => _TodayDefenseCardState();
}

class _TodayDefenseCardState extends State<TodayDefenseCard> {
  DefenseModel? todayDefense;
  DateTime _lastCheckedDate = DateTime.now();
  Timer? _timer;

  Future<void> _getTodayDefense() async {
    todayDefense = await context.read<DefenseRepository>().getTodayDefense(
        course: context.read<ProfileState>().user.level,
        day: getDateDifference(
            context.read<ProfileState>().user.date, getCurrentDate()));
    print(todayDefense);
    setState(() {});
  }

  void _checkDate() {
    DateTime now = DateTime.now();
    // 날짜만 비교하기 위해 시간은 무시합니다.
    if (DateTime(now.year, now.month, now.day) !=
        DateTime(_lastCheckedDate.year, _lastCheckedDate.month,
            _lastCheckedDate.day)) {
      _getTodayDefense();
    }
    _lastCheckedDate = now;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTodayDefense();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => _checkDate());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        splashColor: Colors.blueGrey,
        onTap: () {
          todayDefense == null
              ? null
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SummaryPage(
                            defense: todayDefense,
                          )),
                );
        },
        child: Container(
          height: 250,
          decoration: BoxDecoration(
              color: backGrey,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: todayDefense == null
              ? SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 22, top: 33),
                      child: Text(
                        "오늘의 디펜스 도전!",
                        style: titleStyle,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 22, top: 15, right: 22),
                      child: Text(
                        todayDefense!.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 22,
                        right: 22,
                        top: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: createTagsFromArray(todayDefense!.tag),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 45,
                          width: 216,
                          decoration: BoxDecoration(
                              color: pointColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "글읽기 시작",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: Image(
                                  image: AssetImage('assets/images/arrow.png'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

List<Widget> createTagsFromArray(array) {
  return array.map<Widget>((item) {
    return TagCard(text: item);
  }).toList();
}

class TagCard extends StatelessWidget {
  final String text;
  const TagCard({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        height: 22,
        decoration: BoxDecoration(
          color: pointColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Text(
              '#$text',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: pointColor),
            ),
          ),
        ),
      ),
    );
  }
}

class ReadingAnalysisCard extends StatefulWidget {
  final UserModel user;
  const ReadingAnalysisCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ReadingAnalysisCard> createState() => _ReadingAnalysisCardState();
}

class _ReadingAnalysisCardState extends State<ReadingAnalysisCard> {
  void getRead() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadListProvider>().getRead(userId: widget.user.id);
    });
  }

  @override
  void initState() {
    super.initState();
    getRead();
  }

  @override
  Widget build(BuildContext context) {
    List<ReadModel> reads = context.watch<ReadListState>().reads;
    int totalLength = reads.fold(0, (previousValue, element) {
      return previousValue + element.length;
    });
    int totalTime = reads.fold(0, (previousValue, element) {
      return previousValue + element.time;
    });

    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 25, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "읽기 분석",
            style: titleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text("읽은 글자: $totalLength자"),
          SizedBox(
            height: 5,
          ),
          Text("읽은 시간: $totalTime초"),
          SizedBox(
            height: 5,
          ),
          Text("평균 속도: ${totalTime == 0 ? 0 : totalLength ~/ totalTime}자 (초당)"),
        ],
      ),
    );
  }
}

class AttendanceCheckCard extends StatefulWidget {
  final UserModel user;
  const AttendanceCheckCard({Key? key, required this.user}) : super(key: key);

  @override
  State<AttendanceCheckCard> createState() => _AttendanceCheckCardState();
}

class _AttendanceCheckCardState extends State<AttendanceCheckCard> {
  void getRead() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadListProvider>().getRead(userId: widget.user.id);
    });
  }

  @override
  void initState() {
    super.initState();
    getRead();
  }

  @override
  Widget build(BuildContext context) {
    print(getWeeklyParticipation(context.watch<ReadListState>().reads));
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "출석 체크",
            style: titleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: createIconList(
                getWeeklyParticipation(context.watch<ReadListState>().reads)),
          )
        ],
      ),
    );
  }
}

Map<String, bool> getWeeklyParticipation(List<ReadModel> data) {
  var now = DateTime.now();
  var oneWeekAgo = now.subtract(Duration(days: now.weekday - 1));

  Map<String, bool> weeklyParticipation = {
    '월': false,
    '화': false,
    '수': false,
    '목': false,
    '금': false,
    '토': false,
    '일': false
  };

  for (ReadModel read in data) {
    DateTime date = DateTime.parse(read.date.substring(0, 10));
    if (date.isAfter(oneWeekAgo) && date.isBefore(now)) {
      String dayOfWeek = _getDayOfWeek(date);
      weeklyParticipation[dayOfWeek] = true;
    }
  }

  return weeklyParticipation;
}

String _getDayOfWeek(DateTime date) {
  List<String> days = ['월', '화', '수', '목', '금', '토', '일'];
  return days[date.weekday - 1];
}

List<Widget> createIconList(Map<String, bool> weekParticipation) {
  return weekParticipation.entries.map((entry) {
    return Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: entry.value ? pointColor.withOpacity(0.7) : backGrey,
          shape: BoxShape.circle,
        ),
        child: entry.value
            ? Center(
                child: Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              )
            : Center(
                child: Text(entry.key,
                    style: TextStyle(
                        color: fontGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w700))));
  }).toList();
}
