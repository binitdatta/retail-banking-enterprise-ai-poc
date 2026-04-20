package com.nexusbank.repository;

import com.nexusbank.domain.entity.CustomerAlert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

// ─── CustomerAlert Repository ─────────────────────────────────────────────────
@Repository
public interface CustomerAlertRepository extends JpaRepository<CustomerAlert, Long> {
    @Query("SELECT a FROM CustomerAlert a WHERE a.customer.customerId = :cid " +
            "AND a.isRead = false ORDER BY a.createdAt DESC")
    List<CustomerAlert> findUnreadByCustomerId(@Param("cid") Long customerId);
}
