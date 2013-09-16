-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: landmark
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.1

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
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `rating` decimal(10,0) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  `dataid` int(11) DEFAULT NULL,
  `landmarkid` int(11) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `landmark`
--

DROP TABLE IF EXISTS `landmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `landmark` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dataid` int(11) DEFAULT NULL,
  `feat` varchar(20) DEFAULT NULL,
  `centroidx` double DEFAULT NULL,
  `centroidy` double DEFAULT NULL,
  `numofpoints` int(11) DEFAULT NULL,
  `confidence` int(11) DEFAULT NULL,
  `file` varchar(50) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `landmark`
--

LOCK TABLES `landmark` WRITE;
/*!40000 ALTER TABLE `landmark` DISABLE KEYS */;
/*!40000 ALTER TABLE `landmark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample` (
  `dataid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `folder` varchar(100) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `start_time` varchar(50) DEFAULT NULL,
  UNIQUE KEY `dataid` (`dataid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample`
--

LOCK TABLES `sample` WRITE;
/*!40000 ALTER TABLE `sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(80) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `uid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `salt` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `gcm_regid` varchar(200) DEFAULT NULL,
  `landmarkid` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  UNIQUE KEY `uid` (`uid`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('ananth','8CrNgLJdZxSZC2MG0hyKx8TONNYxNGQxN2I3MmIx','nexus',6,'14d17b72b1','2013-09-04 19:26:56','',NULL,NULL,NULL),('anan','lyIq2c+QcTjCzf+9nMa8mEOlgPM4ZmI5YzczZWUx','nexis',7,'8fb9c73ee1','2013-09-04 19:32:14','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('anant','VnBvDL4pdGPbXOGgj7sQM6HtgM41MDFjN2NkZmE4','nexis',8,'501c7cdfa8','2013-09-04 19:36:13','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('Anya','eCX0x/nUb7jOqvaC0EofQGVdz+IyOWU0NjdjODU5','nexis',9,'29e467c859','2013-09-04 19:40:54','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('Any','1RVY+6Jp56h85du1z4Egh4YYfyJlNzgzNmIwYThm','nexis',10,'e7836b0a8f','2013-09-04 19:41:55','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('Ans','Hb6H+kF6s6TfZeeIoGBifDEpLrhhYzEwYTU0ZmE4','nexis',11,'ac10a54fa8','2013-09-04 19:45:16','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('anu','AL4ovZYZYX4H8ecNUWJm+NjnSOM3YjMwYjM1MzI1','nexus',12,'7b30b35325','2013-09-04 19:51:44','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('awe','wMr2yvsfV+ijtEQ7uIyiSuL4/XU4YmYzYWJkZDg4','def',13,'8bf3abdd88','2013-09-04 19:56:44','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('asd','WQYXs9J00HlS9UJjkkZ4883zK+EwZmExMWE3NjRi','nexus',14,'0fa11a764b','2013-09-05 11:23:55','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('asdi','5E3jVIoGnb0edXXNtgXDpfqDaytmOThhZjNhYjhj','nexus',15,'f98af3ab8c','2013-09-05 11:25:03','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('xfv','Hz8ZfYj+TekwSp4DSkXMAsXmcGY3MmMxODVkOTU5','nexis',16,'72c185d959','2013-09-05 11:29:31','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('ani','TkOANzTj/tvbiEU5QQFWKnTWRYU1NGRiYjJlZjFj','nexus',17,'54dbb2ef1c','2013-09-05 11:30:45','APA91bGBMghRhY5_ax8RZW_pQ0HxrNhM6mvSbFM4p5XIo5S0_HTJONlsaSN0l1QWaM7TR5TT80vAjiatwGOGbN5QnJyexwXhbanK1Ew1mu3UaLx9XwxognFNLVi0HEdgB7dBa9glNCzlQpgVpjYl-UCVAnKLSJp9SLrpdBOX6Zp8qQNkjqXLfxc',NULL,NULL,NULL),('avi','4qfRnfM8hS9/5bQqOH/8PMJE0Ms2ZTY5ZWY4NzQ2','avi',18,'6e69ef8746','2013-09-05 11:51:40','',NULL,NULL,NULL),('asdj','9//3RTtxXRr5O3m5Cctx6+H31sM2YWVkZTNhODg2','asd',19,'6aede3a886','2013-09-05 11:54:51','APA91bEOA97_a0ZkoteddtzcZIIL83KOSJcVGyPST3k1N1vpypj4-zl3nrgbIx0kr9_7LT5Z8hWumPY050M8wRHO1cZN4Q36MMmswtJFKVf57tp80l4YBgm1sW3QuCxFIHpIlRQfhDT1tWlnkO0b4i0JeRqs9mPAGtlCVWsqOpZvwUaQA963gxY',NULL,NULL,NULL),('ase','gUTwewcnNBvwnNOcvPNav5K27xs1NWNhODNjZWMz','bexus',20,'55ca83cec3','2013-09-05 12:26:22','APA91bEOA97_a0ZkoteddtzcZIIL83KOSJcVGyPST3k1N1vpypj4-zl3nrgbIx0kr9_7LT5Z8hWumPY050M8wRHO1cZN4Q36MMmswtJFKVf57tp80l4YBgm1sW3QuCxFIHpIlRQfhDT1tWlnkO0b4i0JeRqs9mPAGtlCVWsqOpZvwUaQA963gxY',NULL,NULL,NULL),('adr','BAGdTX+DI8hSRNH8LXd8i/F0OQMyMzg1YzdmYmZk','as',21,'2385c7fbfd','2013-09-05 12:29:31','APA91bEOA97_a0ZkoteddtzcZIIL83KOSJcVGyPST3k1N1vpypj4-zl3nrgbIx0kr9_7LT5Z8hWumPY050M8wRHO1cZN4Q36MMmswtJFKVf57tp80l4YBgm1sW3QuCxFIHpIlRQfhDT1tWlnkO0b4i0JeRqs9mPAGtlCVWsqOpZvwUaQA963gxY',NULL,NULL,NULL),('anil','G5VJah8TTaoZwlmHaeu96eBlLadiZGFlOTgxOGFj','nexus',22,'bdae9818ac','2013-09-05 12:33:42','APA91bEOA97_a0ZkoteddtzcZIIL83KOSJcVGyPST3k1N1vpypj4-zl3nrgbIx0kr9_7LT5Z8hWumPY050M8wRHO1cZN4Q36MMmswtJFKVf57tp80l4YBgm1sW3QuCxFIHpIlRQfhDT1tWlnkO0b4i0JeRqs9mPAGtlCVWsqOpZvwUaQA963gxY',NULL,NULL,NULL),('add','7r8/ys4S8nLerhybaA5w+LBW3uBhNzMzMDAwNTEx','asd',23,'a733000511','2013-09-05 12:48:22','APA91bEOA97_a0ZkoteddtzcZIIL83KOSJcVGyPST3k1N1vpypj4-zl3nrgbIx0kr9_7LT5Z8hWumPY050M8wRHO1cZN4Q36MMmswtJFKVf57tp80l4YBgm1sW3QuCxFIHpIlRQfhDT1tWlnkO0b4i0JeRqs9mPAGtlCVWsqOpZvwUaQA963gxY',NULL,NULL,NULL);
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

-- Dump completed on 2013-09-08 15:56:25
