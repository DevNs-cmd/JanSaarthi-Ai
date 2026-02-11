package in.gov.jansaarthi.citizen.model;

public class CitizenProfileResponse {
  public String citizenId;
  public String status;
  public String profileVersion;

  public CitizenProfileResponse(String citizenId, String status, String profileVersion) {
    this.citizenId = citizenId;
    this.status = status;
    this.profileVersion = profileVersion;
  }
}
