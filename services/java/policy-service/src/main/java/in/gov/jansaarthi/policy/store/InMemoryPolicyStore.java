package in.gov.jansaarthi.policy.store;

import in.gov.jansaarthi.policy.model.PolicyPublishRequest;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class InMemoryPolicyStore {
  private final Map<String, PolicyPublishRequest> store = new ConcurrentHashMap<>();

  public void put(String policyKey, PolicyPublishRequest request) {
    store.put(policyKey, request);
  }

  public PolicyPublishRequest get(String policyKey) {
    return store.get(policyKey);
  }
}
