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
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `user_ncikname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_phone_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_privacy` enum('ALL','FOLLOWING','PRIVATE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_profile_image` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_role` enum('GUEST','USER') COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_social_id` bigint NOT NULL,
  `user_state_message` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'김태환',NULL,'e9f226-HS26fIZieSOBCCg:APA91bGBMkaRy9Yq4QBEsWnD5SpP6A3ZszNuqGSC1URK48hfpUQYck2n0JMsffjFSrrxvWg-GMgOfEMpwRDa4VcHE9zmpQ8Ys2rDCsrKJSHYQWBSIpuVc6Hod3cpbx5kothdnHWhkGyN','ALL','https://cdn.discordapp.com/attachments/1163775031982174208/1174528078765117460/123_1.jpg?ex=6567eb83&is=65557683&hm=9b59ddce3fffa1ee3bca2d3a817b7706338f842ca6ef8dbda6292461586d7931&','USER',1231231233,NULL),(2,'김나연',NULL,'e9f226-HS26fIZieSOBCCg:APA91bGBMkaRy9Yq4QBEsWnD5SpP6A3ZszNuqGSC1URK48hfpUQYck2n0JMsffjFSrrxvWg-GMgOfEMpwRDa4VcHE9zmpQ8Ys2rDCsrKJSHYQWBSIpuVc6Hod3cpbx5kothdnHWhkGyN','ALL','https://cdn.discordapp.com/attachments/1163775031982174208/1174529022466727936/msk.jpg?ex=6567ec64&is=65557764&hm=5d9da50e1ed61eb3e88fde14c2391b1e9fa5bbae67be4911380b1e7d2222f237&','USER',1231231233,NULL),(3,'구희영',NULL,'e9f226-HS26fIZieSOBCCg:APA91bGBMkaRy9Yq4QBEsWnD5SpP6A3ZszNuqGSC1URK48hfpUQYck2n0JMsffjFSrrxvWg-GMgOfEMpwRDa4VcHE9zmpQ8Ys2rDCsrKJSHYQWBSIpuVc6Hod3cpbx5kothdnHWhkGyN','ALL','http://k.kakaocdn.net/dn/GsJnx/btsqFrTnF8b/KS3O0Ie3KCHtO6ipUMwtjK/img_110x110.jpg','USER',1231231233,NULL),(4,'심규렬',NULL,'e9f226-HS26fIZieSOBCCg:APA91bGBMkaRy9Yq4QBEsWnD5SpP6A3ZszNuqGSC1URK48hfpUQYck2n0JMsffjFSrrxvWg-GMgOfEMpwRDa4VcHE9zmpQ8Ys2rDCsrKJSHYQWBSIpuVc6Hod3cpbx5kothdnHWhkGyN','ALL','https://cdn.discordapp.com/attachments/1163775031982174208/1174528079280996412/rf_1.jpg?ex=6567eb83&is=65557683&hm=cfe12eeae8cc1cf1b7a608f342d99802fe888a1f9406ddeb5452303599fa7fa4&','USER',1231231233,NULL),(40,'이상훈',NULL,'e9f226-HS26fIZieSOBCCg:APA91bGBMkaRy9Yq4QBEsWnD5SpP6A3ZszNuqGSC1URK48hfpUQYck2n0JMsffjFSrrxvWg-GMgOfEMpwRDa4VcHE9zmpQ8Ys2rDCsrKJSHYQWBSIpuVc6Hod3cpbx5kothdnHWhkGyN','ALL','https://cdn.discordapp.com/attachments/1163775031982174208/1174526841931964426/11.jpg?ex=6567ea5c&is=6555755c&hm=e181c626afebf83d33b50b948dd624be22587ae3719c8779c6b9fbddb17a7541&','USER',3114775614,''),(41,'정수완',NULL,'eU9Pif5ESWS2zacWtyAjFB:APA91bErqdN2zRqmtAY0Opa9O-5Jk_gcV5fm7mkA4u-BK9ae-yrchiziTbHWKbUePrLrj9UeucVvl2_oZdoue91eDHoOyygjhJ3LLtXbuH16_9q501A49ekGKUtZs_Y7YDboHx4HIw1B','ALL','http://k.kakaocdn.net/dn/Uk6cb/btsynBTxaIu/RqVOvjioscETUURjp2N8hk/img_110x110.jpg','USER',3140075578,''),(42,'김현빈',NULL,'ed4EpH6aRLqFtq4aDlGcVW:APA91bEKnM5r5A5-6tmBQImPymPBSUS8s26yCJOUrnbIHywJoq_Te8QQ1fSCIMQia08oVdsvCyL--QNRBi9At-JsOIeaKyaqTzQCFnEmDMKL0UDn138ugf3t59P_dOdR2_y2k90Aj1qC','ALL','http://k.kakaocdn.net/dn/cbFqpp/btsnGZkduEP/tPYv1eDYLYmwrAXRWdHBi0/img_110x110.jpg','USER',3154392747,''),(52,':)',NULL,'fbZ1p-liTt6roXmGAQ_5Lt:APA91bGfB4XfLHMtljeLkBQ1-PgxmWGQJhdTlscq-jNNPsOmR8fgBCoNgIj6vlAv3VW8xfVKNPX3hWod8HrUyH7gIa8TN1jKG0E4cUFGz-l9F5XFxAGCCbCpuObBdGyrUe-6wAQtn8iO','PRIVATE','http://k.kakaocdn.net/dn/bUeSPo/btszGNytZm7/59nitdksOoqyClrQldZoHk/img_110x110.jpg','USER',3166385794,''),(56,'희영',NULL,'eYqxXMacTpiVDk2RqSanc2:APA91bEO-Il3cdFsDkEMA2VNOSfXsBdCcVPYd3BHsR_zYzJkXnVOpRnYgBf3b8aBVs3dO3_8rLS3AkHWrnB9ZXtdx3sMJLfSGdIPana7yHE2tKgO1Y6UBKWSZ4VDBkWjctaH-UI7w0qc','PRIVATE','http://k.kakaocdn.net/dn/DvnFR/btsAq2CwruT/Qy1CQ7hYLneMz8ZZt7B961/img_110x110.jpg','USER',3152372783,'');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-17 11:40:05
