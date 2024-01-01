// import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/profile_repository.dart';
import 'profile_state.dart';

// class ProfileProvider with ChangeNotifier {
class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  ProfileProvider() : super(ProfileState.initial());

  Future<void> getProfile({required String uid}) async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      final UserModel user =
          await read<ProfileRepository>().getProfile(id: uid);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
      print("profilestate:${state}");
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      print("profilestate:${state}");
    }
  }

  Future<void> setProfile({required UserModel user}) async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      await read<ProfileRepository>().setProfile(user: user);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
      print("profilestate:${state}");
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      print("profilestate:${state}");
    }
  }
}
