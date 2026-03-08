import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/providers.dart';
import '../models/api_models.dart';

class EligibilityScreen extends ConsumerWidget {
  const EligibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibilityState = ref.watch(eligibilityEvaluationProvider);
    final isLoading = ref.watch(isLoadingEligibilityProvider);
    final error = ref.watch(eligibilityErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Eligibility'),
        backgroundColor: const Color(0xFF6B5CE7),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh eligibility check
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5 Schemes Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 24),

            if (isLoading) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (error != null) ...[
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Retry logic
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: ListView(
                  children: [
                    _buildSchemeCard(
                      'PM Kisan Samman Nidhi',
                      'Direct income support of ₹6,000 per year in three equal installments for all landholding farmer families.',
                      true,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Application submitted for PM Kisan!',
                            ),
                          ),
                        );
                      },
                      () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSchemeCard(
                      'Ayushman Bharat Yojana',
                      'Health cover of ₹5 lakhs per family per year for secondary and tertiary care hospitalization.',
                      true,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Application submitted for Ayushman Bharat!',
                            ),
                          ),
                        );
                      },
                      () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSchemeCard(
                      'PM Svanidhi',
                      'Special Micro-credit facility for street vendors to provide affordable working capital loans.',
                      false,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Application submitted for PM Svanidhi!',
                            ),
                          ),
                        );
                      },
                      () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSchemeCard(
                      'Pradhan Mantri Awas Yojana',
                      'Housing for All by 2022 - urban housing scheme for economically weaker sections.',
                      true,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Application submitted for PMAY!'),
                          ),
                        );
                      },
                      () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSchemeCard(
                      'National Scholarship Portal',
                      'Centralized scholarship portal for students from class 1 to Ph.D level.',
                      false,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Application submitted for Scholarship!',
                            ),
                          ),
                        );
                      },
                      () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                  ],
                ),
              ),

              // Footer CTA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Color(0xFF6B5CE7)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Want better matches? Update Profile Details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B5CE7),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(
    String title,
    String description,
    bool isEligible,
    VoidCallback onApply,
    VoidCallback onViewDetails,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isEligible ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isEligible ? 'ELIGIBLE' : 'PARTIAL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B5CE7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Apply Now'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF6B5CE7)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Color(0xFF6B5CE7)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
