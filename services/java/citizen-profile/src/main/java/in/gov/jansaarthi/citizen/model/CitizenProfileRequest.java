package in.gov.jansaarthi.citizen.model;

import jakarta.validation.constraints.NotBlank;
import java.util.Map;

public class CitizenProfileRequest {
  @NotBlank
  public String yojanaId;
  public Demographics demographics;
  public Contact contact;
  public Map<String, String> attributes;
  @NotBlank
  public String consentToken;
  @NotBlank
  public String source;

  public static class Demographics {
    public String name;
    public String dob;
    public String gender;
    public String language;
  }

  public static class Contact {
    public String mobile;
    public String address;
    public String district;
    public String state;
  }
}
