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
    state = state.copyWith(todayStatus: TodayStatus.loading);

    try {
      DefenseModel todayDefense = await read<DefenseRepository>()
          .getTodayDefense(
              course: user.level,
              day: getDateDifference(user.date, getCurrentDate()));

      try {
        List<ReadModel> todayReads = await read<ReadRepository>()
            .getReadByDefense(defenseId: todayDefense.id);
        state = state.copyWith(
            todayStatus: TodayStatus.success,
            todayRead: todayReads,
            todayDefense: todayDefense);
      } on CustomError catch (e) {
        state = state.copyWith(error: e, todayStatus: TodayStatus.error);
      }
    } on CustomError catch (e) {
      state = state.copyWith(error: e, todayStatus: TodayStatus.error);
    }
  }
}
