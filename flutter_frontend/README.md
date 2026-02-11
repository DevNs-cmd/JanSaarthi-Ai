# JanSaarthi AI Flutter Frontend

Production-grade Flutter frontend for the JanSaarthi AI government digital infrastructure platform.

## Architecture Overview

This Flutter application integrates with the existing multi-language backend services:
- **Java Spring Boot**: Citizen Profile, Consent & Identity, Policy, Eligibility services
- **Go**: Event Streaming, Edge Sync, Workflow Orchestrator
- **Python FastAPI**: Analytics, ASR, Vector Search services

## Prerequisites

- Flutter 3.x (stable channel)
- Dart SDK 3.x
- Android Studio or VS Code with Flutter extensions
- Docker (for backend services)

## Quick Start

### 1. Start Backend Services

First, start the existing backend services using Docker Compose:

```bash
# From project root directory
cd ..
docker compose -f infra/docker-compose.full.yaml up -d --build
```

Wait for services to be ready (check with `docker compose -f infra/docker-compose.full.yaml ps`)

### 2. Run Flutter Frontend

```bash
# Navigate to Flutter project
cd flutter_frontend

# Install dependencies
flutter pub get

# Run on web (development)
flutter run -d chrome

# Run on Android device/emulator
flutter run -d <device-id>

# Run in release mode
flutter run -d chrome --release
```

## Environment Configuration

The application uses environment variables defined in `.env`:

```env
# Backend Service URLs
CITIZEN_PROFILE_URL=http://localhost:8081
CONSENT_IDENTITY_URL=http://localhost:8082
POLICY_SERVICE_URL=http://localhost:8083
ELIGIBILITY_SERVICE_URL=http://localhost:8084
EVENT_STREAMING_URL=http://localhost:8091
EDGE_SYNC_URL=http://localhost:8092
WORKFLOW_ORCHESTRATOR_URL=http://localhost:8093
ASR_SERVICE_URL=http://localhost:8000
ANALYTICS_SERVICE_URL=http://localhost:8001
VECTOR_SEARCH_URL=http://localhost:8002

# Authentication
AUTH_MODE=jwt
MOCK_MODE=false
JWT_SECRET=CHANGE_ME_32_CHAR_MIN_SECRET
JWT_ISSUER=jan-saarthi
JWT_AUDIENCE=jan-saarthi-services

# App Configuration
APP_NAME=JanSaarthi AI
VERSION=1.0.0
```

## Development Modes

### Mock Mode
For frontend development without backend services:
```env
MOCK_MODE=true
```

### JWT Mode (Default)
Connects to real backend services with JWT authentication:
```env
MOCK_MODE=false
AUTH_MODE=jwt
```

### OIDC Mode
For Keycloak integration:
```env
MOCK_MODE=false
AUTH_MODE=oidc
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget with routing
├── auth/                     # Authentication logic
│   └── auth_state.dart       # Riverpod auth state management
├── models/                   # Data models
│   └── api_models.dart       # API response models
├── screens/                  # UI screens
│   ├── home_screen.dart      # Main dashboard
│   ├── eligibility_screen.dart # Scheme eligibility checker
│   ├── profile_screen.dart   # Citizen profile view
│   ├── alerts_screen.dart    # Notifications and alerts
│   └── admin_dashboard_screen.dart # Admin monitoring
├── services/                 # Business logic
│   ├── api_service.dart      # API client layer
│   └── providers.dart        # Riverpod providers
├── shared/                   # Shared components
│   └── theme/                # App theme and styling
│       └── app_theme.dart    # Government-compliant theme
└── routes.dart               # App routing
```

## API Integration

The frontend connects to these existing backend services:

### Citizen Services (Port 8081)
- `GET /api/v1/citizens/{citizenId}` - Get citizen profile
- `POST /api/v1/citizens` - Create/update citizen profile

### Consent Services (Port 8082)
- `POST /api/v1/consents` - Create consent record
- `GET /api/v1/consents/{consentId}` - Get consent details

### Eligibility Services (Port 8084)
- `POST /api/v1/eligibility/evaluate` - Check eligibility

### Policy Services (Port 8083)
- `GET /api/v1/policies/{policyId}/versions/{version}` - Get policy details

### Analytics Services (Port 8001)
- `GET /api/v1/analytics/dashboard` - Admin dashboard metrics (TODO)
- `GET /api/v1/audit/logs` - Audit trail (TODO)

## Key Features Implemented

### Citizen-Facing Features
1. **Home Dashboard** - Multi-service navigation hub
2. **Profile Management** - View citizen details and linked benefits
3. **Eligibility Checker** - Scheme matching with detailed explanations
4. **Notifications** - Real-time alerts and updates
5. **Search & Voice** - Multi-modal interaction (UI ready)

### Admin Features
1. **Monitoring Dashboard** - Key metrics and analytics
2. **Coverage Maps** - Geographic distribution visualization
3. **Scheme Analytics** - Uptake vs target comparisons
4. **Bottleneck Tracking** - Regional issue identification

## Security & Compliance

### Authentication
- JWT token-based authentication
- Role-based access control (Citizen, Admin, Auditor)
- Secure token storage and refresh mechanisms

### Data Protection
- Government-compliant data handling
- Privacy-preserving analytics
- Audit trail for all actions

### Accessibility
- WCAG AA compliance
- High contrast mode support
- Screen reader compatibility
- Large font support

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Deployment

### Web Deployment
```bash
flutter build web --release
```

### Android Deployment
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS Deployment
```bash
flutter build ios --release
```

## Missing Backend Endpoints (TODO)

The following endpoints need to be implemented in the backend:

### Admin Analytics (Port 8001)
```http
GET /api/v1/analytics/dashboard
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

### Audit Logs (Port 8001)
```http
GET /api/v1/audit/logs
Query: ?limit=50&page=1
Response: {
  "items": [
    {
      "citizen_id": string,
      "policy_id": string,
      "decision": bool,
      "timestamp": string,
      "audit_ref": string,
      "explanation": string
    }
  ],
  "total": int,
  "page": int
}
```

## Troubleshooting

### Common Issues

1. **Backend services not responding**
   ```bash
   # Check if services are running
   docker compose -f infra/docker-compose.full.yaml ps
   
   # Restart services if needed
   docker compose -f infra/docker-compose.full.yaml restart
   ```

2. **CORS errors**
   - Ensure backend services have proper CORS configuration
   - Check if services are running on correct ports

3. **Authentication failures**
   - Verify JWT_SECRET matches between frontend and backend
   - Check if tokens are properly formatted

### Debug Commands

```bash
# Check Flutter doctor
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get
flutter build

# Enable verbose logging
flutter run -v
```

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For support and queries, please contact the development team.