package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "auto_loan_details")
public class AutoLoanDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_id", nullable = false)
    private Loan loan;

    @Column(name = "vin", length = 17, nullable = false)
    private String vin;

    @Column(name = "vehicle_year")
    private Integer vehicleYear;

    @Column(name = "vehicle_make", length = 50)
    private String vehicleMake;

    @Column(name = "vehicle_model", length = 80)
    private String vehicleModel;

    @Column(name = "vehicle_trim", length = 80)
    private String vehicleTrim;

    @Column(name = "vehicle_color", length = 40)
    private String vehicleColor;

    @Column(name = "vehicle_mileage")
    private Integer vehicleMileage;

    @Column(name = "is_new")
    private boolean isNew;

    @Column(name = "purchase_price", precision = 12, scale = 2)
    private BigDecimal purchasePrice;

    @Column(name = "down_payment", precision = 10, scale = 2)
    private BigDecimal downPayment;

    @Column(name = "trade_in_value", precision = 10, scale = 2)
    private BigDecimal tradeInValue;

    @Column(name = "gap_insurance")
    private boolean gapInsurance;

    @Column(name = "gap_insurance_amount", precision = 8, scale = 2)
    private BigDecimal gapInsuranceAmount;

    @Column(name = "dealer_name", length = 150)
    private String dealerName;

    @Column(name = "purchase_date")
    private LocalDate purchaseDate;

    @Column(name = "title_state", length = 2)
    private String titleState;

    @Column(name = "license_plate", length = 20)
    private String licensePlate;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    // ── Getters ──────────────────────────────────────────────────
    public Long getId() { return id; }
    public Loan getLoan() { return loan; }
    public String getVin() { return vin; }
    public Integer getVehicleYear() { return vehicleYear; }
    public String getVehicleMake() { return vehicleMake; }
    public String getVehicleModel() { return vehicleModel; }
    public String getVehicleTrim() { return vehicleTrim; }
    public String getVehicleColor() { return vehicleColor; }
    public Integer getVehicleMileage() { return vehicleMileage; }
    public boolean isNew() { return isNew; }
    public BigDecimal getPurchasePrice() { return purchasePrice; }
    public BigDecimal getDownPayment() { return downPayment; }
    public BigDecimal getTradeInValue() { return tradeInValue; }
    public boolean isGapInsurance() { return gapInsurance; }
    public BigDecimal getGapInsuranceAmount() { return gapInsuranceAmount; }
    public String getDealerName() { return dealerName; }
    public LocalDate getPurchaseDate() { return purchaseDate; }
    public String getTitleState() { return titleState; }
    public String getLicensePlate() { return licensePlate; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    // ── Setters ──────────────────────────────────────────────────
    public void setId(Long id) { this.id = id; }
    public void setLoan(Loan loan) { this.loan = loan; }
    public void setVin(String v) { this.vin = v; }
    public void setVehicleYear(Integer v) { this.vehicleYear = v; }
    public void setVehicleMake(String v) { this.vehicleMake = v; }
    public void setVehicleModel(String v) { this.vehicleModel = v; }
    public void setVehicleTrim(String v) { this.vehicleTrim = v; }
    public void setVehicleColor(String v) { this.vehicleColor = v; }
    public void setVehicleMileage(Integer v) { this.vehicleMileage = v; }
    public void setNew(boolean v) { this.isNew = v; }
    public void setPurchasePrice(BigDecimal v) { this.purchasePrice = v; }
    public void setDownPayment(BigDecimal v) { this.downPayment = v; }
    public void setTradeInValue(BigDecimal v) { this.tradeInValue = v; }
    public void setGapInsurance(boolean v) { this.gapInsurance = v; }
    public void setGapInsuranceAmount(BigDecimal v) { this.gapInsuranceAmount = v; }
    public void setDealerName(String v) { this.dealerName = v; }
    public void setPurchaseDate(LocalDate v) { this.purchaseDate = v; }
    public void setTitleState(String v) { this.titleState = v; }
    public void setLicensePlate(String v) { this.licensePlate = v; }
}
