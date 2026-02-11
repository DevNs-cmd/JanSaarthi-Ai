package in.gov.jansaarthi.citizen.api;

import in.gov.jansaarthi.citizen.entity.CitizenProfileEntity;
import in.gov.jansaarthi.citizen.model.CitizenProfileRequest;
import in.gov.jansaarthi.citizen.model.CitizenProfileResponse;
import in.gov.jansaarthi.citizen.repo.CitizenProfileRepository;
import jakarta.validation.Valid;
import java.time.Instant;
import java.util.UUID;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class CitizenProfileController {
  private final CitizenProfileRepository repo;

  public CitizenProfileController(CitizenProfileRepository repo) {
    this.repo = repo;
  }

  @PostMapping("/citizens")
  @PreAuthorize("hasRole('PROFILE_WRITE')")
  public ResponseEntity<CitizenProfileResponse> upsert(@Valid @RequestBody CitizenProfileRequest request) {
    String citizenId = "CID-" + UUID.randomUUID();
    CitizenProfileEntity e = new CitizenProfileEntity();
    e.citizenId = citizenId;
    e.yojanaId = request.yojanaId;
    if (request.demographics != null) {
      e.name = request.demographics.name;
      e.dob = request.demographics.dob;
      e.gender = request.demographics.gender;
      e.language = request.demographics.language;
    }
    if (request.contact != null) {
      e.mobile = request.contact.mobile;
      e.address = request.contact.address;
      e.district = request.contact.district;
      e.state = request.contact.state;
    }
    e.attributes = request.attributes;
    e.profileVersion = Instant.now().toString();
    repo.save(e);
    return ResponseEntity.ok(new CitizenProfileResponse(citizenId, "updated", e.profileVersion));
  }

  @GetMapping("/citizens/{citizenId}")
  @PreAuthorize("hasRole('PROFILE_READ')")
  public ResponseEntity<CitizenProfileEntity> get(@PathVariable String citizenId) {
    return repo.findById(citizenId).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
}
