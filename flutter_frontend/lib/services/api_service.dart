import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiService {
  static final Dio _dio = Dio();

  // Service URLs from environment
  static final String citizenProfileUrl =
      dotenv.env['CITIZEN_PROFILE_URL'] ?? 'http://localhost:8081';
  static final String consentIdentityUrl =
      dotenv.env['CONSENT_IDENTITY_URL'] ?? 'http://localhost:8082';
  static final String policyServiceUrl =
      dotenv.env['POLICY_SERVICE_URL'] ?? 'http://localhost:8083';
  static final String eligibilityServiceUrl =
      dotenv.env['ELIGIBILITY_SERVICE_URL'] ?? 'http://localhost:8084';
  static final String analyticsServiceUrl =
      dotenv.env['ANALYTICS_SERVICE_URL'] ?? 'http://localhost:8001';

  // Auth configuration
  static final String jwtSecret =
      dotenv.env['JWT_SECRET'] ?? 'CHANGE_ME_32_CHAR_MIN_SECRET';
  static final String jwtIssuer = dotenv.env['JWT_ISSUER'] ?? 'jan-saarthi';
  static final String jwtAudience =
      dotenv.env['JWT_AUDIENCE'] ?? 'jan-saarthi-services';
  static final bool mockMode = dotenv.env['MOCK_MODE'] == 'true';

  static void initialize() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth header if available
          // TODO: Add JWT token to headers
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException e, handler) {
          handler.next(e);
        },
      ),
    );
  }

  // Citizen Profile Service
  static Future<Response> getCitizenProfile(String citizenId) async {
    if (mockMode) {
      return _getMockCitizenProfile(citizenId);
    }
    return await _dio.get('$citizenProfileUrl/api/v1/citizens/$citizenId');
  }

  static Future<Response> upsertCitizenProfile(
    Map<String, dynamic> data,
  ) async {
    if (mockMode) {
      return _getMockUpsertResponse();
    }
    return await _dio.post('$citizenProfileUrl/api/v1/citizens', data: data);
  }

  // Consent & Identity Service
  static Future<Response> createConsent(Map<String, dynamic> data) async {
    if (mockMode) {
      return _getMockConsentResponse();
    }
    return await _dio.post('$consentIdentityUrl/api/v1/consents', data: data);
  }

  static Future<Response> getConsent(String consentId) async {
    if (mockMode) {
      return _getMockConsentDetails(consentId);
    }
    return await _dio.get('$consentIdentityUrl/api/v1/consents/$consentId');
  }

  // Eligibility Service
  static Future<Response> evaluateEligibility(Map<String, dynamic> data) async {
    if (mockMode) {
      return _getMockEligibilityResponse();
    }
    return await _dio.post(
      '$eligibilityServiceUrl/api/v1/eligibility/evaluate',
      data: data,
    );
  }

  // Policy Service
  static Future<Response> getPolicy(String policyId, String version) async {
    if (mockMode) {
      return _getMockPolicyResponse(policyId, version);
    }
    return await _dio.get(
      '$policyServiceUrl/api/v1/policies/$policyId/versions/$version',
    );
  }

  // Analytics Service (Admin)
  static Future<Response> getAdminDashboard() async {
    if (mockMode) {
      return _getMockAdminDashboard();
    }
    return await _dio.get('$analyticsServiceUrl/api/v1/analytics/dashboard');
  }

  static Future<Response> getAuditLogs({int limit = 50, int page = 1}) async {
    if (mockMode) {
      return _getMockAuditLogs(limit, page);
    }
    return await _dio.get(
      '$analyticsServiceUrl/api/v1/audit/logs',
      queryParameters: {'limit': limit, 'page': page},
    );
  }

  // Mock data for development
  static Response _getMockCitizenProfile(String citizenId) {
    return Response(
      data: {
        'citizenId': citizenId,
        'yojanaId': 'YID-TEST-123',
        'name': 'Test Citizen',
        'dob': '1990-01-01',
        'gender': 'M',
        'language': 'hi',
        'mobile': '9999999999',
        'address': 'Test Address',
        'district': 'Test District',
        'state': 'Test State',
        'attributes': {
          'incomeBracket': 'middle',
          'farmerCategory': 'small',
          'landHolding': '2 acres',
        },
        'profileVersion': '2026-02-10.1',
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockUpsertResponse() {
    return Response(
      data: {
        'citizenId': 'CID-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'updated',
        'profileVersion': DateTime.now().toIso8601String(),
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockConsentResponse() {
    return Response(
      data: {
        'consentToken':
            'CONSENT-TOKEN-${DateTime.now().millisecondsSinceEpoch}',
        'consentId': 'CONSENT-${DateTime.now().millisecondsSinceEpoch}',
        'status': 'active',
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockConsentDetails(String consentId) {
    return Response(
      data: {
        'consentId': consentId,
        'yojanaId': 'YID-TEST-123',
        'scope': ['profile.read', 'eligibility.evaluate'],
        'expiresAt': '2026-12-31',
        'issuedBy': 'citizen-app',
        'consentToken': 'CONSENT-TOKEN-123',
        'status': 'active',
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockEligibilityResponse() {
    return Response(
      data: {
        'eligible': true,
        'decisionCode': 'ELIGIBLE',
        'explanations': [
          {
            'ruleId': 'PMK-ELIG-001',
            'message': 'Farmer category and landholding criteria satisfied',
            'inputsUsed': ['farmerCategory', 'landHolding'],
            'policyVersion': '2026-02-10.1',
          },
        ],
        'auditRef': 'AUD-${DateTime.now().millisecondsSinceEpoch}',
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockPolicyResponse(String policyId, String version) {
    return Response(
      data: {
        'policyId': policyId,
        'version': version,
        'effectiveFrom': '2026-02-15',
        'rulesetUri': 'object-store://policies/$policyId/$version',
        'checksum': 'sha256:test-checksum',
        'approvals': ['legal', 'domain'],
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockAdminDashboard() {
    return Response(
      data: {
        'metrics': {
          'totalCitizens': 12500,
          'activeProfiles': 9800,
          'eligibilityChecks': 3400,
          'successfulEvaluations': 2800,
          'policyAdoptionRate': 0.82,
        },
        'trends': [
          {'date': '2026-02-01', 'count': 120},
          {'date': '2026-02-02', 'count': 135},
          {'date': '2026-02-03', 'count': 128},
          {'date': '2026-02-04', 'count': 142},
          {'date': '2026-02-05', 'count': 138},
          {'date': '2026-02-06', 'count': 156},
          {'date': '2026-02-07', 'count': 145},
        ],
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }

  static Response _getMockAuditLogs(int limit, int page) {
    return Response(
      data: {
        'items': List.generate(
          limit ~/ 2,
          (index) => {
            'citizenId': 'CID-${1000 + index + (page - 1) * limit}',
            'policyId': 'PM-KISAN',
            'decision': index % 3 != 0, // 66% eligibility rate
            'timestamp': DateTime.now()
                .subtract(Duration(hours: index))
                .toIso8601String(),
            'auditRef':
                'AUD-${DateTime.now().millisecondsSinceEpoch - index * 1000}',
            'explanation': index % 3 != 0
                ? 'Eligibility criteria satisfied'
                : 'Income bracket exceeds threshold',
          },
        ),
        'total': 1250,
        'page': page,
        'limit': limit,
      },
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );
  }
}
