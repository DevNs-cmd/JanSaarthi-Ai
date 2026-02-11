package in.gov.jansaarthi.consent.api;

import in.gov.jansaarthi.consent.entity.ConsentEntity;
import in.gov.jansaarthi.consent.model.ConsentRequest;
import in.gov.jansaarthi.consent.model.ConsentResponse;
import in.gov.jansaarthi.consent.repo.ConsentRepository;
import jakarta.validation.Valid;
import java.util.UUID;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class ConsentController {
  private final ConsentRepository repo;

  public ConsentController(ConsentRepository repo) {
    this.repo = repo;
  }

  @PostMapping("/consents")
  @PreAuthorize("hasRole('CONSENT_WRITE')")
  public ResponseEntity<ConsentResponse> create(@Valid @RequestBody ConsentRequest request) {
    String consentId = "CONSENT-" + UUID.randomUUID();
    String token = "CONSENT-TOKEN-" + UUID.randomUUID();
    ConsentEntity e = new ConsentEntity();
    e.consentId = consentId;
    e.yojanaId = request.yojanaId;
    e.scopeCsv = request.scope == null ? "" : String.join(",", request.scope);
    e.expiresAt = request.expiresAt;
    e.issuedBy = request.issuedBy;
    e.consentToken = token;
    e.status = "active";
    repo.save(e);
    return ResponseEntity.ok(new ConsentResponse(token, consentId, "active"));
  }

  @GetMapping("/consents/{consentId}")
  @PreAuthorize("hasRole('CONSENT_READ')")
  public ResponseEntity<ConsentEntity> get(@PathVariable String consentId) {
    return repo.findById(consentId).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
}
