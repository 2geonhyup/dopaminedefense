import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';

import 'package:dopamine_defense_1/providers/read/read_list_state.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../amplitude_config.dart';
import '../constants.dart';
import '../functions.dart';
import '../models/read.dart';

import 'feedback_view.dart';
import 'home_page.dart';

List<Color> _colors = [
  const Color(0xff60B7B7),
  const Color(0xff966CDB),
  const Color(0xffEC9540),
  const Color(0xff94CC79)
];

List<String> _titles = ["종합 피드백", "요약 다시보기", "중요 포인트", "누락된 포인트"];

//피드백 버튼 크기, 패딩에 따라 달라짐
final List<double> feedbackButtonOffsets = [0, 100, 213, 313];

class FeedbackPage extends StatefulWidget {
  static const routeName = '/feedback';

  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selected = 0;
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  @override
  void initState() {
    //앰플리튜드 피드백 화면
    AmplitudeConfig.amplitude.logEvent("feedback-page");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = _colors[_selected];
    ReadModel myRead = context.watch<ReadListState>().reads.last;
    List<String> contents = [
      myRead.feedback.comprehensiveFeedback,
      myRead.summary,
      listToString(myRead.feedback.keyPointsAddressed),
      listToString(myRead.feedback.misInterpretations)
    ];

    return Scaffold(
      backgroundColor: selectedColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              MediaQuery.of(context).size.height > 800
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 점수 박스
                              ScoreBox(
                                score: myRead.score,
                                color: selectedColor,
                              ),
                              // 홈으로 돌아가는 x아이콘 (구독 안한 경우 구독화면 뜰 수도 있음)
                              GestureDetector(
                                onTap: () {
                                  // if (!context
                                  //     .read<ProfileState>()
                                  //     .user
                                  //     .entitlementIsActive) {
                                  //   Navigator.pushNamed(
                                  //       context, SubscribePage.routeName);
                                  // } else {
                                  //   Navigator.pushNamed(
                                  //       context, HomePage.routeName);
                                  // }
// 무료 버전
                                  Navigator.pushNamed(
                                      context, HomePage.routeName);
                                },
                                child: Image.asset(
                                  'assets/images/x_bg.png',
                                  width: 32,
                                  height: 32,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 24,
                            ),
                            Image.asset(
                              "assets/images/down-arrow.png",
                              width: 24,
                              height: 24,
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),

              const SizedBox(
                height: 32,
              ),
              // 현재 보고 있는 항목
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "자세히 보기",
                          style: semiBoldBlack24.copyWith(color: grey3),
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Image.asset(
                          "assets/images/eye.png",
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    // 홈으로 돌아가는 x아이콘 (구독 안한 경우 구독화면 뜰 수도 있음)
                    MediaQuery.of(context).size.height <= 800
                        ? GestureDetector(
                            onTap: () {
                              // if (!context
                              //     .read<ProfileState>()
                              //     .user
                              //     .entitlementIsActive) {
                              //   Navigator.pushNamed(
                              //       context, SubscribePage.routeName);
                              // } else {
                              //   Navigator.pushNamed(
                              //       context, HomePage.routeName);
                              // }
                              // 무료버전
                              Navigator.pushNamed(context, HomePage.routeName);
                            },
                            child: Image.asset(
                              'assets/images/x_bg.png',
                              width: 32,
                              height: 32,
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // 항목 버튼
              SizedBox(
                height: 32,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == 3
                              ? MediaQuery.of(context).size.width - 80
                              : 12,
                          left: index == 0 ? 24 : 0,
                        ),
                        child: FeedbackButton(
                            title: _titles[index],
                            color: _colors[index],
                            onTap: () {
                              pageController.jumpToPage(index);
                              scrollController.animateTo(
                                  feedbackButtonOffsets[index],
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease);
                              setState(() {
                                _selected = index;
                              });
                            },
                            selected: _selected == index),
                      );
                    }),
              ),
            ],
          ),
          //피드백함
          Expanded(
            child: FeedbackSlider(
              contents: contents,
              pageController: pageController,
              onPageChanged: (pageIndex) {
                scrollController.animateTo(feedbackButtonOffsets[pageIndex],
                    duration: const Duration(seconds: 1), curve: Curves.ease);
                setState(() {
                  _selected = pageIndex;
                });
              },
            ),
          ),
          const BottomScoreBox()
        ],
      ),
    );
  }
}

class FeedbackSlider extends StatelessWidget {
  final Function(int) onPageChanged;
  final List<String> contents;
  final PageController pageController;
  const FeedbackSlider(
      {Key? key,
      required this.onPageChanged,
      required this.contents,
      required this.pageController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ExpandablePageView.builder(
        onPageChanged: onPageChanged,
        controller: pageController,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 42),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      contents[index],
                      style: regularBlack16,
                    ),
                  ),
                ),
                Positioned(
                    right: 5,
                    bottom: 0,
                    child: Image.asset(
                      "assets/images/quote-close.png",
                      width: 14,
                      height: 16,
                    )),
                Positioned(
                    left: 5,
                    top: 0,
                    child: Image.asset(
                      "assets/images/quote-open.png",
                      width: 14,
                      height: 16,
                    )),
              ],
            ),
          );
        });
  }
}
