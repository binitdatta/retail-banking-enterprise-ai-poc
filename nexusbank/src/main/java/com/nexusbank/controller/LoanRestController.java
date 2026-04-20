package com.nexusbank.controller;

import com.nexusbank.domain.entity.Loan;
import com.nexusbank.repository.CustomerRepository;
import com.nexusbank.repository.LoanRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/loans")
public class LoanRestController {

    private final LoanRepository     loanRepository;
    private final CustomerRepository customerRepository;

    public LoanRestController(LoanRepository loanRepository,
                              CustomerRepository customerRepository) {
        this.loanRepository     = loanRepository;
        this.customerRepository = customerRepository;
    }

    @GetMapping("/my-loans")
    @PreAuthorize("hasAnyRole('NEXUS_USER','NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<List<Loan>> getMyLoans(@AuthenticationPrincipal Jwt jwt) {
        return customerRepository.findByKeycloakUserId(jwt.getSubject())
                .map(c -> ResponseEntity.ok(
                        loanRepository.findByCustomer_CustomerIdOrderByCreatedAtDesc(c.getCustomerId())))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('NEXUS_USER','NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<Loan> getLoan(@PathVariable Long id) {
        return loanRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/summary")
    @PreAuthorize("hasAnyRole('NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<List<Object[]>> getLoanSummary() {
        return ResponseEntity.ok(loanRepository.getLoanSummaryByType());
    }
}