package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "loans")
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "loan_id")
    private Long id;

    @Column(name = "loan_number", unique = true, nullable = false, length = 30)
    private String loanNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_product_id", nullable = false)
    private LoanProduct loanProduct;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "disbursement_account_id")
    private Account disbursementAccount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "payment_account_id")
    private Account paymentAccount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id")
    private Branch branch;

    @Enumerated(EnumType.STRING)
    @Column(name = "loan_type", nullable = false, length = 30)
    private LoanType loanType;

    @Enumerated(EnumType.STRING)
    @Column(name = "loan_status", nullable = false, length = 20)
    private LoanStatus loanStatus = LoanStatus.APPLICATION;

    @Enumerated(EnumType.STRING)
    @Column(name = "rate_type", nullable = false, length = 15)
    private RateType rateType = RateType.FIXED;

    @Column(name = "application_date")
    private LocalDate applicationDate;

    @Column(name = "approval_date")
    private LocalDate approvalDate;

    @Column(name = "origination_date")
    private LocalDate originationDate;

    @Column(name = "disbursement_date")
    private LocalDate disbursementDate;

    @Column(name = "maturity_date")
    private LocalDate maturityDate;

    /** Original funded amount */
    @Column(name = "original_amount", precision = 14, scale = 2, nullable = false)
    private BigDecimal originalAmount = BigDecimal.ZERO;

    /** Current outstanding principal */
    @Column(name = "outstanding_balance", precision = 14, scale = 2, nullable = false)
    private BigDecimal outstandingBalance = BigDecimal.ZERO;

    @Column(name = "interest_rate", precision = 7, scale = 4, nullable = false)
    private BigDecimal interestRate;

    @Column(name = "term_months", nullable = false)
    private Integer termMonths;

    @Column(name = "monthly_payment_amount", precision = 12, scale = 2, nullable = false)
    private BigDecimal monthlyPaymentAmount = BigDecimal.ZERO;

    @Column(name = "next_payment_date")
    private LocalDate nextPaymentDate;

    @Column(name = "last_payment_date")
    private LocalDate lastPaymentDate;

    @Column(name = "last_payment_amount", precision = 12, scale = 2)
    private BigDecimal lastPaymentAmount;

    @Column(name = "total_paid", precision = 14, scale = 2)
    private BigDecimal totalPaid = BigDecimal.ZERO;

    @Column(name = "total_interest_paid", precision = 14, scale = 2)
    private BigDecimal totalInterestPaid = BigDecimal.ZERO;

    @Column(name = "accrued_interest", precision = 12, scale = 2)
    private BigDecimal accruedInterest = BigDecimal.ZERO;

    @Column(name = "origination_fee", precision = 10, scale = 2)
    private BigDecimal originationFee = BigDecimal.ZERO;

    @Column(name = "late_fee_balance", precision = 10, scale = 2)
    private BigDecimal lateFeeBalance = BigDecimal.ZERO;

    @Column(name = "days_past_due")
    private Integer daysPastDue = 0;

    @Column(name = "delinquency_date")
    private LocalDate delinquencyDate;

    @Column(name = "loan_officer", length = 150)
    private String loanOfficer;

    @Column(name = "purpose", length = 500)
    private String purpose;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /** Amortization schedule — loaded lazily on demand */
    @OneToMany(mappedBy = "loan", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @OrderBy("paymentNumber ASC")
    private List<LoanPaymentSchedule> paymentSchedule;

    @PrePersist
    protected void onCreate()  { createdAt = LocalDateTime.now(); updatedAt = LocalDateTime.now(); }

    @PreUpdate
    protected void onUpdate()  { updatedAt = LocalDateTime.now(); }

    // ── Computed helpers ──────────────────────────────────────────────────────

    /** Payoff amount = outstanding + accrued interest + any late fees */
    public BigDecimal getPayoffAmount() {
        return outstandingBalance
                .add(accruedInterest != null ? accruedInterest : BigDecimal.ZERO)
                .add(lateFeeBalance  != null ? lateFeeBalance  : BigDecimal.ZERO);
    }

    /** Percent of original principal repaid, 0–100 */
    public int getProgressPercent() {
        if (originalAmount == null || originalAmount.compareTo(BigDecimal.ZERO) == 0) return 0;
        BigDecimal paid = originalAmount.subtract(outstandingBalance);
        return paid.multiply(BigDecimal.valueOf(100))
                .divide(originalAmount, 0, RoundingMode.HALF_UP)
                .max(BigDecimal.ZERO).min(BigDecimal.valueOf(100)).intValue();
    }

    // ── Enums ─────────────────────────────────────────────────────────────────
    public enum LoanType {
        MORTGAGE("Mortgage"),
        HOME_EQUITY_LOAN("Home Equity Loan"),
        HELOC("HELOC"),
        AUTO("Auto Loan"),
        STUDENT_UNDERGRADUATE("Undergraduate Loan"),
        STUDENT_GRADUATE("Graduate Loan"),
        STUDENT_REFINANCE("Student Loan Refinance"),
        PERSONAL("Personal Loan"),
        PERSONAL_SECURED("Secured Personal Loan"),
        BUSINESS("Business Loan"),
        SBA("SBA Loan");

        private final String displayName;
        LoanType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum LoanStatus {
        APPLICATION("Application"),
        UNDERWRITING("Underwriting"),
        APPROVED("Approved"),
        DECLINED("Declined"),
        CURRENT("Current"),
        DELINQUENT("Delinquent"),
        DEFAULT("In Default"),
        PAID_OFF("Paid Off"),
        CHARGED_OFF("Charged Off"),
        CANCELLED("Cancelled");

        private final String displayName;
        LoanStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum RateType {
        FIXED("Fixed Rate"),
        VARIABLE("Variable Rate"),
        HYBRID_ARM("Hybrid ARM"),
        PRIME_PLUS("Prime +");

        private final String displayName;
        RateType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    // ── Getters ───────────────────────────────────────────────────────────────
    public Long getId()                      { return id; }
    public String getLoanNumber()            { return loanNumber; }
    public Customer getCustomer()            { return customer; }
    public LoanProduct getLoanProduct() { return loanProduct; }
    public Account getDisbursementAccount()  { return disbursementAccount; }
    public Account getPaymentAccount()       { return paymentAccount; }
    public Branch getBranch() { return branch; }
    public LoanType getLoanType()            { return loanType; }
    public LoanStatus getLoanStatus()        { return loanStatus; }
    public RateType getRateType()            { return rateType; }
    public LocalDate getApplicationDate()    { return applicationDate; }
    public LocalDate getApprovalDate()       { return approvalDate; }
    public LocalDate getOriginationDate()    { return originationDate; }
    public LocalDate getDisbursementDate()   { return disbursementDate; }
    public LocalDate getMaturityDate()       { return maturityDate; }
    public BigDecimal getOriginalAmount()    { return originalAmount; }
    public BigDecimal getOutstandingBalance(){ return outstandingBalance; }
    public BigDecimal getInterestRate()      { return interestRate; }
    public Integer getTermMonths()           { return termMonths; }
    public BigDecimal getMonthlyPaymentAmount() { return monthlyPaymentAmount; }
    public LocalDate getNextPaymentDate()    { return nextPaymentDate; }
    public LocalDate getLastPaymentDate()    { return lastPaymentDate; }
    public BigDecimal getLastPaymentAmount() { return lastPaymentAmount; }
    public BigDecimal getTotalPaid()         { return totalPaid; }
    public BigDecimal getTotalInterestPaid() { return totalInterestPaid; }
    public BigDecimal getAccruedInterest()   { return accruedInterest; }
    public BigDecimal getOriginationFee()    { return originationFee; }
    public BigDecimal getLateFeeBalance()    { return lateFeeBalance; }
    public Integer getDaysPastDue()          { return daysPastDue; }
    public LocalDate getDelinquencyDate()    { return delinquencyDate; }
    public String getLoanOfficer()           { return loanOfficer; }
    public String getPurpose()               { return purpose; }
    public String getNotes()                 { return notes; }
    public LocalDateTime getCreatedAt()      { return createdAt; }
    public LocalDateTime getUpdatedAt()      { return updatedAt; }
    public List<LoanPaymentSchedule> getPaymentSchedule() { return paymentSchedule; }

    // ── Setters ───────────────────────────────────────────────────────────────
    public void setId(Long id)               { this.id = id; }
    public void setLoanNumber(String v)      { this.loanNumber = v; }
    public void setCustomer(Customer v)      { this.customer = v; }
    public void setLoanProduct(LoanProduct v) { this.loanProduct = v; }
    public void setDisbursementAccount(Account v)  { this.disbursementAccount = v; }
    public void setPaymentAccount(Account v)       { this.paymentAccount = v; }
    public void setBranch(Branch v) { this.branch = v; }
    public void setLoanType(LoanType v)      { this.loanType = v; }
    public void setLoanStatus(LoanStatus v)  { this.loanStatus = v; }
    public void setRateType(RateType v)      { this.rateType = v; }
    public void setApplicationDate(LocalDate v)  { this.applicationDate = v; }
    public void setApprovalDate(LocalDate v)     { this.approvalDate = v; }
    public void setOriginationDate(LocalDate v)  { this.originationDate = v; }
    public void setDisbursementDate(LocalDate v) { this.disbursementDate = v; }
    public void setMaturityDate(LocalDate v)     { this.maturityDate = v; }
    public void setOriginalAmount(BigDecimal v)    { this.originalAmount = v; }
    public void setOutstandingBalance(BigDecimal v){ this.outstandingBalance = v; }
    public void setInterestRate(BigDecimal v)      { this.interestRate = v; }
    public void setTermMonths(Integer v)           { this.termMonths = v; }
    public void setMonthlyPaymentAmount(BigDecimal v) { this.monthlyPaymentAmount = v; }
    public void setNextPaymentDate(LocalDate v)    { this.nextPaymentDate = v; }
    public void setLastPaymentDate(LocalDate v)    { this.lastPaymentDate = v; }
    public void setLastPaymentAmount(BigDecimal v) { this.lastPaymentAmount = v; }
    public void setTotalPaid(BigDecimal v)         { this.totalPaid = v; }
    public void setTotalInterestPaid(BigDecimal v) { this.totalInterestPaid = v; }
    public void setAccruedInterest(BigDecimal v)   { this.accruedInterest = v; }
    public void setOriginationFee(BigDecimal v)    { this.originationFee = v; }
    public void setLateFeeBalance(BigDecimal v)    { this.lateFeeBalance = v; }
    public void setDaysPastDue(Integer v)          { this.daysPastDue = v; }
    public void setDelinquencyDate(LocalDate v)    { this.delinquencyDate = v; }
    public void setLoanOfficer(String v)           { this.loanOfficer = v; }
    public void setPurpose(String v)               { this.purpose = v; }
    public void setNotes(String v)                 { this.notes = v; }
    public void setPaymentSchedule(List<LoanPaymentSchedule> v) { this.paymentSchedule = v; }
}