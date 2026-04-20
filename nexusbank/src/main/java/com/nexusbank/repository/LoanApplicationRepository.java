package com.nexusbank.repository;

import com.nexusbank.domain.entity.LoanApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LoanApplicationRepository extends JpaRepository<LoanApplication, Long> {

    Optional<LoanApplication> findByApplicationNumber(String applicationNumber);

    List<LoanApplication> findByCustomer_CustomerIdOrderBySubmittedAtDesc(Long customerId);

    @Query("SELECT a FROM LoanApplication a " +
            "JOIN FETCH a.customer " +
            "WHERE a.applicationStatus = :status " +
            "ORDER BY a.submittedAt ASC")
    List<LoanApplication> findByStatusForReview(
            @Param("status") LoanApplication.ApplicationStatus status);

    @Query("SELECT a FROM LoanApplication a " +
            "JOIN FETCH a.customer " +
            "ORDER BY a.submittedAt DESC")
    List<LoanApplication> findAllWithCustomer();

    @Query("SELECT a FROM LoanApplication a " +
            "LEFT JOIN FETCH a.mortgageDetail " +
            "WHERE a.id = :id")
    Optional<LoanApplication> findByIdWithDetail(@Param("id") Long id);
}