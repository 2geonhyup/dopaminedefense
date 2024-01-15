import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/models/read.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';

enum TodayStatus {
  initial,
  loading,
  success,
  error,
}

//오늘의 디펜스와 오늘의 디펜스에 대한 참여현황 저장
class TodayState extends Equatable {
  final TodayStatus todayStatus;
  final CustomError error;
  final List<ReadModel> todayRead;
  final DefenseModel todayDefense;
  final List<int> todayRate;

  const TodayState(
      {required this.todayStatus,
      required this.error,
      required this.todayRead,
      required this.todayDefense,
      required this.todayRate});

  factory TodayState.initial() {
    return TodayState(
        todayStatus: TodayStatus.initial,
        error: CustomError(),
        todayRead: [],
        todayDefense: DefenseModel.initial(),
        todayRate: []);
  }

  @override
  List<Object> get props =>
      [todayStatus, error, todayRead, todayDefense, todayRate];

  @override
  bool get stringify => true;

  TodayState copyWith({
    TodayStatus? todayStatus,
    CustomError? error,
    List<ReadModel>? todayRead,
    DefenseModel? todayDefense,
    List<int>? todayRate,
  }) {
    return TodayState(
      todayStatus: todayStatus ?? this.todayStatus,
      error: error ?? this.error,
      todayRead: todayRead ?? this.todayRead,
      todayDefense: todayDefense ?? this.todayDefense,
      todayRate: todayRate ?? this.todayRate,
    );
  }
}
