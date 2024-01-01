import 'package:dopamine_defense_1/main.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final sp.User? user;

  AuthState({
    required this.authStatus,
    this.user,
  });

  factory AuthState.unknown() {
    var initialStatus = supabaseClient.auth.currentSession == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    return AuthState(
      authStatus: initialStatus,
    );
  }

  @override
  List<Object?> get props => [authStatus, user];

  @override
  bool get stringify => true;

  AuthState copyWith({
    AuthStatus? authStatus,
    sp.User? user,
  }) {
    return AuthState(
        authStatus: authStatus ?? this.authStatus, user: user ?? this.user);
  }
}
