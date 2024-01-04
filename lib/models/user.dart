import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/main.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String grade;
  final String level;
  final int time;
  final int word;
  final String date;

  UserModel(
      {required this.id,
      required this.name,
      required this.grade,
      required this.level,
      required this.time,
      required this.word,
      required this.date});

  factory UserModel.fromDoc(var userDoc) {
    final userData = userDoc as Map<String, dynamic>?;
    print(userData);

    return UserModel(
        id: userData!['id'],
        name: userData['name'] ?? '',
        grade: userData['grade'] ?? '',
        level: userData['level'] ?? '',
        time: userData['time'] ?? 0,
        word: userData['word'] ?? 0,
        date: userData['date'] ?? getCurrentDate());
  }

  // 어떤 state에서 유저정보를 읽어올 때,
  // 앱이 시작될 때는 서버에서 데이터를 읽어오기 전이기에
  // user 관련정보는 null이 되고 로그아웃 할 때도 null 이 된다.
  // null을 허용하면, 귀찮은 일이 많이 생길 수 있어서
  // 겹칠 염려가 없는 non-null user를 사용하기 위해서 해당 initialuser()를 만듦
  factory UserModel.initialUser() {
    return UserModel(
        id: '', name: '', grade: '', level: '', time: 0, word: 0, date: '');
  }

  @override
  List<Object> get props {
    return [id, name, grade, level, date];
  }

  @override
  bool get stringify => true;
}