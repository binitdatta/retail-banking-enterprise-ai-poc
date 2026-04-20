package com.nexusbank.repository;

import com.nexusbank.domain.entity.MortgageDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

// ─── MortgageDetail Repository ────────────────────────────────────────────────
@Repository
public interface MortgageDetailRepository extends JpaRepository<MortgageDetail, Long> {
    Optional<MortgageDetail> findByLoan_Id(Long loanId);
}
