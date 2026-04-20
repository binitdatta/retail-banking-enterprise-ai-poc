package com.nexusbank.repository;

import com.nexusbank.domain.entity.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {

    List<Account> findByCustomer_CustomerIdOrderByOpenedDateAsc(Long customerId);

    Optional<Account> findByAccountNumber(String accountNumber);

    @Query("SELECT a FROM Account a " +
            "JOIN FETCH a.accountProduct " +
            "LEFT JOIN FETCH a.branch " +
            "WHERE a.customer.customerId = :cid ORDER BY a.openedDate ASC")
    List<Account> findWithProductAndBranchByCustomerId(@Param("cid") Long customerId);

    @Query("SELECT a FROM Account a " +
            "JOIN FETCH a.accountProduct " +
            "JOIN FETCH a.customer " +
            "ORDER BY a.customer.lastName, a.openedDate")
    List<Account> findAllWithProductAndCustomer();

    // Used by accountDetail — JOIN FETCHes accountProduct to avoid LazyInitializationException
    @Query("SELECT a FROM Account a " +
            "JOIN FETCH a.accountProduct " +
            "LEFT JOIN FETCH a.branch " +
            "WHERE a.id = :id")
    Optional<Account> findByIdWithProduct(@Param("id") Long id);

    @Query("SELECT SUM(a.currentBalance) FROM Account a " +
            "WHERE a.customer.customerId = :cid AND a.accountStatus = 'ACTIVE'")
    BigDecimal sumCurrentBalanceByCustomerId(@Param("cid") Long customerId);

    @Query("SELECT SUM(a.availableBalance) FROM Account a " +
            "WHERE a.customer.customerId = :cid AND a.accountStatus = 'ACTIVE'")
    BigDecimal sumAvailableBalanceByCustomerId(@Param("cid") Long customerId);

    @Query("SELECT COUNT(a) FROM Account a " +
            "WHERE a.customer.customerId = :cid AND a.accountStatus = 'ACTIVE'")
    Long countActiveByCustomerId(@Param("cid") Long customerId);
}