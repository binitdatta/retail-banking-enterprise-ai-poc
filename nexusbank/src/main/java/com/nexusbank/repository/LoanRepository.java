package com.nexusbank.repository;

import com.nexusbank.domain.entity.Loan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

// ─── Loan Repository ─────────────────────────────────────────────────────────
@Repository
public interface LoanRepository extends JpaRepository<Loan, Long> {
    Optional<Loan> findByLoanNumber(String loanNumber);

    List<Loan> findByCustomer_CustomerIdOrderByCreatedAtDesc(Long customerId);

    @Query("SELECT l FROM Loan l JOIN FETCH l.loanProduct WHERE l.customer.customerId = :cid " +
            "ORDER BY l.originationDate DESC")
    List<Loan> findWithProductByCustomerId(@Param("cid") Long customerId);

    @Query("SELECT l.loanType, COUNT(l), SUM(l.outstandingBalance) FROM Loan l " +
            "WHERE l.loanStatus NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED') GROUP BY l.loanType")
    List<Object[]> getLoanSummaryByType();

    @Query("SELECT COUNT(l) FROM Loan l WHERE l.loanStatus = :status")
    Long countByLoanStatus(@Param("status") Loan.LoanStatus status);

    @Query("SELECT COUNT(l) FROM Loan l WHERE l.customer.customerId = :cid " +
            "AND l.loanStatus NOT IN ('PAID_OFF','CHARGED_OFF','CANCELLED')")
    Long countActiveByCustomerId(@Param("cid") Long customerId);
}
