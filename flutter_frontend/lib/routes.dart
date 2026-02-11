import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/eligibility_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/admin_dashboard_screen.dart';

// Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JanSaarthi Login'),
        backgroundColor: const Color(0xFF6B5CE7),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Login Screen - Implementation Pending',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Main Dashboard Screens
class CitizenDashboard extends StatelessWidget {
  const CitizenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminDashboardScreen();
  }
}

class AuditorDashboard extends StatelessWidget {
  const AuditorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminDashboardScreen(); // Same as admin for now
  }
}

class Routes {
  static final routes = <String, WidgetBuilder>{
    '/login': (context) => const LoginScreen(),
    '/citizen': (context) => const CitizenDashboard(),
    '/eligibility': (context) => const EligibilityScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/alerts': (context) => const AlertsScreen(),
    '/admin': (context) => const AdminDashboard(),
    '/auditor': (context) => const AuditorDashboard(),
  };
}
