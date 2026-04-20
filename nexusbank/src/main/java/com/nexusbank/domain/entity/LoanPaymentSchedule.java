package com.nexusbank.domain.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "loan_payment_schedule")
public class LoanPaymentSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "loan_id", nullable = false)
    private Loan loan;

    @Column(name = "payment_number", nullable = false)
    private Integer paymentNumber;

    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    @Column(name = "scheduled_payment", nullable = false, precision = 12, scale = 2)
    private BigDecimal scheduledPayment;

    @Column(name = "principal_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal principalAmount;

    @Column(name = "interest_amount", nullable = false, precision = 12, scale = 2)
    private BigDecimal interestAmount;

    @Column(name = "escrow_amount", precision = 10, scale = 2)
    private BigDecimal escrowAmount = BigDecimal.ZERO;

    @Column(name = "remaining_balance", nullable = false, precision = 14, scale = 2)
    private BigDecimal remainingBalance;

    @Column(name = "actual_payment_date")
    private LocalDate actualPaymentDate;

    @Column(name = "actual_amount_paid", precision = 12, scale = 2)
    private BigDecimal actualAmountPaid;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false, length = 20)
    private PaymentStatus paymentStatus = PaymentStatus.SCHEDULED;

    @Column(name = "late_fee", precision = 8, scale = 2)
    private BigDecimal lateFee = BigDecimal.ZERO;

    public enum PaymentStatus {
        SCHEDULED("Scheduled"), CURRENT("Due"), PAID("Paid"),
        OVERDUE("Overdue"), WAIVED("Waived"), DEFERRED("Deferred");
        private final String displayName;
        PaymentStatus(String d) { this.displayName = d; }
        public String getDisplayName() { return displayName; }
    }

    public Long          getId()                          { return id; }
    public Loan          getLoan()                        { return loan; }
    public void          setLoan(Loan v)                  { this.loan = v; }
    public Integer       getPaymentNumber()               { return paymentNumber; }
    public void          setPaymentNumber(Integer v)      { this.paymentNumber = v; }
    public LocalDate     getDueDate()                     { return dueDate; }
    public void          setDueDate(LocalDate v)          { this.dueDate = v; }
    public BigDecimal    getScheduledPayment()            { return scheduledPayment; }
    public void          setScheduledPayment(BigDecimal v){ this.scheduledPayment = v; }
    public BigDecimal    getPrincipalAmount()             { return principalAmount; }
    public void          setPrincipalAmount(BigDecimal v) { this.principalAmount = v; }
    public BigDecimal    getInterestAmount()              { return interestAmount; }
    public void          setInterestAmount(BigDecimal v)  { this.interestAmount = v; }
    public BigDecimal    getEscrowAmount()                { return escrowAmount; }
    public void          setEscrowAmount(BigDecimal v)    { this.escrowAmount = v; }
    public BigDecimal    getRemainingBalance()            { return remainingBalance; }
    public void          setRemainingBalance(BigDecimal v){ this.remainingBalance = v; }
    public LocalDate     getActualPaymentDate()           { return actualPaymentDate; }
    public void          setActualPaymentDate(LocalDate v){ this.actualPaymentDate = v; }
    public BigDecimal    getActualAmountPaid()            { return actualAmountPaid; }
    public void          setActualAmountPaid(BigDecimal v){ this.actualAmountPaid = v; }
    public PaymentStatus getPaymentStatus()               { return paymentStatus; }
    public void          setPaymentStatus(PaymentStatus v){ this.paymentStatus = v; }
    public BigDecimal    getLateFee()                     { return lateFee; }
    public void          setLateFee(BigDecimal v)         { this.lateFee = v; }
}
