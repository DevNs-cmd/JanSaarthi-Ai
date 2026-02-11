package in.gov.jansaarthi.citizen.store;

import in.gov.jansaarthi.citizen.model.CitizenProfileRequest;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class InMemoryCitizenStore {
  private final Map<String, CitizenProfileRequest> store = new ConcurrentHashMap<>();

  public void upsert(String citizenId, CitizenProfileRequest request) {
    store.put(citizenId, request);
  }

  public CitizenProfileRequest get(String citizenId) {
    return store.get(citizenId);
  }
}
