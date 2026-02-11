package in.gov.jansaarthi.eligibility.model;

import jakarta.validation.constraints.NotBlank;
import java.util.Map;

public class EligibilityRequest {
  @NotBlank
  public String citizenId;
  @NotBlank
  public String policyId;
  @NotBlank
  public String policyVersion;
  @NotBlank
  public String inputSnapshotVersion;
  public String location;
  public String channel;
  public Map<String, String> attributes;
}
