import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/service_locator.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

/// Auth state machine consumed by the router for redirect logic.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);
  final UserModel user;
}

class Unauthenticated extends AuthState {
  const Unauthenticated([this.error]);
  final String? error;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthInitial()) {
    final user = _repo.currentUser();
    state = user != null ? Authenticated(user) : const Unauthenticated();
  }

  final AuthRepository _repo;

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _repo.login(email, password);
    state = result.when(
      success: Authenticated.new,
      failure: (f) => Unauthenticated(f.message),
    );
  }

  Future<void> loginAsGuest() async {
    state = const AuthLoading();
    final result = await _repo.loginAsGuest();
    state = result.when(
      success: Authenticated.new,
      failure: (f) => Unauthenticated(f.message),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const Unauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(sl<AuthRepository>()),
);
