enum UserRole { citizen, admin }

class AuthUser {
  final String userId;
  final String username;
  final UserRole role;
  final String accessToken;
  final String refreshToken;
  final DateTime tokenExpiry;

  AuthUser({
    required this.userId,
    required this.username,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpiry,
  });

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiry);

  AuthUser copyWith({
    String? userId,
    String? username,
    UserRole? role,
    String? accessToken,
    String? refreshToken,
    DateTime? tokenExpiry,
  }) {
    return AuthUser(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      role: role ?? this.role,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpiry: tokenExpiry ?? this.tokenExpiry,
    );
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String userId;
  final String username;
  final UserRole role;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.userId,
    required this.username,
    required this.role,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.citizen,
      ),
    );
  }
}
