-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for osx10.10 (x86_64)
--
-- Host: localhost    Database: core_app
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointments` (
  `appointment_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `case_sheet_id` bigint(20) unsigned NOT NULL,
  `doctor_user_id` int(10) unsigned NOT NULL,
  `scheduled_date` date NOT NULL,
  `scheduled_time` time DEFAULT NULL COMMENT 'NULL = time not specified',
  `visit_mode` enum('IN_PERSON','REMOTE','CAMP') NOT NULL DEFAULT 'IN_PERSON',
  `event_id` bigint(20) unsigned DEFAULT NULL COMMENT 'FK to events for CAMP visits',
  `status` enum('SCHEDULED','CONFIRMED','IN_PROGRESS','COMPLETED','CANCELLED','NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
  `notes` text DEFAULT NULL,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`appointment_id`),
  KEY `idx_appt_date_doctor` (`scheduled_date`,`doctor_user_id`),
  KEY `idx_appt_case_sheet` (`case_sheet_id`),
  KEY `idx_appt_status_date` (`status`,`scheduled_date`),
  KEY `fk_appt_doctor` (`doctor_user_id`),
  KEY `fk_appt_event` (`event_id`),
  KEY `fk_appt_created_by` (`created_by_user_id`),
  CONSTRAINT `fk_appt_case_sheet` FOREIGN KEY (`case_sheet_id`) REFERENCES `case_sheets` (`case_sheet_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_doctor` FOREIGN KEY (`doctor_user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,19,12,'2026-03-05','20:30:00','IN_PERSON',NULL,'IN_PROGRESS','Test case- New Patient01 appointment.',13,'2026-03-04 17:28:21','2026-03-04 18:15:15'),(2,19,12,'2026-03-25',NULL,'IN_PERSON',NULL,'SCHEDULED',NULL,13,'2026-03-25 19:21:24','2026-03-25 19:21:24'),(3,21,12,'2026-03-26',NULL,'IN_PERSON',NULL,'SCHEDULED',NULL,13,'2026-03-26 20:05:03','2026-03-26 20:05:03'),(9,11,4,'2026-03-15','10:00:00','IN_PERSON',NULL,'COMPLETED','BP review after starting Telmisartan. BP 138/86 — improving.',12,'2026-03-01 10:00:00','2026-04-08 23:44:35'),(10,13,17,'2026-04-15','11:00:00','IN_PERSON',NULL,'SCHEDULED','TSH + Free T4 recheck after dose increase to Levothyroxine 75mcg.',12,'2026-03-01 10:35:00','2026-04-08 23:44:35'),(11,15,17,'2026-04-02','10:00:00','IN_PERSON',NULL,'COMPLETED','32-week growth scan completed. Normal fetal biometry. No complications.',13,'2026-03-05 10:00:00','2026-04-08 23:44:35'),(12,16,5,'2026-03-17','09:30:00','IN_PERSON',NULL,'COMPLETED','Reviewed ECG — normal sinus rhythm. Treadmill test scheduled at Deenanath Hospital.',12,'2026-03-10 10:30:00','2026-04-08 23:44:35'),(13,18,17,'2026-04-10','09:00:00','IN_PERSON',NULL,'SCHEDULED','Post-referral follow-up. Review KEM Hospital discharge summary. Wound assessment.',14,'2026-03-20 10:00:00','2026-04-08 23:44:35'),(14,20,5,'2026-03-27','10:00:00','IN_PERSON',NULL,'SCHEDULED','BP review after medication adjustment. Repeat urine albumin.',13,'2026-03-20 09:30:00','2026-04-08 23:44:35'),(15,21,4,'2026-03-27','11:00:00','IN_PERSON',NULL,'SCHEDULED','Review mammogram and ultrasound results. Discuss FNAC plan.',12,'2026-03-20 10:30:00','2026-04-08 23:44:35'),(16,22,17,'2026-04-08','10:00:00','IN_PERSON',NULL,'SCHEDULED','Asthma control review. Check preventer inhaler technique. Peak flow measurement.',13,'2026-03-25 10:35:00','2026-04-08 23:44:35'),(17,11,4,'2026-04-15','10:00:00','IN_PERSON',NULL,'SCHEDULED','Second BP follow-up. Assess telmisartan dose adequacy. Target <130/80.',12,'2026-03-16 09:00:00','2026-04-08 23:44:35'),(18,15,17,'2026-04-30','10:00:00','IN_PERSON',NULL,'SCHEDULED','36-week antenatal. Birth plan discussion. Presentation check.',13,'2026-04-02 10:30:00','2026-04-08 23:44:35');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `asset_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `asset_type` enum('VIDEO','PDF','IMAGE','DOCUMENT','AUDIO','FORM','OTHER') NOT NULL,
  `category` varchar(80) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_size_bytes` bigint(20) unsigned DEFAULT NULL,
  `storage_type` enum('URL','LOCAL','S3','OTHER') NOT NULL DEFAULT 'URL',
  `resource_url` varchar(1024) DEFAULT NULL,
  `local_file_path` varchar(500) DEFAULT NULL COMMENT 'Relative path under uploads/assets/ for LOCAL storage type (e.g. 2026/04/uuid.pdf)',
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `uploaded_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`asset_id`),
  KEY `idx_assets_type` (`asset_type`),
  KEY `idx_assets_public` (`is_public`),
  KEY `idx_assets_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'How to Measure Blood Pressure',NULL,'VIDEO','hypertension',NULL,NULL,'URL','https://example.org/videos/bp_measurement.mp4',NULL,1,1,NULL,'2026-02-04 20:12:21','2026-02-04 20:12:21',NULL),(2,'Nurse Triage Checklist',NULL,'PDF','triage',NULL,NULL,'URL','/internal/training/triage_checklist.pdf',NULL,0,1,NULL,'2026-02-04 20:12:29','2026-02-04 20:12:29',NULL),(3,'Understanding Diabetes','A patient-friendly guide to managing Type 2 Diabetes, diet, and exercise.','PDF','diabetes','diabetes_guide.pdf',2048000,'LOCAL','/assets/documents/diabetes_guide.pdf',NULL,1,1,4,'2026-02-10 10:00:00','2026-02-13 21:40:32',NULL),(4,'Hypertension Self-Care Tips','Infographic with daily tips for managing high blood pressure at home.','IMAGE','hypertension','bp_tips_infographic.png',540000,'LOCAL','/assets/images/bp_tips_infographic.png',NULL,1,1,4,'2026-02-10 10:00:00','2026-02-13 21:40:32',NULL),(5,'Post-Surgical Wound Care','Instructions for patients on caring for surgical wounds after discharge.','PDF','post-op','wound_care_guide.pdf',1200000,'LOCAL','/assets/documents/wound_care_guide.pdf',NULL,1,1,5,'2026-02-10 10:00:00','2026-02-13 21:40:32',NULL),(6,'Hand Hygiene Training Video','WHO-standard hand hygiene technique for clinic staff.','VIDEO','infection-ctrl',NULL,NULL,'URL','https://example.org/videos/hand_hygiene.mp4',NULL,0,1,1,'2026-02-11 08:00:00','2026-02-13 21:40:32',NULL),(7,'Diabetic Foot Care','Visual guide for diabetic patients on daily foot inspection and care.','DOCUMENT','diabetes','diabetic_foot_care.docx',890000,'LOCAL','/assets/documents/diabetic_foot_care.docx',NULL,1,1,5,'2026-02-11 09:00:00','2026-02-13 21:40:32',NULL),(8,'Camp Registration Form Template','Printable patient registration form for use at medical camps.','PDF','admin','camp_reg_form.pdf',350000,'LOCAL','/assets/documents/camp_reg_form.pdf',NULL,0,1,10,'2026-02-12 09:00:00','2026-02-13 21:40:32',NULL),(9,'Diabetic Foot Care – Telugu','Patient-friendly guide for diabetic foot inspection and care, translated into Telugu.','PDF','diabetes','diabetic_foot_care_te.pdf',910000,'LOCAL','/assets/documents/diabetic_foot_care_te.pdf',NULL,1,1,16,'2026-03-15 09:00:00','2026-04-08 23:44:35',NULL),(10,'Antenatal Care Guide – English & Telugu','Bilingual guide covering diet, exercise, warning signs, and fetal movement counting for pregnant women.','PDF','maternal','antenatal_guide_en_te.pdf',1800000,'LOCAL','/assets/documents/antenatal_guide_en_te.pdf',NULL,1,1,16,'2026-03-20 10:00:00','2026-04-08 23:44:35',NULL),(11,'Hypertension Medication Adherence Video','Short video (4 min) on the importance of taking BP medications daily, with common patient concerns addressed.','VIDEO','hypertension',NULL,NULL,'URL','https://example.org/videos/bp_adherence.mp4',NULL,1,1,4,'2026-03-01 11:00:00','2026-04-08 23:44:35',NULL),(12,'Asthma Action Plan Template','Customisable asthma action plan for patients to fill with their doctor. Covers green/yellow/red zones.','PDF','respiratory','asthma_action_plan.pdf',480000,'LOCAL','/assets/documents/asthma_action_plan.pdf',NULL,1,1,17,'2026-03-28 09:00:00','2026-04-08 23:44:35',NULL),(13,'Camp Registration and Consent Form (Updated)','Updated bilingual (English/Telugu) camp registration form with updated consent language per legal review.','PDF','admin','camp_reg_form_v2.pdf',390000,'LOCAL','/assets/documents/camp_reg_form_v2.pdf',NULL,0,1,10,'2026-04-01 09:00:00','2026-04-08 23:44:35',NULL),(14,'COPD Patient Education Card','Pocket card explaining COPD triggers, inhaler technique, and when to seek emergency care.','IMAGE','respiratory','copd_patient_card.png',220000,'LOCAL','/assets/images/copd_patient_card.png',NULL,1,1,5,'2026-03-10 14:00:00','2026-04-08 23:44:35',NULL),(15,'Wound Dressing Protocol – Nursing Staff','Step-by-step wound dressing protocol for diabetic foot ulcers and post-surgical wounds. Internal staff use only.','PDF','wound-care','wound_dressing_protocol.pdf',760000,'LOCAL','/assets/documents/wound_dressing_protocol.pdf',NULL,0,1,6,'2026-03-18 10:00:00','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_sheet_audit_log`
--

DROP TABLE IF EXISTS `case_sheet_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `case_sheet_audit_log` (
  `audit_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `case_sheet_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `changed_by_name` varchar(121) DEFAULT NULL,
  `field_name` varchar(100) NOT NULL,
  `old_value` longtext DEFAULT NULL,
  `new_value` longtext DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_case_sheet` (`case_sheet_id`,`changed_at`),
  KEY `idx_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_case_sheet` FOREIGN KEY (`case_sheet_id`) REFERENCES `case_sheets` (`case_sheet_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_sheet_audit_log`
--

LOCK TABLES `case_sheet_audit_log` WRITE;
/*!40000 ALTER TABLE `case_sheet_audit_log` DISABLE KEYS */;
INSERT INTO `case_sheet_audit_log` VALUES (1,13,13,'Nurse Test01','status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 16:44:24'),(2,13,13,'Nurse Test01','family_history_cancer',NULL,'0','2026-02-18 16:44:50'),(3,13,13,'Nurse Test01','status','INTAKE_IN_PROGRESS','INTAKE_COMPLETE','2026-02-18 16:45:11'),(4,13,12,'Doctor Test01','status','INTAKE_COMPLETE','DOCTOR_REVIEW','2026-02-18 16:45:35'),(5,13,12,'Doctor Test01','doctor_exam_notes','','This is a test input..','2026-02-18 16:46:09'),(6,13,12,'Doctor Test01','doctor_plan_notes','','I am testing the saving functions.','2026-02-18 16:46:20'),(7,13,12,'Doctor Test01','status','DOCTOR_REVIEW','CLOSED','2026-02-18 16:46:40'),(8,13,12,'Doctor Test01','is_closed','0','1','2026-02-18 16:46:40'),(9,13,12,'Doctor Test01','closure_type','PENDING','DISCHARGED','2026-02-18 16:46:40'),(10,13,12,'Doctor Test01','closed_by_user_id',NULL,'12','2026-02-18 16:46:40'),(11,13,12,'Doctor Test01','closed_at',NULL,'2026-02-18 23:46:40','2026-02-18 16:46:40'),(12,13,12,'Doctor Test01','is_locked','0','1','2026-02-18 16:46:40'),(13,14,12,'Doctor Test01','status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 17:45:56'),(14,15,13,'Nurse Test01','status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 19:05:14'),(15,16,13,'Nurse Test01','status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 19:06:59'),(16,16,13,'Nurse Test01','condition_dm',NULL,'CURRENT','2026-02-18 19:09:22'),(17,16,13,'Nurse Test01','condition_htn',NULL,'CURRENT','2026-02-18 19:09:23'),(18,16,13,'Nurse Test01','condition_tsh',NULL,'PAST','2026-02-18 19:09:26'),(19,16,13,'Nurse Test01','condition_heart_disease',NULL,'CURRENT','2026-02-18 19:09:27'),(20,16,13,'Nurse Test01','condition_others',NULL,'Heart disease.','2026-02-18 19:09:48'),(21,16,13,'Nurse Test01','family_history_diabetes',NULL,'1','2026-02-18 19:10:04'),(22,16,13,'Nurse Test01','summary_doctor_summary',NULL,'This is a test of the doctor\'s summary area from intake.','2026-02-18 19:16:46'),(23,16,13,'Nurse Test01','status','INTAKE_IN_PROGRESS','INTAKE_COMPLETE','2026-02-18 19:16:49'),(24,16,12,'Doctor Test01','status','INTAKE_COMPLETE','DOCTOR_REVIEW','2026-02-18 19:18:07'),(25,17,12,'Doctor Test01','status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 19:43:08'),(26,16,12,'Doctor Test01','follow_up_date','','2026-03-11','2026-02-18 19:46:06'),(27,16,12,'Doctor Test01','status','DOCTOR_REVIEW','CLOSED','2026-02-18 19:46:57'),(28,16,12,'Doctor Test01','is_closed','0','1','2026-02-18 19:46:57'),(29,16,12,'Doctor Test01','closure_type','PENDING','DISCHARGED','2026-02-18 19:46:57'),(30,16,12,'Doctor Test01','closed_by_user_id',NULL,'12','2026-02-18 19:46:57'),(31,16,12,'Doctor Test01','closed_at',NULL,'2026-02-19 02:46:57','2026-02-18 19:46:57'),(32,16,12,'Doctor Test01','is_locked','0','1','2026-02-18 19:46:57'),(33,18,13,'Nurse Test01','status',NULL,'INTAKE_IN_PROGRESS','2026-02-26 14:30:20'),(34,4,13,'Nurse Test01','no_known_allergies',NULL,'1','2026-02-27 13:42:16'),(35,4,13,'Nurse Test01','no_known_allergies','1','','2026-02-27 13:44:06'),(36,4,13,'Nurse Test01','no_known_allergies','','0','2026-02-27 13:44:06'),(37,4,12,'Doctor Test01','no_known_allergies','0','1','2026-03-02 13:40:38'),(38,4,12,'Doctor Test01','temperature',NULL,'98','2026-03-02 13:40:48'),(39,4,12,'Doctor Test01','status','INTAKE_IN_PROGRESS','INTAKE_COMPLETE','2026-03-02 13:50:19'),(40,11,12,'Doctor Test01','status','INTAKE_COMPLETE','DOCTOR_REVIEW','2026-03-02 19:46:31'),(41,4,13,'Nurse Test01','general_bp_systolic',NULL,'123','2026-03-18 18:42:11'),(42,4,13,'Nurse Test01','general_bp_diastolic',NULL,'','2026-03-18 18:42:15'),(43,4,13,'Nurse Test01','general_bp_systolic','123','180','2026-03-18 18:42:18'),(44,4,13,'Nurse Test01','general_bp_diastolic','','100','2026-03-18 18:42:28');
/*!40000 ALTER TABLE `case_sheet_audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `case_sheets`
--

DROP TABLE IF EXISTS `case_sheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `case_sheets` (
  `case_sheet_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` int(10) unsigned NOT NULL,
  `visit_datetime` datetime NOT NULL DEFAULT current_timestamp(),
  `visit_type` enum('CAMP','CLINIC','FOLLOW_UP','EMERGENCY','OTHER') NOT NULL DEFAULT 'CAMP',
  `status` enum('INTAKE_IN_PROGRESS','INTAKE_COMPLETE','SCHEDULED','QUEUED','DOCTOR_REVIEW','CLOSED') NOT NULL DEFAULT 'INTAKE_IN_PROGRESS',
  `queue_position` float unsigned DEFAULT NULL,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_by_name` varchar(121) DEFAULT NULL,
  `assigned_doctor_user_id` int(10) unsigned DEFAULT NULL,
  `assigned_doctor_name` varchar(121) DEFAULT NULL,
  `chief_complaint` varchar(255) DEFAULT NULL,
  `history_present_illness` text DEFAULT NULL,
  `vitals_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`vitals_json`)),
  `exam_notes` text DEFAULT NULL,
  `diag_breast` longtext DEFAULT NULL,
  `diag_pelvic` longtext DEFAULT NULL,
  `diag_via` longtext DEFAULT NULL,
  `diag_vili` longtext DEFAULT NULL,
  `assessment` text DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `plan_notes` text DEFAULT NULL,
  `doctor_exam_notes` text DEFAULT NULL,
  `doctor_assessment` text DEFAULT NULL,
  `doctor_diagnosis` text DEFAULT NULL,
  `doctor_plan_notes` text DEFAULT NULL,
  `prescriptions` text DEFAULT NULL,
  `advice` text DEFAULT NULL,
  `follow_up_date` date DEFAULT NULL,
  `referral_to` varchar(255) DEFAULT NULL,
  `referral_reason` text DEFAULT NULL,
  `follow_up_notes` text DEFAULT NULL,
  `is_closed` tinyint(1) NOT NULL DEFAULT 0,
  `closed_at` datetime DEFAULT NULL,
  `closed_by_user_id` int(10) unsigned DEFAULT NULL,
  `closure_type` enum('DISCHARGED','FOLLOW_UP','REFERRAL','PENDING') NOT NULL DEFAULT 'PENDING',
  `disposition` varchar(255) DEFAULT NULL,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`case_sheet_id`),
  KEY `idx_case_sheets_patient` (`patient_id`,`visit_datetime`),
  KEY `idx_case_sheets_closed` (`is_closed`,`closed_at`),
  KEY `idx_case_sheets_visit_date` (`visit_datetime`),
  KEY `idx_case_sheets_status` (`status`,`visit_datetime`),
  KEY `idx_case_sheets_queue` (`status`,`queue_position`,`visit_datetime`),
  CONSTRAINT `fk_case_sheets_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_sheets`
--

LOCK TABLES `case_sheets` WRITE;
/*!40000 ALTER TABLE `case_sheets` DISABLE KEYS */;
INSERT INTO `case_sheets` VALUES (1,5,'2026-02-10 09:20:00','CAMP','CLOSED',NULL,8,NULL,4,'Siva Jasthi','Persistent headaches for 2 weeks','Patient reports daily headaches starting in the morning, worsening with activity. No history of migraine. No visual disturbances.','{\"bp_systolic\":148,\"bp_diastolic\":92,\"pulse\":82,\"temp_f\":98.4,\"spo2\":97,\"weight_kg\":68,\"height_cm\":158}','Alert, oriented. No papilledema. Neck supple. No neurological deficits.',NULL,NULL,NULL,NULL,'Headaches likely secondary to uncontrolled hypertension.','Essential hypertension, Stage 1','Start antihypertensive. Lifestyle modifications. Review in 2 weeks.',NULL,NULL,NULL,NULL,'Tab Amlodipine 5mg OD x 30 days','Reduce salt intake. Walk 30 min daily. Avoid stress. Monitor BP at home.','2026-02-24',NULL,NULL,'Review BP log, assess medication response.',1,'2026-02-10 09:50:00',4,'FOLLOW_UP','Started on antihypertensive. Follow-up in 2 weeks.',0,'2026-02-10 09:20:00','2026-03-25 18:43:14',NULL),(2,6,'2026-02-10 09:35:00','CAMP','CLOSED',NULL,8,NULL,4,'Siva Jasthi','Chest pain on exertion for 1 month','Patient describes substernal chest tightness during walking uphill, relieved by rest. Smoker 30 pack-years. Family history of MI (father at age 55).','{\"bp_systolic\":160,\"bp_diastolic\":95,\"pulse\":88,\"temp_f\":98.6,\"spo2\":95,\"weight_kg\":82,\"height_cm\":170}','Obese. Mild wheeze bilaterally. S1S2 normal, no murmurs. Peripheral pulses present.',NULL,NULL,NULL,NULL,'Exertional chest pain — need to rule out ischemic heart disease.','Suspected angina pectoris; COPD likely','Urgent referral for ECG, stress test, and cardiac workup.',NULL,NULL,NULL,NULL,'Tab Aspirin 75mg OD, Tab Atorvastatin 20mg HS, SL Sorbitrate 5mg SOS','Stop smoking immediately. Avoid heavy exertion. Go to ER if chest pain at rest.',NULL,'Sassoon General Hospital, Cardiology','Suspected unstable angina, needs urgent cardiac evaluation and possible angiography.',NULL,1,'2026-02-10 10:15:00',4,'REFERRAL','Referred to cardiology for urgent evaluation.',1,'2026-02-10 09:35:00','2026-03-25 18:43:14',NULL),(3,7,'2026-02-10 10:05:00','CAMP','CLOSED',NULL,9,NULL,5,'MANVITH KUMAR REDDY DEVARAPALLI','Joint pain in both knees for 6 months','Bilateral knee pain, worse on climbing stairs and squatting. Morning stiffness lasting 15 minutes. No swelling or redness.','{\"bp_systolic\":120,\"bp_diastolic\":78,\"pulse\":74,\"temp_f\":98.2,\"spo2\":98,\"weight_kg\":72,\"height_cm\":160}','Crepitus bilateral knees. No effusion. Full ROM with pain at extremes. BMI 28.1.',NULL,NULL,NULL,NULL,'Bilateral knee osteoarthritis, Grade 2.','Osteoarthritis, bilateral knees','Weight reduction. Quadriceps strengthening exercises. Analgesics as needed.',NULL,NULL,NULL,NULL,'Tab Paracetamol 650mg TDS x 14 days, Cap Glucosamine 1500mg OD x 30 days','Lose 5 kg over next 3 months. Avoid squatting and stair climbing. Use warm compresses.','2026-02-24',NULL,NULL,'Review symptoms. Consider X-ray if no improvement.',1,'2026-02-10 10:35:00',5,'DISCHARGED','Conservative management. Follow-up in 2 weeks.',0,'2026-02-10 10:05:00','2026-03-25 18:43:14',NULL),(4,8,'2026-02-10 10:35:00','CAMP','INTAKE_COMPLETE',1,8,NULL,5,'MANVITH KUMAR REDDY DEVARAPALLI','Uncontrolled diabetes — blood sugar very high','Known diabetic for 12 years. Currently on Metformin 500mg BD. Reports polyuria, polydipsia, blurred vision for 1 month. Last HbA1c was 9.2% (3 months ago).','{\"bp_systolic\":135,\"bp_diastolic\":85,\"pulse\":80,\"temp_f\":98.400000000000005684341886080801486968994140625,\"spo2\":97,\"weight_kg\":78,\"height_cm\":168,\"rbs_mg_dl\":320,\"temperature\":\"98\",\"general_bp_systolic\":\"180\",\"general_bp_diastolic\":\"100\"}','Dry skin. Reduced sensation in feet bilaterally. Fundoscopy: early background retinopathy.',NULL,NULL,NULL,NULL,'{\"no_known_allergies\":\"1\"}','Type 2 Diabetes Mellitus, uncontrolled; Diabetic peripheral neuropathy; Background diabetic retinopathy','Intensify glycemic control. Add second oral agent. Ophthalmology referral for retinopathy. Foot care education.',NULL,NULL,NULL,NULL,'Tab Metformin 1000mg BD, Tab Glimepiride 2mg OD before breakfast, Tab Methylcobalamin 1500mcg OD','Strict diabetic diet. Check blood sugar fasting and post-meal daily. Foot care — inspect daily, wear proper footwear.','2026-02-17',NULL,NULL,'Review fasting and post-meal blood sugar diary. Repeat HbA1c.',0,NULL,NULL,'PENDING',NULL,0,'2026-02-10 10:35:00','2026-03-25 18:43:14',NULL),(5,9,'2026-02-11 09:10:00','CLINIC','CLOSED',NULL,8,NULL,4,'Siva Jasthi','Sore throat and fever for 3 days','High-grade fever (102F) with sore throat and difficulty swallowing. No cough. No rash.','{\"bp_systolic\":110,\"bp_diastolic\":70,\"pulse\":96,\"temp_f\":101.8,\"spo2\":98,\"weight_kg\":55,\"height_cm\":162}','Pharynx congested. Tonsils enlarged, bilateral, with whitish exudate. Anterior cervical lymph nodes tender and palpable.',NULL,NULL,NULL,NULL,'Acute exudative tonsillitis, likely bacterial.','Acute bacterial tonsillitis','Antibiotics x 7 days. Symptomatic treatment. Review if not improving in 48 hours.',NULL,NULL,NULL,NULL,'Tab Amoxicillin 500mg TDS x 7 days, Tab Paracetamol 500mg TDS x 3 days, Betadine gargle TDS','Warm saline gargles. Soft diet. Plenty of fluids. Rest.',NULL,NULL,NULL,NULL,1,'2026-02-11 09:40:00',4,'DISCHARGED','Acute tonsillitis. Antibiotics prescribed.',0,'2026-02-11 09:10:00','2026-03-25 18:43:14',NULL),(6,10,'2026-02-11 10:00:00','CLINIC','INTAKE_COMPLETE',2,9,NULL,5,'MANVITH KUMAR REDDY DEVARAPALLI','Lower back pain radiating to left leg for 1 week','Acute onset LBP after lifting heavy furniture. Pain radiates to left buttock and posterior thigh. Numbness in left foot. No bladder/bowel involvement.','{\"bp_systolic\":130,\"bp_diastolic\":82,\"pulse\":78,\"temp_f\":98.4,\"spo2\":98,\"weight_kg\":85,\"height_cm\":175}','Lumbar paraspinal muscle spasm. SLR positive left at 40 degrees. Reduced ankle jerk left. No motor deficit.',NULL,NULL,NULL,NULL,'Acute lumbar radiculopathy, likely L5-S1 disc involvement.','Lumbar disc herniation with left L5-S1 radiculopathy','Conservative management initially. MRI if no improvement in 2 weeks. Strict bed rest 48 hours.',NULL,NULL,NULL,NULL,'Tab Diclofenac 50mg BD x 7 days, Tab Thiocolchicoside 4mg BD x 7 days, Tab Pregabalin 75mg HS x 14 days','Strict bed rest on firm mattress for 48 hours. Avoid bending and lifting. Apply hot fomentation. Begin gentle back exercises after pain subsides.','2026-02-25',NULL,NULL,'Review pain response. If persistent numbness or weakness, urgent MRI.',0,NULL,NULL,'PENDING',NULL,0,'2026-02-11 10:00:00','2026-03-25 18:43:14',NULL),(7,11,'2026-02-11 11:00:00','CLINIC','CLOSED',NULL,8,NULL,4,'Siva Jasthi','Skin rash on both arms for 5 days','Itchy, red, raised rash on both forearms. Started after using a new laundry detergent. No fever. No prior history of eczema.','{\"bp_systolic\":112,\"bp_diastolic\":72,\"pulse\":70,\"temp_f\":98.0,\"spo2\":99,\"weight_kg\":52,\"height_cm\":155}','Erythematous papular rash on bilateral forearms. No vesicles. No secondary infection. Rest of skin clear.',NULL,NULL,NULL,NULL,'Contact dermatitis secondary to detergent exposure.','Allergic contact dermatitis','Topical steroids. Antihistamine. Avoid offending agent.',NULL,NULL,NULL,NULL,'Cream Betamethasone 0.05% apply BD x 7 days, Tab Cetirizine 10mg HS x 7 days','Stop using the new detergent. Use fragrance-free, hypoallergenic products. Keep skin moisturized.',NULL,NULL,NULL,NULL,1,'2026-02-11 11:25:00',4,'DISCHARGED','Contact dermatitis. Topical treatment prescribed.',0,'2026-02-11 11:00:00','2026-03-25 18:43:14',NULL),(8,12,'2026-02-12 08:45:00','EMERGENCY','CLOSED',NULL,8,NULL,5,'MANVITH KUMAR REDDY DEVARAPALLI','Sudden severe abdominal pain with vomiting','Acute onset severe epigastric pain radiating to back, started 2 hours ago after a heavy meal. Multiple episodes of vomiting. History of gallstones diagnosed 6 months ago.','{\"bp_systolic\":100,\"bp_diastolic\":65,\"pulse\":110,\"temp_f\":100.2,\"spo2\":96,\"weight_kg\":75,\"height_cm\":165}','Distressed, diaphoretic. Abdomen — guarding in epigastrium and RUQ. Tenderness with rebound. Bowel sounds reduced. Murphy sign positive.',NULL,NULL,NULL,NULL,'Acute abdomen — likely acute cholecystitis or biliary pancreatitis given history of gallstones.','Acute cholecystitis; Rule out acute pancreatitis','IV fluids, NPO, pain management. Urgent surgical referral.',NULL,NULL,NULL,NULL,'Inj Pantoprazole 40mg IV stat, Inj Tramadol 50mg IV stat, NS 1000ml IV over 4 hours','Nothing by mouth. Immediate transfer to hospital.',NULL,'Ruby Hall Clinic, Surgery','Acute abdomen with suspected cholecystitis/pancreatitis. Needs urgent imaging and surgical consult.',NULL,1,'2026-02-12 09:30:00',5,'REFERRAL','Emergency referral to surgery for acute abdomen.',1,'2026-02-12 08:45:00','2026-03-25 18:43:14',NULL),(9,13,'2026-02-12 09:20:00','CLINIC','CLOSED',NULL,9,NULL,4,'Siva Jasthi','Irregular periods and fatigue for 3 months','Menstrual cycles irregular — ranging from 20 to 45 days. Heavy flow lasting 7-8 days. Feeling very tired. Weight gain of 5 kg in 3 months.','{\"bp_systolic\":118,\"bp_diastolic\":76,\"pulse\":72,\"temp_f\":98.2,\"spo2\":99,\"weight_kg\":70,\"height_cm\":163}','Mild pallor. Thyroid not enlarged. No hirsutism. Abdomen soft, no masses.',NULL,NULL,NULL,NULL,'Irregular menstruation with fatigue. Need to rule out thyroid dysfunction and anemia.','Dysfunctional uterine bleeding; Anemia to be ruled out; Hypothyroidism to be ruled out','Blood work: CBC, TSH, Free T4, Iron studies. Pelvic ultrasound. Review with reports.',NULL,NULL,NULL,NULL,'Tab Ferrous Fumarate 200mg BD x 30 days, Tab Tranexamic Acid 500mg TDS during menses x 5 days','Iron-rich diet — green leafy vegetables, jaggery, dates. Maintain menstrual diary. Return with blood reports.','2026-02-19',NULL,NULL,'Review CBC and thyroid reports. Adjust treatment accordingly.',1,'2026-02-12 10:00:00',4,'FOLLOW_UP','Lab work ordered. Follow-up with reports.',0,'2026-02-12 09:20:00','2026-03-25 18:43:14',NULL),(10,14,'2026-02-13 08:15:00','CLINIC','INTAKE_COMPLETE',3,8,NULL,4,'Siva Jasthi','Burning urination and frequent urge to urinate for 4 days','Dysuria with increased frequency for 4 days. Mild suprapubic discomfort. No fever. No hematuria. No flank pain.','{\"bp_systolic\":128,\"bp_diastolic\":80,\"pulse\":76,\"temp_f\":98.6,\"spo2\":98,\"weight_kg\":80,\"height_cm\":172}','Abdomen soft. Mild suprapubic tenderness. No costovertebral angle tenderness. No urethral discharge.',NULL,NULL,NULL,NULL,'Lower urinary tract infection.','Acute cystitis','Empirical antibiotics. Urine culture to confirm. Increase fluid intake.',NULL,NULL,NULL,NULL,'Tab Nitrofurantoin 100mg BD x 5 days','Drink at least 3 liters of water daily. Avoid holding urine. Complete full course of antibiotics.',NULL,NULL,NULL,'Review urine culture results if symptoms persist.',0,NULL,NULL,'PENDING',NULL,0,'2026-02-13 08:15:00','2026-03-25 18:43:14',NULL),(11,1,'2026-02-17 19:58:55','CAMP','DOCTOR_REVIEW',4,13,'Nurse Test01',12,'Doctor Test01','Shortness of breath','Prior history of asthma.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-17 19:58:55','2026-03-25 18:43:14',NULL),(12,1,'2026-02-17 20:09:26','CAMP','INTAKE_IN_PROGRESS',5,13,'Nurse Test01',NULL,NULL,'Shortness of breath',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-17 20:09:26','2026-03-25 18:43:14',NULL),(13,16,'2026-02-18 16:44:24','CAMP','CLOSED',NULL,13,'Nurse Test01',12,'Doctor Test01','Stomach pains',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{\"family_history_cancer\":\"0\"}',NULL,NULL,'This is a test input..',NULL,NULL,'I am testing the saving functions.',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-18 23:46:40',12,'DISCHARGED',NULL,1,'2026-02-18 16:44:24','2026-03-25 18:43:14',NULL),(14,16,'2026-02-18 17:45:56','FOLLOW_UP','INTAKE_IN_PROGRESS',2,12,'Doctor Test01',NULL,NULL,'chest pain',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-18 17:45:56','2026-03-25 18:43:14',NULL),(15,4,'2026-02-18 19:05:14','EMERGENCY','INTAKE_IN_PROGRESS',1,13,'Nurse Test01',NULL,NULL,'chest pain',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-18 19:05:14','2026-03-25 18:43:14',NULL),(16,6,'2026-02-18 19:06:59','CAMP','CLOSED',NULL,13,'Nurse Test01',12,'Doctor Test01','Asthma',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{\"condition_dm\":\"CURRENT\",\"condition_htn\":\"CURRENT\",\"condition_tsh\":\"PAST\",\"condition_heart_disease\":\"CURRENT\",\"condition_others\":\"Heart disease.\",\"family_history_diabetes\":\"1\"}',NULL,'{\"summary_doctor_summary\":\"This is a test of the doctor\'s summary area from intake.\"}',NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11',NULL,NULL,NULL,1,'2026-02-19 02:46:57',12,'DISCHARGED',NULL,1,'2026-02-18 19:06:59','2026-03-25 18:43:14',NULL),(17,16,'2026-02-18 19:43:08','CLINIC','INTAKE_IN_PROGRESS',NULL,12,'Doctor Test01',NULL,NULL,'shortness of breath',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-18 19:43:08','2026-03-25 18:43:14',NULL),(18,3,'2026-02-26 14:30:20','FOLLOW_UP','INTAKE_IN_PROGRESS',NULL,13,'Nurse Test01',NULL,NULL,'Wound care',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-26 14:30:20','2026-03-25 18:43:14',NULL),(19,18,'2026-03-04 17:27:39','OTHER','SCHEDULED',NULL,13,'Nurse Test01',12,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-03-04 17:27:39','2026-03-25 19:21:24',NULL),(20,19,'2026-03-25 19:17:11','OTHER','INTAKE_IN_PROGRESS',NULL,13,'Nurse Test01',NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-03-25 19:17:11','2026-03-25 19:17:11',NULL),(21,17,'2026-03-26 20:05:03','OTHER','SCHEDULED',NULL,13,'Nurse Test01',12,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-03-26 20:05:03','2026-03-26 20:05:03',NULL),(22,26,'2026-03-25 09:05:00','EMERGENCY','CLOSED',NULL,13,'Sunil Varma',17,'Kiran Rao','Sudden breathlessness and wheezing — known asthmatic','Young male, known asthmatic since childhood. Sudden wheeze and dyspnoea 45 minutes ago triggered by dust exposure at construction site. Used Salbutamol inhaler twice without relief.','{\"bp_systolic\":120,\"bp_diastolic\":78,\"pulse\":108,\"temperature\":37.0,\"weight_kg\":68,\"height_cm\":178,\"spo2\":92,\"respiratory_rate\":24}','Bilateral wheeze, moderate. Accessory muscles used. SpO2 92%. Speaking in sentences.',NULL,NULL,NULL,NULL,'Acute moderate asthma attack. Needs nebulisation and observation.','Acute exacerbation of bronchial asthma, moderate severity','Salbutamol nebulisation x2. Oral prednisolone. Observe for 2 hours. Discharge if SpO2 >95% stable.','Post-nebulisation: SpO2 97%, wheeze reduced significantly.','Moderate asthma attack, responded to nebulisation.','Acute asthma exacerbation, responded to treatment','Discharge on oral steroids + preventer. Follow-up in 2 weeks.','Salbutamol 5mg nebulisation x2, Tab Prednisolone 40mg OD x 5 days','Avoid triggers (dust, smoke, pets). Use Budesonide inhaler twice daily. Carry Salbutamol at all times. Go to hospital if inhaler gives no relief.','2026-04-08',NULL,NULL,'Review asthma control. Check preventer inhaler technique.',1,'2026-03-25 10:30:00',17,'DISCHARGED','Asthma attack, responded to nebulisation. Discharged.',0,'2026-03-25 09:05:00','2026-04-08 23:44:35',NULL),(23,27,'2026-04-07 09:05:00','CLINIC','INTAKE_IN_PROGRESS',1,12,'Nandita Krishnan',17,'Kiran Rao','Low back pain for 5 days','Elderly woman with lower back pain after lifting a water bucket. Pain constant, worse on movement. No radiation to legs. No bladder/bowel symptoms.','{\"bp_systolic\":136,\"bp_diastolic\":84,\"pulse\":76,\"temperature\":36.8,\"weight_kg\":62,\"height_cm\":152,\"spo2\":97}',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-04-07 09:05:00','2026-04-08 23:44:35',NULL),(24,28,'2026-04-01 08:35:00','CLINIC','INTAKE_IN_PROGRESS',2,13,'Sunil Varma',5,'Amit Patel','Fatigue, excessive thirst and frequent urination for 1 month','No prior medical history. Symptoms of polyuria, polydipsia, and fatigue for 1 month. Father has T2DM. BMI 29. Office worker, sedentary lifestyle.','{\"bp_systolic\":130,\"bp_diastolic\":84,\"pulse\":82,\"temperature\":36.9,\"weight_kg\":84,\"height_cm\":170,\"spo2\":99,\"blood_sugar\":318}',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-04-01 08:35:00','2026-04-08 23:44:35',NULL),(25,30,'2026-04-07 09:05:00','CLINIC','INTAKE_COMPLETE',3,14,'Ravi Shankar',5,'Amit Patel','Hip pain after a fall at home this morning','Elderly male, fell from standing height in bathroom. Right hip pain, unable to bear weight. No loss of consciousness. No head injury. History of osteoporosis.','{\"bp_systolic\":148,\"bp_diastolic\":88,\"pulse\":92,\"temperature\":36.9,\"weight_kg\":58,\"height_cm\":163,\"spo2\":97}','Right hip: tenderness at greater trochanter and inguinal region. Leg shortened and externally rotated. Passive ROM severely painful. Neurovascular intact distally.',NULL,NULL,NULL,NULL,'Right hip — possible neck of femur fracture. Needs urgent X-ray.','Suspected right NOF fracture post-fall','X-ray right hip. IV access. Pain management. Likely hospital referral for surgical intervention.',NULL,NULL,NULL,NULL,'Inj Morphine 2mg IV for pain, NS 500ml IV for hydration',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-04-07 09:05:00','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `case_sheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `event_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_type` enum('MEDICAL_CAMP','EDUCATIONAL_SEMINAR','TRAINING','MEETING','OTHER') NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime DEFAULT NULL,
  `location_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `state_province` varchar(80) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `status` enum('DRAFT','SCHEDULED','ACTIVE','COMPLETED','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`event_id`),
  KEY `idx_events_type` (`event_type`),
  KEY `idx_events_status` (`status`),
  KEY `idx_events_start` (`start_datetime`),
  KEY `idx_events_city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'MEDICAL_CAMP','Health Camp - Community Center',NULL,'2026-02-10 09:00:00','2026-02-10 16:00:00','Ward 12 Community Center',NULL,'Pune','Maharashtra',NULL,'SCHEDULED',1,NULL,'2026-02-04 20:14:30','2026-02-04 20:14:30',NULL),(2,'EDUCATIONAL_SEMINAR','Diabetes Prevention Seminar',NULL,'2026-02-12 18:00:00',NULL,'Library Meeting Room A',NULL,'St. Paul','MN',NULL,'SCHEDULED',1,NULL,'2026-02-04 20:14:36','2026-02-04 20:14:36',NULL),(3,'MEDICAL_CAMP','Eye Screening Camp','Free eye check-ups and spectacle distribution for senior citizens.','2026-02-15 09:00:00','2026-02-15 15:00:00','Government School Ground','Shivaji Nagar','Pune','Maharashtra','411005','SCHEDULED',1,1,'2026-02-10 12:00:00','2026-02-13 21:40:32',NULL),(4,'TRAINING','First Aid Refresher for Nurses','Annual first-aid certification renewal training.','2026-02-18 10:00:00','2026-02-18 13:00:00','D3S3 Training Room','Office Campus','Pune','Maharashtra','411001','SCHEDULED',1,1,'2026-02-10 12:00:00','2026-02-13 21:40:32',NULL),(5,'MEDICAL_CAMP','Rural Health Camp - Mulshi','General health screening and medicine distribution in rural Mulshi area.','2026-02-08 08:00:00','2026-02-08 17:00:00','Mulshi Gram Panchayat Hall','Mulshi Village','Mulshi','Maharashtra','412108','COMPLETED',1,1,'2026-02-01 10:00:00','2026-02-13 21:40:32',NULL),(6,'EDUCATIONAL_SEMINAR','Nutrition & Child Health Workshop','Interactive workshop on child nutrition for new mothers.','2026-02-20 14:00:00','2026-02-20 17:00:00','Community Health Center','Kothrud','Pune','Maharashtra','411038','DRAFT',1,10,'2026-02-12 09:00:00','2026-02-13 21:40:32',NULL),(7,'MEETING','Monthly Staff Review Meeting','Review of patient outcomes, camp reports, and upcoming schedule.','2026-02-14 16:00:00','2026-02-14 17:30:00','D3S3 Conference Room','Office Campus','Pune','Maharashtra','411001','SCHEDULED',1,1,'2026-02-10 14:00:00','2026-02-13 21:40:32',NULL),(8,'MEDICAL_CAMP','Chaitanya Hall Health Screening Camp','General health screening, diabetes and BP checks, eye screening for 80+ registered patients.','2026-03-15 08:00:00','2026-03-15 16:00:00','Chaitanya Community Hall','Erandwane','Pune','Maharashtra','411004','COMPLETED',1,10,'2026-03-05 10:00:00','2026-04-08 23:44:35',NULL),(9,'TRAINING','Labwork Module Staff Training','Hands-on walkthrough of the new Labwork module for nursing and data entry staff. Covers ordering tests, marking completions, and viewing pending queues.','2026-03-20 14:00:00','2026-03-20 15:00:00','D3S3 Training Room','Office Campus','Pune','Maharashtra','411001','COMPLETED',1,1,'2026-03-12 09:00:00','2026-04-08 23:44:35',NULL),(10,'EDUCATIONAL_SEMINAR','Maternal and Child Health Awareness Week','Week-long seminar series on antenatal care, breastfeeding, child immunisation, and nutrition. Open to community members.','2026-03-22 10:00:00','2026-03-28 16:00:00','Kothrud Community Health Center','Kothrud','Pune','Maharashtra','411038','COMPLETED',1,16,'2026-03-10 11:00:00','2026-04-08 23:44:35',NULL),(11,'MEDICAL_CAMP','Rural Diabetic Foot Care Camp — Mulshi','Specialised camp for diabetic patients targeting foot care education and wound screening. Collaboration with podiatry volunteer group.','2026-04-05 09:00:00','2026-04-05 15:00:00','Mulshi Gram Panchayat Hall','Mulshi Village','Mulshi','Maharashtra','412108','COMPLETED',1,10,'2026-03-25 10:00:00','2026-04-08 23:44:35',NULL),(12,'MEETING','Quarterly Clinical Review Q1 2026','Review of Q1 patient outcomes, camp statistics, staff performance, and planning for Q2. All senior staff required.','2026-04-07 16:00:00','2026-04-07 18:00:00','D3S3 Conference Room','Office Campus','Pune','Maharashtra','411001','ACTIVE',1,1,'2026-03-28 09:00:00','2026-04-08 23:44:35',NULL),(13,'MEDICAL_CAMP','April Wellness Camp — Hadapsar','General wellness screening, BP and blood sugar checks, dental referrals, and eye testing. Registration open.','2026-04-20 08:30:00','2026-04-20 16:00:00','Hadapsar Community Ground','Hadapsar','Pune','Maharashtra','411028','SCHEDULED',1,10,'2026-04-05 11:00:00','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback` (
  `feedback_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subject` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `status` enum('OPEN','UNDER_REVIEW','RESOLVED','CLOSED') NOT NULL DEFAULT 'OPEN',
  `submitted_by_user_id` int(10) unsigned NOT NULL,
  `assigned_to_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`feedback_id`),
  KEY `fk_feedback_submitted_by` (`submitted_by_user_id`),
  KEY `fk_feedback_assigned_to` (`assigned_to_user_id`),
  CONSTRAINT `fk_feedback_assigned_to` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_feedback_submitted_by` FOREIGN KEY (`submitted_by_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (3,'Request for interpreter for Telugu-speaking elderly patients','Several elderly patients at recent clinics spoke only Telugu and had difficulty communicating symptoms. The form fields in English are also inaccessible to them. We have the Telugu language option but it is not well known to patients. Suggest printing patient information forms in Telugu and having a designated Telugu interpreter at each camp.','OPEN',12,15,'2026-03-20 09:00:00','2026-04-08 23:44:35',NULL),(4,'ECG machine needs maintenance — inconsistent trace readings','The ECG machine in Exam Room 2 has been giving inconsistent readings for the past 2 weeks. Electrode contact is confirmed, but the trace is noisy and not diagnostic. Case 16 (chest pain patient) may have had an inconclusive ECG as a result. This needs urgent biomedical engineering review before we use it for any cardiac patients.','UNDER_REVIEW',5,1,'2026-03-21 14:00:00','2026-04-08 23:44:35',NULL),(6,'Recognition for triage team performance at March 15 camp','I want to formally commend the triage team (Nandita Krishnan, Sunil Varma, Ravi Shankar) for their exceptional performance at the March 15 Chaitanya Hall camp. Despite 80+ patient registrations, triage was completed for all patients within 45 minutes and zero cases were missed. This deserves formal recognition.','CLOSED',4,1,'2026-03-18 11:00:00','2026-04-08 23:44:35',NULL),(8,'Training needed on new labwork module','The new Labwork module was deployed but no formal training was given to nursing staff. Rohan and I had to figure it out on our own. There is confusion about when to mark orders as COMPLETED versus when the doctor should do it. Please schedule a 30-minute walkthrough session.','RESOLVED',6,1,'2026-03-10 09:00:00','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_orders`
--

DROP TABLE IF EXISTS `lab_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lab_orders` (
  `order_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `case_sheet_id` bigint(20) unsigned NOT NULL,
  `patient_id` int(10) unsigned NOT NULL,
  `test_name` varchar(200) NOT NULL,
  `order_notes` text DEFAULT NULL,
  `status` enum('PENDING','COMPLETED') NOT NULL DEFAULT 'PENDING',
  `ordered_by_user_id` int(10) unsigned NOT NULL,
  `ordered_at` datetime NOT NULL DEFAULT current_timestamp(),
  `completed_by_user_id` int(10) unsigned DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `result_notes` text DEFAULT NULL,
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`order_id`),
  KEY `idx_lab_orders_case_sheet` (`case_sheet_id`),
  KEY `idx_lab_orders_patient` (`patient_id`),
  KEY `idx_lab_orders_status` (`status`),
  KEY `fk_lab_orders_ordered_by` (`ordered_by_user_id`),
  KEY `fk_lab_orders_completed_by` (`completed_by_user_id`),
  CONSTRAINT `fk_lab_orders_case_sheet` FOREIGN KEY (`case_sheet_id`) REFERENCES `case_sheets` (`case_sheet_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lab_orders_completed_by` FOREIGN KEY (`completed_by_user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_lab_orders_ordered_by` FOREIGN KEY (`ordered_by_user_id`) REFERENCES `users` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_lab_orders_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_orders`
--

LOCK TABLES `lab_orders` WRITE;
/*!40000 ALTER TABLE `lab_orders` DISABLE KEYS */;
INSERT INTO `lab_orders` VALUES (1,4,8,'Fasting Blood Sugar (FBS)','Patient on Metformin + Glimepiride. Check fasting glucose for Feb 17 review.','COMPLETED',5,'2026-02-10 10:50:00',6,'2026-02-16 09:30:00','FBS: 186 mg/dL. Improved from 320 at presentation but still above target (<130). Continue current medications. Review HbA1c at next visit.',NULL),(2,4,8,'HbA1c','Repeat HbA1c to assess 3-month glucose control.','COMPLETED',5,'2026-02-10 10:50:00',6,'2026-02-16 09:45:00','HbA1c: 8.4%. Down from 9.2% three months ago. Trending in right direction. Target <7%. Intensify lifestyle modifications.',NULL),(3,4,8,'Serum Creatinine','Baseline renal function before intensifying medications.','COMPLETED',5,'2026-02-10 10:50:00',6,'2026-02-16 10:00:00','Creatinine: 1.1 mg/dL. Within normal range (0.7–1.3). No evidence of diabetic nephropathy at this stage.',NULL),(4,9,13,'Complete Blood Count (CBC)','Rule out anemia secondary to heavy menstrual bleeding.','COMPLETED',4,'2026-02-12 10:00:00',7,'2026-02-15 10:15:00','Hb: 9.8 g/dL (low). MCV: 72 fL (microcytic). Iron-deficiency anemia confirmed. Continue ferrous fumarate supplementation.',NULL),(5,9,13,'TSH (Thyroid Stimulating Hormone)','Rule out hypothyroidism causing menstrual irregularity and fatigue.','COMPLETED',4,'2026-02-12 10:00:00',7,'2026-02-15 10:30:00','TSH: 7.2 mIU/L (elevated, normal 0.5–4.5). Subclinical hypothyroidism confirmed. Start Levothyroxine 50mcg OD — advise Dr. Desai.',NULL),(6,9,13,'Iron Studies (Serum Iron, TIBC, Ferritin)','Confirm iron-deficiency etiology for microcytic anemia.','COMPLETED',4,'2026-02-12 10:00:00',7,'2026-02-15 10:45:00','Serum Iron: 42 mcg/dL (low). TIBC: 480 mcg/dL (high). Ferritin: 6 ng/mL (very low). Classic iron-deficiency pattern. Continue supplementation, recheck in 6 weeks.',NULL),(7,6,10,'MRI Lumbar Spine','Persistent left L5-S1 radiculopathy with foot numbness. Evaluate disc herniation severity.','PENDING',5,'2026-02-25 14:30:00',NULL,NULL,NULL,NULL),(8,1,5,'Lipid Profile','Baseline lipid panel for new hypertensive patient. Rule out dyslipidemia.','PENDING',4,'2026-02-24 10:15:00',NULL,NULL,NULL,NULL),(9,1,5,'Renal Function Test (RFT)','Baseline renal function before long-term antihypertensive use.','PENDING',4,'2026-02-24 10:15:00',NULL,NULL,NULL,NULL),(10,10,14,'Urine Culture & Sensitivity','Confirm acute cystitis diagnosis and guide antibiotic selection if empirical treatment fails.','PENDING',4,'2026-02-13 08:25:00',NULL,NULL,NULL,NULL),(11,16,20,'Resting ECG (12-lead)','Rule out ischaemia. Patient has exertional chest tightness.','COMPLETED',5,'2026-03-10 10:20:00',7,'2026-03-10 11:00:00','Normal sinus rhythm. Rate 86 bpm. No ST changes. No Q waves. Report: Normal ECG. Treadmill stress test recommended.',NULL),(12,16,20,'Lipid Profile','Baseline lipids for cardiovascular risk assessment.','COMPLETED',5,'2026-03-10 10:20:00',7,'2026-03-12 09:30:00','Total Cholesterol: 218 mg/dL (borderline). LDL: 142 mg/dL (high). HDL: 38 mg/dL (low). Triglycerides: 190 mg/dL (borderline). Start Atorvastatin — advise Dr. Patel.',NULL),(13,16,20,'Fasting Blood Sugar','Rule out diabetes as cardiovascular risk factor.','COMPLETED',5,'2026-03-10 10:20:00',7,'2026-03-12 09:45:00','FBS: 102 mg/dL. Pre-diabetic range (100-125 mg/dL). Lifestyle counselling indicated. Recheck HbA1c.',NULL),(14,21,25,'Bilateral Mammogram','Evaluate left breast lump, 2cm at 2 o\'clock position. Age 55, post-menopausal.','COMPLETED',4,'2026-03-20 10:35:00',6,'2026-03-24 10:00:00','Left breast: 2.1cm spiculated mass at 2 o\'clock position, 3cm from nipple. BIRADS 4C — high suspicion for malignancy. Biopsy strongly recommended. Right breast: no abnormality.',NULL),(15,21,25,'Breast Ultrasound','Supplement mammogram findings. Evaluate vascular supply and margins of left breast lump.','COMPLETED',4,'2026-03-20 10:35:00',6,'2026-03-24 10:30:00','Left breast: hypoechoic mass with irregular margins and posterior acoustic shadowing, 2.2 x 1.8 cm. BIRADS 4C. FNAC or core biopsy required urgently. Axillary nodes: no significant lymphadenopathy.',NULL),(16,13,17,'TSH (Thyroid Stimulating Hormone)','Repeat TSH 6 weeks after increasing Levothyroxine from 50mcg to 75mcg.','PENDING',17,'2026-03-01 10:35:00',NULL,NULL,NULL,NULL),(17,20,24,'Urine Microalbumin / Creatinine Ratio','Screen for early renal involvement in uncontrolled hypertension.','PENDING',5,'2026-03-20 09:30:00',NULL,NULL,NULL,NULL),(18,20,24,'Renal Function Test (Serum Creatinine, BUN)','Baseline renal function. BP suboptimally controlled.','PENDING',5,'2026-03-20 09:30:00',NULL,NULL,NULL,NULL),(19,24,28,'HbA1c','New presentation with RBS 318 mg/dL. Confirm T2DM and assess 3-month glucose burden.','PENDING',5,'2026-04-01 09:00:00',NULL,NULL,NULL,NULL),(20,24,28,'Fasting Lipid Profile','Assess cardiovascular risk at DM diagnosis.','PENDING',5,'2026-04-01 09:00:00',NULL,NULL,NULL,NULL),(21,24,28,'Urine Routine and Microscopy','Rule out glycosuria and proteinuria at diabetes diagnosis.','PENDING',5,'2026-04-01 09:00:00',NULL,NULL,NULL,NULL),(22,25,30,'X-ray Right Hip (AP and Lateral views)','Suspected neck of femur fracture after fall. Patient unable to weight-bear.','PENDING',5,'2026-04-07 09:20:00',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `lab_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `message_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `thread_id` char(32) NOT NULL DEFAULT '',
  `sender_user_id` int(10) unsigned NOT NULL,
  `recipient_user_id` int(10) unsigned NOT NULL,
  `subject` varchar(200) NOT NULL,
  `body` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `sent_at` datetime NOT NULL DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`message_id`),
  KEY `fk_messages_sender` (`sender_user_id`),
  KEY `fk_messages_recipient` (`recipient_user_id`),
  KEY `idx_messages_thread_id` (`thread_id`),
  CONSTRAINT `fk_messages_recipient` FOREIGN KEY (`recipient_user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_messages_sender` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'c4ca4238a0b923820dcc509a6f75849b',13,1,'This is a test','This is a test message.',1,'2026-03-20 13:06:50',NULL),(2,'c81e728d9d4c2f636f067f89cc14862c',1,13,'This is test 01 from Andrew H.','This is the first test message send from Andrew H.  This is a test message being send from my admin account.',1,'2026-03-20 13:46:02',NULL),(3,'eccbc87e4b5ce2fe28308fd9f2a7baf3',1,13,'Hello from Lincoln','My son says hello and is helping me test the messaging system!\r\n\r\nLincoln says: \"I like baseball!  I also like playing Fortnite with my dad!\"',1,'2026-03-20 13:48:58',NULL),(4,'e9bc05f2e95e615f3a154b6184641c69',13,14,'This is a test message (#2)','This is a test message. The second test message sent.',0,'2026-03-25 19:26:57',NULL),(5,'dd4dde149a9fdec95704e91eca8baefd',13,1,'Test message 02','This is a test.',1,'2026-03-26 19:18:34',NULL),(6,'02321d433db6bd0dbbbc4524f024a229',1,13,'Re: Test message 02','This is a test reply',1,'2026-03-26 19:18:56',NULL),(7,'945fd03fb62a7a31bb5db764ce1c3680',1,13,'Test message 02','This is a test.',1,'2026-03-26 19:19:11',NULL),(8,'',5,4,'Suresh Yadav post-referral update','Priya, just got word from Ruby Hall — Suresh Yadav (Case #8) was diagnosed with acute cholecystitis and underwent laparoscopic cholecystectomy yesterday. He is stable and will be discharged in 2 days. Worth updating his case sheet. – Amit.',0,'2026-02-15 08:30:00',NULL),(17,'',14,6,'Camp logistics for April 5 — Mulshi','Hi Sneha, for the April 5 Mulshi diabetic foot camp, I will bring the extended wound care kit per the new checklist (saline, iodoform gauze, collagen dressings, measuring tape). Can you confirm how many nursing staff will be attending? Also, do we have a referral letter template for patients needing hospital follow-up from camps? — Ravi.',0,'2026-03-28 10:00:00',NULL),(18,'',5,4,'Geeta Joshi BIRADS 4C — urgent discussion needed','Priya, the imaging results for Geeta Joshi (Case #21) came back as BIRADS 4C bilaterally. This is a high suspicion lesion and needs urgent FNAC/biopsy referral. I can coordinate with Deenanath\'s oncology team if you want. She has an appointment on March 27 — can we ensure she is seen same day and given a clear referral letter? — Amit.',1,'2026-03-24 11:00:00',NULL),(19,'',4,5,'RE: Geeta Joshi BIRADS 4C — urgent discussion needed','Amit, yes please do coordinate. I will prepare the referral letter before March 27. She must not leave that appointment without a confirmed biopsy date. I will also call her today to emotionally prepare her for the conversation — BIRADS 4C will be very frightening news. Appreciate you flagging this. — Priya.',0,'2026-03-24 11:30:00',NULL),(20,'',12,15,'Walk-in patient complaint — waiting time April 7','Fatima, heads up — a patient today (Shobha Hegde, elderly with back pain) complained about a 40-minute wait after triage. She was INTAKE_IN_PROGRESS and Case 23 was in the queue but Dr. Rao was finishing Case 25 (emergency hip fracture). We did our best but she was in pain. She has filed written feedback. Just letting you know before it comes through formally. — Nandita.',0,'2026-04-07 11:00:00',NULL);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_accounts`
--

DROP TABLE IF EXISTS `patient_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_accounts` (
  `patient_account_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` int(10) unsigned NOT NULL,
  `username` varchar(60) DEFAULT NULL COMMENT 'Optional username; email is primary login',
  `email` varchar(190) DEFAULT NULL COMMENT 'Login email – must match patients.email if set',
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `created_by_user_id` int(10) unsigned DEFAULT NULL COMMENT 'Staff member who created this account',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`patient_account_id`),
  UNIQUE KEY `uq_pac_patient` (`patient_id`),
  UNIQUE KEY `uq_pac_username` (`username`),
  UNIQUE KEY `uq_pac_email` (`email`),
  KEY `fk_pac_created_by` (`created_by_user_id`),
  CONSTRAINT `fk_pac_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_pac_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_accounts`
--

LOCK TABLES `patient_accounts` WRITE;
/*!40000 ALTER TABLE `patient_accounts` DISABLE KEYS */;
INSERT INTO `patient_accounts` VALUES (1,1,'patient_priya','priya.patient@example.com','$2y$10$iEbnZFWXi/SriBcbT7FDEepvsVRu9NzL3VYOB5SwT8nHT7jMk930e',1,'2026-04-15 19:25:38',1,'2026-04-16 00:14:45','2026-04-15 19:25:38'),(2,2,'patient_rahul','rahul.patient@example.com','$2y$10$iEbnZFWXi/SriBcbT7FDEepvsVRu9NzL3VYOB5SwT8nHT7jMk930e',1,NULL,1,'2026-04-16 00:14:45','2026-04-15 19:20:39'),(3,3,'patient_ananya','ananya.patient@example.com','$2y$10$iEbnZFWXi/SriBcbT7FDEepvsVRu9NzL3VYOB5SwT8nHT7jMk930e',1,'2026-04-15 19:20:46',1,'2026-04-16 00:14:45','2026-04-15 19:20:46');
/*!40000 ALTER TABLE `patient_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_assets`
--

DROP TABLE IF EXISTS `patient_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_assets` (
  `patient_asset_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` bigint(20) unsigned NOT NULL,
  `patient_id` int(10) unsigned NOT NULL,
  `sent_by_user_id` int(10) unsigned DEFAULT NULL,
  `sent_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `note` text DEFAULT NULL COMMENT 'Optional note from staff to patient',
  PRIMARY KEY (`patient_asset_id`),
  UNIQUE KEY `uq_patient_asset` (`asset_id`,`patient_id`),
  KEY `idx_pa_patient` (`patient_id`),
  KEY `idx_pa_unread` (`patient_id`,`is_read`),
  KEY `fk_pa_sender` (`sent_by_user_id`),
  CONSTRAINT `fk_pa_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pa_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pa_sender` FOREIGN KEY (`sent_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Assets sent by staff to specific patients via the portal';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_assets`
--

LOCK TABLES `patient_assets` WRITE;
/*!40000 ALTER TABLE `patient_assets` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_daily_sequence`
--

DROP TABLE IF EXISTS `patient_daily_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_daily_sequence` (
  `seq_date` date NOT NULL,
  `last_n` int(10) unsigned NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`seq_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_daily_sequence`
--

LOCK TABLES `patient_daily_sequence` WRITE;
/*!40000 ALTER TABLE `patient_daily_sequence` DISABLE KEYS */;
INSERT INTO `patient_daily_sequence` VALUES ('2026-02-04',1,NULL),('2026-02-06',3,NULL),('2026-02-10',4,NULL),('2026-02-11',3,NULL),('2026-02-12',2,NULL),('2026-02-13',1,NULL),('2026-02-18',2,NULL),('2026-03-01',2,NULL),('2026-03-04',2,NULL),('2026-03-05',1,NULL),('2026-03-10',1,NULL),('2026-03-15',1,NULL),('2026-03-20',1,NULL),('2026-03-25',1,NULL),('2026-04-01',1,NULL),('2026-04-07',0,NULL);
/*!40000 ALTER TABLE `patient_daily_sequence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_feedback`
--

DROP TABLE IF EXISTS `patient_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_feedback` (
  `feedback_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` int(10) unsigned NOT NULL,
  `related_user_id` int(10) unsigned DEFAULT NULL,
  `feedback_type` enum('POSITIVE','COMPLAINT','SUGGESTION') NOT NULL,
  `rating` tinyint(3) unsigned DEFAULT NULL,
  `feedback_text` text DEFAULT NULL,
  `status` enum('NEW','REVIEWED','ACTIONED','CLOSED') NOT NULL DEFAULT 'NEW',
  `admin_notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use (distinct from admin_notes)',
  PRIMARY KEY (`feedback_id`),
  KEY `idx_feedback_patient` (`patient_id`,`created_at`),
  KEY `idx_feedback_status` (`status`),
  KEY `idx_feedback_type` (`feedback_type`),
  KEY `idx_feedback_related_user` (`related_user_id`),
  CONSTRAINT `fk_feedback_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_feedback`
--

LOCK TABLES `patient_feedback` WRITE;
/*!40000 ALTER TABLE `patient_feedback` DISABLE KEYS */;
INSERT INTO `patient_feedback` VALUES (1,5,4,'POSITIVE',5,'Dr. Desai was very patient and explained my condition clearly. She took time to answer all my questions about blood pressure. The camp was well organized.','REVIEWED','Shared with Dr. Desai. Good feedback.','2026-02-10 16:00:00','2026-02-13 21:40:32',NULL),(2,6,NULL,'SUGGESTION',NULL,'The waiting time at the camp was very long — almost 2 hours. It would be nice if there was a token system so we know our turn. Also, more chairs would help for elderly patients.','ACTIONED','Will implement token system for next camp. Added to logistics checklist.','2026-02-10 16:30:00','2026-02-13 21:40:32',NULL),(3,7,5,'POSITIVE',4,'Good consultation. Dr. Patel was helpful. Only suggestion is that it would be nice to get a printed summary of the advice given during the visit.','REVIEWED',NULL,'2026-02-10 17:00:00','2026-02-13 21:40:32',NULL),(4,9,8,'POSITIVE',5,'Meena at the registration desk was very helpful and efficient. Got my paperwork done quickly and she was very friendly. Thank you!','NEW',NULL,'2026-02-11 12:00:00','2026-02-13 21:40:32',NULL),(5,12,NULL,'COMPLAINT',2,'I came with severe stomach pain and had to wait 20 minutes before anyone attended to me. For emergency cases there should be immediate attention. The treatment itself was good once the doctor saw me.','REVIEWED','Discussed with team. Implementing triage protocol for emergency walk-ins to ensure immediate assessment.','2026-02-12 14:00:00','2026-02-13 21:40:32',NULL),(6,13,4,'POSITIVE',4,'Dr. Desai was thorough in her examination and ordered all the right tests. I appreciated that she explained why each test was needed. Clinic was clean and comfortable.','NEW',NULL,'2026-02-12 11:00:00','2026-02-13 21:40:32',NULL),(7,14,NULL,'SUGGESTION',NULL,'It would be great if the clinic could offer online appointment booking instead of walk-in only. Hard to take time off work without knowing the wait time.','NEW',NULL,'2026-02-13 09:00:00','2026-02-13 21:40:32',NULL),(8,8,6,'POSITIVE',5,'Nurse Sneha was very caring when checking my vitals and explaining how to use the glucose monitor. She made me feel comfortable despite my fear of needles.','NEW',NULL,'2026-02-11 11:00:00','2026-02-13 21:40:32',NULL),(9,15,4,'POSITIVE',5,'Dr. Desai listened to all my concerns patiently and explained everything about my blood pressure and menopause. I felt very well cared for. The nurse (Nandita) was also very professional.','NEW',NULL,'2026-03-02 11:00:00','2026-04-08 23:44:35',NULL),(10,17,17,'POSITIVE',4,'Dr. Kiran Rao was thorough with my thyroid follow-up and explained why the dose needed to change. Only suggestion is that the waiting area could use better signage so patients know where to go.','REVIEWED','Good feedback for new doctor. Signage improvement noted — will discuss with admin.','2026-03-03 10:00:00','2026-04-08 23:44:35',NULL),(11,18,NULL,'COMPLAINT',1,'I came with a serious wound on my foot and was seen at a camp. The camp did not have proper wound care supplies — only basic bandages. For a diabetic foot camp there should be proper dressing materials available. I had to be told to go to hospital anyway. Why hold a diabetic foot camp without proper supplies?','','Legitimate complaint — coordinating with camp logistics team to review supply checklist for diabetic foot camps.','2026-03-16 14:00:00','2026-04-08 23:44:35',NULL),(12,19,4,'POSITIVE',5,'Very quick and helpful visit. Dr. Desai was kind and the treatment worked well. My infection cleared up in 4 days. Thank you!','NEW',NULL,'2026-03-20 09:30:00','2026-04-08 23:44:35',NULL),(13,22,17,'POSITIVE',5,'I came in struggling to breathe and the team acted quickly. Dr. Rao and the triage nurse were calm and efficient. After the nebulisation I felt much better. Grateful for the fast response.','NEW',NULL,'2026-03-26 08:00:00','2026-04-08 23:44:35',NULL),(14,26,NULL,'SUGGESTION',NULL,'It would be very helpful if patients could get a text message confirmation after an appointment is booked. I was not sure if my follow-up was confirmed and called the clinic twice to check.','NEW',NULL,'2026-03-26 10:00:00','2026-04-08 23:44:35',NULL),(15,16,NULL,'POSITIVE',4,'Good service. My ankle sprain was managed well. Clear instructions were given about what to do at home. Recovered quickly following the advice.','REVIEWED',NULL,'2026-03-08 12:00:00','2026-04-08 23:44:35',NULL),(16,21,4,'POSITIVE',5,'Dr. Desai handled a very sensitive situation (breast lump) with great care and professionalism. She explained every step clearly and did not cause unnecessary alarm while still being appropriately serious about it. I felt safe and informed.','ACTIONED','Shared with Dr. Desai. Outstanding patient communication noted.','2026-03-22 10:00:00','2026-04-08 23:44:35',NULL),(17,23,NULL,'COMPLAINT',2,'I was in a lot of pain with my back and had to wait almost 40 minutes after triage before anyone saw me. The waiting area chairs are very uncomfortable for someone with back pain. Could there be cots or reclining chairs available for patients with pain?','NEW',NULL,'2026-04-08 10:00:00','2026-04-08 23:44:35',NULL),(18,25,NULL,'SUGGESTION',NULL,'For elderly patients visiting for follow-ups, it would help to have someone assist them from the entrance to the registration desk. My mother has difficulty walking and there was no one to help her navigate the clinic.','NEW',NULL,'2026-04-02 09:30:00','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `patient_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_record_access_log`
--

DROP TABLE IF EXISTS `patient_record_access_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patient_record_access_log` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` int(10) unsigned NOT NULL,
  `accessed_by_user_id` int(10) unsigned NOT NULL,
  `access_type` enum('VIEW_PROFILE','VIEW_CASE_SHEET') NOT NULL DEFAULT 'VIEW_PROFILE',
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `accessed_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `idx_access_log_patient` (`patient_id`,`accessed_at`),
  KEY `idx_access_log_user` (`accessed_by_user_id`,`accessed_at`),
  CONSTRAINT `fk_access_log_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_access_log_user` FOREIGN KEY (`accessed_by_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_record_access_log`
--

LOCK TABLES `patient_record_access_log` WRITE;
/*!40000 ALTER TABLE `patient_record_access_log` DISABLE KEYS */;
INSERT INTO `patient_record_access_log` VALUES (1,15,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:09:10'),(2,16,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:13:47'),(3,3,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:13:52'),(4,2,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:14:13'),(5,3,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:14:14'),(6,4,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:14:17'),(7,16,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:14:21'),(8,16,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 15:47:04'),(9,14,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-02-26 18:08:12'),(10,15,12,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15','2026-03-02 19:48:34'),(11,18,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-03-25 19:29:50'),(12,8,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-03-25 19:29:53'),(13,4,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-03-25 19:29:55'),(14,18,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-03-25 19:34:11'),(15,18,13,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-03-25 19:34:13'),(16,17,12,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-04-01 19:38:33'),(17,17,1,'VIEW_PROFILE','::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Safari/605.1.15','2026-04-11 17:10:11');
/*!40000 ALTER TABLE `patient_record_access_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patients` (
  `patient_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `patient_code` char(11) NOT NULL,
  `first_seen_date` date NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) DEFAULT NULL,
  `sex` enum('MALE','FEMALE','OTHER','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
  `date_of_birth` date DEFAULT NULL,
  `age_years` smallint(5) unsigned DEFAULT NULL,
  `phone_e164` varchar(20) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `address_line1` varchar(120) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `state_province` varchar(80) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `blood_group` varchar(5) DEFAULT NULL,
  `allergies` varchar(255) DEFAULT NULL,
  `emergency_contact_name` varchar(120) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `username` varchar(60) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `uq_patients_patient_code` (`patient_code`),
  UNIQUE KEY `uq_patients_username` (`username`),
  UNIQUE KEY `uq_patients_email` (`email`),
  KEY `idx_patients_name` (`last_name`,`first_name`),
  KEY `idx_patients_phone` (`phone_e164`),
  KEY `idx_patients_first_seen` (`first_seen_date`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'20260204001','2026-02-04','Rahul','Sharma','MALE',NULL,NULL,'+919876543210',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-04 20:07:09','2026-02-18 12:15:03',NULL),(2,'20260206001','2026-02-06','Test','Patient1','MALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-06 19:26:14','2026-02-18 12:15:03',NULL),(3,'20260206002','2026-02-06','Test','Patient2','MALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-06 19:26:14','2026-02-18 12:15:03',NULL),(4,'20260206003','2026-02-06','Test','Patient3','MALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-06 19:26:14','2026-02-18 12:15:03',NULL),(5,'20260210001','2026-02-10','Sunita','Devi','FEMALE','1985-03-15',40,'+919900100001','sunita.d@email.com','42 MG Road','Pune','Maharashtra','411001','B+',NULL,'Rajesh Devi','+919900100099',NULL,NULL,NULL,1,'2026-02-10 09:15:00','2026-02-18 12:15:03',NULL),(6,'20260210002','2026-02-10','Arun','Kumar','MALE','1972-08-22',53,'+919900100002',NULL,'15 Station Road','Pune','Maharashtra','411002','O+','Penicillin','Lakshmi Kumar','+919900100098',NULL,NULL,NULL,1,'2026-02-10 09:30:00','2026-02-18 12:15:03',NULL),(7,'20260210003','2026-02-10','Lakshmi','Iyer','FEMALE','1990-11-05',35,'+919900100003','lakshmi.i@email.com','8 Temple Street','Pune','Maharashtra','411003','A+',NULL,'Venkat Iyer','+919900100097',NULL,NULL,NULL,1,'2026-02-10 10:00:00','2026-02-18 12:15:03',NULL),(8,'20260210004','2026-02-10','Mohammed','Ansari','MALE','1968-01-30',58,'+919900100004',NULL,'22 Park Avenue','Pune','Maharashtra','411004','AB+','Sulfa drugs','Fatima Ansari','+919900100096',NULL,NULL,NULL,1,'2026-02-10 10:30:00','2026-02-18 12:15:03',NULL),(9,'20260211001','2026-02-11','Kavita','Reddy','FEMALE','1995-06-18',30,'+919900100005','kavita.r@email.com','5 Jubilee Hills','Hyderabad','Telangana','500033','O-',NULL,'Suresh Reddy','+919900100095',NULL,NULL,NULL,1,'2026-02-11 09:00:00','2026-02-18 12:15:03',NULL),(10,'20260211002','2026-02-11','Rajesh','Verma','MALE','1980-12-01',45,'+919900100006',NULL,'71 Civil Lines','Nagpur','Maharashtra','440001','B-','Aspirin','Suman Verma','+919900100094',NULL,NULL,NULL,1,'2026-02-11 09:45:00','2026-02-18 12:15:03',NULL),(11,'20260211003','2026-02-11','Anjali','Nair','FEMALE','2000-04-10',25,'+919900100007','anjali.n@email.com','33 Beach Road','Kochi','Kerala','682001','A-',NULL,'Vijay Nair','+919900100093',NULL,NULL,NULL,1,'2026-02-11 10:30:00','2026-02-18 12:15:03',NULL),(12,'20260212001','2026-02-12','Suresh','Yadav','MALE','1955-09-25',70,'+919900100008',NULL,'18 Gandhi Nagar','Pune','Maharashtra','411005','O+','Ibuprofen, Codeine','Kamla Yadav','+919900100092',NULL,NULL,NULL,1,'2026-02-12 08:30:00','2026-02-18 12:15:03',NULL),(13,'20260212002','2026-02-12','Pooja','Bhatt','FEMALE','1988-07-14',37,'+919900100009','pooja.b@email.com','9 Lakeview Colony','Pune','Maharashtra','411006','AB-',NULL,'Dinesh Bhatt','+919900100091',NULL,NULL,NULL,1,'2026-02-12 09:15:00','2026-02-18 12:15:03',NULL),(14,'20260213001','2026-02-13','Ramesh','Chauhan','MALE','1975-02-28',51,'+919900100010',NULL,'55 Industrial Area','Pune','Maharashtra','411007','A+',NULL,'Geeta Chauhan','+919900100090',NULL,NULL,NULL,1,'2026-02-13 08:00:00','2026-02-18 12:15:03',NULL),(15,'20260218001','2026-02-18','Test','Patient','MALE','2020-01-07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-18 12:11:22','2026-02-18 12:15:03',NULL),(16,'20260218002','2026-02-18','Test','Patient04','FEMALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-18 16:44:12','2026-02-18 16:44:12',NULL),(17,'20260304001','2026-03-04','New','Patient01','UNKNOWN','2000-02-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-03-04 17:20:30','2026-03-04 17:20:30',NULL),(18,'20260304002','2026-03-04','New','Patient01','UNKNOWN','2000-03-04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-03-04 17:27:39','2026-03-04 17:27:39',NULL),(19,'20260325001','2026-03-25','New','Patient03','UNKNOWN','2012-01-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-03-25 19:17:11','2026-03-25 19:17:11',NULL),(20,'20260310001','2026-03-10','Mahesh','Kulkarni','MALE','1983-06-30',42,'+919900200006',NULL,'89 Deccan Gymkhana','Pune','Maharashtra','411004','A-',NULL,'Suneeta Kulkarni','+919900299006',NULL,NULL,NULL,1,'2026-03-10 09:00:00','2026-04-08 23:44:35',NULL),(21,'20260310002','2026-03-10','Savita','Patil','FEMALE','1998-11-08',27,'+919900200007','savita.p@email.com','12 Baner Road','Pune','Maharashtra','411045','B-',NULL,'Santosh Patil','+919900299007',NULL,NULL,NULL,1,'2026-03-10 10:00:00','2026-04-08 23:44:35',NULL),(22,'20260315001','2026-03-15','Balaji','Venkatesh','MALE','1960-03-22',65,'+919900200008',NULL,'77 Anna Nagar','Hyderabad','Telangana','500082','O+','Sulfonamides','Radha Venkatesh','+919900299008',NULL,NULL,NULL,1,'2026-03-15 08:45:00','2026-04-08 23:44:35',NULL),(23,'20260315002','2026-03-15','Preethi','Raj','FEMALE','2002-08-15',23,'+919900200009','preethi.r@email.com','31 Jayanagar','Bengaluru','Karnataka','560011','A+',NULL,'Mohan Raj','+919900299009',NULL,NULL,NULL,1,'2026-03-15 09:30:00','2026-04-08 23:44:35',NULL),(24,'20260320001','2026-03-20','Vikrant','Deshmukh','MALE','1975-01-10',51,'+919900200010',NULL,'4 Shivaji Nagar','Nashik','Maharashtra','422002','B+',NULL,'Kavita Deshmukh','+919900299010',NULL,NULL,NULL,1,'2026-03-20 09:00:00','2026-04-08 23:44:35',NULL),(25,'20260320002','2026-03-20','Geeta','Joshi','FEMALE','1970-05-05',55,'+919900200011','geeta.j@email.com','19 Camp Road','Pune','Maharashtra','411001','AB-','Morphine','Desh Joshi','+919900299011',NULL,NULL,NULL,1,'2026-03-20 10:15:00','2026-04-08 23:44:35',NULL),(26,'20260325002','2026-03-25','Aditya','Khanna','MALE','2005-03-01',21,'+919900200012','aditya.k@email.com','66 Sector 12','Noida','Uttar Pradesh','201301','O+',NULL,'Sunita Khanna','+919900299012',NULL,NULL,NULL,1,'2026-03-25 09:00:00','2026-04-08 23:44:35',NULL),(27,'20260325003','2026-03-25','Shobha','Hegde','FEMALE','1955-10-18',70,'+919900200013',NULL,'2 Mangalore Road','Mangaluru','Karnataka','575001','A+','Latex','Prasad Hegde','+919900299013',NULL,NULL,NULL,1,'2026-03-25 10:30:00','2026-04-08 23:44:35',NULL),(28,'20260401001','2026-04-01','Naresh','Sharma','MALE','1988-07-07',37,'+919900200014','naresh.s@email.com','10 Ring Road','Pune','Maharashtra','411006','O+',NULL,'Anita Sharma','+919900299014',NULL,NULL,NULL,1,'2026-04-01 08:30:00','2026-04-08 23:44:35',NULL),(29,'20260401002','2026-04-01','Rekha','Pillai','FEMALE','1963-12-30',62,'+919900200015',NULL,'45 Pettah','Thiruvananthapuram','Kerala','695024','B+','Codeine','Suresh Pillai','+919900299015',NULL,NULL,NULL,1,'2026-04-01 09:15:00','2026-04-08 23:44:35',NULL),(30,'20260407001','2026-04-07','Santosh','Pawar','MALE','1945-04-15',80,'+919900200016',NULL,'1 Kasba Peth','Pune','Maharashtra','411011','A+','Ibuprofen','Lata Pawar','+919900299016',NULL,NULL,NULL,1,'2026-04-07 09:00:00','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trg_patients_before_insert
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
  DECLARE v_date DATE;
  DECLARE v_n    INT UNSIGNED;

  SET v_date = IFNULL(NEW.first_seen_date, CURDATE());
  SET NEW.first_seen_date = v_date;

  
  
  INSERT INTO patient_daily_sequence (seq_date, last_n)
  VALUES (v_date, LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE last_n = LAST_INSERT_ID(last_n + 1);

  SET v_n = LAST_INSERT_ID();

  SET NEW.patient_code = CONCAT(DATE_FORMAT(v_date, '%Y%m%d'), LPAD(v_n, 3, '0'));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `permission_change_log`
--

DROP TABLE IF EXISTS `permission_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission_change_log` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `changed_by` int(10) unsigned NOT NULL,
  `role` varchar(30) NOT NULL,
  `resource` varchar(30) NOT NULL,
  `old_perm` enum('R','RW','N') NOT NULL,
  `new_perm` enum('R','RW','N') NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `idx_permlog_changed_at` (`changed_at`),
  KEY `idx_permlog_changed_by` (`changed_by`),
  CONSTRAINT `fk_permlog_user` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_change_log`
--

LOCK TABLES `permission_change_log` WRITE;
/*!40000 ALTER TABLE `permission_change_log` DISABLE KEYS */;
INSERT INTO `permission_change_log` VALUES (1,1,'DOCTOR','appointments','N','RW','::1','2026-03-02 13:37:50'),(2,1,'TRIAGE_NURSE','appointments','N','RW','::1','2026-03-02 13:37:50'),(3,1,'NURSE','appointments','N','RW','::1','2026-03-02 13:37:50'),(4,1,'PARAMEDIC','appointments','N','RW','::1','2026-03-02 13:37:50');
/*!40000 ALTER TABLE `permission_change_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portal_feedback`
--

DROP TABLE IF EXISTS `portal_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portal_feedback` (
  `portal_feedback_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_account_id` bigint(20) unsigned NOT NULL,
  `feedback_type` enum('GRIEVANCE','COMPLAINT','POSITIVE','SUGGESTION') NOT NULL DEFAULT 'SUGGESTION',
  `subject` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `related_user_id` int(10) unsigned DEFAULT NULL COMMENT 'Staff member this feedback is about',
  `rating` tinyint(3) unsigned DEFAULT NULL COMMENT '1–5 optional star rating',
  `status` enum('NEW','REVIEWED','ACTIONED','CLOSED') NOT NULL DEFAULT 'NEW',
  `staff_notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`portal_feedback_id`),
  KEY `idx_pf_patient` (`patient_account_id`,`created_at`),
  KEY `idx_pf_status` (`status`),
  KEY `fk_pf_user` (`related_user_id`),
  CONSTRAINT `fk_pf_pac` FOREIGN KEY (`patient_account_id`) REFERENCES `patient_accounts` (`patient_account_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pf_user` FOREIGN KEY (`related_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_feedback`
--

LOCK TABLES `portal_feedback` WRITE;
/*!40000 ALTER TABLE `portal_feedback` DISABLE KEYS */;
INSERT INTO `portal_feedback` VALUES (1,1,'POSITIVE','Excellent care at the March camp','The nurses were very kind and patient. The doctor explained everything clearly. I felt well looked after. Thank you to the whole team.',NULL,5,'NEW',NULL,'2026-04-16 00:14:45','2026-04-16 00:14:45'),(2,2,'SUGGESTION','Longer clinic hours would help working patients','It is difficult to attend morning-only clinics when working. An evening slot or Saturday clinic would be very helpful for patients who cannot take time off work.',NULL,NULL,'NEW',NULL,'2026-04-16 00:14:45','2026-04-16 00:14:45');
/*!40000 ALTER TABLE `portal_feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portal_message_threads`
--

DROP TABLE IF EXISTS `portal_message_threads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portal_message_threads` (
  `thread_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_account_id` bigint(20) unsigned NOT NULL,
  `subject` varchar(200) NOT NULL,
  `last_message_at` datetime NOT NULL DEFAULT current_timestamp(),
  `patient_unread` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = patient has unread staff reply',
  `staff_unread` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = staff has unread patient message',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`thread_id`),
  KEY `idx_pmt_patient` (`patient_account_id`,`last_message_at`),
  KEY `idx_pmt_staff_unread` (`staff_unread`),
  CONSTRAINT `fk_pmt_pac` FOREIGN KEY (`patient_account_id`) REFERENCES `patient_accounts` (`patient_account_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_message_threads`
--

LOCK TABLES `portal_message_threads` WRITE;
/*!40000 ALTER TABLE `portal_message_threads` DISABLE KEYS */;
INSERT INTO `portal_message_threads` VALUES (1,1,'Question about my follow-up appointment','2026-04-07 10:30:00',0,1,'2026-04-16 00:14:45'),(2,2,'Side effects from my prescription','2026-04-06 15:00:00',1,0,'2026-04-16 00:14:45');
/*!40000 ALTER TABLE `portal_message_threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portal_messages`
--

DROP TABLE IF EXISTS `portal_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portal_messages` (
  `portal_message_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `thread_id` bigint(20) unsigned NOT NULL,
  `sender_type` enum('PATIENT','STAFF') NOT NULL,
  `sender_user_id` int(10) unsigned DEFAULT NULL COMMENT 'Populated when sender_type = STAFF',
  `body` text NOT NULL,
  `sent_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`portal_message_id`),
  KEY `idx_pm_thread` (`thread_id`,`sent_at`),
  KEY `fk_pm_user` (`sender_user_id`),
  CONSTRAINT `fk_pm_thread` FOREIGN KEY (`thread_id`) REFERENCES `portal_message_threads` (`thread_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pm_user` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_messages`
--

LOCK TABLES `portal_messages` WRITE;
/*!40000 ALTER TABLE `portal_messages` DISABLE KEYS */;
INSERT INTO `portal_messages` VALUES (1,1,'PATIENT',NULL,'Hello, I was told to come in for a follow-up next month but I cannot find the exact date in my discharge paperwork. Could you please confirm my appointment date and time? Thank you.','2026-04-07 10:30:00'),(2,2,'PATIENT',NULL,'I started the new medication three days ago and I am experiencing mild nausea and dizziness. Is this normal? Should I continue taking it or stop and come in?','2026-04-06 14:45:00'),(3,2,'STAFF',NULL,'Thank you for letting us know. Mild nausea and dizziness can be common in the first few days. Please continue taking the medication with food. If symptoms worsen or you experience chest pain or difficulty breathing, come in immediately or call us. We will follow up with you in a few days.','2026-04-06 15:00:00');
/*!40000 ALTER TABLE `portal_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_permissions` (
  `role` varchar(30) NOT NULL,
  `resource` varchar(30) NOT NULL,
  `permission` enum('R','RW','N') NOT NULL DEFAULT 'N',
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`role`,`resource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES ('ADMIN','analytics','R',NULL),('ADMIN','appointments','RW',NULL),('ADMIN','assets','RW',NULL),('ADMIN','case_sheets','RW',NULL),('ADMIN','events','RW',NULL),('ADMIN','feedback','RW',NULL),('ADMIN','labwork','RW',NULL),('ADMIN','messages','RW',NULL),('ADMIN','patient_data','RW',NULL),('ADMIN','tasks','RW',NULL),('ADMIN','users','RW',NULL),('DATA_ENTRY_OPERATOR','analytics','N',NULL),('DATA_ENTRY_OPERATOR','appointments','N',NULL),('DATA_ENTRY_OPERATOR','assets','R',NULL),('DATA_ENTRY_OPERATOR','case_sheets','RW',NULL),('DATA_ENTRY_OPERATOR','events','R',NULL),('DATA_ENTRY_OPERATOR','feedback','N',NULL),('DATA_ENTRY_OPERATOR','labwork','N',NULL),('DATA_ENTRY_OPERATOR','messages','RW',NULL),('DATA_ENTRY_OPERATOR','patient_data','RW',NULL),('DATA_ENTRY_OPERATOR','tasks','RW',NULL),('DATA_ENTRY_OPERATOR','users','N',NULL),('DOCTOR','analytics','R',NULL),('DOCTOR','appointments','R',NULL),('DOCTOR','assets','R',NULL),('DOCTOR','case_sheets','RW',NULL),('DOCTOR','events','R',NULL),('DOCTOR','feedback','R',NULL),('DOCTOR','labwork','RW',NULL),('DOCTOR','messages','RW',NULL),('DOCTOR','patient_data','RW',NULL),('DOCTOR','tasks','RW',NULL),('DOCTOR','users','N',NULL),('EDUCATION_TEAM','analytics','N',NULL),('EDUCATION_TEAM','appointments','N',NULL),('EDUCATION_TEAM','assets','RW',NULL),('EDUCATION_TEAM','case_sheets','N',NULL),('EDUCATION_TEAM','events','RW',NULL),('EDUCATION_TEAM','feedback','R',NULL),('EDUCATION_TEAM','labwork','N',NULL),('EDUCATION_TEAM','messages','RW',NULL),('EDUCATION_TEAM','patient_data','N',NULL),('EDUCATION_TEAM','tasks','RW',NULL),('EDUCATION_TEAM','users','N',NULL),('GRIEVANCE_OFFICER','analytics','N',NULL),('GRIEVANCE_OFFICER','appointments','N',NULL),('GRIEVANCE_OFFICER','assets','N',NULL),('GRIEVANCE_OFFICER','case_sheets','R',NULL),('GRIEVANCE_OFFICER','events','N',NULL),('GRIEVANCE_OFFICER','feedback','RW',NULL),('GRIEVANCE_OFFICER','labwork','N',NULL),('GRIEVANCE_OFFICER','messages','RW',NULL),('GRIEVANCE_OFFICER','patient_data','R',NULL),('GRIEVANCE_OFFICER','tasks','RW',NULL),('GRIEVANCE_OFFICER','users','N',NULL),('NURSE','analytics','N',NULL),('NURSE','appointments','RW',NULL),('NURSE','assets','R',NULL),('NURSE','case_sheets','RW',NULL),('NURSE','events','R',NULL),('NURSE','feedback','R',NULL),('NURSE','labwork','RW',NULL),('NURSE','messages','RW',NULL),('NURSE','patient_data','RW',NULL),('NURSE','tasks','RW',NULL),('NURSE','users','N',NULL),('PARAMEDIC','analytics','N',NULL),('PARAMEDIC','appointments','R',NULL),('PARAMEDIC','assets','R',NULL),('PARAMEDIC','case_sheets','RW',NULL),('PARAMEDIC','events','R',NULL),('PARAMEDIC','feedback','R',NULL),('PARAMEDIC','labwork','R',NULL),('PARAMEDIC','messages','RW',NULL),('PARAMEDIC','patient_data','RW',NULL),('PARAMEDIC','tasks','RW',NULL),('PARAMEDIC','users','N',NULL),('SUPER_ADMIN','analytics','R',NULL),('SUPER_ADMIN','appointments','RW',NULL),('SUPER_ADMIN','assets','RW',NULL),('SUPER_ADMIN','case_sheets','RW',NULL),('SUPER_ADMIN','events','RW',NULL),('SUPER_ADMIN','feedback','RW',NULL),('SUPER_ADMIN','labwork','RW',NULL),('SUPER_ADMIN','messages','RW',NULL),('SUPER_ADMIN','patient_data','RW',NULL),('SUPER_ADMIN','tasks','RW',NULL),('SUPER_ADMIN','users','RW',NULL),('TRIAGE_NURSE','analytics','N',NULL),('TRIAGE_NURSE','appointments','RW',NULL),('TRIAGE_NURSE','assets','R',NULL),('TRIAGE_NURSE','case_sheets','RW',NULL),('TRIAGE_NURSE','events','R',NULL),('TRIAGE_NURSE','feedback','R',NULL),('TRIAGE_NURSE','labwork','RW',NULL),('TRIAGE_NURSE','messages','RW',NULL),('TRIAGE_NURSE','patient_data','RW',NULL),('TRIAGE_NURSE','tasks','RW',NULL),('TRIAGE_NURSE','users','N',NULL);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `task_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('PENDING','IN_PROGRESS','DONE') NOT NULL DEFAULT 'PENDING',
  `priority` enum('LOW','MEDIUM','HIGH') NOT NULL DEFAULT 'MEDIUM',
  `assigned_to_user_id` int(10) unsigned DEFAULT NULL,
  `created_by_user_id` int(10) unsigned NOT NULL,
  `due_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`task_id`),
  KEY `fk_tasks_assigned_to` (`assigned_to_user_id`),
  KEY `fk_tasks_created_by` (`created_by_user_id`),
  CONSTRAINT `fk_tasks_assigned_to` FOREIGN KEY (`assigned_to_user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_tasks_created_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (1,'Test task 01','This is the first test of tasks.','DONE','MEDIUM',3,1,'2026-02-27','2026-02-25 18:55:29','2026-02-25 18:56:03',NULL),(4,'Review Pooja Bhatt lab results','Patient Pooja Bhatt (ID 13, Case #9) — CBC, TSH, Free T4, iron studies ordered Feb 12. Results expected by Feb 16. Call patient to discuss findings.','PENDING','HIGH',4,4,'2026-02-17','2026-02-12 10:05:00','2026-04-08 23:44:26',NULL),(5,'Update Mohammed Ansari case notes','Add post-camp counselling notes to Case #4. Record blood sugar diary review outcomes from the Feb 17 follow-up visit.','DONE','MEDIUM',5,5,'2026-02-18','2026-02-13 14:30:00','2026-04-08 23:44:26',NULL),(7,'Check BP cuff calibration','Both BP cuffs (exam room 1 and camp kit) need calibration check. Log result in equipment register.','DONE','HIGH',6,7,'2026-02-14','2026-02-13 08:00:00','2026-04-08 23:44:26',NULL),(8,'Follow up on Kavita Reddy throat swab culture','Lab result expected Feb 16. If positive for Group A Strep, notify Dr. Desai immediately for antibiotic review.','IN_PROGRESS','HIGH',6,6,'2026-02-16','2026-02-14 10:35:00','2026-04-08 23:44:26',NULL),(12,'Refer Geeta Joshi to surgical oncology — FNAC','Patient with BIRADS 4C mammogram (Case #21). Coordinate referral to Deenanath Hospital Oncology. Prepare referral letter with imaging reports attached. Confirm appointment date before patient visit on March 27.','DONE','HIGH',4,5,'2026-03-27','2026-03-24 11:00:00','2026-04-08 23:44:35',NULL),(13,'Schedule TSH recheck — Deepa Menon','Patient increased to Levothyroxine 75mcg on March 1. TSH recheck due week of April 12. Call patient to confirm she will come fasting. Ensure lab order is in the system.','PENDING','MEDIUM',17,17,'2026-04-12','2026-03-01 10:40:00','2026-04-08 23:44:35',NULL),(17,'Follow up Santosh Pawar X-ray result','Elderly patient (Case #25) presented with suspected neck of femur fracture on April 7. X-ray ordered. Follow up result same day. If fracture confirmed, prepare urgent referral to Sassoon General Orthopaedics.','IN_PROGRESS','HIGH',5,5,'2026-04-07','2026-04-07 09:25:00','2026-04-08 23:44:35',NULL),(18,'Mahesh Kulkarni — follow up treadmill stress test booking','Patient needs treadmill stress test at Deenanath Hospital (Case #16). ECG normal but clinical suspicion remains. Confirm booking was made at the March 17 visit. Call patient by April 10 if no confirmation received.','PENDING','MEDIUM',5,5,'2026-04-10','2026-03-17 10:00:00','2026-04-08 23:44:35',NULL),(20,'Organise Labwork module refresher for nursing staff','Following Feedback #8, schedule a 30-minute hands-on refresher. Cover: how to mark an order COMPLETED, viewing the pending queue, understanding who is responsible for entering result notes. Confirm with Dr. Patel on clinical responsibilities.','DONE','MEDIUM',1,1,'2026-03-20','2026-03-12 09:30:00','2026-04-08 23:44:35',NULL),(22,'Grievance officer onboarding — system access and workflow','Fatima Siddiqui is new to the system. Walk her through: viewing feedback submissions, updating status, adding admin notes, and messaging relevant staff. Ensure she has reviewed the GRIEVANCE_OFFICER permissions. Schedule 1-hour session.','DONE','LOW',15,1,'2026-02-25','2026-02-20 10:00:00','2026-04-08 23:44:35',NULL),(23,'Test task 01','This is the first [test] task for this account.','PENDING','LOW',1,12,NULL,'2026-04-15 18:26:32','2026-04-15 18:26:32',NULL);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preferences`
--

DROP TABLE IF EXISTS `user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_preferences` (
  `pref_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `account_type` enum('STAFF','PATIENT') NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `theme` enum('light','dark','system') NOT NULL DEFAULT 'system',
  `language` enum('en','te') NOT NULL DEFAULT 'en',
  `font_size` enum('normal','large') NOT NULL DEFAULT 'normal',
  `date_format` enum('DD/MM/YYYY','MM/DD/YYYY') NOT NULL DEFAULT 'DD/MM/YYYY',
  `session_timeout_minutes` smallint(5) unsigned NOT NULL DEFAULT 30,
  `email_notifications` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`pref_id`),
  UNIQUE KEY `uq_prefs_account` (`account_type`,`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preferences`
--

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;
INSERT INTO `user_preferences` VALUES (1,'STAFF',1,'light','en','normal','DD/MM/YYYY',30,1,'2026-02-17 13:41:02','2026-02-17 13:41:44',NULL),(2,'STAFF',4,'light','en','large','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(3,'STAFF',5,'system','en','normal','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(4,'STAFF',6,'light','te','normal','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(5,'STAFF',13,'light','en','normal','DD/MM/YYYY',30,1,'2026-03-18 19:16:01','2026-03-25 19:05:54',NULL),(6,'STAFF',8,'system','te','normal','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(7,'STAFF',10,'dark','en','normal','DD/MM/YYYY',60,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(8,'STAFF',12,'light','en','normal','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-09 11:13:55',NULL),(9,'STAFF',14,'system','en','normal','DD/MM/YYYY',30,0,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(10,'STAFF',15,'light','en','large','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(11,'STAFF',16,'dark','en','normal','DD/MM/YYYY',45,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL),(12,'STAFF',17,'system','en','normal','DD/MM/YYYY',30,1,'2026-04-08 23:44:35','2026-04-08 23:44:35',NULL);
/*!40000 ALTER TABLE `user_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `email` varchar(190) NOT NULL,
  `phone_e164` varchar(20) DEFAULT NULL,
  `username` varchar(60) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('SUPER_ADMIN','ADMIN','DOCTOR','TRIAGE_NURSE','NURSE','PARAMEDIC','GRIEVANCE_OFFICER','EDUCATION_TEAM','DATA_ENTRY_OPERATOR') NOT NULL DEFAULT 'DATA_ENTRY_OPERATOR',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL COMMENT 'Free-form notes for stakeholder use',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_email` (`email`),
  UNIQUE KEY `uq_users_username` (`username`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Andrew','Hawkinson','hawk@d3s3.com',NULL,'Hawkinson','$2y$10$lO.z3dxebDVH.eVN9UATbO4WmZXs9gOw8X23BGpEKffE1aSaAmXF.','SUPER_ADMIN',1,'2026-04-15 19:38:02','2026-02-04 14:41:37','2026-04-15 19:38:02',NULL),(2,'Admin','Account','admin1@d3s3.com',NULL,'admin1','$2y$10$wH/SJPGCqIxx1wmYUrPzCe7i6JOgeFBk.6a.xrQ4Nl.MuEEUxoASG','ADMIN',0,NULL,'2026-02-04 14:49:41','2026-02-06 18:32:55',NULL),(3,'Gary','Marks','g.marks@d3s3.com',NULL,'gmarks','$2y$10$TQWPTXgCxG5.pdKBpLS0uuO.F.5KAdLEeZRqP0DZsUxp3WqvWQY/2','SUPER_ADMIN',1,'2026-03-04 10:42:19','2026-02-04 18:26:01','2026-03-04 10:42:19',NULL),(4,'Siva','Jasthi','Siva.Jasthi@gmail.com',NULL,'sjasthi','$2y$10$r/VWDUgjPJhbIV93jAV/COGSMognETMDHeDnBP68xKI2W/OjBhIre','SUPER_ADMIN',1,'2026-03-04 17:44:01','2026-02-17 13:49:36','2026-03-04 17:44:01',NULL),(5,'MANVITH KUMAR REDDY','DEVARAPALLI','manvithdevarapalli@gmail.com',NULL,'manvith26','$2y$10$TfiRJQDkX.7qM4Q04Pu1teDJK1ppaCXC/8M9.bjBltQW.Bo09AJYe','SUPER_ADMIN',1,'2026-02-20 00:09:15','2026-02-16 19:31:05','2026-02-20 00:09:15',NULL),(6,'HEMA SRI','ALA','hemasriala@gmail.com',NULL,'hemasriala','$2y$10$0g5N2DqqPSHqxZfOpY9N.efRHLPRWXymjw9nlnA0YIn9xNy6E1si2','DOCTOR',1,'2026-02-20 00:07:08','2026-02-16 20:32:11','2026-02-20 00:07:08',NULL),(7,'HARSHITHA SAI','ALAKUNTA','alakuntaharshitha@gmail.com',NULL,'harshitha','$2y$10$vj/fdBTsHV8Aw77NsWWkj.2.gnB49I64K3qaGKmI4U.WyIocHOsrW','TRIAGE_NURSE',1,'2026-02-20 00:11:35','2026-02-16 20:35:14','2026-02-20 00:11:35',NULL),(12,'Doctor','Test01','dr.test01@d3s3.org',NULL,'doctortest01','$2y$10$GC7ovqcoTdukg932/4fYR.Ad9qn3jvAUKfX7589cL8Z61wccmfvK.','DOCTOR',1,'2026-04-15 19:28:33','2026-02-17 13:46:17','2026-04-15 19:28:33',NULL),(13,'Nurse','Test01','nurse.test01@d3s3.org',NULL,'nurseTest01','$2y$10$q0fIC2.MjrnY2YOSBptMnepi0ef5AeBncceS6KRl9m8YIu/AXmYW.','NURSE',1,'2026-04-11 16:28:51','2026-02-17 13:48:12','2026-04-11 16:28:51',NULL),(14,'Triage','NurseTest01','triage.nurse.test01@d3s3.org',NULL,'triageTest01','$2y$10$D1L4NiKVNN.3xy6Xg2FOIuEAM4TYSotcjUCbH9pQvgxLowutdqqhq','TRIAGE_NURSE',1,NULL,'2026-02-17 13:49:36','2026-02-18 18:51:46',NULL),(15,'Fatima','Siddiqui','f.siddiqui@d3s3.com','+919812345013','fsiddiqui','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','GRIEVANCE_OFFICER',1,'2026-04-07 10:15:00','2026-02-20 09:00:00','2026-04-08 23:44:35',NULL),(16,'Chitra','Nair','c.nair@d3s3.com','+919812345014','cnair','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','EDUCATION_TEAM',1,'2026-04-05 11:00:00','2026-02-20 09:00:00','2026-04-08 23:44:35',NULL),(17,'Kiran','Rao','k.rao@d3s3.com','+919812345015','krao','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','DOCTOR',1,'2026-04-08 08:45:00','2026-03-01 09:00:00','2026-04-08 23:44:35',NULL);
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

-- Dump completed on 2026-04-15 20:29:57
