# JanSaarthi AI – National Opportunity Intelligence Infrastructure for Bharat

This repository contains a production-grade, infrastructure-first reference implementation of **JanSaarthi AI**, a deterministic, offline-first, policy-driven national opportunity intelligence system. It is **not** a chatbot or demo. The system is built for auditability, replayability, and district-to-national scale.

## Core Principles
- Deterministic policy rules are authoritative (AI never overrides eligibility).
- Offline-first execution on edge clusters (district/block) with bidirectional sync.
- Event-driven backbone with schema enforcement and replayable audit trails.
- Sovereign AI (no foreign black-box dependencies for core decisions).
- India data residency and privacy by design.

## Repository Layout
- `services/java/` — Spring Boot services (Citizen Profile, Consent & Identity, Policy, Eligibility)
- `services/go/` — Go services (Event streaming, Edge sync, Workflow orchestration)
- `services/python/` — AI inference + analytics (ASR, Analytics, Vector search)
- `schemas/` — Protobuf contracts
- `infra/` — Docker Compose, Kubernetes manifests, Terraform baseline
- `edge/` — Edge runtime configuration
- `.github/workflows/` — CI pipeline (unit + integration)

## Services
**Java (Spring Boot)**
- Citizen Profile Service (profile storage, RBAC)
- Consent & Identity Service (Yojana ID, consent ledger)
- Policy Service (versioned policies)
- Eligibility Service (Drools-based deterministic evaluation + audit)

**Go**
- Event Streaming Service (Kafka producer, schema-ready)
- Edge Sync Service (offline updates + conflict resolution)
- Workflow Orchestrator (benefit lifecycle orchestration)

**Python (FastAPI)**
- ASR Service (offline-capable voice inference placeholder)
- Analytics Service (aggregated forecasting placeholder)
- Vector Search Service (FAISS placeholder)

## Security & Auth
**Modes**
- `hs256` (default): local JWT with issuer/audience validation
- `oidc`: Keycloak/OIDC via JWKS or issuer URI

**Required Claims**
- `iss`: `jan-saarthi`
- `aud`: `jan-saarthi-services`
- `roles`: service-specific roles (RBAC)

**mTLS (optional)**
- Enabled via `MTLS_ENABLED=true`
- Requires service certs and CA trust chain

**Vault (optional)**
- If `VAULT_ADDR`, `VAULT_TOKEN`, `VAULT_SECRET_PATH` are set, services load JWT secrets from Vault.

## Run Full Stack (Docker)
```powershell
docker compose -f infra/docker-compose.full.yaml up -d --build
```

## Smoke Tests
### PowerShell
```powershell
.\infra\ci-smoke.ps1
```

### Bash
```bash
bash infra/ci-smoke.sh
```

## CI
CI runs:
- Java unit tests (per service)
- Go unit tests
- Python unit tests
- Full integration stack + smoke tests

CI file: `.github/workflows/ci.yml`

## Switching to OIDC (Keycloak)
Set service envs:
- `SECURITY_JWT_MODE=oidc`
- `SECURITY_JWT_ISSUER_URI=http://keycloak:8080/realms/jan-saarthi`

Go/Python:
- `OIDC_JWKS_URL=http://keycloak:8080/realms/jan-saarthi/protocol/openid-connect/certs`
- `AUTH_MODE=oidc` (Python)

## Default Roles
- `PROFILE_WRITE`, `PROFILE_READ`
- `CONSENT_WRITE`, `CONSENT_READ`
- `POLICY_WRITE`, `POLICY_READ`
- `ELIGIBILITY_EXECUTE`
- `EVENT_WRITE`
- `EDGE_SYNC`
- `WORKFLOW_WRITE`
- `ASR_EXECUTE`
- `ANALYTICS_READ`
- `VECTOR_SEARCH`

## Documentation
- Threat Model: `docs/threat-model.md`
- Data Retention & Deletion: `docs/data-retention.md`
- API Examples: `docs/api-examples.md`
- Deployment Runbook: `docs/deployment-runbook.md`

## Notes
- This repo is a production-grade baseline, not a toy demo.
- Replace placeholder secrets before any real deployment.
- Integrate real ASR/TTS models and FAISS indexing for production.

## Compliance
Designed to align with:
- IT Act
- Indian data protection requirements
- Auditability and deterministic governance standards
