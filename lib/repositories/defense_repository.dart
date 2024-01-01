import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/custom_error.dart';
import '../models/defense.dart';
import '../models/user.dart';

class DefenseRepository {
  final SupabaseClient supabaseClient;

  DefenseRepository({
    required this.supabaseClient,
  });

  Future<List<DefenseModel>> getCourse({required String course}) async {
    print(course);
    try {
      final List defenseData = await supabaseClient
          .from('AppDefenseData')
          .select()
          .eq('course', course)
          .order('day', ascending: true) as List;
      print(defenseData);
      List<DefenseModel> courseList = defenseData.map((defense) {
        return DefenseModel.fromDoc(defense);
      }).toList();
      return courseList;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<DefenseModel> getTodayDefense(
      //몇번째 날짜인지에 따라 가져옴
      {required String course,
      required int day}) async {
    try {
      final List defenseData = await supabaseClient
          .from('AppDefenseData')
          .select()
          .eq(
            'course',
            course,
          )
          .eq('day', day + 1) as List;
      //TODO: day에 해당하는 글 없을 때 처리하는 코드
      DefenseModel todayDefense = DefenseModel.fromDoc(defenseData[0]);
      return todayDefense;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
