import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/models/feedback.dart';
import 'package:dopamine_defense_1/models/read.dart';
import 'package:dopamine_defense_1/providers/read/read_state.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/read_repository.dart';

class ReadListProvider extends StateNotifier<ReadListState> with LocatorMixin {
  ReadListProvider() : super(ReadListState.initial());

  // //저장
  // void summarySave({required String read}) {
  //   state = state.copyWith(
  //     read: read,
  //   );
  // }

  Future<void> getRead({required String userId}) async {
    if (state != ReadListState.initial()) return; // 서버에서 처음가져올 때만 적용
    try {
      final newReads =
          await read<ReadRepository>().getReadByUser(userId: userId);
      state = state.copyWith(reads: newReads);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeRead({required String userId}) async {
    try {
      await read<ReadRepository>().removeReadByUser(userId: userId);
      state = ReadListState.initial();
    } catch (e) {
      rethrow;
    }
  }

  //제출 -> complete 바뀜
  Future<void> summarySubmit(
      {required String summary,
      required UserModel user,
      required int time,
      required DefenseModel defense}) async {
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

      state = state.copyWith(reads: newReads);
      print(state.reads.last);
    } on CustomError catch (e) {
      ReadModel lastRead = newReads.removeLast();
      newReads.add(lastRead.copyWith(
        readStatus: ReadStatus.error,
      ));
      state = state.copyWith(reads: newReads, error: e);
    }
  }
}
