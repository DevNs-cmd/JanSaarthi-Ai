package in.gov.jansaarthi.policy.model;

public class PolicyPublishResponse {
  public String status;
  public String policyId;
  public String version;

  public PolicyPublishResponse(String status, String policyId, String version) {
    this.status = status;
    this.policyId = policyId;
    this.version = version;
  }
}
