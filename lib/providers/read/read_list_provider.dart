import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/models/feedback.dart';
import 'package:dopamine_defense_1/models/read.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/read/read_list_state.dart';
import 'package:dopamine_defense_1/providers/today/today_provider.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/read_repository.dart';
import '../profile/profile_provider.dart';

class ReadListProvider extends StateNotifier<ReadListState> with LocatorMixin {
  ReadListProvider() : super(ReadListState.initial());

  // //저장
  // void summarySave({required String read}) {
  //   state = state.copyWith(
  //     read: read,
  //   );
  // }

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
    try {
      List result = await read<ReadRepository>().sendSummary(
          summary: summary, user: user, time: time, defense: defense);

      ReadModel lastRead = newReads.removeLast();
      newReads = [
        ...newReads,
        lastRead.copyWith(
            readStatus: ReadStatus.end, feedback: result[1], score: result[0])
      ];

      // 오늘의 읽기 목록에 내가 읽은 것 추가
      read<TodayProvider>().addTodayRead(lastRead.copyWith(
          readStatus: ReadStatus.end, feedback: result[1], score: result[0]));

      // 유저가 첫 시도라면 trial을 true로 바꿈
      if (!read<ProfileState>().user.trial) {
        await read<ProfileProvider>().setTrial();
      }

      state = state.copyWith(reads: newReads);
    } on CustomError catch (e) {
      print(e.toString());
      // 채점 중 에러 발생시
      newReads.removeLast();
      state = state.copyWith(reads: newReads);
    }
  }
}
