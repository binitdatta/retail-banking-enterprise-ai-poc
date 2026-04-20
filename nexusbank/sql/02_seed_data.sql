-- ============================================================
-- NexusBank Platform - Seed Data
-- Run AFTER 01_schema_ddl.sql
-- ============================================================

USE nexusbank_db;

-- ── Reference Data ─────────────────────────────────────────

INSERT INTO currencies (currency_code, currency_name, symbol) VALUES
                                                                  ('USD', 'US Dollar',       '$'),
                                                                  ('EUR', 'Euro',             '€'),
                                                                  ('GBP', 'British Pound',   '£'),
                                                                  ('CAD', 'Canadian Dollar', 'CA$'),
                                                                  ('MXN', 'Mexican Peso',    'MX$');

INSERT INTO states (state_code, state_name) VALUES
                                                ('AL','Alabama'),     ('AK','Alaska'),        ('AZ','Arizona'),      ('AR','Arkansas'),
                                                ('CA','California'),  ('CO','Colorado'),       ('CT','Connecticut'),   ('DE','Delaware'),
                                                ('FL','Florida'),     ('GA','Georgia'),        ('HI','Hawaii'),       ('ID','Idaho'),
                                                ('IL','Illinois'),    ('IN','Indiana'),        ('IA','Iowa'),         ('KS','Kansas'),
                                                ('KY','Kentucky'),    ('LA','Louisiana'),      ('ME','Maine'),        ('MD','Maryland'),
                                                ('MA','Massachusetts'),('MI','Michigan'),      ('MN','Minnesota'),    ('MS','Mississippi'),
                                                ('MO','Missouri'),    ('MT','Montana'),        ('NE','Nebraska'),     ('NV','Nevada'),
                                                ('NH','New Hampshire'),('NJ','New Jersey'),    ('NM','New Mexico'),   ('NY','New York'),
                                                ('NC','North Carolina'),('ND','North Dakota'), ('OH','Ohio'),         ('OK','Oklahoma'),
                                                ('OR','Oregon'),      ('PA','Pennsylvania'),   ('RI','Rhode Island'), ('SC','South Carolina'),
                                                ('SD','South Dakota'),('TN','Tennessee'),      ('TX','Texas'),        ('UT','Utah'),
                                                ('VT','Vermont'),     ('VA','Virginia'),       ('WA','Washington'),   ('WV','West Virginia'),
                                                ('WI','Wisconsin'),   ('WY','Wyoming');

-- ── Branches ───────────────────────────────────────────────
-- branch_code is VARCHAR(15); values below are 11 chars

INSERT INTO branches (branch_code, branch_name, address_line1, city, state_code, zip_code, phone, manager_name) VALUES
                                                                                                                    ('NBK-CHI-001', 'NexusBank Chicago Loop',           '222 W Adams St',         'Chicago',     'IL', '60606', '(312) 555-0101', 'Patricia Callahan'),
                                                                                                                    ('NBK-NYC-001', 'NexusBank Manhattan Flagship',      '350 Fifth Ave Ste 8000', 'New York',    'NY', '10118', '(212) 555-0102', 'Marcus Wellington'),
                                                                                                                    ('NBK-LAX-001', 'NexusBank Century City',            '2000 Avenue of Stars',   'Los Angeles', 'CA', '90067', '(310) 555-0103', 'Sophia Nakamura'),
                                                                                                                    ('NBK-HOU-001', 'NexusBank Houston Energy Corridor', '1800 W Sam Houston Pkwy','Houston',     'TX', '77042', '(713) 555-0104', 'Diego Ramirez'),
                                                                                                                    ('NBK-PHX-001', 'NexusBank Scottsdale Quarter',      '15169 N Scottsdale Rd',  'Scottsdale',  'AZ', '85254', '(480) 555-0105', 'Jennifer Okafor'),
                                                                                                                    ('NBK-MIA-001', 'NexusBank Brickell',                '1450 Brickell Ave',      'Miami',       'FL', '33131', '(305) 555-0106', 'Carlos Mendez');

-- ── Account Products ───────────────────────────────────────

INSERT INTO account_products (product_code, product_name, product_type, min_balance, monthly_fee, apy_rate, overdraft_limit, description) VALUES
                                                                                                                                              ('CHK-ESSENTIAL',  'Essential Checking',      'CHECKING',      0.00,      0.00, 0.0000,  500.00, 'Fee-free everyday checking with no minimum balance'),
                                                                                                                                              ('CHK-ADVANTAGE',  'Advantage Checking',      'CHECKING',    500.00,     12.00, 0.0100, 1000.00, 'Premium checking with interest and ATM fee rebates'),
                                                                                                                                              ('CHK-NEXUS360',   'Nexus 360 Checking',      'CHECKING',   5000.00,      0.00, 0.0150, 2500.00, 'High-yield checking for balances over $5k, fee waived'),
                                                                                                                                              ('SAV-STANDARD',   'Standard Savings',        'SAVINGS',      25.00,      5.00, 0.0430,    0.00, 'FDIC-insured savings at 4.30% APY'),
                                                                                                                                              ('SAV-HIGH-YIELD', 'High-Yield Savings',      'SAVINGS',    1000.00,      0.00, 0.0510,    0.00, 'Earn 5.10% APY up to $250k'),
                                                                                                                                              ('SAV-NEXUSGROW',  'NexusGrow Savings',       'SAVINGS',    2500.00,      0.00, 0.0525,    0.00, 'Tiered rate savings 5.25% on balances $2,500+'),
                                                                                                                                              ('MM-PREMIER',     'Premier Money Market',    'MONEY_MARKET',2500.00,     10.00, 0.0490,   0.00, 'Check-writing money market 4.90% APY'),
                                                                                                                                              ('MM-BUSINESS',    'Business Money Market',   'MONEY_MARKET',10000.00,    0.00, 0.0505,    0.00, 'Business sweep account 5.05% APY'),
                                                                                                                                              ('CD-6MO',         '6-Month CD',              'CD',          1000.00,      0.00, 0.0525,    0.00, '6-month certificate of deposit 5.25% APY'),
                                                                                                                                              ('CD-12MO',        '12-Month CD',             'CD',          1000.00,      0.00, 0.0540,    0.00, '12-month CD 5.40% APY'),
                                                                                                                                              ('CD-24MO',        '24-Month CD',             'CD',          2500.00,      0.00, 0.0520,    0.00, '24-month CD 5.20% APY'),
                                                                                                                                              ('IRA-TRAD',       'Traditional IRA',         'IRA',          500.00,      0.00, 0.0480,    0.00, 'Tax-deferred traditional IRA savings account'),
                                                                                                                                              ('IRA-ROTH',       'Roth IRA Savings',        'IRA',          500.00,      0.00, 0.0480,    0.00, 'After-tax Roth IRA for tax-free growth');

-- ── Transaction Categories ──────────────────────────────────
-- Column is parent_category_id (not parent_id)

INSERT INTO transaction_categories (category_id, category_code, category_name, parent_category_id, icon_class) VALUES
                                                                                                                   ( 1, 'INCOME',        'Income',                NULL, 'bi-graph-up-arrow'),
                                                                                                                   ( 2, 'SALARY',        'Salary/Payroll',            1, 'bi-briefcase'),
                                                                                                                   ( 3, 'INVESTMENT',    'Investment Returns',         1, 'bi-currency-exchange'),
                                                                                                                   ( 4, 'TRANSFER_IN',   'Incoming Transfer',          1, 'bi-arrow-down-circle'),
                                                                                                                   ( 5, 'EXPENSE',       'Expense',               NULL, 'bi-graph-down-arrow'),
                                                                                                                   ( 6, 'HOUSING',       'Housing',                   5, 'bi-house'),
                                                                                                                   ( 7, 'MORTGAGE_PMT',  'Mortgage Payment',           6, 'bi-building'),
                                                                                                                   ( 8, 'RENT',          'Rent',                       6, 'bi-door-open'),
                                                                                                                   ( 9, 'UTILITIES',     'Utilities',                  5, 'bi-lightning-charge'),
                                                                                                                   (10, 'FOOD',          'Food & Dining',              5, 'bi-cup-hot'),
                                                                                                                   (11, 'GROCERIES',     'Groceries',                 10, 'bi-cart'),
                                                                                                                   (12, 'RESTAURANTS',   'Restaurants',               10, 'bi-shop'),
                                                                                                                   (13, 'TRANSPORT',     'Transportation',             5, 'bi-car-front'),
                                                                                                                   (14, 'AUTO_LOAN_PMT', 'Auto Loan Payment',         13, 'bi-speedometer2'),
                                                                                                                   (15, 'GAS',           'Gas & Fuel',                13, 'bi-fuel-pump'),
                                                                                                                   (16, 'HEALTHCARE',    'Healthcare',                 5, 'bi-heart-pulse'),
                                                                                                                   (17, 'EDUCATION',     'Education',                  5, 'bi-mortarboard'),
                                                                                                                   (18, 'STU_LOAN_PMT',  'Student Loan Payment',      17, 'bi-book'),
                                                                                                                   (19, 'ENTERTAINMENT', 'Entertainment',              5, 'bi-play-circle'),
                                                                                                                   (20, 'SHOPPING',      'Shopping',                   5, 'bi-bag'),
                                                                                                                   (21, 'FEES',          'Bank Fees',             NULL, 'bi-exclamation-circle'),
                                                                                                                   (22, 'ATM',           'ATM Withdrawal',         NULL, 'bi-cash-stack'),
                                                                                                                   (23, 'LOAN',          'Loan',                   NULL, 'bi-bank'),
                                                                                                                   (24, 'LOAN_DISB',     'Loan Disbursement',         23, 'bi-cash-coin'),
                                                                                                                   (25, 'LOAN_PMT',      'Loan Payment',              23, 'bi-arrow-up-circle');

-- ── Loan Products ──────────────────────────────────────────

INSERT INTO loan_products (product_code, product_name, loan_type, min_amount, max_amount, min_term_months, max_term_months, base_rate, max_rate, rate_type, origination_fee_pct, description) VALUES
                                                                                                                                                                                                  ('MORT-30-FIX',   '30-Year Fixed Mortgage',             'MORTGAGE',               100000.00, 3000000.00, 360, 360, 0.0685, 0.0895, 'FIXED',      0.0100, 'Traditional 30-year fixed-rate home purchase mortgage'),
                                                                                                                                                                                                  ('MORT-15-FIX',   '15-Year Fixed Mortgage',             'MORTGAGE',               100000.00, 2000000.00, 180, 180, 0.0635, 0.0835, 'FIXED',      0.0100, 'Build equity faster with 15-year fixed rate'),
                                                                                                                                                                                                  ('MORT-7-1-ARM',  '7/1 ARM Mortgage',                   'MORTGAGE',               150000.00, 2500000.00, 360, 360, 0.0625, 0.0825, 'HYBRID_ARM', 0.0075, 'Fixed 7 years then annual adjustments'),
                                                                                                                                                                                                  ('MORT-5-1-ARM',  '5/1 ARM Mortgage',                   'MORTGAGE',               150000.00, 2000000.00, 360, 360, 0.0605, 0.0805, 'HYBRID_ARM', 0.0075, 'Fixed 5 years then adjusts annually'),
                                                                                                                                                                                                  ('HELOC-VAR',     'Home Equity Line of Credit',         'HELOC',                   25000.00,  500000.00,  60, 120, 0.0890, 0.1200, 'VARIABLE',   0.0000, 'Draw as needed up to credit limit, SOFR + margin'),
                                                                                                                                                                                                  ('HE-LOAN',       'Home Equity Loan',                   'HOME_EQUITY_LOAN',        25000.00,  400000.00,  60, 180, 0.0750, 0.0990, 'FIXED',      0.0050, 'Lump-sum fixed-rate second mortgage'),
                                                                                                                                                                                                  ('AUTO-NEW',      'New Vehicle Loan',                   'AUTO',                     7500.00,  100000.00,  24,  84, 0.0599, 0.1299, 'FIXED',      0.0000, 'Finance a new vehicle up to 84 months'),
                                                                                                                                                                                                  ('AUTO-USED',     'Used Vehicle Loan',                  'AUTO',                     5000.00,   75000.00,  24,  72, 0.0699, 0.1499, 'FIXED',      0.0000, 'Finance a pre-owned vehicle up to 72 months'),
                                                                                                                                                                                                  ('AUTO-REFI',     'Auto Refinance',                     'AUTO',                     5000.00,   75000.00,  24,  72, 0.0649, 0.1299, 'FIXED',      0.0000, 'Refinance an existing auto loan at a better rate'),
                                                                                                                                                                                                  ('STU-UG-PRIV',   'Undergraduate Private Student Loan', 'STUDENT_UNDERGRADUATE',    1000.00,  100000.00,  60, 120, 0.0499, 0.1299, 'FIXED',      0.0100, 'Private undergraduate student financing'),
                                                                                                                                                                                                  ('STU-GRAD-PRIV', 'Graduate Private Student Loan',      'STUDENT_GRADUATE',         1000.00,  150000.00,  60, 180, 0.0549, 0.1199, 'FIXED',      0.0100, 'Graduate and professional school financing'),
                                                                                                                                                                                                  ('STU-REFI',      'Student Loan Refinance',             'STUDENT_REFINANCE',        5000.00,  250000.00,  60, 180, 0.0479, 0.1099, 'FIXED',      0.0000, 'Refinance federal or private student loans'),
                                                                                                                                                                                                  ('PERS-UNSEC',    'Personal Loan - Unsecured',          'PERSONAL',                 1000.00,   50000.00,  12,  84, 0.0899, 0.2599, 'FIXED',      0.0200, 'No-collateral personal loan for any purpose'),
                                                                                                                                                                                                  ('PERS-SECURED',  'Personal Loan - Secured',            'PERSONAL_SECURED',         2500.00,   75000.00,  12,  84, 0.0699, 0.1599, 'FIXED',      0.0150, 'CD or savings-secured personal loan');

-- ── Customers ──────────────────────────────────────────────
-- keycloak_user_id is VARCHAR(50); placeholder values are 42 chars
-- Replace with real Keycloak UUIDs (36 chars) after realm setup

INSERT INTO customers
(customer_number, keycloak_user_id, first_name, middle_name, last_name,
 date_of_birth, ssn_last4, email, email_verified,
 phone, mobile_phone, customer_type, kyc_status, kyc_verified_at,
 credit_score, credit_score_date, annual_income,
 employment_status, employer, occupation, two_factor_enabled)
VALUES
    ('NBK-0000000001', 'kcuid-00000001-0000-0000-0000-000000000001',
     'James',   'Robert',    'Harrington',    '1978-04-12', '4521',
     'james.harrington@email.com',   1, '(312) 555-2001', NULL,
     'PREMIUM',        'VERIFIED', '2024-01-15 10:00:00',
     780, '2025-01-15', 185000.00, 'EMPLOYED',      'Goldman Sachs & Co',          'Managing Director',   1),

    ('NBK-0000000002', 'kcuid-00000002-0000-0000-0000-000000000002',
     'Priya',   'Ananya',    'Krishnamurthy', '1985-09-28', '7834',
     'priya.krishnamurthy@email.com', 1, '(408) 555-2002', '(408) 555-2022',
     'RETAIL',         'VERIFIED', '2024-02-20 14:30:00',
     740, '2025-02-20', 142000.00, 'EMPLOYED',      'Apple Inc',                   'Senior Engineer',     0),

    ('NBK-0000000003', 'kcuid-00000003-0000-0000-0000-000000000003',
     'Marcus',  'DeShawn',   'Williams',      '1990-11-03', '2967',
     'marcus.williams@email.com',     1, '(713) 555-2003', NULL,
     'RETAIL',         'VERIFIED', '2024-03-05 09:15:00',
     695, '2025-03-05',  78000.00, 'EMPLOYED',      'Chevron Corporation',          'Project Manager',     0),

    ('NBK-0000000004', 'kcuid-00000004-0000-0000-0000-000000000004',
     'Sofia',   'Isabella',  'Delgado',       '1993-06-17', '1122',
     'sofia.delgado@email.com',       1, '(305) 555-2004', '(305) 555-2044',
     'RETAIL',         'VERIFIED', '2024-01-28 11:45:00',
     725, '2025-01-28',  95000.00, 'EMPLOYED',      'Carnival Corporation',         'Marketing Manager',   0),

    ('NBK-0000000005', 'kcuid-00000005-0000-0000-0000-000000000005',
     'Ethan',   NULL,        'Thornton',      '1968-02-22', '8843',
     'ethan.thornton@email.com',      1, '(212) 555-2005', NULL,
     'PRIVATE_BANKING', 'VERIFIED', '2023-11-10 16:00:00',
     820, '2024-11-10', 650000.00, 'SELF_EMPLOYED', 'Thornton Capital Partners',    'Managing Partner',    1),

    ('NBK-0000000006', 'kcuid-00000006-0000-0000-0000-000000000006',
     'Aisha',   'Femi',      'Okonkwo',       '2001-08-14', '3357',
     'aisha.okonkwo@email.com',       1, '(773) 555-2006', '(773) 555-2066',
     'STUDENT',        'VERIFIED', '2024-04-01 13:20:00',
     650, '2025-04-01',  18000.00, 'EMPLOYED',      'University of Chicago',        'Research Assistant',  0),

    ('NBK-0000000007', 'kcuid-00000007-0000-0000-0000-000000000007',
     'Chen',    'Wei',       'Zhang',         '1982-12-30', '9901',
     'chen.zhang@email.com',          1, '(626) 555-2007', NULL,
     'PREMIUM',        'VERIFIED', '2024-02-14 08:30:00',
     795, '2025-02-14', 220000.00, 'SELF_EMPLOYED', 'Zhang Technology Ventures',    'Founder & CEO',       1),

    ('NBK-0000000008', 'kcuid-00000008-0000-0000-0000-000000000008',
     'Rebecca', 'Lynn',      'Stafford',      '1975-07-08', '6678',
     'rebecca.stafford@email.com',    1, '(480) 555-2008', '(480) 555-2088',
     'RETAIL',         'VERIFIED', '2024-03-18 15:10:00',
     710, '2025-03-18', 110000.00, 'EMPLOYED',      'Banner Health',                'Nurse Practitioner',  0),

    ('NBK-0000000009', 'kcuid-00000009-0000-0000-0000-000000000009',
     'Tyler',   'James',     'Beaumont',      '2000-03-25', '4410',
     'tyler.beaumont@email.com',      1, '(504) 555-2009', NULL,
     'STUDENT',        'VERIFIED', '2024-05-10 10:45:00',
     620, '2025-05-10',  15000.00, 'EMPLOYED',      'Tulane University',            'Teaching Assistant',  0),

    ('NBK-0000000010', 'kcuid-00000010-0000-0000-0000-000000000010',
     'Fatima',  'Zahra',     'Al-Hassan',     '1988-01-19', '7723',
     'fatima.alhassan@email.com',     1, '(214) 555-2010', NULL,
     'RETAIL',         'VERIFIED', '2024-01-05 09:00:00',
     755, '2025-01-05', 130000.00, 'EMPLOYED',      'AT&T Inc',                     'Senior Analyst',      0);

-- ── Customer Addresses ─────────────────────────────────────

INSERT INTO customer_addresses
(customer_id, address_type, address_line1, address_line2, city, state_code, postal_code, is_primary)
VALUES
    ( 1, 'HOME',    '2401 N Lakeview Ave',  'Unit 3402', 'Chicago',     'IL', '60614', 1),
    ( 1, 'WORK',    '200 West St',          NULL,         'New York',    'NY', '10282', 0),
    ( 2, 'HOME',    '1 Infinite Loop',      'Apt 42',     'Cupertino',   'CA', '95014', 1),
    ( 3, 'HOME',    '4500 Post Oak Pkwy',   'Suite 100',  'Houston',     'TX', '77027', 1),
    ( 4, 'HOME',    '300 S Biscayne Blvd',  'Apt 2801',   'Miami',       'FL', '33131', 1),
    ( 5, 'HOME',    '740 Park Ave',         'Apt 15C',    'New York',    'NY', '10021', 1),
    ( 5, 'MAILING', 'PO Box 2288',          NULL,         'Greenwich',   'CT', '06831', 0),
    ( 6, 'HOME',    '5757 S University Ave','Apt 2B',     'Chicago',     'IL', '60637', 1),
    ( 7, 'HOME',    '888 Arcadia Ave',      NULL,         'Arcadia',     'CA', '91007', 1),
    ( 8, 'HOME',    '8800 E Pinnacle Peak', 'Suite 200',  'Scottsdale',  'AZ', '85255', 1),
    ( 9, 'HOME',    '7001 Freret St',       'Apt 101',    'New Orleans', 'LA', '70118', 1),
    (10, 'HOME',    '5555 Lovers Ln',       'Unit 204',   'Dallas',      'TX', '75209', 1);

-- ── Accounts ───────────────────────────────────────────────

INSERT INTO accounts
(account_number, customer_id, product_id, branch_id, account_status,
 current_balance, available_balance, overdraft_protection, overdraft_limit,
 annual_percentage_yield, opened_date)
VALUES
-- James Harrington (customer 1) - Premium: checking, high-yield savings, 12-month CD
('400000000010011', 1,  3, 1, 'ACTIVE',  28450.00,  28450.00, 1, 2500.00, 0.0150, '2018-06-01'),
('400000000010012', 1,  5, 1, 'ACTIVE',  95000.00,  95000.00, 0,    0.00, 0.0510, '2018-06-01'),
('400000000010013', 1, 10, 1, 'ACTIVE',  50000.00,  50000.00, 0,    0.00, 0.0540, '2022-01-15'),
-- Priya Krishnamurthy (customer 2) - essential checking, standard savings
('400000000020021', 2,  1, 3, 'ACTIVE',  12340.50,  12340.50, 1,  500.00,   NULL, '2020-03-15'),
('400000000020022', 2,  4, 3, 'ACTIVE',  31500.00,  31500.00, 0,    0.00, 0.0430, '2020-03-15'),
-- Marcus Williams (customer 3) - essential checking, standard savings
('400000000030031', 3,  1, 4, 'ACTIVE',   4280.75,   4280.75, 1,  500.00,   NULL, '2019-11-20'),
('400000000030032', 3,  4, 4, 'ACTIVE',   8950.00,   8950.00, 0,    0.00, 0.0430, '2019-11-20'),
-- Sofia Delgado (customer 4) - advantage checking, standard savings
('400000000040041', 4,  2, 6, 'ACTIVE',   7820.25,   7820.25, 1, 1000.00, 0.0100, '2021-08-10'),
('400000000040042', 4,  4, 6, 'ACTIVE',  22400.00,  22400.00, 0,    0.00, 0.0430, '2021-08-10'),
-- Ethan Thornton (customer 5) - Private Banking: nexus360, nexusgrow, business MM
('400000000050051', 5,  3, 2, 'ACTIVE', 185000.00, 185000.00, 1, 2500.00, 0.0150, '2015-02-28'),
('400000000050052', 5,  6, 2, 'ACTIVE', 425000.00, 425000.00, 0,    0.00, 0.0525, '2015-02-28'),
('400000000050053', 5,  8, 2, 'ACTIVE', 750000.00, 750000.00, 0,    0.00, 0.0505, '2015-02-28'),
-- Aisha Okonkwo (customer 6) - Student: essential checking, standard savings
('400000000060061', 6,  1, 1, 'ACTIVE',   1850.00,   1850.00, 0,    0.00,   NULL, '2022-08-20'),
('400000000060062', 6,  4, 1, 'ACTIVE',   3200.00,   3200.00, 0,    0.00, 0.0430, '2022-08-20'),
-- Chen Zhang (customer 7) - Premium: nexus360, high-yield savings
('400000000070071', 7,  3, 3, 'ACTIVE',  42600.00,  42600.00, 1, 2500.00, 0.0150, '2017-05-10'),
('400000000070072', 7,  5, 3, 'ACTIVE', 130000.00, 130000.00, 0,    0.00, 0.0510, '2017-05-10'),
-- Rebecca Stafford (customer 8) - advantage checking, standard savings
('400000000080081', 8,  2, 5, 'ACTIVE',   9340.00,   9340.00, 1, 1000.00, 0.0100, '2020-07-14'),
('400000000080082', 8,  4, 5, 'ACTIVE',  28700.00,  28700.00, 0,    0.00, 0.0430, '2020-07-14'),
-- Tyler Beaumont (customer 9) - Student: essential checking
('400000000090091', 9,  1, 6, 'ACTIVE',    950.25,    950.25, 0,    0.00,   NULL, '2021-08-15'),
-- Fatima Al-Hassan (customer 10) - advantage checking, standard savings
('400000001000101',10,  2, 4, 'ACTIVE',  18500.00,  18500.00, 1, 1000.00, 0.0100, '2019-09-01'),
('400000001000102',10,  4, 4, 'ACTIVE',  45200.00,  45200.00, 0,    0.00, 0.0430, '2019-09-01');

-- ── Loans ──────────────────────────────────────────────────
-- account IDs: disbursement/payment use the customer's primary checking account
-- account_id mapping: 1=JH-chk, 4=PK-chk, 6=MW-chk, 8=SD-chk, 10=ET-chk,
--                    13=AO-chk, 15=CZ-chk, 17=RS-chk, 19=TB-chk, 20=FA-chk

INSERT INTO loans
(loan_number, customer_id, loan_product_id,
 disbursement_account_id, payment_account_id, branch_id,
 loan_type, loan_status, application_date, approval_date,
 origination_date, maturity_date,
 original_amount, outstanding_balance, interest_rate, rate_type,
 term_months, monthly_payment_amount,
 next_payment_date, last_payment_date, last_payment_amount,
 total_paid, total_interest_paid, origination_fee,
 loan_officer, purpose)
VALUES
-- loan_id 1: James Harrington - 30-year mortgage
('LN-MORT-20180615001',  1,  1,  1,  1, 1,
 'MORTGAGE',           'CURRENT',
 '2018-05-15', '2018-06-01', '2018-06-15', '2048-07-01',
 680000.00, 624318.52, 0.0425, 'FIXED', 360,  3351.74,
 '2026-05-01', '2026-04-01',  3351.74,  29018.94,  18012.55,  6800.00,
 'Andrew Colletti',   'Primary residence - Lincoln Park Chicago'),

-- loan_id 2: Priya Krishnamurthy - new auto loan (Tesla Model Y)
('LN-AUTO-20221015001',  2,  7,  4,  4, 3,
 'AUTO',                'CURRENT',
 '2022-09-28', '2022-10-10', '2022-10-15', '2027-10-15',
 58500.00,  41280.15, 0.0499, 'FIXED',  60,  1101.98,
 '2026-05-15', '2026-04-15',  1101.98,  40239.54,   5939.54,     0.00,
 'Lisa Park',          'New Tesla Model Y - Cupertino CA'),

-- loan_id 3: Marcus Williams - unsecured personal loan
('LN-PERS-20230301001',  3, 13,  6,  6, 4,
 'PERSONAL',            'CURRENT',
 '2023-02-15', '2023-02-28', '2023-03-01', '2026-03-01',
 20000.00,  12441.80, 0.1199, 'FIXED',  36,   664.29,
 '2026-05-01', '2026-04-01',   664.29,  16420.95,   2420.95,   400.00,
 'Carmen Reyes',       'Home renovation - kitchen and bathrooms'),

-- loan_id 4: Sofia Delgado - used auto loan (Honda CR-V)
('LN-AUTO-20231101001',  4,  8,  8,  8, 6,
 'AUTO',                'CURRENT',
 '2023-10-20', '2023-11-01', '2023-11-01', '2028-11-01',
 28900.00,  24380.54, 0.0799, 'FIXED',  60,   585.92,
 '2026-05-01', '2026-04-01',   585.92,   8785.39,   2075.39,     0.00,
 'Jose Fuentes',       'Used 2021 Honda CR-V - Miami FL'),

-- loan_id 5: Ethan Thornton - jumbo 15-year mortgage
('LN-MORT-20150401001',  5,  2, 10, 10, 2,
 'MORTGAGE',           'CURRENT',
 '2015-02-01', '2015-03-15', '2015-04-01', '2030-04-01',
 1800000.00, 1108293.18, 0.0375, 'FIXED', 180, 13104.52,
 '2026-05-01', '2026-04-01', 13104.52, 391572.60, 107572.60, 18000.00,
 'Victoria Marsh',     'Primary residence - Upper East Side NY'),

-- loan_id 6: Ethan Thornton - home equity loan
('LN-HEQT-20200601001',  5,  6, 10, 10, 2,
 'HOME_EQUITY_LOAN',   'CURRENT',
 '2020-05-01', '2020-05-25', '2020-06-01', '2035-06-01',
 250000.00,  188500.00, 0.0785, 'FIXED', 180,  2369.96,
 '2026-05-01', '2026-04-01',  2369.96, 146996.80,  28996.80,  1250.00,
 'Victoria Marsh',     'Investment property renovation fund'),

-- loan_id 7: Aisha Okonkwo - undergraduate student loan (UChicago)
('LN-STUD-20220901001',  6, 10, 13, 13, 1,
 'STUDENT_UNDERGRADUATE', 'CURRENT',
 '2022-07-20', '2022-08-15', '2022-09-01', '2032-09-01',
 45000.00,  39288.46, 0.0549, 'FIXED', 120,   487.07,
 '2026-05-01', '2026-04-01',   487.07,   3396.49,   1696.49,   450.00,
 'Diana Nwosu',        'University of Chicago - Computer Science BS'),

-- loan_id 8: Chen Zhang - 15-year mortgage (Arcadia CA)
('LN-MORT-20170601001',  7,  2, 15, 15, 3,
 'MORTGAGE',           'CURRENT',
 '2017-04-20', '2017-05-15', '2017-06-01', '2032-06-01',
 520000.00,  269184.72, 0.0395, 'FIXED', 180,  3842.40,
 '2026-05-01', '2026-04-01',  3842.40, 423104.64,  77104.64,  5200.00,
 'Robert Kim',         'Primary residence - Arcadia CA'),

-- loan_id 9: Rebecca Stafford - new auto loan (Ford Explorer)
('LN-AUTO-20210801001',  8,  7, 17, 17, 5,
 'AUTO',                'CURRENT',
 '2021-07-15', '2021-08-01', '2021-08-01', '2028-08-01',
 42000.00,  22188.09, 0.0629, 'FIXED',  84,   617.22,
 '2026-05-01', '2026-04-01',   617.22,  29866.56,   8266.56,     0.00,
 'Chris Burke',        'New Ford Explorer - Scottsdale AZ'),

-- loan_id 10: Tyler Beaumont - undergraduate student loan (Tulane)
('LN-STUD-20210901001',  9, 10, 19, 19, 6,
 'STUDENT_UNDERGRADUATE', 'CURRENT',
 '2021-07-10', '2021-08-10', '2021-09-01', '2031-09-01',
 38000.00,  30425.64, 0.0559, 'FIXED', 120,   411.34,
 '2026-05-01', '2026-04-01',   411.34,   5768.76,   1368.76,   380.00,
 'Marie Trahan',       'Tulane University - Business Administration BS'),

-- loan_id 11: Fatima Al-Hassan - 30-year mortgage (Dallas TX)
('LN-MORT-20200101001', 10,  1, 20, 20, 4,
 'MORTGAGE',           'CURRENT',
 '2019-10-15', '2019-12-15', '2020-01-01', '2050-01-01',
 385000.00,  358244.93, 0.0699, 'FIXED', 360,  2560.73,
 '2026-05-01', '2026-04-01',  2560.73,  33789.65,  16290.65,  3850.00,
 'Tariq Hassan',       'Primary residence - Dallas TX'),

-- loan_id 12: Fatima Al-Hassan - unsecured personal loan (debt consolidation)
('LN-PERS-20240215001', 10, 13, 20, 20, 4,
 'PERSONAL',            'CURRENT',
 '2024-01-20', '2024-02-10', '2024-02-15', '2027-02-15',
 15000.00,  12188.40, 0.1099, 'FIXED',  36,   491.49,
 '2026-05-01', '2026-04-01',   491.49,   7377.37,    877.37,   300.00,
 'Tariq Hassan',       'Debt consolidation');

-- ── Mortgage Details ───────────────────────────────────────

INSERT INTO mortgage_details
(loan_id, property_address, property_city, property_state_code, property_zip,
 property_type, purchase_price, appraised_value, down_payment, ltv_ratio,
 pmi_required, monthly_escrow_payment, annual_property_tax,
 pmi_monthly_premium, is_arm_loan)
VALUES
-- loan 1: James Harrington - Lincoln Park Chicago condo
(1,  '2401 N Lakeview Ave Unit 3402', 'Chicago',  'IL', '60614',
 'CONDO',         850000.00,  920000.00, 170000.00, 80.00,
 0, 685.00,  9800.00,   NULL, 0),

-- loan 5: Ethan Thornton - 740 Park Ave NYC condo (15-yr mortgage)
(5,  '740 Park Ave Apt 15C',          'New York', 'NY', '10021',
 'CONDO',        2400000.00, 2800000.00, 600000.00, 75.00,
 0, 1850.00, 32000.00,   NULL, 0),

-- loan 6: Ethan Thornton - same property, home equity loan
(6,  '740 Park Ave Apt 15C',          'New York', 'NY', '10021',
 'CONDO',        2400000.00, 2800000.00,      0.00, 68.00,
 0,    0.00, 32000.00,   NULL, 0),

-- loan 8: Chen Zhang - Arcadia CA single family
(8,  '888 Arcadia Ave',               'Arcadia',  'CA', '91007',
 'SINGLE_FAMILY',  675000.00,  720000.00, 155000.00, 77.04,
 0,  680.00, 11200.00,   NULL, 0),

-- loan 11: Fatima Al-Hassan - Dallas TX condo (PMI required, high LTV)
(11, '5555 Lovers Ln Unit 204',       'Dallas',   'TX', '75209',
 'CONDO',          425000.00,  445000.00,  40000.00, 90.59,
 1,  590.00,  7800.00, 145.00, 0);

-- ── Auto Loan Details ──────────────────────────────────────
-- vin is VARCHAR(18); all values below are 17 chars (standard VIN length)

INSERT INTO auto_loan_details
(loan_id, vin, vehicle_year, vehicle_make, vehicle_model,
 vehicle_trim, vehicle_mileage, vehicle_color,
 is_new, dealer_name, purchase_price, down_payment, gap_insurance)
VALUES
-- loan 2: Tesla Model Y (new)
(2, '5YJYGDEE5MF123456', 2022, 'Tesla', 'Model Y',
 'Long Range AWD',      5, 'Pearl White',
 1, 'Tesla Cupertino',              58500.00, 8000.00, 1),

-- loan 4: Honda CR-V (used)
(4, '7FARW6H83ME987654', 2021, 'Honda', 'CR-V',
 'EX-L AWD',        28500, 'Sonic Gray',
 0, 'AutoNation Honda Brickell',    27500.00, 3000.00, 0),

-- loan 9: Ford Explorer (new)
(9, '1FM5K8D88MGA11223', 2021, 'Ford',  'Explorer',
 'XLT 4WD',         14200, 'Carbonized Gray',
 1, 'Earnhardt Ford Scottsdale',    42000.00, 5000.00, 1);

-- ── Student Loan Details ───────────────────────────────────

INSERT INTO student_loan_details
(loan_id, institution_name, ope_id, degree_program, enrollment_status,
 in_school_deferment, repayment_plan, loan_servicer, public_service_eligible)
VALUES
-- loan 7: Aisha Okonkwo - UChicago
(7,  'University of Chicago', '001774',
 'Computer Science B.S.',        'FULL_TIME', 0, 'STANDARD', 'NexusBank', 0),

-- loan 10: Tyler Beaumont - Tulane
(10, 'Tulane University',     '002029',
 'Business Administration B.S.', 'GRADUATED', 0, 'STANDARD', 'NexusBank', 0);

-- ── Transactions ──────────────────────────────────────────
-- James Harrington - account_id 1 (Nexus 360 Checking)

INSERT INTO transactions
(transaction_ref, account_id, transaction_type, transaction_status,
 amount, balance_before, balance_after, category_id,
 description, merchant_name, channel, transaction_date, posted_at)
VALUES
    ('TXN-20260401-0000001', 1, 'CREDIT', 'POSTED', 15416.67, 27033.33, 42450.00,  2,
     'Direct Deposit - Goldman Sachs Payroll', 'Goldman Sachs', 'ACH',
     '2026-04-01', '2026-04-01 08:00:00'),

    ('TXN-20260402-0000002', 1, 'DEBIT',  'POSTED',  3351.74, 42450.00, 39098.26,  7,
     'Mortgage Payment - LN-MORT-20180615001', 'NexusBank',    'ONLINE_BANKING',
     '2026-04-02', '2026-04-02 10:15:00'),

    ('TXN-20260405-0000003', 1, 'DEBIT',  'POSTED',   189.50, 39098.26, 38908.76, 10,
     'Whole Foods Market',                     'Whole Foods',  'CARD',
     '2026-04-05', '2026-04-05 18:30:00'),

    ('TXN-20260407-0000004', 1, 'DEBIT',  'POSTED',   350.00, 38908.76, 38558.76, 20,
     'Nordstrom - Lincoln Park',               'Nordstrom',    'CARD',
     '2026-04-07', '2026-04-07 14:00:00'),

    ('TXN-20260409-0000005', 1, 'DEBIT',  'POSTED',   425.00, 38558.76, 38133.76, 19,
     'Lyric Opera Chicago - Season Tickets',   'Lyric Opera',  'ONLINE_BANKING',
     '2026-04-09', '2026-04-09 09:00:00'),

    ('TXN-20260410-0000006', 1, 'DEBIT',  'POSTED',   280.25, 38133.76, 37853.51, 12,
     'Gibsons Bar and Steakhouse',             'Gibsons',      'CARD',
     '2026-04-10', '2026-04-10 20:45:00'),

    ('TXN-20260411-0000007', 1, 'DEBIT',  'POSTED',   285.00, 37853.51, 37568.51,  9,
     'ComEd Electric Bill',                    'ComEd',        'ONLINE_BANKING',
     '2026-04-11', '2026-04-11 07:00:00'),

    ('TXN-20260411-0000008', 1, 'DEBIT',  'POSTED',   892.00, 37568.51, 36676.51,  6,
     'HOA Payment - 2401 N Lakeview',          'Lakeview Mgmt','ONLINE_BANKING',
     '2026-04-11', '2026-04-11 07:01:00'),

    ('TXN-20260412-0000009', 1, 'DEBIT',  'POSTED',   145.80, 36676.51, 36530.71, 11,
     'Marianos Fresh Market',                  'Marianos',     'CARD',
     '2026-04-12', '2026-04-12 17:15:00'),

    ('TXN-20260413-0000010', 1, 'DEBIT',  'POSTED',    89.99, 36530.71, 36440.72, 19,
     'Netflix Premium + Apple TV+',            'Streaming',    'CARD',
     '2026-04-13', '2026-04-13 00:00:00'),

    ('TXN-20260414-0000011', 1, 'DEBIT',  'PENDING', 3351.74, 36440.72, 33088.98,  7,
     'Mortgage Payment - April 2026',          'NexusBank',    'ONLINE_BANKING',
     '2026-04-14', NULL),

    ('TXN-20260414-0000012', 1, 'DEBIT',  'PENDING', 5000.00, 33088.98, 28088.98, 21,
     'Federal Tax Payment Q1 Estimated',       'IRS',          'ONLINE_BANKING',
     '2026-04-14', NULL);

-- Aisha Okonkwo - account_id 13 (Essential Checking)

INSERT INTO transactions
(transaction_ref, account_id, transaction_type, transaction_status,
 amount, balance_before, balance_after, category_id,
 description, merchant_name, channel, transaction_date, posted_at)
VALUES
    ('TXN-20260401-0001001', 13, 'CREDIT', 'POSTED', 1500.00, 1850.00, 3350.00,  2,
     'Payroll - UChicago Library',               'UChicago',      'ACH',
     '2026-04-01', '2026-04-01 09:00:00'),

    ('TXN-20260402-0001002', 13, 'DEBIT',  'POSTED',  487.07, 3350.00, 2862.93, 18,
     'Student Loan Payment LN-STUD-20220901001', 'NexusBank',     'ONLINE_BANKING',
     '2026-04-02', '2026-04-02 08:00:00'),

    ('TXN-20260405-0001003', 13, 'DEBIT',  'POSTED',  125.00, 2862.93, 2737.93, 17,
     'UChicago Bookstore - Spring Textbooks',    'UChicago Store','CARD',
     '2026-04-05', '2026-04-05 12:00:00'),

    ('TXN-20260408-0001004', 13, 'DEBIT',  'POSTED',   48.50, 2737.93, 2689.43, 11,
     'Trader Joes Hyde Park',                    'Trader Joes',   'CARD',
     '2026-04-08', '2026-04-08 16:00:00'),

    ('TXN-20260410-0001005', 13, 'DEBIT',  'POSTED',  750.00, 2689.43, 1939.43,  8,
     'Rent - Hyde Park Apt April',               'Hyde Park Mgmt','ONLINE_BANKING',
     '2026-04-10', '2026-04-10 10:00:00'),

    ('TXN-20260413-0001006', 13, 'DEBIT',  'POSTED',   35.99, 1939.43, 1903.44, 19,
     'Spotify Premium Student',                  'Spotify',       'CARD',
     '2026-04-13', '2026-04-13 00:00:00'),

    ('TXN-20260414-0001007', 13, 'DEBIT',  'PENDING',  62.40, 1903.44, 1841.04,  9,
     'ComEd + Internet Bundle',                  'Xfinity',       'ONLINE_BANKING',
     '2026-04-14', NULL);

-- ── Cards ──────────────────────────────────────────────────

INSERT INTO cards
(card_number_masked, card_token, account_id, customer_id,
 card_type, card_network, card_status, cardholder_name,
 expiry_month, expiry_year, daily_limit, monthly_limit,
 contactless_enabled, online_enabled, issued_at, activated_at)
VALUES
    ('4000-0000-0010-0112', 'tok_visa_jhvip001',    1,  1,
     'DEBIT', 'VISA',       'ACTIVE', 'JAMES R HARRINGTON',    12, 2028,  5000.00,  25000.00, 1, 1, '2022-01-01', '2022-01-05'),

    ('4000-0000-0020-0213', 'tok_visa_pkcrd001',    4,  2,
     'DEBIT', 'VISA',       'ACTIVE', 'PRIYA A KRISHNAMURTHY',  9, 2027,  2500.00,  10000.00, 1, 1, '2023-01-01', '2023-01-03'),

    ('5200-0000-0030-0314', 'tok_mc_mwcrd001',      6,  3,
     'DEBIT', 'MASTERCARD', 'ACTIVE', 'MARCUS D WILLIAMS',      6, 2027,  2500.00,   8000.00, 1, 1, '2022-01-01', '2022-01-04'),

    ('4000-0000-0040-0415', 'tok_visa_sdcrd001',    8,  4,
     'DEBIT', 'VISA',       'ACTIVE', 'SOFIA I DELGADO',        3, 2028,  2500.00,  10000.00, 1, 1, '2021-10-01', '2021-10-05'),

    ('4000-0000-0050-0516', 'tok_visa_etpb001',    10,  5,
     'DEBIT', 'VISA',       'ACTIVE', 'ETHAN THORNTON',        11, 2029, 10000.00,  50000.00, 1, 1, '2023-01-01', '2023-01-02'),

    ('4000-0000-0060-0617', 'tok_visa_aostd001',   13,  6,
     'DEBIT', 'VISA',       'ACTIVE', 'AISHA F OKONKWO',        8, 2026,  1000.00,   3000.00, 1, 1, '2022-09-01', '2022-09-03'),

    ('4000-0000-0070-0718', 'tok_visa_czhprem01',  15,  7,
     'DEBIT', 'VISA',       'ACTIVE', 'CHEN W ZHANG',          10, 2028,  5000.00,  20000.00, 1, 1, '2022-01-01', '2022-01-03'),

    ('5200-0000-0080-0819', 'tok_mc_rsmcrd001',    17,  8,
     'DEBIT', 'MASTERCARD', 'ACTIVE', 'REBECCA L STAFFORD',     5, 2027,  2500.00,  10000.00, 1, 1, '2022-01-01', '2022-01-06'),

    ('4000-0000-0090-0920', 'tok_visa_tbstud001',  19,  9,
     'DEBIT', 'VISA',       'ACTIVE', 'TYLER J BEAUMONT',       7, 2026,   500.00,   2000.00, 1, 1, '2021-09-01', '2021-09-02'),

    ('4000-0001-0000-1021', 'tok_visa_fahcrd001',  20, 10,
     'DEBIT', 'VISA',       'ACTIVE', 'FATIMA Z AL-HASSAN',    11, 2028,  2500.00,  10000.00, 1, 1, '2020-01-01', '2020-01-04');

-- ── Customer Alerts ────────────────────────────────────────

INSERT INTO customer_alerts (customer_id, alert_type, message, is_read, created_at) VALUES
                                                                                        (1,  'LARGE_TRANSACTION', 'A debit of $5,000.00 (Federal Tax Q1) was posted to your Nexus 360 Checking ending 0011 on Apr 14.', 0, '2026-04-14 09:01:00'),
                                                                                        (1,  'PAYMENT_DUE',       'Your mortgage payment of $3,351.74 is due today (Apr 14, 2026). Pending auto-pay scheduled.',          0, '2026-04-14 07:00:00'),
                                                                                        (2,  'PAYMENT_DUE',       'Your auto loan payment of $1,101.98 is due on May 15, 2026. Auto-pay is active.',                      0, '2026-04-28 09:00:00'),
                                                                                        (3,  'LOW_BALANCE',       'Your Essential Checking balance is $4,280.75, below your $5,000 alert threshold.',                     0, '2026-04-12 10:00:00'),
                                                                                        (6,  'PAYMENT_DUE',       'Your student loan payment of $487.07 is due May 1, 2026.',                                             0, '2026-04-25 08:00:00'),
                                                                                        (6,  'STATEMENT_READY',   'Your March 2026 account statement is ready to view online.',                                           0, '2026-04-01 06:00:00'),
                                                                                        (9,  'LOW_BALANCE',       'Your checking account balance is $950.25, below your $1,000 alert threshold.',                         0, '2026-04-13 09:00:00'),
                                                                                        (5,  'GENERAL',           'Your Home Equity Loan rate adjustment review is scheduled for June 2026.',                             0, '2026-04-01 10:00:00');