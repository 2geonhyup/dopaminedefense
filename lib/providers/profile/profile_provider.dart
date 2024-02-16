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
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
    }
  }

  Future<void> setProfile({required UserModel user}) async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      await read<ProfileRepository>().setProfile(user: user);
      state = state.copyWith(profileStatus: ProfileStatus.loaded, user: user);
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
    }
  }

  Future<void> setTrial() async {
    try {
      await read<ProfileRepository>().setTrial(user: state.user);
      state = state.copyWith(user: state.user.copyWith(trial: true));
    } on CustomError {
      rethrow;
    }
  }

  Future<void> removeTrial() async {
    try {
      await read<ProfileRepository>().removeTrial(user: state.user);
      state = state.copyWith(user: state.user.copyWith(trial: false));
    } on CustomError {
      rethrow;
    }
  }

  Future<void> setTime({required String push}) async {
    print("settime");
    try {
      await read<ProfileRepository>().setPushTime(user: state.user, push: push);
      state = state.copyWith(user: state.user.copyWith(push: push));
    } on CustomError {
      rethrow;
    }
  }

  // void setSubscribe() {
  //   final UserModel user = state.user;
  //   state = state.copyWith(user: user.copyWith(entitlementIsActive: true));
  // }

  Future<void> removeProfile() async {
    state = state.copyWith(profileStatus: ProfileStatus.loading);
    try {
      await read<ProfileRepository>().removeProfile(user: state.user);
      state = ProfileState.initial();
    } on CustomError catch (e) {
      state = state.copyWith(profileStatus: ProfileStatus.error, error: e);
    }
  }
}
