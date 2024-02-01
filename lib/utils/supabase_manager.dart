import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  final SupabaseClient supabase;

  SupabaseManager(this.supabase);

  Future<bool> findAndInsertIfNotExists(
      String table, String id, Map<String, dynamic> data) async {
    // 테이블에서 해당 ID를 찾습니다.
    final findResponse = await supabase.from(table).select().eq('id', id);

    // 데이터가 없으면 새로운 row를 추가합니다.
    if (findResponse == null || findResponse.isEmpty) {
      print("cant");
      await supabase.from(table).insert(data);
      return false; // 새로운 데이터 insert 시 false
    }
    return true; // 원래 데이터가 있었으면 true
  }
}
