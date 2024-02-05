import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/models/user.dart';
import 'package:dopamine_defense_1/providers/today/today_state.dart';
import 'package:dopamine_defense_1/repositories/read_repository.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import '../../functions.dart';
import '../../models/defense.dart';
import '../../models/read.dart';
import '../../repositories/defense_repository.dart';

class TodayProvider extends StateNotifier<TodayState> with LocatorMixin {
  TodayProvider() : super(TodayState.initial());

  // 오늘의 디펜스,참여현황을 가져옴
  Future<void> getToday({required UserModel user}) async {
    try {
      DefenseModel todayDefense = await read<DefenseRepository>()
          .getTodayDefense(
              course: user.level,
              day: getDateDifference(user.date, getCurrentDate()));

      try {
        List<ReadModel> todayReads = await read<ReadRepository>()
            .getReadByDefense(defenseId: todayDefense.id);

        try {
          List<int> readRate = await read<DefenseRepository>()
              .getTodayRate(day: getCurrentDate());
          state = state.copyWith(
              todayStatus: TodayStatus.loaded,
              todayRead: todayReads,
              todayDefense: todayDefense,
              todayRate: readRate);
        } on CustomError catch (e) {
          state = state.copyWith(error: e, todayStatus: TodayStatus.error);
        }
      } on CustomError catch (e) {
        state = state.copyWith(error: e, todayStatus: TodayStatus.error);
      }
    } on CustomError catch (e) {
      state = state.copyWith(error: e, todayStatus: TodayStatus.error);
    }
  }

  List<ReadModel> getTopDefense() {
    List<ReadModel> reads = state.todayRead;
    reads.sort((a, b) => b.score.compareTo(a.score));
    List<ReadModel> topReads = reads.take(3).toList();
    ReadModel top1 = topReads.isEmpty ? ReadModel.initial() : topReads[0];
    ReadModel top2 = topReads.length < 2 ? ReadModel.initial() : topReads[1];
    ReadModel top3 = topReads.length < 3 ? ReadModel.initial() : topReads[2];
    return [top1, top2, top3];
  }

  void addTodayRead(ReadModel read) {
    state = state.copyWith(todayRead: [...state.todayRead, read]);
  }

  int calculatePercentile(int myScore) {
    List scores = state.todayRead.map((e) => e.score).toList();

    // 점수를 오름차순으로 정렬합니다.
    scores.sort();

    // 자신의 점수가 배열에서 어느 위치에 있는지 찾습니다.
    int myIndex = scores.indexOf(myScore);

    // 상위 몇 퍼센트에 해당하는지 계산합니다.
    double percentile = scores.isEmpty
        ? 1
        : (scores.length - myIndex - 1) / (scores.length) * 100;
    return percentile == 0 ? 1 : percentile.ceil();
  }

  int get avgScore {
    double sum = state.todayRead
        .fold(0, (previousValue, element) => previousValue + element.score);

    return state.todayRead.isEmpty ? 0 : (sum / state.todayRead.length).floor();
  }
}
