import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/eligibility_entities.dart';
import '../../../../data/repositories/citizen_repository.dart';

abstract class EligibilityRepository {
  Future<List<Scheme>> getAvailableSchemes();
  Future<EligibilityResponse> evaluateEligibility(EligibilityRequest request);
  Future<List<Scheme>> getSuggestedSchemes(String citizenId);
}

class EligibilityRepositoryImpl implements EligibilityRepository {
  final ApiClient apiClient;

  EligibilityRepositoryImpl({required this.apiClient});

  @override
  Future<List<Scheme>> getAvailableSchemes() async {
    try {
      final response = await apiClient.get<List<dynamic>>(
        AppConstants.policyServiceBaseUrl,
        '${AppConstants.policyPath}/schemes',
        parser: (data) {
          return (data as List)
              .map((item) => Scheme.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (response.success && response.data != null) {
        return response.data! as List<Scheme>;
      } else {
        throw Exception(response.error?.message ?? 'Failed to fetch schemes');
      }
    } catch (e) {
      // Mock data for demonstration since backend might not be available
      return [
        Scheme(
          schemeId: 'pm-kisan',
          name: 'PM Kisan Samman Nidhi',
          description: 'Financial support for farmers',
          category: 'Agriculture',
          ministry: 'Ministry of Agriculture',
          estimatedBenefit: 6000.0,
          eligibilityUrl: '/eligibility/pm-kisan',
        ),
        Scheme(
          schemeId: 'pm-ayushman',
          name: 'PM Ayushman Bharat',
          description: 'Health insurance scheme',
          category: 'Health',
          ministry: 'Ministry of Health',
          estimatedBenefit: 500000.0,
          eligibilityUrl: '/eligibility/pm-ayushman',
        ),
        Scheme(
          schemeId: 'pm-svanidhi',
          name: 'PM Street Vendor AtmaNirbhar Nidhi',
          description: 'Working capital loan for street vendors',
          category: 'Employment',
          ministry: 'Ministry of Housing and Urban Affairs',
          estimatedBenefit: 10000.0,
          eligibilityUrl: '/eligibility/pm-svanidhi',
        ),
      ];
    }
  }

  @override
  Future<EligibilityResponse> evaluateEligibility(
    EligibilityRequest request,
  ) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        AppConstants.eligibilityServiceBaseUrl,
        AppConstants.eligibilityPath,
        {
          'citizenId': request.citizenId,
          'schemeId': request.schemeId,
          'inputData': request.inputData,
        },
        parser: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        return EligibilityResponse.fromJson(response.data!);
      } else {
        throw Exception(
          response.error?.message ?? 'Eligibility evaluation failed',
        );
      }
    } catch (e) {
      // Mock response for demonstration
      return EligibilityResponse(
        citizenId: request.citizenId,
        schemeId: request.schemeId,
        isEligible: true,
        confidenceScore: 0.85,
        factors: [
          EligibilityFactor(
            factorName: 'Income Level',
            factorValue: 'Below Poverty Line',
            weight: 0.4,
            meetsCriteria: true,
            description: 'Annual income is within eligible range',
          ),
          EligibilityFactor(
            factorName: 'Land Ownership',
            factorValue: '2 acres',
            weight: 0.3,
            meetsCriteria: true,
            description: 'Owns cultivable land',
          ),
          EligibilityFactor(
            factorName: 'Bank Account',
            factorValue: 'Yes',
            weight: 0.2,
            meetsCriteria: true,
            description: 'Has valid bank account',
          ),
          EligibilityFactor(
            factorName: 'Age Criteria',
            factorValue: '45 years',
            weight: 0.1,
            meetsCriteria: true,
            description: 'Meets minimum age requirement',
          ),
        ],
        explanation:
            'Based on the provided information, you meet the eligibility criteria for PM Kisan Samman Nidhi scheme. Your annual income is below the threshold, you own cultivable land, and you have a valid bank account for direct benefit transfer.',
        evaluatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<List<Scheme>> getSuggestedSchemes(String citizenId) async {
    try {
      final response = await apiClient.get<List<dynamic>>(
        AppConstants.analyticsServiceBaseUrl,
        '${AppConstants.analyticsDashboardPath}/suggestions/$citizenId',
        parser: (data) {
          return (data as List)
              .map((item) => Scheme.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );

      if (response.success && response.data != null) {
        return response.data! as List<Scheme>;
      } else {
        throw Exception(
          response.error?.message ?? 'Failed to fetch suggested schemes',
        );
      }
    } catch (e) {
      // Return subset of available schemes as suggestions
      final allSchemes = await getAvailableSchemes();
      return allSchemes.take(2).toList();
    }
  }
}

final eligibilityRepositoryProvider = Provider<EligibilityRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return EligibilityRepositoryImpl(apiClient: apiClient);
});
