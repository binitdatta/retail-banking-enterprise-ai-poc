package com.nexusbank.service;

import com.nexusbank.domain.dto.MortgageApplicationDTO;
import com.nexusbank.domain.entity.*;
import com.nexusbank.repository.LoanApplicationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MortgageApplicationService {

    private final LoanApplicationRepository applicationRepository;

    public MortgageApplicationService(LoanApplicationRepository applicationRepository) {
        this.applicationRepository = applicationRepository;
    }

    /**
     * Submit a new mortgage application.
     * Snapshots applicant financial data, computes LTV, persists both
     * LoanApplication and MortgageApplicationDetail in one transaction.
     */
    public LoanApplication submitMortgageApplication(Customer customer,
                                                     MortgageApplicationDTO dto) {
        // Build the parent application
        LoanApplication app = new LoanApplication();
        app.setApplicationNumber(generateApplicationNumber());
        app.setCustomer(customer);
        app.setLoanType(Loan.LoanType.MORTGAGE);
        app.setRequestedAmount(dto.getRequestedAmount());
        app.setRequestedTermMonths(dto.getRequestedTermMonths());
        app.setRequestedRateType(dto.getRequestedRateType());
        app.setPurpose(dto.getPurpose() != null ? dto.getPurpose() : "Home Purchase");
        app.setApplicationStatus(LoanApplication.ApplicationStatus.PENDING);

        // Snapshot applicant financials at time of application
        app.setApplicantAnnualIncome(customer.getAnnualIncome());
        app.setApplicantEmploymentStatus(
                customer.getEmploymentStatus() != null
                        ? customer.getEmploymentStatus().name() : null);
        app.setApplicantEmployer(customer.getEmployer());
        app.setApplicantCreditScore(customer.getCreditScore());

        // Build the mortgage detail
        MortgageApplicationDetail detail = new MortgageApplicationDetail();
        detail.setApplication(app);
        detail.setPropertyAddress(dto.getPropertyAddress());
        detail.setPropertyCity(dto.getPropertyCity());
        detail.setPropertyStateCode(dto.getPropertyStateCode().toUpperCase());
        detail.setPropertyZip(dto.getPropertyZip());
        detail.setPropertyType(dto.getPropertyType());
        detail.setPurchasePrice(dto.getPurchasePrice());
        detail.setDownPayment(dto.getDownPayment());
        detail.setRateType(dto.getRequestedRateType());
        detail.setPrimaryResidence(dto.isPrimaryResidence());
        detail.setFirstTimeBuyer(dto.isFirstTimeBuyer());
        detail.setHasExistingMortgage(dto.isHasExistingMortgage());
        detail.setCoBorrowerName(dto.getCoBorrowerName());
        detail.setCoBorrowerIncome(dto.getCoBorrowerIncome());
        detail.setAnnualPropertyTax(dto.getAnnualPropertyTax());
        detail.setAnnualInsurance(dto.getAnnualInsurance());
        detail.setHoaMonthlyFee(dto.getHoaMonthlyFee());
        detail.setPreferredClosingDate(dto.getPreferredClosingDate());
        detail.setRealtorName(dto.getRealtorName());
        detail.setAdditionalNotes(dto.getAdditionalNotes());

        // Compute LTV = (requestedAmount / purchasePrice) * 100
        if (dto.getPurchasePrice() != null
                && dto.getPurchasePrice().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal ltv = dto.getRequestedAmount()
                    .divide(dto.getPurchasePrice(), 4, RoundingMode.HALF_UP)
                    .multiply(BigDecimal.valueOf(100))
                    .setScale(2, RoundingMode.HALF_UP);
            detail.setLtvRatio(ltv);
        }

        app.setMortgageDetail(detail);
        return applicationRepository.save(app);
    }

    /**
     * Retrieve all applications for a given customer, newest first.
     */
    @Transactional(readOnly = true)
    public List<LoanApplication> getApplicationsForCustomer(Long customerId) {
        return applicationRepository
                .findByCustomer_CustomerIdOrderBySubmittedAtDesc(customerId);
    }

    /**
     * Retrieve a single application with its mortgage detail eagerly loaded.
     */
    @Transactional(readOnly = true)
    public Optional<LoanApplication> getApplicationWithDetail(Long applicationId) {
        return applicationRepository.findByIdWithDetail(applicationId);
    }

    /**
     * Retrieve all PENDING applications for the banker review queue.
     */
    @Transactional(readOnly = true)
    public List<LoanApplication> getPendingApplications() {
        return applicationRepository
                .findByStatusForReview(LoanApplication.ApplicationStatus.PENDING);
    }

    /**
     * Retrieve all applications for the banker dashboard (all statuses).
     */
    @Transactional(readOnly = true)
    public List<LoanApplication> getAllApplications() {
        return applicationRepository.findAllWithCustomer();
    }

    /**
     * Banker action: update application status and record reviewer info.
     */
    public LoanApplication updateStatus(Long applicationId,
                                        LoanApplication.ApplicationStatus newStatus,
                                        String reviewedBy,
                                        String reviewerNotes) {
        LoanApplication app = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new IllegalArgumentException(
                        "Application not found: " + applicationId));

        app.setApplicationStatus(newStatus);
        app.setReviewedBy(reviewedBy);
        app.setReviewerNotes(reviewerNotes);
        app.setReviewedAt(LocalDateTime.now());
        return applicationRepository.save(app);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private String generateApplicationNumber() {
        String ts   = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String rand = String.valueOf((int)(Math.random() * 9000) + 1000);
        return "APP-" + ts + "-" + rand;
    }
}