package com.nexusbank.controller;

import com.nexusbank.domain.entity.*;
import com.nexusbank.repository.*;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Controller
public class DashboardController {

    private final CustomerRepository          customerRepository;
    private final AccountRepository           accountRepository;
    private final LoanRepository              loanRepository;
    private final TransactionRepository       transactionRepository;
    private final CustomerAddressRepository   addressRepository;
    private final CustomerAlertRepository     alertRepository;
    private final MortgageDetailRepository    mortgageDetailRepository;
    private final AutoLoanDetailRepository    autoLoanDetailRepository;
    private final StudentLoanDetailRepository studentLoanDetailRepository;

    public DashboardController(
            CustomerRepository customerRepository,
            AccountRepository accountRepository,
            LoanRepository loanRepository,
            TransactionRepository transactionRepository,
            CustomerAddressRepository addressRepository,
            CustomerAlertRepository alertRepository,
            MortgageDetailRepository mortgageDetailRepository,
            AutoLoanDetailRepository autoLoanDetailRepository,
            StudentLoanDetailRepository studentLoanDetailRepository) {
        this.customerRepository          = customerRepository;
        this.accountRepository           = accountRepository;
        this.loanRepository              = loanRepository;
        this.transactionRepository       = transactionRepository;
        this.addressRepository           = addressRepository;
        this.alertRepository             = alertRepository;
        this.mortgageDetailRepository    = mortgageDetailRepository;
        this.autoLoanDetailRepository    = autoLoanDetailRepository;
        this.studentLoanDetailRepository = studentLoanDetailRepository;
    }

    // ── Root redirect ─────────────────────────────────────────────────────────
    @GetMapping("/")
    public String root() {
        return "redirect:/dashboard";
    }

    // ── Dashboard ─────────────────────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        Optional<Customer> customerOpt = customerRepository.findByKeycloakUserId(oidcUser.getSubject());

        if (customerOpt.isPresent()) {
            Customer customer = customerOpt.get();
            Long cid = customer.getCustomerId();

            List<Account>     accounts = accountRepository.findWithProductAndBranchByCustomerId(cid);
            List<Loan>        loans    = loanRepository.findWithProductByCustomerId(cid);
            List<Transaction> recent   = transactionRepository.findRecentByCustomerId(cid, PageRequest.of(0, 10));
            List<CustomerAlert> alerts = alertRepository.findUnreadByCustomerId(cid);

            BigDecimal totalDeposits = accounts.stream()
                    .filter(a -> a.getAccountStatus() == Account.AccountStatus.ACTIVE)
                    .map(Account::getCurrentBalance)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal totalLoanBalance = loans.stream()
                    .filter(l -> l.getLoanStatus() != Loan.LoanStatus.PAID_OFF
                            && l.getLoanStatus() != Loan.LoanStatus.CHARGED_OFF)
                    .map(Loan::getOutstandingBalance)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            long depositAccountCount = accounts.stream()
                    .filter(a -> a.getAccountStatus() == Account.AccountStatus.ACTIVE).count();
            long activeLoanCount = loans.stream()
                    .filter(l -> l.getLoanStatus() != Loan.LoanStatus.PAID_OFF
                            && l.getLoanStatus() != Loan.LoanStatus.CHARGED_OFF).count();

            model.addAttribute("customer",            customer);
            model.addAttribute("accounts",            accounts);
            model.addAttribute("loans",               loans);
            model.addAttribute("recentTransactions",  recent);
            model.addAttribute("alerts",              alerts);
            model.addAttribute("totalDeposits",       totalDeposits);
            model.addAttribute("totalLoanBalance",    totalLoanBalance);
            model.addAttribute("netWorth",            totalDeposits.subtract(totalLoanBalance));
            model.addAttribute("depositAccountCount", depositAccountCount);
            model.addAttribute("activeLoanCount",     activeLoanCount);
        } else {
            model.addAttribute("newUser", true);
        }
        return "dashboard/dashboard";
    }

    // ── Accounts List ─────────────────────────────────────────────────────────
    @GetMapping("/accounts")
    public String accounts(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            Long cid = customer.getCustomerId();
            List<Account> accounts = accountRepository.findWithProductAndBranchByCustomerId(cid);

            BigDecimal totalCurrent   = accounts.stream()
                    .filter(a -> a.getAccountStatus() == Account.AccountStatus.ACTIVE)
                    .map(Account::getCurrentBalance).reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal totalAvailable = accounts.stream()
                    .filter(a -> a.getAccountStatus() == Account.AccountStatus.ACTIVE)
                    .map(Account::getAvailableBalance).reduce(BigDecimal.ZERO, BigDecimal::add);
            long activeCount = accounts.stream()
                    .filter(a -> a.getAccountStatus() == Account.AccountStatus.ACTIVE).count();

            model.addAttribute("customer",       customer);
            model.addAttribute("accounts",       accounts);
            model.addAttribute("totalCurrent",   totalCurrent);
            model.addAttribute("totalAvailable", totalAvailable);
            model.addAttribute("activeCount",    activeCount);
        });
        model.addAttribute("allAccounts", accountRepository.findAllWithProductAndCustomer());
        return "accounts/list";
    }

    // ── Account Detail ────────────────────────────────────────────────────────
    @GetMapping("/accounts/{accountId}")
    public String accountDetail(@PathVariable Long accountId,
                                @AuthenticationPrincipal OidcUser oidcUser, Model model) {
        // findByIdWithProduct JOIN FETCHes accountProduct — avoids LazyInitializationException
        accountRepository.findByIdWithProduct(accountId).ifPresent(account -> {
            List<Transaction> transactions =
                    transactionRepository.findByAccountIdOrderByDateDesc(accountId);

            Integer cdProgress = null;
            if (account.getMaturityDate() != null && account.getOpenedDate() != null) {
                long totalDays = ChronoUnit.DAYS.between(account.getOpenedDate(), account.getMaturityDate());
                long elapsed   = ChronoUnit.DAYS.between(account.getOpenedDate(), LocalDate.now());
                if (totalDays > 0) {
                    cdProgress = (int) Math.min(100, Math.max(0, elapsed * 100 / totalDays));
                }
            }

            // Materialize lazy beneficiaries collection inside the session
            List<?> beneficiaries = account.getBeneficiaries() != null
                    ? new ArrayList<>(account.getBeneficiaries())
                    : Collections.emptyList();

            model.addAttribute("account",       account);
            model.addAttribute("transactions",  transactions);
            model.addAttribute("beneficiaries", beneficiaries);
            model.addAttribute("cdProgress",    cdProgress != null ? cdProgress : 0);
        });
        return "accounts/detail";
    }

    // ── Loans List ────────────────────────────────────────────────────────────
    @GetMapping("/loans")
    public String loans(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            List<Loan> loans = loanRepository.findWithProductByCustomerId(customer.getCustomerId());

            BigDecimal totalOutstanding = loans.stream()
                    .filter(l -> l.getLoanStatus() != Loan.LoanStatus.PAID_OFF
                            && l.getLoanStatus() != Loan.LoanStatus.CHARGED_OFF)
                    .map(Loan::getOutstandingBalance).reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal totalMonthlyPayment = loans.stream()
                    .filter(l -> l.getLoanStatus() != Loan.LoanStatus.PAID_OFF
                            && l.getLoanStatus() != Loan.LoanStatus.CHARGED_OFF)
                    .map(Loan::getMonthlyPaymentAmount).reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal totalOriginalAmount = loans.stream()
                    .map(Loan::getOriginalAmount).reduce(BigDecimal.ZERO, BigDecimal::add);

            long activeCount = loans.stream()
                    .filter(l -> l.getLoanStatus() != Loan.LoanStatus.PAID_OFF
                            && l.getLoanStatus() != Loan.LoanStatus.CHARGED_OFF).count();

            model.addAttribute("customer",            customer);
            model.addAttribute("loans",               loans);
            model.addAttribute("totalOutstanding",    totalOutstanding);
            model.addAttribute("totalMonthlyPayment", totalMonthlyPayment);
            model.addAttribute("totalOriginalAmount", totalOriginalAmount);
            model.addAttribute("activeCount",         activeCount);
        });
        return "loans/list";
    }

    // ── Loan Detail ───────────────────────────────────────────────────────────
    @GetMapping("/loans/{loanId}")
    public String loanDetail(@PathVariable Long loanId,
                             @AuthenticationPrincipal OidcUser oidcUser, Model model) {
        loanRepository.findById(loanId).ifPresent(loan -> {
            // Materialize lazy paymentSchedule collection inside the session
            List<?> schedule = loan.getPaymentSchedule() != null
                    ? new ArrayList<>(loan.getPaymentSchedule())
                    : Collections.emptyList();

            model.addAttribute("loan",            loan);
            model.addAttribute("paymentSchedule", schedule);

            if (loan.getLoanType() == Loan.LoanType.MORTGAGE
                    || loan.getLoanType() == Loan.LoanType.HOME_EQUITY_LOAN
                    || loan.getLoanType() == Loan.LoanType.HELOC) {
                mortgageDetailRepository.findByLoan_Id(loanId)
                        .ifPresent(md -> model.addAttribute("mortgageDetail", md));
            }
            if (loan.getLoanType() == Loan.LoanType.AUTO) {
                autoLoanDetailRepository.findByLoan_Id(loanId)
                        .ifPresent(ad -> model.addAttribute("autoDetail", ad));
            }
            if (loan.getLoanType() == Loan.LoanType.STUDENT_UNDERGRADUATE
                    || loan.getLoanType() == Loan.LoanType.STUDENT_GRADUATE
                    || loan.getLoanType() == Loan.LoanType.STUDENT_REFINANCE) {
                studentLoanDetailRepository.findByLoan_Id(loanId)
                        .ifPresent(sd -> model.addAttribute("studentDetail", sd));
            }
        });
        return "loans/detail";
    }

    // ── Profile ───────────────────────────────────────────────────────────────
    @GetMapping("/profile")
    public String profile(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        // Use dedicated query that JOIN FETCHes documents — avoids LazyInitializationException
        customerRepository.findWithDocumentsByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            List<CustomerAddress> addresses =
                    addressRepository.findByCustomer_CustomerIdOrderByIsPrimaryDesc(customer.getCustomerId());
            // documents is now fully initialized — safe to wrap as ArrayList
            List<?> docs = customer.getDocuments() != null
                    ? new ArrayList<>(customer.getDocuments())
                    : Collections.emptyList();
            model.addAttribute("customer",  customer);
            model.addAttribute("addresses", addresses);
            model.addAttribute("documents", docs);
        });
        return "dashboard/profile";
    }

    // ── Transactions ──────────────────────────────────────────────────────────
    @GetMapping("/transactions")
    public String transactions(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            List<Account> accounts =
                    accountRepository.findByCustomer_CustomerIdOrderByOpenedDateAsc(customer.getCustomerId());
            List<Transaction> all = new ArrayList<>();
            for (Account a : accounts) {
                all.addAll(transactionRepository.findByAccountIdOrderByDateDesc(a.getId()));
            }
            all.sort(java.util.Comparator.comparing(Transaction::getTransactionDate).reversed());
            model.addAttribute("customer",     customer);
            model.addAttribute("accounts",     accounts);
            model.addAttribute("transactions", all);
        });
        return "transactions/list";
    }

    // ── Cards (stub) ──────────────────────────────────────────────────────────
    @GetMapping("/cards")
    public String cards(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject())
                .ifPresent(c -> model.addAttribute("customer", c));
        return "cards/list";
    }

    // ── Transfers ─────────────────────────────────────────────────────────────
    @GetMapping("/transfers")
    public String transfers(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            model.addAttribute("customer", customer);
            model.addAttribute("accounts",
                    accountRepository.findByCustomer_CustomerIdOrderByOpenedDateAsc(customer.getCustomerId()));
        });
        return "transfers/list";
    }

    // ── Alerts ────────────────────────────────────────────────────────────────
    @GetMapping("/alerts")
    public String alerts(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            model.addAttribute("customer", customer);
            model.addAttribute("alerts",
                    alertRepository.findUnreadByCustomerId(customer.getCustomerId()));
        });
        return "alerts/list";
    }

    // ── Statements ────────────────────────────────────────────────────────────
    @GetMapping("/statements")
    public String statements(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject()).ifPresent(customer -> {
            model.addAttribute("customer", customer);
            model.addAttribute("accounts",
                    accountRepository.findByCustomer_CustomerIdOrderByOpenedDateAsc(customer.getCustomerId()));
        });
        return "statements/list";
    }

    // ── Loan Apply ────────────────────────────────────────────────────────────
    @GetMapping("/loans/apply")
    public String loanApply(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject())
                .ifPresent(c -> model.addAttribute("customer", c));
        return "loans/apply";
    }

    // ── Loan Calculator ───────────────────────────────────────────────────────
    @GetMapping("/loans/calculator")
    public String loanCalculator(@AuthenticationPrincipal OidcUser oidcUser, Model model) {
        customerRepository.findByKeycloakUserId(oidcUser.getSubject())
                .ifPresent(c -> model.addAttribute("customer", c));
        return "loans/calculator";
    }

    // ── Banker: Customers ─────────────────────────────────────────────────────
    @GetMapping("/banker/customers")
    public String bankerCustomers(Model model) {
        model.addAttribute("customers", customerRepository.findByIsActive(true));
        return "banker/customers";
    }

    // ── Admin: Reports ────────────────────────────────────────────────────────
    @GetMapping("/admin/reports")
    public String adminReports(Model model) {
        model.addAttribute("totalCustomers", customerRepository.count());
        model.addAttribute("totalAccounts",  accountRepository.count());
        model.addAttribute("totalLoans",     loanRepository.count());
        model.addAttribute("loanSummary",    loanRepository.getLoanSummaryByType());
        return "admin/reports";
    }
}