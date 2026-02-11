# JanSaarthi AI Event Schemas

## Conventions
- Topic naming: `jsai.{domain}.{eventType}.v{major}`
- Event envelopes are versioned and include policy version references.
- Schemas stored in schema registry (Avro/Protobuf) and mirrored in object store.

## Event Envelope (Generic)
```json
{
  "eventId": "uuid",
  "eventType": "eligibility.evaluated",
  "eventVersion": "1.0",
  "occurredAt": "YYYY-MM-DDTHH:MM:SSZ",
  "producer": "eligibility-service",
  "traceId": "trace-id",
  "policyVersion": "2026-02-10.1",
  "consentToken": "string",
  "payload": {}
}
```

## Topics and Schemas

### 1) Eligibility Evaluated
- Topic: `jsai.eligibility.evaluated.v1`

Payload
```json
{
  "citizenId": "CID-XXXX",
  "policyId": "PM-KISAN",
  "policyVersion": "2026-02-10.1",
  "eligible": true,
  "decisionCode": "ELIGIBLE",
  "explanations": [
    {
      "ruleId": "PMK-ELIG-001",
      "message": "Farmer category and landholding criteria satisfied",
      "inputsUsed": ["farmerCategory", "landHolding"]
    }
  ],
  "executionContext": {
    "location": "district-code",
    "channel": "kiosk"
  }
}
```

### 2) Policy Published
- Topic: `jsai.policy.published.v1`

Payload
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

### 3) Consent Granted
- Topic: `jsai.consent.granted.v1`

Payload
```json
{
  "consentId": "CONSENT-XXXX",
  "yojanaId": "YID-XXXX-XXXX",
  "scope": ["profile.read", "eligibility.evaluate"],
  "expiresAt": "YYYY-MM-DD",
  "issuedBy": "string"
}
```

### 4) Edge Sync Completed
- Topic: `jsai.edge.sync.completed.v1`

Payload
```json
{
  "edgeId": "EDGE-XYZ",
  "lastSyncAt": "YYYY-MM-DDTHH:MM:SSZ",
  "syncedEvents": 1240,
  "conflicts": 0,
  "policyBundleVersions": ["2026-02-10.1"]
}
```

### 5) Governance Insight Generated
- Topic: `jsai.governance.insight.generated.v1`

Payload
```json
{
  "insightId": "INS-XXXX",
  "level": "district|state|national",
  "category": "demand-forecast|gap-detection|anomaly",
  "summary": "string",
  "confidence": 0.82,
  "dataWindow": {
    "from": "YYYY-MM-DD",
    "to": "YYYY-MM-DD"
  }
}
```
