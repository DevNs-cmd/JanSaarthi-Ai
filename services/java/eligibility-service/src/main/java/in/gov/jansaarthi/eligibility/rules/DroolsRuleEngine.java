package in.gov.jansaarthi.eligibility.rules;

import in.gov.jansaarthi.eligibility.model.EligibilityRequest;
import in.gov.jansaarthi.eligibility.model.EligibilityResponse;
import java.util.List;
import java.util.UUID;
import org.kie.api.KieServices;
import org.kie.api.builder.KieBuilder;
import org.kie.api.builder.KieFileSystem;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.internal.io.ResourceFactory;

public class DroolsRuleEngine {
  private final KieContainer kieContainer;

  public DroolsRuleEngine() {
    KieServices ks = KieServices.Factory.get();
    KieFileSystem kfs = ks.newKieFileSystem();
    kfs.write(ResourceFactory.newClassPathResource("rules/default.drl"));
    KieBuilder kb = ks.newKieBuilder(kfs).buildAll();
    if (kb.getResults().hasMessages(org.kie.api.builder.Message.Level.ERROR)) {
      throw new IllegalStateException(kb.getResults().toString());
    }
    this.kieContainer = ks.newKieContainer(ks.getRepository().getDefaultReleaseId());
  }

  public EligibilityResponse evaluate(EligibilityRequest request) {
    KieSession session = kieContainer.newKieSession();
    CitizenFacts facts = new CitizenFacts();
    facts.farmer = request.attributes.getOrDefault("farmer", "no");
    facts.landHolding = request.attributes.getOrDefault("landHolding", "large");
    facts.gender = request.attributes.getOrDefault("gender", "");
    facts.disability = request.attributes.getOrDefault("disability", "");
    session.insert(facts);
    DecisionCollector collector = new DecisionCollector();
    session.setGlobal("collector", collector);
    session.fireAllRules();
    session.dispose();

    boolean eligible = collector.eligible;
    String decisionCode = eligible ? "ELIGIBLE" : "INELIGIBLE";
    var exp = new EligibilityResponse.Explanation(
        collector.ruleId,
        collector.message,
        List.of("farmer", "landHolding"),
        request.policyVersion
    );
    return new EligibilityResponse(eligible, decisionCode, List.of(exp), "AUD-" + UUID.randomUUID());
  }
}
