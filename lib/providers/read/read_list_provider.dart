import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/models/feedback.dart';
import 'package:dopamine_defense_1/models/read.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/read/read_list_state.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:dopamine_defense_1/repositories/profile_repository.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/read_repository.dart';
import '../profile/profile_provider.dart';

class ReadListProvider extends StateNotifier<ReadListState> with LocatorMixin {
  ReadListProvider() : super(ReadListState.initial());

  Future<void> getRead({required String userId}) async {
    // if (state != ReadListState.initial()) return; // 서버에서 처음가져올 때만 적용
    try {
      final newReads =
          await read<ReadRepository>().getReadByUser(userId: userId);
      state = state.copyWith(
          reads: newReads, readListStatus: ReadListStatus.loaded);
    } on CustomError catch (e) {
      state = state.copyWith(error: e, readListStatus: ReadListStatus.error);
    }
  }

  // 어제 읽은 것의 점수 반환, 없으면 0 반환
  int getYesterdayRead() {
    int day =
        getDateDifference(read<ProfileState>().user.date, getCurrentDate());
    int todayTextId = day + 1;
    int yesterdayTextId = todayTextId - 1;
    ReadModel yesterdayRead = state.reads.lastWhere(
        (element) => element.defenseId == yesterdayTextId,
        orElse: () => ReadModel.initial());
    return yesterdayRead.score;
  }

  Future<void> removeRead() async {
    try {
      await read<ReadRepository>()
          .removeReadByUser(userId: read<ProfileState>().user.id);
      state = ReadListState.initial();
    } catch (e) {
      rethrow;
    }
  }

  //제출 -> complete 바뀜
  Future<void> summarySubmit({
    required String summary,
    required int time,
  }) async {
    DefenseModel defense = read<TodayState>().todayDefense;
    UserModel user = read<ProfileState>().user;
    print("summarysubmit");

    final newRead = ReadModel(
        date: getCurrentDate(),
        time: time,
        length: defense.content.length,
        defenseId: defense.id,
        readStatus: ReadStatus.process,
        feedback: FeedbackModel.initialFeedback(),
        score: 0,
        summary: summary);
    List<ReadModel> newReads = [...state.reads, newRead];
    state = state.copyWith(reads: newReads);
    // 유저가 첫 시도라면 trial을 true로 바꿈
    if (!read<ProfileState>().user.trial) {
      read<ProfileProvider>().setTrial();
    }

    try {
      await read<ReadRepository>().sendSummary(
          summary: summary, user: user, time: time, defense: defense);
    } on CustomError {
      // 채점 중 에러 발생시
      newReads.removeLast();
      state = state.copyWith(reads: newReads);
    }
  }

  void feedbackEnd({required ReadModel newRead}) {
    state.reads.removeLast();
    List<ReadModel> newReads = [
      ...state.reads,
      newRead,
    ];
    state = state.copyWith(reads: newReads);

    // 오늘의 읽기 목록에 내가 읽은 것 추가
    read<TodayProvider>().addTodayRead(newRead);
  }
}
