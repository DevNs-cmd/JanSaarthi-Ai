package in.gov.jansaarthi.citizen.entity;

import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.util.Map;

@Entity
@Table(name = "citizen_profiles")
public class CitizenProfileEntity {
  @Id
  public String citizenId;
  public String yojanaId;
  public String name;
  public String dob;
  public String gender;
  public String language;
  public String mobile;
  public String address;
  public String district;
  public String state;

  @ElementCollection
  public Map<String, String> attributes;

  public String profileVersion;
}
