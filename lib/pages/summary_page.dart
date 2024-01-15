import 'dart:async';

import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/pages/score_page.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../functions.dart';
import '../providers/profile/profile_state.dart';
import '../providers/read/read_provider.dart';

class SummaryPage extends StatefulWidget {
  final DefenseModel todayDefense;

  SummaryPage({Key? key, required this.todayDefense}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final TextEditingController _controller = TextEditingController();
  bool _keyboardVisible = false;
  int _seconds = 300;
  int _sec = 0;
  int _min = 5;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > -1000) {
          _seconds--;
          _sec = _seconds % 60;
          _min = _seconds ~/ 60;
        }
      });
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _keyboardVisible = true);
      } else {
        setState(() => _keyboardVisible = false);
      }
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Scrollbar(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 80, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "오늘의 ",
                                                style: subTitleStyle),
                                            TextSpan(
                                                text: "디펜스",
                                                style: subTitleStyle.copyWith(
                                                    color: pointColor))
                                          ]),
                                        ),
                                        TimerWidget(
                                          sec: _sec,
                                          min: _min,
                                          seconds: _seconds,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                color: backGrey,
                                child: Text(
                                  widget.todayDefense.content,
                                  style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 17,
                                      height: 1.7,
                                      fontWeight: FontWeight.w400,
                                      color: black1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(width: 1, color: lineGrey))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              focusNode: _focusNode,
                              controller: _controller,
                              style: textStyle, // 텍스트 색상
                              maxLength: 200,
                              decoration: InputDecoration(
                                counterStyle: textStyle.copyWith(fontSize: 15),
                                hintText: '원문의 핵심을 간단히 요약해주세요.',
                                hintStyle: textStyle, // 힌트 텍스트 색상
                                border: InputBorder.none, // 테두리 제거
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          _keyboardVisible
              ? SizedBox.shrink()
              : Column(
                  children: [
                    Center(
                      child: NavigateButton(
                          onPressed: () {
                            if (_controller.text.length < 20) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    title: Text(
                                      '알림',
                                    ),
                                    content: Text(
                                      '20자 이상 적어주세요!',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('확인'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    title: Text(
                                      '요약 제출',
                                    ),
                                    content: Text(
                                      '이 요약을 최종 제출하겠습니까?',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('확인'),
                                        onPressed: () {
                                          //최종제출
                                          context
                                              .read<ReadListProvider>()
                                              .summarySubmit(
                                                  summary: _controller.text,
                                                  user: context
                                                      .read<ProfileState>()
                                                      .user,
                                                  time: 300 - _seconds,
                                                  defense: widget.todayDefense);
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => ScorePage(
                                                      todayDefense:
                                                          widget.todayDefense,
                                                    )), // 새 화면으로 이동
                                          );
                                        },
                                      ),
                                      TextButton(
                                        child: Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // 다이얼로그 닫기
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          text: "완료",
                          foregroundColor: Colors.white,
                          backgroundColor: pointColor),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final int seconds;
  final int sec;
  final int min;
  const TimerWidget(
      {Key? key, required this.seconds, required this.sec, required this.min})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 49,
          height: 49,
          child: CircularProgressIndicator(
            strokeWidth: 5,
            value: (300 - seconds).toDouble() / 300,
            backgroundColor: widgetGrey,
            color: pointColor,
          ),
        ),
        SizedBox(
          width: 49,
          height: 49,
          child: Center(
            child: Text(
                seconds < 0
                    ? '+${-seconds}'
                    : '${min} : ${sec >= 10 ? sec : '0${sec}'}',
                style: textStyle.copyWith(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
