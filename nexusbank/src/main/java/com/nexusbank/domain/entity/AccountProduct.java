package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "account_products")
public class AccountProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Integer productId;

    @Column(name = "product_code", nullable = false, unique = true, length = 30)
    private String productCode;

    @Column(name = "product_name", nullable = false, length = 200)
    private String productName;

    @Enumerated(EnumType.STRING)
    @Column(name = "product_type", nullable = false, length = 20)
    private ProductType productType;

    @Column(name = "min_balance", nullable = false, precision = 12, scale = 2)
    private BigDecimal minBalance = BigDecimal.ZERO;

    @Column(name = "monthly_fee", nullable = false, precision = 8, scale = 2)
    private BigDecimal monthlyFee = BigDecimal.ZERO;

    @Column(name = "apy_rate", precision = 6, scale = 4)
    private BigDecimal apyRate;

    @Column(name = "overdraft_limit", nullable = false, precision = 10, scale = 2)
    private BigDecimal overdraftLimit = BigDecimal.ZERO;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public enum ProductType {
        CHECKING("Checking"), SAVINGS("Savings"), MONEY_MARKET("Money Market"),
        CD("Certificate of Deposit"), IRA("IRA"), BROKERAGE("Brokerage");
        private final String displayName;
        ProductType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Integer     getProductId()           { return productId; }
    public String      getProductCode()          { return productCode; }
    public void        setProductCode(String v)  { this.productCode = v; }
    public String      getProductName()          { return productName; }
    public void        setProductName(String v)  { this.productName = v; }
    public ProductType getProductType()          { return productType; }
    public void        setProductType(ProductType v) { this.productType = v; }
    public BigDecimal  getMinBalance()           { return minBalance; }
    public void        setMinBalance(BigDecimal v) { this.minBalance = v; }
    public BigDecimal  getMonthlyFee()           { return monthlyFee; }
    public void        setMonthlyFee(BigDecimal v) { this.monthlyFee = v; }
    public BigDecimal  getApyRate()              { return apyRate; }
    public void        setApyRate(BigDecimal v)  { this.apyRate = v; }
    public BigDecimal  getOverdraftLimit()       { return overdraftLimit; }
    public void        setOverdraftLimit(BigDecimal v) { this.overdraftLimit = v; }
    public Boolean     getIsActive()             { return isActive; }
    public void        setIsActive(Boolean v)    { this.isActive = v; }
    public String      getDescription()          { return description; }
    public void        setDescription(String v)  { this.description = v; }
    public LocalDateTime getCreatedAt()          { return createdAt; }
}
