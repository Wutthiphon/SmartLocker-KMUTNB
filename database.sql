/*
 Navicat Premium Dump SQL

 Source Server         : Wutthiphon Backup Server
 Source Server Type    : MySQL
 Source Server Version : 80032 (8.0.32)
 Source Host           : backup.wutthiphon.space:3306
 Source Schema         : dev_cs_flutter

 Target Server Type    : MySQL
 Target Server Version : 80032 (8.0.32)
 File Encoding         : 65001

 Date: 12/03/2025 21:58:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for homepage_image
-- ----------------------------
DROP TABLE IF EXISTS `homepage_image`;
CREATE TABLE `homepage_image`  (
  `img_id` int NOT NULL AUTO_INCREMENT,
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`img_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of homepage_image
-- ----------------------------
INSERT INTO `homepage_image` VALUES (1, 'https://wutthiphon.space/bg1.58469ece57fad897.png');
INSERT INTO `homepage_image` VALUES (2, 'https://c4.wallpaperflare.com/wallpaper/448/301/135/lockers-red-wallpaper-preview.jpg');
INSERT INTO `homepage_image` VALUES (3, 'https://c4.wallpaperflare.com/wallpaper/208/77/108/lockers-wallpaper-preview.jpg');

-- ----------------------------
-- Table structure for lockers
-- ----------------------------
DROP TABLE IF EXISTS `lockers`;
CREATE TABLE `lockers`  (
  `locker_id` int NOT NULL AUTO_INCREMENT,
  `locker_num` int NOT NULL,
  `locker_status` tinyint NOT NULL,
  `locker_count` int NOT NULL,
  PRIMARY KEY (`locker_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of lockers
-- ----------------------------
INSERT INTO `lockers` VALUES (1, 3, 1, 6);
INSERT INTO `lockers` VALUES (2, 4, 1, 5);
INSERT INTO `lockers` VALUES (3, 1, 1, 6);
INSERT INTO `lockers` VALUES (4, 2, 1, 8);
INSERT INTO `lockers` VALUES (5, 5, 1, 4);
INSERT INTO `lockers` VALUES (11, 6, 1, 1);
INSERT INTO `lockers` VALUES (12, 7, 1, 0);
INSERT INTO `lockers` VALUES (13, 8, 1, 2);
INSERT INTO `lockers` VALUES (14, 9, 1, 1);
INSERT INTO `lockers` VALUES (15, 10, 1, 0);

-- ----------------------------
-- Table structure for records
-- ----------------------------
DROP TABLE IF EXISTS `records`;
CREATE TABLE `records`  (
  `record_id` int NOT NULL AUTO_INCREMENT,
  `date_start` datetime NULL DEFAULT NULL,
  `date_end` datetime NULL DEFAULT NULL,
  `user_id` int NOT NULL,
  `locker_id` int NOT NULL,
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `record_user_id`(`user_id` ASC) USING BTREE,
  INDEX `record_locker_id`(`locker_id` ASC) USING BTREE,
  CONSTRAINT `record_locker_id` FOREIGN KEY (`locker_id`) REFERENCES `lockers` (`locker_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `record_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of records
-- ----------------------------
INSERT INTO `records` VALUES (13, '2025-03-07 22:45:07', '2025-03-08 22:45:11', 22, 2);
INSERT INTO `records` VALUES (14, '2025-03-09 06:45:22', '2025-03-09 08:02:15', 16, 13);
INSERT INTO `records` VALUES (22, '2025-03-09 08:23:56', '2025-03-09 08:24:20', 16, 5);
INSERT INTO `records` VALUES (23, '2025-03-09 08:24:28', '2025-03-09 09:57:29', 16, 5);
INSERT INTO `records` VALUES (24, '2025-03-09 08:20:40', '2025-03-09 09:57:54', 16, 4);
INSERT INTO `records` VALUES (26, '2025-03-09 08:06:52', '2025-03-10 10:02:31', 16, 13);
INSERT INTO `records` VALUES (27, '2025-03-09 06:46:44', '2025-03-10 10:11:24', 16, 3);
INSERT INTO `records` VALUES (28, '2025-03-07 22:43:25', '2025-03-10 10:14:51', 23, 2);
INSERT INTO `records` VALUES (29, '2025-03-10 10:16:55', '2025-03-10 10:18:43', 23, 2);
INSERT INTO `records` VALUES (30, '2025-03-10 10:19:14', '2025-03-10 10:20:06', 23, 2);
INSERT INTO `records` VALUES (31, '2025-03-10 10:21:21', '2025-03-10 10:21:28', 23, 4);
INSERT INTO `records` VALUES (32, '2025-03-10 10:21:58', '2025-03-10 10:22:04', 23, 4);
INSERT INTO `records` VALUES (33, '2025-03-10 10:23:31', '2025-03-10 10:24:22', 23, 2);
INSERT INTO `records` VALUES (34, '2025-03-09 08:23:25', '2025-03-10 10:31:59', 16, 1);
INSERT INTO `records` VALUES (35, '2025-03-10 10:12:13', '2025-03-11 01:49:39', 16, 3);
INSERT INTO `records` VALUES (36, '2025-03-11 01:56:23', '2025-03-11 02:08:31', 23, 3);
INSERT INTO `records` VALUES (37, '2025-03-11 02:55:46', '2025-03-11 02:55:51', 23, 14);
INSERT INTO `records` VALUES (38, '2025-03-11 02:44:57', '2025-03-11 02:57:13', 16, 3);
INSERT INTO `records` VALUES (39, '2025-03-11 01:49:50', '2025-03-11 03:36:52', 16, 1);
INSERT INTO `records` VALUES (40, '2025-03-11 03:37:08', '2025-03-11 03:57:25', 16, 3);

-- ----------------------------
-- Table structure for reservations
-- ----------------------------
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations`  (
  `rsv_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `locker_id` int NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`rsv_id`) USING BTREE,
  INDEX `rsv_locker_id`(`locker_id` ASC) USING BTREE,
  INDEX `rsv_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `rsv_locker_id` FOREIGN KEY (`locker_id`) REFERENCES `lockers` (`locker_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rsv_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reservations
-- ----------------------------
INSERT INTO `reservations` VALUES (74, 23, 2, '923189', '2025-03-10 10:24:36');
INSERT INTO `reservations` VALUES (80, 16, 3, '111527', '2025-03-11 04:01:24');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lastname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ref` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `otp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `verify_status` tinyint NOT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (16, 'fluk290344@gmail.com', '$2b$12$ZQPj.T9lWE/6KAhP5odKj.bjCFW5nVrJAjJ5L4SNHC9C3GdyVKTz.', 'อชิรวิชญ์', 'บุญแต่ง', NULL, NULL, 1);
INSERT INTO `users` VALUES (22, 's6504062620132@email.kmutnb.ac.th', '$2b$12$aMY9FHYEylYIPS9LA2oivOqAy2mleYlZTp79jqEZekAvxUnXrGt4a', 'อชิรวิชญ์', 'บุญแต่ง', '5QAV7O', '385967', 0);
INSERT INTO `users` VALUES (23, 's.suphanat.t@gmail.com', '$2b$12$xtaPyBoAJ50XFfSJUyt7cuTqTAtcKGY.DFVx5ogh4b9CXPQfggJ7C', 'suphanat', 'bamrungna', NULL, NULL, 1);
INSERT INTO `users` VALUES (25, 's6504062610293@email.kmutnb.ac.th', '$2b$12$76F3BsI5tw4fdXsCdA.l3.zCEZ6rgkpUu8krb1dURMQPxRigjcT/m', 'Achirawit ', 'Pikor', NULL, NULL, 1);
INSERT INTO `users` VALUES (26, 's6504062610081@email.kmutnb.ac.th', '$2b$12$9xvGzgPl.kAx2KO2CTfljuYKB3IYQ1Phuc9UApZxOYJQ79CcstFFq', 'Nuttanan', 'Termsettajaroen', NULL, NULL, 1);

SET FOREIGN_KEY_CHECKS = 1;
