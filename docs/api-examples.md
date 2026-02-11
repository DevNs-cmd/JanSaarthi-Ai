# API Examples & Documentation – JanSaarthi AI

All endpoints require `Authorization: Bearer <token>`.

## Auth Examples
**HS256 JWT**
```http
Authorization: Bearer <HS256 JWT with roles, iss, aud>
```

**OIDC (Keycloak)**
```http
Authorization: Bearer <OIDC Access Token>
```

## Citizen Profile
**POST /api/v1/citizens**
```json
{
  "yojanaId": "YID-TEST",
  "demographics": {"name":"Test","dob":"2000-01-01","gender":"M","language":"hi"},
  "contact": {"mobile":"999","address":"X","district":"D","state":"S"},
  "attributes": {"farmer":"yes","landHolding":"small"},
  "consentToken": "CONSENT",
  "source": "kiosk"
}
```
Response
```json
{"citizenId":"CID-123","status":"updated","profileVersion":"2026-02-10T12:00:00Z"}
```

## Consent
**POST /api/v1/consents**
```json
{"yojanaId":"YID-TEST","scope":["profile.read","eligibility.evaluate"],"expiresAt":"2026-12-31","issuedBy":"ci"}
```
Response
```json
{"consentToken":"CONSENT-TOKEN-123","consentId":"CONSENT-123","status":"active"}
```

## Policy
**POST /api/v1/policies**
```json
{"policyId":"PM-KISAN","version":"2026-02-10.1","effectiveFrom":"2026-02-15","rulesetUri":"object-store://policies/PM-KISAN/2026-02-10.1","checksum":"sha256:x","approvals":["legal","domain"]}
```
Response
```json
{"status":"published","policyId":"PM-KISAN","version":"2026-02-10.1"}
```

## Eligibility
**POST /api/v1/eligibility/evaluate**
```json
{"citizenId":"CID-1","policyId":"PM-KISAN","policyVersion":"2026-02-10.1","inputSnapshotVersion":"2026-02-10.1","attributes":{"farmer":"yes","landHolding":"small"}}
```
Response
```json
{
  "eligible": true,
  "decisionCode": "ELIGIBLE",
  "explanations": [{"ruleId":"RULE-BASE-001","message":"Eligibility criteria satisfied","inputsUsed":["farmer","landHolding"],"policyVersion":"2026-02-10.1"}],
  "auditRef": "AUD-123"
}
```

## Event Streaming
**POST /api/v1/events**
```json
{"eventId":"uuid","eventType":"eligibility.evaluated","eventVersion":"1.0","occurredAt":"2026-02-10T12:00:00Z","producer":"eligibility-service","traceId":"trace","policyVersion":"2026-02-10.1","consentToken":"CONSENT","payload":{"citizenId":"CID-1","policyId":"PM-KISAN","eligible":true}}
```
Response
```json
{"status":"accepted","ackId":"20260210120000"}
```

## Edge Sync
**POST /api/v1/edge/sync**
```json
{"edgeId":"EDGE-1","lastSyncAt":"2026-02-10T00:00:00Z","events":[],"policyBundleVersions":[],"updates":[{"key":"k1","value":"v1","updatedAt":"2026-02-10T00:00:00Z"}]}
```
Response
```json
{"status":"ok","newPolicyBundles":[],"conflicts":[]}
```

## Workflow
**POST /api/v1/workflows/start**
```json
{"type":"benefit-disbursal","citizenId":"CID-1","policyId":"PM-KISAN","eligibilityRef":"AUD-1"}
```
Response
```json
{"workflowId":"WF-20260210120000","status":"started"}
```

## Errors and Retry Guidance
| Status | Meaning | Retry Guidance |
|---|---|---|
| 400 | Validation error | Do not retry without fixing input |
| 401 | Unauthorized | Refresh token, verify issuer/audience |
| 403 | Forbidden | Verify roles and consent scope |
| 409 | Conflict | Retry after resolving conflict |
| 429 | Rate limited | Retry with exponential backoff |
| 502 | Upstream error | Retry with jitter |
