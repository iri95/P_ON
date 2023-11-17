CREATE DATABASE  IF NOT EXISTS `user_service` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `user_service`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: k9e102.p.ssafy.io    Database: user_service
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `room_id` bigint NOT NULL AUTO_INCREMENT,
  `anonymous` bit(1) NOT NULL,
  `complete` bit(1) NOT NULL,
  `dead_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dead_time` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `multiple_choice` bit(1) NOT NULL,
  `promise_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promise_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promise_time` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `promise_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `date_complete` bit(1) NOT NULL,
  `location_complete` bit(1) NOT NULL,
  `time_complete` bit(1) NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (128,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-16','미정','미정','테스트',45,_binary '',_binary '\0',_binary '\0'),(129,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-21','부산','오후 03시 40분','놀자',40,_binary '',_binary '',_binary ''),(130,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','ㅌㅅㅌ',NULL,_binary '\0',_binary '\0',_binary '\0'),(131,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17','미정','미정','ㄴㅎ',42,_binary '',_binary '\0',_binary '\0'),(132,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','테스트',45,_binary '\0',_binary '\0',_binary '\0'),(133,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-18 00:00:00.000','<b>하단</b>','오후 05시 15분','하이하이',NULL,_binary '',_binary '',_binary ''),(134,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17','미정','미정','ㄴㅇ',41,_binary '',_binary '\0',_binary '\0'),(136,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','미정','오후 04시 00분','끝내자',40,_binary '',_binary '\0',_binary ''),(138,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','하단','미정','ㅎㅇ',NULL,_binary '\0',_binary '',_binary '\0'),(139,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나수완',NULL,_binary '\0',_binary '\0',_binary '\0'),(140,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','@',NULL,_binary '\0',_binary '\0',_binary '\0'),(141,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','특별한 약속',47,_binary '\0',_binary '\0',_binary '\0'),(142,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','상훈햄',NULL,_binary '\0',_binary '\0',_binary '\0'),(143,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16','하단','오후 12시 00분','히히',41,_binary '',_binary '',_binary ''),(144,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','미정','오후 05시 00분','시연',47,_binary '',_binary '\0',_binary ''),(145,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','삼성전기부산사업장','오전 10시 00분','발표',NULL,_binary '',_binary '',_binary ''),(146,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','삼성전기부산사업장','오후 04시 55분','테스트',NULL,_binary '',_binary '',_binary ''),(147,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','삼성전기부산사업장','오후 04시 00분','내일',NULL,_binary '',_binary '',_binary ''),(148,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','한화시스템서울사업장','오후 04시 00분','약속약속약속양속',NULL,_binary '',_binary '',_binary ''),(149,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','ㄹㄹㄹㄹㄹㄹㄹ',NULL,_binary '\0',_binary '\0',_binary '\0'),(150,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-12 00:00:00.000','삼성청년SW아카데미 부울경캠퍼스','오후 06시 00분','자율 프로젝트',NULL,_binary '',_binary '',_binary ''),(151,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','이재모피자 서면점','오후 08시 00분','저녁 약속',NULL,_binary '',_binary '',_binary ''),(152,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-15 00:00:00.000','미정','미정','점심 약속',NULL,_binary '',_binary '\0',_binary '\0'),(153,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','미정','오후 01시 00분','점심 약속',NULL,_binary '',_binary '\0',_binary ''),(154,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-18 00:00:00.000','이재모피자 서면점','오후 04시 00분','P:ON 프로젝트 팀',NULL,_binary '',_binary '',_binary ''),(155,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-18 00:00:00.000','이재모피자 서면점','오후 04시 00분','P:ON 프로젝트 팀',NULL,_binary '',_binary '',_binary ''),(156,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','P:ON 프로젝트 팀',NULL,_binary '\0',_binary '\0',_binary '\0'),(157,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','미정','오후 04시 00분','내일의 약속',NULL,_binary '',_binary '\0',_binary ''),(158,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-24 00:00:00.000','미정','미정','다음주 약속',NULL,_binary '',_binary '\0',_binary '\0'),(159,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-09 00:00:00.000','부산광역시청','오후 03시 00분','이전의 약속',NULL,_binary '',_binary '',_binary ''),(160,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-10 00:00:00.000','부산광역시청','오후 04시 20분','지난 약속',NULL,_binary '',_binary '',_binary ''),(161,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-10 00:00:00.000','부산광역시청','오후 03시 00분','지난 약속',NULL,_binary '',_binary '',_binary ''),(162,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','회식',NULL,_binary '\0',_binary '\0',_binary '\0'),(163,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-18 00:00:00.000','이재모피자 서면점','오후 04시 00분','회식',NULL,_binary '',_binary '',_binary ''),(164,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','미정','오후 08시 00분','저녁 약속',51,_binary '',_binary '\0',_binary ''),(165,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-15 00:00:00.000','부산광역시청','오후 04시 00분','어제 약속',NULL,_binary '',_binary '',_binary ''),(166,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 04시 00분','또또약속',NULL,_binary '',_binary '',_binary ''),(167,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 04시 00분','또또또 약속',NULL,_binary '',_binary '',_binary ''),(168,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 04시 00분','또또또또 약속',NULL,_binary '',_binary '',_binary ''),(169,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','부산광역시청','오전 01시 10분','도도약속',NULL,_binary '',_binary '',_binary ''),(170,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','이재모피자 서면점','오전 04시 00분','시연테스트',51,_binary '\0',_binary '',_binary ''),(171,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나갈랴',NULL,_binary '\0',_binary '\0',_binary '\0'),(172,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나갈ㄹ9',NULL,_binary '\0',_binary '\0',_binary '\0'),(173,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나갈래',NULL,_binary '\0',_binary '\0',_binary '\0'),(174,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','2023-11-18','미정','오후 07시 00분','테스트트',51,_binary '',_binary '\0',_binary ''),(175,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나갈방',NULL,_binary '\0',_binary '\0',_binary '\0'),(176,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나갈거',NULL,_binary '\0',_binary '\0',_binary '\0'),(177,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','나갈거',NULL,_binary '\0',_binary '\0',_binary '\0'),(178,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','이북5도청','오후 07시 00분','끝낼거',NULL,_binary '',_binary '',_binary ''),(179,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','이재모피자 서면점','오후 07시 00분','투표해',51,_binary '\0',_binary '',_binary ''),(180,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','이재모피자 서면점','오후 04시 00분','P:ON 개발자 회식',NULL,_binary '\0',_binary '',_binary ''),(181,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-10-12 00:00:00.000','하단','오후 08시 00분','첫회식',NULL,_binary '',_binary '',_binary ''),(182,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','진짜마지막 테스트',NULL,_binary '\0',_binary '\0',_binary '\0'),(183,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 08시 00분','ㅇㅅㅇ',NULL,_binary '',_binary '',_binary ''),(184,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 08시 00분','추억',NULL,_binary '',_binary '',_binary ''),(185,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','삭제',NULL,_binary '\0',_binary '\0',_binary '\0'),(186,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 08시 00분','ㅇㅅㅇ',NULL,_binary '',_binary '',_binary ''),(187,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 08시 55분','어째서',NULL,_binary '',_binary '',_binary ''),(188,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','ㅎㅅ',NULL,_binary '\0',_binary '\0',_binary '\0'),(189,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','ㅈㅁㅈㅂㅈ',NULL,_binary '\0',_binary '\0',_binary '\0'),(190,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','ㅇ',NULL,_binary '\0',_binary '\0',_binary '\0'),(191,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','미정','미정','ㅅㅇㄴㅅㄴ',NULL,_binary '\0',_binary '\0',_binary '\0'),(192,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-16 00:00:00.000','부산광역시청','오후 09시 00분','ㅇㅅㅇ',NULL,_binary '',_binary '',_binary ''),(193,_binary '\0',_binary '',NULL,NULL,_binary '\0','2023-11-17 00:00:00.000','알콩달콩순두부','오전 07시 00분','저녁약속',NULL,_binary '',_binary '',_binary ''),(194,_binary '\0',_binary '\0',NULL,NULL,_binary '\0','미정','이재모피자 서면점','오후 04시 00분','P:ON 개발자 회식',56,_binary '\0',_binary '',_binary '');
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-17 11:40:06
