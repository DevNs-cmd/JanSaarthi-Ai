package in.gov.jansaarthi.eligibility.events;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Instant;
import java.util.Map;

public class EventPublisher {
  private final HttpClient client = HttpClient.newHttpClient();
  private final String endpoint;

  public EventPublisher(String endpoint) {
    this.endpoint = endpoint;
  }

  public void publish(String eventType, String payloadJson, String policyVersion, String consentToken, String traceId) {
    String body = "{" +
        "\"eventId\":\"" + java.util.UUID.randomUUID() + "\"," +
        "\"eventType\":\"" + eventType + "\"," +
        "\"eventVersion\":\"1.0\"," +
        "\"occurredAt\":\"" + Instant.now().toString() + "\"," +
        "\"producer\":\"eligibility-service\"," +
        "\"traceId\":\"" + traceId + "\"," +
        "\"policyVersion\":\"" + policyVersion + "\"," +
        "\"consentToken\":\"" + consentToken + "\"," +
        "\"payload\":" + payloadJson +
        "}";
    try {
      HttpRequest req = HttpRequest.newBuilder(URI.create(endpoint))
          .POST(HttpRequest.BodyPublishers.ofString(body))
          .header("Content-Type", "application/json")
          .build();
      client.send(req, HttpResponse.BodyHandlers.discarding());
    } catch (Exception ex) {
      // best-effort event publish; do not block eligibility
    }
  }
}
