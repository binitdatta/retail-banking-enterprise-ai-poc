package com.nexusbank.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.client.oidc.web.logout.OidcClientInitiatedLogoutSuccessHandler;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    private static final String[] PUBLIC_PATHS = {
            "/actuator/health",
            "/error",
            "/css/**",
            "/js/**",
            "/images/**",
            "/webjars/**"
    };

    // ── Chain 1: REST API — stateless JWT ────────────────────────────────────
    @Bean
    @Order(1)
    public SecurityFilterChain apiSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher("/api/v1/**")
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/v1/public/**").permitAll()
                        .requestMatchers("/api/v1/admin/**").hasRole("NEXUS_ADMIN")
                        .requestMatchers("/api/v1/**").hasAnyRole("NEXUS_USER", "NEXUS_BANKER", "NEXUS_ADMIN")
                )
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .oauth2ResourceServer(rs -> rs
                        .jwt(jwt -> jwt.jwtAuthenticationConverter(keycloakJwtConverter()))
                )
                .csrf(csrf -> csrf.disable());
        return http.build();
    }

    // ── Chain 2: UI — PKCE Authorization Code ────────────────────────────────
    @Bean
    @Order(2)
    public SecurityFilterChain uiSecurityFilterChain(
            HttpSecurity http,
            ClientRegistrationRepository clientRegistrationRepository) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(PUBLIC_PATHS).permitAll()
                        .requestMatchers("/oauth2/**", "/login/oauth2/**").permitAll()
                        .requestMatchers("/dashboard/**", "/accounts/**", "/loans/**",
                                "/transactions/**", "/cards/**", "/profile/**")
                        .hasAnyRole("NEXUS_USER", "NEXUS_BANKER", "NEXUS_ADMIN")
                        .requestMatchers("/admin/**").hasRole("NEXUS_ADMIN")
                        .requestMatchers("/banker/**").hasAnyRole("NEXUS_BANKER", "NEXUS_ADMIN")
                        .anyRequest().authenticated()
                )
                .oauth2Login(oauth2 -> oauth2
                        .loginPage("/oauth2/authorization/keycloak")
                        .userInfoEndpoint(ui -> ui.oidcUserService(oidcUserService()))
                        .defaultSuccessUrl("/dashboard", true)
                        .failureUrl("/error")
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .logoutSuccessHandler(oidcLogoutSuccessHandler(clientRegistrationRepository))
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                )
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) ->
                                response.sendRedirect(request.getContextPath()
                                        + "/oauth2/authorization/keycloak")
                        )
                );
        return http.build();
    }

    /**
     * Custom OidcUserService that extracts realm_access.roles from the OIDC ID token
     * and maps them to Spring Security GrantedAuthority objects (ROLE_NEXUS_*).
     * This is required for the UI OAuth2 Login flow — JwtAuthenticationConverter
     * only applies to the Resource Server (REST API) flow.
     */
    @Bean
    public OAuth2UserService<OidcUserRequest, OidcUser> oidcUserService() {
        OidcUserService delegate = new OidcUserService();
        return userRequest -> {
            OidcUser oidcUser = delegate.loadUser(userRequest);

            // Extract existing authorities (OIDC_USER, SCOPE_*)
            Set<GrantedAuthority> authorities = new HashSet<>(oidcUser.getAuthorities());

            // Extract realm_access.roles from the ID token claims
            Map<String, Object> claims = oidcUser.getClaims();
            Object realmAccessObj = claims.get("realm_access");
            if (realmAccessObj instanceof Map<?, ?> realmAccess) {
                Object rolesObj = realmAccess.get("roles");
                if (rolesObj instanceof List<?> roles) {
                    roles.stream()
                            .filter(r -> r instanceof String)
                            .map(r -> (String) r)
                            .filter(r -> r.startsWith("NEXUS_"))
                            .map(r -> new SimpleGrantedAuthority("ROLE_" + r))
                            .forEach(authorities::add);
                }
            }

            return new DefaultOidcUser(
                    authorities,
                    oidcUser.getIdToken(),
                    oidcUser.getUserInfo()
            );
        };
    }

    // ── JWT Converter for REST API Resource Server ────────────────────────────
    @Bean
    public JwtAuthenticationConverter keycloakJwtConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(this::extractKeycloakRoles);
        return converter;
    }

    @SuppressWarnings("unchecked")
    private Collection<GrantedAuthority> extractKeycloakRoles(Jwt jwt) {
        Map<String, Object> realmAccess = jwt.getClaim("realm_access");
        if (realmAccess == null || !realmAccess.containsKey("roles")) {
            return List.of();
        }
        List<String> roles = (List<String>) realmAccess.get("roles");
        return roles.stream()
                .filter(role -> role.startsWith("NEXUS_"))
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());
    }

    // ── OIDC logout → Keycloak end_session_endpoint ──────────────────────────
    private LogoutSuccessHandler oidcLogoutSuccessHandler(
            ClientRegistrationRepository clientRegistrationRepository) {
        OidcClientInitiatedLogoutSuccessHandler handler =
                new OidcClientInitiatedLogoutSuccessHandler(clientRegistrationRepository);
        handler.setPostLogoutRedirectUri("http://localhost:9099/nexusbank/dashboard");
        return handler;
    }
}