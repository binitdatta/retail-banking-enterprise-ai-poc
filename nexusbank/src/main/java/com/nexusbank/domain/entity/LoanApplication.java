package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "loan_applications")
public class LoanApplication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "application_id")
    private Long id;

    @Column(name = "application_number", nullable = false, unique = true, length = 30)
    private String applicationNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @Enumerated(EnumType.STRING)
    @Column(name = "loan_type", nullable = false, length = 30)
    private Loan.LoanType loanType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_product_id")
    private LoanProduct loanProduct;

    @Column(name = "requested_amount", nullable = false, precision = 14, scale = 2)
    private BigDecimal requestedAmount;

    @Column(name = "requested_term_months", nullable = false)
    private Integer requestedTermMonths;

    @Enumerated(EnumType.STRING)
    @Column(name = "requested_rate_type", nullable = false, length = 15)
    private Loan.RateType requestedRateType = Loan.RateType.FIXED;

    @Column(name = "purpose", length = 500)
    private String purpose;

    @Enumerated(EnumType.STRING)
    @Column(name = "application_status", nullable = false, length = 30)
    private ApplicationStatus applicationStatus = ApplicationStatus.PENDING;

    // Applicant snapshot at time of application
    @Column(name = "applicant_annual_income", precision = 15, scale = 2)
    private BigDecimal applicantAnnualIncome;

    @Column(name = "applicant_employment_status", length = 20)
    private String applicantEmploymentStatus;

    @Column(name = "applicant_employer", length = 150)
    private String applicantEmployer;

    @Column(name = "applicant_credit_score")
    private Integer applicantCreditScore;

    // Workflow fields
    @Column(name = "submitted_at", nullable = false)
    private LocalDateTime submittedAt;

    @Column(name = "reviewed_at")
    private LocalDateTime reviewedAt;

    @Column(name = "reviewed_by", length = 150)
    private String reviewedBy;

    @Column(name = "reviewer_notes", length = 1000)
    private String reviewerNotes;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Mortgage-specific detail (null for non-mortgage loan types)
    @OneToOne(mappedBy = "application", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private MortgageApplicationDetail mortgageDetail;

    @PrePersist
    protected void onCreate() {
        createdAt   = LocalDateTime.now();
        updatedAt   = LocalDateTime.now();
        submittedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    // ── Enums ─────────────────────────────────────────────────────────────────
    public enum ApplicationStatus {
        PENDING("Pending Review"),
        UNDER_REVIEW("Under Review"),
        APPROVED("Approved"),
        DECLINED("Declined"),
        WITHDRAWN("Withdrawn"),
        CONVERTED("Converted to Loan");

        private final String displayName;
        ApplicationStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    // ── Getters / Setters ─────────────────────────────────────────────────────
    public Long getId()                              { return id; }
    public String getApplicationNumber()             { return applicationNumber; }
    public void setApplicationNumber(String v)       { this.applicationNumber = v; }
    public Customer getCustomer()                    { return customer; }
    public void setCustomer(Customer v)              { this.customer = v; }
    public Loan.LoanType getLoanType()               { return loanType; }
    public void setLoanType(Loan.LoanType v)         { this.loanType = v; }
    public LoanProduct getLoanProduct() { return loanProduct; }
    public void setLoanProduct(LoanProduct v) { this.loanProduct = v; }
    public BigDecimal getRequestedAmount()           { return requestedAmount; }
    public void setRequestedAmount(BigDecimal v)     { this.requestedAmount = v; }
    public Integer getRequestedTermMonths()          { return requestedTermMonths; }
    public void setRequestedTermMonths(Integer v)    { this.requestedTermMonths = v; }
    public Loan.RateType getRequestedRateType()      { return requestedRateType; }
    public void setRequestedRateType(Loan.RateType v){ this.requestedRateType = v; }
    public String getPurpose()                       { return purpose; }
    public void setPurpose(String v)                 { this.purpose = v; }
    public ApplicationStatus getApplicationStatus()  { return applicationStatus; }
    public void setApplicationStatus(ApplicationStatus v) { this.applicationStatus = v; }
    public BigDecimal getApplicantAnnualIncome()     { return applicantAnnualIncome; }
    public void setApplicantAnnualIncome(BigDecimal v) { this.applicantAnnualIncome = v; }
    public String getApplicantEmploymentStatus()     { return applicantEmploymentStatus; }
    public void setApplicantEmploymentStatus(String v) { this.applicantEmploymentStatus = v; }
    public String getApplicantEmployer()             { return applicantEmployer; }
    public void setApplicantEmployer(String v)       { this.applicantEmployer = v; }
    public Integer getApplicantCreditScore()         { return applicantCreditScore; }
    public void setApplicantCreditScore(Integer v)   { this.applicantCreditScore = v; }
    public LocalDateTime getSubmittedAt()            { return submittedAt; }
    public void setSubmittedAt(LocalDateTime v)      { this.submittedAt = v; }
    public LocalDateTime getReviewedAt()             { return reviewedAt; }
    public void setReviewedAt(LocalDateTime v)       { this.reviewedAt = v; }
    public String getReviewedBy()                    { return reviewedBy; }
    public void setReviewedBy(String v)              { this.reviewedBy = v; }
    public String getReviewerNotes()                 { return reviewerNotes; }
    public void setReviewerNotes(String v)           { this.reviewerNotes = v; }
    public LocalDateTime getCreatedAt()              { return createdAt; }
    public LocalDateTime getUpdatedAt()              { return updatedAt; }
    public MortgageApplicationDetail getMortgageDetail() { return mortgageDetail; }
    public void setMortgageDetail(MortgageApplicationDetail v) { this.mortgageDetail = v; }
}