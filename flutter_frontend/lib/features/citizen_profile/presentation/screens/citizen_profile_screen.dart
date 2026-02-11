import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/citizen_profile_providers.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';

class CitizenProfileScreen extends ConsumerWidget {
  const CitizenProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(citizenProfileProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(citizenProfileProvider.notifier).refreshProfile(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(citizenProfileProvider.notifier).refreshProfile();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading State
              if (profileState.isLoading && profileState.profile == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16.0),
                        Text('Loading profile...'),
                      ],
                    ),
                  ),
                ),

              // Error State
              if (profileState.error != null && profileState.profile == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64.0,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Failed to load profile',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          profileState.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(citizenProfileProvider.notifier)
                                .refreshProfile();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

              // Empty State
              if (!profileState.isLoading &&
                  profileState.error == null &&
                  profileState.profile == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 64.0,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'No Profile Found',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Your citizen profile is not available yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

              // Success State - Profile Content
              if (profileState.profile != null) ...[
                // Profile Header Card
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                profileState.profile!.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileState.profile!.name,
                                    style: const TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'ID: ${profileState.profile!.citizenId}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'YoJana ID: ${profileState.profile!.yojanaId}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Personal Information Section
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildInfoRow(
                          'Date of Birth',
                          profileState.profile!.dob,
                        ),
                        _buildInfoRow('Gender', profileState.profile!.gender),
                        _buildInfoRow(
                          'Language',
                          profileState.profile!.language,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Contact Information Section
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildInfoRow('Mobile', profileState.profile!.mobile),
                        _buildInfoRow('Address', profileState.profile!.address),
                        _buildInfoRow(
                          'District',
                          profileState.profile!.district,
                        ),
                        _buildInfoRow('State', profileState.profile!.state),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                // Additional Attributes Section
                if (profileState.profile!.attributes.isNotEmpty)
                  Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Additional Information',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ...profileState.profile!.attributes.entries
                              .map(
                                (entry) =>
                                    _buildInfoRow(entry.key, entry.value),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20.0),

                // Profile Metadata
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile Information',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildInfoRow(
                          'Profile Version',
                          profileState.profile!.profileVersion,
                        ),
                        _buildInfoRow(
                          'Last Updated',
                          DateTime.now().toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20.0),

              // User Info Footer
              if (currentUser != null)
                Card(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Logged in as:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(currentUser.username),
                        const SizedBox(height: 4.0),
                        Text(
                          'Role: ${currentUser.role.name.toUpperCase()}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16.0))),
        ],
      ),
    );
  }
}
