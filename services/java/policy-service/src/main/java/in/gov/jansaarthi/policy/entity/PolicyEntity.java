package in.gov.jansaarthi.policy.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "policies")
public class PolicyEntity {
  @Id
  public String policyKey;
  public String policyId;
  public String version;
  public String effectiveFrom;
  public String rulesetUri;
  public String checksum;
  public String approvalsCsv;
}
