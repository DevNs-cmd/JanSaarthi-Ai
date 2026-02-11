# JanSaarthi AI Reference Architecture

## Purpose
This document provides the production-grade reference architecture for JanSaarthi AI, along with system boundaries, trust zones, and operational assumptions. It aligns with deterministic policy execution, offline-first operation, and national-scale auditability.

## Architecture Overview
JanSaarthi AI is a national digital public infrastructure composed of multiple planes.

- Interaction plane: citizen apps, kiosks, IVR, WhatsApp, government dashboards
- Policy plane: deterministic policy authoring, validation, versioning, and eligibility execution
- Event plane: Kafka backbone with schema registry and event sourcing
- Knowledge plane: knowledge graph and vector search for proactive discovery
- Edge plane: k3s clusters at district or block level with offline execution
- Intelligence plane: aggregated, anonymized analytics and forecasts
- Security plane: zero-trust, identity, consent, audit, and encryption
- Operations plane: CI/CD, IaC, monitoring, SRE tooling

## Trust Zones
- Zone A: Citizen devices and kiosks (low trust)
- Zone B: Edge cluster within district (medium trust)
- Zone C: State data center (high trust)
- Zone D: National data center (highest trust)

## Deterministic Decisioning
Policy rules are authoritative. AI services can suggest relevant policies, but cannot override eligibility determinations. All eligibility decisions are explainable and reproducible from policy version, input data, and execution logs.

## Data Residency
All data, models, and policy artifacts are hosted and processed in India. No external black-box APIs are used for eligibility or core inference.

## Operational Assumptions
- Each district has at least one edge cluster connected to state data centers.
- Policy publication follows a formal change-control process with versioned bundles.
- Event streams are partitioned by state and district.
- Edge clusters maintain a minimum offline window of 30 days.

## Files
- `docs/diagrams.mmd` includes architecture diagrams and interaction flows.
- `docs/api-contracts.md` defines service APIs.
- `docs/event-schemas.md` defines event schemas and topic naming.
- `docs/policy-dsl.md` defines the policy DSL and versioning approach.
- `docs/rollout-plan.md` defines the phased implementation plan.
