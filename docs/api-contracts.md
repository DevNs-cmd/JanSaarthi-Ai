# JanSaarthi AI API Contracts

## Common Conventions
- Base URL pattern: `https://{zone}.jansaarthi.gov.in/api/v1`
- Auth: OAuth2.1 with mTLS between services, JWT for user sessions, short-lived tokens
- Idempotency: All write endpoints accept `Idempotency-Key` header
- Audit headers: `X-Policy-Version`, `X-Consent-Token`, `X-Trace-Id`

## Citizen Profile Service (Spring Boot)

### POST /citizens
Creates or updates a citizen profile.

Request
```json
{
  "yojanaId": "YID-XXXX-XXXX",
  "demographics": {
    "name": "string",
    "dob": "YYYY-MM-DD",
    "gender": "string",
    "language": "string"
  },
  "contact": {
    "mobile": "string",
    "address": "string",
    "district": "string",
    "state": "string"
  },
  "attributes": {
    "incomeBracket": "string",
    "disabilityStatus": "string",
    "farmerCategory": "string"
  },
  "consentToken": "string",
  "source": "mobile|kiosk|ivr|whatsapp"
}
```

Response
```json
{
  "citizenId": "CID-XXXX",
  "status": "updated",
  "profileVersion": "2026-02-10.1"
}
```

### GET /citizens/{citizenId}
Returns the canonical profile with provenance and version.

## Consent and Identity Service (Spring Boot)

### POST /consents
Creates a scoped consent record.

Request
```json
{
  "yojanaId": "YID-XXXX-XXXX",
  "scope": ["profile.read", "eligibility.evaluate"],
  "expiresAt": "YYYY-MM-DD",
  "issuedBy": "string"
}
```

Response
```json
{
  "consentToken": "string",
  "consentId": "CONSENT-XXXX",
  "status": "active"
}
```

## Policy Service (Spring Boot + Drools/OPA)

### POST /policies
Publishes a versioned policy bundle.

Request
```json
{
  "policyId": "PM-KISAN",
  "version": "2026-02-10.1",
  "effectiveFrom": "YYYY-MM-DD",
  "rulesetUri": "object-store://policies/PM-KISAN/2026-02-10.1",
  "checksum": "sha256:...",
  "approvals": ["legal", "domain", "security"]
}
```

Response
```json
{
  "status": "published",
  "policyId": "PM-KISAN",
  "version": "2026-02-10.1"
}
```

### GET /policies/{policyId}/versions/{version}
Returns the policy metadata and references.

## Eligibility Service (Spring Boot)

### POST /eligibility/evaluate
Executes deterministic eligibility rules.

Request
```json
{
  "citizenId": "CID-XXXX",
  "policyId": "PM-KISAN",
  "policyVersion": "2026-02-10.1",
  "inputSnapshotVersion": "2026-02-10.2",
  "executionContext": {
    "location": "district-code",
    "channel": "mobile"
  }
}
```

Response
```json
{
  "eligible": true,
  "decisionCode": "ELIGIBLE",
  "explanations": [
    {
      "ruleId": "PMK-ELIG-001",
      "message": "Farmer category and landholding criteria satisfied",
      "inputsUsed": ["farmerCategory", "landHolding"],
      "policyVersion": "2026-02-10.1"
    }
  ],
  "auditRef": "AUD-XXXX"
}
```

## Workflow Orchestrator (Go)

### POST /workflows/start
Creates a workflow instance for benefit processing.

Request
```json
{
  "type": "benefit-disbursal",
  "citizenId": "CID-XXXX",
  "policyId": "PM-KISAN",
  "eligibilityRef": "AUD-XXXX"
}
```

Response
```json
{
  "workflowId": "WF-XXXX",
  "status": "started"
}
```

## Edge Sync Service (Go)

### POST /edge/sync
Syncs local changes to core and pulls updates.

Request
```json
{
  "edgeId": "EDGE-XYZ",
  "lastSyncAt": "YYYY-MM-DDTHH:MM:SSZ",
  "events": ["base64-encoded-event"],
  "policyBundleVersions": ["2026-02-10.1"]
}
```

Response
```json
{
  "status": "ok",
  "newPolicyBundles": ["2026-02-11.1"],
  "conflicts": []
}
```

## AI Inference Service (Python FastAPI)

### POST /asr/transcribe
Offline-capable ASR inference.

Request
```json
{
  "audioRef": "local://audio/123",
  "language": "hi-IN"
}
```

Response
```json
{
  "text": "transcribed text",
  "confidence": 0.91
}
```
