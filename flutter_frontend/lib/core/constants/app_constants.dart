class AppConstants {
  // API Endpoints
  static const String citizenProfileBaseUrl = 'http://localhost:8081';
  static const String consentIdentityBaseUrl = 'http://localhost:8082';
  static const String policyServiceBaseUrl = 'http://localhost:8083';
  static const String eligibilityServiceBaseUrl = 'http://localhost:8084';
  static const String eventStreamingBaseUrl = 'http://localhost:8091';
  static const String analyticsServiceBaseUrl = 'http://localhost:8001';

  // API Paths
  static const String citizenProfilePath = '/api/v1/citizens';
  static const String consentPath = '/api/v1/consents';
  static const String policyPath = '/api/v1/policies';
  static const String eligibilityPath = '/api/v1/eligibility/evaluate';
  static const String analyticsDashboardPath = '/api/v1/analytics/dashboard';
  static const String auditLogsPath = '/api/v1/audit/logs';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';

  // Timeout Configuration
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 20;

  // Retry Configuration
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;
}
