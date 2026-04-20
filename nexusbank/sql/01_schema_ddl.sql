-- ============================================================
-- NexusBank Platform - DBA-Owned DDL Script
-- MySQL 8.x | Schema Version 1.1.0
-- Run as: nexusbank_dba (DDL privileges)
-- App user: nexusbank_app (DML only - SELECT, INSERT, UPDATE, DELETE)
-- ============================================================
drop database nexusbank_db;

CREATE DATABASE IF NOT EXISTS nexusbank_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE nexusbank_db;

CREATE USER IF NOT EXISTS 'nexusbank_app'@'%' IDENTIFIED BY 'NexusBank@2025!';
GRANT SELECT, INSERT, UPDATE, DELETE ON nexusbank_db.* TO 'nexusbank_app'@'%';
FLUSH PRIVILEGES;

-- ============================================================
-- REFERENCE TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS states (
                                      state_code  CHAR(2)      NOT NULL,
    state_name  VARCHAR(50)  NOT NULL,
    PRIMARY KEY (state_code)
    ) ENGINE=InnoDB COMMENT='US State reference data';

CREATE TABLE IF NOT EXISTS currencies (
                                          currency_code CHAR(3)      NOT NULL,
    currency_name VARCHAR(50)  NOT NULL,
    symbol        VARCHAR(5)   NOT NULL,
    PRIMARY KEY (currency_code)
    ) ENGINE=InnoDB COMMENT='ISO 4217 Currency codes';

-- ============================================================
-- CUSTOMER MANAGEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
                                         customer_id              BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                         customer_number          VARCHAR(20)       NOT NULL,
    keycloak_user_id         VARCHAR(50)       NULL     COMMENT 'Keycloak UUID sub claim - 36 chars standard UUID',
    first_name               VARCHAR(100)      NOT NULL,
    middle_name              VARCHAR(100)      NULL,
    last_name                VARCHAR(100)      NOT NULL,
    date_of_birth            DATE              NULL,
    gender                   ENUM('MALE','FEMALE','NON_BINARY','PREFER_NOT_TO_SAY') NULL,
    ssn_last4                CHAR(4)           NULL     COMMENT 'Last 4 digits only - never store full SSN',
    nationality              VARCHAR(60)       NULL,
    email                    VARCHAR(200)      NOT NULL,
    email_verified           TINYINT(1)        NOT NULL DEFAULT 0,
    phone                    VARCHAR(20)       NOT NULL,
    mobile_phone             VARCHAR(20)       NULL,
    two_factor_enabled       TINYINT(1)        NOT NULL DEFAULT 0,
    customer_type            ENUM('RETAIL','PREMIUM','PRIVATE_BANKING','STUDENT') NOT NULL DEFAULT 'RETAIL',
    kyc_status               ENUM('PENDING','VERIFIED','REJECTED','EXPIRED')      NOT NULL DEFAULT 'PENDING',
    kyc_verified_at          DATETIME          NULL,
    credit_score             SMALLINT UNSIGNED NULL     COMMENT 'FICO 300-850',
    credit_score_date        DATE              NULL,
    annual_income            DECIMAL(15,2)     NULL,
    employment_status        ENUM('EMPLOYED','SELF_EMPLOYED','RETIRED','STUDENT','UNEMPLOYED') NOT NULL DEFAULT 'EMPLOYED',
    employer                 VARCHAR(150)      NULL,
    occupation               VARCHAR(100)      NULL,
    preferred_contact_method ENUM('EMAIL','PHONE','SMS','MAIL') NULL,
    assigned_branch_id       INT UNSIGNED      NULL,
    assigned_banker_id       BIGINT UNSIGNED   NULL,
    is_active                TINYINT(1)        NOT NULL DEFAULT 1,
    created_at               DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id),
    UNIQUE KEY uk_customer_number    (customer_number),
    UNIQUE KEY uk_keycloak_user_id   (keycloak_user_id),
    UNIQUE KEY uk_customer_email     (email),
    INDEX idx_customer_type          (customer_type),
    INDEX idx_kyc_status             (kyc_status),
    INDEX idx_customer_active        (is_active)
    ) ENGINE=InnoDB COMMENT='Core customer registry';

CREATE TABLE IF NOT EXISTS customer_addresses (
                                                  address_id    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                                  customer_id   BIGINT UNSIGNED  NOT NULL,
                                                  address_type  ENUM('HOME','MAILING','WORK','OTHER') NOT NULL DEFAULT 'HOME',
    address_line1 VARCHAR(200)     NOT NULL,
    address_line2 VARCHAR(200)     NULL,
    city          VARCHAR(100)     NOT NULL,
    state_code    CHAR(2)          NOT NULL,
    postal_code   VARCHAR(10)      NOT NULL,
    country_code  CHAR(2)          NOT NULL DEFAULT 'US',
    is_primary    TINYINT(1)       NOT NULL DEFAULT 0,
    created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (address_id),
    INDEX idx_addr_customer (customer_id),
    CONSTRAINT fk_addr_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    ) ENGINE=InnoDB COMMENT='Customer addresses - multiple per customer';

CREATE TABLE IF NOT EXISTS customer_documents (
                                                  document_id         BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                                  customer_id         BIGINT UNSIGNED  NOT NULL,
                                                  document_type       ENUM('PASSPORT','DRIVERS_LICENSE','STATE_ID','NATIONAL_ID','SSN_CARD','TAX_ID','VISA') NOT NULL,
    document_number     VARCHAR(100)     NOT NULL,
    issuing_country     CHAR(2)          NULL,
    issue_date          DATE             NULL,
    expiration_date     DATE             NULL,
    verification_status ENUM('PENDING','VERIFIED','REJECTED','EXPIRED') NOT NULL DEFAULT 'PENDING',
    verified_at         DATETIME         NULL,
    created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (document_id),
    INDEX idx_doc_customer (customer_id),
    CONSTRAINT fk_doc_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    ) ENGINE=InnoDB COMMENT='Customer KYC document records';

-- ============================================================
-- BRANCHES & PRODUCT CATALOG
-- ============================================================

CREATE TABLE IF NOT EXISTS branches (
                                        branch_id    INT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                        branch_code  VARCHAR(15)    NOT NULL COMMENT 'Format: NBK-XXX-000 (11 chars max)',
    branch_name  VARCHAR(200)   NOT NULL,
    address_line1 VARCHAR(200)  NOT NULL,
    city         VARCHAR(100)   NOT NULL,
    state_code   CHAR(2)        NOT NULL,
    zip_code     VARCHAR(10)    NOT NULL,
    phone        VARCHAR(20)    NOT NULL,
    manager_name VARCHAR(200)   NULL,
    is_active    TINYINT(1)     NOT NULL DEFAULT 1,
    created_at   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (branch_id),
    UNIQUE KEY uk_branch_code (branch_code)
    ) ENGINE=InnoDB COMMENT='Bank branch locations';

CREATE TABLE IF NOT EXISTS account_products (
                                                product_id    INT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                                product_code  VARCHAR(30)    NOT NULL,
    product_name  VARCHAR(200)   NOT NULL,
    product_type  ENUM('CHECKING','SAVINGS','MONEY_MARKET','CD','IRA','BROKERAGE') NOT NULL,
    min_balance   DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    monthly_fee   DECIMAL(8,2)   NOT NULL DEFAULT 0.00,
    apy_rate      DECIMAL(6,4)   NULL,
    overdraft_limit DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    is_active     TINYINT(1)     NOT NULL DEFAULT 1,
    description   TEXT           NULL,
    created_at    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id),
    UNIQUE KEY uk_product_code (product_code)
    ) ENGINE=InnoDB COMMENT='Retail deposit product catalog';

-- ============================================================
-- ACCOUNTS
-- ============================================================

CREATE TABLE IF NOT EXISTS accounts (
                                        account_id              BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                        account_number          VARCHAR(20)      NOT NULL,
    routing_number          VARCHAR(9)       NOT NULL DEFAULT '071000013',
    nickname                VARCHAR(100)     NULL,
    customer_id             BIGINT UNSIGNED  NOT NULL,
    product_id              INT UNSIGNED     NOT NULL,
    branch_id               INT UNSIGNED     NULL,
    account_status          ENUM('PENDING_APPROVAL','ACTIVE','DORMANT','FROZEN','CLOSED') NOT NULL DEFAULT 'PENDING_APPROVAL',
    current_balance         DECIMAL(18,2)    NOT NULL DEFAULT 0.00,
    available_balance       DECIMAL(18,2)    NOT NULL DEFAULT 0.00,
    hold_amount             DECIMAL(14,2)    NOT NULL DEFAULT 0.00,
    currency_code           CHAR(3)          NOT NULL DEFAULT 'USD',
    overdraft_protection    TINYINT(1)       NOT NULL DEFAULT 0,
    overdraft_limit         DECIMAL(10,2)    NOT NULL DEFAULT 0.00,
    annual_percentage_yield DECIMAL(6,4)     NULL,
    opened_date             DATE             NOT NULL DEFAULT (CURRENT_DATE),
    closed_date             DATE             NULL,
    maturity_date           DATE             NULL     COMMENT 'CDs only',
    last_transaction_at     DATETIME         NULL,
    created_at              DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (account_id),
    UNIQUE KEY uk_account_number (account_number),
    INDEX idx_acct_customer      (customer_id),
    INDEX idx_acct_status        (account_status),
    INDEX idx_acct_product       (product_id),
    CONSTRAINT fk_acct_customer  FOREIGN KEY (customer_id) REFERENCES customers      (customer_id),
    CONSTRAINT fk_acct_product   FOREIGN KEY (product_id)  REFERENCES account_products (product_id),
    CONSTRAINT fk_acct_branch    FOREIGN KEY (branch_id)   REFERENCES branches       (branch_id)
    ) ENGINE=InnoDB COMMENT='Customer bank accounts';

CREATE TABLE IF NOT EXISTS account_beneficiaries (
                                                     beneficiary_id     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                                     account_id         BIGINT UNSIGNED  NOT NULL,
                                                     beneficiary_name   VARCHAR(200)     NOT NULL,
    relationship       VARCHAR(50)      NULL,
    allocation_percent DECIMAL(5,2)     NOT NULL DEFAULT 100.00,
    ssn_last4          CHAR(4)          NULL,
    is_primary         TINYINT(1)       NOT NULL DEFAULT 0,
    created_at         DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (beneficiary_id),
    INDEX idx_ben_account (account_id),
    CONSTRAINT fk_ben_account FOREIGN KEY (account_id) REFERENCES accounts (account_id)
    ) ENGINE=InnoDB COMMENT='Account beneficiaries for estate purposes';

-- ============================================================
-- TRANSACTIONS
-- ============================================================

CREATE TABLE IF NOT EXISTS transaction_categories (
                                                      category_id        INT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                                      category_code      VARCHAR(30)   NOT NULL,
    category_name      VARCHAR(100)  NOT NULL,
    parent_category_id INT UNSIGNED  NULL,
    icon_class         VARCHAR(50)   NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uk_cat_code (category_code),
    CONSTRAINT fk_cat_parent FOREIGN KEY (parent_category_id) REFERENCES transaction_categories (category_id)
    ) ENGINE=InnoDB COMMENT='Transaction category hierarchy';

CREATE TABLE IF NOT EXISTS transactions (
                                            transaction_id     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                            transaction_ref    VARCHAR(30)      NOT NULL,
    account_id         BIGINT UNSIGNED  NOT NULL,
    category_id        INT UNSIGNED     NULL,
    transaction_type   ENUM('DEBIT','CREDIT','TRANSFER','FEE','INTEREST','ADJUSTMENT','LOAN_PAYMENT','LOAN_DISBURSEMENT') NOT NULL,
    transaction_status ENUM('PENDING','POSTED','FAILED','REVERSED','HOLD') NOT NULL DEFAULT 'PENDING',
    channel            ENUM('ONLINE_BANKING','MOBILE','ATM','BRANCH','ACH','WIRE','CHECK','CARD') NOT NULL DEFAULT 'ONLINE_BANKING',
    amount             DECIMAL(18,2)    NOT NULL,
    balance_before     DECIMAL(18,2)    NULL,
    balance_after      DECIMAL(18,2)    NULL,
    currency_code      CHAR(3)          NOT NULL DEFAULT 'USD',
    description        VARCHAR(500)     NOT NULL,
    merchant_name      VARCHAR(200)     NULL,
    merchant_city      VARCHAR(100)     NULL,
    transaction_date   DATE             NOT NULL DEFAULT (CURRENT_DATE),
    posted_at          DATETIME         NULL,
    created_at         DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transaction_id),
    UNIQUE KEY uk_txn_ref        (transaction_ref),
    INDEX idx_txn_account        (account_id),
    INDEX idx_txn_type           (transaction_type),
    INDEX idx_txn_status         (transaction_status),
    INDEX idx_txn_date           (transaction_date),
    CONSTRAINT fk_txn_account    FOREIGN KEY (account_id)  REFERENCES accounts              (account_id),
    CONSTRAINT fk_txn_category   FOREIGN KEY (category_id) REFERENCES transaction_categories (category_id)
    ) ENGINE=InnoDB COMMENT='All financial transactions - append-only ledger';

-- ============================================================
-- CARDS
-- ============================================================

CREATE TABLE IF NOT EXISTS cards (
                                     card_id             BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                     card_number_masked  VARCHAR(20)      NOT NULL COMMENT 'XXXX-XXXX-XXXX-1234',
    card_token          VARCHAR(64)      NOT NULL COMMENT 'Tokenized card reference',
    account_id          BIGINT UNSIGNED  NOT NULL,
    customer_id         BIGINT UNSIGNED  NOT NULL,
    card_type           ENUM('DEBIT','CREDIT','PREPAID','VIRTUAL') NOT NULL,
    card_network        ENUM('VISA','MASTERCARD','AMEX','DISCOVER') NOT NULL DEFAULT 'VISA',
    card_status         ENUM('ACTIVE','BLOCKED','EXPIRED','CANCELLED','PENDING_ACTIVATION') NOT NULL DEFAULT 'PENDING_ACTIVATION',
    cardholder_name     VARCHAR(200)     NOT NULL,
    expiry_month        TINYINT UNSIGNED NOT NULL,
    expiry_year         SMALLINT UNSIGNED NOT NULL,
    daily_limit         DECIMAL(10,2)    NOT NULL DEFAULT 2500.00,
    monthly_limit       DECIMAL(12,2)    NOT NULL DEFAULT 15000.00,
    contactless_enabled TINYINT(1)       NOT NULL DEFAULT 1,
    online_enabled      TINYINT(1)       NOT NULL DEFAULT 1,
    issued_at           DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activated_at        DATETIME         NULL,
    blocked_at          DATETIME         NULL,
    block_reason        VARCHAR(200)     NULL,
    created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (card_id),
    UNIQUE KEY uk_card_token     (card_token),
    INDEX idx_card_account       (account_id),
    INDEX idx_card_customer      (customer_id),
    INDEX idx_card_status        (card_status),
    CONSTRAINT fk_card_account   FOREIGN KEY (account_id)  REFERENCES accounts   (account_id),
    CONSTRAINT fk_card_customer  FOREIGN KEY (customer_id) REFERENCES customers  (customer_id)
    ) ENGINE=InnoDB COMMENT='Payment cards - debit and credit';

-- ============================================================
-- LOAN PRODUCT CATALOG
-- ============================================================

CREATE TABLE IF NOT EXISTS loan_products (
                                             loan_product_id     INT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                             product_code        VARCHAR(30)    NOT NULL,
    product_name        VARCHAR(200)   NOT NULL,
    loan_type           ENUM('MORTGAGE','HOME_EQUITY_LOAN','HELOC','AUTO','STUDENT_UNDERGRADUATE','STUDENT_GRADUATE','STUDENT_REFINANCE','PERSONAL','PERSONAL_SECURED','BUSINESS','SBA') NOT NULL,
    min_amount          DECIMAL(15,2)  NOT NULL,
    max_amount          DECIMAL(15,2)  NOT NULL,
    min_term_months     SMALLINT UNSIGNED NOT NULL,
    max_term_months     SMALLINT UNSIGNED NOT NULL,
    base_rate           DECIMAL(6,4)   NOT NULL COMMENT 'Floor APR',
    max_rate            DECIMAL(6,4)   NOT NULL COMMENT 'Ceiling APR',
    rate_type           ENUM('FIXED','VARIABLE','HYBRID_ARM') NOT NULL DEFAULT 'FIXED',
    origination_fee_pct DECIMAL(5,4)   NOT NULL DEFAULT 0.0000,
    prepayment_penalty  TINYINT(1)     NOT NULL DEFAULT 0,
    description         TEXT           NULL,
    is_active           TINYINT(1)     NOT NULL DEFAULT 1,
    created_at          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (loan_product_id),
    UNIQUE KEY uk_loan_product_code (product_code),
    INDEX idx_lp_type               (loan_type)
    ) ENGINE=InnoDB COMMENT='Loan product catalog with terms and rates';

-- ============================================================
-- LOANS
-- ============================================================

CREATE TABLE IF NOT EXISTS loans (
                                     loan_id                  BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                     loan_number              VARCHAR(30)       NOT NULL,
    customer_id              BIGINT UNSIGNED   NOT NULL,
    loan_product_id          INT UNSIGNED      NOT NULL,
    disbursement_account_id  BIGINT UNSIGNED   NULL,
    payment_account_id       BIGINT UNSIGNED   NULL,
    branch_id                INT UNSIGNED      NULL,
    loan_type                ENUM('MORTGAGE','HOME_EQUITY_LOAN','HELOC','AUTO','STUDENT_UNDERGRADUATE','STUDENT_GRADUATE','STUDENT_REFINANCE','PERSONAL','PERSONAL_SECURED','BUSINESS','SBA') NOT NULL,
    loan_status              ENUM('APPLICATION','UNDERWRITING','APPROVED','DECLINED','CURRENT','DELINQUENT','DEFAULT','PAID_OFF','CHARGED_OFF','CANCELLED') NOT NULL DEFAULT 'APPLICATION',
    rate_type                ENUM('FIXED','VARIABLE','HYBRID_ARM','PRIME_PLUS') NOT NULL DEFAULT 'FIXED',
    application_date         DATE              NOT NULL DEFAULT (CURRENT_DATE),
    approval_date            DATE              NULL,
    origination_date         DATE              NULL,
    disbursement_date        DATE              NULL,
    maturity_date            DATE              NULL,
    original_amount          DECIMAL(14,2)     NOT NULL DEFAULT 0.00,
    outstanding_balance      DECIMAL(14,2)     NOT NULL DEFAULT 0.00,
    interest_rate            DECIMAL(7,4)      NOT NULL DEFAULT 0.0000,
    term_months              SMALLINT UNSIGNED NOT NULL DEFAULT 12,
    monthly_payment_amount   DECIMAL(12,2)     NOT NULL DEFAULT 0.00,
    next_payment_date        DATE              NULL,
    last_payment_date        DATE              NULL,
    last_payment_amount      DECIMAL(12,2)     NULL,
    total_paid               DECIMAL(14,2)     NOT NULL DEFAULT 0.00,
    total_interest_paid      DECIMAL(14,2)     NOT NULL DEFAULT 0.00,
    accrued_interest         DECIMAL(12,2)     NOT NULL DEFAULT 0.00,
    origination_fee          DECIMAL(10,2)     NOT NULL DEFAULT 0.00,
    late_fee_balance         DECIMAL(10,2)     NOT NULL DEFAULT 0.00,
    days_past_due            SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    delinquency_date         DATE              NULL,
    loan_officer             VARCHAR(150)      NULL,
    purpose                  VARCHAR(500)      NULL,
    notes                    TEXT              NULL,
    created_at               DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (loan_id),
    UNIQUE KEY uk_loan_number         (loan_number),
    INDEX idx_loan_customer           (customer_id),
    INDEX idx_loan_status             (loan_status),
    INDEX idx_loan_type               (loan_type),
    INDEX idx_loan_next_payment       (next_payment_date),
    CONSTRAINT fk_loan_customer       FOREIGN KEY (customer_id)            REFERENCES customers     (customer_id),
    CONSTRAINT fk_loan_product        FOREIGN KEY (loan_product_id)        REFERENCES loan_products (loan_product_id),
    CONSTRAINT fk_loan_disb_acct      FOREIGN KEY (disbursement_account_id) REFERENCES accounts    (account_id),
    CONSTRAINT fk_loan_pay_acct       FOREIGN KEY (payment_account_id)     REFERENCES accounts     (account_id),
    CONSTRAINT fk_loan_branch         FOREIGN KEY (branch_id)              REFERENCES branches     (branch_id)
    ) ENGINE=InnoDB COMMENT='All loan types - master loans table';

-- ============================================================
-- MORTGAGE DETAILS
-- ============================================================

CREATE TABLE IF NOT EXISTS mortgage_details (
                                                id                       BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                                loan_id                  BIGINT UNSIGNED   NOT NULL,
                                                property_address         VARCHAR(500)      NOT NULL,
    property_city            VARCHAR(100)      NULL,
    property_state_code      CHAR(2)           NULL,
    property_zip             VARCHAR(10)       NULL,
    property_type            ENUM('SINGLE_FAMILY','CONDO','TOWNHOUSE','MULTI_FAMILY','COOPERATIVE','MANUFACTURED') NOT NULL DEFAULT 'SINGLE_FAMILY',
    purchase_price           DECIMAL(14,2)     NULL,
    appraised_value          DECIMAL(14,2)     NULL,
    down_payment             DECIMAL(14,2)     NULL,
    ltv_ratio                DECIMAL(5,2)      NULL,
    pmi_required             TINYINT(1)        NOT NULL DEFAULT 0,
    pmi_monthly_premium      DECIMAL(8,2)      NULL,
    pmi_cancellation_date    DATE              NULL,
    escrow_required          TINYINT(1)        NOT NULL DEFAULT 0,
    escrow_balance           DECIMAL(10,2)     NULL,
    monthly_escrow_payment   DECIMAL(8,2)      NULL,
    annual_property_tax      DECIMAL(10,2)     NULL,
    annual_insurance_premium DECIMAL(10,2)     NULL,
    is_arm_loan              TINYINT(1)        NOT NULL DEFAULT 0,
    arm_initial_period_months SMALLINT UNSIGNED NULL,
    arm_adjustment_cap       DECIMAL(4,2)      NULL,
    arm_lifetime_cap         DECIMAL(4,2)      NULL,
    arm_index_rate           DECIMAL(6,4)      NULL,
    arm_margin               DECIMAL(6,4)      NULL,
    next_adjustment_date     DATE              NULL,
    flood_zone               TINYINT(1)        NULL,
    created_at               DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_mort_loan (loan_id),
    CONSTRAINT fk_mort_loan FOREIGN KEY (loan_id) REFERENCES loans (loan_id)
    ) ENGINE=InnoDB COMMENT='Mortgage-specific property and escrow details';

-- ============================================================
-- AUTO LOAN DETAILS
-- ============================================================

CREATE TABLE IF NOT EXISTS auto_loan_details (
                                                 id               BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                                 loan_id          BIGINT UNSIGNED   NOT NULL,
                                                 vin              VARCHAR(18)       NOT NULL COMMENT 'Standard VIN 17 chars; 18 allows regional variants',
    vehicle_year     SMALLINT UNSIGNED NOT NULL,
    vehicle_make     VARCHAR(50)       NOT NULL,
    vehicle_model    VARCHAR(80)       NOT NULL,
    vehicle_trim     VARCHAR(80)       NULL,
    vehicle_color    VARCHAR(40)       NULL,
    vehicle_mileage  INT UNSIGNED      NULL,
    is_new           TINYINT(1)        NOT NULL DEFAULT 1,
    purchase_price   DECIMAL(12,2)     NOT NULL,
    down_payment     DECIMAL(10,2)     NULL,
    trade_in_value   DECIMAL(10,2)     NULL,
    gap_insurance    TINYINT(1)        NOT NULL DEFAULT 0,
    gap_insurance_amount DECIMAL(8,2)  NULL,
    dealer_name      VARCHAR(150)      NULL,
    purchase_date    DATE              NULL,
    title_state      CHAR(2)           NULL,
    license_plate    VARCHAR(20)       NULL,
    created_at       DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_auto_loan (loan_id),
    UNIQUE KEY uk_vin       (vin),
    CONSTRAINT fk_auto_loan FOREIGN KEY (loan_id) REFERENCES loans (loan_id)
    ) ENGINE=InnoDB COMMENT='Auto loan vehicle collateral details';

-- ============================================================
-- STUDENT LOAN DETAILS
-- ============================================================

CREATE TABLE IF NOT EXISTS student_loan_details (
                                                    id                       BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                                    loan_id                  BIGINT UNSIGNED   NOT NULL,
                                                    institution_name         VARCHAR(200)      NOT NULL,
    ope_id                   VARCHAR(20)       NULL,
    degree_program           VARCHAR(150)      NULL,
    enrollment_status        VARCHAR(20)       NULL,
    expected_graduation      DATE              NULL,
    repayment_plan           ENUM('STANDARD','GRADUATED','EXTENDED','IBR','PAYE','SAVE','ICR','IN_SCHOOL') NOT NULL DEFAULT 'STANDARD',
    loan_servicer            VARCHAR(100)      NULL,
    federal_loan_type        VARCHAR(50)       NULL,
    in_school_deferment      TINYINT(1)        NOT NULL DEFAULT 0,
    deferment_end_date       DATE              NULL,
    grace_period_end         DATE              NULL,
    income_based_payment     DECIMAL(10,2)     NULL,
    public_service_eligible  TINYINT(1)        NOT NULL DEFAULT 0,
    qualifying_payments_made INT UNSIGNED      NULL,
    created_at               DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_student_loan (loan_id),
    CONSTRAINT fk_student_loan FOREIGN KEY (loan_id) REFERENCES loans (loan_id)
    ) ENGINE=InnoDB COMMENT='Student loan education and repayment details';

-- ============================================================
-- LOAN PAYMENT SCHEDULE
-- ============================================================

CREATE TABLE IF NOT EXISTS loan_payment_schedule (
                                                     id                  BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
                                                     loan_id             BIGINT UNSIGNED   NOT NULL,
                                                     payment_number      SMALLINT UNSIGNED NOT NULL,
                                                     due_date            DATE              NOT NULL,
                                                     scheduled_payment   DECIMAL(12,2)     NOT NULL,
    principal_amount    DECIMAL(12,2)     NOT NULL,
    interest_amount     DECIMAL(12,2)     NOT NULL,
    escrow_amount       DECIMAL(10,2)     NULL     DEFAULT 0.00,
    remaining_balance   DECIMAL(14,2)     NOT NULL,
    actual_payment_date DATE              NULL,
    actual_amount_paid  DECIMAL(12,2)     NULL,
    payment_status      ENUM('SCHEDULED','CURRENT','PAID','OVERDUE','WAIVED','DEFERRED') NOT NULL DEFAULT 'SCHEDULED',
    late_fee            DECIMAL(8,2)      NULL     DEFAULT 0.00,
    PRIMARY KEY (id),
    INDEX idx_sched_loan     (loan_id),
    INDEX idx_sched_due_date (due_date),
    INDEX idx_sched_status   (payment_status),
    CONSTRAINT fk_sched_loan FOREIGN KEY (loan_id) REFERENCES loans (loan_id)
    ) ENGINE=InnoDB COMMENT='Loan amortization schedule';

-- ============================================================
-- WIRE TRANSFERS & ACH
-- ============================================================

CREATE TABLE IF NOT EXISTS wire_transfers (
                                              wire_id              BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                              wire_reference       VARCHAR(30)      NOT NULL,
    source_account_id    BIGINT UNSIGNED  NOT NULL,
    transfer_type        ENUM('DOMESTIC_WIRE','INTERNATIONAL_WIRE','ACH_CREDIT','ACH_DEBIT','ZELLE','BILL_PAY') NOT NULL,
    transfer_status      ENUM('INITIATED','PENDING','PROCESSING','COMPLETED','FAILED','CANCELLED','RETURNED') NOT NULL DEFAULT 'INITIATED',
    amount               DECIMAL(18,2)    NOT NULL,
    fee_amount           DECIMAL(8,2)     NOT NULL DEFAULT 0.00,
    currency_code        CHAR(3)          NOT NULL DEFAULT 'USD',
    beneficiary_name     VARCHAR(200)     NOT NULL,
    beneficiary_account  VARCHAR(50)      NOT NULL,
    beneficiary_bank     VARCHAR(200)     NULL,
    beneficiary_routing  VARCHAR(11)      NULL,
    beneficiary_address  VARCHAR(500)     NULL,
    swift_code           VARCHAR(11)      NULL,
    iban                 VARCHAR(34)      NULL,
    purpose_code         VARCHAR(10)      NULL,
    memo                 VARCHAR(500)     NULL,
    scheduled_date       DATE             NOT NULL,
    executed_at          DATETIME         NULL,
    created_at           DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (wire_id),
    UNIQUE KEY uk_wire_ref    (wire_reference),
    INDEX idx_wire_source     (source_account_id),
    INDEX idx_wire_status     (transfer_status),
    CONSTRAINT fk_wire_source FOREIGN KEY (source_account_id) REFERENCES accounts (account_id)
    ) ENGINE=InnoDB COMMENT='Wire transfers and ACH transactions';

-- ============================================================
-- CUSTOMER ALERTS
-- ============================================================

CREATE TABLE IF NOT EXISTS customer_alerts (
                                               alert_id    BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                               customer_id BIGINT UNSIGNED  NOT NULL,
                                               alert_type  ENUM('LOW_BALANCE','LARGE_TRANSACTION','PAYMENT_DUE','PAYMENT_OVERDUE','SECURITY','KYC_EXPIRY','STATEMENT_READY','GENERAL') NOT NULL,
    message     VARCHAR(500)     NOT NULL,
    is_read     TINYINT(1)       NOT NULL DEFAULT 0,
    created_at  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (alert_id),
    INDEX idx_alert_customer (customer_id),
    INDEX idx_alert_unread   (customer_id, is_read),
    CONSTRAINT fk_alert_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
    ) ENGINE=InnoDB COMMENT='Customer notifications and alerts';

-- ============================================================
-- AUDIT LOG
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_log (
                                         audit_id     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
                                         entity_type  VARCHAR(50)      NOT NULL,
    entity_id    VARCHAR(50)      NOT NULL,
    action       ENUM('CREATE','UPDATE','DELETE','VIEW','LOGIN','LOGOUT','EXPORT','ADMIN_OVERRIDE') NOT NULL,
    performed_by VARCHAR(100)     NOT NULL COMMENT 'Keycloak username',
    ip_address   VARCHAR(45)      NULL,
    old_values   JSON             NULL,
    new_values   JSON             NULL,
    description  VARCHAR(500)     NULL,
    created_at   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (audit_id),
    INDEX idx_audit_entity  (entity_type, entity_id),
    INDEX idx_audit_user    (performed_by),
    INDEX idx_audit_created (created_at)
    ) ENGINE=InnoDB COMMENT='Immutable audit trail';