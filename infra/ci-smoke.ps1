$ErrorActionPreference = "Stop"

function Wait-Port($Url, $Name) {
  for ($i = 0; $i -lt 60; $i++) {
    try {
      $resp = Invoke-WebRequest -Uri $Url -Method Get -TimeoutSec 2
      Write-Host "$Name ready"
      return
    } catch {
      Start-Sleep -Seconds 2
    }
  }
  throw "$Name not ready"
}

Wait-Port "http://localhost:8081/api/v1/citizens" "citizen-profile"
Wait-Port "http://localhost:8082/api/v1/consents" "consent-identity"
Wait-Port "http://localhost:8083/api/v1/policies" "policy-service"
Wait-Port "http://localhost:8084/api/v1/eligibility/evaluate" "eligibility-service"
Wait-Port "http://localhost:8091/api/v1/events" "event-streaming"
Wait-Port "http://localhost:8092/api/v1/edge/sync" "edge-sync"
Wait-Port "http://localhost:8093/api/v1/workflows/start" "workflow-orchestrator"
Wait-Port "http://localhost:8000/api/v1/asr/transcribe" "asr-service"
Wait-Port "http://localhost:8001/api/v1/analytics/forecast" "analytics-service"
Wait-Port "http://localhost:8002/api/v1/vector/search" "vector-search"

$secret = "CHANGE_ME_32_CHAR_MIN_SECRET"
$roles = @(
  "PROFILE_WRITE","PROFILE_READ","CONSENT_WRITE","CONSENT_READ",
  "POLICY_WRITE","POLICY_READ","ELIGIBILITY_EXECUTE","EVENT_WRITE",
  "EDGE_SYNC","WORKFLOW_WRITE","ASR_EXECUTE","ANALYTICS_READ","VECTOR_SEARCH"
)
$header = @{ alg = "HS256"; typ = "JWT" } | ConvertTo-Json -Compress
$payload = @{
  sub = "ci-user"
  roles = $roles
  iat = [int][double]::Parse((Get-Date -UFormat %s))
  iss = "jan-saarthi"
  aud = "jan-saarthi-services"
} | ConvertTo-Json -Compress

function Base64UrlEncode([byte[]]$bytes) {
  [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+','-').Replace('/','_')
}

$h = Base64UrlEncode([Text.Encoding]::UTF8.GetBytes($header))
$p = Base64UrlEncode([Text.Encoding]::UTF8.GetBytes($payload))
$sigInput = [Text.Encoding]::UTF8.GetBytes("$h.$p")
$hmac = New-Object System.Security.Cryptography.HMACSHA256
$hmac.Key = [Text.Encoding]::UTF8.GetBytes($secret)
$sig = Base64UrlEncode($hmac.ComputeHash($sigInput))
$token = "$h.$p.$sig"

$headers = @{ "Authorization" = "Bearer $token" }

Invoke-RestMethod -Method Post -Uri http://localhost:8082/api/v1/consents -Headers $headers -ContentType "application/json" -Body '{"yojanaId":"YID-TEST","scope":["profile.read","eligibility.evaluate"],"expiresAt":"2026-12-31","issuedBy":"ci"}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8081/api/v1/citizens -Headers $headers -ContentType "application/json" -Body '{"yojanaId":"YID-TEST","demographics":{"name":"Test","dob":"2000-01-01","gender":"M","language":"hi"},"contact":{"mobile":"999","address":"X","district":"D","state":"S"},"attributes":{"farmer":"yes","landHolding":"small"},"consentToken":"CONSENT","source":"ci"}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8083/api/v1/policies -Headers $headers -ContentType "application/json" -Body '{"policyId":"PM-KISAN","version":"2026-02-10.1","effectiveFrom":"2026-02-15","rulesetUri":"object-store://policies/PM-KISAN/2026-02-10.1","checksum":"sha256:x","approvals":["legal","domain"]}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8084/api/v1/eligibility/evaluate -Headers $headers -ContentType "application/json" -Body '{"citizenId":"CID-1","policyId":"PM-KISAN","policyVersion":"2026-02-10.1","inputSnapshotVersion":"2026-02-10.1","attributes":{"farmer":"yes","landHolding":"small"}}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8092/api/v1/edge/sync -Headers $headers -ContentType "application/json" -Body '{"edgeId":"EDGE-1","lastSyncAt":"2026-02-10T00:00:00Z","events":[],"policyBundleVersions":[],"updates":[{"key":"k1","value":"v1","updatedAt":"2026-02-10T00:00:00Z"}]}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8093/api/v1/workflows/start -Headers $headers -ContentType "application/json" -Body '{"type":"benefit-disbursal","citizenId":"CID-1","policyId":"PM-KISAN","eligibilityRef":"AUD-1"}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8000/api/v1/asr/transcribe -Headers $headers -ContentType "application/json" -Body '{"audioRef":"local://a","language":"hi-IN"}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8001/api/v1/analytics/forecast -Headers $headers -ContentType "application/json" -Body '{"window_from":"2026-02-01","window_to":"2026-02-10","district":"D","signals":["s1"]}' | Out-Null
Invoke-RestMethod -Method Post -Uri http://localhost:8002/api/v1/vector/search -Headers $headers -ContentType "application/json" -Body '{"query":"test","top_k":3}' | Out-Null

Write-Host "smoke tests passed"
