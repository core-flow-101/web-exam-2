-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: recipes
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('4233e2f65c53');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `recipe_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `images_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
INSERT INTO `images` VALUES (2,'2d2ab7df-cdbc-48a8-a936-35bba702def5.jpg','image/jpeg',3),(5,'afc2cfe7-5cac-4b80-9b9a-d5c65ef0c728.jpg','image/jpeg',5),(6,'avatar.jpg','image/jpeg',6),(7,'download.png','image/png',6),(9,'avatar.jpg','image/jpeg',8),(10,'download.png','image/png',9);
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipes`
--

DROP TABLE IF EXISTS `recipes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `cooking_time` int NOT NULL,
  `servings` int NOT NULL,
  `ingredients` text NOT NULL,
  `steps` text NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `recipes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipes`
--

LOCK TABLES `recipes` WRITE;
/*!40000 ALTER TABLE `recipes` DISABLE KEYS */;
INSERT INTO `recipes` VALUES (3,'╤Б╤Г╨┐','╨╛╨┐╨╕╤Б╨░╨╜╨╕╨╡',30,3,'╨╕╨╜╨│╤А╨╕╤В╨┤╨╕╨╡╨╡╨╜╤В╤Л','╤И╨░╨│',1,'2025-06-18 20:59:02'),(5,'╨С╤Л╤Б╤В╤А╤Л╨╣ ╤И╨╛╨║╨╛╨╗╨░╨┤╨╜╤Л╨╣ ╨║╨╡╨║╤Б','╨Ю╤З╨╡╨╜╤М ╨▓╨║╤Г╤Б╨╜╤Л╨╣ ╨╕ ╨▒╤Л╤Б╤В╤А╤Л╨╣ ╨║╨╡╨║╤Б, ╨║╨╛╤В╨╛╤А╤Л╨╣ ╨╝╨╛╨╢╨╜╨╛ ╨┐╤А╨╕╨│╨╛╤В╨╛╨▓╨╕╤В╤М ╨╖╨░ 5 ╨╝╨╕╨╜╤Г╤В!\n\n**╨Ю╤Б╨╛╨▒╨╡╨╜╨╜╨╛╤Б╤В╨╕:**\n- ╨У╨╛╤В╨╛╨▓╨╕╤В╤Б╤П ╨▓ ╨╝╨╕╨║╤А╨╛╨▓╨╛╨╗╨╜╨╛╨▓╨║╨╡\n- ╨Ь╨╕╨╜╨╕╨╝╤Г╨╝ ╨╕╨╜╨│╤А╨╡╨┤╨╕╨╡╨╜╤В╨╛╨▓\n- ╨Ю╤В╨╗╨╕╤З╨╜╨╛ ╨┐╨╛╨┤╤Е╨╛╨┤╨╕╤В ╨┤╨╗╤П ╨╖╨░╨▓╤В╤А╨░╨║╨░',5,2,'- 4 ╤Б╤В.╨╗. ╨╝╤Г╨║╨╕\n- 4 ╤Б╤В.╨╗. ╤Б╨░╤Е╨░╤А╨░\n- 2 ╤Б╤В.╨╗. ╨║╨░╨║╨░╨╛\n- 1 ╤П╨╣╤Ж╨╛\n- 3 ╤Б╤В.╨╗. ╨╝╨╛╨╗╨╛╨║╨░\n- 3 ╤Б╤В.╨╗. ╤А╨░╤Б╤В╨╕╤В╨╡╨╗╤М╨╜╨╛╨│╨╛ ╨╝╨░╤Б╨╗╨░\n- ╤Й╨╡╨┐╨╛╤В╨║╨░ ╤Б╨╛╨╗╨╕','1. ╨б╨╝╨╡╤И╨░╨╣╤В╨╡ ╨▓╤Б╨╡ ╤Б╤Г╤Е╨╕╨╡ ╨╕╨╜╨│╤А╨╡╨┤╨╕╨╡╨╜╤В╤Л ╨▓ ╨║╤А╤Г╨╢╨║╨╡.\n2. ╨Ф╨╛╨▒╨░╨▓╤М╤В╨╡ ╤П╨╣╤Ж╨╛, ╨╝╨╛╨╗╨╛╨║╨╛ ╨╕ ╨╝╨░╤Б╨╗╨╛, ╤Е╨╛╤А╨╛╤И╨╛ ╨┐╨╡╤А╨╡╨╝╨╡╤И╨░╨╣╤В╨╡.\n3. ╨Я╨╛╤Б╤В╨░╨▓╤М╤В╨╡ ╨▓ ╨╝╨╕╨║╤А╨╛╨▓╨╛╨╗╨╜╨╛╨▓╨║╤Г ╨╜╨░ 3-4 ╨╝╨╕╨╜╤Г╤В╤Л ╨╜╨░ ╨╝╨░╨║╤Б╨╕╨╝╨░╨╗╤М╨╜╨╛╨╣ ╨╝╨╛╤Й╨╜╨╛╤Б╤В╨╕.\n4. ╨Ф╨░╨╣╤В╨╡ ╨╜╨╡╨╝╨╜╨╛╨│╨╛ ╨╛╤Б╤В╤Л╤В╤М ╨╕ ╨╜╨░╤Б╨╗╨░╨╢╨┤╨░╨╣╤В╨╡╤Б╤М!',1,'2025-06-18 21:13:21'),(6,'╨Ь╨╛╨╣ ╨┐╨╡╤А╨▓╤Л╨╣ ╤А╨╡╤Ж╨╡╨┐╤В','╨Э╨╛╨▓╨╛╨╡ ╨╛╨┐╨╕╤Б╨░╨╜╨╕╨╡ ╤А╨╡╤Ж╨╡╨┐╤В╨░',10,2,'╨Ш╨╜╨│╤А╨╡╨┤╨╕╨╡╨╜╤В╤Л','╨и╨░╨│ 1\r\n╨и╨░╨│ 2\r\n╨и╨░╨│ 3 ',2,'2025-06-22 15:15:26'),(8,'╨в╨Х╨б╨в','╨в╨Х╨б╨в',12,1,'╨в╨Х╨б╨в','╨в╨Х╨б╨в',1,'2025-06-22 21:46:10'),(9,'╤В╨╡╤Б╤В ╨╝╨░╨║╤Б╨░','123',123,123,'123','123',3,'2025-06-22 21:48:00');
/*!40000 ALTER TABLE `recipes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipe_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `recipe_id` (`recipe_id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`recipe_id`) REFERENCES `recipes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (2,5,1,5,'╨║╨░╨╣╤Д ╨┐╨╛╨╗╨╜╤Л╨╣ ╨╡╨╗╨╕ ╨▓╤Б╨╡╨╣ ╤Б╨╡╨╝╤М╨╡╨╣','2025-06-20 15:11:42'),(3,3,1,5,'**╨Т╨б╨Х ╨Ю╨з╨Х╨Э╨м ╨Ъ╨а╨г╨в╨Ю!!!!**\n','2025-06-20 15:16:02'),(4,5,2,2,'**╨Э╨Х ╨Э╨а╨Р╨Т**','2025-06-22 14:56:51'),(5,6,1,1,'╨╝╨╜╨╡ ╨╜╤Г ╨╛╤Б╨╛╨▒╨╛ ╨┐╨╛╨╜╤А╨░╨▓╨╕╨╗╨╛╤Б╤М','2025-06-22 21:38:47'),(6,8,1,5,'╨Ь╨Э╨Х ╨Ю╨з╨Х╨Э╨м ╨Я╨Ю╨Э╨а╨Р╨Т╨Ш╨Ы╨Ю╨б╨м','2025-06-22 21:46:49'),(7,9,3,5,'╨╛╤В╨╖╤Л╨▓','2025-06-22 21:48:14'),(8,9,1,0,'123','2025-06-22 21:48:48');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'╨Я╨╛╨╗╤М╨╖╨╛╨▓╨░╤В╨╡╨╗╤М','SUPERUSER'),(2,'╨Р╨┤╨╝╨╕╨╜╨╕╤Б╤В╤А╨░╤В╨╛╤А','╨н╤В╨╛ ╨╛╤З╨╡╨╜╤М ╨║╤А╤Г╤В╨╛╨╣ ╤З╨╡╨╗');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'misha','scrypt:32768:8:1$4rmjf5D7jfyuw8Xq$7603c34bc753fdb41730bbb321304c8f1b24fd10697e65780a71d39119d75184a90880c2de9b7e8b988a88e24697a3b288d3f546fcb32709e8f0f903b7b4ccc2','kremlev','misha','stanislavovich',1),(2,'ivan','scrypt:32768:8:1$4rmjf5D7jfyuw8Xq$7603c34bc753fdb41730bbb321304c8f1b24fd10697e65780a71d39119d75184a90880c2de9b7e8b988a88e24697a3b288d3f546fcb32709e8f0f903b7b4ccc2','kremlev','misha','staniclavovich',1),(3,'Max','scrypt:32768:8:1$4rmjf5D7jfyuw8Xq$7603c34bc753fdb41730bbb321304c8f1b24fd10697e65780a71d39119d75184a90880c2de9b7e8b988a88e24697a3b288d3f546fcb32709e8f0f903b7b4ccc2','Maxov','Max','Maximovich',2);
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

-- Dump completed on 2025-06-23 13:21:40
