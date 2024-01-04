import 'package:supabase_flutter/supabase_flutter.dart';

import '../functions.dart';
import '../models/custom_error.dart';
import '../models/user.dart';
import '../utils/supabase_manager.dart';

class ProfileRepository {
  final SupabaseClient supabaseClient;
  ProfileRepository({
    required this.supabaseClient,
  });

  Future<UserModel> getProfile({required String id}) async {
    var manager = SupabaseManager(supabaseClient);
    // 해당 값이 존재하지 않을 때만 insert
    await manager.findAndInsertIfNotExists('ProfileData', id, {
      'id': id,
      'date': getCurrentDate(),
      'grade': "모름",
      "level": "모름",
      "name": "모름"
    });
    try {
      final profileData = await supabaseClient
          .from('ProfileData')
          .select()
          .eq('id', supabaseClient.auth.currentUser!.email.toString())
          .limit(1);
      print(profileData);
      if (profileData.isNotEmpty) {
        final UserModel currentUser = UserModel.fromDoc(profileData[0]);

        return currentUser;
      }

      throw CustomError(
        code: 'Exception',
        message: "유저를 찾을 수 없습니다",
        plugin: 'flutter_error/server_error',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> setProfile({required UserModel user}) async {
    try {
      await supabaseClient.from('ProfileData').update({
        'name': user.name,
        'grade': user.grade,
        'level': user.level
      }).match({'id': user.id});
    } catch (e) {
      print(e.toString());
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
