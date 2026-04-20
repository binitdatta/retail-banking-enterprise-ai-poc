package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "account_beneficiaries")
public class AccountBeneficiary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "beneficiary_id")
    private Long beneficiaryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;

    @Column(name = "beneficiary_name", nullable = false, length = 200)
    private String beneficiaryName;

    @Column(name = "relationship", length = 50)
    private String relationship;

    @Column(name = "allocation_percent", nullable = false, precision = 5, scale = 2)
    private BigDecimal allocationPercent = BigDecimal.valueOf(100);

    @Column(name = "ssn_last4", length = 4)
    private String ssnLast4;

    @Column(name = "is_primary", nullable = false)
    private boolean isPrimary = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public Long        getBeneficiaryId()            { return beneficiaryId; }
    public Account     getAccount()                  { return account; }
    public void        setAccount(Account v)          { this.account = v; }
    public String      getBeneficiaryName()           { return beneficiaryName; }
    public void        setBeneficiaryName(String v)   { this.beneficiaryName = v; }
    public String      getRelationship()              { return relationship; }
    public void        setRelationship(String v)      { this.relationship = v; }
    public BigDecimal  getAllocationPercent()          { return allocationPercent; }
    public void        setAllocationPercent(BigDecimal v) { this.allocationPercent = v; }
    public String      getSsnLast4()                  { return ssnLast4; }
    public void        setSsnLast4(String v)          { this.ssnLast4 = v; }
    public boolean     isPrimary()                    { return isPrimary; }
    public void        setPrimary(boolean v)          { this.isPrimary = v; }
    public LocalDateTime getCreatedAt()               { return createdAt; }
}
