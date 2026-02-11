import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// User roles
enum UserRole { citizen, admin, auditor }

// User model
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String yojanaId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.yojanaId,
  });

  @override
  List<Object?> get props => [id, name, email, role, yojanaId];
}

// Auth states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String token;

  const Authenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class Loading extends AuthState {}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(Unauthenticated());

  Future<void> login(String username, String password) async {
    state = Loading();

    try {
      // TODO: Implement actual authentication
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: 'user_123',
        name: 'Test User',
        email: 'test@example.com',
        role: UserRole.citizen,
        yojanaId: 'YID-TEST-123',
      );

      final token = 'mock-jwt-token';
      state = Authenticated(user: user, token: token);
    } catch (e) {
      state = Unauthenticated();
      rethrow;
    }
  }

  void logout() {
    state = Unauthenticated();
  }
}

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
