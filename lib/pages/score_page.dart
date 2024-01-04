import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/read.dart';
import '../providers/read/read_state.dart';

class ScorePage extends StatelessWidget {
  final DefenseModel todayDefense;
  const ScorePage({Key? key, required this.todayDefense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ReadModel> reads = context.watch<ReadListState>().reads;
    ReadCheck todayReadCheck = readCheck(reads, todayDefense.id);
    ReadModel todayRead =
        reads.firstWhere((element) => element.defenseId == todayDefense.id);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: todayReadCheck == ReadCheck.end
                ? [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "오늘의 ", style: subTitleStyle),
                        TextSpan(
                            text: "내 점수",
                            style: subTitleStyle.copyWith(color: pointColor))
                      ]),
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    Container(
                      width: 330,
                      height: 140,
                      color: pointColor,
                      child: Center(
                        child: Text(
                          "858점",
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 100,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      "🏆 점수 상위 11%에요",
                      style: informationStyle,
                    )
                  ]
                : [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "오늘의 ", style: subTitleStyle),
                        TextSpan(
                            text: "평균 점수",
                            style: subTitleStyle.copyWith(color: pointColor))
                      ]),
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    Container(
                      width: 330,
                      height: 140,
                      color: pointColor,
                      child: Center(
                        child: Text(
                          "858점",
                          style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 100,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      "과연 내 점수가 궁금하다면?\n2분 안에 공개됩니다!",
                      style: informationStyle,
                      textAlign: TextAlign.center,
                    )
                  ],
          ),
        )),
        todayReadCheck == ReadCheck.end
            ? NavigateButton(
                onPressed: () {},
                text: "자세히 보기",
                foregroundColor: Colors.white,
                backgroundColor: black1)
            : LoadingButton(),
        SizedBox(
          height: 26,
        ),
      ],
    ));
  }
}

enum ReadCheck { start, end, process }

ReadCheck readCheck(List<ReadModel> reads, int defenseId) {
  if (reads.any((element) => element.defenseId == defenseId)) {
    if (reads.any((element) =>
        element.defenseId == defenseId &&
        element.readStatus == ReadStatus.process)) {
      return ReadCheck.process;
    } else {
      return ReadCheck.end;
    }
  } else {
    return ReadCheck.start;
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 70,
      child: TextButton(
        onPressed: () {},
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "채점 중",
                  style: buttonTextStyle.copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                backgroundColor: black1,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        style: TextButton.styleFrom(
            backgroundColor: black1,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(90))),
      ),
    );
  }
}
