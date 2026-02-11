# JanSaarthi AI Flutter Implementation Plan

## Architecture Overview

### Directory Structure
```
/flutter_frontend/
├── lib/
│   ├── main.dart             # App entry point
│   ├── app.dart              # Main app widget
│   ├── auth/                 # Authentication services
│   ├── citizen/              # Citizen-facing features
│   │   ├── profile/
│   │   ├── eligibility/
│   │   └── schemes/
│   ├── admin/                # Admin features (role-based)
│   │   ├── analytics/
│   │   ├── audit/
│   │   └── policies/
│   ├── shared/               # Common widgets and utilities
│   ├── services/             # API and data services
│   └── utils/                # Helper functions
├── pubspec.yaml              # Dependencies
└── assets/                   # Fonts, images, localization
/backend/
├── main.py                   # FastAPI entry point
├── api/                      # API routes
├── models/                   # Pydantic models
├── services/                 # Business logic
└── requirements.txt          # Dependencies
```

## Flutter Frontend (Single App with Role-Based Routing)

### Tech Stack
- Flutter 3.x (stable) with null safety
- Riverpod for state management
- Dio for networking
- JWT + optional OIDC (Keycloak-ready)
- Local cache for offline support
- WCAG AA accessibility compliance
- PWA + Android target

### Core Features
1. **Authentication Layer**
   - JWT/OIDC authentication with Riverpod
   - Secure token persistence
   - Role-based routing (Citizen/Admin)
   - Session management

2. **Citizen Features**
   - Profile view (read-only)
   - Eligibility checker with explanations
   - Scheme discovery with ranking
   - Offline sync indicators

3. **Admin Features**
   - Analytics dashboard
   - Audit logs (read-only)
   - Policy management interface
   - System monitoring

### Flutter Project Structure
```
lib/
├── main.dart                 # Entry point
├── app.dart                  # Main app widget
├── auth/
│   ├── auth_service.dart     # Authentication logic
│   ├── auth_state.dart       # Riverpod providers
│   └── login_screen.dart     # Login UI
├── citizen/
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── profile_provider.dart
│   ├── eligibility/
│   │   ├── eligibility_screen.dart
│   │   └── eligibility_provider.dart
│   └── schemes/
│       ├── schemes_screen.dart
│       └── schemes_provider.dart
├── admin/
│   ├── analytics/
│   │   ├── analytics_screen.dart
│   │   └── analytics_provider.dart
│   ├── audit/
│   │   ├── audit_screen.dart
│   │   └── audit_provider.dart
│   └── policies/
│       ├── policies_screen.dart
│       └── policies_provider.dart
├── shared/
│   ├── widgets/
│   │   ├── app_bar.dart
│   │   ├── loading_indicator.dart
│   │   └── error_widget.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── colors.dart
│   └── constants/
│       └── api_endpoints.dart
├── services/
│   ├── api_service.dart      # Dio client
│   ├── cache_service.dart    # Local storage
│   └── offline_service.dart  # Sync logic
└── utils/
    ├── validators.dart
    └── formatters.dart
```

## Backend API (FastAPI)

### Tech Stack
- FastAPI with Pydantic
- JWT authentication
- RBAC (Citizen, Admin, Auditor)
- OpenAPI documentation
- PostgreSQL integration
- Mock data for missing endpoints

### Required Endpoints
```http
POST   /auth/login              # User authentication
GET    /citizens/{id}           # Citizen profile
POST   /eligibility/evaluate    # Eligibility assessment
GET    /schemes/recommended     # Scheme recommendations
GET    /analytics/dashboard     # Admin analytics (TODO)
GET    /audit/eligibility-decisions # Audit logs (TODO)
GET    /policies/list           # Policy versions (TODO)
```

### Core Features
1. **Authentication**
   - JWT token generation
   - Role-based access control
   - Session management

2. **Citizen Services**
   - Profile retrieval
   - Eligibility evaluation
   - Scheme recommendations

3. **Admin Services**
   - Analytics dashboard data
   - Audit trail queries
   - Policy management
   - System monitoring

### Backend Structure
```
backend/
├── main.py                  # FastAPI app
├── api/
│   ├── auth.py              # Authentication routes
│   ├── citizens.py          # Citizen endpoints
│   ├── eligibility.py       # Eligibility service
│   ├── schemes.py           # Scheme recommendations
│   ├── analytics.py         # Admin analytics (TODO)
│   ├── audit.py             # Audit logs (TODO)
│   └── policies.py          # Policy management (TODO)
├── models/
│   ├── auth_models.py       # Auth schemas
│   ├── citizen_models.py    # Citizen data models
│   └── response_models.py   # API response schemas
├── services/
│   ├── auth_service.py      # Auth business logic
│   ├── citizen_service.py   # Citizen data service
│   └── eligibility_service.py # Eligibility engine
├── database.py              # DB connection
├── config.py                # Configuration
└── requirements.txt         # Dependencies
```

## Development & Run Instructions

### Flutter Setup
```bash
# Install Flutter 3.x
flutter pub get
flutter run -d chrome  # Web
flutter run -d android # Android

# Environment variables
# Create .env file:
API_BASE_URL=http://localhost:8000
AUTH_MODE=jwt  # or oidc
MOCK_MODE=false
```

### Backend Setup
```bash
# Install dependencies
pip install -r requirements.txt

# Run development server
uvicorn main:app --reload --port 8000

# Environment variables
# Create .env file:
SECRET_KEY=your-secret-key
DATABASE_URL=sqlite:///./test.db
JWT_ALGORITHM=HS256
```

### Mock Mode
Enable MOCK_MODE=true in .env to run frontend without backend

## API Service Layer

### Contract-Driven Approach
```dart
// services/api_service.dart
import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio();
  
  Future<CitizenProfile> getCitizenProfile(String citizenId) async {
    final response = await _dio.get('/citizens/$citizenId');
    return CitizenProfile.fromJson(response.data);
  }
  
  Future<EligibilityResponse> checkEligibility(
    EligibilityRequest request) async {
    final response = await _dio.post('/eligibility/evaluate', 
      data: request.toJson());
    return EligibilityResponse.fromJson(response.data);
  }
  
  // TODO: Implement when backend ready
  // Future<SchemeList> getRecommendedSchemes() async {
  //   final response = await _dio.get('/schemes/recommended');
  //   return SchemeList.fromJson(response.data);
  // }
}
```

## Authentication Implementation

### Riverpod State Management
```dart
// auth/auth_state.dart
import 'package:riverpod/riverpod.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState.unauthenticated());
  
  Future<void> login(LoginRequest request) async {
    // JWT/OIDC login logic
    state = AuthState.authenticated(user: user, token: token);
  }
  
  void logout() {
    state = const AuthState.unauthenticated();
  }
}

abstract class AuthState {
  const AuthState._();
  
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.authenticated({required User user, required String token}) = Authenticated;
  const factory AuthState.loading() = Loading;
}
```

## Missing Endpoint Specifications (TODO)

### Admin Analytics
```http
GET /analytics/dashboard
Response: {
  "metrics": {
    "total_citizens": int,
    "active_profiles": int,
    "eligibility_checks": int,
    "success_rate": float
  },
  "trends": [
    {"date": "YYYY-MM-DD", "count": int}
  ]
}
```

### Audit Logs
```http
GET /audit/eligibility-decisions
Query: ?limit=50&page=1
Response: {
  "items": [
    {
      "citizen_id": string,
      "policy_id": string,
      "decision": bool,
      "timestamp": string,
      "audit_ref": string
    }
  ],
  "total": int,
  "page": int
}
```

## Development Workflow

### Testing Strategy
- Widget tests for UI components
- Unit tests for services and providers
- Integration tests for API interactions
- Accessibility testing (Flutter Semantics)
- Performance profiling

### Security Standards
- Input validation and sanitization
- Secure token storage
- Network security (HTTPS)
- Error handling without exposing internals
- Audit logging for admin actions

## Quality Standards

### Code Quality
- Dart null safety
- Riverpod best practices
- Comprehensive error handling
- Widget testing coverage >80%
- Performance optimization

### UX Standards
- WCAG AA compliance
- Large font support
- High contrast themes
- Screen reader compatibility
- Touch-friendly interfaces
- Offline status indicators

### Security Standards
- Secure token management
- Input validation
- Network security
- Audit logging
- OWASP compliance

## Implementation Timeline

1. **Week 1**: Flutter project setup, auth layer, API service
2. **Week 2**: Citizen features (profile, eligibility, schemes)
3. **Week 3**: Admin features (analytics, audit, policies)
4. **Week 4**: Offline support, accessibility, testing
5. **Week 5**: Backend API implementation
6. **Week 6**: Integration, security review, documentation

## Success Criteria

- Single Flutter app with role-based routing
- All required endpoints implemented or clearly TODO'd
- WCAG AA accessibility compliance
- Offline-first capability with sync indicators
- Production-ready code with comprehensive testing
- Clear documentation with run commands