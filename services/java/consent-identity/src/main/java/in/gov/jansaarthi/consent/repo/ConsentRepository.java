package in.gov.jansaarthi.consent.repo;

import in.gov.jansaarthi.consent.entity.ConsentEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ConsentRepository extends JpaRepository<ConsentEntity, String> {}
