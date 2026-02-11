package in.gov.jansaarthi.eligibility.rules;

import in.gov.jansaarthi.eligibility.model.EligibilityRequest;
import in.gov.jansaarthi.eligibility.model.EligibilityResponse;
import java.util.List;
import java.util.UUID;

public class DeterministicRuleEngine {
  public EligibilityResponse evaluate(EligibilityRequest request) {
    // Deterministic, auditable rule example (extend via Drools policies)
    boolean eligible = "yes".equalsIgnoreCase(request.attributes.getOrDefault("farmer", "no"))
        && "small".equalsIgnoreCase(request.attributes.getOrDefault("landHolding", "large"));

    String decisionCode = eligible ? "ELIGIBLE" : "INELIGIBLE";
    EligibilityResponse.Explanation exp = new EligibilityResponse.Explanation(
        "RULE-BASE-001",
        eligible ? "Eligibility criteria satisfied" : "Eligibility criteria not satisfied",
        List.of("farmer", "landHolding"),
        request.policyVersion
    );

    return new EligibilityResponse(eligible, decisionCode, List.of(exp), "AUD-" + UUID.randomUUID());
  }
}
