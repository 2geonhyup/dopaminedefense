import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/read.dart';

class ScoreCard extends StatelessWidget {
  final ReadModel todayRead;
  const ScoreCard({Key? key, required this.todayRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int avgScore = context.read<TodayProvider>().avgScore;
    bool loaded = todayRead.readStatus == ReadStatus.end;

    return Container(
      height: 280,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 33.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 342,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: loaded ? black1 : greyF),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loaded
                              ? todayRead.score.toString()
                              : avgScore.toString(),
                          style: numberStyle.copyWith(
                              fontSize: 128,
                              color: loaded ? greenPoint : orangePoint),
                        ),
                        Text(
                          "점",
                          style: mediumGrey32.copyWith(
                              color: loaded ? Colors.white : greyA),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Image.asset(
              loaded
                  ? "assets/images/score-arrow-green.png"
                  : "assets/images/score-arrow-orange.png",
              width: 64,
              height: 64,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              width: 64,
              height: 64,
            ),
          ),
          Positioned(
              top: 238,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  loaded ? "" : "'오늘의 Best 디펜서’에서 더 자세히 볼 수 있어요",
                  style: regularGrey14.copyWith(color: greyA),
                ),
              )),
        ],
      ),
    );
  }
}

class ScorePageTitle extends StatelessWidget {
  final bool loaded;
  const ScorePageTitle({Key? key, required this.loaded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !loaded
        // 채점 완료 전
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "다른 디펜서들의",
              style: semiBoldBlack24,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "평균 점수", style: semiBoldOrange24),
                TextSpan(text: "는?", style: semiBoldBlack24)
              ]),
            )
          ])
        // 채점 완료 후
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("나의", style: semiBoldBlack24),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "오늘의 점수", style: semiBoldOrange24),
                TextSpan(text: "는?", style: semiBoldBlack24)
              ]),
            )
          ]);
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
