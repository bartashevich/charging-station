-- MySQL dump 10.13  Distrib 5.7.23, for Linux (x86_64)
--
-- Host: localhost    Database: thethingsnetwork
-- ------------------------------------------------------
-- Server version	5.7.23

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
-- Temporary table structure for view `GET_ACTIVE_STATIONS`
--

DROP TABLE IF EXISTS `GET_ACTIVE_STATIONS`;
/*!50001 DROP VIEW IF EXISTS `GET_ACTIVE_STATIONS`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `GET_ACTIVE_STATIONS` AS SELECT 
 1 AS `station_id`,
 1 AS `update_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `GET_CALLBACKS`
--

DROP TABLE IF EXISTS `GET_CALLBACKS`;
/*!50001 DROP VIEW IF EXISTS `GET_CALLBACKS`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `GET_CALLBACKS` AS SELECT 
 1 AS `callback_url`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `GET_DEVICES`
--

DROP TABLE IF EXISTS `GET_DEVICES`;
/*!50001 DROP VIEW IF EXISTS `GET_DEVICES`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `GET_DEVICES` AS SELECT 
 1 AS `dev_eui`,
 1 AS `dev_id`,
 1 AS `description`,
 1 AS `app_id`,
 1 AS `latitude`,
 1 AS `longitude`,
 1 AS `altitude`,
 1 AS `dev_state`,
 1 AS `charging_state`,
 1 AS `charging_socket_location`,
 1 AS `charging_percentage`,
 1 AS `parking_state`,
 1 AS `update_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `GET_STATIONS`
--

DROP TABLE IF EXISTS `GET_STATIONS`;
/*!50001 DROP VIEW IF EXISTS `GET_STATIONS`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `GET_STATIONS` AS SELECT 
 1 AS `station_id`,
 1 AS `dev_eui`,
 1 AS `station_state`,
 1 AS `station_type`,
 1 AS `charging_state`,
 1 AS `charging_percentage`,
 1 AS `charging_consumption_periodic`,
 1 AS `charging_consumption_total`,
 1 AS `charging_socket_location`,
 1 AS `charging_socket_type`,
 1 AS `charging_power`,
 1 AS `parking_state`,
 1 AS `update_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `callbacks`
--

DROP TABLE IF EXISTS `callbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `callbacks` (
  `id` int(11) NOT NULL,
  `callback_url` varchar(255) NOT NULL,
  `devices` varchar(255) DEFAULT 'all',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callbacks`
--

LOCK TABLES `callbacks` WRITE;
/*!40000 ALTER TABLE `callbacks` DISABLE KEYS */;
INSERT INTO `callbacks` VALUES (1,'http://206.189.26.231:1717/api/stations/log/','all');
/*!40000 ALTER TABLE `callbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `dev_eui` varchar(16) NOT NULL,
  `dev_id` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `app_id` varchar(255) NOT NULL,
  `latitude` double NOT NULL DEFAULT '0',
  `longitude` double NOT NULL DEFAULT '0',
  `altitude` double NOT NULL DEFAULT '0',
  `dev_state` varchar(255) DEFAULT 'out-of-service',
  `charging_state` varchar(255) DEFAULT 'unknown',
  `charging_socket_location` varchar(255) DEFAULT 'unknown',
  `charging_percentage` double(3,0) DEFAULT '0',
  `charging_consumption_periodic` double DEFAULT '0',
  `charging_consumption_total` double DEFAULT '0',
  `parking_state` varchar(255) DEFAULT 'unknown',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dev_eui`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES ('70B3D54995F59E76','charging-station-1','Station near University of Aveiro','electric-vehicle-charging-station-ua',40.634174,-8.65974,10,'out-of-service','not-charging','station',0,0,0,'free','2018-12-03 16:57:46'),('70B3D549988A54E5','it-device','Charging Station at Costa Nova','electric-vehicle-charging-station-ua',40.61288,-8.75271,3,'out-of-service','unknown','unknown',0,0,0,'unknown','2018-12-03 11:23:30');
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `dev_eui` varchar(255) NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`dev_eui`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES ('70B3D54995F59E76','2018-11-07 15:30:46'),('70B3D549988A54E5','2018-12-03 23:26:16');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stations` (
  `station_id` varchar(255) NOT NULL,
  `station_number` int(11) DEFAULT NULL,
  `dev_eui` varchar(255) NOT NULL,
  `station_state` varchar(255) NOT NULL DEFAULT 'unknown',
  `station_type` varchar(255) NOT NULL DEFAULT 'unknown',
  `charging_state` varchar(255) NOT NULL DEFAULT 'unknown',
  `charging_percentage` float NOT NULL DEFAULT '0',
  `charging_consumption_periodic` double DEFAULT '0',
  `charging_consumption_total` double DEFAULT '0',
  `charging_socket_location` varchar(255) NOT NULL DEFAULT 'unknown',
  `charging_socket_type` varchar(255) DEFAULT 'unknown',
  `charging_power` double(11,0) DEFAULT '0',
  `parking_state` varchar(255) NOT NULL DEFAULT 'unknown',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`station_id`,`dev_eui`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES ('70B3D54995F59E76_1',1,'70B3D54995F59E76','out-of-service','normal','not-charging',100,1,50,'unknown','Type 2',22,'occupied','2018-11-10 14:30:12'),('70B3D54995F59E76_2',2,'70B3D54995F59E76','out-of-service','wireless','not-charging',38,1,19,'unknown','BMW Pad',3,'occupied','2018-11-10 14:30:12'),('70B3D549988A54E5_1',1,'70B3D549988A54E5','available','socket','not-charging',85,15,75,'station','CHAdeMO',50,'free','2018-12-03 23:03:03'),('70B3D549988A54E5_2',2,'70B3D549988A54E5','available','wireless','not-charging',25,15,15,'station','ChargeIT Pad',10,'free','2018-12-03 23:03:03');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'thethingsnetwork'
--
/*!50003 DROP FUNCTION IF EXISTS `DEL_CALLBACK_URL` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `DEL_CALLBACK_URL`(CALLBACK_NUMBER int) RETURNS int(11)
BEGIN
	SELECT COUNT(1) INTO @found_callback
	FROM `thethingsnetwork`.`callbacks`
	WHERE `callbacks`.`id` = CALLBACK_NUMBER;

	IF @found_callback = 1 THEN
		DELETE FROM `thethingsnetwork`.`callbacks`
		WHERE `callbacks`.`id` = CALLBACK_NUMBER;
	END IF;

	RETURN @found_callback;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `DEVICE_EXISTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `DEVICE_EXISTS`(DEV_EUI varchar(255)) RETURNS int(11)
BEGIN
	SET @device_exists = 0;

	SELECT COUNT(1) INTO @found
	FROM `thethingsnetwork`.`devices`
	WHERE `devices`.`dev_eui` = DEV_EUI;
	IF @found > 0 THEN
		SET @device_exists = 1;
	END IF;

	RETURN @device_exists;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GET_CALLBACK_URL` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GET_CALLBACK_URL`(CALLBACK_NUMBER int) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN

	SELECT `callbacks`.`callback_url` INTO @callback_url
	FROM `thethingsnetwork`.`callbacks`
	WHERE `callbacks`.`id` = CALLBACK_NUMBER;

	return @callback_url;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GET_DEVICE_EUI` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GET_DEVICE_EUI`(STATION_ID varchar(255)) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN

	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 0 THEN
		RETURN 'station-not-found';
	END IF;

	SELECT `stations`.`dev_eui` INTO @dev_eui
	FROM `thethingsnetwork`.`stations`
	WHERE `stations`.`station_id` = STATION_ID;

	return @dev_eui;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GET_DEVICE_ID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GET_DEVICE_ID`(STATION_ID varchar(255)) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN

	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 0 THEN
		RETURN 'station-not-found';
	END IF;

	SELECT `devices`.`dev_id` INTO @device_id 
	FROM `thethingsnetwork`.`stations` INNER JOIN `thethingsnetwork`.`devices` ON `stations`.`dev_eui` = `devices`.`dev_eui`
	WHERE `stations`.`station_id` = STATION_ID;

	return @device_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GET_STATION_NUMBER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GET_STATION_NUMBER`(STATION_ID varchar(255)) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN

	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 0 THEN
		RETURN 'station-not-found';
	END IF;

	SELECT `stations`.`station_number` INTO @station_number
	FROM `thethingsnetwork`.`stations`
	WHERE `stations`.`station_id` = STATION_ID;

	return @station_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GET_STATION_STATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GET_STATION_STATE`(STATION_ID varchar(255)) RETURNS varchar(255) CHARSET latin1
    DETERMINISTIC
BEGIN

	SELECT `stations`.`station_state` INTO @station_state
	FROM `thethingsnetwork`.`stations`
	WHERE `stations`.`station_id` = STATION_ID;

	RETURN @station_state;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `PERFORM_REQUEST` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `PERFORM_REQUEST`(STATION_ID varchar(255), DEVICE_EUI varchar(255), DELAY int) RETURNS varchar(255) CHARSET latin1
BEGIN
	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 0 THEN
		RETURN 'station-not-found';
	END IF;

	SET @device_exists = DEVICE_EXISTS(DEVICE_EUI);

	IF @device_exists = 0 THEN
		RETURN 'device-not-found';
	END IF;

	SET @station_state = GET_STATION_STATE(STATION_ID);

	IF @station_state = 'out-of-service' THEN
		RETURN 'station-is-out-of-service';
	END IF;

	SET @request_exists = REQUEST_EXISTS(DEVICE_EUI);

	IF @request_exists = 0 THEN
		INSERT INTO `thethingsnetwork`.`requests`
		VALUES (DEVICE_EUI, CURRENT_TIMESTAMP());

		RETURN 'success';
	ELSE
		SELECT COUNT(1) INTO @found
		FROM `thethingsnetwork`.`requests`
		WHERE `requests`.`dev_eui` = DEVICE_EUI AND TIMESTAMPDIFF(SECOND, `requests`.`last_update`, CURRENT_TIMESTAMP()) > DELAY;

		IF @found > 0 THEN
			UPDATE `thethingsnetwork`.`requests`
			SET `requests`.`last_update` = CURRENT_TIMESTAMP()
			WHERE `requests`.`dev_eui` = DEVICE_EUI;

			RETURN 'success';
		ELSE
			RETURN 'too-many-requests';
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `REQUEST_EXISTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `REQUEST_EXISTS`(DEVICE_EUI varchar(255)) RETURNS int(11)
BEGIN
	SET @request_exists = 0;

	SELECT COUNT(1) INTO @found
	FROM `thethingsnetwork`.`requests`
	WHERE `requests`.`dev_eui` = DEVICE_EUI;
	IF @found > 0 THEN
		SET @request_exists = 1;
	END IF;

	RETURN @request_exists;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `SET_CALLBACK_URL` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `SET_CALLBACK_URL`(CALLBACK_NUMBER int, CALLBACK_URL varchar(255)) RETURNS int(11)
BEGIN
	SELECT COUNT(1) INTO @found_callback
	FROM `thethingsnetwork`.`callbacks`
	WHERE `callbacks`.`id` = CALLBACK_NUMBER;

	IF @found_callback = 0 THEN
		INSERT INTO `thethingsnetwork`.`callbacks`
		VALUES (CALLBACK_NUMBER, CALLBACK_URL, 'all');
	ELSE
		UPDATE `thethingsnetwork`.`callbacks`
		SET `callbacks`.`callback_url` = CALLBACK_URL
		WHERE `callbacks`.`id` = CALLBACK_NUMBER;
	END IF;

	RETURN @found_callback;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `STATION_EXISTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `STATION_EXISTS`(STATION_ID varchar(255)) RETURNS int(11)
BEGIN
	SET @station_exists = 0;

	SELECT COUNT(1) INTO @found
	FROM `thethingsnetwork`.`stations`
	WHERE `stations`.`station_id` = STATION_ID;
	IF @found > 0 THEN
		SET @station_exists = 1;
	END IF;

	RETURN @station_exists;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ADD_UPDATE_DEVICE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_UPDATE_DEVICE`(DEV_EUI varchar(255), APP_ID varchar(255), DEV_ID varchar(255), LATITUDE double, LONGITUDE double, ALTITUDE double, DESCRIPTION varchar(255))
BEGIN
	SET @device_exists = DEVICE_EXISTS(DEV_EUI);

	IF @device_exists = 1 THEN
		UPDATE `thethingsnetwork`.`devices`
		SET `devices`.`app_id`=APP_ID,
			`devices`.`dev_id`=DEV_ID,
			`devices`.`latitude`=LATITUDE,
			`devices`.`longitude`=LONGITUDE,
			`devices`.`altitude`=ALTITUDE,
			`devices`.`description`=DESCRIPTION,
			`devices`.`update_time`=CURRENT_TIMESTAMP()
		WHERE `dev_eui`=DEV_EUI;
	ELSE
		INSERT INTO `thethingsnetwork`.`devices` (`devices`.`dev_eui`, `devices`.`app_id`, `devices`.`dev_id`, `devices`.`latitude`, `devices`.`longitude`, `devices`.`altitude`, `devices`.`description`)
		VALUES (DEV_EUI, APP_ID, DEV_ID, LATITUDE, LONGITUDE, ALTITUDE, DESCRIPTION);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEVICE_ACKNOWLEDGEMENT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DEVICE_ACKNOWLEDGEMENT`(DEV_EUI varchar(255), DEV_STATE varchar(255))
BEGIN
	SET @device_exists = DEVICE_EXISTS(DEV_EUI);

	IF @device_exists = 1 THEN
		UPDATE `thethingsnetwork`.`devices`
		SET `devices`.`dev_state`=DEV_STATE,
			`devices`.`update_time`=CURRENT_TIMESTAMP()
		WHERE `devices`.`dev_eui`=DEV_EUI;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEVICE_STATE_CHANGE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DEVICE_STATE_CHANGE`(DEV_EUI varchar(255), DEV_STATE varchar(255), PARKING_STATE varchar(255), CHARGING_STATE varchar(255), CHARGING_SOCKER_LOCATION varchar(255), CHARGING_PERCENTAGE double, CHARGING_CONSUMPTION_PERIODIC double, CHARGING_CONSUMPTION_TOTAL double)
BEGIN
	SET @device_exists = DEVICE_EXISTS(DEV_EUI);

	IF @device_exists = 1 THEN
		UPDATE `thethingsnetwork`.`devices`
		SET `devices`.`dev_state`=DEV_STATE,
			`devices`.`parking_state`=PARKING_STATE,
			`devices`.`charging_state`=CHARGING_STATE,
			`devices`.`charging_socket_location`=CHARGING_SOCKER_LOCATION,
			`devices`.`charging_percentage`=CHARGING_PERCENTAGE,
			`devices`.`charging_consumption_periodic`=CHARGING_CONSUMPTION_PERIODIC,
			`devices`.`charging_consumption_total`=CHARGING_CONSUMPTION_TOTAL,
			`devices`.`update_time`=CURRENT_TIMESTAMP()
		WHERE `devices`.`dev_eui`=DEV_EUI;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `PUT_STATION_OUT_OF_SERVICE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PUT_STATION_OUT_OF_SERVICE`(STATION_ID varchar(255))
BEGIN
	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 1 THEN
		UPDATE `thethingsnetwork`.`stations`
		SET `stations`.`station_state`="out-of-service",
			`stations`.`update_time`=CURRENT_TIMESTAMP()
		WHERE `stations`.`station_id`=STATION_ID;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `STATION_CHARGED_STATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `STATION_CHARGED_STATE`(STATION_ID varchar(255), STATION_STATE varchar(255), PARKING_STATE varchar(255), CHARGING_SOCKET_LOCATION varchar(255), CHARGING_STATE varchar(255), CHARGING_PERCENTAGE double, CHARGING_CONSUMPTION_PERIODIC double, CHARGING_CONSUMPTION_TOTAL double)
BEGIN
	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 1 THEN
		UPDATE `thethingsnetwork`.`stations`
		SET `stations`.`station_state`=STATION_STATE,
			`stations`.`parking_state`=PARKING_STATE,
			`stations`.`charging_socket_location`=CHARGING_SOCKET_LOCATION,
			`stations`.`charging_state`=CHARGING_STATE,
			`stations`.`charging_percentage`=CHARGING_PERCENTAGE,
			`stations`.`charging_consumption_periodic`=CHARGING_CONSUMPTION_PERIODIC,
			`stations`.`charging_consumption_total`=CHARGING_CONSUMPTION_TOTAL,
			`stations`.`update_time`=CURRENT_TIMESTAMP()
		WHERE `stations`.`station_id`=STATION_ID;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `STATION_STATE_CHANGE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `STATION_STATE_CHANGE`(STATION_ID varchar(255), STATION_STATE varchar(255), PARKING_STATE varchar(255), CHARGING_SOCKET_LOCATION varchar(255), CHARGING_STATE varchar(255))
BEGIN
	SET @station_exists = STATION_EXISTS(STATION_ID);

	IF @station_exists = 1 THEN
		UPDATE `thethingsnetwork`.`stations`
		SET `stations`.`station_state`=STATION_STATE,
			`stations`.`parking_state`=PARKING_STATE,
			`stations`.`charging_socket_location`=CHARGING_SOCKET_LOCATION,
			`stations`.`charging_state`=CHARGING_STATE,
			`stations`.`update_time`=CURRENT_TIMESTAMP()
		WHERE `stations`.`station_id`=STATION_ID;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `GET_ACTIVE_STATIONS`
--

/*!50001 DROP VIEW IF EXISTS `GET_ACTIVE_STATIONS`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `GET_ACTIVE_STATIONS` AS select `stations`.`station_id` AS `station_id`,`stations`.`update_time` AS `update_time` from `stations` where (`stations`.`station_state` <> 'out-of-service') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `GET_CALLBACKS`
--

/*!50001 DROP VIEW IF EXISTS `GET_CALLBACKS`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `GET_CALLBACKS` AS select `callbacks`.`callback_url` AS `callback_url` from `callbacks` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `GET_DEVICES`
--

/*!50001 DROP VIEW IF EXISTS `GET_DEVICES`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `GET_DEVICES` AS select `devices`.`dev_eui` AS `dev_eui`,`devices`.`dev_id` AS `dev_id`,`devices`.`description` AS `description`,`devices`.`app_id` AS `app_id`,`devices`.`latitude` AS `latitude`,`devices`.`longitude` AS `longitude`,`devices`.`altitude` AS `altitude`,`devices`.`dev_state` AS `dev_state`,`devices`.`charging_state` AS `charging_state`,`devices`.`charging_socket_location` AS `charging_socket_location`,`devices`.`charging_percentage` AS `charging_percentage`,`devices`.`parking_state` AS `parking_state`,`devices`.`update_time` AS `update_time` from `devices` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `GET_STATIONS`
--

/*!50001 DROP VIEW IF EXISTS `GET_STATIONS`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `GET_STATIONS` AS select `stations`.`station_id` AS `station_id`,`stations`.`dev_eui` AS `dev_eui`,`stations`.`station_state` AS `station_state`,`stations`.`station_type` AS `station_type`,`stations`.`charging_state` AS `charging_state`,`stations`.`charging_percentage` AS `charging_percentage`,`stations`.`charging_consumption_periodic` AS `charging_consumption_periodic`,`stations`.`charging_consumption_total` AS `charging_consumption_total`,`stations`.`charging_socket_location` AS `charging_socket_location`,`stations`.`charging_socket_type` AS `charging_socket_type`,`stations`.`charging_power` AS `charging_power`,`stations`.`parking_state` AS `parking_state`,`stations`.`update_time` AS `update_time` from `stations` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-12-03 23:28:52
