package in.gov.jansaarthi.citizen.repo;

import in.gov.jansaarthi.citizen.entity.CitizenProfileEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CitizenProfileRepository extends JpaRepository<CitizenProfileEntity, String> {}
