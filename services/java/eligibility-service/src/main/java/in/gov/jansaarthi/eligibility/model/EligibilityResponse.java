package in.gov.jansaarthi.eligibility.model;

import java.util.List;

public class EligibilityResponse {
  public boolean eligible;
  public String decisionCode;
  public List<Explanation> explanations;
  public String auditRef;

  public EligibilityResponse(boolean eligible, String decisionCode, List<Explanation> explanations, String auditRef) {
    this.eligible = eligible;
    this.decisionCode = decisionCode;
    this.explanations = explanations;
    this.auditRef = auditRef;
  }

  public static class Explanation {
    public String ruleId;
    public String message;
    public List<String> inputsUsed;
    public String policyVersion;

    public Explanation(String ruleId, String message, List<String> inputsUsed, String policyVersion) {
      this.ruleId = ruleId;
      this.message = message;
      this.inputsUsed = inputsUsed;
      this.policyVersion = policyVersion;
    }
  }
}
