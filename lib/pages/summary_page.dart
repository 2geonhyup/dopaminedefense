import 'dart:async';

import 'package:dopamine_defense_1/models/defense.dart';

import 'package:dopamine_defense_1/pages/summary_view.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../functions.dart';

import '../providers/today/today_state.dart';
import '../widgets/back_icon.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);
  static const String routeName = "summary_page";

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  bool _floating = true;
  int seconds = 0;
  late Timer _timer;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.offset < _controller.position.maxScrollExtent - 300) {
        _floating = true;
      } else {
        _floating = false;
      }
      setState(() {});
    });
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DefenseModel todayDefense = context.read<TodayState>().todayDefense;

    return Scaffold(
      floatingActionButton: _floating
          ? GestureDetector(
              onTap: () {
                _scrollDown();
              },
              child: Image.asset(
                "assets/images/down.png",
                width: 48,
                height: 48,
              ),
            )
          : null,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              "assets/images/paper-texture.png",
            ),
            fit: BoxFit.cover,
          )),
          child: ListView(
            controller: _controller,
            padding: EdgeInsets.zero,
            children: [
              // 뒤로가기 버튼
              const Padding(
                padding: EdgeInsets.only(left: 24, top: 60),
                child: BackIcon(),
              ),
              const SizedBox(
                height: 32,
              ),
              // 상단 제목 및 위젯들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        // 날짜
                        Text(
                          getDateWithWeekday(),
                          style:
                              regularGrey16.copyWith(fontSize: 14, height: 1.2),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        // 제목
                        Row(
                          children: [
                            Text(
                              "오늘의",
                              style: semiBoldBlack24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            defenseTypo,
                          ],
                        )
                      ],
                    ),
                    // 시계
                    TimerWidget(
                      seconds: seconds,
                    )
                  ],
                ),
              ),
              // 글 컨텐츠
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24, top: 16, bottom: 32),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      todayDefense.content,
                      style: regularBlack16.copyWith(
                          height: 1.58, letterSpacing: 0.1),
                    ),
                  ),
                ),
              ),
              // 입력창
              const SummaryField(),
            ],
          ),
        ),
      ),
    );
  }
}
