package in.gov.jansaarthi.consent.model;

import jakarta.validation.constraints.NotBlank;
import java.util.List;

public class ConsentRequest {
  @NotBlank
  public String yojanaId;
  public List<String> scope;
  @NotBlank
  public String expiresAt;
  @NotBlank
  public String issuedBy;
}
