import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:equatable/equatable.dart';

import '../../models/read.dart';

class ReadListState extends Equatable {
  final List<ReadModel> reads;
  final CustomError error;

  ReadListState({required this.reads, required this.error});

  factory ReadListState.initial() {
    return ReadListState(reads: [], error: CustomError());
  }

  @override
  List<Object> get props => [reads, error];

  @override
  bool get stringify => true;

  ReadListState copyWith({
    List<ReadModel>? reads,
    CustomError? error,
  }) {
    return ReadListState(
      reads: reads ?? this.reads,
      error: error ?? this.error,
    );
  }
}
