package com.nexusbank.repository;

import com.nexusbank.domain.entity.CustomerAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

// ─── CustomerAddress Repository ───────────────────────────────────────────────
@Repository
public interface CustomerAddressRepository extends JpaRepository<CustomerAddress, Long> {
    List<CustomerAddress> findByCustomer_CustomerIdOrderByIsPrimaryDesc(Long customerId);
}
