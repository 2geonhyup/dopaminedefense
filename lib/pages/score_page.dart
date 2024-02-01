import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/pages/feedback_page.dart';
import 'package:dopamine_defense_1/pages/score_view.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/read.dart';
import '../providers/read/read_list_state.dart';
import '../providers/today/today_state.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);
  static const String routeName = "score_page";

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    // 현재 읽은 결과 받아오기
    List<ReadModel> reads = context.watch<ReadListState>().reads;
    print("change");

    // 오류가 났다면 재시작하게 하기
    if (reads.isEmpty ||
        reads.last.defenseId != context.read<TodayState>().todayDefense.id) {
      return Text("error");
    }

    ReadModel todayRead = reads.last;
    bool loaded = todayRead.readStatus == ReadStatus.end;
    // 화면 크기와 상관없이 위젯들 왼쪽 패딩 크기를 맞추기 위함
    double leftPaddingSize = (MediaQuery.of(context).size.width - 342) / 2;
    // 로딩 중이거나 채점 완료
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 위 기준 정렬
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 132,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: leftPaddingSize,
                    ),
                    Container(
                      width: 132,
                      height: 24,
                      decoration: BoxDecoration(
                          color: greyE,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text(
                          getDateWithWeekday(),
                          style: regularGrey14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // 문구
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: leftPaddingSize,
                    ),
                    ScorePageTitle(
                      loaded: loaded,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                //점수
                ScoreCard(
                  todayRead: todayRead,
                ),
              ],
            ),
          ),

          // 아래 기준 정렬
          Column(
            children: [
              // 멘트
              Text(
                loaded
                    ? "와우! 상위 ${context.read<TodayProvider>().calculatePercentile(todayRead.score)}%에요"
                    : "나의 점수는\n2분 뒤에 곧 공개됩니다!",
                style: loaded ? mediumGreen14 : regularGrey14,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 18,
              ),
              // 버튼
              NavigateButton(
                onPressed: () {
                  //피드백 페이지로 이동
                  Navigator.pushNamed(context, FeedbackPage.routeName);
                },
                text: loaded ? "자세히 보기" : "채점 중",
                icon: loaded
                    ? Icon(
                        Icons.remove_red_eye,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                backgroundColor: loaded ? orangePoint : greyA,
              ),
              SizedBox(
                height: 34,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
