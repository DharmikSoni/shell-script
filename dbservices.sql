-- MySQL dump 10.13  Distrib 5.7.25, for Linux (x86_64)
--
-- Host: localhost    Database: db_services
-- ------------------------------------------------------
-- Server version	5.7.25-0ubuntu0.16.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authentication`
--

DROP TABLE IF EXISTS `authentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authentication` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(80) NOT NULL,
  `publickey` varchar(500) NOT NULL,
  `privatekey` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `authentication_ibfk_1` (`clientID`),
  CONSTRAINT `authentication_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `benchmarking`
--

DROP TABLE IF EXISTS `benchmarking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `benchmarking` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `commandID` int(18) NOT NULL,
  `clientID` bigint(80) NOT NULL,
  `command` varchar(500) NOT NULL,
  `label` varchar(500) NOT NULL,
  `status` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(256) NOT NULL,
  `security_qn` varchar(50) NOT NULL,
  `answer` varchar(50) NOT NULL,
  `company_name` varchar(256) NOT NULL,
  `designation` varchar(256) NOT NULL,
  `account_type` varchar(300) DEFAULT NULL,
  `account_status` varchar(10) DEFAULT NULL,
  `random_Text` varchar(30) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `renew_time` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cmd`
--

DROP TABLE IF EXISTS `cmd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cmd` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `commandID` bigint(18) NOT NULL,
  `topic` varchar(500) NOT NULL,
  `discription` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `file_upload`
--

DROP TABLE IF EXISTS `file_upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_upload` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(20) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_name` varchar(500) NOT NULL,
  `file_size` varchar(500) NOT NULL,
  `log_type` varchar(500) NOT NULL,
  `status` int(10) NOT NULL,
  `UID` varchar(200) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ftp`
--

DROP TABLE IF EXISTS `ftp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ftp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(18) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(256) NOT NULL,
  `flag` int(11) DEFAULT NULL,
  `time_stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_ftp` (`clientID`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ipprofile`
--

DROP TABLE IF EXISTS `ipprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipprofile` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(30) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `logtype` varchar(20) NOT NULL,
  `errorcode` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_action_details`
--

DROP TABLE IF EXISTS `log_action_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_action_details` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `action_id` bigint(8) NOT NULL,
  `action_details` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `action_id` (`action_id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logagent`
--

DROP TABLE IF EXISTS `logagent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logagent` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(18) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `logaibfk_1` (`clientID`),
  CONSTRAINT `logaibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logdetails`
--

DROP TABLE IF EXISTS `logdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logdetails` (
  `id` bigint(18) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `action` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_logdetails` (`clientID`),
  CONSTRAINT `fk_logdetails` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `logsdata` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notification` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(18) NOT NULL,
  `title` varchar(500) NOT NULL,
  `message` varchar(1500) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `amt` float(10,2) NOT NULL,
  `cc` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `cm` int(11) NOT NULL,
  `txn_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `item_name` int(11) NOT NULL,
  `item_number` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `st` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `tx` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portinfo`
--

DROP TABLE IF EXISTS `portinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portinfo` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(30) NOT NULL,
  `portNumber` bigint(20) DEFAULT NULL,
  `portStatus` int(11) NOT NULL,
  `scanType` int(11) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `platform` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `clientID` (`clientID`),
  CONSTRAINT `portinfo_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portscanner`
--

DROP TABLE IF EXISTS `portscanner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portscanner` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(30) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `platform` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_constraint_clientID_ip` (`clientID`,`ip`),
  CONSTRAINT `portscanner_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `portscannerlog`
--

DROP TABLE IF EXISTS `portscannerlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portscannerlog` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(30) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `scantime` varchar(100) NOT NULL,
  `logs` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `clientID` (`clientID`),
  CONSTRAINT `portscannerlog_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `image` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `price` float(10,2) NOT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scansystem`
--

DROP TABLE IF EXISTS `scansystem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scansystem` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(30) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `scanDuration` int(11) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_constraint_clientID_ip` (`clientID`,`ip`),
  CONSTRAINT `scansystem_ibfk_1` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_config`
--

DROP TABLE IF EXISTS `tbl_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_config` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(30) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `command` varchar(1000) DEFAULT NULL,
  `result` varchar(20000) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tbl_configfk` (`clientID`),
  CONSTRAINT `tbl_configfk` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unauthorisedaccess`
--

DROP TABLE IF EXISTS `unauthorisedaccess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unauthorisedaccess` (
  `id` bigint(30) NOT NULL AUTO_INCREMENT,
  `clientID` bigint(20) NOT NULL,
  `ip` varchar(64) NOT NULL,
  `method` varchar(10) NOT NULL,
  `locale` varchar(60) NOT NULL,
  `log` varchar(300) NOT NULL,
  `responseCode` int(8) NOT NULL,
  `requestURL` varchar(100) NOT NULL,
  `timestamp` varchar(60) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_unauthorisedaccess` (`clientID`),
  CONSTRAINT `fk_unauthorisedaccess` FOREIGN KEY (`clientID`) REFERENCES `clients` (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-03-16 17:39:13
