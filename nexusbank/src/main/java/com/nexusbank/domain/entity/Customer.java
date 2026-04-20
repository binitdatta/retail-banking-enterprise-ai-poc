package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "customers")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "customer_id")
    private Long customerId;

    @Column(name = "customer_number", unique = true, nullable = false, length = 20)
    private String customerNumber;

    @Column(name = "keycloak_user_id", unique = true, length = 50)
    private String keycloakUserId;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "middle_name", length = 100)
    private String middleName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    @Column(name = "gender", length = 20)
    private Gender gender;

    @Column(name = "ssn_last4", length = 4)
    private String ssnLast4;

    @Column(name = "nationality", length = 60)
    private String nationality;

    @Column(name = "email", nullable = false, unique = true, length = 200)
    private String email;

    @Column(name = "email_verified", nullable = false)
    private boolean emailVerified = false;

    @Column(name = "phone", nullable = false, length = 20)
    private String phone;

    @Column(name = "mobile_phone", length = 20)
    private String mobilePhone;

    @Column(name = "two_factor_enabled", nullable = false)
    private boolean twoFactorEnabled = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "customer_type", nullable = false, length = 20)
    private CustomerType customerType = CustomerType.RETAIL;

    @Enumerated(EnumType.STRING)
    @Column(name = "kyc_status", nullable = false, length = 20)
    private KycStatus kycStatus = KycStatus.PENDING;

    @Column(name = "kyc_verified_at")
    private LocalDateTime kycVerifiedAt;

    @Column(name = "credit_score")
    private Integer creditScore;

    @Column(name = "credit_score_date")
    private LocalDate creditScoreDate;

    @Column(name = "annual_income", precision = 15, scale = 2)
    private BigDecimal annualIncome;

    @Enumerated(EnumType.STRING)
    @Column(name = "employment_status", nullable = false, length = 20)
    private EmploymentStatus employmentStatus = EmploymentStatus.EMPLOYED;

    @Column(name = "employer", length = 150)
    private String employer;

    @Column(name = "occupation", length = 100)
    private String occupation;

    @Enumerated(EnumType.STRING)
    @Column(name = "preferred_contact_method", length = 20)
    private ContactMethod preferredContactMethod;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assigned_branch_id")
    private Branch assignedBranch;

    @Column(name = "assigned_banker_id")
    private Long assignedBankerId;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // ── Relationships ─────────────────────────────────────────────────────────
    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @OrderBy("isPrimary DESC")
    private List<CustomerAddress> addresses = new ArrayList<>();

    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<CustomerDocument> documents = new ArrayList<>();

    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY)
    @OrderBy("openedDate ASC")
    private List<Account> accounts = new ArrayList<>();

    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY)
    @OrderBy("originationDate DESC")
    private List<Loan> loans = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    // ── Helpers ───────────────────────────────────────────────────────────────
    public String getFullName() {
        if (middleName != null && !middleName.isBlank())
            return firstName + " " + middleName + " " + lastName;
        return firstName + " " + lastName;
    }

    public String getDisplayName() {
        return firstName + " " + lastName.substring(0, 1) + ".";
    }

    // ── Getters / Setters ─────────────────────────────────────────────────────
    public Long getCustomerId()               { return customerId; }
    public String getCustomerNumber()         { return customerNumber; }
    public void setCustomerNumber(String v)   { this.customerNumber = v; }
    public String getKeycloakUserId()         { return keycloakUserId; }
    public void setKeycloakUserId(String v)   { this.keycloakUserId = v; }
    public String getFirstName()              { return firstName; }
    public void setFirstName(String v)        { this.firstName = v; }
    public String getMiddleName()             { return middleName; }
    public void setMiddleName(String v)       { this.middleName = v; }
    public String getLastName()               { return lastName; }
    public void setLastName(String v)         { this.lastName = v; }
    public LocalDate getDateOfBirth()         { return dateOfBirth; }
    public void setDateOfBirth(LocalDate v)   { this.dateOfBirth = v; }
    public Gender getGender()                 { return gender; }
    public void setGender(Gender v)           { this.gender = v; }
    public String getSsnLast4()               { return ssnLast4; }
    public void setSsnLast4(String v)         { this.ssnLast4 = v; }
    public String getNationality()            { return nationality; }
    public void setNationality(String v)      { this.nationality = v; }
    public String getEmail()                  { return email; }
    public void setEmail(String v)            { this.email = v; }
    public boolean isEmailVerified()          { return emailVerified; }
    public void setEmailVerified(boolean v)   { this.emailVerified = v; }
    public String getPhone()                  { return phone; }
    public void setPhone(String v)            { this.phone = v; }
    public String getMobilePhone()            { return mobilePhone; }
    public void setMobilePhone(String v)      { this.mobilePhone = v; }
    public boolean isTwoFactorEnabled()       { return twoFactorEnabled; }
    public void setTwoFactorEnabled(boolean v){ this.twoFactorEnabled = v; }
    public CustomerType getCustomerType()     { return customerType; }
    public void setCustomerType(CustomerType v){ this.customerType = v; }
    public KycStatus getKycStatus()           { return kycStatus; }
    public void setKycStatus(KycStatus v)     { this.kycStatus = v; }
    public LocalDateTime getKycVerifiedAt()   { return kycVerifiedAt; }
    public void setKycVerifiedAt(LocalDateTime v) { this.kycVerifiedAt = v; }
    public Integer getCreditScore()           { return creditScore; }
    public void setCreditScore(Integer v)     { this.creditScore = v; }
    public LocalDate getCreditScoreDate()     { return creditScoreDate; }
    public void setCreditScoreDate(LocalDate v){ this.creditScoreDate = v; }
    public BigDecimal getAnnualIncome()       { return annualIncome; }
    public void setAnnualIncome(BigDecimal v) { this.annualIncome = v; }
    public EmploymentStatus getEmploymentStatus() { return employmentStatus; }
    public void setEmploymentStatus(EmploymentStatus v) { this.employmentStatus = v; }
    public String getEmployer()               { return employer; }
    public void setEmployer(String v)         { this.employer = v; }
    public String getOccupation()             { return occupation; }
    public void setOccupation(String v)       { this.occupation = v; }
    public ContactMethod getPreferredContactMethod() { return preferredContactMethod; }
    public void setPreferredContactMethod(ContactMethod v) { this.preferredContactMethod = v; }
    public Branch getAssignedBranch()         { return assignedBranch; }
    public void setAssignedBranch(Branch v)   { this.assignedBranch = v; }
    public Long getAssignedBankerId()         { return assignedBankerId; }
    public void setAssignedBankerId(Long v)   { this.assignedBankerId = v; }
    public Boolean getIsActive()              { return isActive; }
    public void setIsActive(Boolean v)        { this.isActive = v; }
    public LocalDateTime getCreatedAt()       { return createdAt; }
    public LocalDateTime getUpdatedAt()       { return updatedAt; }
    public List<CustomerAddress> getAddresses() { return addresses; }
    public List<CustomerDocument> getDocuments() { return documents; }
    public List<Account> getAccounts()        { return accounts; }
    public List<Loan> getLoans()              { return loans; }

    // ── Enums ─────────────────────────────────────────────────────────────────
    public enum CustomerType {
        RETAIL("Retail"), PREMIUM("Premium"), PRIVATE_BANKING("Private Banking"), STUDENT("Student");
        private final String displayName;
        CustomerType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum KycStatus {
        PENDING("Pending"), VERIFIED("Verified"), REJECTED("Rejected"), EXPIRED("Expired");
        private final String displayName;
        KycStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum EmploymentStatus {
        EMPLOYED("Employed"), SELF_EMPLOYED("Self-Employed"), RETIRED("Retired"),
        STUDENT("Student"), UNEMPLOYED("Unemployed");
        private final String displayName;
        EmploymentStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum Gender {
        MALE("Male"), FEMALE("Female"), NON_BINARY("Non-Binary"), PREFER_NOT_TO_SAY("Prefer Not to Say");
        private final String displayName;
        Gender(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum ContactMethod {
        EMAIL("Email"), PHONE("Phone"), SMS("SMS"), MAIL("Mail");
        private final String displayName;
        ContactMethod(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }
}