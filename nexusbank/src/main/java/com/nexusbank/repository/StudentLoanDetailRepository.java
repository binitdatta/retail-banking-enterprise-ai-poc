package com.nexusbank.repository;

import com.nexusbank.domain.entity.StudentLoanDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
// ─── StudentLoanDetail Repository ─────────────────────────────────────────────
@Repository
public interface StudentLoanDetailRepository extends JpaRepository<StudentLoanDetail, Long> {
    Optional<StudentLoanDetail> findByLoan_Id(Long loanId);
}
