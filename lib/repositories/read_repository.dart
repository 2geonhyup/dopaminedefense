import 'dart:convert';
import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart';
import '../models/read.dart';
import '../models/user.dart';

String _url = 'ebneycbqwtuhyxggghia.supabase.co';

class ReadRepository {
  final SupabaseClient supabaseClient;

  ReadRepository({required this.supabaseClient});

  Stream readListByUser({required String userId}) async* {
    yield supabaseClient
        .from('AppReadData')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .toList();
  }

  Future<List<ReadModel>> getReadByUser({required String userId}) async {
    try {
      final data = await supabaseClient
          .from('AppReadData')
          .select()
          .eq('user_id', userId)
          .order('text_id', ascending: true) as List;
      List<ReadModel> appReadData = data.map((e) {
        return ReadModel.fromDoc(e);
      }).toList();
      return appReadData;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> removeReadByUser({required String userId}) async {
    try {
      await supabaseClient.from('AppReadData').delete().eq('user_id', userId);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List<ReadModel>> getReadByDefense({required int defenseId}) async {
    try {
      final data = await supabaseClient
          .from('AppReadData')
          .select()
          .eq('text_id', defenseId) as List;
      List<ReadModel> appReadData = data.map((e) {
        return ReadModel.fromDoc(e);
      }).toList();
      return appReadData;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> sendSummary(
      {required DefenseModel defense,
      required String summary,
      required int time,
      required UserModel user}) async {
    Uri uri = Uri.https(_url, '/functions/v1/post-functions');
    try {
      await post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Function-Name': 'app-submit-summary',
        },
        body: jsonEncode({
          "user_id": user.id,
          "name": user.name,
          "summary": summary,
          "text_id": defense.id,
          "time": time,
          "length": defense.content.length
        }),
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}

int allToInt(var input) {
  if (input is String) {
    var number = int.tryParse(input);
    if (number != null) {
      return number.floor();
    } else {
      return 0;
    }
  } else if (input is num) {
    return input.floor();
  } else {
    return 0;
  }
}
