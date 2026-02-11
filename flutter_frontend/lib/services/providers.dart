import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

// Citizen Profile Providers
final citizenProfileProvider = FutureProvider.family<CitizenProfile, String>((
  ref,
  citizenId,
) async {
  try {
    final response = await ApiService.getCitizenProfile(citizenId);
    return CitizenProfile.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    throw Exception('Failed to fetch citizen profile: ${e.message}');
  }
});

final upsertCitizenProfileProvider =
    FutureProvider.family<CitizenProfile, Map<String, dynamic>>((
      ref,
      data,
    ) async {
      try {
        final response = await ApiService.upsertCitizenProfile(data);
        return CitizenProfile.fromJson(response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        throw Exception('Failed to update citizen profile: ${e.message}');
      }
    });

// Consent Providers
final createConsentProvider =
    FutureProvider.family<Consent, Map<String, dynamic>>((ref, data) async {
      try {
        final response = await ApiService.createConsent(data);
        return Consent.fromJson(response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        throw Exception('Failed to create consent: ${e.message}');
      }
    });

final consentProvider = FutureProvider.family<Consent, String>((
  ref,
  consentId,
) async {
  try {
    final response = await ApiService.getConsent(consentId);
    return Consent.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    throw Exception('Failed to fetch consent: ${e.message}');
  }
});

// Eligibility Providers
final eligibilityEvaluationProvider =
    FutureProvider.family<EligibilityResponse, Map<String, dynamic>>((
      ref,
      data,
    ) async {
      try {
        final response = await ApiService.evaluateEligibility(data);
        return EligibilityResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } on DioException catch (e) {
        throw Exception('Failed to evaluate eligibility: ${e.message}');
      }
    });

// Policy Providers
final policyProvider =
    FutureProvider.family<Policy, ({String policyId, String version})>((
      ref,
      params,
    ) async {
      try {
        final response = await ApiService.getPolicy(
          params.policyId,
          params.version,
        );
        return Policy.fromJson(response.data as Map<String, dynamic>);
      } on DioException catch (e) {
        throw Exception('Failed to fetch policy: ${e.message}');
      }
    });

// Admin Dashboard Providers
final adminDashboardProvider = FutureProvider<AdminDashboard>((ref) async {
  try {
    final response = await ApiService.getAdminDashboard();
    return AdminDashboard.fromJson(response.data as Map<String, dynamic>);
  } on DioException catch (e) {
    throw Exception('Failed to fetch admin dashboard: ${e.message}');
  }
});

final auditLogsProvider =
    FutureProvider.family<PaginatedAuditLogs, ({int limit, int page})>((
      ref,
      params,
    ) async {
      try {
        final response = await ApiService.getAuditLogs(
          limit: params.limit,
          page: params.page,
        );
        return PaginatedAuditLogs.fromJson(
          response.data as Map<String, dynamic>,
        );
      } on DioException catch (e) {
        throw Exception('Failed to fetch audit logs: ${e.message}');
      }
    });

// Loading state providers
final isLoadingCitizenProfileProvider = StateProvider<bool>((ref) => false);
final isLoadingEligibilityProvider = StateProvider<bool>((ref) => false);
final isLoadingAdminDashboardProvider = StateProvider<bool>((ref) => false);

// Error state providers
final citizenProfileErrorProvider = StateProvider<String?>((ref) => null);
final eligibilityErrorProvider = StateProvider<String?>((ref) => null);
final adminDashboardErrorProvider = StateProvider<String?>((ref) => null);
