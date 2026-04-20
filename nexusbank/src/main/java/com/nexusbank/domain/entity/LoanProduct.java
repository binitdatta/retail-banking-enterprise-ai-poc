package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "loan_products")
public class LoanProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "loan_product_id")
    private Integer loanProductId;

    @Column(name = "product_code", nullable = false, unique = true, length = 30)
    private String productCode;

    @Column(name = "product_name", nullable = false, length = 200)
    private String productName;

    @Enumerated(EnumType.STRING)
    @Column(name = "loan_type", nullable = false, length = 30)
    private Loan.LoanType loanType;

    @Column(name = "min_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal minAmount;

    @Column(name = "max_amount", nullable = false, precision = 15, scale = 2)
    private BigDecimal maxAmount;

    @Column(name = "min_term_months", nullable = false)
    private Integer minTermMonths;

    @Column(name = "max_term_months", nullable = false)
    private Integer maxTermMonths;

    @Column(name = "base_rate", nullable = false, precision = 6, scale = 4)
    private BigDecimal baseRate;

    @Column(name = "max_rate", nullable = false, precision = 6, scale = 4)
    private BigDecimal maxRate;

    @Enumerated(EnumType.STRING)
    @Column(name = "rate_type", nullable = false, length = 15)
    private Loan.RateType rateType = Loan.RateType.FIXED;

    @Column(name = "origination_fee_pct", nullable = false, precision = 5, scale = 4)
    private BigDecimal originationFeePct = BigDecimal.ZERO;

    @Column(name = "prepayment_penalty", nullable = false)
    private Boolean prepaymentPenalty = false;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public Integer       getLoanProductId()              { return loanProductId; }
    public String        getProductCode()                { return productCode; }
    public void          setProductCode(String v)        { this.productCode = v; }
    public String        getProductName()                { return productName; }
    public void          setProductName(String v)        { this.productName = v; }
    public Loan.LoanType getLoanType()                   { return loanType; }
    public void          setLoanType(Loan.LoanType v)    { this.loanType = v; }
    public BigDecimal    getMinAmount()                  { return minAmount; }
    public void          setMinAmount(BigDecimal v)      { this.minAmount = v; }
    public BigDecimal    getMaxAmount()                  { return maxAmount; }
    public void          setMaxAmount(BigDecimal v)      { this.maxAmount = v; }
    public Integer       getMinTermMonths()              { return minTermMonths; }
    public void          setMinTermMonths(Integer v)     { this.minTermMonths = v; }
    public Integer       getMaxTermMonths()              { return maxTermMonths; }
    public void          setMaxTermMonths(Integer v)     { this.maxTermMonths = v; }
    public BigDecimal    getBaseRate()                   { return baseRate; }
    public void          setBaseRate(BigDecimal v)       { this.baseRate = v; }
    public BigDecimal    getMaxRate()                    { return maxRate; }
    public void          setMaxRate(BigDecimal v)        { this.maxRate = v; }
    public Loan.RateType getRateType()                   { return rateType; }
    public void          setRateType(Loan.RateType v)    { this.rateType = v; }
    public BigDecimal    getOriginationFeePct()          { return originationFeePct; }
    public void          setOriginationFeePct(BigDecimal v) { this.originationFeePct = v; }
    public Boolean       getPrepaymentPenalty()          { return prepaymentPenalty; }
    public void          setPrepaymentPenalty(Boolean v) { this.prepaymentPenalty = v; }
    public String        getDescription()                { return description; }
    public void          setDescription(String v)        { this.description = v; }
    public Boolean       getIsActive()                   { return isActive; }
    public void          setIsActive(Boolean v)          { this.isActive = v; }
    public LocalDateTime getCreatedAt()                  { return createdAt; }
}
