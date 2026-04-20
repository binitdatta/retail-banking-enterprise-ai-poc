package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "mortgage_application_details")
public class MortgageApplicationDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "detail_id")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "application_id", nullable = false)
    private LoanApplication application;

    // Property details
    @Column(name = "property_address", nullable = false, length = 500)
    private String propertyAddress;

    @Column(name = "property_city", nullable = false, length = 100)
    private String propertyCity;

    @Column(name = "property_state_code", nullable = false, length = 2)
    private String propertyStateCode;

    @Column(name = "property_zip", nullable = false, length = 10)
    private String propertyZip;

    @Enumerated(EnumType.STRING)
    @Column(name = "property_type", nullable = false, length = 30)
    private MortgageDetail.PropertyType propertyType;

    // Financials
    @Column(name = "purchase_price", nullable = false, precision = 14, scale = 2)
    private BigDecimal purchasePrice;

    @Column(name = "down_payment", nullable = false, precision = 14, scale = 2)
    private BigDecimal downPayment;

    @Column(name = "ltv_ratio", precision = 5, scale = 2)
    private BigDecimal ltvRatio;

    // Mortgage specifics
    @Column(name = "is_primary_residence", nullable = false)
    private boolean primaryResidence = true;

    @Column(name = "is_first_time_buyer", nullable = false)
    private boolean firstTimeBuyer = false;

    @Column(name = "has_existing_mortgage", nullable = false)
    private boolean hasExistingMortgage = false;

    @Column(name = "co_borrower_name", length = 200)
    private String coBorrowerName;

    @Column(name = "co_borrower_income", precision = 15, scale = 2)
    private BigDecimal coBorrowerIncome;

    // Ongoing costs
    @Column(name = "annual_property_tax", precision = 10, scale = 2)
    private BigDecimal annualPropertyTax;

    @Column(name = "annual_insurance", precision = 10, scale = 2)
    private BigDecimal annualInsurance;

    @Column(name = "hoa_monthly_fee", precision = 8, scale = 2)
    private BigDecimal hoaMonthlyFee;

    // Loan structure preference
    @Enumerated(EnumType.STRING)
    @Column(name = "rate_type", nullable = false, length = 15)
    private Loan.RateType rateType = Loan.RateType.FIXED;

    @Column(name = "preferred_closing_date")
    private LocalDate preferredClosingDate;

    @Column(name = "realtor_name", length = 200)
    private String realtorName;

    @Column(name = "additional_notes", columnDefinition = "TEXT")
    private String additionalNotes;

    // ── Getters / Setters ─────────────────────────────────────────────────────
    public Long getId()                                  { return id; }
    public LoanApplication getApplication()              { return application; }
    public void setApplication(LoanApplication v)        { this.application = v; }
    public String getPropertyAddress()                   { return propertyAddress; }
    public void setPropertyAddress(String v)             { this.propertyAddress = v; }
    public String getPropertyCity()                      { return propertyCity; }
    public void setPropertyCity(String v)                { this.propertyCity = v; }
    public String getPropertyStateCode()                 { return propertyStateCode; }
    public void setPropertyStateCode(String v)           { this.propertyStateCode = v; }
    public String getPropertyZip()                       { return propertyZip; }
    public void setPropertyZip(String v)                 { this.propertyZip = v; }
    public MortgageDetail.PropertyType getPropertyType() { return propertyType; }
    public void setPropertyType(MortgageDetail.PropertyType v) { this.propertyType = v; }
    public BigDecimal getPurchasePrice()                 { return purchasePrice; }
    public void setPurchasePrice(BigDecimal v)           { this.purchasePrice = v; }
    public BigDecimal getDownPayment()                   { return downPayment; }
    public void setDownPayment(BigDecimal v)             { this.downPayment = v; }
    public BigDecimal getLtvRatio()                      { return ltvRatio; }
    public void setLtvRatio(BigDecimal v)                { this.ltvRatio = v; }
    public boolean isPrimaryResidence()                  { return primaryResidence; }
    public void setPrimaryResidence(boolean v)           { this.primaryResidence = v; }
    public boolean isFirstTimeBuyer()                    { return firstTimeBuyer; }
    public void setFirstTimeBuyer(boolean v)             { this.firstTimeBuyer = v; }
    public boolean isHasExistingMortgage()               { return hasExistingMortgage; }
    public void setHasExistingMortgage(boolean v)        { this.hasExistingMortgage = v; }
    public String getCoBorrowerName()                    { return coBorrowerName; }
    public void setCoBorrowerName(String v)              { this.coBorrowerName = v; }
    public BigDecimal getCoBorrowerIncome()              { return coBorrowerIncome; }
    public void setCoBorrowerIncome(BigDecimal v)        { this.coBorrowerIncome = v; }
    public BigDecimal getAnnualPropertyTax()             { return annualPropertyTax; }
    public void setAnnualPropertyTax(BigDecimal v)       { this.annualPropertyTax = v; }
    public BigDecimal getAnnualInsurance()               { return annualInsurance; }
    public void setAnnualInsurance(BigDecimal v)         { this.annualInsurance = v; }
    public BigDecimal getHoaMonthlyFee()                 { return hoaMonthlyFee; }
    public void setHoaMonthlyFee(BigDecimal v)           { this.hoaMonthlyFee = v; }
    public Loan.RateType getRateType()                   { return rateType; }
    public void setRateType(Loan.RateType v)             { this.rateType = v; }
    public LocalDate getPreferredClosingDate()           { return preferredClosingDate; }
    public void setPreferredClosingDate(LocalDate v)     { this.preferredClosingDate = v; }
    public String getRealtorName()                       { return realtorName; }
    public void setRealtorName(String v)                 { this.realtorName = v; }
    public String getAdditionalNotes()                   { return additionalNotes; }
    public void setAdditionalNotes(String v)             { this.additionalNotes = v; }
}