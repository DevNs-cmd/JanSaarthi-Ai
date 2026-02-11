package in.gov.jansaarthi.policy.repo;

import in.gov.jansaarthi.policy.entity.PolicyEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PolicyRepository extends JpaRepository<PolicyEntity, String> {}
