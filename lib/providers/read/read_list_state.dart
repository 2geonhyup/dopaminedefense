import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:equatable/equatable.dart';

import '../../models/read.dart';

enum ReadListStatus {
  loading,
  loaded,
  error,
}

class ReadListState extends Equatable {
  final List<ReadModel> reads;
  final CustomError error;
  final ReadListStatus readListStatus;

  const ReadListState(
      {required this.reads, required this.error, required this.readListStatus});

  factory ReadListState.initial() {
    return const ReadListState(
        reads: [],
        error: CustomError(),
        readListStatus: ReadListStatus.loading);
  }

  @override
  List<Object> get props => [reads, error, readListStatus];

  @override
  bool get stringify => true;

  ReadListState copyWith({
    List<ReadModel>? reads,
    CustomError? error,
    ReadListStatus? readListStatus,
  }) {
    return ReadListState(
        reads: reads ?? this.reads,
        error: error ?? this.error,
        readListStatus: readListStatus ?? this.readListStatus);
  }
}
