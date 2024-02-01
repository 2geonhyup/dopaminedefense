import 'package:action_slider/action_slider.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/pages/login_page.dart';
import 'package:dopamine_defense_1/pages/score_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/pages/time_select_page.dart';
import 'package:dopamine_defense_1/utils/navigate_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../functions.dart';
import '../models/user.dart';
import '../providers/auth/auth_provider.dart';
import '../providers/profile/profile_provider.dart';
import '../providers/profile/profile_state.dart';
import '../providers/read/read_list_provider.dart';
import '../providers/read/read_list_state.dart';
import '../providers/today/today_state.dart';

class TodayDefenseCard extends StatelessWidget {
  const TodayDefenseCard({Key? key, required this.todayState})
      : super(key: key);
  final TodayState todayState;

  @override
  Widget build(BuildContext context) {
    final TodayStatus todayStatus = todayState.todayStatus;
    //에러가 발생했거나 로딩 중이면 공백
    if (todayStatus == TodayStatus.error ||
        todayStatus == TodayStatus.loading ||
        todayState.todayRate.isEmpty) {
      return Container(
        width: 342,
        height: 206,
        color: greyE,
      );
    }
    int readRate = todayState.todayRate[DateTime.now().hour];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 19,
          child: Text(
            getDateWithWeekday(),
            style: regularGrey16,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Container(
                width: 342,
                height: 166,
                decoration: BoxDecoration(
                    color: black1, borderRadius: BorderRadius.circular(35)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 184, top: 88),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "%의 디펜서들이 읽었어요",
                        style: mediumWhite12,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: todayState.todayDefense.tag
                              .map((e) => TagBox(
                                    text: e,
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SizedBox(
                width: 164,
                height: 164,
                child: Stack(
                  children: [
                    //중간에 살짝 비는 부분 방지
                    Center(
                      child: Container(
                        width: 3,
                        height: 3,
                        color: readRate == 0 ? grey3 : greenPoint,
                      ),
                    ),
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: readRate,
                      selectedStepSize: 82,
                      unselectedStepSize: 82,
                      selectedColor: greenPoint,
                      unselectedColor: grey3,
                      padding: 0,
                    ),
                    Center(
                      child: Text(
                        '$readRate',
                        style: numberStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TagBox extends StatelessWidget {
  final String text;
  const TagBox({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 26,
        decoration: BoxDecoration(
            color: grey7, borderRadius: BorderRadius.circular(13)),
        child: Center(
          child: Text(
            "# $text",
            style: mediumWhite14,
          ),
        ),
      ),
    );
  }
}

class ReadNavigateButton extends StatelessWidget {
  final ReadListStatus readListStatus;
  final bool todaySubmit;
  const ReadNavigateButton(
      {Key? key, required this.readListStatus, required this.todaySubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel user = context.read<ProfileState>().user;

    //에러가 발생했거나 로딩 중이면 공백
    if (readListStatus == ReadListStatus.error ||
        readListStatus == ReadListStatus.loading) {
      return Container(
        width: 342,
        height: 80,
        decoration: BoxDecoration(
            color: greyE, borderRadius: BorderRadius.circular(40)),
      );
    }
    return ActionSlider.standard(
      boxShadow: [],
      width: 342,
      height: 80,
      backgroundColor: orangePoint,
      customForegroundBuilderChild: Center(
        child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(32)),
            child: Center(
                child: Image.asset(
                    width: 30, height: 40, "assets/images/go.png"))),
      ),
      customForegroundBuilder: (context, state, child) => child!,
      action: (controller) {
        controller.setAnchorPosition(1);
        print(user.entitlementIsActive);
        // 점수 화면 - 오늘 것 요약제출을 완료한 경우 (아직 채점중이더라도)
        if (todaySubmit)
          Navigator.pushNamed(context, ScorePage.routeName);
        // 구독 화면 - 이미 한번 읽었고, 아직 구독을 하지 않은 경우
        else if (user.trial && !user.entitlementIsActive)
          Navigator.pushNamed(context, SubscribePage.routeName);
        // 글읽기 화면 - 나머지 경우 (구독을 하고 오늘 것 완료하지 않았거나, 구독을 안했는데 첫 참여인 경우)
        else
          Navigator.pushNamed(context, SummaryPage.routeName);

        controller.setAnchorPosition(0);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "오늘의 디펜스",
            style: semiBoldWhite22,
          ),
          SizedBox(
            width: 23,
          ),
          Image.asset("assets/images/three-arrow.png"),
        ],
      ),
    );
  }
}

class PopUpMenuWidget extends StatefulWidget {
  const PopUpMenuWidget({Key? key}) : super(key: key);

  @override
  State<PopUpMenuWidget> createState() => _PopUpMenuWidgetState();
}

class _PopUpMenuWidgetState extends State<PopUpMenuWidget> {
  @override
  Widget build(BuildContext context) {
    List<PopUpMenu> popUpMenuList = [
      PopUpMenu(
        index: 0,
        title: "알림 설정",
        onTap: () async {
          Navigator.pushNamed(context, TimeSelectPage.routeName);
        },
      ),
      PopUpMenu(
        index: 1,
        title: "로그아웃",
        onTap: () async {
          context.read<AuthProvider>().signout();
          Navigator.pushNamed(context, LoadingPage.routeName);
        },
      ),
      PopUpMenu(
        index: 2,
        title: "문의하기",
        onTap: () async {
          final url = Uri.parse('http://pf.kakao.com/_zmTAG/chat');
          if (await canLaunchUrl(url)) {
            launchUrl(url, mode: LaunchMode.platformDefault);
          }
        },
      ),
      PopUpMenu(
        index: 3,
        title: "계정 탈퇴",
        onTap: () async {
          functionDialog(context, "알림", "정말로 계정을 삭제하시겠습니까?", () async {
            await context.read<ReadListProvider>().removeRead();
            await context.read<ProfileProvider>().removeProfile();
            context.read<AuthProvider>().signout();
            Navigator.pushNamed(context, LoadingPage.routeName);
          });
        },
      ),
    ];
    return PopupMenuButton<String>(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        color: Colors.transparent,
        child: Image.asset(
          'assets/images/menu.png',
          width: 24,
          height: 24,
        ),
        constraints: BoxConstraints(maxWidth: 160),
        onSelected: (String result) {
          // 선택한 옵션에 따라 동작 처리
          print(result);
        },
        padding: EdgeInsets.symmetric(vertical: 0),
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) => popUpMenuList.map((e) {
              return PopupMenuItem<String>(
                height: 44,
                padding: EdgeInsets.zero,
                onTap: e.onTap,
                value: e.title,
                child: Container(
                    height: 44,
                    width: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(e.index == 0 ? 5 : 0),
                            bottom: Radius.circular(e.index == 3 ? 5 : 0)),
                        color: Colors.white,
                        border: Border(
                            left: BorderSide(width: 0.5, color: greyC),
                            right: BorderSide(width: 0.5, color: greyC),
                            bottom: BorderSide(width: 0.5, color: greyC),
                            top: e.index == 0
                                ? BorderSide(width: 0.5, color: greyC)
                                : BorderSide.none)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          e.title,
                          style: regularBlack16,
                        ),
                      ],
                    )),
              );
            }).toList());
  }
}

class PopUpMenu {
  final String title;
  final Function() onTap;

  final int index;

  const PopUpMenu(
      {required this.title, required this.onTap, required this.index});
}
