package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "customer_documents")
public class CustomerDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "document_id")
    private Long documentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @Enumerated(EnumType.STRING)
    @Column(name = "document_type", nullable = false, length = 30)
    private DocumentType documentType;

    @Column(name = "document_number", nullable = false, length = 100)
    private String documentNumber;

    @Column(name = "issuing_country", length = 2)
    private String issuingCountry;

    @Column(name = "issue_date")
    private LocalDate issueDate;

    @Column(name = "expiration_date")
    private LocalDate expirationDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "verification_status", nullable = false, length = 20)
    private VerificationStatus verificationStatus = VerificationStatus.PENDING;

    @Column(name = "verified_at")
    private LocalDateTime verifiedAt;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public enum DocumentType {
        PASSPORT("Passport"), DRIVERS_LICENSE("Driver's License"),
        STATE_ID("State ID"), NATIONAL_ID("National ID"),
        SSN_CARD("SSN Card"), TAX_ID("Tax ID"), VISA("Visa");
        private final String displayName;
        DocumentType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public enum VerificationStatus {
        PENDING("Pending"), VERIFIED("Verified"), REJECTED("Rejected"), EXPIRED("Expired");
        private final String displayName;
        VerificationStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Long               getDocumentId()               { return documentId; }
    public Customer           getCustomer()                  { return customer; }
    public void               setCustomer(Customer v)        { this.customer = v; }
    public DocumentType       getDocumentType()              { return documentType; }
    public void               setDocumentType(DocumentType v){ this.documentType = v; }
    public String             getDocumentNumber()            { return documentNumber; }
    public void               setDocumentNumber(String v)    { this.documentNumber = v; }
    public String             getIssuingCountry()            { return issuingCountry; }
    public void               setIssuingCountry(String v)    { this.issuingCountry = v; }
    public LocalDate          getIssueDate()                 { return issueDate; }
    public void               setIssueDate(LocalDate v)      { this.issueDate = v; }
    public LocalDate          getExpirationDate()            { return expirationDate; }
    public void               setExpirationDate(LocalDate v) { this.expirationDate = v; }
    public VerificationStatus getVerificationStatus()        { return verificationStatus; }
    public void               setVerificationStatus(VerificationStatus v) { this.verificationStatus = v; }
    public LocalDateTime      getVerifiedAt()                { return verifiedAt; }
    public void               setVerifiedAt(LocalDateTime v) { this.verifiedAt = v; }
    public LocalDateTime      getCreatedAt()                 { return createdAt; }
}
