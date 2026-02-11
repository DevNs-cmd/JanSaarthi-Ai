package in.gov.jansaarthi.eligibility.api;

import in.gov.jansaarthi.eligibility.entity.EligibilityDecisionEntity;
import in.gov.jansaarthi.eligibility.events.EventPublisher;
import in.gov.jansaarthi.eligibility.model.EligibilityRequest;
import in.gov.jansaarthi.eligibility.model.EligibilityResponse;
import in.gov.jansaarthi.eligibility.repo.EligibilityDecisionRepository;
import in.gov.jansaarthi.eligibility.rules.DroolsRuleEngine;
import jakarta.validation.Valid;
import java.time.Instant;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class EligibilityController {
  private final DroolsRuleEngine engine = new DroolsRuleEngine();
  private final EligibilityDecisionRepository repo;
  private final EventPublisher publisher;

  public EligibilityController(EligibilityDecisionRepository repo,
      @Value("${event.streaming.endpoint}") String endpoint) {
    this.repo = repo;
    this.publisher = new EventPublisher(endpoint);
  }

  @PostMapping("/eligibility/evaluate")
  @PreAuthorize("hasRole('ELIGIBILITY_EXECUTE')")
  public ResponseEntity<EligibilityResponse> evaluate(@Valid @RequestBody EligibilityRequest request,
      @RequestHeader(value = "X-Trace-Id", required = false) String traceId,
      @RequestHeader(value = "X-Consent-Token", required = false) String consentToken) {
    EligibilityResponse resp = engine.evaluate(request);

    EligibilityDecisionEntity e = new EligibilityDecisionEntity();
    e.auditRef = resp.auditRef;
    e.citizenId = request.citizenId;
    e.policyId = request.policyId;
    e.policyVersion = request.policyVersion;
    e.eligible = resp.eligible;
    e.decisionCode = resp.decisionCode;
    e.explanation = resp.explanations.get(0).message;
    e.occurredAt = Instant.now().toString();
    repo.save(e);

    String payload = "{\"citizenId\":\"" + request.citizenId + "\",\"policyId\":\"" + request.policyId + "\",\"eligible\":" + resp.eligible + "}";
    publisher.publish("eligibility.evaluated", payload, request.policyVersion, consentToken == null ? "" : consentToken,
        traceId == null ? "" : traceId);

    return ResponseEntity.ok(resp);
  }
}
