-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server versie:                10.11.7-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Versie:              12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Databasestructuur van postorderbedrijfx wordt geschreven
DROP DATABASE IF EXISTS `postorderbedrijfx`;
CREATE DATABASE IF NOT EXISTS `postorderbedrijfx` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `postorderbedrijfx`;

-- Structuur van  procedure postorderbedrijfx.apply_discount wordt geschreven
DROP PROCEDURE IF EXISTS `apply_discount`;
DELIMITER //
CREATE PROCEDURE `apply_discount`(IN discount_percentage DECIMAL(5,2))
UPDATE `order` o
    LEFT JOIN `order_item` oi ON o.id = oi.order_id
    LEFT JOIN `item` i ON oi.item_id = i.id
    SET o.orderDiscount = discount_percentage
    WHERE o.orderDiscount IS NULL//
DELIMITER ;

-- Structuur van  tabel postorderbedrijfx.costumer wordt geschreven
DROP TABLE IF EXISTS `costumer`;
CREATE TABLE IF NOT EXISTS `costumer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(50) NOT NULL DEFAULT '',
  `lastName` varchar(50) NOT NULL DEFAULT '',
  `age` int(11) NOT NULL DEFAULT 0,
  `gender` varchar(50) DEFAULT NULL,
  `street` varchar(50) NOT NULL,
  `houseNumber` int(11) NOT NULL,
  `postalCode` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumpen data van tabel postorderbedrijfx.costumer: ~2 rows (ongeveer)
DELETE FROM `costumer`;
INSERT INTO `costumer` (`id`, `firstName`, `lastName`, `age`, `gender`, `street`, `houseNumber`, `postalCode`) VALUES
	(1, 'Test', 'tes', 10, NULL, 'testtest', 10, '2020AB'),
	(2, 'User', 'yse', 20, NULL, 'use', 20, '3030BA');

-- Structuur van  tabel postorderbedrijfx.item wordt geschreven
DROP TABLE IF EXISTS `item`;
CREATE TABLE IF NOT EXISTS `item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` decimal(20,6) NOT NULL DEFAULT 0.000000,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumpen data van tabel postorderbedrijfx.item: ~3 rows (ongeveer)
DELETE FROM `item`;
INSERT INTO `item` (`id`, `name`, `price`, `description`) VALUES
	(1, 'Item1', 20.000000, 'blablabla'),
	(2, 'Item2', 30.000000, NULL),
	(3, 'Tiem3', 40.000000, NULL);

-- Structuur van  tabel postorderbedrijfx.order wordt geschreven
DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderDate` date NOT NULL,
  `orderTotal` decimal(20,6) NOT NULL DEFAULT 0.000000,
  `orderDiscount` varchar(50) DEFAULT NULL,
  `costumer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_order_costumer` (`costumer_id`),
  CONSTRAINT `FK_order_costumer` FOREIGN KEY (`costumer_id`) REFERENCES `costumer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumpen data van tabel postorderbedrijfx.order: ~4 rows (ongeveer)
DELETE FROM `order`;
INSERT INTO `order` (`id`, `orderDate`, `orderTotal`, `orderDiscount`, `costumer_id`) VALUES
	(1, '2024-03-11', 20.000000, '10.00', 1),
	(2, '2024-03-11', 30.000000, '10.00', 2),
	(3, '2024-03-11', 40.000000, '10.00', 2),
	(4, '2024-03-11', 0.000000, '15.00', 2);

-- Structuur van  view postorderbedrijfx.order_details_view wordt geschreven
DROP VIEW IF EXISTS `order_details_view`;
-- Tijdelijke tabel wordt aangemaakt zodat we geen VIEW afhankelijkheidsfouten krijgen
CREATE TABLE `order_details_view` (
	`order_id` INT(11) NOT NULL,
	`orderDate` DATE NOT NULL,
	`customer_id` INT(11) NOT NULL,
	`customer_name` VARCHAR(101) NULL COLLATE 'latin1_swedish_ci',
	`item_name` VARCHAR(255) NOT NULL COLLATE 'latin1_swedish_ci',
	`item_price` DECIMAL(20,6) NOT NULL,
	`order_item_id` INT(11) NOT NULL
) ENGINE=MyISAM;

-- Structuur van  tabel postorderbedrijfx.order_item wordt geschreven
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE IF NOT EXISTS `order_item` (
  `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `FK_order_item_item` (`item_id`),
  KEY `FK_order_item_order` (`order_id`),
  CONSTRAINT `FK_order_item_item` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Dumpen data van tabel postorderbedrijfx.order_item: ~5 rows (ongeveer)
DELETE FROM `order_item`;
INSERT INTO `order_item` (`order_item_id`, `item_id`, `order_id`) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 1, 3),
	(4, 2, 1),
	(5, 3, 1);

-- Tijdelijke tabel wordt verwijderd, en definitieve VIEW wordt aangemaakt.
DROP TABLE IF EXISTS `order_details_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `order_details_view` AS SELECT
    o.id AS order_id,
    o.orderDate,
    c.id AS customer_id,
    CONCAT(c.firstName, ' ', c.lastName) AS customer_name,
    i.name AS item_name,
    i.price AS item_price,
    oi.order_item_id
FROM
    `order` o
JOIN
    costumer c ON o.costumer_id = c.id
JOIN
    order_item oi ON o.id = oi.order_id
JOIN
    item i ON oi.item_id = i.id ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
