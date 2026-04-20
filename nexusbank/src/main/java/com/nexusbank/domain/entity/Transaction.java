package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transaction_id")
    private Long id;

    @Column(name = "transaction_ref", nullable = false, unique = true, length = 30)
    private String referenceNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private TransactionCategory transactionCategory;

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", nullable = false, length = 30)
    private TransactionType transactionType;

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_status", nullable = false, length = 20)
    private TransactionStatus status = TransactionStatus.PENDING;

    @Enumerated(EnumType.STRING)
    @Column(name = "channel", nullable = false, length = 20)
    private Channel channel = Channel.ONLINE_BANKING;

    @Column(name = "amount", nullable = false, precision = 18, scale = 2)
    private BigDecimal amount;

    @Column(name = "balance_before", precision = 18, scale = 2)
    private BigDecimal balanceBefore;

    @Column(name = "balance_after", precision = 18, scale = 2)
    private BigDecimal runningBalance;

    @Column(name = "currency_code", nullable = false, length = 3)
    private String currencyCode = "USD";

    @Column(name = "description", nullable = false, length = 500)
    private String description;

    @Column(name = "merchant_name", length = 200)
    private String merchantName;

    @Column(name = "merchant_city", length = 100)
    private String merchantCity;

    @Column(name = "transaction_date", nullable = false)
    private LocalDate transactionDate;

    @Column(name = "posted_at")
    private LocalDateTime postedAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.transactionDate == null) this.transactionDate = LocalDate.now();
    }

    public enum TransactionType {
        DEBIT("Debit"), CREDIT("Credit"), TRANSFER("Transfer"),
        FEE("Fee"), INTEREST("Interest"), ADJUSTMENT("Adjustment"),
        LOAN_PAYMENT("Loan Payment"), LOAN_DISBURSEMENT("Loan Disbursement");
        private final String displayName;
        TransactionType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum TransactionStatus {
        PENDING("Pending"), POSTED("Posted"), FAILED("Failed"),
        REVERSED("Reversed"), HOLD("On Hold");
        private final String displayName;
        TransactionStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum Channel {
        ONLINE_BANKING("Online Banking"), MOBILE("Mobile App"), ATM("ATM"),
        BRANCH("Branch"), ACH("ACH"), WIRE("Wire Transfer"), CHECK("Check"), CARD("Card");
        private final String displayName;
        Channel(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Long                getId()                      { return id; }
    public String              getReferenceNumber()          { return referenceNumber; }
    public void                setReferenceNumber(String v)  { this.referenceNumber = v; }
    public Account             getAccount()                  { return account; }
    public void                setAccount(Account v)         { this.account = v; }
    public TransactionCategory getTransactionCategory()      { return transactionCategory; }
    public void                setTransactionCategory(TransactionCategory v) { this.transactionCategory = v; }
    public TransactionType     getTransactionType()          { return transactionType; }
    public void                setTransactionType(TransactionType v) { this.transactionType = v; }
    public TransactionStatus   getStatus()                   { return status; }
    public void                setStatus(TransactionStatus v){ this.status = v; }
    public Channel             getChannel()                  { return channel; }
    public void                setChannel(Channel v)         { this.channel = v; }
    public BigDecimal          getAmount()                   { return amount; }
    public void                setAmount(BigDecimal v)       { this.amount = v; }
    public BigDecimal          getBalanceBefore()            { return balanceBefore; }
    public void                setBalanceBefore(BigDecimal v){ this.balanceBefore = v; }
    public BigDecimal          getRunningBalance()           { return runningBalance; }
    public void                setRunningBalance(BigDecimal v){ this.runningBalance = v; }
    public String              getCurrencyCode()             { return currencyCode; }
    public void                setCurrencyCode(String v)     { this.currencyCode = v; }
    public String              getDescription()              { return description; }
    public void                setDescription(String v)      { this.description = v; }
    public String              getMerchantName()             { return merchantName; }
    public void                setMerchantName(String v)     { this.merchantName = v; }
    public String              getMerchantCity()             { return merchantCity; }
    public void                setMerchantCity(String v)     { this.merchantCity = v; }
    public LocalDate           getTransactionDate()          { return transactionDate; }
    public void                setTransactionDate(LocalDate v){ this.transactionDate = v; }
    public LocalDateTime       getPostedAt()                 { return postedAt; }
    public void                setPostedAt(LocalDateTime v)  { this.postedAt = v; }
    public LocalDateTime       getCreatedAt()                { return createdAt; }
}
