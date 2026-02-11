# JanSaarthi AI Policy DSL and Versioning Strategy

## Goals
- Deterministic, auditable, human-readable rules
- Versioned bundles with rollback
- Testable against known citizen profiles
- Supports exclusions and dependencies across schemes

## Policy Package Structure
```
policies/
  PM-KISAN/
    2026-02-10.1/
      metadata.json
      rules.drl
      tests.json
```

## Metadata Schema
```json
{
  "policyId": "PM-KISAN",
  "version": "2026-02-10.1",
  "effectiveFrom": "2026-02-15",
  "effectiveTo": null,
  "jurisdiction": ["IN"],
  "owner": "MoA",
  "dependencies": ["LAND_RECORDS"],
  "exclusions": ["PMKISAN_DUPLICATE"],
  "checksum": "sha256:...",
  "approvals": ["legal", "domain", "security"]
}
```

## Rule DSL (Drools Example)
```java
rule "PM-KISAN Eligibility"
when
  Citizen( farmerCategory == "marginal" || farmerCategory == "small" )
  Citizen( landHolding <= 2 )
  not Citizen( hasDuplicateBenefit == true )
then
  insert(new EligibilityDecision("ELIGIBLE", "PMK-ELIG-001",
    "Farmer category and landholding criteria satisfied"));
end
```

## OPA/Rego Alternative (for ABAC and policy layers)
```rego
package eligibility.pmkisan

eligible {
  input.citizen.farmerCategory == "marginal" or input.citizen.farmerCategory == "small"
  input.citizen.landHolding <= 2
  not input.citizen.hasDuplicateBenefit
}
```

## Versioning and Rollback
- Every policy bundle is immutable once published.
- `effectiveFrom` and `effectiveTo` define time applicability.
- Rollback is performed by changing the active policy pointer, not altering the bundle.
- All eligibility decisions store `policyId` and `policyVersion` for reproducibility.

## Tests
Policy bundles must include a minimum set of test cases.

Example `tests.json`
```json
[
  {
    "caseId": "PMK-ELIG-001",
    "input": {"farmerCategory":"small","landHolding":1.5,"hasDuplicateBenefit":false},
    "expected": {"eligible": true, "decisionCode": "ELIGIBLE"}
  },
  {
    "caseId": "PMK-INELIG-001",
    "input": {"farmerCategory":"large","landHolding":4,"hasDuplicateBenefit":false},
    "expected": {"eligible": false, "decisionCode": "INELIGIBLE"}
  }
]
```
