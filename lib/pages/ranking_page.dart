import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/pages/time_select_page.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/read.dart';
import '../models/user.dart';
import '../providers/profile/profile_state.dart';
import '../providers/today/today_state.dart';
import '../utils/error_dialog.dart';
import 'loading_page.dart';

class RankingPage extends StatefulWidget {
  final ReadModel myRead;
  const RankingPage({Key? key, required this.myRead}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late final TodayProvider todayProv;
  late final void Function() _removeListener;
  void _getToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TodayProvider>()
          .getToday(user: context.read<ProfileState>().user);
    });
  }

  void errorDialogListener(TodayState state) {
    if (state.todayStatus == TodayStatus.error) {
      errorDialog(context, state.error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todayProv = context.read<TodayProvider>();
    _removeListener =
        todayProv.addListener(errorDialogListener, fireImmediately: false);
    _getToday();
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayState = context.watch<TodayState>();

    List<ReadModel> todayReads = context.read<TodayProvider>().getTopDefense();
    ReadModel? top1 = todayReads.isEmpty ? null : todayReads[0];
    ReadModel? top2 = todayReads.length < 2 ? null : todayReads[1];
    ReadModel? top3 = todayReads.length < 3 ? null : todayReads[2];
    final UserModel user = context.watch<ProfileState>().user;
    return Scaffold(
      body: todayState.todayStatus == TodayStatus.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: "오늘의 ", style: subTitleStyle),
                          TextSpan(
                              text: "BEST 디펜스",
                              style: subTitleStyle.copyWith(color: pointColor))
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          color: backGrey,
                          child: Text(
                            '${todayReads[0].summary}',
                            style:
                                textStyle.copyWith(color: black1, height: 1.7),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("🥇 ${top1 == null ? 0 : top1.score}",
                              style: subTitleStyle),
                          SizedBox(
                            width: 20,
                          ),
                          Text("🥈 ${top2 == null ? 0 : top2.score}",
                              style: subTitleStyle),
                          SizedBox(
                            width: 20,
                          ),
                          Text("🥉 ${top3 == null ? 0 : top3.score}",
                              style: subTitleStyle)
                        ],
                      ),
                    ],
                  ),
                ),
                NavigateButton(
                    onPressed: () {
                      //trial은 푸쉬알림 설정할 때 같이 설정됨.
                      if (user.trial) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoadingPage()));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TimeSelectPage())); //구독하고 시간선택은 안한 경우
                      }
                    },
                    text: "돌아가기",
                    foregroundColor: Colors.white,
                    backgroundColor: black1),
                SizedBox(
                  height: 26,
                ),
              ],
            ),
    );
  }
}
