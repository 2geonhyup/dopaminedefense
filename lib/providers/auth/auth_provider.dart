import 'package:state_notifier/state_notifier.dart';
import 'auth_state.dart';
import 'package:dopamine_defense_1/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.unknown());

  @override
  void update(Locator watch) async {
    final authState = watch<sp.AuthState?>();

    // authstate session 있는 경우
    if (authState != null && (authState.session != null)) {
      // 만약 변화가 있지만 이미 authenticated 되어 있다면 그냥 리턴한다
      if (state.authStatus == AuthStatus.authenticated) return;
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: authState.session!.user,
      );
    } else if (authState?.event == null) {
      state = state.copyWith(authStatus: AuthStatus.unknown);
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    super.update(watch);
  }

  void signout() async {
    await read<AuthRepository>().signOut();
  }
}
