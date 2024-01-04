import 'dart:convert';

import 'package:dopamine_defense_1/models/feedback.dart';
import 'package:equatable/equatable.dart';

enum ReadStatus { end, process, error }

class ReadModel extends Equatable {
  final String date;
  final int time;
  final int length;
  final int defenseId;
  final ReadStatus readStatus;
  final FeedbackModel feedback;
  final int score;

  const ReadModel({
    required this.date,
    required this.time,
    required this.length,
    required this.defenseId,
    required this.readStatus,
    required this.feedback,
    required this.score,
  });

  factory ReadModel.fromDoc(var readDoc) {
    final readData = readDoc as Map<String, dynamic>?;
    return ReadModel(
        date: readData!["created_at"] ?? '',
        time: readData["time"] ?? 0,
        length: readData["length"] ?? 0,
        defenseId: readData["text_id"] ?? 0,
        readStatus: ReadStatus.end,
        score: readData["score"] ?? 0,
        feedback: readData["feedback"] == null
            ? FeedbackModel.initialFeedback()
            : FeedbackModel.fromJson(jsonDecode(readData["feedback"])));
  }

  ReadModel copyWith({
    String? date,
    int? time,
    int? length,
    int? defenseId,
    ReadStatus? readStatus,
    FeedbackModel? feedback,
    int? score,
  }) {
    return ReadModel(
        date: date ?? this.date,
        time: time ?? this.time,
        length: length ?? this.length,
        defenseId: defenseId ?? this.defenseId,
        readStatus: readStatus ?? this.readStatus,
        feedback: feedback ?? this.feedback,
        score: score ?? this.score);
  }

  @override
  List<Object> get props {
    return [date, time, length, defenseId, readStatus, feedback, score];
  }

  @override
  bool get stringify => true;
}
