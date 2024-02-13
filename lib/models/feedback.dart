import 'package:equatable/equatable.dart';

class FeedbackModel extends Equatable {
  final String comprehensiveFeedback;
  final List<String> clarifySpecificMisunderstandings;
  final List<String> frequentlyUsedWords;
  final Map<String, dynamic> inferredStudentSummary;
  final List<String> misInterpretations;
  final List<String> keyPointsAddressed;

  const FeedbackModel({
    required this.comprehensiveFeedback, // 종합 피드백
    required this.clarifySpecificMisunderstandings, //나만을 위한 🔑 포인트
    required this.frequentlyUsedWords, // 자주 사용한 단어
    required this.inferredStudentSummary, // 내 요약 다시보기
    required this.misInterpretations, //📌 더 살펴볼 포인트
    required this.keyPointsAddressed, //🎯 내 요약의 주요 포인트
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      comprehensiveFeedback:
          json['Comprehensive Feedback'] ?? 'No feedback available',
      clarifySpecificMisunderstandings: List<String>.from(
          json['Personalized Reflection Points']
                  ?['Clarify Specific Misunderstandings'] ??
              []),
      frequentlyUsedWords:
          List<String>.from(json['Frequently Used Words'] ?? []),
      inferredStudentSummary: json['Summary Analysis']
                  ['Inferred Student\'s Summary Structure']
              as Map<String, dynamic>? ??
          {},
      misInterpretations: List<String>.from(
          json['Summary Analysis']?['Misinterpretations'] ?? []),
      keyPointsAddressed: List<String>.from(
          json['Summary Analysis']?['Key Points Addressed'] ?? []),
    );
  }

  factory FeedbackModel.initialFeedback() {
    return const FeedbackModel(
      comprehensiveFeedback: '',
      clarifySpecificMisunderstandings: [],
      frequentlyUsedWords: [],
      inferredStudentSummary: {},
      misInterpretations: [],
      keyPointsAddressed: [],
    );
  }

  @override
  List<Object> get props {
    return [
      comprehensiveFeedback,
      clarifySpecificMisunderstandings,
      frequentlyUsedWords,
      inferredStudentSummary,
      misInterpretations,
      keyPointsAddressed,
    ];
  }

  @override
  bool get stringify => true;

  FeedbackModel copyWith({
    String? comprehensiveFeedback,
    List<String>? clarifySpecificMisunderstandings,
    List<String>? frequentlyUsedWords,
    Map<String, dynamic>? inferredStudentSummary,
    List<String>? misInterpretations,
    List<String>? keyPointsAddressed,
  }) {
    return FeedbackModel(
      comprehensiveFeedback:
          comprehensiveFeedback ?? this.comprehensiveFeedback,
      clarifySpecificMisunderstandings: clarifySpecificMisunderstandings ??
          this.clarifySpecificMisunderstandings,
      frequentlyUsedWords: frequentlyUsedWords ?? this.frequentlyUsedWords,
      inferredStudentSummary:
          inferredStudentSummary ?? this.inferredStudentSummary,
      misInterpretations: misInterpretations ?? this.misInterpretations,
      keyPointsAddressed: keyPointsAddressed ?? this.keyPointsAddressed,
    );
  }
}
