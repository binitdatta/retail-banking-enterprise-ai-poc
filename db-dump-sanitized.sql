CREATE DATABASE  IF NOT EXISTS `nexusbank_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `nexusbank_db`;
-- MySQL dump 10.13  Distrib 8.0.45, for macos15 (x86_64)
--
-- Host: localhost    Database: nexusbank_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_beneficiaries`
--

DROP TABLE IF EXISTS `account_beneficiaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_beneficiaries` (
  `beneficiary_id` bigint NOT NULL AUTO_INCREMENT,
  `account_id` bigint NOT NULL,
  `beneficiary_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `relationship` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allocation_percent` decimal(5,2) NOT NULL DEFAULT '100.00',
  `ssn_last4` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`beneficiary_id`),
  KEY `idx_ben_account` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Account beneficiaries for estate purposes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_beneficiaries`
--

LOCK TABLES `account_beneficiaries` WRITE;
/*!40000 ALTER TABLE `account_beneficiaries` DISABLE KEYS */;
INSERT INTO `account_beneficiaries` VALUES (1,1,'Alex Carter','SPOUSE',60.00,'9346',1,'2024-01-20 10:00:00'),(2,1,'Jordan Bennett','CHILD',40.00,'6125',0,'2024-01-20 10:05:00'),(3,2,'Taylor Hayes','SPOUSE',100.00,'6422',1,'2024-02-22 09:00:00'),(4,5,'Morgan Foster','TRUST',100.00,NULL,1,'2023-11-12 08:00:00'),(5,10,'Casey Brooks','SPOUSE',50.00,'7575',1,'2023-11-12 08:05:00'),(6,10,'Riley Perry','CHILD',50.00,'9534',0,'2023-11-12 08:10:00'),(7,15,'Avery Murphy','SPOUSE',100.00,'2201',1,'2024-02-15 10:00:00'),(8,17,'Cameron Reed','SPOUSE',100.00,'2701',1,'2024-03-20 11:00:00'),(9,20,'Drew Bailey','MOTHER',100.00,'9836',1,'2024-01-06 09:00:00');
/*!40000 ALTER TABLE `account_beneficiaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `account_products`
--

DROP TABLE IF EXISTS `account_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `monthly_fee` decimal(8,2) NOT NULL DEFAULT '0.00',
  `apy_rate` decimal(6,4) DEFAULT NULL,
  `overdraft_limit` decimal(10,2) NOT NULL DEFAULT '0.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `uk_product_code` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Retail deposit product catalog';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_products`
--

LOCK TABLES `account_products` WRITE;
/*!40000 ALTER TABLE `account_products` DISABLE KEYS */;
INSERT INTO `account_products` VALUES (1,'CHK-ESSENTIAL','Essential Checking','CHECKING',0.00,0.00,0.0000,500.00,1,'Fee-free everyday checking with no minimum balance','2026-04-14 08:03:09'),(2,'CHK-ADVANTAGE','Advantage Checking','CHECKING',500.00,12.00,0.0100,1000.00,1,'Premium checking with interest and ATM fee rebates','2026-04-14 08:03:09'),(3,'CHK-NEXUS360','Nexus 360 Checking','CHECKING',5000.00,0.00,0.0150,2500.00,1,'High-yield checking for balances over $5k, fee waived','2026-04-14 08:03:09'),(4,'SAV-STANDARD','Standard Savings','SAVINGS',25.00,5.00,0.0430,0.00,1,'FDIC-insured savings at 4.30% APY','2026-04-14 08:03:09'),(5,'SAV-HIGH-YIELD','High-Yield Savings','SAVINGS',1000.00,0.00,0.0510,0.00,1,'Earn 5.10% APY up to $250k','2026-04-14 08:03:09'),(6,'SAV-NEXUSGROW','NexusGrow Savings','SAVINGS',2500.00,0.00,0.0525,0.00,1,'Tiered rate savings 5.25% on balances $2,500+','2026-04-14 08:03:09'),(7,'MM-PREMIER','Premier Money Market','MONEY_MARKET',2500.00,10.00,0.0490,0.00,1,'Check-writing money market 4.90% APY','2026-04-14 08:03:09'),(8,'MM-BUSINESS','Business Money Market','MONEY_MARKET',10000.00,0.00,0.0505,0.00,1,'Business sweep account 5.05% APY','2026-04-14 08:03:09'),(9,'CD-6MO','6-Month CD','CD',1000.00,0.00,0.0525,0.00,1,'6-month certificate of deposit 5.25% APY','2026-04-14 08:03:09'),(10,'CD-12MO','12-Month CD','CD',1000.00,0.00,0.0540,0.00,1,'12-month CD 5.40% APY','2026-04-14 08:03:09'),(11,'CD-24MO','24-Month CD','CD',2500.00,0.00,0.0520,0.00,1,'24-month CD 5.20% APY','2026-04-14 08:03:09'),(12,'IRA-TRAD','Traditional IRA','IRA',500.00,0.00,0.0480,0.00,1,'Tax-deferred traditional IRA savings account','2026-04-14 08:03:09'),(13,'IRA-ROTH','Roth IRA Savings','IRA',500.00,0.00,0.0480,0.00,1,'After-tax Roth IRA for tax-free growth','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `account_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `account_id` bigint NOT NULL AUTO_INCREMENT,
  `account_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `routing_number` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '071000013',
  `nickname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` bigint NOT NULL,
  `product_id` int NOT NULL,
  `branch_id` int DEFAULT NULL,
  `account_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_APPROVAL',
  `current_balance` decimal(18,2) NOT NULL DEFAULT '0.00',
  `available_balance` decimal(18,2) NOT NULL DEFAULT '0.00',
  `hold_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `overdraft_protection` tinyint(1) NOT NULL DEFAULT '0',
  `overdraft_limit` decimal(10,2) NOT NULL DEFAULT '0.00',
  `annual_percentage_yield` decimal(6,4) DEFAULT NULL,
  `opened_date` date NOT NULL DEFAULT (curdate()),
  `closed_date` date DEFAULT NULL,
  `maturity_date` date DEFAULT NULL COMMENT 'CDs only',
  `last_transaction_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_id`),
  UNIQUE KEY `uk_account_number` (`account_number`),
  KEY `idx_acct_customer` (`customer_id`),
  KEY `idx_acct_status` (`account_status`),
  KEY `idx_acct_product` (`product_id`),
  KEY `fk_acct_branch` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Customer bank accounts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'ACCT-00000001','209089689','Demo Account 1',1,3,1,'ACTIVE',28450.00,28450.00,0.00,'USD',1,2500.00,0.0150,'2018-06-01',NULL,NULL,'2026-04-14 09:01:00','2026-04-14 08:03:09','2026-04-14 09:01:00'),(2,'ACCT-00000002','209089689','Demo Account 2',1,5,1,'ACTIVE',95000.00,95000.00,0.00,'USD',0,0.00,0.0510,'2018-06-01',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(3,'ACCT-00000003','209089689','Demo Account 3',1,10,1,'ACTIVE',50000.00,50000.00,0.00,'USD',0,0.00,0.0540,'2022-01-15',NULL,'2027-01-15',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(4,'ACCT-00000004','209089689','Demo Account 4',2,1,3,'ACTIVE',12340.50,12340.50,0.00,'USD',1,500.00,NULL,'2020-03-15',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(5,'ACCT-00000005','209089689','Demo Account 5',2,4,3,'ACTIVE',31500.00,31500.00,0.00,'USD',0,0.00,0.0430,'2020-03-15',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(6,'ACCT-00000006','209089689','Demo Account 6',3,1,4,'ACTIVE',4280.75,4280.75,0.00,'USD',1,500.00,NULL,'2019-11-20',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(7,'ACCT-00000007','209089689','Demo Account 7',3,4,4,'ACTIVE',8950.00,8950.00,0.00,'USD',0,0.00,0.0430,'2019-11-20',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(8,'ACCT-00000008','209089689','Demo Account 8',4,2,6,'ACTIVE',7820.25,7820.25,0.00,'USD',1,1000.00,0.0100,'2021-08-10',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(9,'ACCT-00000009','209089689','Demo Account 9',4,4,6,'ACTIVE',22400.00,22400.00,0.00,'USD',0,0.00,0.0430,'2021-08-10',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(10,'ACCT-00000010','209089689','Demo Account 10',5,3,2,'ACTIVE',185000.00,185000.00,0.00,'USD',1,2500.00,0.0150,'2015-02-28',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(11,'ACCT-00000011','209089689','Demo Account 11',5,6,2,'ACTIVE',425000.00,425000.00,0.00,'USD',0,0.00,0.0525,'2015-02-28',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(12,'ACCT-00000012','209089689','Demo Account 12',5,8,2,'ACTIVE',750000.00,750000.00,0.00,'USD',0,0.00,0.0505,'2015-02-28',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(13,'ACCT-00000013','209089689','Demo Account 13',6,1,1,'ACTIVE',1850.00,1850.00,0.00,'USD',0,0.00,NULL,'2022-08-20',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(14,'ACCT-00000014','209089689','Demo Account 14',6,4,1,'ACTIVE',3200.00,3200.00,0.00,'USD',0,0.00,0.0430,'2022-08-20',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(15,'ACCT-00000015','209089689','Demo Account 15',7,3,3,'ACTIVE',42600.00,42600.00,0.00,'USD',1,2500.00,0.0150,'2017-05-10',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(16,'ACCT-00000016','209089689','Demo Account 16',7,5,3,'ACTIVE',130000.00,130000.00,0.00,'USD',0,0.00,0.0510,'2017-05-10',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(17,'ACCT-00000017','209089689','Demo Account 17',8,2,5,'ACTIVE',9340.00,9340.00,0.00,'USD',1,1000.00,0.0100,'2020-07-14',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(18,'ACCT-00000018','209089689','Demo Account 18',8,4,5,'ACTIVE',28700.00,28700.00,0.00,'USD',0,0.00,0.0430,'2020-07-14',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(19,'ACCT-00000019','209089689','Demo Account 19',9,1,6,'ACTIVE',950.25,950.25,0.00,'USD',0,0.00,NULL,'2021-08-15',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(20,'ACCT-00000020','209089689','Demo Account 20',10,2,4,'ACTIVE',18500.00,18500.00,0.00,'USD',1,1000.00,0.0100,'2019-09-01',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09','2026-04-14 08:03:09'),(21,'ACCT-00000021','209089689','Demo Account 21',10,4,4,'ACTIVE',45200.00,45200.00,0.00,'USD',0,0.00,0.0430,'2019-09-01',NULL,NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(22,'ACCT-00000022','209089689','Demo Account 22',10,3,NULL,'ACTIVE',7000.00,7000.00,0.00,'USD',0,0.00,0.0150,'2026-04-17',NULL,NULL,NULL,'2026-04-17 09:32:37','2026-04-17 09:32:37');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `audit_id` bigint NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `performed_by` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Keycloak username',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_entity` (`entity_type`,`entity_id`),
  KEY `idx_audit_user` (`performed_by`),
  KEY `idx_audit_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Immutable audit trail';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,'CUSTOMER','1','LOGIN','Quinn Cooper','198.51.100.10',NULL,NULL,'Sanitized audit event for public repository','2026-04-15 07:45:00'),(2,'LOAN_APPLICATION','3','UPDATE','Parker Morgan','198.51.100.10','{"sanitized": true}','{"sanitized": true}','Sanitized audit event for public repository','2026-04-15 15:30:00'),(3,'LOAN_APPLICATION','4','UPDATE','Logan Gray','198.51.100.10','{"sanitized": true}','{"sanitized": true}','Sanitized audit event for public repository','2026-04-15 16:00:00'),(4,'LOAN_APPLICATION','6','UPDATE','Devon Ward','198.51.100.10','{"sanitized": true}','{"sanitized": true}','Sanitized audit event for public repository','2026-04-11 14:00:00'),(5,'LOAN_APPLICATION','8','UPDATE','Skyler Price','198.51.100.10','{"sanitized": true}','{"sanitized": true}','Sanitized audit event for public repository','2026-04-06 10:00:00'),(6,'CUSTOMER','1','UPDATE','Reese Bell','198.51.100.11',NULL,'{"sanitized": true}','Sanitized audit event for public repository','2026-04-14 09:00:00'),(7,'WIRE','3','CREATE','Alex Carter','198.51.100.12',NULL,'{"sanitized": true}','Sanitized audit event for public repository','2026-04-10 09:00:00'),(8,'CUSTOMER','5','LOGIN','Jordan Bennett','198.51.100.13',NULL,NULL,'Sanitized audit event for public repository','2026-04-14 08:00:00');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auto_loan_details`
--

DROP TABLE IF EXISTS `auto_loan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auto_loan_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loan_id` bigint NOT NULL,
  `vin` varchar(18) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Standard VIN 17 chars; 18 allows regional variants',
  `vehicle_year` int NOT NULL,
  `vehicle_make` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehicle_model` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehicle_trim` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehicle_color` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehicle_mileage` int DEFAULT NULL,
  `is_new` tinyint(1) NOT NULL DEFAULT '1',
  `purchase_price` decimal(12,2) NOT NULL,
  `down_payment` decimal(10,2) DEFAULT NULL,
  `trade_in_value` decimal(10,2) DEFAULT NULL,
  `gap_insurance` tinyint(1) NOT NULL DEFAULT '0',
  `gap_insurance_amount` decimal(8,2) DEFAULT NULL,
  `dealer_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `title_state` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `license_plate` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_auto_loan` (`loan_id`),
  UNIQUE KEY `uk_vin` (`vin`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Auto loan vehicle collateral details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auto_loan_details`
--

LOCK TABLES `auto_loan_details` WRITE;
/*!40000 ALTER TABLE `auto_loan_details` DISABLE KEYS */;
INSERT INTO `auto_loan_details` VALUES (1,2,'DEMOAUTOVIN000001',2022,'Tesla','Model Y','Long Range AWD','Pearl White',5,1,58500.00,8000.00,NULL,1,NULL,'First Harbor Bank','2022-10-15','CA','DEM0001','2026-04-14 08:03:09'),(2,4,'DEMOAUTOVIN000002',2021,'Honda','CR-V','EX-L AWD','Sonic Gray',28500,0,27500.00,3000.00,NULL,0,NULL,'Union Metro Bank','2023-11-01','FL','DEM0002','2026-04-14 08:03:09'),(3,9,'DEMOAUTOVIN000003',2021,'Ford','Explorer','XLT 4WD','Carbonized Gray',14200,1,42000.00,5000.00,NULL,1,NULL,'Summit National Bank','2021-08-01','AZ','DEM0003','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `auto_loan_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `branches` (
  `branch_id` int NOT NULL AUTO_INCREMENT,
  `branch_code` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Format: NBK-XXX-000 (11 chars max)',
  `branch_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line1` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `manager_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`branch_id`),
  UNIQUE KEY `uk_branch_code` (`branch_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bank branch locations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'NBK-CHI-001','NexusBank Chicago Loop','100 Demo Avenue','Phoenix','IL','28512','(555) 010-0001','Taylor Hayes',1,'2026-04-14 08:03:09'),(2,'NBK-NYC-001','NexusBank Manhattan Flagship','101 Demo Avenue','Seattle','NY','31547','(555) 010-0002','Morgan Foster',1,'2026-04-14 08:03:09'),(3,'NBK-LAX-001','NexusBank Century City','102 Demo Avenue','Denver','CA','58647','(555) 010-0003','Casey Brooks',1,'2026-04-14 08:03:09'),(4,'NBK-HOU-001','NexusBank Houston Energy Corridor','103 Demo Avenue','Denver','TX','51250','(555) 010-0004','Riley Perry',1,'2026-04-14 08:03:09'),(5,'NBK-PHX-001','NexusBank Scottsdale Quarter','104 Demo Avenue','Houston','AZ','76987','(555) 010-0005','Avery Murphy',1,'2026-04-14 08:03:09'),(6,'NBK-MIA-001','NexusBank Brickell','105 Demo Avenue','Denver','FL','51079','(555) 010-0006','Cameron Reed',1,'2026-04-14 08:03:09');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `card_id` bigint NOT NULL AUTO_INCREMENT,
  `card_number_masked` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'XXXX-XXXX-XXXX-1234',
  `card_token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tokenized card reference',
  `account_id` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `card_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `card_network` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VISA',
  `card_status` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_ACTIVATION',
  `cardholder_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiry_month` int NOT NULL,
  `expiry_year` int NOT NULL,
  `daily_limit` decimal(10,2) NOT NULL DEFAULT '2500.00',
  `monthly_limit` decimal(12,2) NOT NULL DEFAULT '15000.00',
  `contactless_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `online_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `issued_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activated_at` datetime DEFAULT NULL,
  `blocked_at` datetime DEFAULT NULL,
  `block_reason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`card_id`),
  UNIQUE KEY `uk_card_token` (`card_token`),
  KEY `idx_card_account` (`account_id`),
  KEY `idx_card_customer` (`customer_id`),
  KEY `idx_card_status` (`card_status`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Payment cards - debit and credit';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` VALUES (1,'**** **** **** 0000','TOKEN-00000025',1,1,'DEBIT','VISA','ACTIVE','Drew Bailey',12,2028,5000.00,25000.00,1,1,'2022-01-01 00:00:00','2022-01-05 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(2,'**** **** **** 0000','TOKEN-00000026',4,2,'DEBIT','VISA','ACTIVE','Quinn Cooper',9,2027,2500.00,10000.00,1,1,'2023-01-01 00:00:00','2023-01-03 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(3,'**** **** **** 0000','TOKEN-00000027',6,3,'DEBIT','MASTERCARD','ACTIVE','Parker Morgan',6,2027,2500.00,8000.00,1,1,'2022-01-01 00:00:00','2022-01-04 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(4,'**** **** **** 0000','TOKEN-00000028',8,4,'DEBIT','VISA','ACTIVE','Logan Gray',3,2028,2500.00,10000.00,1,1,'2021-10-01 00:00:00','2021-10-05 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(5,'**** **** **** 0000','TOKEN-00000029',10,5,'DEBIT','VISA','ACTIVE','Devon Ward',11,2029,10000.00,50000.00,1,1,'2023-01-01 00:00:00','2023-01-02 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(6,'**** **** **** 0000','TOKEN-00000030',13,6,'DEBIT','VISA','ACTIVE','Skyler Price',8,2026,1000.00,3000.00,1,1,'2022-09-01 00:00:00','2022-09-03 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(7,'**** **** **** 0000','TOKEN-00000031',15,7,'DEBIT','VISA','ACTIVE','Reese Bell',10,2028,5000.00,20000.00,1,1,'2022-01-01 00:00:00','2022-01-03 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(8,'**** **** **** 0000','TOKEN-00000032',17,8,'DEBIT','MASTERCARD','ACTIVE','Alex Carter',5,2027,2500.00,10000.00,1,1,'2022-01-01 00:00:00','2022-01-06 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(9,'**** **** **** 0000','TOKEN-00000033',19,9,'DEBIT','VISA','ACTIVE','Jordan Bennett',7,2026,500.00,2000.00,1,1,'2021-09-01 00:00:00','2021-09-02 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(10,'**** **** **** 0000','TOKEN-00000034',20,10,'DEBIT','VISA','ACTIVE','Taylor Hayes',11,2028,2500.00,10000.00,1,1,'2020-01-01 00:00:00','2020-01-04 00:00:00',NULL,NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currencies` (
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ISO 4217 Currency codes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
INSERT INTO `currencies` VALUES ('CAD','Canadian Dollar','CA$'),('EUR','Euro','€'),('GBP','British Pound','£'),('MXN','Mexican Peso','MX$'),('USD','US Dollar','$');
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_addresses`
--

DROP TABLE IF EXISTS `customer_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_addresses` (
  `address_id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `address_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOME',
  `address_line1` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line2` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'US',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_addr_customer` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Customer addresses - multiple per customer';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_addresses`
--

LOCK TABLES `customer_addresses` WRITE;
/*!40000 ALTER TABLE `customer_addresses` DISABLE KEYS */;
INSERT INTO `customer_addresses` VALUES (1,1,'HOME','106 Demo Avenue','107 Demo Avenue','Chicago','IL','64310','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(2,1,'WORK','108 Demo Avenue',NULL,'Seattle','NY','91470','US',0,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(3,2,'HOME','109 Demo Avenue','110 Demo Avenue','Phoenix','CA','76994','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(4,3,'HOME','111 Demo Avenue','112 Demo Avenue','Chicago','TX','80925','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(5,4,'HOME','113 Demo Avenue','114 Demo Avenue','Chicago','FL','87192','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(6,5,'HOME','115 Demo Avenue','116 Demo Avenue','Seattle','NY','36005','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(7,5,'MAILING','117 Demo Avenue',NULL,'Denver','CT','93238','US',0,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(8,6,'HOME','118 Demo Avenue','119 Demo Avenue','Chicago','IL','70393','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(9,7,'HOME','120 Demo Avenue',NULL,'Denver','CA','24116','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(10,8,'HOME','121 Demo Avenue','122 Demo Avenue','Atlanta','AZ','37333','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(11,9,'HOME','123 Demo Avenue','124 Demo Avenue','Denver','LA','86427','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(12,10,'HOME','125 Demo Avenue','126 Demo Avenue','Seattle','TX','48230','US',1,'2026-04-14 08:03:09','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `customer_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_alerts`
--

DROP TABLE IF EXISTS `customer_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_alerts` (
  `alert_id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `alert_type` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`alert_id`),
  KEY `idx_alert_customer` (`customer_id`),
  KEY `idx_alert_unread` (`customer_id`,`is_read`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Customer notifications and alerts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_alerts`
--

LOCK TABLES `customer_alerts` WRITE;
/*!40000 ALTER TABLE `customer_alerts` DISABLE KEYS */;
INSERT INTO `customer_alerts` VALUES (1,1,'LARGE_TRANSACTION','A debit of $5,000.00 (IRS Estimated Tax Q1) was posted to your Nexus 360 Checking ending 0000 on Apr 14.',0,'2026-04-14 09:01:00'),(2,1,'PAYMENT_DUE','Your mortgage payment of $3,351.74 (LN-00000035) is due May 1, 2026. Auto-pay is scheduled.',0,'2026-04-28 07:00:00'),(3,1,'LOAN_APPROVED','Your mortgage application APP-00000023 for $300,000 has been APPROVED at 7.25% for 30 years.',0,'2026-04-15 15:30:00'),(4,2,'PAYMENT_DUE','Your auto loan payment of $1,101.98 is due May 15, 2026. Auto-pay is active.',0,'2026-04-28 09:00:00'),(5,2,'STATEMENT_READY','Your March 2026 account statement is ready to view in NexusBank online.',0,'2026-04-01 06:00:00'),(6,3,'LOW_BALANCE','Your Essential Checking balance is $4,280.75, which is below your $5,000 alert threshold.',0,'2026-04-12 10:00:00'),(7,3,'PAYMENT_DUE','Your personal loan payment of $664.29 (LN-00000036) is due May 1, 2026.',0,'2026-04-25 08:00:00'),(8,4,'PAYMENT_DUE','Your auto loan payment of $585.92 (LN-00000037) is due May 1, 2026.',0,'2026-04-25 08:00:00'),(9,5,'GENERAL','Your Home Equity Loan rate review is scheduled for June 2026. No action needed now.',0,'2026-04-01 10:00:00'),(10,5,'LARGE_TRANSACTION','A wire transfer of $25,000.00 to Thornton Capital Trust was completed on Apr 1, 2026.',1,'2026-04-01 14:35:00'),(11,6,'PAYMENT_DUE','Your student loan payment of $487.07 is due May 1, 2026. Auto-pay is OFF — action required.',0,'2026-04-25 08:00:00'),(12,6,'STATEMENT_READY','Your March 2026 account statement is ready to view online.',0,'2026-04-01 06:00:00'),(13,7,'LARGE_TRANSACTION','A wire transfer of $50,000.00 to Zhang Shenzhen Tech Ltd was completed on Apr 10, 2026.',1,'2026-04-10 09:05:00'),(14,7,'PAYMENT_DUE','Your mortgage payment of $3,842.40 (LN-00000038) is due May 1, 2026.',0,'2026-04-25 08:00:00'),(15,8,'PAYMENT_DUE','Your auto loan payment of $617.22 (LN-00000039) is due May 1, 2026.',0,'2026-04-25 08:00:00'),(16,9,'LOW_BALANCE','Your checking account balance is $950.25, below your $1,000 alert threshold.',0,'2026-04-13 09:00:00'),(17,9,'PAYMENT_DUE','Your student loan payment of $411.34 is due May 1, 2026. Please ensure sufficient funds.',0,'2026-04-25 08:00:00'),(18,10,'PAYMENT_DUE','Two payments due May 1: Mortgage $2,560.73 and Personal Loan $491.49. Total: $3,052.22.',0,'2026-04-25 08:00:00');
/*!40000 ALTER TABLE `customer_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_documents`
--

DROP TABLE IF EXISTS `customer_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_documents` (
  `document_id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `document_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `issuing_country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `verification_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`document_id`),
  KEY `idx_doc_customer` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Customer KYC document records';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_documents`
--

LOCK TABLES `customer_documents` WRITE;
/*!40000 ALTER TABLE `customer_documents` DISABLE KEYS */;
INSERT INTO `customer_documents` VALUES (1,1,'DRIVERS_LICENSE','DOC-00000040','US','2020-03-01','2028-03-01','VERIFIED','2024-01-15 10:30:00','2026-04-14 08:03:09'),(2,1,'PASSPORT','DOC-00000041','US','2019-06-15','2029-06-15','VERIFIED','2024-01-15 10:35:00','2026-04-14 08:03:09'),(3,2,'DRIVERS_LICENSE','DOC-00000042','US','2021-09-01','2029-09-01','VERIFIED','2024-02-20 14:45:00','2026-04-14 08:03:09'),(4,3,'DRIVERS_LICENSE','DOC-00000043','US','2022-11-01','2030-11-01','VERIFIED','2024-03-05 09:30:00','2026-04-14 08:03:09'),(5,4,'PASSPORT','DOC-00000044','US','2020-07-20','2030-07-20','VERIFIED','2024-01-28 12:00:00','2026-04-14 08:03:09'),(6,5,'PASSPORT','DOC-00000045','US','2018-04-10','2028-04-10','VERIFIED','2023-11-10 16:30:00','2026-04-14 08:03:09'),(7,6,'STATE_ID','DOC-00000046','US','2023-08-14','2027-08-14','VERIFIED','2024-04-01 13:40:00','2026-04-14 08:03:09'),(8,7,'PASSPORT','DOC-00000047','US','2021-12-01','2031-12-01','VERIFIED','2024-02-14 09:00:00','2026-04-14 08:03:09'),(9,8,'DRIVERS_LICENSE','DOC-00000048','US','2020-07-08','2028-07-08','VERIFIED','2024-03-18 15:30:00','2026-04-14 08:03:09'),(10,9,'STATE_ID','DOC-00000049','US','2022-03-25','2026-03-25','VERIFIED','2024-05-10 11:00:00','2026-04-14 08:03:09'),(11,10,'DRIVERS_LICENSE','DOC-00000050','US','2021-01-19','2029-01-19','VERIFIED','2024-01-05 09:20:00','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `customer_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` bigint NOT NULL AUTO_INCREMENT,
  `customer_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `keycloak_user_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Keycloak UUID sub claim - 36 chars standard UUID',
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ssn_last4` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nationality` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified` tinyint(1) NOT NULL DEFAULT '0',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `customer_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'RETAIL',
  `kyc_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `kyc_verified_at` datetime DEFAULT NULL,
  `credit_score` int DEFAULT NULL,
  `credit_score_date` date DEFAULT NULL,
  `annual_income` decimal(15,2) DEFAULT NULL,
  `employment_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'EMPLOYED',
  `employer` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `occupation` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preferred_contact_method` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `assigned_branch_id` int DEFAULT NULL,
  `assigned_banker_id` bigint DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `uk_customer_number` (`customer_number`),
  UNIQUE KEY `uk_customer_email` (`email`),
  UNIQUE KEY `uk_keycloak_user_id` (`keycloak_user_id`),
  KEY `idx_customer_type` (`customer_type`),
  KEY `idx_kyc_status` (`kyc_status`),
  KEY `idx_customer_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Core customer registry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'CUST-00000051','00000000-0000-0000-0000-000000000001','Morgan','Lee','Foster','1978-04-12',NULL,'1222',NULL,'demo.user01@example.com',1,'(555) 010-0007','(555) 010-0008',1,'PREMIUM','VERIFIED','2024-01-15 10:00:00',780,'2025-01-15',185000.00,'EMPLOYED','Cedar Analytics','Managing Director','EMAIL',1,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(2,'CUST-00000052','00000000-0000-0000-0000-000000000002','Casey',NULL,'Brooks','1985-09-28',NULL,'9459',NULL,'demo.user02@example.com',1,'(555) 010-0009','(555) 010-0010',0,'RETAIL','VERIFIED','2024-02-20 14:30:00',740,'2025-02-20',142000.00,'EMPLOYED','Summit Retail Group','Senior Engineer','SMS',3,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(3,'CUST-00000053','00000000-0000-0000-0000-000000000003','Riley',NULL,'Perry','1990-11-03',NULL,'7988',NULL,'demo.user03@example.com',1,'(555) 010-0011','(555) 010-0012',0,'RETAIL','VERIFIED','2024-03-05 09:15:00',695,'2025-03-05',78000.00,'EMPLOYED','Northstar Health','Project Manager','EMAIL',4,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(4,'CUST-00000054','00000000-0000-0000-0000-000000000004','Avery','Lee','Murphy','1993-06-17',NULL,'7361',NULL,'demo.user04@example.com',1,'(555) 010-0013','(555) 010-0014',0,'RETAIL','VERIFIED','2024-01-28 11:45:00',725,'2025-01-28',95000.00,'EMPLOYED','Cedar Analytics','Marketing Manager','SMS',6,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(5,'CUST-00000055','00000000-0000-0000-0000-000000000005','Cameron',NULL,'Reed','1968-02-22',NULL,'9155',NULL,'demo.user05@example.com',1,'(555) 010-0015','(555) 010-0016',1,'PRIVATE_BANKING','VERIFIED','2023-11-10 16:00:00',820,'2024-11-10',650000.00,'SELF_EMPLOYED','Northstar Health','Managing Partner','EMAIL',2,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(6,'CUST-00000056','00000000-0000-0000-0000-000000000006','Drew',NULL,'Bailey','2001-08-14',NULL,'1569',NULL,'demo.user06@example.com',1,'(555) 010-0017','(555) 010-0018',0,'STUDENT','VERIFIED','2024-04-01 13:20:00',650,'2025-04-01',18000.00,'EMPLOYED','Summit Retail Group','Research Assistant','SMS',1,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(7,'CUST-00000057','00000000-0000-0000-0000-000000000007','Quinn','Lee','Cooper','1982-12-30',NULL,'3032',NULL,'demo.user07@example.com',1,'(555) 010-0019','(555) 010-0020',1,'PREMIUM','VERIFIED','2024-02-14 08:30:00',795,'2025-02-14',220000.00,'SELF_EMPLOYED','Summit Retail Group','Founder & CEO','EMAIL',3,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(8,'CUST-00000058','00000000-0000-0000-0000-000000000008','Parker',NULL,'Morgan','1975-07-08',NULL,'6228',NULL,'demo.user08@example.com',1,'(555) 010-0021','(555) 010-0022',0,'RETAIL','VERIFIED','2024-03-18 15:10:00',710,'2025-03-18',110000.00,'EMPLOYED','Northstar Health','Nurse Practitioner','EMAIL',5,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(9,'CUST-00000059','00000000-0000-0000-0000-000000000009','Logan',NULL,'Gray','2000-03-25',NULL,'1589',NULL,'demo.user09@example.com',1,'(555) 010-0023','(555) 010-0024',0,'STUDENT','VERIFIED','2024-05-10 10:45:00',620,'2025-05-10',15000.00,'EMPLOYED','Horizon Foods','Teaching Assistant','SMS',6,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(10,'CUST-00000060','00000000-0000-0000-0000-000000000010','Devon','Lee','Ward','1988-01-19',NULL,'9388',NULL,'demo.user10@example.com',1,'(555) 010-0025','(555) 010-0026',0,'RETAIL','VERIFIED','2024-01-05 09:00:00',755,'2025-01-05',130000.00,'EMPLOYED','Summit Retail Group','Senior Analyst','EMAIL',4,NULL,1,'2026-04-14 08:03:09','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_applications`
--

DROP TABLE IF EXISTS `loan_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_applications` (
  `application_id` bigint NOT NULL AUTO_INCREMENT,
  `application_number` varchar(30) NOT NULL,
  `customer_id` bigint NOT NULL,
  `loan_type` varchar(30) NOT NULL,
  `loan_product_id` int DEFAULT NULL,
  `requested_amount` decimal(14,2) NOT NULL,
  `requested_term_months` int NOT NULL,
  `requested_rate_type` varchar(15) NOT NULL DEFAULT 'FIXED',
  `purpose` varchar(500) DEFAULT NULL,
  `application_status` varchar(30) NOT NULL DEFAULT 'PENDING',
  `applicant_annual_income` decimal(15,2) DEFAULT NULL,
  `applicant_employment_status` varchar(20) DEFAULT NULL,
  `applicant_employer` varchar(150) DEFAULT NULL,
  `applicant_credit_score` int DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_at` datetime DEFAULT NULL,
  `reviewed_by` varchar(150) DEFAULT NULL,
  `reviewer_notes` varchar(1000) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`application_id`),
  UNIQUE KEY `application_number` (`application_number`),
  KEY `fk_loanapp_product` (`loan_product_id`),
  KEY `idx_loanapp_customer` (`customer_id`),
  KEY `idx_loanapp_status` (`application_status`),
  KEY `idx_loanapp_submitted` (`submitted_at`),
  CONSTRAINT `fk_loanapp_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
  CONSTRAINT `fk_loanapp_product` FOREIGN KEY (`loan_product_id`) REFERENCES `loan_products` (`loan_product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_applications`
--

LOCK TABLES `loan_applications` WRITE;
/*!40000 ALTER TABLE `loan_applications` DISABLE KEYS */;
INSERT INTO `loan_applications` VALUES (1,'APP-00000061',1,'MORTGAGE',1,300000.00,360,'FIXED','Buying a new home in Naperville','PENDING',185000.00,'EMPLOYED','Goldman Sachs & Co',780,'2026-04-15 12:48:23',NULL,NULL,NULL,'2026-04-15 12:48:23','2026-04-15 12:48:23'),(2,'APP-00000062',1,'MORTGAGE',1,300000.00,360,'FIXED','New primary residence purchase','PENDING',185000.00,'EMPLOYED','Goldman Sachs & Co',780,'2026-04-15 12:55:32',NULL,NULL,NULL,'2026-04-15 12:55:32','2026-04-15 12:55:32'),(3,'APP-00000023',1,'MORTGAGE',1,300000.00,360,'FIXED','Residential home purchase','APPROVED',185000.00,'EMPLOYED','Goldman Sachs & Co',780,'2026-04-15 13:01:25','2026-04-15 15:30:00','Alice Bentley','Strong credit profile. Income supports payment. Approved at 7.25% 30yr fixed.','2026-04-15 13:01:25','2026-04-15 15:30:00'),(4,'APP-00000024',1,'MORTGAGE',2,300000.00,300,'FIXED','New home - 25-year term preferred','DECLINED',185000.00,'EMPLOYED','Goldman Sachs & Co',780,'2026-04-15 13:08:51','2026-04-15 16:00:00','Alice Bentley','Duplicate application. Applicant already has approved APP-00000023.','2026-04-15 13:08:51','2026-04-15 16:00:00'),(5,'APP-00000063',1,'MORTGAGE',1,300000.00,360,'FIXED','New Home - primary residence','PENDING',185000.00,'EMPLOYED','Goldman Sachs & Co',780,'2026-04-15 13:15:17',NULL,NULL,NULL,'2026-04-15 13:15:17','2026-04-15 13:15:17'),(6,'APP-00000064',2,'AUTO',7,45000.00,60,'FIXED','Upgrade to 2025 Tesla Model 3','APPROVED',142000.00,'EMPLOYED','Apple Inc',740,'2026-04-10 09:00:00','2026-04-11 14:00:00','Alice Bentley','Excellent credit. Existing Tesla loan well-maintained. Approved 5.49% 60mo.','2026-04-10 09:00:00','2026-04-11 14:00:00'),(7,'APP-00000065',3,'PERSONAL',13,10000.00,24,'FIXED','Vacation and emergency fund','UNDER_REVIEW',78000.00,'EMPLOYED','Chevron Corporation',695,'2026-04-08 11:00:00',NULL,NULL,NULL,'2026-04-08 11:00:00','2026-04-08 11:00:00'),(8,'APP-00000066',9,'STUDENT_UNDERGRADUATE',10,12000.00,120,'FIXED','Junior year tuition - Tulane','APPROVED',15000.00,'EMPLOYED','Tulane University',620,'2026-04-05 08:00:00','2026-04-06 10:00:00','Alice Bentley','Enrollment verified. GPA 3.4. Co-signer waived per student product guidelines.','2026-04-05 08:00:00','2026-04-06 10:00:00');
/*!40000 ALTER TABLE `loan_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_payment_schedule`
--

DROP TABLE IF EXISTS `loan_payment_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_payment_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loan_id` bigint NOT NULL,
  `payment_number` int NOT NULL,
  `due_date` date NOT NULL,
  `scheduled_payment` decimal(12,2) NOT NULL,
  `principal_amount` decimal(12,2) NOT NULL,
  `interest_amount` decimal(12,2) NOT NULL,
  `escrow_amount` decimal(10,2) DEFAULT '0.00',
  `remaining_balance` decimal(14,2) NOT NULL,
  `actual_payment_date` date DEFAULT NULL,
  `actual_amount_paid` decimal(12,2) DEFAULT NULL,
  `payment_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SCHEDULED',
  `late_fee` decimal(8,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `idx_sched_loan` (`loan_id`),
  KEY `idx_sched_due_date` (`due_date`),
  KEY `idx_sched_status` (`payment_status`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Loan amortization schedule';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_payment_schedule`
--

LOCK TABLES `loan_payment_schedule` WRITE;
/*!40000 ALTER TABLE `loan_payment_schedule` DISABLE KEYS */;
INSERT INTO `loan_payment_schedule` VALUES (1,1,1,'2018-08-01',3351.74,942.64,2409.10,685.00,679057.36,'2018-08-01',3351.74,'PAID',0.00),(2,1,2,'2018-09-01',3351.74,945.97,2405.77,685.00,678111.39,'2018-09-01',3351.74,'PAID',0.00),(3,1,3,'2018-10-01',3351.74,949.32,2402.42,685.00,677162.07,'2018-10-01',3351.74,'PAID',0.00),(4,1,94,'2026-01-01',3351.74,1581.12,1770.62,685.00,626584.73,'2026-01-01',3351.74,'PAID',0.00),(5,1,95,'2026-02-01',3351.74,1586.72,1765.02,685.00,624997.41,'2026-02-01',3351.74,'PAID',0.00),(6,1,96,'2026-03-01',3351.74,1591.37,1760.37,685.00,623406.04,'2026-03-01',3351.74,'PAID',0.00),(7,1,97,'2026-04-01',3351.74,1594.04,1757.70,685.00,621812.00,'2026-04-01',3351.74,'PAID',0.00),(8,1,98,'2026-05-01',3351.74,1598.72,1753.02,685.00,620213.28,NULL,NULL,'SCHEDULED',0.00),(9,7,40,'2026-01-01',487.07,307.24,179.83,0.00,39908.46,'2026-01-01',487.07,'PAID',0.00),(10,7,41,'2026-02-01',487.07,308.64,178.43,0.00,39599.82,'2026-02-01',487.07,'PAID',0.00),(11,7,42,'2026-03-01',487.07,310.05,177.02,0.00,39289.77,'2026-03-01',487.07,'PAID',0.00),(12,7,43,'2026-04-01',487.07,311.46,175.61,0.00,38978.31,'2026-04-01',487.07,'PAID',0.00),(13,7,44,'2026-05-01',487.07,312.87,174.20,0.00,38665.44,NULL,NULL,'SCHEDULED',0.00),(14,11,75,'2026-01-01',2560.73,340.44,2220.29,590.00,358935.37,'2026-01-01',2560.73,'PAID',0.00),(15,11,76,'2026-02-01',2560.73,342.28,2218.45,590.00,358593.09,'2026-02-01',2560.73,'PAID',0.00),(16,11,77,'2026-03-01',2560.73,344.13,2216.60,590.00,358248.96,'2026-03-01',2560.73,'PAID',0.00),(17,11,78,'2026-04-01',2560.73,345.99,2214.74,590.00,357903.97,'2026-04-01',2560.73,'PAID',0.00),(18,11,79,'2026-05-01',2560.73,347.85,2212.88,590.00,357556.12,NULL,NULL,'SCHEDULED',0.00);
/*!40000 ALTER TABLE `loan_payment_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_products`
--

DROP TABLE IF EXISTS `loan_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_products` (
  `loan_product_id` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `loan_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `min_amount` decimal(15,2) NOT NULL,
  `max_amount` decimal(15,2) NOT NULL,
  `min_term_months` int NOT NULL,
  `max_term_months` int NOT NULL,
  `base_rate` decimal(6,4) NOT NULL COMMENT 'Floor APR',
  `max_rate` decimal(6,4) NOT NULL COMMENT 'Ceiling APR',
  `rate_type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'FIXED',
  `origination_fee_pct` decimal(5,4) NOT NULL DEFAULT '0.0000',
  `prepayment_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`loan_product_id`),
  UNIQUE KEY `uk_loan_product_code` (`product_code`),
  KEY `idx_lp_type` (`loan_type`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Loan product catalog with terms and rates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_products`
--

LOCK TABLES `loan_products` WRITE;
/*!40000 ALTER TABLE `loan_products` DISABLE KEYS */;
INSERT INTO `loan_products` VALUES (1,'MORT-30-FIX','30-Year Fixed Mortgage','MORTGAGE',100000.00,3000000.00,360,360,0.0685,0.0895,'FIXED',0.0100,0,'Traditional 30-year fixed-rate home purchase mortgage',1,'2026-04-14 08:03:09'),(2,'MORT-15-FIX','15-Year Fixed Mortgage','MORTGAGE',100000.00,2000000.00,180,180,0.0635,0.0835,'FIXED',0.0100,0,'Build equity faster with 15-year fixed rate',1,'2026-04-14 08:03:09'),(3,'MORT-7-1-ARM','7/1 ARM Mortgage','MORTGAGE',150000.00,2500000.00,360,360,0.0625,0.0825,'HYBRID_ARM',0.0075,0,'Fixed 7 years then annual adjustments',1,'2026-04-14 08:03:09'),(4,'MORT-5-1-ARM','5/1 ARM Mortgage','MORTGAGE',150000.00,2000000.00,360,360,0.0605,0.0805,'HYBRID_ARM',0.0075,0,'Fixed 5 years then adjusts annually',1,'2026-04-14 08:03:09'),(5,'HELOC-VAR','Home Equity Line of Credit','HELOC',25000.00,500000.00,60,120,0.0890,0.1200,'VARIABLE',0.0000,0,'Draw as needed up to credit limit, SOFR + margin',1,'2026-04-14 08:03:09'),(6,'HE-LOAN','Home Equity Loan','HOME_EQUITY_LOAN',25000.00,400000.00,60,180,0.0750,0.0990,'FIXED',0.0050,0,'Lump-sum fixed-rate second mortgage',1,'2026-04-14 08:03:09'),(7,'AUTO-NEW','New Vehicle Loan','AUTO',7500.00,100000.00,24,84,0.0599,0.1299,'FIXED',0.0000,0,'Finance a new vehicle up to 84 months',1,'2026-04-14 08:03:09'),(8,'AUTO-USED','Used Vehicle Loan','AUTO',5000.00,75000.00,24,72,0.0699,0.1499,'FIXED',0.0000,0,'Finance a pre-owned vehicle up to 72 months',1,'2026-04-14 08:03:09'),(9,'AUTO-REFI','Auto Refinance','AUTO',5000.00,75000.00,24,72,0.0649,0.1299,'FIXED',0.0000,0,'Refinance an existing auto loan at a better rate',1,'2026-04-14 08:03:09'),(10,'STU-UG-PRIV','Undergraduate Private Student Loan','STUDENT_UNDERGRADUATE',1000.00,100000.00,60,120,0.0499,0.1299,'FIXED',0.0100,0,'Private undergraduate student financing',1,'2026-04-14 08:03:09'),(11,'STU-GRAD-PRIV','Graduate Private Student Loan','STUDENT_GRADUATE',1000.00,150000.00,60,180,0.0549,0.1199,'FIXED',0.0100,0,'Graduate and professional school financing',1,'2026-04-14 08:03:09'),(12,'STU-REFI','Student Loan Refinance','STUDENT_REFINANCE',5000.00,250000.00,60,180,0.0479,0.1099,'FIXED',0.0000,0,'Refinance federal or private student loans',1,'2026-04-14 08:03:09'),(13,'PERS-UNSEC','Personal Loan - Unsecured','PERSONAL',1000.00,50000.00,12,84,0.0899,0.2599,'FIXED',0.0200,0,'No-collateral personal loan for any purpose',1,'2026-04-14 08:03:09'),(14,'PERS-SECURED','Personal Loan - Secured','PERSONAL_SECURED',2500.00,75000.00,12,84,0.0699,0.1599,'FIXED',0.0150,0,'CD or savings-secured personal loan',1,'2026-04-14 08:03:09');
/*!40000 ALTER TABLE `loan_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loans`
--

DROP TABLE IF EXISTS `loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loans` (
  `loan_id` bigint NOT NULL AUTO_INCREMENT,
  `loan_number` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` bigint NOT NULL,
  `loan_product_id` int NOT NULL,
  `disbursement_account_id` bigint DEFAULT NULL,
  `payment_account_id` bigint DEFAULT NULL,
  `branch_id` int DEFAULT NULL,
  `loan_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `loan_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'APPLICATION',
  `rate_type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'FIXED',
  `application_date` date NOT NULL DEFAULT (curdate()),
  `approval_date` date DEFAULT NULL,
  `origination_date` date DEFAULT NULL,
  `disbursement_date` date DEFAULT NULL,
  `maturity_date` date DEFAULT NULL,
  `original_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `outstanding_balance` decimal(14,2) NOT NULL DEFAULT '0.00',
  `interest_rate` decimal(7,4) NOT NULL DEFAULT '0.0000',
  `term_months` int NOT NULL DEFAULT '12',
  `monthly_payment_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `next_payment_date` date DEFAULT NULL,
  `last_payment_date` date DEFAULT NULL,
  `last_payment_amount` decimal(12,2) DEFAULT NULL,
  `total_paid` decimal(14,2) NOT NULL DEFAULT '0.00',
  `total_interest_paid` decimal(14,2) NOT NULL DEFAULT '0.00',
  `accrued_interest` decimal(12,2) NOT NULL DEFAULT '0.00',
  `origination_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `late_fee_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `days_past_due` int NOT NULL DEFAULT '0',
  `delinquency_date` date DEFAULT NULL,
  `loan_officer` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purpose` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`loan_id`),
  UNIQUE KEY `uk_loan_number` (`loan_number`),
  KEY `idx_loan_customer` (`customer_id`),
  KEY `idx_loan_status` (`loan_status`),
  KEY `idx_loan_type` (`loan_type`),
  KEY `idx_loan_next_payment` (`next_payment_date`),
  KEY `fk_loan_product` (`loan_product_id`),
  KEY `fk_loan_disb_acct` (`disbursement_account_id`),
  KEY `fk_loan_pay_acct` (`payment_account_id`),
  KEY `fk_loan_branch` (`branch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='All loan types - master loans table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loans`
--

LOCK TABLES `loans` WRITE;
/*!40000 ALTER TABLE `loans` DISABLE KEYS */;
INSERT INTO `loans` VALUES (1,'LN-00000035',1,1,1,1,1,'MORTGAGE','CURRENT','FIXED','2018-05-15','2018-06-01','2018-06-15',NULL,'2048-07-01',680000.00,624318.52,0.0425,360,3351.74,'2026-05-01','2026-04-01',3351.74,29018.94,18012.55,0.00,6800.00,0.00,0,NULL,'Skyler Price','Primary residence - Lincoln Park Chicago',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(2,'LN-00000067',2,7,4,4,3,'AUTO','CURRENT','FIXED','2022-09-28','2022-10-10','2022-10-15',NULL,'2027-10-15',58500.00,41280.15,0.0499,60,1101.98,'2026-05-15','2026-04-15',1101.98,40239.54,5939.54,0.00,0.00,0.00,0,NULL,'Reese Bell','New Tesla Model Y - Cupertino CA',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(3,'LN-00000036',3,13,6,6,4,'PERSONAL','CURRENT','FIXED','2023-02-15','2023-02-28','2023-03-01',NULL,'2026-03-01',20000.00,12441.80,0.1199,36,664.29,'2026-05-01','2026-04-01',664.29,16420.95,2420.95,0.00,400.00,0.00,0,NULL,'Alex Carter','Home renovation - kitchen and bathrooms',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(4,'LN-00000037',4,8,8,8,6,'AUTO','CURRENT','FIXED','2023-10-20','2023-11-01','2023-11-01',NULL,'2028-11-01',28900.00,24380.54,0.0799,60,585.92,'2026-05-01','2026-04-01',585.92,8785.39,2075.39,0.00,0.00,0.00,0,NULL,'Jordan Bennett','Used 2021 Honda CR-V - Miami FL',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(5,'LN-00000068',5,2,10,10,2,'MORTGAGE','CURRENT','FIXED','2015-02-01','2015-03-15','2015-04-01',NULL,'2030-04-01',1800000.00,1108293.18,0.0375,180,13104.52,'2026-05-01','2026-04-01',13104.52,391572.60,107572.60,0.00,18000.00,0.00,0,NULL,'Taylor Hayes','Primary residence - Upper East Side NY',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(6,'LN-00000069',5,6,10,10,2,'HOME_EQUITY_LOAN','CURRENT','FIXED','2020-05-01','2020-05-25','2020-06-01',NULL,'2035-06-01',250000.00,188500.00,0.0785,180,2369.96,'2026-05-01','2026-04-01',2369.96,146996.80,28996.80,0.00,1250.00,0.00,0,NULL,'Morgan Foster','Investment property renovation fund',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(7,'LN-00000070',6,10,13,13,1,'STUDENT_UNDERGRADUATE','CURRENT','FIXED','2022-07-20','2022-08-15','2022-09-01',NULL,'2032-09-01',45000.00,39288.46,0.0549,120,487.07,'2026-05-01','2026-04-01',487.07,3396.49,1696.49,0.00,450.00,0.00,0,NULL,'Casey Brooks','University of Chicago - Computer Science BS',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(8,'LN-00000038',7,2,15,15,3,'MORTGAGE','CURRENT','FIXED','2017-04-20','2017-05-15','2017-06-01',NULL,'2032-06-01',520000.00,269184.72,0.0395,180,3842.40,'2026-05-01','2026-04-01',3842.40,423104.64,77104.64,0.00,5200.00,0.00,0,NULL,'Riley Perry','Primary residence - Arcadia CA',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(9,'LN-00000039',8,7,17,17,5,'AUTO','CURRENT','FIXED','2021-07-15','2021-08-01','2021-08-01',NULL,'2028-08-01',42000.00,22188.09,0.0629,84,617.22,'2026-05-01','2026-04-01',617.22,29866.56,8266.56,0.00,0.00,0.00,0,NULL,'Avery Murphy','New Ford Explorer - Scottsdale AZ',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(10,'LN-00000071',9,10,19,19,6,'STUDENT_UNDERGRADUATE','CURRENT','FIXED','2021-07-10','2021-08-10','2021-09-01',NULL,'2031-09-01',38000.00,30425.64,0.0559,120,411.34,'2026-05-01','2026-04-01',411.34,5768.76,1368.76,0.00,380.00,0.00,0,NULL,'Cameron Reed','Tulane University - Business Administration BS',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(11,'LN-00000072',10,1,20,20,4,'MORTGAGE','CURRENT','FIXED','2019-10-15','2019-12-15','2020-01-01',NULL,'2050-01-01',385000.00,358244.93,0.0699,360,2560.73,'2026-05-01','2026-04-01',2560.73,33789.65,16290.65,0.00,3850.00,0.00,0,NULL,'Drew Bailey','Primary residence - Dallas TX',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09'),(12,'LN-00000073',10,13,20,20,4,'PERSONAL','CURRENT','FIXED','2024-01-20','2024-02-10','2024-02-15',NULL,'2027-02-15',15000.00,12188.40,0.1099,36,491.49,'2026-05-01','2026-04-01',491.49,7377.37,877.37,0.00,300.00,0.00,0,NULL,'Quinn Cooper','Debt consolidation',NULL,'2026-04-14 08:03:09','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mortgage_application_details`
--

DROP TABLE IF EXISTS `mortgage_application_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mortgage_application_details` (
  `detail_id` bigint NOT NULL AUTO_INCREMENT,
  `application_id` bigint NOT NULL,
  `property_address` varchar(500) NOT NULL,
  `property_city` varchar(100) NOT NULL,
  `property_state_code` varchar(2) NOT NULL,
  `property_zip` varchar(10) NOT NULL,
  `property_type` varchar(30) NOT NULL,
  `purchase_price` decimal(14,2) NOT NULL,
  `down_payment` decimal(14,2) NOT NULL,
  `ltv_ratio` decimal(5,2) DEFAULT NULL,
  `is_primary_residence` tinyint(1) NOT NULL DEFAULT '1',
  `is_first_time_buyer` tinyint(1) NOT NULL DEFAULT '0',
  `has_existing_mortgage` tinyint(1) NOT NULL DEFAULT '0',
  `co_borrower_name` varchar(200) DEFAULT NULL,
  `co_borrower_income` decimal(15,2) DEFAULT NULL,
  `annual_property_tax` decimal(10,2) DEFAULT NULL,
  `annual_insurance` decimal(10,2) DEFAULT NULL,
  `hoa_monthly_fee` decimal(8,2) DEFAULT NULL,
  `rate_type` varchar(15) NOT NULL DEFAULT 'FIXED',
  `preferred_closing_date` date DEFAULT NULL,
  `realtor_name` varchar(200) DEFAULT NULL,
  `additional_notes` text,
  PRIMARY KEY (`detail_id`),
  UNIQUE KEY `application_id` (`application_id`),
  CONSTRAINT `fk_mortapp_application` FOREIGN KEY (`application_id`) REFERENCES `loan_applications` (`application_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mortgage_application_details`
--

LOCK TABLES `mortgage_application_details` WRITE;
/*!40000 ALTER TABLE `mortgage_application_details` DISABLE KEYS */;
INSERT INTO `mortgage_application_details` VALUES (1,1,'127 Demo Avenue','Denver','IL','82925','SINGLE_FAMILY',380000.00,80000.00,78.95,1,1,0,'Parker Morgan',0.00,8500.00,2200.00,NULL,'FIXED','2026-06-15','Logan Gray','First-time buyer assistance requested'),(2,2,'128 Demo Avenue','Atlanta','IL','40707','SINGLE_FAMILY',420000.00,84000.00,80.00,1,0,1,'Devon Ward',0.00,9200.00,2400.00,NULL,'FIXED','2026-07-01','Skyler Price','Contingent on sale of existing property'),(3,3,'129 Demo Avenue','Denver','IL','82925','SINGLE_FAMILY',350000.00,70000.00,80.00,1,0,0,'Reese Bell',95000.00,7800.00,2100.00,650.00,'FIXED','2026-05-30','Alex Carter','HOA approval required'),(4,4,'130 Demo Avenue','Austin','IL','71609','CONDO',285000.00,57000.00,80.00,1,0,0,NULL,0.00,6100.00,1800.00,425.00,'FIXED','2026-06-01',NULL,'Pre-approval letter needed for offer'),(5,5,'131 Demo Avenue','Dallas','IL','16096','SINGLE_FAMILY',395000.00,79000.00,80.00,1,1,0,'Jordan Bennett',0.00,8800.00,2300.00,NULL,'FIXED','2026-06-20','Taylor Hayes','Rate lock requested for 60 days');
/*!40000 ALTER TABLE `mortgage_application_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mortgage_details`
--

DROP TABLE IF EXISTS `mortgage_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mortgage_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loan_id` bigint NOT NULL,
  `property_address` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `property_city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `property_state_code` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `property_zip` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `property_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SINGLE_FAMILY',
  `purchase_price` decimal(14,2) DEFAULT NULL,
  `appraised_value` decimal(14,2) DEFAULT NULL,
  `down_payment` decimal(14,2) DEFAULT NULL,
  `ltv_ratio` decimal(5,2) DEFAULT NULL,
  `pmi_required` tinyint(1) NOT NULL DEFAULT '0',
  `pmi_monthly_premium` decimal(8,2) DEFAULT NULL,
  `pmi_cancellation_date` date DEFAULT NULL,
  `escrow_required` tinyint(1) NOT NULL DEFAULT '0',
  `escrow_balance` decimal(10,2) DEFAULT NULL,
  `monthly_escrow_payment` decimal(8,2) DEFAULT NULL,
  `annual_property_tax` decimal(10,2) DEFAULT NULL,
  `annual_insurance_premium` decimal(10,2) DEFAULT NULL,
  `is_arm_loan` tinyint(1) NOT NULL DEFAULT '0',
  `arm_initial_period_months` int DEFAULT NULL,
  `arm_adjustment_cap` decimal(4,2) DEFAULT NULL,
  `arm_lifetime_cap` decimal(4,2) DEFAULT NULL,
  `arm_index_rate` decimal(6,4) DEFAULT NULL,
  `arm_margin` decimal(6,4) DEFAULT NULL,
  `next_adjustment_date` date DEFAULT NULL,
  `flood_zone` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_mort_loan` (`loan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mortgage-specific property and escrow details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mortgage_details`
--

LOCK TABLES `mortgage_details` WRITE;
/*!40000 ALTER TABLE `mortgage_details` DISABLE KEYS */;
INSERT INTO `mortgage_details` VALUES (1,1,'132 Demo Avenue','Chicago','IL','47714','CONDO',850000.00,920000.00,170000.00,80.00,0,NULL,NULL,1,18200.00,685.00,9800.00,2400.00,0,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-04-14 08:03:09'),(2,5,'133 Demo Avenue','Phoenix','NY','74350','CONDO',2400000.00,2800000.00,600000.00,75.00,0,NULL,NULL,1,42000.00,1850.00,32000.00,4800.00,0,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-04-14 08:03:09'),(3,6,'133 Demo Avenue','Phoenix','NY','74350','CONDO',2400000.00,2800000.00,0.00,68.00,0,NULL,NULL,1,38000.00,0.00,32000.00,4800.00,0,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-04-14 08:03:09'),(4,8,'134 Demo Avenue','Denver','CA','41877','SINGLE_FAMILY',675000.00,720000.00,155000.00,77.04,0,NULL,NULL,1,24600.00,680.00,11200.00,2800.00,0,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-04-14 08:03:09'),(5,11,'135 Demo Avenue','Dallas','TX','48072','CONDO',425000.00,445000.00,40000.00,90.59,1,145.00,NULL,1,14800.00,590.00,7800.00,1900.00,0,NULL,NULL,NULL,NULL,NULL,NULL,0,'2026-04-14 08:03:09');
/*!40000 ALTER TABLE `mortgage_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `states` (
  `state_code` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`state_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='US State reference data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
INSERT INTO `states` VALUES ('AK','Alaska'),('AL','Alabama'),('AR','Arkansas'),('AZ','Arizona'),('CA','California'),('CO','Colorado'),('CT','Connecticut'),('DE','Delaware'),('FL','Florida'),('GA','Georgia'),('HI','Hawaii'),('IA','Iowa'),('ID','Idaho'),('IL','Illinois'),('IN','Indiana'),('KS','Kansas'),('KY','Kentucky'),('LA','Louisiana'),('MA','Massachusetts'),('MD','Maryland'),('ME','Maine'),('MI','Michigan'),('MN','Minnesota'),('MO','Missouri'),('MS','Mississippi'),('MT','Montana'),('NC','North Carolina'),('ND','North Dakota'),('NE','Nebraska'),('NH','New Hampshire'),('NJ','New Jersey'),('NM','New Mexico'),('NV','Nevada'),('NY','New York'),('OH','Ohio'),('OK','Oklahoma'),('OR','Oregon'),('PA','Pennsylvania'),('RI','Rhode Island'),('SC','South Carolina'),('SD','South Dakota'),('TN','Tennessee'),('TX','Texas'),('UT','Utah'),('VA','Virginia'),('VT','Vermont'),('WA','Washington'),('WI','Wisconsin'),('WV','West Virginia'),('WY','Wyoming');
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_loan_details`
--

DROP TABLE IF EXISTS `student_loan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_loan_details` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loan_id` bigint NOT NULL,
  `institution_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ope_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `degree_program` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enrollment_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expected_graduation` date DEFAULT NULL,
  `repayment_plan` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'STANDARD',
  `loan_servicer` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `federal_loan_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `in_school_deferment` tinyint(1) NOT NULL DEFAULT '0',
  `deferment_end_date` date DEFAULT NULL,
  `grace_period_end` date DEFAULT NULL,
  `income_based_payment` decimal(10,2) DEFAULT NULL,
  `public_service_eligible` tinyint(1) NOT NULL DEFAULT '0',
  `qualifying_payments_made` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_loan` (`loan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Student loan education and repayment details';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_loan_details`
--

LOCK TABLES `student_loan_details` WRITE;
/*!40000 ALTER TABLE `student_loan_details` DISABLE KEYS */;
INSERT INTO `student_loan_details` VALUES (1,7,'Summit National Bank','OPE-00000074','Computer Science B.S.','FULL_TIME','2026-06-15','STANDARD','Summit National Bank',NULL,0,NULL,'2023-01-01',NULL,0,NULL,'2026-04-14 08:03:09'),(2,10,'First Harbor Bank','OPE-00000075','Business Administration B.S.','GRADUATED',NULL,'STANDARD','Summit National Bank',NULL,0,NULL,'2022-06-01',NULL,0,24,'2026-04-14 08:03:09');
/*!40000 ALTER TABLE `student_loan_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_categories`
--

DROP TABLE IF EXISTS `transaction_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_category_id` int DEFAULT NULL,
  `icon_class` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uk_cat_code` (`category_code`),
  KEY `fk_cat_parent` (`parent_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Transaction category hierarchy';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_categories`
--

LOCK TABLES `transaction_categories` WRITE;
/*!40000 ALTER TABLE `transaction_categories` DISABLE KEYS */;
INSERT INTO `transaction_categories` VALUES (1,'INCOME','Income',NULL,'bi-graph-up-arrow'),(2,'SALARY','Salary/Payroll',1,'bi-briefcase'),(3,'INVESTMENT','Investment Returns',1,'bi-currency-exchange'),(4,'TRANSFER_IN','Incoming Transfer',1,'bi-arrow-down-circle'),(5,'EXPENSE','Expense',NULL,'bi-graph-down-arrow'),(6,'HOUSING','Housing',5,'bi-house'),(7,'MORTGAGE_PMT','Mortgage Payment',6,'bi-building'),(8,'RENT','Rent',6,'bi-door-open'),(9,'UTILITIES','Utilities',5,'bi-lightning-charge'),(10,'FOOD','Food & Dining',5,'bi-cup-hot'),(11,'GROCERIES','Groceries',10,'bi-cart'),(12,'RESTAURANTS','Restaurants',10,'bi-shop'),(13,'TRANSPORT','Transportation',5,'bi-car-front'),(14,'AUTO_LOAN_PMT','Auto Loan Payment',13,'bi-speedometer2'),(15,'GAS','Gas & Fuel',13,'bi-fuel-pump'),(16,'HEALTHCARE','Healthcare',5,'bi-heart-pulse'),(17,'EDUCATION','Education',5,'bi-mortarboard'),(18,'STU_LOAN_PMT','Student Loan Payment',17,'bi-book'),(19,'ENTERTAINMENT','Entertainment',5,'bi-play-circle'),(20,'SHOPPING','Shopping',5,'bi-bag'),(21,'FEES','Bank Fees',NULL,'bi-exclamation-circle'),(22,'ATM','ATM Withdrawal',NULL,'bi-cash-stack'),(23,'LOAN','Loan',NULL,'bi-bank'),(24,'LOAN_DISB','Loan Disbursement',23,'bi-cash-coin'),(25,'LOAN_PMT','Loan Payment',23,'bi-arrow-up-circle');
/*!40000 ALTER TABLE `transaction_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` bigint NOT NULL AUTO_INCREMENT,
  `transaction_ref` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_id` bigint NOT NULL,
  `category_id` int DEFAULT NULL,
  `transaction_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `channel` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ONLINE_BANKING',
  `amount` decimal(18,2) NOT NULL,
  `balance_before` decimal(18,2) DEFAULT NULL,
  `balance_after` decimal(18,2) DEFAULT NULL,
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `merchant_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `merchant_city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_date` date NOT NULL DEFAULT (curdate()),
  `posted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  UNIQUE KEY `uk_txn_ref` (`transaction_ref`),
  KEY `idx_txn_account` (`account_id`),
  KEY `idx_txn_type` (`transaction_type`),
  KEY `idx_txn_status` (`transaction_status`),
  KEY `idx_txn_date` (`transaction_date`),
  KEY `fk_txn_category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='All financial transactions - append-only ledger';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,'TXN-00000076',1,2,'CREDIT','POSTED','ACH',15416.67,27033.33,42450.00,'USD','Direct Deposit - Goldman Sachs Payroll 04/01','Harbor Utilities','Seattle','2026-04-01','2026-04-01 08:00:00','2026-04-14 08:03:09'),(2,'TXN-00000077',1,7,'DEBIT','POSTED','ONLINE_BANKING',3351.74,42450.00,39098.26,'USD','Mortgage Payment - LN-00000035 Apr','Northwind Market','Houston','2026-04-02','2026-04-02 10:15:00','2026-04-14 08:03:09'),(3,'TXN-00000078',1,11,'DEBIT','POSTED','CARD',189.50,39098.26,38908.76,'USD','Whole Foods Market - Lincoln Park','Blue Oak Pharmacy','Houston','2026-04-05','2026-04-05 18:30:00','2026-04-14 08:03:09'),(4,'TXN-00000079',1,20,'DEBIT','POSTED','CARD',350.00,38908.76,38558.76,'USD','Nordstrom - Lincoln Park','Northwind Market','Houston','2026-04-07','2026-04-07 14:00:00','2026-04-14 08:03:09'),(5,'TXN-00000080',1,19,'DEBIT','POSTED','ONLINE_BANKING',425.00,38558.76,38133.76,'USD','Lyric Opera Chicago - Season Tickets','Northwind Market','Houston','2026-04-09','2026-04-09 09:00:00','2026-04-14 08:03:09'),(6,'TXN-00000081',1,12,'DEBIT','POSTED','CARD',280.25,38133.76,37853.51,'USD','Gibsons Bar and Steakhouse','Northwind Market','Houston','2026-04-10','2026-04-10 20:45:00','2026-04-14 08:03:09'),(7,'TXN-00000082',1,9,'DEBIT','POSTED','ONLINE_BANKING',285.00,37853.51,37568.51,'USD','ComEd Electric Bill - April 2026','Summit Fuel','Houston','2026-04-11','2026-04-11 07:00:00','2026-04-14 08:03:09'),(8,'TXN-00000083',1,6,'DEBIT','POSTED','ONLINE_BANKING',892.00,37568.51,36676.51,'USD','HOA Payment - 2401 N Lakeview Apr','Blue Oak Pharmacy','Houston','2026-04-11','2026-04-11 07:01:00','2026-04-14 08:03:09'),(9,'TXN-00000084',1,11,'DEBIT','POSTED','CARD',145.80,36676.51,36530.71,'USD','Marianos Fresh Market - Lincoln Park','Harbor Utilities','Houston','2026-04-12','2026-04-12 17:15:00','2026-04-14 08:03:09'),(10,'TXN-00000085',1,19,'DEBIT','POSTED','CARD',89.99,36530.71,36440.72,'USD','Netflix Premium + Apple TV+ Bundle','Northwind Market','Houston','2026-04-13','2026-04-13 00:00:00','2026-04-14 08:03:09'),(11,'TXN-00000086',1,7,'DEBIT','PENDING','ONLINE_BANKING',3351.74,36440.72,33088.98,'USD','Mortgage Auto-Pay - April 2026 Scheduled','Northwind Market','Houston','2026-04-14',NULL,'2026-04-14 08:03:09'),(12,'TXN-00000087',1,21,'DEBIT','POSTED','ONLINE_BANKING',5000.00,33088.98,28088.98,'USD','IRS Estimated Tax Payment Q1 2026','Northwind Market','Houston','2026-04-14','2026-04-14 11:00:00','2026-04-14 08:03:09'),(13,'TXN-00000088',2,3,'CREDIT','POSTED','SYSTEM',400.63,94599.37,95000.00,'USD','Monthly Interest Credit - High-Yield Savings Mar','Northwind Market','Houston','2026-04-01','2026-04-01 06:00:00','2026-04-14 08:03:09'),(14,'TXN-00000089',13,2,'CREDIT','POSTED','ACH',1500.00,1850.00,3350.00,'USD','Payroll - UChicago Library Research','City Transit','Houston','2026-04-01','2026-04-01 09:00:00','2026-04-14 08:03:09'),(15,'TXN-00000090',13,18,'DEBIT','POSTED','ONLINE_BANKING',487.07,3350.00,2862.93,'USD','Student Loan Payment LN-00000070','Northwind Market','Houston','2026-04-02','2026-04-02 08:00:00','2026-04-14 08:03:09'),(16,'TXN-00000091',13,17,'DEBIT','POSTED','CARD',125.00,2862.93,2737.93,'USD','UChicago Bookstore - Spring Textbooks','Harbor Utilities','Houston','2026-04-05','2026-04-05 12:00:00','2026-04-14 08:03:09'),(17,'TXN-00000092',13,11,'DEBIT','POSTED','CARD',48.50,2737.93,2689.43,'USD','Trader Joes Hyde Park','Northwind Market','Houston','2026-04-08','2026-04-08 16:00:00','2026-04-14 08:03:09'),(18,'TXN-00000093',13,8,'DEBIT','POSTED','ONLINE_BANKING',750.00,2689.43,1939.43,'USD','Rent Payment - Hyde Park Apt April','Blue Oak Pharmacy','Houston','2026-04-10','2026-04-10 10:00:00','2026-04-14 08:03:09'),(19,'TXN-00000094',13,19,'DEBIT','POSTED','CARD',35.99,1939.43,1903.44,'USD','Spotify Premium Student Plan','Northwind Market','Houston','2026-04-13','2026-04-13 00:00:00','2026-04-14 08:03:09'),(20,'TXN-00000095',13,9,'DEBIT','PENDING','ONLINE_BANKING',62.40,1903.44,1841.04,'USD','ComEd + Internet Bundle - April','City Transit','Houston','2026-04-14',NULL,'2026-04-14 08:03:09'),(21,'TXN-00000096',4,2,'CREDIT','POSTED','ACH',11833.33,12340.50,12340.50,'USD','Apple Inc Payroll - April 1 2026','Summit Fuel','Dallas','2026-04-01','2026-04-01 08:00:00','2026-04-14 08:03:09'),(22,'TXN-00000097',4,14,'DEBIT','POSTED','ONLINE_BANKING',1101.98,12340.50,11238.52,'USD','Auto Loan Payment LN-00000067','Northwind Market','Dallas','2026-04-03','2026-04-03 09:00:00','2026-04-14 08:03:09'),(23,'TXN-00000098',4,11,'DEBIT','POSTED','CARD',215.30,11238.52,11023.22,'USD','Safeway Cupertino Weekly Groceries','Northwind Market','Dallas','2026-04-06','2026-04-06 17:00:00','2026-04-14 08:03:09'),(24,'TXN-00000099',4,15,'DEBIT','POSTED','CARD',78.40,11023.22,10944.82,'USD','Shell Gas Station Cupertino','Blue Oak Pharmacy','Dallas','2026-04-08','2026-04-08 08:15:00','2026-04-14 08:03:09'),(25,'TXN-00000100',4,12,'DEBIT','POSTED','CARD',145.00,10944.82,10799.82,'USD','The Cheesecake Factory - San Jose','City Transit','Denver','2026-04-10','2026-04-10 19:30:00','2026-04-14 08:03:09'),(26,'TXN-00000101',10,2,'CREDIT','POSTED','WIRE',54166.67,185000.00,185000.00,'USD','Thornton Capital Wire - Monthly Draw','Pioneer Telecom','Seattle','2026-04-01','2026-04-01 09:00:00','2026-04-14 08:03:09'),(27,'TXN-00000102',10,7,'DEBIT','POSTED','ONLINE_BANKING',13104.52,185000.00,171895.48,'USD','Mortgage Payment LN-00000068 Apr','Northwind Market','Seattle','2026-04-02','2026-04-02 10:00:00','2026-04-14 08:03:09'),(28,'TXN-00000103',10,7,'DEBIT','POSTED','ONLINE_BANKING',2369.96,171895.48,169525.52,'USD','Home Equity Loan LN-00000069 Apr','Northwind Market','Seattle','2026-04-02','2026-04-02 10:05:00','2026-04-14 08:03:09'),(29,'TXN-00000104',10,19,'DEBIT','POSTED','CARD',850.00,169525.52,168675.52,'USD','Metropolitan Opera - Gala Tickets','Northwind Market','Seattle','2026-04-05','2026-04-05 12:00:00','2026-04-14 08:03:09'),(30,'TXN-00000105',10,12,'DEBIT','POSTED','CARD',1250.00,168675.52,167425.52,'USD','Le Bernardin - Business Dinner','Summit Fuel','Seattle','2026-04-08','2026-04-08 20:00:00','2026-04-14 08:03:09'),(31,'TXN-00000106',15,2,'CREDIT','POSTED','WIRE',18333.33,42600.00,42600.00,'USD','Zhang Technology Ventures - Salary Apr','Northwind Market','Chicago','2026-04-01','2026-04-01 08:00:00','2026-04-14 08:03:09'),(32,'TXN-00000107',15,7,'DEBIT','POSTED','ONLINE_BANKING',3842.40,42600.00,38757.60,'USD','Mortgage Payment LN-00000038 Apr','Northwind Market','Chicago','2026-04-02','2026-04-02 10:00:00','2026-04-14 08:03:09'),(33,'TXN-00000108',15,20,'DEBIT','POSTED','CARD',2200.00,38757.60,36557.60,'USD','Best Buy - MacBook Pro Business','Blue Oak Pharmacy','Chicago','2026-04-07','2026-04-07 14:00:00','2026-04-14 08:03:09'),(34,'TXN-00000109',15,12,'DEBIT','POSTED','CARD',320.00,36557.60,36237.60,'USD','Nobu Los Angeles - Client Dinner','Summit Fuel','Atlanta','2026-04-09','2026-04-09 20:30:00','2026-04-14 08:03:09'),(35,'TXN-00000110',17,2,'CREDIT','POSTED','ACH',9166.67,9340.00,9340.00,'USD','Banner Health Payroll - April 1 2026','Summit Fuel','Chicago','2026-04-01','2026-04-01 09:00:00','2026-04-14 08:03:09'),(36,'TXN-00000111',17,14,'DEBIT','POSTED','ONLINE_BANKING',617.22,9340.00,8722.78,'USD','Auto Loan Payment LN-00000039','Northwind Market','Chicago','2026-04-03','2026-04-03 09:00:00','2026-04-14 08:03:09'),(37,'TXN-00000112',17,16,'DEBIT','POSTED','CARD',185.00,8722.78,8537.78,'USD','Mayo Clinic Scottsdale - Copay','Summit Fuel','Chicago','2026-04-05','2026-04-05 10:00:00','2026-04-14 08:03:09'),(38,'TXN-00000113',17,11,'DEBIT','POSTED','CARD',210.40,8537.78,8327.38,'USD','Sprouts Farmers Market Scottsdale','Pioneer Telecom','Chicago','2026-04-07','2026-04-07 17:00:00','2026-04-14 08:03:09'),(39,'TXN-00000114',19,2,'CREDIT','POSTED','ACH',1250.00,950.25,950.25,'USD','Tulane University TA Stipend - April','Pioneer Telecom','Seattle','2026-04-01','2026-04-01 09:00:00','2026-04-14 08:03:09'),(40,'TXN-00000115',19,18,'DEBIT','POSTED','ONLINE_BANKING',411.34,950.25,538.91,'USD','Student Loan Payment LN-00000071','Northwind Market','Seattle','2026-04-02','2026-04-02 08:00:00','2026-04-14 08:03:09'),(41,'TXN-00000116',19,11,'DEBIT','POSTED','CARD',55.20,538.91,483.71,'USD','Rouses Markets Magazine St','Pioneer Telecom','Seattle','2026-04-06','2026-04-06 16:00:00','2026-04-14 08:03:09'),(42,'TXN-00000117',19,12,'DEBIT','POSTED','CARD',28.50,483.71,455.21,'USD','Caf Du Monde Beignets','City Transit','Seattle','2026-04-09','2026-04-09 09:00:00','2026-04-14 08:03:09'),(43,'TXN-00000118',20,2,'CREDIT','POSTED','ACH',10833.33,18500.00,18500.00,'USD','AT&T Payroll Direct Deposit - April 1','Northwind Market','Chicago','2026-04-01','2026-04-01 08:00:00','2026-04-14 08:03:09'),(44,'TXN-00000119',20,7,'DEBIT','POSTED','ONLINE_BANKING',2560.73,18500.00,15939.27,'USD','Mortgage Payment LN-00000072 Apr','Northwind Market','Chicago','2026-04-02','2026-04-02 10:00:00','2026-04-14 08:03:09'),(45,'TXN-00000120',20,25,'DEBIT','POSTED','ONLINE_BANKING',491.49,15939.27,15447.78,'USD','Personal Loan Payment LN-00000073','Northwind Market','Chicago','2026-04-02','2026-04-02 10:05:00','2026-04-14 08:03:09'),(46,'TXN-00000121',20,11,'DEBIT','POSTED','CARD',175.60,15447.78,15272.18,'USD','Central Market Dallas Weekly Groceries','Pioneer Telecom','Chicago','2026-04-05','2026-04-05 11:00:00','2026-04-14 08:03:09'),(47,'TXN-00000122',20,15,'DEBIT','POSTED','CARD',82.15,15272.18,15190.03,'USD','Exxon Gas Station I-35','Northwind Market','Chicago','2026-04-08','2026-04-08 07:30:00','2026-04-14 08:03:09'),(48,'TXN-00000123',20,12,'DEBIT','POSTED','CARD',95.00,15190.03,15095.03,'USD','Milos Greek Restaurant Dallas','Summit Fuel','Chicago','2026-04-10','2026-04-10 19:00:00','2026-04-14 08:03:09'),(49,'TXN-00000124',6,2,'CREDIT','POSTED','ACH',6500.00,4280.75,4280.75,'USD','Chevron Corporation Payroll - April','Blue Oak Pharmacy','Phoenix','2026-04-01','2026-04-01 08:00:00','2026-04-14 08:03:09'),(50,'TXN-00000125',6,25,'DEBIT','POSTED','ONLINE_BANKING',664.29,4280.75,3616.46,'USD','Personal Loan Payment LN-00000036','Northwind Market','Phoenix','2026-04-02','2026-04-02 09:00:00','2026-04-14 08:03:09');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wire_transfers`
--

DROP TABLE IF EXISTS `wire_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wire_transfers` (
  `wire_id` bigint NOT NULL AUTO_INCREMENT,
  `wire_reference` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_account_id` bigint NOT NULL,
  `transfer_type` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transfer_status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INITIATED',
  `amount` decimal(18,2) NOT NULL,
  `fee_amount` decimal(8,2) NOT NULL DEFAULT '0.00',
  `currency_code` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `beneficiary_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `beneficiary_account` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `beneficiary_bank` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `beneficiary_routing` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `beneficiary_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `swift_code` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iban` varchar(34) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purpose_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `memo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scheduled_date` date NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wire_id`),
  UNIQUE KEY `uk_wire_ref` (`wire_reference`),
  KEY `idx_wire_source` (`source_account_id`),
  KEY `idx_wire_status` (`transfer_status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wire transfers and ACH transactions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wire_transfers`
--

LOCK TABLES `wire_transfers` WRITE;
/*!40000 ALTER TABLE `wire_transfers` DISABLE KEYS */;
INSERT INTO `wire_transfers` VALUES (1,'WIRE-00000126',10,'DOMESTIC_WIRE','COMPLETED',25000.00,25.00,'USD','Morgan Foster','BEN-00000127','Cedar Trust Bank','844967518','136 Demo Avenue',NULL,NULL,'INVEST','Q1 Investment Portfolio Transfer','2026-04-01','2026-04-01 14:30:00','2026-04-14 08:03:09'),(2,'WIRE-00000128',2,'DOMESTIC_WIRE','COMPLETED',10000.00,25.00,'USD','Casey Brooks','BEN-00000129','Summit National Bank','844967518','137 Demo Avenue',NULL,NULL,'FAMILY','Wedding anniversary gift wire','2026-04-07','2026-04-07 11:00:00','2026-04-14 08:03:09'),(3,'WIRE-00000130',15,'INTERNATIONAL_WIRE','COMPLETED',50000.00,45.00,'USD','Riley Perry','BEN-00000131','Union Metro Bank','448777711',NULL,'DEMOUS33','DE00 0000 0000 0000 0000 00','TRADE','Technology vendor payment - Q2 invoice','2026-04-10','2026-04-10 09:00:00','2026-04-14 08:03:09'),(4,'WIRE-00000132',20,'DOMESTIC_WIRE','PENDING',5000.00,15.00,'USD','Avery Murphy','BEN-00000133','Summit National Bank','803081292','138 Demo Avenue',NULL,NULL,'FAMILY','Family support transfer','2026-04-15',NULL,'2026-04-14 08:03:09');
/*!40000 ALTER TABLE `wire_transfers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-20 14:40:08
