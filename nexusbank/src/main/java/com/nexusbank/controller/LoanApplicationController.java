package com.nexusbank.controller;

import com.nexusbank.domain.dto.MortgageApplicationDTO;
import com.nexusbank.domain.entity.LoanApplication;
import com.nexusbank.domain.entity.MortgageDetail;
import com.nexusbank.repository.CustomerRepository;
import com.nexusbank.service.MortgageApplicationService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/loans/applications")
public class LoanApplicationController {

    private final MortgageApplicationService applicationService;
    private final CustomerRepository         customerRepository;

    public LoanApplicationController(MortgageApplicationService applicationService,
                                     CustomerRepository customerRepository) {
        this.applicationService = applicationService;
        this.customerRepository = customerRepository;
    }

    // ── GET: Mortgage application form ────────────────────────────────────────
    @GetMapping("/mortgage/new")
    public String newMortgageForm(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            model.addAttribute("customer", customer);
        });
        model.addAttribute("mortgageForm", new MortgageApplicationDTO());
        model.addAttribute("propertyTypes",  MortgageDetail.PropertyType.values());
        model.addAttribute("rateTypes",      com.nexusbank.domain.entity.Loan.RateType.values());
        model.addAttribute("termOptions",    List.of(60, 84, 120, 180, 240, 300, 360));
        return "loans/apply-mortgage";
    }

    // ── POST: Submit mortgage application ─────────────────────────────────────
    @PostMapping("/mortgage/submit")
    public String submitMortgageApplication(
            @AuthenticationPrincipal OidcUser oidcUser,
            @Valid @ModelAttribute("mortgageForm") MortgageApplicationDTO form,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttrs) {

        // Cross-field validation: down payment must not exceed purchase price
        if (form.getPurchasePrice() != null && form.getDownPayment() != null
                && form.getDownPayment().compareTo(form.getPurchasePrice()) >= 0) {
            bindingResult.rejectValue("downPayment", "downPayment.tooHigh",
                    "Down payment cannot be equal to or greater than the purchase price");
        }

        // Cross-field validation: loan amount must not exceed purchase price
        if (form.getPurchasePrice() != null && form.getRequestedAmount() != null
                && form.getRequestedAmount().compareTo(form.getPurchasePrice()) > 0) {
            bindingResult.rejectValue("requestedAmount", "requestedAmount.tooHigh",
                    "Loan amount cannot exceed the purchase price");
        }

        if (bindingResult.hasErrors()) {
            customerRepository.findByKeycloakUserId(oidcUser.getSubject())
                    .ifPresent(c -> model.addAttribute("customer", c));
            model.addAttribute("propertyTypes", MortgageDetail.PropertyType.values());
            model.addAttribute("rateTypes",     com.nexusbank.domain.entity.Loan.RateType.values());
            model.addAttribute("termOptions",   List.of(60, 84, 120, 180, 240, 300, 360));
            return "loans/apply-mortgage";
        }

        var customerOpt = customerRepository.findByKeycloakUserId(oidcUser.getSubject());
        if (customerOpt.isEmpty()) {
            redirectAttrs.addFlashAttribute("errorMessage",
                    "Customer record not found. Please contact support.");
            return "redirect:/loans/apply";
        }

        LoanApplication saved = applicationService.submitMortgageApplication(
                customerOpt.get(), form);

        redirectAttrs.addFlashAttribute("successMessage",
                "Your mortgage application " + saved.getApplicationNumber()
                        + " has been submitted successfully. A banker will review it within 2 business days.");
        redirectAttrs.addFlashAttribute("applicationNumber", saved.getApplicationNumber());
        return "redirect:/loans/applications/confirmation";
    }

    // ── GET: Confirmation page ────────────────────────────────────────────────
    @GetMapping("/confirmation")
    public String confirmation(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject())
                .ifPresent(c -> model.addAttribute("customer", c));
        return "loans/apply-confirmation";
    }

    // ── GET: My Applications ──────────────────────────────────────────────────
    @GetMapping("/my")
    public String myApplications(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            model.addAttribute("customer",     customer);
            model.addAttribute("applications",
                    applicationService.getApplicationsForCustomer(customer.getCustomerId()));
        });
        return "loans/my-applications";
    }

    // ── GET: Application detail ───────────────────────────────────────────────
    @GetMapping("/{id}")
    public String applicationDetail(@PathVariable Long id,
                                    @AuthenticationPrincipal OidcUser oidcUser,
                                    Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject())
                .ifPresent(c -> model.addAttribute("customer", c));
        applicationService.getApplicationWithDetail(id)
                .ifPresent(a -> model.addAttribute("application", a));
        return "loans/application-detail";
    }

    // ── GET: Banker — all applications queue ──────────────────────────────────
    @GetMapping("/banker/queue")
    public String bankerQueue(Model model) {
        model.addAttribute("applications",  applicationService.getAllApplications());
        model.addAttribute("pendingCount",  applicationService.getPendingApplications().size());
        return "banker/application-queue";
    }

    // ── POST: Banker — update application status ──────────────────────────────
    @PostMapping("/banker/review/{id}")
    public String bankerReview(@PathVariable Long id,
                               @RequestParam String status,
                               @RequestParam(required = false) String reviewerNotes,
                               @AuthenticationPrincipal OidcUser oidcUser,
                               RedirectAttributes redirectAttrs) {
        try {
            LoanApplication.ApplicationStatus newStatus =
                    LoanApplication.ApplicationStatus.valueOf(status);
            String reviewerName = oidcUser.getFullName() != null
                    ? oidcUser.getFullName() : oidcUser.getPreferredUsername();
            applicationService.updateStatus(id, newStatus, reviewerName, reviewerNotes);
            redirectAttrs.addFlashAttribute("successMessage",
                    "Application status updated to " + newStatus.getDisplayName());
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("errorMessage",
                    "Failed to update application: " + e.getMessage());
        }
        return "redirect:/loans/applications/banker/queue";
    }
}