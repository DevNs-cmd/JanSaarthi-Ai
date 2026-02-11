import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/authentication/presentation/providers/auth_providers.dart';
import '../features/citizen_profile/presentation/screens/citizen_profile_screen.dart';
import '../features/eligibility/presentation/screens/eligibility_screen.dart';
import '../features/authentication/domain/auth_entities.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JanSaarthi AI'),
        backgroundColor: const Color(0xFF6B5CE7),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: const HomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6B5CE7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Eligibility',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          if (currentUser?.role == UserRole.admin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          const Text(
            'Welcome to JanSaarthi AI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Government Digital Infrastructure Platform',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Service cards grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildServiceCard(
                context,
                'Check Benefits',
                Icons.document_scanner,
                'Eligibility Assessment',
                const EligibilityScreen(),
              ),
              _buildServiceCard(
                context,
                'Jobs & Skills',
                Icons.work,
                'Employment Schemes',
                null,
              ),
              _buildServiceCard(
                context,
                'Health & Edu',
                Icons.school,
                'Welfare Programs',
                null,
              ),
              _buildServiceCard(
                context,
                'Agriculture',
                Icons.agriculture,
                'Farmer Benefits',
                null,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Government cards section
          const Text(
            'Government Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              _buildGovCard('Auditor Card'),
              const SizedBox(width: 12),
              _buildGovCard('Ration Card'),
              const SizedBox(width: 12),
              _buildGovCard('PM Kisan'),
            ],
          ),

          const SizedBox(height: 32),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              _buildActionCard(
                context,
                'View Profile',
                Icons.person,
                const CitizenProfileScreen(),
              ),
              const SizedBox(width: 16),
              _buildActionCard(
                context,
                'Check Status',
                Icons.track_changes,
                null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    Widget? destination,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: destination != null
            ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF6B5CE7)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovCard(String title) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF6B5CE7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget? destination,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: destination != null
            ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => destination),
              )
            : null,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6B5CE7)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: const Color(0xFF6B5CE7)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
