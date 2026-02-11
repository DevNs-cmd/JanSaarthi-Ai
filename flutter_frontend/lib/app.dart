import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/auth_state.dart';
import 'shared/theme/app_theme.dart';
import 'routes.dart';

class JanSaarthiApp extends ConsumerWidget {
  const JanSaarthiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'JanSaarthi AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: _buildHome(authState),
      routes: Routes.routes,
    );
  }

  Widget _buildHome(AuthState authState) {
    if (authState is Unauthenticated) {
      return const LoginScreen();
    } else if (authState is Authenticated) {
      return _buildMainApp(authState.user.role);
    } else {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }

  Widget _buildMainApp(UserRole role) {
    switch (role) {
      case UserRole.citizen:
        return const CitizenDashboard();
      case UserRole.admin:
        return const AdminDashboard();
      case UserRole.auditor:
        return const AuditorDashboard();
    }
  }
}
