package in.gov.jansaarthi.eligibility.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "eligibility_decisions")
public class EligibilityDecisionEntity {
  @Id
  public String auditRef;
  public String citizenId;
  public String policyId;
  public String policyVersion;
  public boolean eligible;
  public String decisionCode;
  public String explanation;
  public String occurredAt;
}
