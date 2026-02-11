package in.gov.jansaarthi.policyservice.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/policies")
public class PolicyController {

    @GetMapping
    public ResponseEntity<String> getPolicies() {
        return ResponseEntity.ok("Policies endpoint");
    }

    @PostMapping
    public ResponseEntity<String> createPolicy(@RequestBody String policy) {
        return ResponseEntity.ok("Policy created");
    }
}
