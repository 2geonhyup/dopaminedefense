import 'package:equatable/equatable.dart';

class DefenseModel extends Equatable {
  final int id;
  final String course;
  final int day;
  final int level;
  final String content;
  final List tag;
  final List source;

  const DefenseModel({
    required this.id,
    required this.course,
    required this.day,
    required this.level,
    required this.content,
    required this.tag,
    required this.source,
  });

  factory DefenseModel.fromDoc(var defenseDoc) {
    final defenseData = defenseDoc as Map<String, dynamic>;

    return DefenseModel(
      id: defenseData["id"],
      course: defenseData["course"],
      day: defenseData["day"],
      level: defenseData["level"],
      content: defenseData["content"],
      tag: defenseData["tag"],
      source: defenseData["source"],
    );
  }

  factory DefenseModel.initial() {
    return DefenseModel(
        id: -1,
        course: "",
        day: -1,
        level: -1,
        content: "",
        tag: [],
        source: []);
  }

  @override
  List<Object> get props {
    return [id, course, day, level, content, tag, source];
  }

  @override
  bool get stringify => true;
}
