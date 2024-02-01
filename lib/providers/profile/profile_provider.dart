// import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';
import '../../repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin {
  ProfileProvider() : super(ProfileState.initial());

  Future<void> getProfile({required String uid}) async {
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

  Future<void> setTrial() async {
    try {
      await read<ProfileRepository>().setTrial(user: state.user);
      state = state.copyWith(user: state.user.copyWith(trial: true));
    } on CustomError catch (e) {
      print("profilestate:${state}");
    }
  }

  Future<void> setTime({required String push}) async {
    try {
      await read<ProfileRepository>().setPushTime(user: state.user, push: push);
      state = state.copyWith(user: state.user.copyWith(push: push));
      print(state.user);
    } on CustomError catch (e) {
      print("profilestate:${state}");
    }
  }

  void setSubscribe() {
    final UserModel user = state.user;
    state = state.copyWith(user: user.copyWith(entitlementIsActive: true));
    print(state.user);
  }

  Future<void> removeProfile() async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      await read<ProfileRepository>().removeProfile(user: state.user);
      state = ProfileState.initial();
      print("profilestate:${state}");
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
      print("profilestate:${state}");
    }
  }
}
