import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

import '../models/custom_error.dart';

class AuthRepository {
  final sp.SupabaseClient supabaseClient;

  AuthRepository({
    required this.supabaseClient,
  });

  Stream<sp.AuthState?> get authState => supabaseClient.auth.onAuthStateChange;

  Future<void> signIn() async {
    try {
      await supabaseClient.auth.signInWithOAuth(
        sp.Provider.kakao,
        redirectTo:
            kIsWeb ? null : 'io.supabase.dopaminedefense1://login-callback/',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
