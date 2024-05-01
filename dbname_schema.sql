-- MySQL dump 10.13  Distrib 8.3.0, for macos14.2 (arm64)
--
-- Host: localhost    Database: onlinebookstore
-- ------------------------------------------------------
-- Server version	8.3.0

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
-- Table structure for table `Authors`
--

DROP TABLE IF EXISTS `Authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Authors` (
  `AuthorID` int NOT NULL AUTO_INCREMENT,
  `AuthorName` varchar(255) NOT NULL,
  `Bio` text,
  `BirthYear` year DEFAULT NULL,
  PRIMARY KEY (`AuthorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BookAuthors`
--

DROP TABLE IF EXISTS `BookAuthors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BookAuthors` (
  `BookISBN` varchar(13) NOT NULL,
  `AuthorID` int NOT NULL,
  PRIMARY KEY (`BookISBN`,`AuthorID`),
  KEY `AuthorID` (`AuthorID`),
  CONSTRAINT `bookauthors_ibfk_1` FOREIGN KEY (`BookISBN`) REFERENCES `Books` (`ISBN`),
  CONSTRAINT `bookauthors_ibfk_2` FOREIGN KEY (`AuthorID`) REFERENCES `Authors` (`AuthorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `BookCategories`
--

DROP TABLE IF EXISTS `BookCategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BookCategories` (
  `BookISBN` varchar(13) NOT NULL,
  `CategoryID` int NOT NULL,
  PRIMARY KEY (`BookISBN`,`CategoryID`),
  KEY `CategoryID` (`CategoryID`),
  CONSTRAINT `bookcategories_ibfk_1` FOREIGN KEY (`BookISBN`) REFERENCES `Books` (`ISBN`),
  CONSTRAINT `bookcategories_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `Categories` (`CategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Books`
--

DROP TABLE IF EXISTS `Books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Books` (
  `ISBN` varchar(13) NOT NULL,
  `Title` varchar(255) NOT NULL,
  `PublicationYear` year NOT NULL,
  `Genre` varchar(100) DEFAULT NULL,
  `Price` decimal(10,2) NOT NULL,
  `StockQuantity` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Categories`
--

DROP TABLE IF EXISTS `Categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categories` (
  `CategoryID` int NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(255) NOT NULL,
  PRIMARY KEY (`CategoryID`),
  UNIQUE KEY `CategoryName` (`CategoryName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `OrderDetails`
--

DROP TABLE IF EXISTS `OrderDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrderDetails` (
  `OrderDetailID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `ISBN` varchar(13) NOT NULL,
  `Quantity` int NOT NULL,
  `PurchasePrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderDetailID`),
  KEY `fk_order_orderdetails` (`OrderID`),
  KEY `fk_book_orderdetails` (`ISBN`),
  CONSTRAINT `fk_book_orderdetails` FOREIGN KEY (`ISBN`) REFERENCES `Books` (`ISBN`),
  CONSTRAINT `fk_order_orderdetails` FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`),
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`ISBN`) REFERENCES `Books` (`ISBN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `TotalPrice` decimal(10,2) NOT NULL,
  `OrderDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ShippingStatus` varchar(50) NOT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `fk_user_order` (`UserID`),
  CONSTRAINT `fk_user_order` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Reviews`
--

DROP TABLE IF EXISTS `Reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reviews` (
  `ReviewID` int NOT NULL AUTO_INCREMENT,
  `ISBN` varchar(13) NOT NULL,
  `UserID` int NOT NULL,
  `Rating` int NOT NULL,
  `ReviewText` text,
  `ReviewDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ReviewID`),
  KEY `fk_user_reviews` (`UserID`),
  KEY `fk_book_reviews` (`ISBN`),
  CONSTRAINT `fk_book_reviews` FOREIGN KEY (`ISBN`) REFERENCES `Books` (`ISBN`),
  CONSTRAINT `fk_user_reviews` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`ISBN`) REFERENCES `Books` (`ISBN`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `Users` (`UserID`),
  CONSTRAINT `chk_rating` CHECK ((`Rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `idx_email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-20 17:01:34
