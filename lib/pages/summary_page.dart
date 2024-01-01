import 'dart:async';

import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/providers/read/read_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../functions.dart';
import '../providers/profile/profile_state.dart';
import '../repositories/defense_repository.dart';

class SummaryPage extends StatefulWidget {
  DefenseModel? defense;
  SummaryPage({Key? key, this.defense}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  DefenseModel? defense;

  Future<void> _getDefense() async {
    defense = widget.defense ??
        await context.read<DefenseRepository>().getTodayDefense(
            course: context.read<ProfileState>().user.level,
            day: getDateDifference(
                context.read<ProfileState>().user.date, getCurrentDate()));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDefense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: defense == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Stack(
                children: [
                  ListView(
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          color: backGrey,
                          child: Text(
                            defense!.content,
                            style: const TextStyle(
                                fontSize: 16,
                                height: 1.8,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 429,
                      ),
                    ],
                  ),
                  SummaryBottomSheet(
                    defense: defense!,
                  ),
                  TopBar(defense: defense!),
                ],
              ),
            ),
    );
  }
}

class SummaryBottomSheet extends StatefulWidget {
  final DefenseModel defense;
  const SummaryBottomSheet({Key? key, required this.defense}) : super(key: key);

  @override
  State<SummaryBottomSheet> createState() => _SummaryBottomSheetState();
}

class _SummaryBottomSheetState extends State<SummaryBottomSheet> {
  late double _height;

  final double _lowLimit = 200;
  final double _highLimit = 429;
  final double _upThresh = 250;
  final double _boundary = 330;
  final double _downThresh = 380;
  String summary = "";

  /// 100 -> 600, 550 -> 100 으로 애니메이션이 진행 될 때,
  /// 드래그로 인한 _height의 변화 방지
  bool _longAnimation = false;

  int _sec = 0;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _sec++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _height = _lowLimit;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0.0,
        child: GestureDetector(
            onVerticalDragUpdate: ((details) {
              // delta: y축의 변화량, 우리가 보기에 위로 움직이면 양의 값, 아래로 움직이면 음의 값
              double? delta = details.primaryDelta;
              if (delta != null) {
                /// Long Animation이 진행 되고 있을 때는 드래그로 높이 변화 방지,
                /// 그리고 low limit 보다 작을 때 delta가 양수,
                /// High limit 보다 크거나 같을 때 delta가 음수이면 드래그로 높이 변화 방지
                if (_longAnimation ||
                    (_height <= _lowLimit && delta > 0) ||
                    (_height >= _highLimit && delta < 0)) return;
                setState(() {
                  /// 600으로 높이 설정
                  if (_upThresh <= _height && _height <= _boundary) {
                    _height = _highLimit;
                    _longAnimation = true;
                  }

                  /// 100으로 높이 설정
                  else if (_boundary <= _height && _height <= _downThresh) {
                    _height = _lowLimit;
                    _longAnimation = true;
                  }

                  /// 기본 작동
                  else {
                    _height -= delta;
                  }
                });
              }
            }),
            child: AnimatedContainer(
              onEnd: () {
                if (_longAnimation) {
                  setState(() {
                    _longAnimation = false;
                  });
                }
              },
              duration: const Duration(milliseconds: 150),
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(0, -3),
                        color: Color(0x2625262E))
                  ],
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              width: MediaQuery.of(context).size.width,
              height: _height,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 429,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                width: 70,
                                height: 3,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 25, bottom: 10),
                              child: Text(
                                "나의 요약",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: black1),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                height: 206,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: lineGrey, width: 1)),
                                child: TextFormField(
                                  initialValue: '',
                                  onChanged: (val) {
                                    summary = val;
                                  },
                                  maxLines: 50,
                                  maxLength: 200,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration.collapsed(
                                      hintText: "여기에 요약해주세요."),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () async {},
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0, 70),
                                  alignment: AlignmentDirectional.center,
                                  shadowColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                  padding: EdgeInsets.zero,
                                  surfaceTintColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  foregroundColor: pointColor,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: pointColor),
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                child: Text(
                                  "저장",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  //최종제출
                                  context
                                      .read<ReadListProvider>()
                                      .summarySubmit(
                                          summary: summary,
                                          user:
                                              context.read<ProfileState>().user,
                                          time: _sec,
                                          defense: widget.defense);
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(0, 70),
                                  alignment: AlignmentDirectional.center,
                                  shadowColor: Colors.transparent,
                                  splashFactory: NoSplash.splashFactory,
                                  padding: EdgeInsets.zero,
                                  surfaceTintColor: pointColor,
                                  backgroundColor: pointColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: pointColor),
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                child: Text(
                                  "최종 제출",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

class TopBar extends StatelessWidget {
  DefenseModel defense;
  TopBar({Key? key, required this.defense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.only(right: 25.0, left: 25, top: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: black1),
                            children: [
                          TextSpan(text: '디펜스'),
                          TextSpan(
                              text: ' 지문분석',
                              style: TextStyle(color: pointColor))
                        ])),
                  ],
                ),
                TimerWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _seconds = 300;
  int _sec = 0;
  int _min = 5;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
          _sec = _seconds % 60;
          _min = _seconds ~/ 60;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 49,
          height: 49,
          child: CircularProgressIndicator(
            strokeWidth: 5,
            value: (300 - _seconds).toDouble() / 300,
            backgroundColor: widgetGrey,
            color: pointColor,
          ),
        ),
        SizedBox(
          width: 49,
          height: 49,
          child: Center(
            child: Text('${_min} : ${_sec >= 10 ? _sec : '0${_sec}'}',
                style: TextStyle(
                    fontSize: 12,
                    color: fontGrey,
                    fontWeight: FontWeight.w400)),
          ),
        ),
      ],
    );
  }
}
