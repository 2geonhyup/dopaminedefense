import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/pages/feedback_page.dart';
import 'package:dopamine_defense_1/providers/read/read_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/read.dart';
import '../providers/read/read_state.dart';
import '../utils/error_dialog.dart';

class ScorePage extends StatefulWidget {
  final DefenseModel todayDefense;
  const ScorePage({Key? key, required this.todayDefense}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late final ReadListProvider readListProv;
  late final void Function() _removeListener;

  void errorDialogListener(ReadListState state) {
    //가장 최근에 읽은 것에 오류가 있을 경우
    if (state.reads.last.readStatus == ReadStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readListProv = context.read<ReadListProvider>();
    _removeListener =
        readListProv.addListener(errorDialogListener, fireImmediately: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int avgScore = context.read<TodayProvider>().avgScore;

    ReadModel todayRead = context
        .watch<ReadListState>()
        .reads
        .lastWhere((element) => element.defenseId == widget.todayDefense.id);
    ReadStatus todayReadCheck = todayRead.readStatus;

    print(todayRead);
    int percentile =
        context.read<TodayProvider>().calculatePercentile(todayRead.score);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: todayReadCheck == ReadStatus.end
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
                          '${todayRead.score}점',
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
                      "${percentile < 10 ? '🎉' : '🏆'} 점수 상위 ${percentile}%에요",
                      style: informationStyle,
                      textAlign: TextAlign.center,
                    )
                  ]
                : todayReadCheck != ReadStatus.error
                    ? [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(text: "오늘의 ", style: subTitleStyle),
                            TextSpan(
                                text: "평균 점수",
                                style:
                                    subTitleStyle.copyWith(color: pointColor))
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
                              '$avgScore점',
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
                          "과연 내 점수는 몇 점일까? \n2분 안에 공개됩니다!",
                          style: informationStyle,
                          textAlign: TextAlign.center,
                        )
                      ]
                    : [
                        Text(
                          "죄송합니다. 채점 중 오류가 발생했습니다. 앱을 다시 실행해주세요.",
                          style: subTitleStyle,
                          textAlign: TextAlign.center,
                        )
                      ],
          ),
        )),
        todayReadCheck == ReadStatus.end
            ? Column(
                children: [
                  NavigateButton(
                      onPressed: () {
                        //TODO: 인자 전달
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                FeedbackPage(myRead: todayRead)));
                      },
                      text: "자세히 보기",
                      foregroundColor: Colors.white,
                      backgroundColor: black1),
                ],
              )
            : LoadingButton(),
        SizedBox(
          height: 26,
        ),
      ],
    ));
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
