package in.gov.jansaarthi.policy.model;

import jakarta.validation.constraints.NotBlank;
import java.util.List;

public class PolicyPublishRequest {
  @NotBlank
  public String policyId;
  @NotBlank
  public String version;
  @NotBlank
  public String effectiveFrom;
  public String rulesetUri;
  public String checksum;
  public List<String> approvals;
}
