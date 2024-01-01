import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:equatable/equatable.dart';

import '../../models/read.dart';

class ReadListState extends Equatable {
  final List<ReadModel> reads;

  ReadListState({required this.reads});

  factory ReadListState.initial() {
    return ReadListState(reads: []);
  }

  @override
  List<Object> get props => [reads];

  @override
  bool get stringify => true;

  ReadListState copyWith({
    List<ReadModel>? reads,
  }) {
    return ReadListState(
      reads: reads ?? this.reads,
    );
  }
}
