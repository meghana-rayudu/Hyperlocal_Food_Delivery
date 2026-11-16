-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: hyperlocal_food_delivery
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Current Database: `hyperlocal_food_delivery`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hyperlocal_food_delivery` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hyperlocal_food_delivery`;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `address_line` varchar(255) NOT NULL,
  `area` varchar(100) NOT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `fk_address_customer` (`customer_id`),
  CONSTRAINT `fk_address_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,1,'12 MG Road','Indiranagar',12.9716000,77.6412000),(2,2,'45 5th Main Road','Koramangala',12.9352000,77.6245000),(3,3,'8 Residency Road','Richmond Town',12.9650000,77.6010000),(4,4,'21 HSR Layout','HSR Layout',12.9116000,77.6389000),(5,5,'33 2nd Cross','BTM Layout',12.9166000,77.6101000);
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courier`
--

DROP TABLE IF EXISTS `courier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courier` (
  `courier_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `vehicle_type` enum('BIKE','SCOOTER','BICYCLE','CAR') NOT NULL,
  `status` enum('AVAILABLE','BUSY','OFFLINE') NOT NULL DEFAULT 'OFFLINE',
  PRIMARY KEY (`courier_id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_courier_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courier`
--

LOCK TABLES `courier` WRITE;
/*!40000 ALTER TABLE `courier` DISABLE KEYS */;
INSERT INTO `courier` VALUES (1,'Ravi Kumar','9666666661','BIKE','AVAILABLE'),(2,'Suresh Babu','9666666662','SCOOTER','AVAILABLE'),(3,'Nikhil Raj','9666666663','BIKE','BUSY'),(4,'Vikram Singh','9666666664','BICYCLE','AVAILABLE'),(5,'Aman Joseph','9666666665','BIKE','OFFLINE');
/*!40000 ALTER TABLE `courier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `courier_delivery_summary`
--

DROP TABLE IF EXISTS `courier_delivery_summary`;
/*!50001 DROP VIEW IF EXISTS `courier_delivery_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `courier_delivery_summary` AS SELECT 
 1 AS `courier_id`,
 1 AS `courier_name`,
 1 AS `total_deliveries`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_customer_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Rahul Sharma','9876543210','rahul@gmail.com','hash_rahul'),(2,'Ananya Rao','9876543211','ananya@gmail.com','hash_ananya'),(3,'Arjun Kumar','9876543212','arjun@gmail.com','hash_arjun'),(4,'Meera Nair','9876543213','meera@gmail.com','hash_meera'),(5,'Arun Varma','9876543214','arun@gmail.com','hash_arun');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery`
--

DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `delivery_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `courier_id` int NOT NULL,
  `assigned_at` datetime DEFAULT NULL,
  `picked_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `status` enum('UNASSIGNED','ASSIGNED','PICKED_UP','IN_TRANSIT','DELIVERED','CANCELLED') NOT NULL DEFAULT 'UNASSIGNED',
  PRIMARY KEY (`delivery_id`),
  UNIQUE KEY `order_id` (`order_id`),
  KEY `idx_delivery_courier` (`courier_id`),
  CONSTRAINT `fk_delivery_courier` FOREIGN KEY (`courier_id`) REFERENCES `courier` (`courier_id`),
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
INSERT INTO `delivery` VALUES (1,1,1,'2026-08-24 12:05:00','2026-08-24 12:25:00','2026-08-24 12:50:00','DELIVERED'),(2,2,2,'2026-08-24 13:00:00','2026-08-24 13:20:00',NULL,'IN_TRANSIT'),(3,3,3,NULL,NULL,NULL,'UNASSIGNED'),(4,4,4,'2026-08-24 13:30:00',NULL,NULL,'ASSIGNED'),(5,5,1,NULL,NULL,NULL,'UNASSIGNED');
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_allocation`
--

DROP TABLE IF EXISTS `delivery_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_allocation` (
  `allocation_id` int NOT NULL AUTO_INCREMENT,
  `delivery_id` int NOT NULL,
  `courier_id` int NOT NULL,
  `distance_km` decimal(6,2) NOT NULL,
  `estimated_time` int NOT NULL,
  `allocation_score` decimal(5,2) NOT NULL,
  `allocated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `result` enum('SELECTED','REJECTED','EXPIRED') NOT NULL,
  PRIMARY KEY (`allocation_id`),
  KEY `fk_allocation_courier` (`courier_id`),
  KEY `idx_allocation_delivery` (`delivery_id`),
  KEY `idx_allocation_score` (`allocation_score`),
  CONSTRAINT `fk_allocation_courier` FOREIGN KEY (`courier_id`) REFERENCES `courier` (`courier_id`),
  CONSTRAINT `fk_allocation_delivery` FOREIGN KEY (`delivery_id`) REFERENCES `delivery` (`delivery_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_allocation_score` CHECK ((`allocation_score` between 0 and 100)),
  CONSTRAINT `chk_distance` CHECK ((`distance_km` >= 0)),
  CONSTRAINT `chk_estimated_time` CHECK ((`estimated_time` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_allocation`
--

LOCK TABLES `delivery_allocation` WRITE;
/*!40000 ALTER TABLE `delivery_allocation` DISABLE KEYS */;
INSERT INTO `delivery_allocation` VALUES (1,1,1,1.20,5,92.00,'2026-08-24 15:26:16','SELECTED'),(2,1,2,2.10,8,81.00,'2026-08-24 15:26:16','REJECTED'),(3,2,2,0.80,4,95.00,'2026-08-24 15:26:16','SELECTED'),(4,2,4,1.70,7,84.00,'2026-08-24 15:26:16','REJECTED'),(5,3,1,1.50,6,88.00,'2026-08-24 15:26:16','SELECTED'),(6,3,4,2.00,9,78.00,'2026-08-24 15:26:16','REJECTED'),(7,4,4,0.90,5,91.00,'2026-08-24 15:26:16','SELECTED'),(8,4,1,1.80,8,80.00,'2026-08-24 15:26:16','REJECTED'),(9,5,2,1.10,5,90.00,'2026-08-24 15:26:16','SELECTED');
/*!40000 ALTER TABLE `delivery_allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_item`
--

DROP TABLE IF EXISTS `menu_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_item` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `restaurant_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `availability` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`item_id`),
  KEY `idx_menu_restaurant` (`restaurant_id`),
  CONSTRAINT `fk_menu_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_menu_price` CHECK ((`price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_item`
--

LOCK TABLES `menu_item` WRITE;
/*!40000 ALTER TABLE `menu_item` DISABLE KEYS */;
INSERT INTO `menu_item` VALUES (1,1,'Paneer Biryani','Aromatic rice with spicy paneer',220.00,'Main Course',1),(2,1,'Butter Naan','Soft naan with butter',60.00,'Bread',1),(3,2,'Classic Veg Burger','Veg patty with fresh vegetables',150.00,'Burger',1),(4,2,'French Fries','Crispy salted fries',90.00,'Sides',1),(5,3,'Masala Dosa','Crispy dosa with potato masala',100.00,'South Indian',1),(6,3,'Idli Vada','Idli served with vada and sambar',90.00,'South Indian',1),(7,4,'Margherita Pizza','Classic cheese and tomato pizza',250.00,'Pizza',1),(8,4,'Farmhouse Pizza','Pizza with fresh vegetables',320.00,'Pizza',1),(9,5,'Paneer Salad Bowl','Healthy salad with paneer',180.00,'Healthy',1),(10,5,'Fruit Bowl','Fresh seasonal fruits',130.00,'Healthy',1);
/*!40000 ALTER TABLE `menu_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_id`,`item_id`),
  KEY `fk_orderitem_item` (`item_id`),
  CONSTRAINT `fk_orderitem_item` FOREIGN KEY (`item_id`) REFERENCES `menu_item` (`item_id`),
  CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_order_quantity` CHECK ((`quantity` > 0)),
  CONSTRAINT `chk_unit_price` CHECK ((`unit_price` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,1,220.00),(1,2,1,60.00),(2,3,1,150.00),(2,4,1,90.00),(3,5,1,100.00),(3,6,1,90.00),(4,9,1,180.00),(4,10,1,130.00),(5,1,2,220.00);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `order_summary`
--

DROP TABLE IF EXISTS `order_summary`;
/*!50001 DROP VIEW IF EXISTS `order_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `order_summary` AS SELECT 
 1 AS `order_id`,
 1 AS `customer_name`,
 1 AS `restaurant_name`,
 1 AS `order_time`,
 1 AS `status`,
 1 AS `total_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `restaurant_id` int NOT NULL,
  `address_id` int NOT NULL,
  `order_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('PLACED','CONFIRMED','PREPARING','READY','OUT_FOR_DELIVERY','DELIVERED','CANCELLED') NOT NULL DEFAULT 'PLACED',
  `total_amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_id`),
  KEY `fk_order_address` (`address_id`),
  KEY `idx_order_customer` (`customer_id`),
  KEY `idx_order_restaurant` (`restaurant_id`),
  KEY `idx_order_status` (`status`),
  CONSTRAINT `fk_order_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`),
  CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `fk_order_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`),
  CONSTRAINT `chk_order_amount` CHECK ((`total_amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,1,1,'2026-08-24 15:24:30','DELIVERED',280.00),(2,2,2,2,'2026-08-24 15:24:30','OUT_FOR_DELIVERY',240.00),(3,3,3,3,'2026-08-24 15:24:30','PREPARING',190.00),(4,4,5,4,'2026-08-24 15:24:30','CONFIRMED',310.00),(5,5,1,5,'2026-08-24 15:24:30','PLACED',440.00);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `method` enum('UPI','CARD','CASH','WALLET') NOT NULL,
  `status` enum('PENDING','SUCCESS','FAILED','REFUNDED') NOT NULL DEFAULT 'PENDING',
  `paid_at` datetime DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `order_id` (`order_id`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1,280.00,'UPI','SUCCESS','2026-08-24 12:50:00'),(2,2,240.00,'CARD','SUCCESS','2026-08-24 13:00:00'),(3,3,190.00,'UPI','SUCCESS','2026-08-24 13:10:00'),(4,4,310.00,'WALLET','SUCCESS','2026-08-24 13:25:00'),(5,5,440.00,'CASH','PENDING',NULL);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `restaurant_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `area` varchar(100) NOT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `status` enum('OPEN','CLOSED','TEMPORARILY_UNAVAILABLE') NOT NULL DEFAULT 'OPEN',
  `rating` decimal(2,1) DEFAULT '0.0',
  PRIMARY KEY (`restaurant_id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_restaurant_area` (`area`),
  CONSTRAINT `chk_restaurant_rating` CHECK ((`rating` between 0 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'Spice Route','9111111111','Indiranagar',12.9719000,77.6412000,'OPEN',0.0),(2,'Burger Hub','9222222222','Koramangala',12.9350000,77.6240000,'OPEN',0.0),(3,'Dosa Corner','9333333333','HSR Layout',12.9115000,77.6380000,'OPEN',0.0),(4,'Pizza Craft','9444444444','BTM Layout',12.9165000,77.6100000,'CLOSED',0.0),(5,'Green Bowl','9555555555','Richmond Town',12.9652000,77.6015000,'OPEN',0.0);
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'hyperlocal_food_delivery'
--

--
-- Dumping routines for database 'hyperlocal_food_delivery'
--

--
-- Current Database: `hyperlocal_food_delivery`
--

USE `hyperlocal_food_delivery`;

--
-- Final view structure for view `courier_delivery_summary`
--

/*!50001 DROP VIEW IF EXISTS `courier_delivery_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `courier_delivery_summary` AS select `c`.`courier_id` AS `courier_id`,`c`.`name` AS `courier_name`,count(`d`.`delivery_id`) AS `total_deliveries` from (`courier` `c` left join `delivery` `d` on((`c`.`courier_id` = `d`.`courier_id`))) group by `c`.`courier_id`,`c`.`name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `order_summary`
--

/*!50001 DROP VIEW IF EXISTS `order_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `order_summary` AS select `o`.`order_id` AS `order_id`,`c`.`name` AS `customer_name`,`r`.`name` AS `restaurant_name`,`o`.`order_time` AS `order_time`,`o`.`status` AS `status`,`o`.`total_amount` AS `total_amount` from ((`orders` `o` join `customer` `c` on((`o`.`customer_id` = `c`.`customer_id`))) join `restaurant` `r` on((`o`.`restaurant_id` = `r`.`restaurant_id`))) */;
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

-- Dump completed on 2026-10-28 22:02:39
