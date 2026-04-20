package com.nexusbank.repository;

import com.nexusbank.domain.entity.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    Optional<Customer> findByKeycloakUserId(String keycloakUserId);
    Optional<Customer> findByCustomerNumber(String customerNumber);
    Optional<Customer> findByEmail(String email);
    List<Customer> findByIsActive(Boolean isActive);

    @Query("SELECT c FROM Customer c " +
            "WHERE LOWER(c.firstName) LIKE LOWER(CONCAT('%',:term,'%')) " +
            "   OR LOWER(c.lastName)  LIKE LOWER(CONCAT('%',:term,'%')) " +
            "   OR LOWER(c.email)     LIKE LOWER(CONCAT('%',:term,'%')) " +
            "   OR c.customerNumber   LIKE CONCAT('%',:term,'%')")
    Page<Customer> searchCustomers(@Param("term") String term, Pageable pageable);

    @Query("SELECT COUNT(c) FROM Customer c WHERE c.customerType = :type AND c.isActive = true")
    Long countByCustomerType(@Param("type") Customer.CustomerType type);

    @Query("SELECT c FROM Customer c LEFT JOIN FETCH c.documents WHERE c.keycloakUserId = :sub")
    Optional<Customer> findWithDocumentsByKeycloakUserId(@Param("sub") String keycloakUserId);
}