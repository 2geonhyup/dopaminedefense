import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/custom_error.dart';
import '../models/user.dart';

class ProfileRepository {
  final SupabaseClient supabaseClient;
  ProfileRepository({
    required this.supabaseClient,
  });

  Future<UserModel> getProfile({required String id}) async {
    print(supabaseClient.auth.currentUser!.email);
    try {
      final profileData = await supabaseClient
          .from('ProfileData')
          .select()
          .eq('id', supabaseClient.auth.currentUser!.email)
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
