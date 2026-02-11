#!/usr/bin/env bash
set -euo pipefail

function wait_port() {
  local url="$1"
  local name="$2"
  for i in {1..60}; do
    if curl -s "$url" >/dev/null 2>&1; then
      echo "$name ready"
      return 0
    fi
    sleep 2
  done
  echo "$name not ready"
  exit 1
}

wait_port http://localhost:8081/api/v1/citizens "citizen-profile"
wait_port http://localhost:8082/api/v1/consents "consent-identity"
wait_port http://localhost:8083/api/v1/policies "policy-service"
wait_port http://localhost:8084/api/v1/eligibility/evaluate "eligibility-service"
wait_port http://localhost:8091/api/v1/events "event-streaming"
wait_port http://localhost:8092/api/v1/edge/sync "edge-sync"
wait_port http://localhost:8093/api/v1/workflows/start "workflow-orchestrator"
wait_port http://localhost:8000/api/v1/asr/transcribe "asr-service"
wait_port http://localhost:8001/api/v1/analytics/forecast "analytics-service"
wait_port http://localhost:8002/api/v1/vector/search "vector-search"

JWT_SECRET="CHANGE_ME_32_CHAR_MIN_SECRET"
JWT_SECRET="CHANGE_ME_32_CHAR_MIN_SECRET"
JWT_ISSUER="jan-saarthi"
JWT_AUDIENCE="jan-saarthi-services"
HEADER=$(printf '{"alg":"HS256","typ":"JWT"}' | openssl base64 -A | tr '+/' '-_' | tr -d '=')
PAYLOAD=$(printf '{"sub":"ci-user","roles":["PROFILE_WRITE","PROFILE_READ","CONSENT_WRITE","CONSENT_READ","POLICY_WRITE","POLICY_READ","ELIGIBILITY_EXECUTE","EVENT_WRITE","EDGE_SYNC","WORKFLOW_WRITE","ASR_EXECUTE","ANALYTICS_READ","VECTOR_SEARCH"],"iat":%s,"iss":"%s","aud":"%s"}' "$(date +%s)" "$JWT_ISSUER" "$JWT_AUDIENCE" | openssl base64 -A | tr '+/' '-_' | tr -d '=')
SIG=$(printf "%s.%s" "$HEADER" "$PAYLOAD" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | openssl base64 -A | tr '+/' '-_' | tr -d '=')
TOKEN="$HEADER.$PAYLOAD.$SIG"

HDR=("-H" "Authorization: Bearer ${TOKEN}")

curl -s -X POST http://localhost:8082/api/v1/consents "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"yojanaId":"YID-TEST","scope":["profile.read","eligibility.evaluate"],"expiresAt":"2026-12-31","issuedBy":"ci"}' >/dev/null

curl -s -X POST http://localhost:8081/api/v1/citizens "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"yojanaId":"YID-TEST","demographics":{"name":"Test","dob":"2000-01-01","gender":"M","language":"hi"},"contact":{"mobile":"999","address":"X","district":"D","state":"S"},"attributes":{"farmer":"yes","landHolding":"small"},"consentToken":"CONSENT","source":"ci"}' >/dev/null

curl -s -X POST http://localhost:8083/api/v1/policies "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"policyId":"PM-KISAN","version":"2026-02-10.1","effectiveFrom":"2026-02-15","rulesetUri":"object-store://policies/PM-KISAN/2026-02-10.1","checksum":"sha256:x","approvals":["legal","domain"]}' >/dev/null

curl -s -X POST http://localhost:8084/api/v1/eligibility/evaluate "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -H "X-Trace-Id: ci-trace" \
  -H "X-Consent-Token: ci-consent" \
  -d '{"citizenId":"CID-1","policyId":"PM-KISAN","policyVersion":"2026-02-10.1","inputSnapshotVersion":"2026-02-10.1","attributes":{"farmer":"yes","landHolding":"small"}}' >/dev/null

curl -s -X POST http://localhost:8092/api/v1/edge/sync "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"edgeId":"EDGE-1","lastSyncAt":"2026-02-10T00:00:00Z","events":[],"policyBundleVersions":[],"updates":[{"key":"k1","value":"v1","updatedAt":"2026-02-10T00:00:00Z"}]}' >/dev/null

curl -s -X POST http://localhost:8093/api/v1/workflows/start "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"type":"benefit-disbursal","citizenId":"CID-1","policyId":"PM-KISAN","eligibilityRef":"AUD-1"}' >/dev/null

curl -s -X POST http://localhost:8000/api/v1/asr/transcribe "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"audioRef":"local://a","language":"hi-IN"}' >/dev/null

curl -s -X POST http://localhost:8001/api/v1/analytics/forecast "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"window_from":"2026-02-01","window_to":"2026-02-10","district":"D","signals":["s1"]}' >/dev/null

curl -s -X POST http://localhost:8002/api/v1/vector/search "${HDR[@]}" \
  -H "Content-Type: application/json" \
  -d '{"query":"test","top_k":3}' >/dev/null

echo "smoke tests passed"
