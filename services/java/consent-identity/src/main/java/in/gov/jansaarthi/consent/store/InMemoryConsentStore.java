package in.gov.jansaarthi.consent.store;

import in.gov.jansaarthi.consent.model.ConsentRequest;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class InMemoryConsentStore {
  private final Map<String, ConsentRequest> store = new ConcurrentHashMap<>();

  public void put(String consentId, ConsentRequest request) {
    store.put(consentId, request);
  }

  public ConsentRequest get(String consentId) {
    return store.get(consentId);
  }
}
