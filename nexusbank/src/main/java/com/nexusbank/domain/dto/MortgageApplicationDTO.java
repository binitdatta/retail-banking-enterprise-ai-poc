package com.nexusbank.domain.dto;

import com.nexusbank.domain.entity.Loan;
import com.nexusbank.domain.entity.MortgageDetail;
import jakarta.validation.constraints.*;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Form-backing DTO for the mortgage application form.
 * Validated before being handed to MortgageApplicationService.
 */
public class MortgageApplicationDTO {

    // ── Loan parameters ───────────────────────────────────────────────────────
    @NotNull(message = "Loan amount is required")
    @DecimalMin(value = "100000.00", message = "Minimum mortgage amount is $100,000")
    @DecimalMax(value = "5000000.00", message = "Maximum mortgage amount is $5,000,000")
    private BigDecimal requestedAmount;

    @NotNull(message = "Loan term is required")
    @Min(value = 60,  message = "Minimum term is 60 months (5 years)")
    @Max(value = 360, message = "Maximum term is 360 months (30 years)")
    private Integer requestedTermMonths;

    @NotNull(message = "Rate type is required")
    private Loan.RateType requestedRateType = Loan.RateType.FIXED;

    @Size(max = 500, message = "Purpose must be 500 characters or less")
    private String purpose;

    // ── Property details ──────────────────────────────────────────────────────
    @NotBlank(message = "Property address is required")
    @Size(max = 500, message = "Address must be 500 characters or less")
    private String propertyAddress;

    @NotBlank(message = "City is required")
    @Size(max = 100, message = "City must be 100 characters or less")
    private String propertyCity;

    @NotBlank(message = "State is required")
    @Size(min = 2, max = 2, message = "State must be a 2-letter code")
    private String propertyStateCode;

    @NotBlank(message = "ZIP code is required")
    @Pattern(regexp = "^\\d{5}(-\\d{4})?$", message = "Enter a valid ZIP code")
    private String propertyZip;

    @NotNull(message = "Property type is required")
    private MortgageDetail.PropertyType propertyType;

    // ── Financial details ─────────────────────────────────────────────────────
    @NotNull(message = "Purchase price is required")
    @DecimalMin(value = "50000.00", message = "Purchase price must be at least $50,000")
    private BigDecimal purchasePrice;

    @NotNull(message = "Down payment is required")
    @DecimalMin(value = "0.00", message = "Down payment cannot be negative")
    private BigDecimal downPayment;

    @DecimalMin(value = "0.00", message = "Annual property tax cannot be negative")
    private BigDecimal annualPropertyTax;

    @DecimalMin(value = "0.00", message = "Annual insurance cannot be negative")
    private BigDecimal annualInsurance;

    @DecimalMin(value = "0.00", message = "HOA fee cannot be negative")
    private BigDecimal hoaMonthlyFee;

    // ── Borrower details ──────────────────────────────────────────────────────
    private boolean primaryResidence = true;
    private boolean firstTimeBuyer   = false;
    private boolean hasExistingMortgage = false;

    @Size(max = 200, message = "Co-borrower name must be 200 characters or less")
    private String coBorrowerName;

    @DecimalMin(value = "0.00", message = "Co-borrower income cannot be negative")
    private BigDecimal coBorrowerIncome;

    // ── Closing details ───────────────────────────────────────────────────────
    private LocalDate preferredClosingDate;

    @Size(max = 200, message = "Realtor name must be 200 characters or less")
    private String realtorName;

    @Size(max = 2000, message = "Additional notes must be 2000 characters or less")
    private String additionalNotes;

    // ── Getters / Setters ─────────────────────────────────────────────────────
    public BigDecimal getRequestedAmount()               { return requestedAmount; }
    public void setRequestedAmount(BigDecimal v)         { this.requestedAmount = v; }
    public Integer getRequestedTermMonths()              { return requestedTermMonths; }
    public void setRequestedTermMonths(Integer v)        { this.requestedTermMonths = v; }
    public Loan.RateType getRequestedRateType()          { return requestedRateType; }
    public void setRequestedRateType(Loan.RateType v)    { this.requestedRateType = v; }
    public String getPurpose()                           { return purpose; }
    public void setPurpose(String v)                     { this.purpose = v; }
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
    public BigDecimal getAnnualPropertyTax()             { return annualPropertyTax; }
    public void setAnnualPropertyTax(BigDecimal v)       { this.annualPropertyTax = v; }
    public BigDecimal getAnnualInsurance()               { return annualInsurance; }
    public void setAnnualInsurance(BigDecimal v)         { this.annualInsurance = v; }
    public BigDecimal getHoaMonthlyFee()                 { return hoaMonthlyFee; }
    public void setHoaMonthlyFee(BigDecimal v)           { this.hoaMonthlyFee = v; }
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
    public LocalDate getPreferredClosingDate()           { return preferredClosingDate; }
    public void setPreferredClosingDate(LocalDate v)     { this.preferredClosingDate = v; }
    public String getRealtorName()                       { return realtorName; }
    public void setRealtorName(String v)                 { this.realtorName = v; }
    public String getAdditionalNotes()                   { return additionalNotes; }
    public void setAdditionalNotes(String v)             { this.additionalNotes = v; }
}