package in.gov.jansaarthi.eligibility;

import in.gov.jansaarthi.eligibility.model.EligibilityRequest;
import in.gov.jansaarthi.eligibility.rules.DroolsRuleEngine;
import java.util.HashMap;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class EligibilityRuleTest {
  @Test
  void baseRuleEligible() {
    EligibilityRequest req = new EligibilityRequest();
    req.policyVersion = "2026-02-10.1";
    req.attributes = new HashMap<>();
    req.attributes.put("farmer", "yes");
    req.attributes.put("landHolding", "small");
    var engine = new DroolsRuleEngine();
    var resp = engine.evaluate(req);
    assertTrue(resp.eligible);
    assertEquals("ELIGIBLE", resp.decisionCode);
  }

  @Test
  void baseRuleIneligible() {
    EligibilityRequest req = new EligibilityRequest();
    req.policyVersion = "2026-02-10.1";
    req.attributes = new HashMap<>();
    req.attributes.put("farmer", "no");
    req.attributes.put("landHolding", "small");
    var engine = new DroolsRuleEngine();
    var resp = engine.evaluate(req);
    assertFalse(resp.eligible);
    assertEquals("INELIGIBLE", resp.decisionCode);
  }
}
