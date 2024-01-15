import 'package:dopamine_defense_1/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../functions.dart';
import '../models/custom_error.dart';
import '../models/user.dart';
import '../providers/profile/profile_state.dart';
import '../store_config.dart';
import '../utils/supabase_manager.dart';

class ProfileRepository {
  final SupabaseClient supabaseClient;
  ProfileRepository({
    required this.supabaseClient,
  });

  Future<UserModel> getProfile({required String id}) async {
    // 구독 관련 프로필 설정
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration configuration;
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = id
      ..observerMode = false;

    await Purchases.configure(configuration);
    //슈퍼베이스 프로필 설정
    var manager = SupabaseManager(supabaseClient);
    // 해당 값이 존재하지 않을 때만 insert
    await manager.findAndInsertIfNotExists('ProfileData', id, {
      'id': id,
      'date': getCurrentDate(),
      'grade': "모름",
      "level": "모름",
      "name": "모름",
    });
    try {
      final profileData = await supabaseClient
          .from('ProfileData')
          .select()
          .eq('id', supabaseClient.auth.currentUser!.email.toString())
          .limit(1);
      print(profileData);
      if (profileData.isNotEmpty) {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        bool subscribed = false;
        if (customerInfo.entitlements.all[entitlementID] != null) {
          subscribed = customerInfo.entitlements.all[entitlementID]!.isActive;
        }
        final UserModel currentUser =
            UserModel.fromDoc(profileData[0], subscribed);

        return currentUser;
      } else {
        throw CustomError(
          code: 'Exception',
          message: "유저를 못 찾겠습니다.",
          plugin: 'flutter_error/server_error',
        );
      }
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

  Future<void> setTime({required UserModel user, required String time}) async {
    print(user.id);
    try {
      await supabaseClient
          .from('ProfileData')
          .update({'push': time, "trial": true}).match({'id': user.id});
      OneSignal.login(user.id);
      OneSignal.User.addTagWithKey("time", "$time");
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
