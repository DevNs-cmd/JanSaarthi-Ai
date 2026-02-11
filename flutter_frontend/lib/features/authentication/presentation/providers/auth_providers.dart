import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/auth_entities.dart';
import '../../data/repositories/auth_repository.dart';

// Authentication State
class AuthState {
  final AuthUser? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({AuthUser? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.role == UserRole.admin;
  bool get isCitizen => user?.role == UserRole.citizen;
}

// Authentication Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null && !user.isTokenExpired) {
        state = state.copyWith(user: user, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.login(
        LoginRequest(username: username, password: password),
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.logout();
      state = state.copyWith(user: null, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshToken() async {
    if (state.user?.refreshToken != null) {
      try {
        final newUser = await _authRepository.refreshToken(
          state.user!.refreshToken,
        );
        state = state.copyWith(user: newUser);
      } catch (e) {
        // Token refresh failed, logout user
        await logout();
      }
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(authStateProvider).user;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAdmin;
});

final isCitizenProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isCitizen;
});
