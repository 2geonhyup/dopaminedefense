import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/providers/read/read_state.dart';
import 'package:dopamine_defense_1/repositories/feedback_repository.dart';
import 'package:dopamine_defense_1/utils/error_dialog.dart';
import 'package:dopamine_defense_1/widgets/name_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dopamine_defense_1/models/feedback.dart';

import '../constants.dart';
import '../models/read.dart';

class FeedbackPage extends StatefulWidget {
  final int defenseId;
  const FeedbackPage({Key? key, required this.defenseId}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  FeedbackModel? feedback;
  void getFeedback() async {
    try {
      feedback = await context
          .read<FeedbackRepository>()
          .getFeedback(defenseId: widget.defenseId);
      setState(() {});
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: nameAppBar(),
      body: feedback == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(25),
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '🔎 내 요약 다시보기',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '서론',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${feedback!.inferredStudentSummary["Development"]}',
                        style: TextStyle(
                            color: black1,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '본론',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${feedback!.inferredStudentSummary["Conclusion"]}',
                        style: TextStyle(
                            color: black1,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '결론',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${feedback!.inferredStudentSummary["Introduction"]}',
                        style: TextStyle(
                            color: black1,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '⭐️ 요약의 핵심 단어',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: feedback!.frequentlyUsedWords
                            .map((text) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text(
                                    '﹒${text}',
                                    style: TextStyle(
                                        color: black1,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '🎯 포함한 핵심 내용',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: feedback!.keyPointsAddressed
                            .map((text) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Text(
                                    '﹒${text}',
                                    style: TextStyle(
                                        color: black1,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '📌 누락한 핵심 포인트',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: feedback!.misInterpretations
                            .map((text) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '${text}',
                                    style: TextStyle(
                                        color: black1,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  constraints: BoxConstraints(minHeight: 100),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '🔑 개선을 위한 조언',
                        style: TextStyle(
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: feedback!.clarifySpecificMisunderstandings
                            .map((text) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    '${text}',
                                    style: TextStyle(
                                        color: black1,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
    );
  }
}
