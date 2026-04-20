package com.nexusbank.repository;

import com.nexusbank.domain.entity.Transaction;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

// ─── Transaction Repository ───────────────────────────────────────────────────
@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {
    @Query("SELECT t FROM Transaction t " +
            "JOIN FETCH t.account a " +
            "JOIN FETCH a.accountProduct " +
            "LEFT JOIN FETCH t.transactionCategory " +
            "WHERE a.customer.customerId = :cid " +
            "ORDER BY t.transactionDate DESC")
    List<Transaction> findRecentByCustomerId(@Param("cid") Long customerId, Pageable pageable);

    @Query("SELECT t FROM Transaction t " +
            "JOIN FETCH t.account " +
            "LEFT JOIN FETCH t.transactionCategory " +
            "WHERE t.account.id = :accountId " +
            "ORDER BY t.transactionDate DESC")
    List<Transaction> findByAccountIdOrderByDateDesc(@Param("accountId") Long accountId);
}
