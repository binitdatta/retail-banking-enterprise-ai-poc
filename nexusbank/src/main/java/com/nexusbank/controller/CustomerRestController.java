package com.nexusbank.controller;

import com.nexusbank.domain.entity.Customer;
import com.nexusbank.repository.CustomerRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/customers")
public class CustomerRestController {

    private final CustomerRepository customerRepository;

    public CustomerRestController(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @GetMapping("/me")
    @PreAuthorize("hasAnyRole('NEXUS_USER','NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<Map<String, Object>> getMyProfile(@AuthenticationPrincipal Jwt jwt) {
        return customerRepository.findByKeycloakUserId(jwt.getSubject())
                .map(c -> ResponseEntity.ok(Map.<String, Object>of(
                        "customerId",     c.getCustomerId(),
                        "customerNumber", c.getCustomerNumber(),
                        "fullName",       c.getFullName(),
                        "email",          c.getEmail(),
                        "customerType",   c.getCustomerType().name(),
                        "kycStatus",      c.getKycStatus().name(),
                        "creditScore",    c.getCreditScore() != null ? c.getCreditScore() : "N/A"
                )))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<List<Customer>> getAllCustomers() {
        return ResponseEntity.ok(customerRepository.findByIsActive(true));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<Customer> getCustomer(@PathVariable Long id) {
        return customerRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}