package in.gov.jansaarthi.consent.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {
  @Value("${security.jwt.secret}")
  private String jwtSecret;
  @Value("${security.jwt.issuer}")
  private String jwtIssuer;
  @Value("${security.jwt.audience}")
  private String jwtAudience;
  @Value("${security.jwt.mode:hs256}")
  private String jwtMode;
  @Value("${security.jwt.issuer-uri:}")
  private String issuerUri;

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http.csrf(csrf -> csrf.disable());
    if ("oidc".equalsIgnoreCase(jwtMode)) {
      http.oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt -> jwt.issuerUri(issuerUri)));
    } else {
      http.addFilterBefore(new JwtAuthFilter(jwtSecret, jwtIssuer, jwtAudience), UsernamePasswordAuthenticationFilter.class);
    }
    http.authorizeHttpRequests(auth -> auth
        .requestMatchers("/api/v1/consents/**").authenticated()
        .anyRequest().authenticated());
    return http.build();
  }
}
