import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/pages/ranking_page.dart';

import 'package:dopamine_defense_1/providers/read/read_list_provider.dart';
import 'package:dopamine_defense_1/providers/read/read_list_state.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

import '../models/read.dart';
import '../providers/today/today_provider.dart';

//피드백 버튼 크기, 패딩에 따라 달라짐
final List<double> feedbackButtonOffsets = [0, 100, 213, 313];

class BottomScoreBox extends StatefulWidget {
  const BottomScoreBox({Key? key}) : super(key: key);

  @override
  State<BottomScoreBox> createState() => _BottomScoreBoxState();
}

class _BottomScoreBoxState extends State<BottomScoreBox> {
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  @override
  Widget build(BuildContext context) {
    int yesterdayScore = context.read<ReadListProvider>().getYesterdayRead();
    int todayScore = context.read<ReadListState>().reads.last.score;
    int upScore = todayScore - yesterdayScore;
    ReadModel topDefense = context.read<TodayProvider>().getTopDefense()[0];

    // 아래 점수 박스
    return Container(
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(color: greyA, width: 0.5))),
      height: (MediaQuery.of(context).size.width / 2) - 14,
      constraints: BoxConstraints(maxHeight: 181),
      child: Row(
        children: [
          Expanded(
              child: Stack(
            children: [
              //어제 점수와 비교
              GestureDetector(
                onPanStart: (e) {
                  setState(() {
                    color1 = greyE;
                  });
                },
                onPanCancel: () {
                  setState(() {
                    color1 = Colors.white;
                  });
                },
                onPanEnd: (e) {
                  setState(() {
                    color1 = Colors.white;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 16, left: 24, bottom: 26),
                  color: color1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "어제 점수",
                            style: mediumGrey7_16,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text(
                                yesterdayScore.toString(),
                                style: numberStyle.copyWith(
                                    color: grey3,
                                    fontSize: 48,
                                    height: 1.42,
                                    letterSpacing: 0.1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  "점",
                                  style: mediumGreyA_16,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        //TODO: 어제 안했을 때 만들어야 함
                        yesterdayScore == 0
                            ? "어제의 점수가 없어요"
                            : "어제보다 $upScore점 ${upScore >= 0 ? '높아요' : '낮아요'}",
                        style: regularOrange14.copyWith(
                            color: yesterdayScore == 0
                                ? greyA
                                : upScore >= 0
                                    ? Color(0xff368CF1)
                                    : orangePoint),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 15,
                  right: 20,
                  child: Image.asset(
                    "assets/images/icon-more.png",
                    width: 24,
                    height: 24,
                  )),
            ],
          )),
          VerticalDivider(
            width: 0.5,
            color: greyA,
          ),
          Expanded(
              child: Stack(
            children: [
              GestureDetector(
                onPanStart: (e) {
                  setState(() {
                    color2 = greyE;
                  });
                },
                onPanCancel: () {
                  setState(() {
                    color2 = Colors.white;
                  });
                },
                onPanEnd: (e) {
                  setState(() {
                    color2 = Colors.white;
                  });
                },
                onTap: () {
                  Navigator.pushNamed(context, RankingPage.routeName);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 16, left: 24, bottom: 26),
                  color: color2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "오늘의 디펜서",
                            style: mediumGrey7_16,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text(
                                '${topDefense.score}',
                                style: numberStyle.copyWith(
                                    color: grey3,
                                    fontSize: 48,
                                    height: 1.42,
                                    letterSpacing: 0.1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text(
                                  "점",
                                  style: mediumGreyA_16,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Text(
                        topDefense.score <= todayScore
                            ? "내가 1등이에요!"
                            : "나보다 +${topDefense.score - todayScore}점 높아요",
                        style:
                            regularOrange14.copyWith(color: Color(0xff368CF1)),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 10,
                  right: 24.06,
                  child: Image.asset(
                    "assets/images/arrow-right.png",
                    width: 34,
                    height: 34,
                  )),
            ],
          ))
        ],
      ),
    );
  }
}

class FeedbackButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function() onTap;
  final bool selected;
  const FeedbackButton(
      {Key? key,
      required this.title,
      required this.color,
      required this.onTap,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        selected ? semiBold14.copyWith(color: color) : mediumGrey7_14;
    Color boxColor = selected ? black1 : greyE;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: ShapeDecoration(
          color: boxColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreBox extends StatelessWidget {
  final int score;
  final Color color;
  const ScoreBox({
    Key? key,
    required this.score,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 48,
      decoration: BoxDecoration(
        color: black1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.5),
            child: Text(
              '$score',
              style: numberStyle.copyWith(fontSize: 32, color: color),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              "점",
              style: mediumGreyE16,
            ),
          )
        ],
      ),
    );
  }
}
