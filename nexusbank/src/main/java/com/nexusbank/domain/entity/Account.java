package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "accounts")
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "account_id")
    private Long id;

    @Column(name = "account_number", unique = true, nullable = false, length = 20)
    private String accountNumber;

    @Column(name = "routing_number", nullable = false, length = 9)
    private String routingNumber = "071000013";   // NexusBank routing

    @Column(name = "nickname", length = 100)
    private String nickname;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private AccountProduct accountProduct;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id")
    private Branch branch;

    @Enumerated(EnumType.STRING)
    @Column(name = "account_status", nullable = false, length = 20)
    private AccountStatus accountStatus = AccountStatus.PENDING_APPROVAL;

    @Column(name = "current_balance", nullable = false, precision = 18, scale = 2)
    private BigDecimal currentBalance = BigDecimal.ZERO;

    @Column(name = "available_balance", nullable = false, precision = 18, scale = 2)
    private BigDecimal availableBalance = BigDecimal.ZERO;

    @Column(name = "hold_amount", nullable = false, precision = 14, scale = 2)
    private BigDecimal holdAmount = BigDecimal.ZERO;

    @Column(name = "currency_code", nullable = false, length = 3)
    private String currencyCode = "USD";

    @Column(name = "overdraft_protection", nullable = false)
    private boolean overdraftProtection = false;

    @Column(name = "overdraft_limit", nullable = false, precision = 10, scale = 2)
    private BigDecimal overdraftLimit = BigDecimal.ZERO;

    /** APY for savings, CD, money market, IRA */
    @Column(name = "annual_percentage_yield", precision = 6, scale = 4)
    private BigDecimal annualPercentageYield;

    @Column(name = "opened_date", nullable = false)
    private LocalDate openedDate;

    @Column(name = "closed_date")
    private LocalDate closedDate;

    /** Maturity date for CDs */
    @Column(name = "maturity_date")
    private LocalDate maturityDate;

    @Column(name = "last_transaction_at")
    private LocalDateTime lastTransactionAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY)
    @OrderBy("transactionDate DESC")
    private List<Transaction> transactions = new ArrayList<>();

    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<AccountBeneficiary> beneficiaries = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (openedDate == null) openedDate = LocalDate.now();
    }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    // ── Computed helpers ──────────────────────────────────────────────────────
    public String getMaskedAccountNumber() {
        if (accountNumber == null || accountNumber.length() < 4) return "••••";
        return "••••" + accountNumber.substring(accountNumber.length() - 4);
    }

    // ── Getters ───────────────────────────────────────────────────────────────
    public Long getId()                       { return id; }
    public String getAccountNumber()          { return accountNumber; }
    public void setAccountNumber(String v)    { this.accountNumber = v; }
    public String getRoutingNumber()          { return routingNumber; }
    public void setRoutingNumber(String v)    { this.routingNumber = v; }
    public String getNickname()               { return nickname; }
    public void setNickname(String v)         { this.nickname = v; }
    public Customer getCustomer()             { return customer; }
    public void setCustomer(Customer v)       { this.customer = v; }
    public AccountProduct getAccountProduct() { return accountProduct; }
    public void setAccountProduct(AccountProduct v) { this.accountProduct = v; }
    public Branch getBranch()                 { return branch; }
    public void setBranch(Branch v)           { this.branch = v; }
    public AccountStatus getAccountStatus()   { return accountStatus; }
    public void setAccountStatus(AccountStatus v) { this.accountStatus = v; }
    public BigDecimal getCurrentBalance()     { return currentBalance; }
    public void setCurrentBalance(BigDecimal v) { this.currentBalance = v; }
    public BigDecimal getAvailableBalance()   { return availableBalance; }
    public void setAvailableBalance(BigDecimal v) { this.availableBalance = v; }
    public BigDecimal getHoldAmount()         { return holdAmount; }
    public void setHoldAmount(BigDecimal v)   { this.holdAmount = v; }
    public String getCurrencyCode()           { return currencyCode; }
    public void setCurrencyCode(String v)     { this.currencyCode = v; }
    public boolean isOverdraftProtection()    { return overdraftProtection; }
    public void setOverdraftProtection(boolean v) { this.overdraftProtection = v; }
    public BigDecimal getOverdraftLimit()     { return overdraftLimit; }
    public void setOverdraftLimit(BigDecimal v) { this.overdraftLimit = v; }
    public BigDecimal getAnnualPercentageYield() { return annualPercentageYield; }
    public void setAnnualPercentageYield(BigDecimal v) { this.annualPercentageYield = v; }
    public LocalDate getOpenedDate()          { return openedDate; }
    public void setOpenedDate(LocalDate v)    { this.openedDate = v; }
    public LocalDate getClosedDate()          { return closedDate; }
    public void setClosedDate(LocalDate v)    { this.closedDate = v; }
    public LocalDate getMaturityDate()        { return maturityDate; }
    public void setMaturityDate(LocalDate v)  { this.maturityDate = v; }
    public LocalDateTime getLastTransactionAt() { return lastTransactionAt; }
    public void setLastTransactionAt(LocalDateTime v) { this.lastTransactionAt = v; }
    public LocalDateTime getCreatedAt()       { return createdAt; }
    public LocalDateTime getUpdatedAt()       { return updatedAt; }
    public List<Transaction> getTransactions() { return transactions; }
    public List<AccountBeneficiary> getBeneficiaries() { return beneficiaries; }

    // ── Enum ──────────────────────────────────────────────────────────────────
    public enum AccountStatus {
        PENDING_APPROVAL("Pending Approval"),
        ACTIVE("Active"),
        DORMANT("Dormant"),
        FROZEN("Frozen"),
        CLOSED("Closed");

        private final String displayName;
        AccountStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }
}
