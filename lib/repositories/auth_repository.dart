import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/custom_error.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepository({
    required this.supabaseClient,
  });

  Stream<AuthState?> get authState => supabaseClient.auth.onAuthStateChange;

  Future<void> signIn() async {
    try {
      await supabaseClient.auth.signInWithOAuth(
        OAuthProvider.kakao,
        authScreenLaunchMode: LaunchMode.inAppWebView,
        redirectTo:
            kIsWeb ? null : 'io.supabase.dopaminedefense://login-callback',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> signInWithApple() async {
    final rawNonce = supabaseClient.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const AuthException(
            'Could not find ID Token from generated credential.');
      }
      try {
        await supabaseClient.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
          nonce: rawNonce,
        );
      } catch (e) {
        throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error',
        );
      }
    } catch (e) {
      throw CustomError(
        code: '중도포기',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
