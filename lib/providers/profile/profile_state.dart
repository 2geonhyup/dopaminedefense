import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';

enum ProfileStatus {
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final UserModel user;
  final CustomError error;
  ProfileState({
    required this.profileStatus,
    required this.user,
    required this.error,
  });

  factory ProfileState.initial() {
    return ProfileState(
        profileStatus: ProfileStatus.loading,
        user: UserModel.initialUser(),
        error: CustomError());
  }

  @override
  List<Object> get props => [profileStatus, user, error];

  @override
  bool get stringify => true;

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserModel? user,
    CustomError? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
