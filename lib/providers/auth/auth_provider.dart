import 'package:state_notifier/state_notifier.dart';
import '../../functions.dart';
import '../../main.dart';
import '../../utils/supabase_manager.dart';
import 'auth_state.dart';
import 'package:dopamine_defense_1/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.unknown());

  @override
  void update(Locator watch) async {
    final authState = watch<sp.AuthState?>();
    print(getCurrentDate());
    if (authState != null &&
        (authState.session != null ||
            authState.event == sp.AuthChangeEvent.signedIn)) {
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
        user: authState.session!.user,
      );
      var manager = SupabaseManager(supabaseClient);
      // 해당 값이 존재하지 않을 때만 insert
      await manager.findAndInsertIfNotExists(
          'ProfileData',
          authState.session!.user.email!,
          {'id': authState.session!.user.email!, 'date': getCurrentDate()});
    } else {
      state = state.copyWith(authStatus: AuthStatus.unauthenticated);
    }
    print('authState: $state');
    super.update(watch);
  }

  void signout() async {
    await read<AuthRepository>().signOut();
  }
}
