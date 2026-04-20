package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

// ══════════════════════════════════════════════════════════════════
//  MORTGAGE DETAIL
// ══════════════════════════════════════════════════════════════════
@Entity
@Table(name = "mortgage_details")
public class MortgageDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_id", nullable = false)
    private Loan loan;

    @Column(name = "property_address", nullable = false, length = 500)
    private String propertyAddress;

    @Column(name = "property_city", length = 100)
    private String propertyCity;

    @Column(name = "property_state_code", length = 2)
    private String propertyStateCode;

    @Column(name = "property_zip", length = 10)
    private String propertyZip;

    @Enumerated(EnumType.STRING)
    @Column(name = "property_type", nullable = false, length = 30)
    private PropertyType propertyType;

    @Column(name = "appraised_value", precision = 14, scale = 2)
    private BigDecimal appraisedValue;

    @Column(name = "purchase_price", precision = 14, scale = 2)
    private BigDecimal purchasePrice;

    @Column(name = "down_payment", precision = 14, scale = 2)
    private BigDecimal downPayment;

    @Column(name = "ltv_ratio", precision = 5, scale = 2)
    private BigDecimal ltvRatio;

    @Column(name = "pmi_required")
    private boolean pmiRequired;

    @Column(name = "pmi_monthly_premium", precision = 8, scale = 2)
    private BigDecimal pmiMonthlyPremium;

    @Column(name = "pmi_cancellation_date")
    private LocalDate pmiCancellationDate;

    @Column(name = "escrow_required")
    private boolean escrowRequired;

    @Column(name = "escrow_balance", precision = 10, scale = 2)
    private BigDecimal escrowBalance;

    @Column(name = "monthly_escrow_payment", precision = 8, scale = 2)
    private BigDecimal monthlyEscrowPayment;

    @Column(name = "annual_property_tax", precision = 10, scale = 2)
    private BigDecimal annualPropertyTax;

    @Column(name = "annual_insurance_premium", precision = 10, scale = 2)
    private BigDecimal annualInsurancePremium;

    @Column(name = "is_arm_loan")
    private boolean isArmLoan;

    @Column(name = "arm_initial_period_months")
    private Integer armInitialPeriodMonths;

    @Column(name = "arm_adjustment_cap", precision = 4, scale = 2)
    private BigDecimal armAdjustmentCap;

    @Column(name = "arm_lifetime_cap", precision = 4, scale = 2)
    private BigDecimal armLifetimeCap;

    @Column(name = "arm_index_rate", precision = 6, scale = 4)
    private BigDecimal armIndexRate;

    @Column(name = "arm_margin", precision = 6, scale = 4)
    private BigDecimal armMargin;

    @Column(name = "next_adjustment_date")
    private LocalDate nextAdjustmentDate;

    @Column(name = "flood_zone")
    private Boolean floodZone;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public enum PropertyType {
        SINGLE_FAMILY("Single Family"), CONDO("Condominium"), TOWNHOUSE("Townhouse"),
        MULTI_FAMILY("Multi-Family"), COOPERATIVE("Cooperative"), MANUFACTURED("Manufactured");
        private final String displayName;
        PropertyType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    // ── Getters ──────────────────────────────────────────────────
    public Long getId() { return id; }
    public Loan getLoan() { return loan; }
    public String getPropertyAddress() { return propertyAddress; }
    public String getPropertyCity() { return propertyCity; }
    public String getPropertyStateCode() { return propertyStateCode; }
    public String getPropertyZip() { return propertyZip; }
    public PropertyType getPropertyType() { return propertyType; }
    public BigDecimal getAppraisedValue() { return appraisedValue; }
    public BigDecimal getPurchasePrice() { return purchasePrice; }
    public BigDecimal getDownPayment() { return downPayment; }
    public BigDecimal getLtvRatio() { return ltvRatio; }
    public boolean isPmiRequired() { return pmiRequired; }
    public BigDecimal getPmiMonthlyPremium() { return pmiMonthlyPremium; }
    public LocalDate getPmiCancellationDate() { return pmiCancellationDate; }
    public boolean isEscrowRequired() { return escrowRequired; }
    public BigDecimal getEscrowBalance() { return escrowBalance; }
    public BigDecimal getMonthlyEscrowPayment() { return monthlyEscrowPayment; }
    public BigDecimal getAnnualPropertyTax() { return annualPropertyTax; }
    public BigDecimal getAnnualInsurancePremium() { return annualInsurancePremium; }
    public boolean isArmLoan() { return isArmLoan; }
    public Integer getArmInitialPeriodMonths() { return armInitialPeriodMonths; }
    public BigDecimal getArmAdjustmentCap() { return armAdjustmentCap; }
    public BigDecimal getArmLifetimeCap() { return armLifetimeCap; }
    public BigDecimal getArmIndexRate() { return armIndexRate; }
    public BigDecimal getArmMargin() { return armMargin; }
    public LocalDate getNextAdjustmentDate() { return nextAdjustmentDate; }
    public Boolean getFloodZone() { return floodZone; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    // ── Setters ──────────────────────────────────────────────────
    public void setId(Long id) { this.id = id; }
    public void setLoan(Loan loan) { this.loan = loan; }
    public void setPropertyAddress(String v) { this.propertyAddress = v; }
    public void setPropertyCity(String v) { this.propertyCity = v; }
    public void setPropertyStateCode(String v) { this.propertyStateCode = v; }
    public void setPropertyZip(String v) { this.propertyZip = v; }
    public void setPropertyType(PropertyType v) { this.propertyType = v; }
    public void setAppraisedValue(BigDecimal v) { this.appraisedValue = v; }
    public void setPurchasePrice(BigDecimal v) { this.purchasePrice = v; }
    public void setDownPayment(BigDecimal v) { this.downPayment = v; }
    public void setLtvRatio(BigDecimal v) { this.ltvRatio = v; }
    public void setPmiRequired(boolean v) { this.pmiRequired = v; }
    public void setPmiMonthlyPremium(BigDecimal v) { this.pmiMonthlyPremium = v; }
    public void setPmiCancellationDate(LocalDate v) { this.pmiCancellationDate = v; }
    public void setEscrowRequired(boolean v) { this.escrowRequired = v; }
    public void setEscrowBalance(BigDecimal v) { this.escrowBalance = v; }
    public void setMonthlyEscrowPayment(BigDecimal v) { this.monthlyEscrowPayment = v; }
    public void setAnnualPropertyTax(BigDecimal v) { this.annualPropertyTax = v; }
    public void setAnnualInsurancePremium(BigDecimal v) { this.annualInsurancePremium = v; }
    public void setArmLoan(boolean v) { this.isArmLoan = v; }
    public void setArmInitialPeriodMonths(Integer v) { this.armInitialPeriodMonths = v; }
    public void setArmAdjustmentCap(BigDecimal v) { this.armAdjustmentCap = v; }
    public void setArmLifetimeCap(BigDecimal v) { this.armLifetimeCap = v; }
    public void setArmIndexRate(BigDecimal v) { this.armIndexRate = v; }
    public void setArmMargin(BigDecimal v) { this.armMargin = v; }
    public void setNextAdjustmentDate(LocalDate v) { this.nextAdjustmentDate = v; }
    public void setFloodZone(Boolean v) { this.floodZone = v; }
}
