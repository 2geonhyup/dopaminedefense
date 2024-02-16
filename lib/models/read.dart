import 'dart:convert';

import 'package:dopamine_defense_1/models/feedback.dart';
import 'package:equatable/equatable.dart';

enum ReadStatus { end, process, error, initial }

class ReadModel extends Equatable {
  final String date;
  final int time;
  final int length;
  final int defenseId;
  final ReadStatus readStatus;
  final FeedbackModel feedback;
  final int score;
  final String summary;

  const ReadModel({
    required this.date,
    required this.time,
    required this.length,
    required this.defenseId,
    required this.readStatus,
    required this.feedback,
    required this.score,
    required this.summary,
  });

  factory ReadModel.fromDoc(var readDoc) {
    final readData = readDoc as Map<String, dynamic>?;
    FeedbackModel feedback;
    if (readData!["feedback"] == null) {
      feedback = FeedbackModel.initialFeedback();
    }
    try {
      feedback = FeedbackModel.fromJson(jsonDecode(readData["feedback"]));
    } catch (e) {
      feedback = FeedbackModel.initialFeedback()
          .copyWith(comprehensiveFeedback: readData["feedback"].toString());
    }
    return ReadModel(
        date: readData["created_at"] ?? '',
        time: readData["time"] ?? 0,
        length: readData["length"] ?? 0,
        defenseId: readData["text_id"] ?? 0,
        readStatus: ReadStatus.end,
        score: readData["score"] ?? 0,
        summary: readData["summary"] ?? '',
        feedback: feedback);
  }

  factory ReadModel.initial() {
    return ReadModel(
        date: '',
        time: 0,
        length: 0,
        defenseId: 0,
        readStatus: ReadStatus.initial,
        score: 0,
        summary: '',
        feedback: FeedbackModel.initialFeedback());
  }

  ReadModel copyWith({
    String? date,
    int? time,
    int? length,
    int? defenseId,
    ReadStatus? readStatus,
    FeedbackModel? feedback,
    int? score,
    String? summary,
  }) {
    return ReadModel(
        date: date ?? this.date,
        time: time ?? this.time,
        length: length ?? this.length,
        defenseId: defenseId ?? this.defenseId,
        readStatus: readStatus ?? this.readStatus,
        feedback: feedback ?? this.feedback,
        score: score ?? this.score,
        summary: summary ?? this.summary);
  }

  @override
  List<Object> get props {
    return [
      date,
      time,
      length,
      defenseId,
      readStatus,
      feedback,
      score,
      summary
    ];
  }

  @override
  bool get stringify => true;
}
