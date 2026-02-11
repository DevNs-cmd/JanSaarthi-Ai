package in.gov.jansaarthi.eligibility.repo;

import in.gov.jansaarthi.eligibility.entity.EligibilityDecisionEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EligibilityDecisionRepository extends JpaRepository<EligibilityDecisionEntity, String> {}
