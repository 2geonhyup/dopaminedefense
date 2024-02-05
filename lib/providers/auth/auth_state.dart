import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final sp.User? user;

  const AuthState({
    required this.authStatus,
    this.user,
  });

  factory AuthState.unknown() {
    var initialStatus = AuthStatus.unknown;
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
