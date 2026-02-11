# Deployment Runbooks – JanSaarthi AI

## Pre-Deployment Checklist
- Policy bundles signed and approved.
- Secrets provisioned in Vault.
- TLS/mTLS certificates issued and installed.
- Schema registry compatibility checks passed.
- Database migrations reviewed and applied.

## Dev Deployment
1. Start full stack: `docker compose -f infra/docker-compose.full.yaml up -d --build`
2. Run smoke tests: `infra/ci-smoke.ps1` or `infra/ci-smoke.sh`

## Staging Deployment
1. Apply Kubernetes namespace: `kubectl apply -f infra/k8s/namespace.yaml`
2. Deploy services: `kubectl apply -f infra/k8s/`
3. Validate health endpoints and smoke tests.
4. Enable OIDC mode: set `SECURITY_JWT_MODE=oidc` and `AUTH_MODE=oidc`.

## Production Deployment
1. Provision infrastructure using Terraform in `infra/terraform/`.
2. Deploy Keycloak and Vault with hardened configurations.
3. Enable mTLS across all services.
4. Deploy services with canary (10% traffic) for 1 hour.
5. Promote to 100% traffic if SLOs remain stable.

## Rollback Criteria
| Trigger | Action |
|---|---|
| Error rate > 1% for 10 min | Roll back to previous release |
| Eligibility mismatch detected | Disable current policy bundle |
| Security incident | Freeze deployment, rotate secrets |

## Rollback Steps
1. Revert deployment to previous image tag.
2. Restore previous policy version pointer.
3. Replay events for audit validation.
4. Post-incident report within 24 hours.

## Monitoring & Observability
| Signal | Tooling | Purpose |
|---|---|---|
| Metrics | Prometheus / Grafana | SLO tracking, capacity |
| Logs | Centralized log store | Audit and debugging |
| Traces | OpenTelemetry | End-to-end tracing |
| Alerts | PagerDuty / On-call | Incident response |
