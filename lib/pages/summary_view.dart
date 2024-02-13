import 'package:dopamine_defense_1/pages/score_page.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/read/read_list_provider.dart';

class SummaryField extends StatefulWidget {
  const SummaryField({Key? key}) : super(key: key);

  @override
  State<SummaryField> createState() => _SummaryFieldState();
}

class _SummaryFieldState extends State<SummaryField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1, color: greyC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 25),
                child: Text(
                  "원문의 핵심을 간단히 요약해주세요",
                  style: mediumWhite14.copyWith(color: greyA),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                TextFormField(
                  maxLines: null,
                  controller: _textEditingController,
                  keyboardType: TextInputType.text,
                  style: mediumGrey3_16,
                  maxLength: 200,
                  cursorHeight: 25,
                  cursorColor: grey3,
                  cursorWidth: 1,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      hintText: '200자 이내로 요약해주시면 AI의 피드백이 제공됩니다.\n\n',
                      hintStyle: mediumLightGreyC16, // 힌트 텍스트 색상
                      hintMaxLines: 3,
                      counterText: "",
                      labelStyle: mediumGrey3_16,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: greyE, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: greyE, width: 1))),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${_textEditingController.text.length}/200",
                      style: numberStyle.copyWith(fontSize: 14, color: greyA),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 23,
          ),
          // 제출 버튼
          NavigateButton(
            onPressed: () {
              if (_textEditingController.text.length > 20) {
                context.read<ReadListProvider>().summarySubmit(
                      summary: _textEditingController.text,
                      time: 300,
                    );
                Navigator.pushReplacementNamed(context, ScorePage.routeName);
              }
            },
            text: "제출하기",
            backgroundColor:
                _textEditingController.text.length > 20 ? orangePoint : greyA,
          ),
          const SizedBox(
            height: 34,
          ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final int seconds;
  const TimerWidget({Key? key, required this.seconds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: 62,
      child: Stack(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
                color: black1, borderRadius: BorderRadius.circular(10)),
          ),
          Center(
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 5.88,
                value: seconds >= 300 ? 1 : seconds.toDouble() / 300,
                backgroundColor: greyE,
                color: orangePoint,
              ),
            ),
          ),
          Center(
            child: Text(
              formatTime(),
              style: numberStyle.copyWith(fontSize: 12, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime() {
    // 총 타이머 시간 (5분)에서 지난 시간을 뺍니다.
    int remainingSeconds = 300 - seconds;

    // 남은 시간을 분과 초로 변환합니다.
    int min = remainingSeconds ~/ 60;
    int sec = remainingSeconds % 60;

    return seconds >= 300
        ? '끝'
        : '${min.toString()}:${sec.toString().padLeft(2, '0')}';
  }
}
