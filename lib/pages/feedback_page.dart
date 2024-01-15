import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/pages/ranking_page.dart';
import 'package:dopamine_defense_1/providers/read/read_state.dart';
import 'package:dopamine_defense_1/repositories/feedback_repository.dart';
import 'package:dopamine_defense_1/utils/error_dialog.dart';
import 'package:dopamine_defense_1/widgets/name_app_bar.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamine_defense_1/models/feedback.dart';

import '../constants.dart';
import '../models/read.dart';

class FeedbackPage extends StatelessWidget {
  static const routeName = '/feedback';

  final ReadModel myRead;
  const FeedbackPage({Key? key, required this.myRead}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FeedbackModel feedback = myRead.feedback;
    String summary = myRead.summary;
    return Scaffold(
      backgroundColor: backGrey,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(15),
            children: [
              SizedBox(
                height: 90,
              ),
              FeedbackCard(
                title: "🔎 요약 다시보기",
                textWidget: Text(
                  '${summary}',
                  style: textStyle.copyWith(color: black1, height: 1.7),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FeedbackCard(
                title: '🎯 주요 포인트',
                textWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: feedback.keyPointsAddressed
                      .map((text) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('${text}',
                                style: textStyle.copyWith(color: black1)),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FeedbackCard(
                title: '📌 더 살펴볼 포인트',
                textWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: feedback.misInterpretations
                      .map((text) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('${text}',
                                style: textStyle.copyWith(color: black1)),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FeedbackCard(
                title: 'AI 종합 피드백',
                textWidget: Text(
                  feedback.comprehensiveFeedback,
                  style: textStyle.copyWith(color: black1, height: 1.7),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          Positioned(
              bottom: 26,
              left: 0,
              right: 0,
              child: Center(
                child: NavigateButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RankingPage(myRead: myRead)));
                    },
                    text: "완료",
                    foregroundColor: Colors.white,
                    backgroundColor: pointColor),
              ))
        ],
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final String title;
  final Widget textWidget;
  const FeedbackCard({Key? key, required this.title, required this.textWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      constraints: BoxConstraints(minHeight: 100),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$title', style: subTitleStyle.copyWith(color: pointColor)),
          SizedBox(
            height: 15,
          ),
          textWidget,
        ],
      ),
    );
  }
}
