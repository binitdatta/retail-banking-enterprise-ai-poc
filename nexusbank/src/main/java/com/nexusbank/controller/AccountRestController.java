package com.nexusbank.controller;

import com.nexusbank.domain.entity.Account;
import com.nexusbank.repository.AccountRepository;
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

@RestController
@RequestMapping("/api/v1/accounts")
public class AccountRestController {

    private final AccountRepository  accountRepository;
    private final CustomerRepository customerRepository;

    public AccountRestController(AccountRepository accountRepository,
                                 CustomerRepository customerRepository) {
        this.accountRepository  = accountRepository;
        this.customerRepository = customerRepository;
    }

    @GetMapping("/my-accounts")
    @PreAuthorize("hasAnyRole('NEXUS_USER','NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<List<Account>> getMyAccounts(@AuthenticationPrincipal Jwt jwt) {
        return customerRepository.findByKeycloakUserId(jwt.getSubject())
                .map(c -> ResponseEntity.ok(
                        accountRepository.findByCustomer_CustomerIdOrderByOpenedDateAsc(c.getCustomerId())))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('NEXUS_USER','NEXUS_BANKER','NEXUS_ADMIN')")
    public ResponseEntity<Account> getAccount(@PathVariable Long id) {
        return accountRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}