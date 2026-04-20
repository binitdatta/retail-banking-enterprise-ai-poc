package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "customer_alerts")
public class CustomerAlert {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "alert_id")
    private Long alertId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @Enumerated(EnumType.STRING)
    @Column(name = "alert_type", nullable = false, length = 40)
    private AlertType alertType;

    @Column(name = "message", nullable = false, length = 500)
    private String message;

    @Column(name = "is_read", nullable = false)
    private boolean isRead = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { this.createdAt = LocalDateTime.now(); }

    public enum AlertType {
        LOW_BALANCE("Low Balance"), LARGE_TRANSACTION("Large Transaction"),
        PAYMENT_DUE("Payment Due"), PAYMENT_OVERDUE("Payment Overdue"),
        SECURITY("Security Alert"), KYC_EXPIRY("KYC Expiry"),
        STATEMENT_READY("Statement Ready"), GENERAL("General");
        private final String displayName;
        AlertType(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Long          getAlertId()             { return alertId; }
    public Customer      getCustomer()             { return customer; }
    public void          setCustomer(Customer v)   { this.customer = v; }
    public AlertType     getAlertType()            { return alertType; }
    public void          setAlertType(AlertType v) { this.alertType = v; }
    public String        getMessage()              { return message; }
    public void          setMessage(String v)      { this.message = v; }
    public boolean       isRead()                  { return isRead; }
    public void          setRead(boolean v)        { this.isRead = v; }
    public LocalDateTime getCreatedAt()            { return createdAt; }
}
