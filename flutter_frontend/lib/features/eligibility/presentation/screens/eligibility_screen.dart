import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/eligibility_providers.dart';
import '../../domain/eligibility_entities.dart';

class EligibilityScreen extends ConsumerWidget {
  const EligibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibilityState = ref.watch(eligibilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligibility Check'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(eligibilityProvider.notifier).refreshSchemes(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(eligibilityProvider.notifier).refreshSchemes();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading State
              if (eligibilityState.isLoading &&
                  eligibilityState.availableSchemes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16.0),
                        Text('Loading schemes...'),
                      ],
                    ),
                  ),
                ),

              // Error State
              if (eligibilityState.error != null &&
                  eligibilityState.availableSchemes.isEmpty)
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
                        const Text(
                          'Failed to load schemes',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          eligibilityState.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(eligibilityProvider.notifier)
                                .refreshSchemes();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

              // Success State - Schemes Content
              if (eligibilityState.availableSchemes.isNotEmpty) ...[
                // Suggested Schemes Section
                if (eligibilityState.suggestedSchemes.isNotEmpty) ...[
                  const Text(
                    'Suggested for You',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 180.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: eligibilityState.suggestedSchemes.length,
                      itemBuilder: (context, index) {
                        final scheme = eligibilityState.suggestedSchemes[index];
                        return _buildSchemeCard(context, scheme, ref, true);
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],

                // All Schemes Section
                const Text(
                  'All Government Schemes',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3.0,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: eligibilityState.availableSchemes.length,
                  itemBuilder: (context, index) {
                    final scheme = eligibilityState.availableSchemes[index];
                    return _buildSchemeListItem(context, scheme, ref);
                  },
                ),
              ],

              // Evaluation Result
              if (eligibilityState.hasEvaluated &&
                  eligibilityState.currentEvaluation != null) ...[
                const SizedBox(height: 32.0),
                const Divider(),
                const SizedBox(height: 16.0),
                const Text(
                  'Eligibility Result',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                _buildEvaluationResult(
                  context,
                  eligibilityState.currentEvaluation!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(
    BuildContext context,
    Scheme scheme,
    WidgetRef ref,
    bool isSuggested,
  ) {
    return Container(
      width: 280.0,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isSuggested
            ? Border.all(color: const Color(0xFF6B5CE7), width: 2.0)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: isSuggested ? const Color(0xFF6B5CE7) : Colors.grey,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    scheme.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSuggested)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B5CE7),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      'Suggested',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              scheme.description,
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${scheme.estimatedBenefit.toInt().toString()}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B5CE7),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(eligibilityProvider.notifier)
                        .evaluateEligibility(
                          scheme.schemeId,
                          {}, // Empty input data for demo
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B5CE7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                  ),
                  child: const Text('Check Eligibility'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeListItem(
    BuildContext context,
    Scheme scheme,
    WidgetRef ref,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6B5CE7),
          child: Text(
            scheme.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          scheme.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scheme.description),
            const SizedBox(height: 4.0),
            Text(
              'Ministry: ${scheme.ministry}',
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${scheme.estimatedBenefit.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B5CE7),
              ),
            ),
            const SizedBox(height: 4.0),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(eligibilityProvider.notifier)
                    .evaluateEligibility(
                      scheme.schemeId,
                      {}, // Empty input data for demo
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
              ),
              child: const Text('Check'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationResult(
    BuildContext context,
    EligibilityResponse response,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: response.isEligible ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: response.isEligible ? Colors.green : Colors.red,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  response.isEligible ? Icons.check_circle : Icons.cancel,
                  color: response.isEligible ? Colors.green : Colors.red,
                  size: 32.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        response.isEligible ? 'Eligible' : 'Not Eligible',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: response.isEligible
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Confidence: ${(response.confidenceScore * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Clear evaluation
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Detailed Explanation:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(response.explanation, style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 16.0),
            const Text(
              'Evaluation Factors:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...response.factors
                .map((factor) => _buildFactorItem(factor))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorItem(EligibilityFactor factor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: factor.meetsCriteria ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            factor.meetsCriteria ? Icons.check : Icons.close,
            color: factor.meetsCriteria ? Colors.green : Colors.red,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.factorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '${factor.factorValue} - ${factor.description}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${(factor.weight * 100).toStringAsFixed(0)}%',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
