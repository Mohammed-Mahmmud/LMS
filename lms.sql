-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 27, 2026 at 08:34 PM
-- Server version: 8.0.30
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lms`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('lms_cache_livewire-rate-limiter:a17961fa74e9275d529f489537f179c05d50c2f3', 'i:1;', 1790538295),
('lms_cache_livewire-rate-limiter:a17961fa74e9275d529f489537f179c05d50c2f3:timer', 'i:1790538295;', 1790538295);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` bigint UNSIGNED NOT NULL,
  `instructor_id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `instructor_id`, `title`, `created_at`, `updated_at`) VALUES
(1, 1, 'Mandatory 4thgeneration superstructure', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(2, 1, 'Versatile neutral methodology', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(3, 2, 'Right-sized regional application', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(4, 2, 'Triple-buffered human-resource focusgroup', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(5, 3, 'Polarised 4thgeneration task-force', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(6, 3, 'Centralized composite website', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(7, 4, 'Pre-emptive hybrid moderator', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(8, 4, 'Intuitive bottom-line processimprovement', '2026-09-26 11:10:51', '2026-09-26 11:10:51');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `instructors`
--

CREATE TABLE `instructors` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payout_account` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `instructors`
--

INSERT INTO `instructors` (`id`, `name`, `email`, `payout_account`, `created_at`, `updated_at`) VALUES
(1, 'Sara Hassan', 'sara@lms.test', 'acct_sara001', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(2, 'Omar Nabil', 'omar@lms.test', 'acct_omar002', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(3, 'Laila Mostafa', 'laila@lms.test', 'acct_laila03', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(4, 'Youssef Adel', 'youssef@lms.test', NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ledger_entries`
--

CREATE TABLE `ledger_entries` (
  `id` bigint UNSIGNED NOT NULL,
  `instructor_id` bigint UNSIGNED DEFAULT NULL,
  `type` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount_cents` bigint NOT NULL,
  `idempotency_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subscription_id` bigint UNSIGNED DEFAULT NULL,
  `revenue_allocation_id` bigint UNSIGNED DEFAULT NULL,
  `refund_id` bigint UNSIGNED DEFAULT NULL,
  `payout_id` bigint UNSIGNED DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ledger_entries`
--

INSERT INTO `ledger_entries` (`id`, `instructor_id`, `type`, `amount_cents`, `idempotency_key`, `subscription_id`, `revenue_allocation_id`, `refund_id`, `payout_id`, `description`, `created_at`) VALUES
(1, NULL, 'platform_fee', 480, 'allocation:1:fee', 1, 1, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(2, 1, 'instructor_earning', 1120, 'allocation:1:instructor:1', 1, 1, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(3, NULL, 'platform_fee', 480, 'allocation:2:fee', 1, 2, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(4, 1, 'instructor_earning', 1120, 'allocation:2:instructor:1', 1, 2, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(5, NULL, 'platform_fee', 480, 'allocation:3:fee', 2, 3, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(6, 3, 'instructor_earning', 1120, 'allocation:3:instructor:3', 2, 3, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(7, NULL, 'platform_fee', 480, 'allocation:4:fee', 2, 4, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(8, 3, 'instructor_earning', 1120, 'allocation:4:instructor:3', 2, 4, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(9, NULL, 'platform_fee', 480, 'allocation:5:fee', 2, 5, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(10, 3, 'instructor_earning', 1120, 'allocation:5:instructor:3', 2, 5, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(11, NULL, 'platform_fee', 480, 'allocation:6:fee', 2, 6, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(12, 3, 'instructor_earning', 1120, 'allocation:6:instructor:3', 2, 6, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(13, NULL, 'platform_fee', 540, 'allocation:7:fee', 3, 7, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(14, 4, 'instructor_earning', 1260, 'allocation:7:instructor:4', 3, 7, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(15, NULL, 'platform_fee', 540, 'allocation:8:fee', 3, 8, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(16, 4, 'instructor_earning', 1260, 'allocation:8:instructor:4', 3, 8, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(17, NULL, 'platform_fee', 540, 'allocation:9:fee', 3, 9, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(18, 4, 'instructor_earning', 1260, 'allocation:9:instructor:4', 3, 9, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(19, NULL, 'platform_fee', 540, 'allocation:10:fee', 4, 10, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(20, 1, 'instructor_earning', 942, 'allocation:10:instructor:1', 4, 10, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(21, 4, 'instructor_earning', 318, 'allocation:10:instructor:4', 4, 10, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(22, NULL, 'platform_fee', 600, 'allocation:11:fee', 5, 11, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(23, 3, 'instructor_earning', 1400, 'allocation:11:instructor:3', 5, 11, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(24, NULL, 'platform_fee', 600, 'allocation:12:fee', 6, 12, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(25, 1, 'instructor_earning', 1400, 'allocation:12:instructor:1', 6, 12, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(26, NULL, 'platform_fee', 600, 'allocation:13:fee', 7, 13, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(27, 2, 'instructor_earning', 586, 'allocation:13:instructor:2', 7, 13, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(28, 4, 'instructor_earning', 814, 'allocation:13:instructor:4', 7, 13, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(29, NULL, 'platform_fee', 480, 'allocation:14:fee', 8, 14, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(30, 4, 'instructor_earning', 1120, 'allocation:14:instructor:4', 8, 14, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(31, NULL, 'platform_fee', 480, 'allocation:15:fee', 8, 15, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(32, 4, 'instructor_earning', 1120, 'allocation:15:instructor:4', 8, 15, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(33, NULL, 'platform_fee', 540, 'allocation:16:fee', 9, 16, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(34, 1, 'instructor_earning', 993, 'allocation:16:instructor:1', 9, 16, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(35, 4, 'instructor_earning', 267, 'allocation:16:instructor:4', 9, 16, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(36, NULL, 'platform_fee', 540, 'allocation:17:fee', 9, 17, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(37, 1, 'instructor_earning', 1088, 'allocation:17:instructor:1', 9, 17, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(38, 4, 'instructor_earning', 172, 'allocation:17:instructor:4', 9, 17, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(39, NULL, 'platform_fee', 540, 'allocation:18:fee', 9, 18, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(40, 1, 'instructor_earning', 728, 'allocation:18:instructor:1', 9, 18, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(41, 4, 'instructor_earning', 532, 'allocation:18:instructor:4', 9, 18, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(42, NULL, 'platform_fee', 540, 'allocation:19:fee', 10, 19, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(43, 1, 'instructor_earning', 145, 'allocation:19:instructor:1', 10, 19, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(44, 3, 'instructor_earning', 648, 'allocation:19:instructor:3', 10, 19, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(45, 4, 'instructor_earning', 467, 'allocation:19:instructor:4', 10, 19, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(46, NULL, 'platform_fee', 540, 'allocation:20:fee', 10, 20, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(47, 1, 'instructor_earning', 449, 'allocation:20:instructor:1', 10, 20, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(48, 4, 'instructor_earning', 811, 'allocation:20:instructor:4', 10, 20, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(49, NULL, 'platform_fee', 540, 'allocation:21:fee', 10, 21, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(50, 3, 'instructor_earning', 387, 'allocation:21:instructor:3', 10, 21, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(51, 4, 'instructor_earning', 873, 'allocation:21:instructor:4', 10, 21, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(52, NULL, 'platform_fee', 540, 'allocation:22:fee', 11, 22, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(53, 1, 'instructor_earning', 861, 'allocation:22:instructor:1', 11, 22, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(54, 2, 'instructor_earning', 399, 'allocation:22:instructor:2', 11, 22, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(55, NULL, 'platform_fee', 540, 'allocation:23:fee', 11, 23, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(56, 1, 'instructor_earning', 476, 'allocation:23:instructor:1', 11, 23, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(57, 2, 'instructor_earning', 784, 'allocation:23:instructor:2', 11, 23, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(58, NULL, 'platform_fee', 540, 'allocation:24:fee', 11, 24, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(59, 1, 'instructor_earning', 814, 'allocation:24:instructor:1', 11, 24, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(60, 2, 'instructor_earning', 446, 'allocation:24:instructor:2', 11, 24, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(61, NULL, 'platform_fee', 600, 'allocation:25:fee', 12, 25, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(62, 1, 'instructor_earning', 1400, 'allocation:25:instructor:1', 12, 25, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(63, NULL, 'platform_fee', 600, 'allocation:26:fee', 13, 26, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(64, 3, 'instructor_earning', 1400, 'allocation:26:instructor:3', 13, 26, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(65, NULL, 'platform_fee', 600, 'allocation:27:fee', 14, 27, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(66, 1, 'instructor_earning', 876, 'allocation:27:instructor:1', 14, 27, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(67, 4, 'instructor_earning', 524, 'allocation:27:instructor:4', 14, 27, NULL, NULL, NULL, '2026-09-26 14:10:53'),
(68, NULL, 'platform_fee', 480, 'allocation:28:fee', 15, 28, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(69, 1, 'instructor_earning', 43, 'allocation:28:instructor:1', 15, 28, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(70, 2, 'instructor_earning', 833, 'allocation:28:instructor:2', 15, 28, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(71, 3, 'instructor_earning', 244, 'allocation:28:instructor:3', 15, 28, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(72, NULL, 'platform_fee', 480, 'allocation:29:fee', 15, 29, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(73, 1, 'instructor_earning', 684, 'allocation:29:instructor:1', 15, 29, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(74, 3, 'instructor_earning', 436, 'allocation:29:instructor:3', 15, 29, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(75, NULL, 'platform_fee', 480, 'allocation:30:fee', 15, 30, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(76, 1, 'instructor_earning', 681, 'allocation:30:instructor:1', 15, 30, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(77, 2, 'instructor_earning', 329, 'allocation:30:instructor:2', 15, 30, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(78, 3, 'instructor_earning', 110, 'allocation:30:instructor:3', 15, 30, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(79, NULL, 'platform_fee', 480, 'allocation:31:fee', 15, 31, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(80, 1, 'instructor_earning', 238, 'allocation:31:instructor:1', 15, 31, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(81, 2, 'instructor_earning', 116, 'allocation:31:instructor:2', 15, 31, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(82, 3, 'instructor_earning', 766, 'allocation:31:instructor:3', 15, 31, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(83, NULL, 'platform_fee', 480, 'allocation:32:fee', 15, 32, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(84, 1, 'instructor_earning', 727, 'allocation:32:instructor:1', 15, 32, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(85, 2, 'instructor_earning', 302, 'allocation:32:instructor:2', 15, 32, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(86, 3, 'instructor_earning', 91, 'allocation:32:instructor:3', 15, 32, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(87, NULL, 'platform_fee', 480, 'allocation:33:fee', 15, 33, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(88, 1, 'instructor_earning', 565, 'allocation:33:instructor:1', 15, 33, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(89, 2, 'instructor_earning', 218, 'allocation:33:instructor:2', 15, 33, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(90, 3, 'instructor_earning', 337, 'allocation:33:instructor:3', 15, 33, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(91, NULL, 'platform_fee', 480, 'allocation:34:fee', 15, 34, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(92, 1, 'instructor_earning', 183, 'allocation:34:instructor:1', 15, 34, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(93, 2, 'instructor_earning', 867, 'allocation:34:instructor:2', 15, 34, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(94, 3, 'instructor_earning', 70, 'allocation:34:instructor:3', 15, 34, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(95, NULL, 'platform_fee', 480, 'allocation:35:fee', 16, 35, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(96, NULL, 'unattributed_revenue', 1120, 'allocation:35:unattributed', 16, 35, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(97, NULL, 'platform_fee', 480, 'allocation:36:fee', 16, 36, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(98, NULL, 'unattributed_revenue', 1120, 'allocation:36:unattributed', 16, 36, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(99, NULL, 'platform_fee', 480, 'allocation:37:fee', 16, 37, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(100, NULL, 'unattributed_revenue', 1120, 'allocation:37:unattributed', 16, 37, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(101, NULL, 'platform_fee', 480, 'allocation:38:fee', 16, 38, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(102, NULL, 'unattributed_revenue', 1120, 'allocation:38:unattributed', 16, 38, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(103, NULL, 'platform_fee', 480, 'allocation:39:fee', 16, 39, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(104, NULL, 'unattributed_revenue', 1120, 'allocation:39:unattributed', 16, 39, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(105, NULL, 'platform_fee', 480, 'allocation:40:fee', 17, 40, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(106, 1, 'instructor_earning', 61, 'allocation:40:instructor:1', 17, 40, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(107, 3, 'instructor_earning', 616, 'allocation:40:instructor:3', 17, 40, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(108, 4, 'instructor_earning', 443, 'allocation:40:instructor:4', 17, 40, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(109, NULL, 'platform_fee', 480, 'allocation:41:fee', 17, 41, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(110, 1, 'instructor_earning', 194, 'allocation:41:instructor:1', 17, 41, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(111, 4, 'instructor_earning', 926, 'allocation:41:instructor:4', 17, 41, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(112, NULL, 'platform_fee', 480, 'allocation:42:fee', 17, 42, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(113, 1, 'instructor_earning', 239, 'allocation:42:instructor:1', 17, 42, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(114, 3, 'instructor_earning', 322, 'allocation:42:instructor:3', 17, 42, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(115, 4, 'instructor_earning', 559, 'allocation:42:instructor:4', 17, 42, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(116, NULL, 'platform_fee', 480, 'allocation:43:fee', 17, 43, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(117, 1, 'instructor_earning', 213, 'allocation:43:instructor:1', 17, 43, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(118, 3, 'instructor_earning', 129, 'allocation:43:instructor:3', 17, 43, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(119, 4, 'instructor_earning', 778, 'allocation:43:instructor:4', 17, 43, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(120, NULL, 'platform_fee', 480, 'allocation:44:fee', 17, 44, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(121, 3, 'instructor_earning', 1079, 'allocation:44:instructor:3', 17, 44, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(122, 4, 'instructor_earning', 41, 'allocation:44:instructor:4', 17, 44, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(123, NULL, 'platform_fee', 480, 'allocation:45:fee', 17, 45, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(124, 1, 'instructor_earning', 403, 'allocation:45:instructor:1', 17, 45, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(125, 3, 'instructor_earning', 543, 'allocation:45:instructor:3', 17, 45, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(126, 4, 'instructor_earning', 174, 'allocation:45:instructor:4', 17, 45, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(127, NULL, 'platform_fee', 480, 'allocation:46:fee', 17, 46, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(128, 3, 'instructor_earning', 44, 'allocation:46:instructor:3', 17, 46, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(129, 4, 'instructor_earning', 1076, 'allocation:46:instructor:4', 17, 46, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(130, NULL, 'platform_fee', 480, 'allocation:47:fee', 17, 47, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(131, 1, 'instructor_earning', 697, 'allocation:47:instructor:1', 17, 47, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(132, 3, 'instructor_earning', 301, 'allocation:47:instructor:3', 17, 47, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(133, 4, 'instructor_earning', 122, 'allocation:47:instructor:4', 17, 47, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(134, NULL, 'platform_fee', 480, 'allocation:48:fee', 17, 48, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(135, 1, 'instructor_earning', 294, 'allocation:48:instructor:1', 17, 48, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(136, 3, 'instructor_earning', 317, 'allocation:48:instructor:3', 17, 48, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(137, 4, 'instructor_earning', 509, 'allocation:48:instructor:4', 17, 48, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(138, NULL, 'platform_fee', 480, 'allocation:49:fee', 18, 49, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(139, 2, 'instructor_earning', 1120, 'allocation:49:instructor:2', 18, 49, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(140, NULL, 'platform_fee', 480, 'allocation:50:fee', 18, 50, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(141, 2, 'instructor_earning', 1120, 'allocation:50:instructor:2', 18, 50, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(142, NULL, 'platform_fee', 480, 'allocation:51:fee', 18, 51, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(143, 2, 'instructor_earning', 1120, 'allocation:51:instructor:2', 18, 51, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(144, NULL, 'platform_fee', 480, 'allocation:52:fee', 18, 52, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(145, 2, 'instructor_earning', 1120, 'allocation:52:instructor:2', 18, 52, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(146, NULL, 'platform_fee', 480, 'allocation:53:fee', 18, 53, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(147, 2, 'instructor_earning', 1120, 'allocation:53:instructor:2', 18, 53, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(148, NULL, 'platform_fee', 480, 'allocation:54:fee', 18, 54, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(149, 2, 'instructor_earning', 1120, 'allocation:54:instructor:2', 18, 54, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(150, NULL, 'platform_fee', 480, 'allocation:55:fee', 19, 55, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(151, 1, 'instructor_earning', 481, 'allocation:55:instructor:1', 19, 55, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(152, 3, 'instructor_earning', 639, 'allocation:55:instructor:3', 19, 55, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(153, NULL, 'platform_fee', 480, 'allocation:56:fee', 19, 56, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(154, 1, 'instructor_earning', 909, 'allocation:56:instructor:1', 19, 56, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(155, 3, 'instructor_earning', 211, 'allocation:56:instructor:3', 19, 56, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(156, NULL, 'platform_fee', 540, 'allocation:57:fee', 20, 57, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(157, 1, 'instructor_earning', 1260, 'allocation:57:instructor:1', 20, 57, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(158, NULL, 'platform_fee', 540, 'allocation:58:fee', 20, 58, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(159, 1, 'instructor_earning', 1260, 'allocation:58:instructor:1', 20, 58, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(160, NULL, 'platform_fee', 540, 'allocation:59:fee', 20, 59, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(161, 1, 'instructor_earning', 1260, 'allocation:59:instructor:1', 20, 59, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(162, NULL, 'platform_fee', 480, 'allocation:60:fee', 21, 60, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(163, NULL, 'unattributed_revenue', 1120, 'allocation:60:unattributed', 21, 60, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(164, NULL, 'platform_fee', 480, 'allocation:61:fee', 21, 61, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(165, NULL, 'unattributed_revenue', 1120, 'allocation:61:unattributed', 21, 61, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(166, NULL, 'platform_fee', 480, 'allocation:62:fee', 21, 62, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(167, NULL, 'unattributed_revenue', 1120, 'allocation:62:unattributed', 21, 62, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(168, NULL, 'platform_fee', 480, 'allocation:63:fee', 21, 63, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(169, NULL, 'unattributed_revenue', 1120, 'allocation:63:unattributed', 21, 63, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(170, NULL, 'platform_fee', 480, 'allocation:64:fee', 21, 64, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(171, NULL, 'unattributed_revenue', 1120, 'allocation:64:unattributed', 21, 64, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(172, NULL, 'platform_fee', 480, 'allocation:65:fee', 21, 65, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(173, NULL, 'unattributed_revenue', 1120, 'allocation:65:unattributed', 21, 65, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(174, NULL, 'platform_fee', 480, 'allocation:66:fee', 21, 66, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(175, NULL, 'unattributed_revenue', 1120, 'allocation:66:unattributed', 21, 66, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(176, NULL, 'platform_fee', 480, 'allocation:67:fee', 21, 67, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(177, NULL, 'unattributed_revenue', 1120, 'allocation:67:unattributed', 21, 67, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(178, NULL, 'platform_fee', 480, 'allocation:68:fee', 22, 68, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(179, 3, 'instructor_earning', 583, 'allocation:68:instructor:3', 22, 68, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(180, 4, 'instructor_earning', 537, 'allocation:68:instructor:4', 22, 68, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(181, NULL, 'platform_fee', 480, 'allocation:69:fee', 22, 69, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(182, 3, 'instructor_earning', 536, 'allocation:69:instructor:3', 22, 69, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(183, 4, 'instructor_earning', 584, 'allocation:69:instructor:4', 22, 69, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(184, NULL, 'platform_fee', 480, 'allocation:70:fee', 22, 70, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(185, 3, 'instructor_earning', 611, 'allocation:70:instructor:3', 22, 70, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(186, 4, 'instructor_earning', 509, 'allocation:70:instructor:4', 22, 70, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(187, NULL, 'platform_fee', 480, 'allocation:71:fee', 22, 71, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(188, 3, 'instructor_earning', 822, 'allocation:71:instructor:3', 22, 71, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(189, 4, 'instructor_earning', 298, 'allocation:71:instructor:4', 22, 71, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(190, NULL, 'platform_fee', 480, 'allocation:72:fee', 22, 72, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(191, 3, 'instructor_earning', 291, 'allocation:72:instructor:3', 22, 72, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(192, 4, 'instructor_earning', 829, 'allocation:72:instructor:4', 22, 72, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(193, NULL, 'platform_fee', 480, 'allocation:73:fee', 22, 73, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(194, 3, 'instructor_earning', 394, 'allocation:73:instructor:3', 22, 73, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(195, 4, 'instructor_earning', 726, 'allocation:73:instructor:4', 22, 73, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(196, NULL, 'platform_fee', 540, 'allocation:74:fee', 23, 74, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(197, 4, 'instructor_earning', 1260, 'allocation:74:instructor:4', 23, 74, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(198, NULL, 'platform_fee', 540, 'allocation:75:fee', 23, 75, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(199, 4, 'instructor_earning', 1260, 'allocation:75:instructor:4', 23, 75, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(200, NULL, 'platform_fee', 540, 'allocation:76:fee', 23, 76, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(201, 4, 'instructor_earning', 1260, 'allocation:76:instructor:4', 23, 76, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(202, NULL, 'platform_fee', 540, 'allocation:77:fee', 24, 77, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(203, 1, 'instructor_earning', 192, 'allocation:77:instructor:1', 24, 77, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(204, 3, 'instructor_earning', 251, 'allocation:77:instructor:3', 24, 77, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(205, 4, 'instructor_earning', 817, 'allocation:77:instructor:4', 24, 77, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(206, NULL, 'platform_fee', 540, 'allocation:78:fee', 24, 78, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(207, 1, 'instructor_earning', 854, 'allocation:78:instructor:1', 24, 78, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(208, 3, 'instructor_earning', 65, 'allocation:78:instructor:3', 24, 78, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(209, 4, 'instructor_earning', 341, 'allocation:78:instructor:4', 24, 78, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(210, NULL, 'platform_fee', 540, 'allocation:79:fee', 24, 79, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(211, 3, 'instructor_earning', 734, 'allocation:79:instructor:3', 24, 79, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(212, 4, 'instructor_earning', 526, 'allocation:79:instructor:4', 24, 79, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(213, NULL, 'platform_fee', 600, 'allocation:80:fee', 25, 80, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(214, 1, 'instructor_earning', 623, 'allocation:80:instructor:1', 25, 80, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(215, 4, 'instructor_earning', 777, 'allocation:80:instructor:4', 25, 80, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(216, NULL, 'platform_fee', 480, 'allocation:81:fee', 26, 81, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(217, 2, 'instructor_earning', 198, 'allocation:81:instructor:2', 26, 81, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(218, 4, 'instructor_earning', 922, 'allocation:81:instructor:4', 26, 81, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(219, NULL, 'platform_fee', 480, 'allocation:82:fee', 26, 82, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(220, 2, 'instructor_earning', 910, 'allocation:82:instructor:2', 26, 82, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(221, 4, 'instructor_earning', 210, 'allocation:82:instructor:4', 26, 82, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(222, NULL, 'platform_fee', 480, 'allocation:83:fee', 26, 83, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(223, 2, 'instructor_earning', 644, 'allocation:83:instructor:2', 26, 83, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(224, 4, 'instructor_earning', 476, 'allocation:83:instructor:4', 26, 83, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(225, NULL, 'platform_fee', 480, 'allocation:84:fee', 26, 84, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(226, 2, 'instructor_earning', 157, 'allocation:84:instructor:2', 26, 84, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(227, 4, 'instructor_earning', 963, 'allocation:84:instructor:4', 26, 84, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(228, NULL, 'platform_fee', 480, 'allocation:85:fee', 26, 85, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(229, 2, 'instructor_earning', 219, 'allocation:85:instructor:2', 26, 85, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(230, 4, 'instructor_earning', 901, 'allocation:85:instructor:4', 26, 85, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(231, NULL, 'platform_fee', 480, 'allocation:86:fee', 26, 86, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(232, 2, 'instructor_earning', 877, 'allocation:86:instructor:2', 26, 86, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(233, 4, 'instructor_earning', 243, 'allocation:86:instructor:4', 26, 86, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(234, NULL, 'platform_fee', 480, 'allocation:87:fee', 26, 87, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(235, 2, 'instructor_earning', 850, 'allocation:87:instructor:2', 26, 87, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(236, 4, 'instructor_earning', 270, 'allocation:87:instructor:4', 26, 87, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(237, NULL, 'platform_fee', 480, 'allocation:88:fee', 26, 88, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(238, 2, 'instructor_earning', 65, 'allocation:88:instructor:2', 26, 88, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(239, 4, 'instructor_earning', 1055, 'allocation:88:instructor:4', 26, 88, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(240, NULL, 'platform_fee', 480, 'allocation:89:fee', 27, 89, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(241, 1, 'instructor_earning', 428, 'allocation:89:instructor:1', 27, 89, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(242, 3, 'instructor_earning', 692, 'allocation:89:instructor:3', 27, 89, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(243, NULL, 'platform_fee', 480, 'allocation:90:fee', 27, 90, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(244, 1, 'instructor_earning', 265, 'allocation:90:instructor:1', 27, 90, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(245, 3, 'instructor_earning', 855, 'allocation:90:instructor:3', 27, 90, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(246, NULL, 'platform_fee', 480, 'allocation:91:fee', 27, 91, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(247, 1, 'instructor_earning', 351, 'allocation:91:instructor:1', 27, 91, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(248, 3, 'instructor_earning', 769, 'allocation:91:instructor:3', 27, 91, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(249, NULL, 'platform_fee', 480, 'allocation:92:fee', 27, 92, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(250, 1, 'instructor_earning', 1048, 'allocation:92:instructor:1', 27, 92, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(251, 3, 'instructor_earning', 72, 'allocation:92:instructor:3', 27, 92, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(252, NULL, 'platform_fee', 480, 'allocation:93:fee', 27, 93, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(253, 1, 'instructor_earning', 783, 'allocation:93:instructor:1', 27, 93, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(254, 3, 'instructor_earning', 337, 'allocation:93:instructor:3', 27, 93, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(255, NULL, 'platform_fee', 480, 'allocation:94:fee', 27, 94, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(256, 1, 'instructor_earning', 700, 'allocation:94:instructor:1', 27, 94, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(257, 3, 'instructor_earning', 420, 'allocation:94:instructor:3', 27, 94, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(258, NULL, 'platform_fee', 480, 'allocation:95:fee', 27, 95, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(259, 1, 'instructor_earning', 371, 'allocation:95:instructor:1', 27, 95, NULL, NULL, NULL, '2026-09-26 14:10:54'),
(260, 3, 'instructor_earning', 749, 'allocation:95:instructor:3', 27, 95, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(261, NULL, 'platform_fee', 600, 'allocation:96:fee', 28, 96, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(262, 3, 'instructor_earning', 985, 'allocation:96:instructor:3', 28, 96, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(263, 4, 'instructor_earning', 415, 'allocation:96:instructor:4', 28, 96, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(264, NULL, 'platform_fee', 600, 'allocation:97:fee', 29, 97, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(265, 1, 'instructor_earning', 566, 'allocation:97:instructor:1', 29, 97, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(266, 2, 'instructor_earning', 834, 'allocation:97:instructor:2', 29, 97, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(267, NULL, 'platform_fee', 480, 'allocation:98:fee', 30, 98, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(268, NULL, 'unattributed_revenue', 1120, 'allocation:98:unattributed', 30, 98, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(269, NULL, 'platform_fee', 480, 'allocation:99:fee', 30, 99, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(270, NULL, 'unattributed_revenue', 1120, 'allocation:99:unattributed', 30, 99, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(271, NULL, 'platform_fee', 480, 'allocation:100:fee', 30, 100, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(272, NULL, 'unattributed_revenue', 1120, 'allocation:100:unattributed', 30, 100, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(273, NULL, 'platform_fee', 480, 'allocation:101:fee', 30, 101, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(274, NULL, 'unattributed_revenue', 1120, 'allocation:101:unattributed', 30, 101, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(275, NULL, 'platform_fee', 480, 'allocation:102:fee', 30, 102, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(276, NULL, 'unattributed_revenue', 1120, 'allocation:102:unattributed', 30, 102, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(277, NULL, 'platform_fee', 480, 'allocation:103:fee', 30, 103, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(278, NULL, 'unattributed_revenue', 1120, 'allocation:103:unattributed', 30, 103, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(279, NULL, 'platform_fee', 1920, 'allocation:104:fee', 1, 104, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(280, 1, 'instructor_earning', 4480, 'allocation:104:instructor:1', 1, 104, NULL, NULL, NULL, '2026-09-26 14:10:55'),
(281, NULL, 'refund_clawback', -9600, 'refund:2:platform', 30, NULL, 2, NULL, NULL, '2026-09-26 14:10:55'),
(282, 1, 'payout_debit', -16732, 'payout:1:debit', NULL, NULL, NULL, 1, NULL, '2026-09-26 14:10:55'),
(283, 2, 'payout_debit', -8177, 'payout:2:debit', NULL, NULL, NULL, 2, NULL, '2026-09-26 14:10:56');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_09_26_000001_create_catalog_tables', 1),
(5, '2026_09_26_000002_create_subscription_tables', 1),
(6, '2026_09_26_000003_create_ledger_and_payout_tables', 1);

-- --------------------------------------------------------

--
-- Table structure for table `mock_provider_transfers`
--

CREATE TABLE `mock_provider_transfers` (
  `id` bigint UNSIGNED NOT NULL,
  `idempotency_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `failure_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mock_provider_transfers`
--

INSERT INTO `mock_provider_transfers` (`id`, `idempotency_key`, `reference`, `destination`, `amount_cents`, `status`, `failure_reason`, `created_at`, `updated_at`) VALUES
(1, '5087b90f-848a-47fe-aff1-e6a82f3def9d', 'tr_fsmzb2zgw5bei56cuhwt', 'acct_sara001', 16732, 'succeeded', NULL, '2026-09-26 11:10:56', '2026-09-26 11:10:56'),
(2, '34951d16-1592-41a3-813f-878bf660b95e', 'tr_x5ivwurxmvcomjzahcom', 'acct_omar002', 8177, 'succeeded', NULL, '2026-09-26 11:10:56', '2026-09-26 11:11:01'),
(3, '8034430c-d332-4d9c-b2d7-15f821aef35e', 'tr_t3zfwmq53feas4l6uirz', 'acct_sara001', 16733, 'succeeded', NULL, '2026-09-27 17:25:31', '2026-09-27 17:25:31'),
(4, 'aa846534-3942-4b82-8966-8f3f3024f8ac', 'tr_xbbdbbszq66l1vz3tidc', 'acct_laila03', 23736, 'succeeded', NULL, '2026-09-27 17:25:31', '2026-09-27 17:25:31'),
(5, 'ed1be186-ac45-4c68-aa5a-68c837ebd8f4', 'tr_eclhoakhlsepwqywjghy', 'acct_omar002', 8177, 'succeeded', NULL, '2026-09-27 17:25:43', '2026-09-27 17:25:43');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payouts`
--

CREATE TABLE `payouts` (
  `id` bigint UNSIGNED NOT NULL,
  `instructor_id` bigint UNSIGNED NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `idempotency_key` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider_reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_updated_at` datetime DEFAULT NULL,
  `attempts` int UNSIGNED NOT NULL DEFAULT '0',
  `last_error` text COLLATE utf8mb4_unicode_ci,
  `requested_at` datetime NOT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payouts`
--

INSERT INTO `payouts` (`id`, `instructor_id`, `amount_cents`, `status`, `idempotency_key`, `provider_reference`, `provider_updated_at`, `attempts`, `last_error`, `requested_at`, `submitted_at`, `completed_at`, `created_at`, `updated_at`) VALUES
(1, 1, 16732, 'succeeded', '5087b90f-848a-47fe-aff1-e6a82f3def9d', 'tr_fsmzb2zgw5bei56cuhwt', '2026-09-26 14:10:56', 1, NULL, '2026-09-26 14:10:55', '2026-09-26 14:10:56', '2026-09-26 14:10:56', '2026-09-26 11:10:55', '2026-09-26 11:10:56'),
(2, 2, 8177, 'succeeded', '34951d16-1592-41a3-813f-878bf660b95e', 'tr_x5ivwurxmvcomjzahcom', '2026-09-26 14:11:01', 2, NULL, '2026-09-26 14:10:56', '2026-09-26 14:10:56', '2026-09-26 14:11:01', '2026-09-26 11:10:56', '2026-09-26 11:11:01');

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE `plans` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `interval_months` tinyint UNSIGNED NOT NULL,
  `price_cents` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plans`
--

INSERT INTO `plans` (`id`, `name`, `interval_months`, `price_cents`, `created_at`, `updated_at`) VALUES
(1, 'Monthly', 1, 2000, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(2, 'Quarterly', 3, 5400, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(3, 'Annual', 12, 19200, '2026-09-26 11:10:51', '2026-09-26 11:10:51');

-- --------------------------------------------------------

--
-- Table structure for table `provider_webhook_events`
--

CREATE TABLE `provider_webhook_events` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json NOT NULL,
  `processed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `provider_webhook_events`
--

INSERT INTO `provider_webhook_events` (`id`, `event_id`, `type`, `payload`, `processed_at`, `created_at`) VALUES
(1, 'evt_koadf1j2qda6lkd9szjvfvgt', 'transfer.succeeded', '{\"id\": \"evt_koadf1j2qda6lkd9szjvfvgt\", \"data\": {\"status\": \"succeeded\", \"reference\": \"tr_fsmzb2zgw5bei56cuhwt\", \"amount_cents\": 16732, \"failure_reason\": null, \"idempotency_key\": \"5087b90f-848a-47fe-aff1-e6a82f3def9d\"}, \"type\": \"transfer.succeeded\", \"occurred_at\": \"2026-09-26T14:10:56.144058Z\"}', '2026-09-26 14:10:58', '2026-09-26 14:10:58'),
(2, 'evt_0pcygziuchzdl0qe3rz4wj0v', 'transfer.succeeded', '{\"id\": \"evt_0pcygziuchzdl0qe3rz4wj0v\", \"data\": {\"status\": \"succeeded\", \"reference\": \"tr_x5ivwurxmvcomjzahcom\", \"amount_cents\": 8177, \"failure_reason\": null, \"idempotency_key\": \"34951d16-1592-41a3-813f-878bf660b95e\"}, \"type\": \"transfer.succeeded\", \"occurred_at\": \"2026-09-26T14:11:01.175580Z\"}', '2026-09-26 14:11:01', '2026-09-26 14:11:01'),
(3, 'evt_tqrsaxbgkzlwc6mlop27blpu', 'transfer.succeeded', '{\"id\": \"evt_tqrsaxbgkzlwc6mlop27blpu\", \"data\": {\"status\": \"succeeded\", \"reference\": \"tr_t3zfwmq53feas4l6uirz\", \"amount_cents\": 16733, \"failure_reason\": null, \"idempotency_key\": \"8034430c-d332-4d9c-b2d7-15f821aef35e\"}, \"type\": \"transfer.succeeded\", \"occurred_at\": \"2026-09-27T20:25:31.596996Z\"}', '2026-09-27 20:25:31', '2026-09-27 20:25:31'),
(4, 'evt_dvgf8fitj9qmoomfbanvelar', 'transfer.succeeded', '{\"id\": \"evt_dvgf8fitj9qmoomfbanvelar\", \"data\": {\"status\": \"succeeded\", \"reference\": \"tr_xbbdbbszq66l1vz3tidc\", \"amount_cents\": 23736, \"failure_reason\": null, \"idempotency_key\": \"aa846534-3942-4b82-8966-8f3f3024f8ac\"}, \"type\": \"transfer.succeeded\", \"occurred_at\": \"2026-09-27T20:25:31.701199Z\"}', '2026-09-27 20:25:31', '2026-09-27 20:25:31'),
(5, 'evt_vsruiapdcn63zgrtolgik78n', 'transfer.succeeded', '{\"id\": \"evt_vsruiapdcn63zgrtolgik78n\", \"data\": {\"status\": \"succeeded\", \"reference\": \"tr_eclhoakhlsepwqywjghy\", \"amount_cents\": 8177, \"failure_reason\": null, \"idempotency_key\": \"ed1be186-ac45-4c68-aa5a-68c837ebd8f4\"}, \"type\": \"transfer.succeeded\", \"occurred_at\": \"2026-09-27T20:25:43.836915Z\"}', '2026-09-27 20:25:43', '2026-09-27 20:25:43');

-- --------------------------------------------------------

--
-- Table structure for table `refunds`
--

CREATE TABLE `refunds` (
  `id` bigint UNSIGNED NOT NULL,
  `subscription_id` bigint UNSIGNED NOT NULL,
  `idempotency_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `unearned_cents` bigint UNSIGNED NOT NULL,
  `clawback_cents` bigint UNSIGNED NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `refunds`
--

INSERT INTO `refunds` (`id`, `subscription_id`, `idempotency_key`, `amount_cents`, `unearned_cents`, `clawback_cents`, `reason`, `created_at`, `updated_at`) VALUES
(1, 1, 'seed-refund-partial', 9600, 9600, 0, 'Customer asked to cancel', '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(2, 30, 'seed-refund-full', 19200, 9600, 9600, 'Chargeback', '2026-09-26 11:10:55', '2026-09-26 11:10:55');

-- --------------------------------------------------------

--
-- Table structure for table `revenue_allocations`
--

CREATE TABLE `revenue_allocations` (
  `id` bigint UNSIGNED NOT NULL,
  `subscription_id` bigint UNSIGNED NOT NULL,
  `period_index` tinyint UNSIGNED NOT NULL,
  `period_starts_at` datetime NOT NULL,
  `period_ends_at` datetime NOT NULL,
  `gross_cents` bigint UNSIGNED NOT NULL,
  `platform_cents` bigint UNSIGNED NOT NULL,
  `instructor_cents` bigint UNSIGNED NOT NULL,
  `is_settlement` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `revenue_allocations`
--

INSERT INTO `revenue_allocations` (`id`, `subscription_id`, `period_index`, `period_starts_at`, `period_ends_at`, `gross_cents`, `platform_cents`, `instructor_cents`, `is_settlement`, `created_at`, `updated_at`) VALUES
(1, 1, 0, '2026-07-05 00:00:00', '2026-08-05 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(2, 1, 1, '2026-08-05 00:00:00', '2026-09-05 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(3, 2, 0, '2026-05-24 00:00:00', '2026-06-24 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(4, 2, 1, '2026-06-24 00:00:00', '2026-07-24 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(5, 2, 2, '2026-07-24 00:00:00', '2026-08-24 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(6, 2, 3, '2026-08-24 00:00:00', '2026-09-24 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(7, 3, 0, '2026-03-05 00:00:00', '2026-04-05 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(8, 3, 1, '2026-04-05 00:00:00', '2026-05-05 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(9, 3, 2, '2026-05-05 00:00:00', '2026-06-05 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(10, 4, 0, '2026-08-22 00:00:00', '2026-09-22 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(11, 5, 0, '2026-08-08 00:00:00', '2026-09-08 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(12, 6, 0, '2026-02-08 00:00:00', '2026-03-08 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(13, 7, 0, '2026-06-13 00:00:00', '2026-07-13 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(14, 8, 0, '2026-07-06 00:00:00', '2026-08-06 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(15, 8, 1, '2026-08-06 00:00:00', '2026-09-06 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(16, 9, 0, '2026-02-18 00:00:00', '2026-03-18 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(17, 9, 1, '2026-03-18 00:00:00', '2026-04-18 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(18, 9, 2, '2026-04-18 00:00:00', '2026-05-18 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(19, 10, 0, '2026-05-08 00:00:00', '2026-06-08 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(20, 10, 1, '2026-06-08 00:00:00', '2026-07-08 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(21, 10, 2, '2026-07-08 00:00:00', '2026-08-08 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(22, 11, 0, '2026-04-22 00:00:00', '2026-05-22 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(23, 11, 1, '2026-05-22 00:00:00', '2026-06-22 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(24, 11, 2, '2026-06-22 00:00:00', '2026-07-22 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(25, 12, 0, '2026-03-12 00:00:00', '2026-04-12 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(26, 13, 0, '2026-01-04 00:00:00', '2026-02-04 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(27, 14, 0, '2026-02-24 00:00:00', '2026-03-24 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(28, 15, 0, '2026-01-29 00:00:00', '2026-02-28 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(29, 15, 1, '2026-02-28 00:00:00', '2026-03-29 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(30, 15, 2, '2026-03-29 00:00:00', '2026-04-29 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(31, 15, 3, '2026-04-29 00:00:00', '2026-05-29 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(32, 15, 4, '2026-05-29 00:00:00', '2026-06-29 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(33, 15, 5, '2026-06-29 00:00:00', '2026-07-29 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(34, 15, 6, '2026-07-29 00:00:00', '2026-08-29 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(35, 16, 0, '2026-03-31 00:00:00', '2026-04-30 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(36, 16, 1, '2026-04-30 00:00:00', '2026-05-31 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(37, 16, 2, '2026-05-31 00:00:00', '2026-06-30 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(38, 16, 3, '2026-06-30 00:00:00', '2026-07-31 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(39, 16, 4, '2026-07-31 00:00:00', '2026-08-31 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(40, 17, 0, '2025-12-18 00:00:00', '2026-01-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(41, 17, 1, '2026-01-18 00:00:00', '2026-02-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(42, 17, 2, '2026-02-18 00:00:00', '2026-03-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(43, 17, 3, '2026-03-18 00:00:00', '2026-04-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(44, 17, 4, '2026-04-18 00:00:00', '2026-05-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(45, 17, 5, '2026-05-18 00:00:00', '2026-06-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(46, 17, 6, '2026-06-18 00:00:00', '2026-07-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(47, 17, 7, '2026-07-18 00:00:00', '2026-08-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(48, 17, 8, '2026-08-18 00:00:00', '2026-09-18 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(49, 18, 0, '2026-03-19 00:00:00', '2026-04-19 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(50, 18, 1, '2026-04-19 00:00:00', '2026-05-19 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(51, 18, 2, '2026-05-19 00:00:00', '2026-06-19 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(52, 18, 3, '2026-06-19 00:00:00', '2026-07-19 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(53, 18, 4, '2026-07-19 00:00:00', '2026-08-19 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(54, 18, 5, '2026-08-19 00:00:00', '2026-09-19 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(55, 19, 0, '2026-07-01 00:00:00', '2026-08-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(56, 19, 1, '2026-08-01 00:00:00', '2026-09-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(57, 20, 0, '2026-02-13 00:00:00', '2026-03-13 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(58, 20, 1, '2026-03-13 00:00:00', '2026-04-13 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(59, 20, 2, '2026-04-13 00:00:00', '2026-05-13 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(60, 21, 0, '2026-01-02 00:00:00', '2026-02-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(61, 21, 1, '2026-02-02 00:00:00', '2026-03-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(62, 21, 2, '2026-03-02 00:00:00', '2026-04-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(63, 21, 3, '2026-04-02 00:00:00', '2026-05-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(64, 21, 4, '2026-05-02 00:00:00', '2026-06-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(65, 21, 5, '2026-06-02 00:00:00', '2026-07-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(66, 21, 6, '2026-07-02 00:00:00', '2026-08-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(67, 21, 7, '2026-08-02 00:00:00', '2026-09-02 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(68, 22, 0, '2026-03-25 00:00:00', '2026-04-25 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(69, 22, 1, '2026-04-25 00:00:00', '2026-05-25 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(70, 22, 2, '2026-05-25 00:00:00', '2026-06-25 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(71, 22, 3, '2026-06-25 00:00:00', '2026-07-25 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(72, 22, 4, '2026-07-25 00:00:00', '2026-08-25 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(73, 22, 5, '2026-08-25 00:00:00', '2026-09-25 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(74, 23, 0, '2026-03-09 00:00:00', '2026-04-09 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(75, 23, 1, '2026-04-09 00:00:00', '2026-05-09 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(76, 23, 2, '2026-05-09 00:00:00', '2026-06-09 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(77, 24, 0, '2026-04-06 00:00:00', '2026-05-06 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(78, 24, 1, '2026-05-06 00:00:00', '2026-06-06 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(79, 24, 2, '2026-06-06 00:00:00', '2026-07-06 00:00:00', 1800, 540, 1260, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(80, 25, 0, '2026-03-05 00:00:00', '2026-04-05 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(81, 26, 0, '2026-01-22 00:00:00', '2026-02-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(82, 26, 1, '2026-02-22 00:00:00', '2026-03-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(83, 26, 2, '2026-03-22 00:00:00', '2026-04-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(84, 26, 3, '2026-04-22 00:00:00', '2026-05-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(85, 26, 4, '2026-05-22 00:00:00', '2026-06-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(86, 26, 5, '2026-06-22 00:00:00', '2026-07-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(87, 26, 6, '2026-07-22 00:00:00', '2026-08-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(88, 26, 7, '2026-08-22 00:00:00', '2026-09-22 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(89, 27, 0, '2026-02-01 00:00:00', '2026-03-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(90, 27, 1, '2026-03-01 00:00:00', '2026-04-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(91, 27, 2, '2026-04-01 00:00:00', '2026-05-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(92, 27, 3, '2026-05-01 00:00:00', '2026-06-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(93, 27, 4, '2026-06-01 00:00:00', '2026-07-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(94, 27, 5, '2026-07-01 00:00:00', '2026-08-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(95, 27, 6, '2026-08-01 00:00:00', '2026-09-01 00:00:00', 1600, 480, 1120, 0, '2026-09-26 11:10:54', '2026-09-26 11:10:54'),
(96, 28, 0, '2026-04-11 00:00:00', '2026-05-11 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(97, 29, 0, '2026-06-08 00:00:00', '2026-07-08 00:00:00', 2000, 600, 1400, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(98, 30, 0, '2026-03-07 00:00:00', '2026-04-07 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(99, 30, 1, '2026-04-07 00:00:00', '2026-05-07 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(100, 30, 2, '2026-05-07 00:00:00', '2026-06-07 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(101, 30, 3, '2026-06-07 00:00:00', '2026-07-07 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(102, 30, 4, '2026-07-07 00:00:00', '2026-08-07 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(103, 30, 5, '2026-08-07 00:00:00', '2026-09-07 00:00:00', 1600, 1600, 0, 0, '2026-09-26 11:10:55', '2026-09-26 11:10:55'),
(104, 1, 2, '2026-09-05 00:00:00', '2026-09-26 14:10:55', 6400, 1920, 4480, 1, '2026-09-26 11:10:55', '2026-09-26 11:10:55');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('hykIek6li0BxmECUmRceQQ5bje2KJpoEMZZhmz4L', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoiUENWcGFyVkhGNzNCNHFWTjhPV3NyQXhYaWoxVTJrVWt1amZMd1hvUSI7czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjM1OiJodHRwOi8vbG1zLnRlc3QvYWRtaW4vaW5zdHJ1Y3RvcnMvMiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjA6IiQyeSQxMiRRR3FIeU1WZENNc2dDUm1FZzRMNkwudW9rdmVOTDl4enlqL0xObHNIV1RtMjBTa0pvR0o3aSI7fQ==', 1790541097);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `email`, `created_at`, `updated_at`) VALUES
(1, 'Norberto Prosacco', 'aubree81@example.org', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(2, 'Aron Langosh', 'bettie71@example.net', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(3, 'Tremayne Bruen', 'uemmerich@example.com', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(4, 'Candelario Dooley', 'arch.kilback@example.net', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(5, 'Lilliana Braun', 'elbert41@example.org', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(6, 'Dexter Senger Jr.', 'reinger.hailee@example.com', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(7, 'Davion Balistreri', 'susie82@example.net', '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(8, 'Prof. Anderson Farrell PhD', 'christy57@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(9, 'Jamaal Schultz Jr.', 'judson14@example.com', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(10, 'Prof. Kristofer Purdy DDS', 'parker.toy@example.net', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(11, 'Prof. Toni Leannon', 'mosciski.eusebio@example.net', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(12, 'Eldora Kuvalis', 'abbott.edgar@example.com', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(13, 'Chelsea Bednar', 'frempel@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(14, 'Bradley Feil', 'bernier.edgardo@example.net', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(15, 'Reymundo Jacobs DVM', 'zmohr@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(16, 'Aimee DuBuque', 'bobbie.fay@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(17, 'Rae Becker IV', 'brandon15@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(18, 'Dr. Gwendolyn Keeling DVM', 'seamus44@example.net', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(19, 'Dr. Hollis Hand', 'zfeil@example.net', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(20, 'Sophie Connelly', 'sanford.maggie@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(21, 'Tiana Mann', 'sgislason@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(22, 'Serena Fay PhD', 'wilburn.hansen@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(23, 'Mr. Jordan Gorczany Jr.', 'usipes@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(24, 'Mabelle Marks', 'xander.stroman@example.org', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(25, 'Prof. Sven Robel DDS', 'greenfelder.rhett@example.com', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(26, 'Dereck Ernser', 'treutel.trent@example.net', '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(27, 'Korbin Kub II', 'ihomenick@example.net', '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(28, 'Miss Veronica Kunde', 'wsteuber@example.org', '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(29, 'Dulce Murray', 'uwest@example.org', '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(30, 'Peyton Murphy', 'okeefe.reanna@example.org', '2026-09-26 11:10:53', '2026-09-26 11:10:53');

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NOT NULL,
  `plan_id` bigint UNSIGNED NOT NULL,
  `amount_cents` bigint UNSIGNED NOT NULL,
  `platform_fee_bps` smallint UNSIGNED NOT NULL,
  `periods` tinyint UNSIGNED NOT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `refunded_cents` bigint UNSIGNED NOT NULL DEFAULT '0',
  `refunded_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `student_id`, `plan_id`, `amount_cents`, `platform_fee_bps`, `periods`, `starts_at`, `ends_at`, `status`, `refunded_cents`, `refunded_at`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 19200, 3000, 12, '2026-07-05 00:00:00', '2027-07-05 00:00:00', 'refunded', 9600, '2026-09-26 14:10:55', '2026-09-26 11:10:51', '2026-09-26 11:10:55'),
(2, 2, 3, 19200, 3000, 12, '2026-05-24 00:00:00', '2027-05-24 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(3, 3, 2, 5400, 3000, 3, '2026-03-05 00:00:00', '2026-06-05 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(4, 4, 2, 5400, 3000, 3, '2026-08-22 00:00:00', '2026-11-22 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(5, 5, 1, 2000, 3000, 1, '2026-08-08 00:00:00', '2026-09-08 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(6, 6, 1, 2000, 3000, 1, '2026-02-08 00:00:00', '2026-03-08 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(7, 7, 1, 2000, 3000, 1, '2026-06-13 00:00:00', '2026-07-13 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51'),
(8, 8, 3, 19200, 3000, 12, '2026-07-06 00:00:00', '2027-07-06 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(9, 9, 2, 5400, 3000, 3, '2026-02-18 00:00:00', '2026-05-18 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(10, 10, 2, 5400, 3000, 3, '2026-05-08 00:00:00', '2026-08-08 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(11, 11, 2, 5400, 3000, 3, '2026-04-22 00:00:00', '2026-07-22 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(12, 12, 1, 2000, 3000, 1, '2026-03-12 00:00:00', '2026-04-12 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(13, 13, 1, 2000, 3000, 1, '2026-01-04 00:00:00', '2026-02-04 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(14, 14, 1, 2000, 3000, 1, '2026-02-24 00:00:00', '2026-03-24 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(15, 15, 3, 19200, 3000, 12, '2026-01-29 00:00:00', '2027-01-29 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(16, 16, 3, 19200, 3000, 12, '2026-03-31 00:00:00', '2027-03-31 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(17, 17, 3, 19200, 3000, 12, '2025-12-18 00:00:00', '2026-12-18 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(18, 18, 3, 19200, 3000, 12, '2026-03-19 00:00:00', '2027-03-19 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(19, 19, 3, 19200, 3000, 12, '2026-07-01 00:00:00', '2027-07-01 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(20, 20, 2, 5400, 3000, 3, '2026-02-13 00:00:00', '2026-05-13 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(21, 21, 3, 19200, 3000, 12, '2026-01-02 00:00:00', '2027-01-02 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(22, 22, 3, 19200, 3000, 12, '2026-03-25 00:00:00', '2027-03-25 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(23, 23, 2, 5400, 3000, 3, '2026-03-09 00:00:00', '2026-06-09 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(24, 24, 2, 5400, 3000, 3, '2026-04-06 00:00:00', '2026-07-06 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(25, 25, 1, 2000, 3000, 1, '2026-03-05 00:00:00', '2026-04-05 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(26, 26, 3, 19200, 3000, 12, '2026-01-22 00:00:00', '2027-01-22 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:52', '2026-09-26 11:10:52'),
(27, 27, 3, 19200, 3000, 12, '2026-02-01 00:00:00', '2027-02-01 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(28, 28, 1, 2000, 3000, 1, '2026-04-11 00:00:00', '2026-05-11 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(29, 29, 1, 2000, 3000, 1, '2026-06-08 00:00:00', '2026-07-08 00:00:00', 'active', 0, NULL, '2026-09-26 11:10:53', '2026-09-26 11:10:53'),
(30, 30, 3, 19200, 3000, 12, '2026-03-07 00:00:00', '2027-03-07 00:00:00', 'refunded', 19200, '2026-09-26 14:10:55', '2026-09-26 11:10:53', '2026-09-26 11:10:55');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@lms.test', NULL, '$2y$12$QGqHyMVdCMsgCRmEg4L6L.uokveNL9xzyj/LNlsHWTm20SkJoGJ7i', NULL, '2026-09-26 11:10:51', '2026-09-26 11:10:51');

-- --------------------------------------------------------

--
-- Table structure for table `watch_sessions`
--

CREATE TABLE `watch_sessions` (
  `id` bigint UNSIGNED NOT NULL,
  `student_id` bigint UNSIGNED NOT NULL,
  `course_id` bigint UNSIGNED NOT NULL,
  `seconds` int UNSIGNED NOT NULL,
  `watched_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `watch_sessions`
--

INSERT INTO `watch_sessions` (`id`, `student_id`, `course_id`, `seconds`, `watched_at`) VALUES
(1, 1, 1, 660, '2026-07-05 14:07:00'),
(2, 1, 1, 1560, '2026-07-13 19:14:00'),
(3, 1, 1, 4560, '2026-07-18 11:15:00'),
(4, 1, 1, 2640, '2026-07-20 17:25:00'),
(5, 1, 1, 1860, '2026-07-23 21:08:00'),
(6, 1, 1, 1920, '2026-07-31 15:27:00'),
(7, 1, 1, 1380, '2026-08-08 10:24:00'),
(8, 1, 1, 1560, '2026-08-12 09:23:00'),
(9, 1, 1, 600, '2026-08-15 15:18:00'),
(10, 1, 1, 1740, '2026-08-19 13:01:00'),
(11, 1, 1, 600, '2026-08-25 14:07:00'),
(12, 1, 1, 3360, '2026-08-29 10:12:00'),
(13, 1, 1, 4140, '2026-09-04 10:23:00'),
(14, 1, 1, 1380, '2026-09-10 17:51:00'),
(15, 1, 1, 2520, '2026-09-17 14:52:00'),
(16, 1, 1, 2400, '2026-09-22 08:00:00'),
(17, 2, 5, 1500, '2026-05-24 17:22:00'),
(18, 2, 5, 4440, '2026-05-31 15:05:00'),
(19, 2, 5, 1800, '2026-06-04 10:51:00'),
(20, 2, 5, 780, '2026-06-09 09:09:00'),
(21, 2, 5, 480, '2026-06-13 13:23:00'),
(22, 2, 5, 2280, '2026-06-16 11:47:00'),
(23, 2, 5, 360, '2026-06-22 13:26:00'),
(24, 2, 5, 2100, '2026-06-30 16:10:00'),
(25, 2, 5, 2160, '2026-07-03 16:52:00'),
(26, 2, 5, 420, '2026-07-09 21:45:00'),
(27, 2, 5, 1980, '2026-07-18 10:51:00'),
(28, 2, 5, 3900, '2026-07-27 11:22:00'),
(29, 2, 5, 4620, '2026-08-01 14:00:00'),
(30, 2, 5, 3060, '2026-08-06 14:26:00'),
(31, 2, 5, 3060, '2026-08-14 20:34:00'),
(32, 2, 5, 4080, '2026-08-17 08:15:00'),
(33, 2, 5, 2040, '2026-08-25 13:32:00'),
(34, 2, 5, 3540, '2026-09-01 17:33:00'),
(35, 2, 5, 600, '2026-09-09 11:49:00'),
(36, 2, 5, 3960, '2026-09-15 15:21:00'),
(37, 2, 5, 3600, '2026-09-17 10:18:00'),
(38, 2, 5, 1560, '2026-09-25 10:28:00'),
(39, 3, 7, 1980, '2026-03-05 10:13:00'),
(40, 3, 7, 3180, '2026-03-14 16:46:00'),
(41, 3, 7, 5160, '2026-03-19 12:03:00'),
(42, 3, 7, 1140, '2026-03-23 15:48:00'),
(43, 3, 7, 4620, '2026-03-29 18:04:00'),
(44, 3, 7, 4200, '2026-04-07 19:22:00'),
(45, 3, 7, 1260, '2026-04-15 09:56:00'),
(46, 3, 7, 4260, '2026-04-24 20:12:00'),
(47, 3, 7, 4260, '2026-04-27 19:13:00'),
(48, 3, 7, 2940, '2026-04-30 13:54:00'),
(49, 3, 7, 600, '2026-05-08 12:40:00'),
(50, 3, 7, 660, '2026-05-12 20:22:00'),
(51, 3, 7, 4980, '2026-05-14 20:55:00'),
(52, 3, 7, 960, '2026-05-21 21:58:00'),
(53, 3, 7, 2280, '2026-05-30 11:37:00'),
(54, 4, 1, 3780, '2026-08-22 22:11:00'),
(55, 4, 7, 1980, '2026-08-26 16:15:00'),
(56, 4, 1, 3300, '2026-08-28 10:47:00'),
(57, 4, 1, 720, '2026-09-01 22:29:00'),
(58, 4, 1, 4560, '2026-09-05 10:34:00'),
(59, 4, 7, 4080, '2026-09-07 17:12:00'),
(60, 4, 1, 2580, '2026-09-12 19:32:00'),
(61, 4, 1, 3000, '2026-09-21 19:44:00'),
(62, 4, 7, 600, '2026-09-24 22:31:00'),
(63, 5, 6, 2820, '2026-08-08 19:43:00'),
(64, 5, 6, 4800, '2026-08-14 16:13:00'),
(65, 5, 6, 5280, '2026-08-20 21:42:00'),
(66, 5, 6, 780, '2026-08-26 17:18:00'),
(67, 5, 6, 3360, '2026-08-31 22:14:00'),
(68, 5, 6, 3120, '2026-09-07 19:19:00'),
(69, 6, 1, 2400, '2026-02-08 14:56:00'),
(70, 6, 1, 3720, '2026-02-10 11:28:00'),
(71, 6, 1, 4500, '2026-02-13 21:53:00'),
(72, 6, 1, 3540, '2026-02-20 19:38:00'),
(73, 6, 1, 5160, '2026-03-01 17:30:00'),
(74, 7, 8, 2880, '2026-06-13 09:12:00'),
(75, 7, 8, 4380, '2026-06-16 18:53:00'),
(76, 7, 8, 3840, '2026-06-18 17:41:00'),
(77, 7, 3, 600, '2026-06-21 22:10:00'),
(78, 7, 3, 1620, '2026-06-25 19:58:00'),
(79, 7, 8, 3240, '2026-06-27 18:20:00'),
(80, 7, 3, 3000, '2026-07-02 18:14:00'),
(81, 7, 3, 5100, '2026-07-10 11:42:00'),
(82, 8, 7, 540, '2026-07-06 15:53:00'),
(83, 8, 7, 1500, '2026-07-14 19:50:00'),
(84, 8, 7, 2880, '2026-07-20 20:32:00'),
(85, 8, 7, 3000, '2026-07-22 20:36:00'),
(86, 8, 7, 3900, '2026-07-25 17:24:00'),
(87, 8, 7, 2220, '2026-08-01 22:17:00'),
(88, 8, 7, 1080, '2026-08-06 22:11:00'),
(89, 8, 7, 4920, '2026-08-15 12:35:00'),
(90, 8, 7, 660, '2026-08-17 19:43:00'),
(91, 8, 7, 3720, '2026-08-22 16:26:00'),
(92, 8, 7, 3840, '2026-08-27 22:11:00'),
(93, 8, 7, 4320, '2026-08-30 12:20:00'),
(94, 8, 7, 2400, '2026-09-05 21:23:00'),
(95, 8, 7, 1500, '2026-09-12 13:50:00'),
(96, 8, 7, 2760, '2026-09-18 15:14:00'),
(97, 8, 7, 900, '2026-09-26 14:28:00'),
(98, 9, 7, 3240, '2026-02-18 10:33:00'),
(99, 9, 2, 300, '2026-02-23 22:23:00'),
(100, 9, 2, 5400, '2026-02-26 12:09:00'),
(101, 9, 2, 900, '2026-03-05 14:56:00'),
(102, 9, 1, 4740, '2026-03-13 14:24:00'),
(103, 9, 2, 720, '2026-03-17 09:11:00'),
(104, 9, 1, 4020, '2026-03-20 11:48:00'),
(105, 9, 1, 5040, '2026-03-24 17:09:00'),
(106, 9, 7, 1200, '2026-03-28 17:00:00'),
(107, 9, 2, 2640, '2026-04-06 12:24:00'),
(108, 9, 2, 1380, '2026-04-10 15:18:00'),
(109, 9, 2, 3960, '2026-04-15 20:44:00'),
(110, 9, 7, 1500, '2026-04-17 17:20:00'),
(111, 9, 7, 1980, '2026-04-19 14:13:00'),
(112, 9, 1, 4740, '2026-04-21 22:53:00'),
(113, 9, 2, 4860, '2026-04-29 08:20:00'),
(114, 9, 7, 2820, '2026-05-08 18:40:00'),
(115, 9, 7, 2220, '2026-05-11 21:02:00'),
(116, 10, 6, 1080, '2026-05-08 20:48:00'),
(117, 10, 6, 1680, '2026-05-16 15:48:00'),
(118, 10, 7, 4200, '2026-05-18 15:36:00'),
(119, 10, 7, 420, '2026-05-23 17:48:00'),
(120, 10, 6, 3660, '2026-05-31 15:18:00'),
(121, 10, 1, 1440, '2026-06-03 20:30:00'),
(122, 10, 1, 1620, '2026-06-11 22:06:00'),
(123, 10, 7, 3120, '2026-06-13 18:53:00'),
(124, 10, 7, 3900, '2026-06-18 18:16:00'),
(125, 10, 7, 3120, '2026-06-21 08:43:00'),
(126, 10, 7, 2100, '2026-06-30 22:39:00'),
(127, 10, 1, 5160, '2026-07-06 13:23:00'),
(128, 10, 7, 2340, '2026-07-13 14:24:00'),
(129, 10, 7, 2940, '2026-07-20 18:53:00'),
(130, 10, 6, 720, '2026-07-28 22:46:00'),
(131, 10, 6, 1620, '2026-08-06 15:57:00'),
(132, 11, 1, 1500, '2026-04-22 22:04:00'),
(133, 11, 1, 5340, '2026-04-25 18:19:00'),
(134, 11, 1, 4020, '2026-05-01 21:23:00'),
(135, 11, 3, 1500, '2026-05-09 21:39:00'),
(136, 11, 1, 3420, '2026-05-11 21:12:00'),
(137, 11, 1, 480, '2026-05-19 13:56:00'),
(138, 11, 3, 5340, '2026-05-21 19:41:00'),
(139, 11, 1, 3600, '2026-05-27 10:01:00'),
(140, 11, 1, 3660, '2026-05-29 16:06:00'),
(141, 11, 3, 1680, '2026-06-01 08:20:00'),
(142, 11, 3, 1260, '2026-06-10 22:51:00'),
(143, 11, 3, 4320, '2026-06-18 08:39:00'),
(144, 11, 3, 4680, '2026-06-21 16:12:00'),
(145, 11, 3, 1620, '2026-06-25 11:44:00'),
(146, 11, 3, 1740, '2026-06-28 15:07:00'),
(147, 11, 1, 3900, '2026-07-06 11:59:00'),
(148, 11, 1, 2880, '2026-07-11 20:53:00'),
(149, 11, 3, 360, '2026-07-17 14:20:00'),
(150, 12, 2, 4380, '2026-03-12 20:18:00'),
(151, 12, 2, 300, '2026-03-21 08:05:00'),
(152, 12, 2, 4080, '2026-03-27 14:02:00'),
(153, 12, 2, 1680, '2026-04-02 21:39:00'),
(154, 12, 2, 1080, '2026-04-10 11:18:00'),
(155, 13, 5, 5280, '2026-01-04 21:35:00'),
(156, 13, 5, 1560, '2026-01-06 14:48:00'),
(157, 13, 5, 4560, '2026-01-14 10:06:00'),
(158, 13, 5, 1920, '2026-01-16 13:20:00'),
(159, 13, 5, 3420, '2026-01-22 16:25:00'),
(160, 13, 5, 4560, '2026-01-31 19:21:00'),
(161, 14, 2, 1680, '2026-02-24 19:39:00'),
(162, 14, 2, 4740, '2026-03-02 13:06:00'),
(163, 14, 2, 2520, '2026-03-11 19:18:00'),
(164, 14, 8, 2700, '2026-03-16 13:50:00'),
(165, 14, 8, 2640, '2026-03-23 10:19:00'),
(166, 15, 2, 660, '2026-01-29 21:07:00'),
(167, 15, 4, 2940, '2026-02-05 10:14:00'),
(168, 15, 4, 3960, '2026-02-11 17:01:00'),
(169, 15, 4, 3120, '2026-02-13 15:43:00'),
(170, 15, 4, 2700, '2026-02-15 12:23:00'),
(171, 15, 5, 3720, '2026-02-22 10:06:00'),
(172, 15, 2, 1500, '2026-03-03 10:33:00'),
(173, 15, 2, 1740, '2026-03-09 15:43:00'),
(174, 15, 5, 5400, '2026-03-18 20:44:00'),
(175, 15, 2, 5220, '2026-03-27 12:55:00'),
(176, 15, 2, 4200, '2026-04-05 12:31:00'),
(177, 15, 2, 2880, '2026-04-14 16:07:00'),
(178, 15, 5, 1140, '2026-04-23 09:30:00'),
(179, 15, 4, 3420, '2026-04-26 08:55:00'),
(180, 15, 4, 2100, '2026-04-30 16:20:00'),
(181, 15, 5, 3300, '2026-05-06 14:15:00'),
(182, 15, 5, 2580, '2026-05-12 16:25:00'),
(183, 15, 5, 3120, '2026-05-16 20:58:00'),
(184, 15, 2, 4320, '2026-05-20 15:45:00'),
(185, 15, 5, 4920, '2026-05-28 15:57:00'),
(186, 15, 2, 3120, '2026-06-02 19:32:00'),
(187, 15, 5, 1380, '2026-06-06 13:47:00'),
(188, 15, 2, 3720, '2026-06-13 21:38:00'),
(189, 15, 2, 4140, '2026-06-19 08:46:00'),
(190, 15, 4, 4560, '2026-06-27 15:28:00'),
(191, 15, 2, 5340, '2026-07-02 18:45:00'),
(192, 15, 5, 5160, '2026-07-06 16:40:00'),
(193, 15, 4, 3960, '2026-07-11 19:18:00'),
(194, 15, 2, 2520, '2026-07-14 21:30:00'),
(195, 15, 5, 960, '2026-07-22 08:09:00'),
(196, 15, 2, 2400, '2026-07-28 15:13:00'),
(197, 15, 4, 5340, '2026-08-06 08:06:00'),
(198, 15, 2, 3600, '2026-08-09 21:23:00'),
(199, 15, 4, 5040, '2026-08-16 15:23:00'),
(200, 15, 4, 2700, '2026-08-19 12:24:00'),
(201, 15, 5, 1380, '2026-08-22 21:52:00'),
(202, 15, 4, 4020, '2026-08-25 11:14:00'),
(203, 15, 5, 2160, '2026-09-01 12:13:00'),
(204, 15, 5, 1560, '2026-09-06 15:31:00'),
(205, 15, 5, 2820, '2026-09-11 11:00:00'),
(206, 15, 4, 4020, '2026-09-17 22:03:00'),
(207, 15, 2, 5400, '2026-09-25 19:12:00'),
(208, 17, 8, 1500, '2025-12-18 18:57:00'),
(209, 17, 1, 780, '2025-12-25 20:10:00'),
(210, 17, 6, 2820, '2026-01-03 09:42:00'),
(211, 17, 8, 4200, '2026-01-08 09:05:00'),
(212, 17, 6, 2280, '2026-01-11 13:23:00'),
(213, 17, 6, 2820, '2026-01-16 10:37:00'),
(214, 17, 8, 4200, '2026-01-23 22:40:00'),
(215, 17, 1, 3300, '2026-01-30 13:57:00'),
(216, 17, 8, 4440, '2026-02-02 22:44:00'),
(217, 17, 8, 5040, '2026-02-06 20:57:00'),
(218, 17, 8, 2040, '2026-02-13 14:01:00'),
(219, 17, 8, 3600, '2026-02-18 22:21:00'),
(220, 17, 8, 2940, '2026-02-23 12:31:00'),
(221, 17, 8, 420, '2026-02-25 21:07:00'),
(222, 17, 8, 5220, '2026-03-01 17:30:00'),
(223, 17, 6, 2460, '2026-03-08 21:24:00'),
(224, 17, 6, 4560, '2026-03-12 20:18:00'),
(225, 17, 1, 5220, '2026-03-14 21:05:00'),
(226, 17, 1, 3360, '2026-03-21 21:21:00'),
(227, 17, 8, 1260, '2026-03-23 19:54:00'),
(228, 17, 8, 1980, '2026-03-29 22:56:00'),
(229, 17, 8, 3480, '2026-04-02 14:05:00'),
(230, 17, 6, 2040, '2026-04-06 08:27:00'),
(231, 17, 8, 5220, '2026-04-08 09:22:00'),
(232, 17, 8, 360, '2026-04-11 13:35:00'),
(233, 17, 6, 2520, '2026-04-18 10:42:00'),
(234, 17, 6, 2880, '2026-04-26 09:13:00'),
(235, 17, 6, 4860, '2026-05-05 09:45:00'),
(236, 17, 6, 4080, '2026-05-13 13:35:00'),
(237, 17, 8, 540, '2026-05-17 22:16:00'),
(238, 17, 8, 1680, '2026-05-22 15:47:00'),
(239, 17, 1, 5340, '2026-05-27 12:53:00'),
(240, 17, 6, 2280, '2026-05-30 21:09:00'),
(241, 17, 1, 4140, '2026-06-01 16:49:00'),
(242, 17, 8, 2400, '2026-06-06 14:57:00'),
(243, 17, 6, 5100, '2026-06-10 11:12:00'),
(244, 17, 6, 5400, '2026-06-15 17:43:00'),
(245, 17, 6, 420, '2026-06-20 12:50:00'),
(246, 17, 8, 3180, '2026-06-26 16:16:00'),
(247, 17, 8, 4800, '2026-07-05 08:08:00'),
(248, 17, 8, 2280, '2026-07-13 09:21:00'),
(249, 17, 6, 5160, '2026-07-18 13:45:00'),
(250, 17, 1, 4500, '2026-07-25 19:18:00'),
(251, 17, 1, 3660, '2026-07-30 11:41:00'),
(252, 17, 1, 3000, '2026-08-06 17:01:00'),
(253, 17, 1, 780, '2026-08-11 16:24:00'),
(254, 17, 8, 2100, '2026-08-15 11:38:00'),
(255, 17, 8, 780, '2026-08-21 13:26:00'),
(256, 17, 1, 4620, '2026-08-23 13:31:00'),
(257, 17, 8, 2040, '2026-08-28 17:30:00'),
(258, 17, 6, 4980, '2026-09-05 21:24:00'),
(259, 17, 8, 3360, '2026-09-09 10:35:00'),
(260, 17, 8, 1800, '2026-09-15 09:15:00'),
(261, 17, 6, 1920, '2026-09-18 16:24:00'),
(262, 17, 1, 2580, '2026-09-26 19:30:00'),
(263, 18, 4, 4500, '2026-03-19 12:26:00'),
(264, 18, 4, 2400, '2026-03-21 22:16:00'),
(265, 18, 4, 3720, '2026-03-30 08:55:00'),
(266, 18, 4, 1620, '2026-04-01 15:59:00'),
(267, 18, 4, 4620, '2026-04-09 12:37:00'),
(268, 18, 4, 2880, '2026-04-13 15:55:00'),
(269, 18, 4, 4020, '2026-04-19 15:58:00'),
(270, 18, 4, 1200, '2026-04-23 18:19:00'),
(271, 18, 4, 600, '2026-04-29 19:43:00'),
(272, 18, 4, 1800, '2026-05-04 08:05:00'),
(273, 18, 4, 2280, '2026-05-07 17:04:00'),
(274, 18, 4, 2100, '2026-05-14 13:42:00'),
(275, 18, 4, 3840, '2026-05-23 08:57:00'),
(276, 18, 4, 1620, '2026-05-31 13:37:00'),
(277, 18, 4, 420, '2026-06-06 10:14:00'),
(278, 18, 4, 4080, '2026-06-09 15:01:00'),
(279, 18, 4, 2280, '2026-06-13 15:15:00'),
(280, 18, 4, 360, '2026-06-15 13:42:00'),
(281, 18, 4, 540, '2026-06-20 22:13:00'),
(282, 18, 4, 2340, '2026-06-29 16:41:00'),
(283, 18, 4, 660, '2026-07-02 16:59:00'),
(284, 18, 4, 3660, '2026-07-05 20:35:00'),
(285, 18, 4, 2820, '2026-07-13 16:37:00'),
(286, 18, 4, 4140, '2026-07-18 12:29:00'),
(287, 18, 4, 660, '2026-07-20 22:32:00'),
(288, 18, 4, 4560, '2026-07-27 13:01:00'),
(289, 18, 4, 720, '2026-08-05 22:42:00'),
(290, 18, 4, 1200, '2026-08-12 19:57:00'),
(291, 18, 4, 480, '2026-08-17 19:58:00'),
(292, 18, 4, 3300, '2026-08-24 19:51:00'),
(293, 18, 4, 480, '2026-08-26 13:34:00'),
(294, 18, 4, 5220, '2026-09-04 13:19:00'),
(295, 18, 4, 1800, '2026-09-09 19:11:00'),
(296, 18, 4, 4080, '2026-09-18 12:57:00'),
(297, 18, 4, 1320, '2026-09-24 08:21:00'),
(298, 18, 4, 2160, '2026-09-26 12:23:00'),
(299, 19, 2, 2880, '2026-07-01 08:50:00'),
(300, 19, 2, 1440, '2026-07-08 10:02:00'),
(301, 19, 6, 5280, '2026-07-13 20:48:00'),
(302, 19, 2, 3540, '2026-07-22 13:08:00'),
(303, 19, 6, 5160, '2026-07-26 14:26:00'),
(304, 19, 2, 3900, '2026-08-01 21:08:00'),
(305, 19, 2, 720, '2026-08-07 13:11:00'),
(306, 19, 6, 1440, '2026-08-14 13:51:00'),
(307, 19, 2, 1800, '2026-08-22 19:41:00'),
(308, 19, 2, 2100, '2026-08-24 08:44:00'),
(309, 19, 6, 540, '2026-08-30 15:06:00'),
(310, 19, 6, 1620, '2026-09-01 14:21:00'),
(311, 19, 6, 3960, '2026-09-05 22:36:00'),
(312, 19, 2, 360, '2026-09-12 13:49:00'),
(313, 19, 6, 3540, '2026-09-18 13:58:00'),
(314, 19, 6, 2820, '2026-09-22 11:04:00'),
(315, 19, 6, 5100, '2026-09-25 14:34:00'),
(316, 20, 1, 540, '2026-02-13 20:46:00'),
(317, 20, 1, 3660, '2026-02-22 17:21:00'),
(318, 20, 1, 5220, '2026-02-25 14:28:00'),
(319, 20, 1, 1380, '2026-03-02 15:29:00'),
(320, 20, 1, 1500, '2026-03-04 20:21:00'),
(321, 20, 1, 3540, '2026-03-09 14:07:00'),
(322, 20, 1, 4500, '2026-03-14 10:33:00'),
(323, 20, 1, 1140, '2026-03-20 17:52:00'),
(324, 20, 1, 1440, '2026-03-25 21:31:00'),
(325, 20, 1, 3480, '2026-03-30 20:59:00'),
(326, 20, 1, 1620, '2026-04-01 17:14:00'),
(327, 20, 1, 4320, '2026-04-07 14:03:00'),
(328, 20, 1, 660, '2026-04-12 16:43:00'),
(329, 20, 1, 5400, '2026-04-15 20:18:00'),
(330, 20, 1, 5280, '2026-04-19 12:16:00'),
(331, 20, 1, 1440, '2026-04-22 09:24:00'),
(332, 20, 1, 4920, '2026-04-27 13:34:00'),
(333, 20, 1, 3900, '2026-05-06 22:12:00'),
(334, 20, 1, 4620, '2026-05-11 17:15:00'),
(335, 22, 5, 4500, '2026-03-25 12:47:00'),
(336, 22, 8, 5340, '2026-03-31 14:15:00'),
(337, 22, 5, 4680, '2026-04-03 08:31:00'),
(338, 22, 8, 840, '2026-04-09 19:56:00'),
(339, 22, 8, 2280, '2026-04-18 18:03:00'),
(340, 22, 5, 4440, '2026-04-25 13:17:00'),
(341, 22, 5, 2460, '2026-04-30 21:15:00'),
(342, 22, 8, 4080, '2026-05-02 16:24:00'),
(343, 22, 5, 1620, '2026-05-04 10:17:00'),
(344, 22, 8, 5280, '2026-05-11 14:37:00'),
(345, 22, 8, 2220, '2026-05-17 16:11:00'),
(346, 22, 5, 2100, '2026-05-23 19:46:00'),
(347, 22, 8, 2160, '2026-05-25 15:56:00'),
(348, 22, 5, 3240, '2026-05-29 10:55:00'),
(349, 22, 8, 4260, '2026-06-05 22:41:00'),
(350, 22, 5, 5040, '2026-06-13 16:16:00'),
(351, 22, 8, 480, '2026-06-21 08:12:00'),
(352, 22, 5, 1500, '2026-06-26 14:40:00'),
(353, 22, 5, 2280, '2026-07-04 14:46:00'),
(354, 22, 5, 1320, '2026-07-07 21:13:00'),
(355, 22, 5, 2580, '2026-07-11 18:50:00'),
(356, 22, 5, 600, '2026-07-20 13:44:00'),
(357, 22, 8, 3000, '2026-07-23 15:46:00'),
(358, 22, 8, 2760, '2026-07-26 15:16:00'),
(359, 22, 5, 4260, '2026-08-04 21:55:00'),
(360, 22, 8, 2880, '2026-08-10 11:56:00'),
(361, 22, 8, 3540, '2026-08-19 08:21:00'),
(362, 22, 8, 2940, '2026-08-23 11:37:00'),
(363, 22, 8, 2460, '2026-08-25 16:38:00'),
(364, 22, 8, 2040, '2026-08-27 10:04:00'),
(365, 22, 8, 3960, '2026-09-01 12:43:00'),
(366, 22, 5, 2580, '2026-09-08 14:35:00'),
(367, 22, 8, 300, '2026-09-10 09:47:00'),
(368, 22, 5, 4020, '2026-09-12 16:05:00'),
(369, 22, 8, 5040, '2026-09-14 19:06:00'),
(370, 22, 5, 900, '2026-09-20 17:45:00'),
(371, 22, 5, 3660, '2026-09-25 17:04:00'),
(372, 23, 7, 840, '2026-03-09 15:38:00'),
(373, 23, 7, 5400, '2026-03-17 20:08:00'),
(374, 23, 7, 1080, '2026-03-22 13:08:00'),
(375, 23, 7, 3720, '2026-03-30 20:23:00'),
(376, 23, 7, 5340, '2026-04-04 08:10:00'),
(377, 23, 7, 4920, '2026-04-12 15:32:00'),
(378, 23, 7, 4980, '2026-04-14 19:43:00'),
(379, 23, 7, 3960, '2026-04-23 19:39:00'),
(380, 23, 7, 4800, '2026-04-28 21:46:00'),
(381, 23, 7, 3060, '2026-05-03 22:10:00'),
(382, 23, 7, 2580, '2026-05-12 18:42:00'),
(383, 23, 7, 600, '2026-05-21 14:07:00'),
(384, 23, 7, 5100, '2026-05-25 21:42:00'),
(385, 23, 7, 480, '2026-05-31 09:07:00'),
(386, 23, 7, 5340, '2026-06-05 14:20:00'),
(387, 24, 7, 960, '2026-04-06 12:57:00'),
(388, 24, 2, 3120, '2026-04-12 08:40:00'),
(389, 24, 7, 2700, '2026-04-18 15:52:00'),
(390, 24, 7, 5100, '2026-04-24 12:14:00'),
(391, 24, 5, 4080, '2026-04-27 13:03:00'),
(392, 24, 7, 4500, '2026-05-02 21:35:00'),
(393, 24, 2, 1440, '2026-05-06 08:46:00'),
(394, 24, 2, 1200, '2026-05-08 17:56:00'),
(395, 24, 5, 900, '2026-05-12 14:41:00'),
(396, 24, 7, 4740, '2026-05-19 08:37:00'),
(397, 24, 2, 4320, '2026-05-21 15:18:00'),
(398, 24, 2, 4920, '2026-05-30 13:09:00'),
(399, 24, 7, 4500, '2026-06-06 12:04:00'),
(400, 24, 5, 1680, '2026-06-15 11:45:00'),
(401, 24, 7, 2160, '2026-06-24 14:40:00'),
(402, 24, 5, 4020, '2026-07-02 20:26:00'),
(403, 24, 5, 3600, '2026-07-04 10:21:00'),
(404, 25, 1, 2880, '2026-03-05 22:37:00'),
(405, 25, 1, 3180, '2026-03-09 13:58:00'),
(406, 25, 7, 4860, '2026-03-15 16:55:00'),
(407, 25, 7, 3060, '2026-03-19 12:57:00'),
(408, 25, 7, 4320, '2026-03-24 13:47:00'),
(409, 25, 7, 1140, '2026-03-31 11:34:00'),
(410, 25, 1, 4680, '2026-04-02 12:39:00'),
(411, 26, 7, 5280, '2026-01-22 21:17:00'),
(412, 26, 3, 1740, '2026-01-27 18:50:00'),
(413, 26, 3, 1020, '2026-02-04 15:00:00'),
(414, 26, 7, 3000, '2026-02-13 19:44:00'),
(415, 26, 7, 4560, '2026-02-15 21:49:00'),
(416, 26, 7, 1140, '2026-02-24 08:11:00'),
(417, 26, 7, 1500, '2026-03-05 16:27:00'),
(418, 26, 3, 2940, '2026-03-09 18:42:00'),
(419, 26, 3, 2100, '2026-03-11 20:29:00'),
(420, 26, 3, 2820, '2026-03-15 16:52:00'),
(421, 26, 3, 3600, '2026-03-18 19:57:00'),
(422, 26, 7, 4800, '2026-03-24 11:43:00'),
(423, 26, 3, 4920, '2026-03-31 09:11:00'),
(424, 26, 3, 2460, '2026-04-08 11:49:00'),
(425, 26, 3, 420, '2026-04-12 20:31:00'),
(426, 26, 3, 960, '2026-04-14 18:52:00'),
(427, 26, 7, 1680, '2026-04-17 13:11:00'),
(428, 26, 7, 420, '2026-04-23 17:11:00'),
(429, 26, 7, 3360, '2026-04-30 12:12:00'),
(430, 26, 3, 1440, '2026-05-04 16:50:00'),
(431, 26, 7, 4740, '2026-05-13 17:19:00'),
(432, 26, 7, 300, '2026-05-20 17:20:00'),
(433, 26, 7, 1560, '2026-05-27 13:03:00'),
(434, 26, 7, 2760, '2026-05-31 17:04:00'),
(435, 26, 7, 3180, '2026-06-08 14:56:00'),
(436, 26, 3, 2880, '2026-06-10 15:24:00'),
(437, 26, 7, 1980, '2026-06-12 15:38:00'),
(438, 26, 7, 2400, '2026-06-16 11:54:00'),
(439, 26, 7, 1440, '2026-06-25 22:38:00'),
(440, 26, 7, 1020, '2026-06-30 16:04:00'),
(441, 26, 3, 3720, '2026-07-04 22:58:00'),
(442, 26, 3, 660, '2026-07-10 17:27:00'),
(443, 26, 3, 4500, '2026-07-18 22:47:00'),
(444, 26, 3, 2760, '2026-07-22 15:28:00'),
(445, 26, 3, 1620, '2026-07-28 13:30:00'),
(446, 26, 7, 3060, '2026-08-05 16:25:00'),
(447, 26, 3, 3840, '2026-08-08 09:17:00'),
(448, 26, 3, 4440, '2026-08-13 14:55:00'),
(449, 26, 7, 960, '2026-08-18 13:44:00'),
(450, 26, 7, 4500, '2026-08-27 15:22:00'),
(451, 26, 7, 900, '2026-09-05 22:57:00'),
(452, 26, 7, 3420, '2026-09-08 20:37:00'),
(453, 26, 3, 540, '2026-09-17 11:17:00'),
(454, 26, 3, 5280, '2026-09-26 10:42:00'),
(455, 27, 5, 4140, '2026-02-01 20:23:00'),
(456, 27, 5, 2700, '2026-02-09 15:53:00'),
(457, 27, 2, 2400, '2026-02-13 22:33:00'),
(458, 27, 2, 2460, '2026-02-21 09:06:00'),
(459, 27, 5, 1020, '2026-02-25 19:59:00'),
(460, 27, 5, 4560, '2026-03-02 22:35:00'),
(461, 27, 2, 660, '2026-03-05 15:15:00'),
(462, 27, 2, 2700, '2026-03-14 14:38:00'),
(463, 27, 5, 4860, '2026-03-16 10:12:00'),
(464, 27, 5, 3420, '2026-03-19 21:48:00'),
(465, 27, 5, 540, '2026-03-24 10:02:00'),
(466, 27, 2, 780, '2026-03-29 18:52:00'),
(467, 27, 5, 1800, '2026-04-01 11:47:00'),
(468, 27, 2, 540, '2026-04-03 11:48:00'),
(469, 27, 5, 3660, '2026-04-12 18:49:00'),
(470, 27, 5, 1380, '2026-04-19 11:05:00'),
(471, 27, 2, 4200, '2026-04-21 18:08:00'),
(472, 27, 5, 3540, '2026-04-30 20:36:00'),
(473, 27, 2, 720, '2026-05-05 19:04:00'),
(474, 27, 5, 540, '2026-05-10 22:25:00'),
(475, 27, 2, 2520, '2026-05-19 18:08:00'),
(476, 27, 2, 4620, '2026-05-26 16:10:00'),
(477, 27, 5, 420, '2026-06-01 17:51:00'),
(478, 27, 2, 3840, '2026-06-10 20:13:00'),
(479, 27, 5, 720, '2026-06-15 14:13:00'),
(480, 27, 2, 5400, '2026-06-24 16:39:00'),
(481, 27, 5, 3840, '2026-06-26 10:27:00'),
(482, 27, 2, 2340, '2026-06-30 09:37:00'),
(483, 27, 2, 3480, '2026-07-02 11:40:00'),
(484, 27, 2, 2940, '2026-07-05 19:02:00'),
(485, 27, 5, 4440, '2026-07-14 10:49:00'),
(486, 27, 2, 4200, '2026-07-21 22:27:00'),
(487, 27, 5, 780, '2026-07-24 08:35:00'),
(488, 27, 5, 1140, '2026-07-31 08:50:00'),
(489, 27, 2, 4620, '2026-08-05 18:06:00'),
(490, 27, 5, 1980, '2026-08-11 09:02:00'),
(491, 27, 5, 3240, '2026-08-15 08:28:00'),
(492, 27, 2, 1440, '2026-08-20 09:23:00'),
(493, 27, 5, 4740, '2026-08-22 13:24:00'),
(494, 27, 5, 2280, '2026-08-25 08:18:00'),
(495, 27, 5, 1440, '2026-09-03 20:46:00'),
(496, 27, 2, 2700, '2026-09-05 19:10:00'),
(497, 27, 2, 4080, '2026-09-08 12:09:00'),
(498, 27, 5, 2400, '2026-09-15 21:59:00'),
(499, 27, 2, 1740, '2026-09-17 21:45:00'),
(500, 27, 5, 4980, '2026-09-24 19:23:00'),
(501, 28, 6, 3780, '2026-04-11 18:54:00'),
(502, 28, 8, 360, '2026-04-18 20:21:00'),
(503, 28, 8, 1080, '2026-04-25 10:54:00'),
(504, 28, 6, 2100, '2026-04-30 20:10:00'),
(505, 28, 6, 2100, '2026-05-02 18:36:00'),
(506, 28, 8, 1920, '2026-05-08 10:28:00'),
(507, 29, 1, 5220, '2026-06-08 14:48:00'),
(508, 29, 4, 2280, '2026-06-12 15:20:00'),
(509, 29, 4, 3780, '2026-06-16 22:27:00'),
(510, 29, 1, 3180, '2026-06-24 21:57:00'),
(511, 29, 4, 1860, '2026-06-29 11:40:00'),
(512, 29, 4, 4440, '2026-07-04 22:57:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courses_instructor_id_foreign` (`instructor_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `instructors`
--
ALTER TABLE `instructors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `instructors_email_unique` (`email`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ledger_entries_idempotency_key_unique` (`idempotency_key`),
  ADD KEY `ledger_entries_subscription_id_foreign` (`subscription_id`),
  ADD KEY `ledger_entries_revenue_allocation_id_foreign` (`revenue_allocation_id`),
  ADD KEY `ledger_entries_refund_id_foreign` (`refund_id`),
  ADD KEY `ledger_entries_payout_id_foreign` (`payout_id`),
  ADD KEY `ledger_entries_instructor_id_type_index` (`instructor_id`,`type`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mock_provider_transfers`
--
ALTER TABLE `mock_provider_transfers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mock_provider_transfers_idempotency_key_unique` (`idempotency_key`),
  ADD UNIQUE KEY `mock_provider_transfers_reference_unique` (`reference`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payouts`
--
ALTER TABLE `payouts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payouts_idempotency_key_unique` (`idempotency_key`),
  ADD KEY `payouts_instructor_id_foreign` (`instructor_id`),
  ADD KEY `payouts_status_index` (`status`),
  ADD KEY `payouts_provider_reference_index` (`provider_reference`);

--
-- Indexes for table `plans`
--
ALTER TABLE `plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `provider_webhook_events`
--
ALTER TABLE `provider_webhook_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `provider_webhook_events_event_id_unique` (`event_id`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `refunds_idempotency_key_unique` (`idempotency_key`),
  ADD KEY `refunds_subscription_id_foreign` (`subscription_id`);

--
-- Indexes for table `revenue_allocations`
--
ALTER TABLE `revenue_allocations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `revenue_allocations_subscription_id_period_index_unique` (`subscription_id`,`period_index`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `students_email_unique` (`email`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscriptions_student_id_foreign` (`student_id`),
  ADD KEY `subscriptions_plan_id_foreign` (`plan_id`),
  ADD KEY `subscriptions_status_index` (`status`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `watch_sessions`
--
ALTER TABLE `watch_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `watch_sessions_course_id_foreign` (`course_id`),
  ADD KEY `watch_sessions_student_id_watched_at_index` (`student_id`,`watched_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=287;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `mock_provider_transfers`
--
ALTER TABLE `mock_provider_transfers`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payouts`
--
ALTER TABLE `payouts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `plans`
--
ALTER TABLE `plans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `provider_webhook_events`
--
ALTER TABLE `provider_webhook_events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `refunds`
--
ALTER TABLE `refunds`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `revenue_allocations`
--
ALTER TABLE `revenue_allocations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `watch_sessions`
--
ALTER TABLE `watch_sessions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=513;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_instructor_id_foreign` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD CONSTRAINT `ledger_entries_instructor_id_foreign` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `ledger_entries_payout_id_foreign` FOREIGN KEY (`payout_id`) REFERENCES `payouts` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `ledger_entries_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `refunds` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `ledger_entries_revenue_allocation_id_foreign` FOREIGN KEY (`revenue_allocation_id`) REFERENCES `revenue_allocations` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `ledger_entries_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `payouts`
--
ALTER TABLE `payouts`
  ADD CONSTRAINT `payouts_instructor_id_foreign` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `refunds`
--
ALTER TABLE `refunds`
  ADD CONSTRAINT `refunds_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `revenue_allocations`
--
ALTER TABLE `revenue_allocations`
  ADD CONSTRAINT `revenue_allocations_subscription_id_foreign` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD CONSTRAINT `subscriptions_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `subscriptions_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `watch_sessions`
--
ALTER TABLE `watch_sessions`
  ADD CONSTRAINT `watch_sessions_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `watch_sessions_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
