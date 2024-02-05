import 'package:dopamine_defense_1/providers/sign_in/sign_in_state.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

class SignInProvider extends StateNotifier<SignInState> with LocatorMixin {
  SignInProvider() : super(SignInState.initial());

  Future<void> signIn() async {
    state = state.copyWith(signInStatus: SignInStatus.submitting);
    try {
      await read<AuthRepository>().signIn();
      state = state.copyWith(signInStatus: SignInStatus.success);
    } on CustomError catch (e) {
      state = state.copyWith(signInStatus: SignInStatus.error, error: e);
      rethrow;
    }
  }

  Future<void> appeSignIn() async {
    state = state.copyWith(signInStatus: SignInStatus.submitting);
    try {
      await read<AuthRepository>().signInWithApple();
      state = state.copyWith(signInStatus: SignInStatus.success);
    } on CustomError catch (e) {
      if (e.code == "중도포기") {
        state = SignInState.initial();
      } else {
        state = state.copyWith(signInStatus: SignInStatus.error, error: e);
        rethrow;
      }
    }
  }
}
