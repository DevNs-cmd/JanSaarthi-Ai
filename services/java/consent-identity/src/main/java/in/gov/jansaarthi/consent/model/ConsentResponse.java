package in.gov.jansaarthi.consent.model;

public class ConsentResponse {
  public String consentToken;
  public String consentId;
  public String status;

  public ConsentResponse(String consentToken, String consentId, String status) {
    this.consentToken = consentToken;
    this.consentId = consentId;
    this.status = status;
  }
}
