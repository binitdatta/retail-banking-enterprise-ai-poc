package com.nexusbank.repository;

import com.nexusbank.domain.entity.AutoLoanDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
// ─── AutoLoanDetail Repository ────────────────────────────────────────────────
@Repository
public interface AutoLoanDetailRepository extends JpaRepository<AutoLoanDetail, Long> {
    Optional<AutoLoanDetail> findByLoan_Id(Long loanId);
}