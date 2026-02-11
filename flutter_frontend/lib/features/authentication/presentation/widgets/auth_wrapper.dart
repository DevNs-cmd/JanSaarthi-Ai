import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Show loading indicator while checking auth state
    if (authState.isLoading && authState.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show login screen if not authenticated
    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }

    // Show main app if authenticated
    return child;
  }
}

class RoleGuard extends ConsumerWidget {
  final Widget child;
  final bool adminOnly;

  const RoleGuard({super.key, required this.child, this.adminOnly = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final isCitizen = ref.watch(isCitizenProvider);

    if (adminOnly && !isAdmin) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block, size: 64.0, color: Colors.red),
              SizedBox(height: 16.0),
              Text(
                'Access Denied',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'You do not have permission to access this section.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (!adminOnly && !isCitizen && !isAdmin) {
      return const Scaffold(body: Center(child: Text('Invalid user role')));
    }

    return child;
  }
}
