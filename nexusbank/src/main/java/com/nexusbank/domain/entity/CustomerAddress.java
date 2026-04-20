package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "customer_addresses")
public class CustomerAddress {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "address_id")
    private Long addressId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @Enumerated(EnumType.STRING)
    @Column(name = "address_type", nullable = false, length = 10)
    private AddressType addressType = AddressType.HOME;

    @Column(name = "address_line1", nullable = false, length = 200)
    private String addressLine1;

    @Column(name = "address_line2", length = 200)
    private String addressLine2;

    @Column(name = "city", nullable = false, length = 100)
    private String city;

    @Column(name = "state_code", nullable = false, length = 2)
    private String stateCode;

    @Column(name = "postal_code", nullable = false, length = 10)
    private String postalCode;

    @Column(name = "country_code", nullable = false, length = 2)
    private String countryCode = "US";

    @Column(name = "is_primary", nullable = false)
    private Boolean isPrimary = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); updatedAt = LocalDateTime.now(); }

    @PreUpdate
    protected void onUpdate() { updatedAt = LocalDateTime.now(); }

    public enum AddressType {
        HOME("Home"), MAILING("Mailing"), WORK("Work"), OTHER("Other");
        private final String displayName;
        AddressType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Long        getAddressId()             { return addressId; }
    public Customer    getCustomer()               { return customer; }
    public void        setCustomer(Customer v)     { this.customer = v; }
    public AddressType getAddressType()            { return addressType; }
    public void        setAddressType(AddressType v) { this.addressType = v; }
    public String      getAddressLine1()           { return addressLine1; }
    public void        setAddressLine1(String v)   { this.addressLine1 = v; }
    public String      getAddressLine2()           { return addressLine2; }
    public void        setAddressLine2(String v)   { this.addressLine2 = v; }
    public String      getCity()                   { return city; }
    public void        setCity(String v)           { this.city = v; }
    public String      getStateCode()              { return stateCode; }
    public void        setStateCode(String v)      { this.stateCode = v; }
    public String      getPostalCode()             { return postalCode; }
    public void        setPostalCode(String v)     { this.postalCode = v; }
    public String      getCountryCode()            { return countryCode; }
    public void        setCountryCode(String v)    { this.countryCode = v; }
    public Boolean     getIsPrimary()              { return isPrimary; }
    public void        setIsPrimary(Boolean v)     { this.isPrimary = v; }
    public LocalDateTime getCreatedAt()            { return createdAt; }
    public LocalDateTime getUpdatedAt()            { return updatedAt; }
}
