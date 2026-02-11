# JanSaarthi AI Phased Rollout Plan and KPIs

## Phase 1: Foundation (Months 0-6)
**Objective**: Establish core infrastructure and policy execution backbone.

- Stand up national and state data centers with Kafka backbone.
- Deploy core Spring Boot services: citizen profile, consent, policy, eligibility.
- Establish schema registry, object store, audit log store.
- Build initial policy authoring workflow.

**KPIs**
- 99.9% availability of core services
- Policy publish-to-execution latency < 5 minutes
- 100% policy execution events logged with audit trails

## Phase 2: District Edge Pilot (Months 6-12)
**Objective**: Validate offline-first edge execution and sync.

- Deploy k3s clusters in 10 pilot districts.
- Implement edge sync service and conflict resolution.
- Roll out kiosks and mobile app in pilot regions.
- Enable offline ASR/TTS models for Hindi and one regional language.

**KPIs**
- 95% of eligibility checks executed offline in pilot
- Sync conflict rate < 1%
- Edge uptime > 98%

## Phase 3: Multi-State Expansion (Months 12-24)
**Objective**: Expand to 8-10 states with multi-language support.

- Increase language coverage to 8 Indian languages.
- Expand knowledge graph and vector search capability.
- Launch governance dashboards for district and state administrators.

**KPIs**
- 100M+ citizens covered
- 50+ schemes integrated
- Governance dashboards updated within 24 hours of events

## Phase 4: National Scale (Months 24-36)
**Objective**: Full national deployment and predictive intelligence.

- Expand edge coverage to all districts.
- Full rollout of voice-first access nationwide.
- Enable predictive governance intelligence nationally.

**KPIs**
- 1B+ citizens reachable
- 200+ schemes integrated
- Forecast accuracy within 10% for key demand indicators

## Phase 5: Continuous Optimization (Post 36 months)
**Objective**: Policy optimization and operational maturity.

- Regular policy audits and automated test coverage expansion.
- Maturity in anomaly detection and resource allocation alerts.

**KPIs**
- 100% policies versioned with tests
- 99.99% uptime for citizen-facing services
- Audit log integrity with zero discrepancies
