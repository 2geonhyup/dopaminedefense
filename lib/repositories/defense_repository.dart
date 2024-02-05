import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/custom_error.dart';
import '../models/defense.dart';

class DefenseRepository {
  final SupabaseClient supabaseClient;

  DefenseRepository({
    required this.supabaseClient,
  });

  Future<List<DefenseModel>> getCourse({required String course}) async {
    try {
      final List defenseData = await supabaseClient
          .from('AppDefenseData')
          .select()
          .eq('course', course == "모름" ? "고1 모의고사" : course)
          .order('day', ascending: true) as List;
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

  Future<List<int>> getTodayRate({required String day}) async {
    try {
      final List readRateData = await supabaseClient
          .from('AppReadRate')
          .select()
          .eq('day', DateTime.parse(day)) as List;
      List<dynamic> readRate = readRateData[0]["rate"];
      return readRate.map((item) => int.parse(item.toString())).toList();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
