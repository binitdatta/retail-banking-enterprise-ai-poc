package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_loan_details")
public class StudentLoanDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_id", nullable = false)
    private Loan loan;

    @Column(name = "institution_name", nullable = false, length = 200)
    private String institutionName;

    @Column(name = "ope_id", length = 20)
    private String opeId;

    @Column(name = "degree_program", length = 150)
    private String degreeProgram;

    @Column(name = "enrollment_status", length = 20)
    private String enrollmentStatus;

    @Column(name = "expected_graduation")
    private LocalDate expectedGraduation;

    @Enumerated(EnumType.STRING)
    @Column(name = "repayment_plan", nullable = false, length = 30)
    private RepaymentPlan repaymentPlan = RepaymentPlan.STANDARD;

    @Column(name = "loan_servicer", length = 100)
    private String loanServicer;

    @Column(name = "federal_loan_type", length = 50)
    private String federalLoanType;

    @Column(name = "in_school_deferment", nullable = false)
    private boolean inSchoolDeferment = false;

    @Column(name = "deferment_end_date")
    private LocalDate defermentEndDate;

    @Column(name = "grace_period_end")
    private LocalDate gracePeriodEnd;

    @Column(name = "income_based_payment", precision = 10, scale = 2)
    private BigDecimal incomeBasedPayment;

    @Column(name = "public_service_eligible", nullable = false)
    private boolean publicServiceEligible = false;

    @Column(name = "qualifying_payments_made")
    private Integer qualifyingPaymentsMade;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public enum RepaymentPlan {
        STANDARD("Standard 10-Year"), GRADUATED("Graduated"), EXTENDED("Extended"),
        IBR("Income-Based Repayment"), PAYE("Pay As You Earn"),
        SAVE("SAVE Plan"), ICR("Income-Contingent Repayment"), IN_SCHOOL("In-School");
        private final String displayName;
        RepaymentPlan(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Long          getId()                           { return id; }
    public Loan          getLoan()                         { return loan; }
    public void          setLoan(Loan v)                   { this.loan = v; }
    public String        getInstitutionName()              { return institutionName; }
    public void          setInstitutionName(String v)      { this.institutionName = v; }
    public String        getOpeId()                        { return opeId; }
    public void          setOpeId(String v)                { this.opeId = v; }
    public String        getDegreeProgram()                { return degreeProgram; }
    public void          setDegreeProgram(String v)        { this.degreeProgram = v; }
    public String        getEnrollmentStatus()             { return enrollmentStatus; }
    public void          setEnrollmentStatus(String v)     { this.enrollmentStatus = v; }
    public LocalDate     getExpectedGraduation()           { return expectedGraduation; }
    public void          setExpectedGraduation(LocalDate v){ this.expectedGraduation = v; }
    public RepaymentPlan getRepaymentPlan()                { return repaymentPlan; }
    public void          setRepaymentPlan(RepaymentPlan v) { this.repaymentPlan = v; }
    public String        getLoanServicer()                 { return loanServicer; }
    public void          setLoanServicer(String v)         { this.loanServicer = v; }
    public String        getFederalLoanType()              { return federalLoanType; }
    public void          setFederalLoanType(String v)      { this.federalLoanType = v; }
    public boolean       isInSchoolDeferment()             { return inSchoolDeferment; }
    public void          setInSchoolDeferment(boolean v)   { this.inSchoolDeferment = v; }
    public LocalDate     getDefermentEndDate()             { return defermentEndDate; }
    public void          setDefermentEndDate(LocalDate v)  { this.defermentEndDate = v; }
    public LocalDate     getGracePeriodEnd()               { return gracePeriodEnd; }
    public void          setGracePeriodEnd(LocalDate v)    { this.gracePeriodEnd = v; }
    public BigDecimal    getIncomeBasedPayment()           { return incomeBasedPayment; }
    public void          setIncomeBasedPayment(BigDecimal v){ this.incomeBasedPayment = v; }
    public boolean       isPublicServiceEligible()         { return publicServiceEligible; }
    public void          setPublicServiceEligible(boolean v){ this.publicServiceEligible = v; }
    public Integer       getQualifyingPaymentsMade()       { return qualifyingPaymentsMade; }
    public void          setQualifyingPaymentsMade(Integer v){ this.qualifyingPaymentsMade = v; }
    public LocalDateTime getCreatedAt()                    { return createdAt; }
}
