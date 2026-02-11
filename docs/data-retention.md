# Data Retention & Deletion Policy – JanSaarthi AI

## Retention Periods
| Data Type | Retention Period | Rationale |
|---|---|---|
| Citizen Profiles | 7 years after last activity | Auditability and scheme eligibility history |
| Consent Records | 7 years after expiry | Regulatory compliance and disputes |
| Eligibility Decisions | 10 years | Auditability and replayability |
| Event Streams (Kafka) | 180 days hot, 7 years archive | Operational + audit needs |
| Policy Bundles | Permanent | Legal traceability and rollback |
| Edge Caches | 30 days offline window | Offline-first constraints |
| Logs (system) | 180 days | Security and operational troubleshooting |
| Aggregated Analytics | 10 years | Planning and governance |

## Deletion Workflows
1. Data deletion is initiated by authorized workflow with traceable approvals.
2. Deletion requests are validated against legal hold or audit requirements.
3. Deletion is executed in primary stores, then propagated to replicas and edge caches.
4. Deletion events are recorded in audit logs with immutable references.

## Legal and Compliance Rationale
Retention aligns with:
- IT Act and applicable data protection norms.
- Statutory audit and grievance redressal requirements.
- Scheme-specific mandates defined by ministries.
