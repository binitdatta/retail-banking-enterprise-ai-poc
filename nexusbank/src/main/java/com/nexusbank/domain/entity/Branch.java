package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "branches")
public class Branch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "branch_id")
    private Integer branchId;

    @Column(name = "branch_code", nullable = false, unique = true, length = 15)
    private String branchCode;

    @Column(name = "branch_name", nullable = false, length = 200)
    private String branchName;

    @Column(name = "address_line1", nullable = false, length = 200)
    private String addressLine1;

    @Column(name = "city", nullable = false, length = 100)
    private String city;

    @Column(name = "state_code", nullable = false, length = 2)
    private String stateCode;

    @Column(name = "zip_code", nullable = false, length = 10)
    private String zipCode;

    @Column(name = "phone", nullable = false, length = 20)
    private String phone;

    @Column(name = "manager_name", length = 200)
    private String managerName;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public Integer getBranchId()          { return branchId; }
    public String  getBranchCode()        { return branchCode; }
    public void    setBranchCode(String v){ this.branchCode = v; }
    public String  getBranchName()        { return branchName; }
    public void    setBranchName(String v){ this.branchName = v; }
    public String  getAddressLine1()      { return addressLine1; }
    public void    setAddressLine1(String v){ this.addressLine1 = v; }
    public String  getCity()              { return city; }
    public void    setCity(String v)      { this.city = v; }
    public String  getStateCode()         { return stateCode; }
    public void    setStateCode(String v) { this.stateCode = v; }
    public String  getZipCode()           { return zipCode; }
    public void    setZipCode(String v)   { this.zipCode = v; }
    public String  getPhone()             { return phone; }
    public void    setPhone(String v)     { this.phone = v; }
    public String  getManagerName()       { return managerName; }
    public void    setManagerName(String v){ this.managerName = v; }
    public Boolean getIsActive()          { return isActive; }
    public void    setIsActive(Boolean v) { this.isActive = v; }
    public LocalDateTime getCreatedAt()   { return createdAt; }
}
