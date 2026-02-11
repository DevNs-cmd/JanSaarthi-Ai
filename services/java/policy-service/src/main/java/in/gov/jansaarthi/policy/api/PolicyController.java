package in.gov.jansaarthi.policy.api;

import in.gov.jansaarthi.policy.entity.PolicyEntity;
import in.gov.jansaarthi.policy.model.PolicyPublishRequest;
import in.gov.jansaarthi.policy.model.PolicyPublishResponse;
import in.gov.jansaarthi.policy.repo.PolicyRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1")
public class PolicyController {
  private final PolicyRepository repo;

  public PolicyController(PolicyRepository repo) {
    this.repo = repo;
  }

  @PostMapping("/policies")
  @PreAuthorize("hasRole('POLICY_WRITE')")
  public ResponseEntity<PolicyPublishResponse> publish(@Valid @RequestBody PolicyPublishRequest request) {
    String key = request.policyId + ":" + request.version;
    PolicyEntity e = new PolicyEntity();
    e.policyKey = key;
    e.policyId = request.policyId;
    e.version = request.version;
    e.effectiveFrom = request.effectiveFrom;
    e.rulesetUri = request.rulesetUri;
    e.checksum = request.checksum;
    e.approvalsCsv = request.approvals == null ? "" : String.join(",", request.approvals);
    repo.save(e);
    return ResponseEntity.ok(new PolicyPublishResponse("published", request.policyId, request.version));
  }

  @GetMapping("/policies/{policyId}/versions/{version}")
  @PreAuthorize("hasRole('POLICY_READ')")
  public ResponseEntity<PolicyEntity> get(@PathVariable String policyId, @PathVariable String version) {
    String key = policyId + ":" + version;
    return repo.findById(key).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
  }
}
