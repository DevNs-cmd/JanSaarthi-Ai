import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/providers.dart';
import '../models/api_models.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Updates'),
        backgroundColor: const Color(0xFF6B5CE7),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search notifications...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ),

          // Tabs
          Container(
            height: 50,
            decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
            child: Row(
              children: [
                _buildTab('All', true),
                _buildTab('Schemes', false),
                _buildTab('Agriculture', false),
                _buildTab('Health', false),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New for You Section
                  const Text(
                    'New for You',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildNotificationCard(
                    'Apke liye noyi yojana uplabdh hai',
                    'PM Kisan Samman Nidhi application successfully created.',
                    '2 hours ago',
                    true,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    'Scholarship application open',
                    'National Scholarship Portal is now accepting applications for 2026-27 academic year.',
                    '5 hours ago',
                    false,
                  ),

                  const SizedBox(height: 24),

                  // Earlier This Week
                  const Text(
                    'Earlier This Week',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildNotificationCard(
                    'Health Camp nearby',
                    'Free health checkup camp organized by Ministry of Health in your area on 12 Oct.',
                    'Oct 12',
                    false,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    'Ration Card Update',
                    'Your ration card details have been updated. No further action required.',
                    'Oct 11',
                    false,
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationCard(
                    'Digital Locker Sync',
                    'Successfully synced your documents with Digital Locker.',
                    'Oct 10',
                    false,
                  ),

                  const SizedBox(height: 24),

                  // View older updates
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Load more notifications
                      },
                      child: const Text(
                        'View older updates',
                        style: TextStyle(
                          color: Color(0xFF6B5CE7),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6B5CE7),
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Schemes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF6B5CE7) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    String title,
    String description,
    String time,
    bool isNew,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isNew) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF6B5CE7),
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(right: 12, top: 6),
              ),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
