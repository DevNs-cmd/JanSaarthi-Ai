package in.gov.jansaarthi.consent.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "consents")
public class ConsentEntity {
  @Id
  public String consentId;
  public String yojanaId;
  public String scopeCsv;
  public String expiresAt;
  public String issuedBy;
  public String consentToken;
  public String status;
}
