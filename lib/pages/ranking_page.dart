import 'package:dopamine_defense_1/pages/home_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../functions.dart';
import '../models/read.dart';
import '../providers/profile/profile_state.dart';
import '../providers/today/today_provider.dart';

final List<Color> _pointColors = [orangePoint, greenPoint, purplePoint];

class RankingPage extends StatefulWidget {
  static const routeName = '/ranking';

  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<RankingPage> {
  int selectedNum = 1;

  @override
  Widget build(BuildContext context) {
    List<ReadModel> todayReads = context.read<TodayProvider>().getTopDefense();

    return Scaffold(
      backgroundColor: black1,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 뒤로가기 버튼
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 24,
                    top: MediaQuery.of(context).size.height > 800 ? 60 : 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                          width: 15,
                          height: 15,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              // 날짜
              Container(
                width: 112,
                height: 29,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: Colors.white)),
                child: Center(
                  child: Text(
                    getDateWithWeekday(),
                    style: regularWhite14,
                  ),
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              // 제목
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "오늘의",
                    style: semiBoldWhite24,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Best",
                    style: typoBoldStyle,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    "디펜서",
                    style: semiBoldOrange24,
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height > 800 ? 82 : 20,
              ),
              // 랭킹박스 3개
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3]
                      .map((e) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: ScoreRankCard(
                                num: e,
                                selectedNum: selectedNum,
                                onTap: () {
                                  setState(() {
                                    selectedNum = e;
                                  });
                                },
                                score: todayReads[e - 1].score),
                          ))
                      .toList()),
              const SizedBox(
                height: 14,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //랭커의 요약
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: 342,
                    constraints: const BoxConstraints(minHeight: 212),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: _pointColors[selectedNum - 1], width: 1.5),
                      color: Colors.white,
                    ),
                    child: Text(todayReads[selectedNum - 1].summary,
                        style: mediumGrey3_16),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    width: 342,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${todayReads[selectedNum - 1].summary.length}/200",
                          style: numberStyle.copyWith(
                              fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 34.0),
            child: NavigateButton(
                onPressed: () {
                  if (!context.read<ProfileState>().user.entitlementIsActive) {
                    Navigator.pushNamed(context, SubscribePage.routeName);
                  } else {
                    Navigator.pushNamed(context, HomePage.routeName);
                  }
                },
                text: context.read<ProfileState>().user.entitlementIsActive
                    ? "홈으로 돌아가기"
                    : "내일도 읽어보기"),
          )
        ],
      ),
    );
  }
}

class ScoreRankCard extends StatelessWidget {
  final int num;
  final int selectedNum;
  final Function() onTap;
  final int score;

  const ScoreRankCard(
      {Key? key,
      required this.num,
      required this.selectedNum,
      required this.onTap,
      required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color scoreColor = _pointColors[num - 1]; // 점수와 랭킹 박스 색상
    Color rankColor = Colors.white; // 랭킹 숫자 색상
    Color boxColor = greyE; // 점수 박스 색상
    Color textColor = grey7; // "점"의 색상

    if (selectedNum == num) {
      scoreColor = textColor = Colors.white;
      rankColor = boxColor = _pointColors[num - 1];
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              width: 106,
              height: 44,
              decoration: BoxDecoration(
                  color: boxColor, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$score",
                    style:
                        numberStyle.copyWith(fontSize: 28, color: scoreColor),
                  ),
                  Text(
                    "점",
                    style: mediumWhite16.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                color: scoreColor, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Text(
                "$num",
                style: numberStyle.copyWith(color: rankColor, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
