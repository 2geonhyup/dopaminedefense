import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/pages/feedback_page.dart';
import 'package:dopamine_defense_1/pages/score_view.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:dopamine_defense_1/widgets/re_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';
import '../models/read.dart';
import '../providers/read/read_list_provider.dart';
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
    String userId = context.read<ProfileState>().user.id;
    bool loaded = false; //로딩되었는지
    List<ReadModel> reads = context.read<ReadListState>().reads;
    ReadModel todayRead = reads.last;
    // 화면 크기와 상관없이 위젯들 왼쪽 패딩 크기를 맞추기 위함
    double leftPaddingSize = (MediaQuery.of(context).size.width - 342) / 2;

    // 리드의 마지막 부분이 비었다면, 에러가 발생한 것
    if (reads.isEmpty ||
        todayRead.defenseId != context.read<TodayState>().todayDefense.id) {
      return const ReloadingScreen(text: "죄송합니다. 다시 로딩해주세요.");
    }

    // 이미 로딩된 경우, streambuilder없이 반환
    if (todayRead.readStatus == ReadStatus.end) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ScoreLayout(
            loaded: true,
            leftPaddingSize: leftPaddingSize,
            todayRead: todayRead),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: supabaseClient
              .from('AppReadData')
              .stream(primaryKey: ['id']).eq('user_id', userId),
          builder: (context, snapshot) {
            ReadModel dbLastRead = ReadModel.initial(); // 디비 상 유저가 마지막으로 읽은 것

            // 무언가가 로딩 된 경우
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data!.isNotEmpty) {
              dbLastRead = ReadModel.fromDoc(snapshot.data!.last);
              // 디비에서 마지막으로 읽은 것과 방금 읽은 것이 같다면, 로딩 완료된 것
              if (dbLastRead.defenseId == todayRead.defenseId && !loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context
                      .read<ReadListProvider>()
                      .feedbackEnd(newRead: dbLastRead);
                  setState(() {});
                });
                todayRead = dbLastRead;
                loaded = true;
              }
            }

            // 로딩 중이거나 채점 완료
            return ScoreLayout(
                loaded: loaded,
                leftPaddingSize: leftPaddingSize,
                todayRead: todayRead);
          }),
    );
  }
}

class ScoreLayout extends StatelessWidget {
  final bool loaded;
  final double leftPaddingSize;
  final ReadModel todayRead;
  const ScoreLayout(
      {Key? key,
      required this.loaded,
      required this.leftPaddingSize,
      required this.todayRead})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 위 기준 정렬
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height > 800 ? 132 : 60,
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
                        color: greyE, borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        getDateWithWeekday(),
                        style: regularGrey14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
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
              const SizedBox(
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
            const SizedBox(
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
                  ? const Icon(
                      Icons.remove_red_eye,
                    )
                  : const Padding(
                      padding: EdgeInsets.only(left: 4.0),
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
            const SizedBox(
              height: 34,
            ),
          ],
        ),
      ],
    );
  }
}
