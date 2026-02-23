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
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `asset_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `asset_type` enum('VIDEO','PDF','IMAGE','DOCUMENT','OTHER') NOT NULL,
  `category` varchar(80) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_size_bytes` bigint(20) unsigned DEFAULT NULL,
  `storage_type` enum('URL','LOCAL','S3','OTHER') NOT NULL DEFAULT 'URL',
  `resource_url` varchar(1024) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `uploaded_by_user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`asset_id`),
  KEY `idx_assets_type` (`asset_type`),
  KEY `idx_assets_public` (`is_public`),
  KEY `idx_assets_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'How to Measure Blood Pressure',NULL,'VIDEO','hypertension',NULL,NULL,'URL','https://example.org/videos/bp_measurement.mp4',1,1,NULL,'2026-02-04 20:12:21','2026-02-04 20:12:21'),(2,'Nurse Triage Checklist',NULL,'PDF','triage',NULL,NULL,'URL','/internal/training/triage_checklist.pdf',0,1,NULL,'2026-02-04 20:12:29','2026-02-04 20:12:29'),(3,'Understanding Diabetes','A patient-friendly guide to managing Type 2 Diabetes, diet, and exercise.','PDF','diabetes','diabetes_guide.pdf',2048000,'LOCAL','/assets/documents/diabetes_guide.pdf',1,1,4,'2026-02-10 10:00:00','2026-02-13 21:40:32'),(4,'Hypertension Self-Care Tips','Infographic with daily tips for managing high blood pressure at home.','IMAGE','hypertension','bp_tips_infographic.png',540000,'LOCAL','/assets/images/bp_tips_infographic.png',1,1,4,'2026-02-10 10:00:00','2026-02-13 21:40:32'),(5,'Post-Surgical Wound Care','Instructions for patients on caring for surgical wounds after discharge.','PDF','post-op','wound_care_guide.pdf',1200000,'LOCAL','/assets/documents/wound_care_guide.pdf',1,1,5,'2026-02-10 10:00:00','2026-02-13 21:40:32'),(6,'Hand Hygiene Training Video','WHO-standard hand hygiene technique for clinic staff.','VIDEO','infection-ctrl',NULL,NULL,'URL','https://example.org/videos/hand_hygiene.mp4',0,1,1,'2026-02-11 08:00:00','2026-02-13 21:40:32'),(7,'Diabetic Foot Care','Visual guide for diabetic patients on daily foot inspection and care.','DOCUMENT','diabetes','diabetic_foot_care.docx',890000,'LOCAL','/assets/documents/diabetic_foot_care.docx',1,1,5,'2026-02-11 09:00:00','2026-02-13 21:40:32'),(8,'Camp Registration Form Template','Printable patient registration form for use at medical camps.','PDF','admin','camp_reg_form.pdf',350000,'LOCAL','/assets/documents/camp_reg_form.pdf',0,1,10,'2026-02-12 09:00:00','2026-02-13 21:40:32');
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
  `field_name` varchar(100) NOT NULL,
  `old_value` longtext DEFAULT NULL,
  `new_value` longtext DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`audit_id`),
  KEY `idx_audit_case_sheet` (`case_sheet_id`,`changed_at`),
  KEY `idx_audit_user` (`user_id`),
  CONSTRAINT `fk_audit_case_sheet` FOREIGN KEY (`case_sheet_id`) REFERENCES `case_sheets` (`case_sheet_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_sheet_audit_log`
--

LOCK TABLES `case_sheet_audit_log` WRITE;
/*!40000 ALTER TABLE `case_sheet_audit_log` DISABLE KEYS */;
INSERT INTO `case_sheet_audit_log` VALUES (1,13,13,'status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 16:44:24'),(2,13,13,'family_history_cancer',NULL,'0','2026-02-18 16:44:50'),(3,13,13,'status','INTAKE_IN_PROGRESS','INTAKE_COMPLETE','2026-02-18 16:45:11'),(4,13,12,'status','INTAKE_COMPLETE','DOCTOR_REVIEW','2026-02-18 16:45:35'),(5,13,12,'doctor_exam_notes','','This is a test input..','2026-02-18 16:46:09'),(6,13,12,'doctor_plan_notes','','I am testing the saving functions.','2026-02-18 16:46:20'),(7,13,12,'status','DOCTOR_REVIEW','CLOSED','2026-02-18 16:46:40'),(8,13,12,'is_closed','0','1','2026-02-18 16:46:40'),(9,13,12,'closure_type','PENDING','DISCHARGED','2026-02-18 16:46:40'),(10,13,12,'closed_by_user_id',NULL,'12','2026-02-18 16:46:40'),(11,13,12,'closed_at',NULL,'2026-02-18 23:46:40','2026-02-18 16:46:40'),(12,13,12,'is_locked','0','1','2026-02-18 16:46:40'),(13,14,12,'status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 17:45:56'),(14,15,13,'status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 19:05:14'),(15,16,13,'status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 19:06:59'),(16,16,13,'condition_dm',NULL,'CURRENT','2026-02-18 19:09:22'),(17,16,13,'condition_htn',NULL,'CURRENT','2026-02-18 19:09:23'),(18,16,13,'condition_tsh',NULL,'PAST','2026-02-18 19:09:26'),(19,16,13,'condition_heart_disease',NULL,'CURRENT','2026-02-18 19:09:27'),(20,16,13,'condition_others',NULL,'Heart disease.','2026-02-18 19:09:48'),(21,16,13,'family_history_diabetes',NULL,'1','2026-02-18 19:10:04'),(22,16,13,'summary_doctor_summary',NULL,'This is a test of the doctor\'s summary area from intake.','2026-02-18 19:16:46'),(23,16,13,'status','INTAKE_IN_PROGRESS','INTAKE_COMPLETE','2026-02-18 19:16:49'),(24,16,12,'status','INTAKE_COMPLETE','DOCTOR_REVIEW','2026-02-18 19:18:07'),(25,17,12,'status',NULL,'INTAKE_IN_PROGRESS','2026-02-18 19:43:08'),(26,16,12,'follow_up_date','','2026-03-11','2026-02-18 19:46:06'),(27,16,12,'status','DOCTOR_REVIEW','CLOSED','2026-02-18 19:46:57'),(28,16,12,'is_closed','0','1','2026-02-18 19:46:57'),(29,16,12,'closure_type','PENDING','DISCHARGED','2026-02-18 19:46:57'),(30,16,12,'closed_by_user_id',NULL,'12','2026-02-18 19:46:57'),(31,16,12,'closed_at',NULL,'2026-02-19 02:46:57','2026-02-18 19:46:57'),(32,16,12,'is_locked','0','1','2026-02-18 19:46:57');
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
  `status` enum('INTAKE_IN_PROGRESS','INTAKE_COMPLETE','DOCTOR_REVIEW','CLOSED') NOT NULL DEFAULT 'INTAKE_IN_PROGRESS',
  `queue_position` float unsigned DEFAULT NULL,
  `created_by_user_id` int(10) unsigned DEFAULT NULL,
  `assigned_doctor_user_id` int(10) unsigned DEFAULT NULL,
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
  PRIMARY KEY (`case_sheet_id`),
  KEY `idx_case_sheets_patient` (`patient_id`,`visit_datetime`),
  KEY `idx_case_sheets_closed` (`is_closed`,`closed_at`),
  KEY `idx_case_sheets_visit_date` (`visit_datetime`),
  KEY `idx_case_sheets_status` (`status`,`visit_datetime`),
  KEY `idx_case_sheets_queue` (`status`,`queue_position`,`visit_datetime`),
  CONSTRAINT `fk_case_sheets_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `case_sheets`
--

LOCK TABLES `case_sheets` WRITE;
/*!40000 ALTER TABLE `case_sheets` DISABLE KEYS */;
INSERT INTO `case_sheets` VALUES (1,5,'2026-02-10 09:20:00','CAMP','CLOSED',NULL,8,4,'Persistent headaches for 2 weeks','Patient reports daily headaches starting in the morning, worsening with activity. No history of migraine. No visual disturbances.','{\"bp_systolic\":148,\"bp_diastolic\":92,\"pulse\":82,\"temp_f\":98.4,\"spo2\":97,\"weight_kg\":68,\"height_cm\":158}','Alert, oriented. No papilledema. Neck supple. No neurological deficits.',NULL,NULL,NULL,NULL,'Headaches likely secondary to uncontrolled hypertension.','Essential hypertension, Stage 1','Start antihypertensive. Lifestyle modifications. Review in 2 weeks.',NULL,NULL,NULL,NULL,'Tab Amlodipine 5mg OD x 30 days','Reduce salt intake. Walk 30 min daily. Avoid stress. Monitor BP at home.','2026-02-24',NULL,NULL,'Review BP log, assess medication response.',1,'2026-02-10 09:50:00',4,'FOLLOW_UP','Started on antihypertensive. Follow-up in 2 weeks.',0,'2026-02-10 09:20:00','2026-02-17 19:47:28'),(2,6,'2026-02-10 09:35:00','CAMP','CLOSED',NULL,8,4,'Chest pain on exertion for 1 month','Patient describes substernal chest tightness during walking uphill, relieved by rest. Smoker 30 pack-years. Family history of MI (father at age 55).','{\"bp_systolic\":160,\"bp_diastolic\":95,\"pulse\":88,\"temp_f\":98.6,\"spo2\":95,\"weight_kg\":82,\"height_cm\":170}','Obese. Mild wheeze bilaterally. S1S2 normal, no murmurs. Peripheral pulses present.',NULL,NULL,NULL,NULL,'Exertional chest pain — need to rule out ischemic heart disease.','Suspected angina pectoris; COPD likely','Urgent referral for ECG, stress test, and cardiac workup.',NULL,NULL,NULL,NULL,'Tab Aspirin 75mg OD, Tab Atorvastatin 20mg HS, SL Sorbitrate 5mg SOS','Stop smoking immediately. Avoid heavy exertion. Go to ER if chest pain at rest.',NULL,'Sassoon General Hospital, Cardiology','Suspected unstable angina, needs urgent cardiac evaluation and possible angiography.',NULL,1,'2026-02-10 10:15:00',4,'REFERRAL','Referred to cardiology for urgent evaluation.',1,'2026-02-10 09:35:00','2026-02-17 19:47:28'),(3,7,'2026-02-10 10:05:00','CAMP','CLOSED',NULL,9,5,'Joint pain in both knees for 6 months','Bilateral knee pain, worse on climbing stairs and squatting. Morning stiffness lasting 15 minutes. No swelling or redness.','{\"bp_systolic\":120,\"bp_diastolic\":78,\"pulse\":74,\"temp_f\":98.2,\"spo2\":98,\"weight_kg\":72,\"height_cm\":160}','Crepitus bilateral knees. No effusion. Full ROM with pain at extremes. BMI 28.1.',NULL,NULL,NULL,NULL,'Bilateral knee osteoarthritis, Grade 2.','Osteoarthritis, bilateral knees','Weight reduction. Quadriceps strengthening exercises. Analgesics as needed.',NULL,NULL,NULL,NULL,'Tab Paracetamol 650mg TDS x 14 days, Cap Glucosamine 1500mg OD x 30 days','Lose 5 kg over next 3 months. Avoid squatting and stair climbing. Use warm compresses.','2026-02-24',NULL,NULL,'Review symptoms. Consider X-ray if no improvement.',1,'2026-02-10 10:35:00',5,'DISCHARGED','Conservative management. Follow-up in 2 weeks.',0,'2026-02-10 10:05:00','2026-02-17 19:47:28'),(4,8,'2026-02-10 10:35:00','CAMP','INTAKE_COMPLETE',1,8,5,'Uncontrolled diabetes — blood sugar very high','Known diabetic for 12 years. Currently on Metformin 500mg BD. Reports polyuria, polydipsia, blurred vision for 1 month. Last HbA1c was 9.2% (3 months ago).','{\"bp_systolic\":135,\"bp_diastolic\":85,\"pulse\":80,\"temp_f\":98.4,\"spo2\":97,\"weight_kg\":78,\"height_cm\":168,\"rbs_mg_dl\":320}','Dry skin. Reduced sensation in feet bilaterally. Fundoscopy: early background retinopathy.',NULL,NULL,NULL,NULL,'Poorly controlled Type 2 DM with early complications (neuropathy, retinopathy).','Type 2 Diabetes Mellitus, uncontrolled; Diabetic peripheral neuropathy; Background diabetic retinopathy','Intensify glycemic control. Add second oral agent. Ophthalmology referral for retinopathy. Foot care education.',NULL,NULL,NULL,NULL,'Tab Metformin 1000mg BD, Tab Glimepiride 2mg OD before breakfast, Tab Methylcobalamin 1500mcg OD','Strict diabetic diet. Check blood sugar fasting and post-meal daily. Foot care — inspect daily, wear proper footwear.','2026-02-17',NULL,NULL,'Review fasting and post-meal blood sugar diary. Repeat HbA1c.',0,NULL,NULL,'PENDING',NULL,0,'2026-02-10 10:35:00','2026-02-18 16:32:45'),(5,9,'2026-02-11 09:10:00','CLINIC','CLOSED',NULL,8,4,'Sore throat and fever for 3 days','High-grade fever (102F) with sore throat and difficulty swallowing. No cough. No rash.','{\"bp_systolic\":110,\"bp_diastolic\":70,\"pulse\":96,\"temp_f\":101.8,\"spo2\":98,\"weight_kg\":55,\"height_cm\":162}','Pharynx congested. Tonsils enlarged, bilateral, with whitish exudate. Anterior cervical lymph nodes tender and palpable.',NULL,NULL,NULL,NULL,'Acute exudative tonsillitis, likely bacterial.','Acute bacterial tonsillitis','Antibiotics x 7 days. Symptomatic treatment. Review if not improving in 48 hours.',NULL,NULL,NULL,NULL,'Tab Amoxicillin 500mg TDS x 7 days, Tab Paracetamol 500mg TDS x 3 days, Betadine gargle TDS','Warm saline gargles. Soft diet. Plenty of fluids. Rest.',NULL,NULL,NULL,NULL,1,'2026-02-11 09:40:00',4,'DISCHARGED','Acute tonsillitis. Antibiotics prescribed.',0,'2026-02-11 09:10:00','2026-02-17 19:47:28'),(6,10,'2026-02-11 10:00:00','CLINIC','INTAKE_COMPLETE',2,9,5,'Lower back pain radiating to left leg for 1 week','Acute onset LBP after lifting heavy furniture. Pain radiates to left buttock and posterior thigh. Numbness in left foot. No bladder/bowel involvement.','{\"bp_systolic\":130,\"bp_diastolic\":82,\"pulse\":78,\"temp_f\":98.4,\"spo2\":98,\"weight_kg\":85,\"height_cm\":175}','Lumbar paraspinal muscle spasm. SLR positive left at 40 degrees. Reduced ankle jerk left. No motor deficit.',NULL,NULL,NULL,NULL,'Acute lumbar radiculopathy, likely L5-S1 disc involvement.','Lumbar disc herniation with left L5-S1 radiculopathy','Conservative management initially. MRI if no improvement in 2 weeks. Strict bed rest 48 hours.',NULL,NULL,NULL,NULL,'Tab Diclofenac 50mg BD x 7 days, Tab Thiocolchicoside 4mg BD x 7 days, Tab Pregabalin 75mg HS x 14 days','Strict bed rest on firm mattress for 48 hours. Avoid bending and lifting. Apply hot fomentation. Begin gentle back exercises after pain subsides.','2026-02-25',NULL,NULL,'Review pain response. If persistent numbness or weakness, urgent MRI.',0,NULL,NULL,'PENDING',NULL,0,'2026-02-11 10:00:00','2026-02-18 16:32:45'),(7,11,'2026-02-11 11:00:00','CLINIC','CLOSED',NULL,8,4,'Skin rash on both arms for 5 days','Itchy, red, raised rash on both forearms. Started after using a new laundry detergent. No fever. No prior history of eczema.','{\"bp_systolic\":112,\"bp_diastolic\":72,\"pulse\":70,\"temp_f\":98.0,\"spo2\":99,\"weight_kg\":52,\"height_cm\":155}','Erythematous papular rash on bilateral forearms. No vesicles. No secondary infection. Rest of skin clear.',NULL,NULL,NULL,NULL,'Contact dermatitis secondary to detergent exposure.','Allergic contact dermatitis','Topical steroids. Antihistamine. Avoid offending agent.',NULL,NULL,NULL,NULL,'Cream Betamethasone 0.05% apply BD x 7 days, Tab Cetirizine 10mg HS x 7 days','Stop using the new detergent. Use fragrance-free, hypoallergenic products. Keep skin moisturized.',NULL,NULL,NULL,NULL,1,'2026-02-11 11:25:00',4,'DISCHARGED','Contact dermatitis. Topical treatment prescribed.',0,'2026-02-11 11:00:00','2026-02-17 19:47:28'),(8,12,'2026-02-12 08:45:00','EMERGENCY','CLOSED',NULL,8,5,'Sudden severe abdominal pain with vomiting','Acute onset severe epigastric pain radiating to back, started 2 hours ago after a heavy meal. Multiple episodes of vomiting. History of gallstones diagnosed 6 months ago.','{\"bp_systolic\":100,\"bp_diastolic\":65,\"pulse\":110,\"temp_f\":100.2,\"spo2\":96,\"weight_kg\":75,\"height_cm\":165}','Distressed, diaphoretic. Abdomen — guarding in epigastrium and RUQ. Tenderness with rebound. Bowel sounds reduced. Murphy sign positive.',NULL,NULL,NULL,NULL,'Acute abdomen — likely acute cholecystitis or biliary pancreatitis given history of gallstones.','Acute cholecystitis; Rule out acute pancreatitis','IV fluids, NPO, pain management. Urgent surgical referral.',NULL,NULL,NULL,NULL,'Inj Pantoprazole 40mg IV stat, Inj Tramadol 50mg IV stat, NS 1000ml IV over 4 hours','Nothing by mouth. Immediate transfer to hospital.',NULL,'Ruby Hall Clinic, Surgery','Acute abdomen with suspected cholecystitis/pancreatitis. Needs urgent imaging and surgical consult.',NULL,1,'2026-02-12 09:30:00',5,'REFERRAL','Emergency referral to surgery for acute abdomen.',1,'2026-02-12 08:45:00','2026-02-17 19:47:28'),(9,13,'2026-02-12 09:20:00','CLINIC','CLOSED',NULL,9,4,'Irregular periods and fatigue for 3 months','Menstrual cycles irregular — ranging from 20 to 45 days. Heavy flow lasting 7-8 days. Feeling very tired. Weight gain of 5 kg in 3 months.','{\"bp_systolic\":118,\"bp_diastolic\":76,\"pulse\":72,\"temp_f\":98.2,\"spo2\":99,\"weight_kg\":70,\"height_cm\":163}','Mild pallor. Thyroid not enlarged. No hirsutism. Abdomen soft, no masses.',NULL,NULL,NULL,NULL,'Irregular menstruation with fatigue. Need to rule out thyroid dysfunction and anemia.','Dysfunctional uterine bleeding; Anemia to be ruled out; Hypothyroidism to be ruled out','Blood work: CBC, TSH, Free T4, Iron studies. Pelvic ultrasound. Review with reports.',NULL,NULL,NULL,NULL,'Tab Ferrous Fumarate 200mg BD x 30 days, Tab Tranexamic Acid 500mg TDS during menses x 5 days','Iron-rich diet — green leafy vegetables, jaggery, dates. Maintain menstrual diary. Return with blood reports.','2026-02-19',NULL,NULL,'Review CBC and thyroid reports. Adjust treatment accordingly.',1,'2026-02-12 10:00:00',4,'FOLLOW_UP','Lab work ordered. Follow-up with reports.',0,'2026-02-12 09:20:00','2026-02-17 19:47:28'),(10,14,'2026-02-13 08:15:00','CLINIC','INTAKE_COMPLETE',3,8,4,'Burning urination and frequent urge to urinate for 4 days','Dysuria with increased frequency for 4 days. Mild suprapubic discomfort. No fever. No hematuria. No flank pain.','{\"bp_systolic\":128,\"bp_diastolic\":80,\"pulse\":76,\"temp_f\":98.6,\"spo2\":98,\"weight_kg\":80,\"height_cm\":172}','Abdomen soft. Mild suprapubic tenderness. No costovertebral angle tenderness. No urethral discharge.',NULL,NULL,NULL,NULL,'Lower urinary tract infection.','Acute cystitis','Empirical antibiotics. Urine culture to confirm. Increase fluid intake.',NULL,NULL,NULL,NULL,'Tab Nitrofurantoin 100mg BD x 5 days','Drink at least 3 liters of water daily. Avoid holding urine. Complete full course of antibiotics.',NULL,NULL,NULL,'Review urine culture results if symptoms persist.',0,NULL,NULL,'PENDING',NULL,0,'2026-02-13 08:15:00','2026-02-18 16:32:45'),(11,1,'2026-02-17 19:58:55','CAMP','INTAKE_COMPLETE',4,13,NULL,'Shortness of breath','Prior history of asthma.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-17 19:58:55','2026-02-18 16:32:45'),(12,1,'2026-02-17 20:09:26','CAMP','INTAKE_IN_PROGRESS',5,13,NULL,'Shortness of breath',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-17 20:09:26','2026-02-18 16:32:45'),(13,16,'2026-02-18 16:44:24','CAMP','CLOSED',NULL,13,12,'Stomach pains',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{\"family_history_cancer\":\"0\"}',NULL,NULL,'This is a test input..',NULL,NULL,'I am testing the saving functions.',NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-18 23:46:40',12,'DISCHARGED',NULL,1,'2026-02-18 16:44:24','2026-02-18 23:46:40'),(14,16,'2026-02-18 17:45:56','FOLLOW_UP','INTAKE_IN_PROGRESS',2,12,NULL,'chest pain',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-18 17:45:56','2026-02-18 19:05:59'),(15,4,'2026-02-18 19:05:14','EMERGENCY','INTAKE_IN_PROGRESS',1,13,NULL,'chest pain',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-18 19:05:14','2026-02-18 19:05:59'),(16,6,'2026-02-18 19:06:59','CAMP','CLOSED',NULL,13,12,'Asthma',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'{\"condition_dm\":\"CURRENT\",\"condition_htn\":\"CURRENT\",\"condition_tsh\":\"PAST\",\"condition_heart_disease\":\"CURRENT\",\"condition_others\":\"Heart disease.\",\"family_history_diabetes\":\"1\"}',NULL,'{\"summary_doctor_summary\":\"This is a test of the doctor\'s summary area from intake.\"}',NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-11',NULL,NULL,NULL,1,'2026-02-19 02:46:57',12,'DISCHARGED',NULL,1,'2026-02-18 19:06:59','2026-02-19 02:46:57'),(17,16,'2026-02-18 19:43:08','CLINIC','INTAKE_IN_PROGRESS',NULL,12,NULL,'shortness of breath',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'PENDING',NULL,0,'2026-02-18 19:43:08','2026-02-18 19:43:08');
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
  PRIMARY KEY (`event_id`),
  KEY `idx_events_type` (`event_type`),
  KEY `idx_events_status` (`status`),
  KEY `idx_events_start` (`start_datetime`),
  KEY `idx_events_city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'MEDICAL_CAMP','Health Camp - Community Center',NULL,'2026-02-10 09:00:00','2026-02-10 16:00:00','Ward 12 Community Center',NULL,'Pune','Maharashtra',NULL,'SCHEDULED',1,NULL,'2026-02-04 20:14:30','2026-02-04 20:14:30'),(2,'EDUCATIONAL_SEMINAR','Diabetes Prevention Seminar',NULL,'2026-02-12 18:00:00',NULL,'Library Meeting Room A',NULL,'St. Paul','MN',NULL,'SCHEDULED',1,NULL,'2026-02-04 20:14:36','2026-02-04 20:14:36'),(3,'MEDICAL_CAMP','Eye Screening Camp','Free eye check-ups and spectacle distribution for senior citizens.','2026-02-15 09:00:00','2026-02-15 15:00:00','Government School Ground','Shivaji Nagar','Pune','Maharashtra','411005','SCHEDULED',1,1,'2026-02-10 12:00:00','2026-02-13 21:40:32'),(4,'TRAINING','First Aid Refresher for Nurses','Annual first-aid certification renewal training.','2026-02-18 10:00:00','2026-02-18 13:00:00','D3S3 Training Room','Office Campus','Pune','Maharashtra','411001','SCHEDULED',1,1,'2026-02-10 12:00:00','2026-02-13 21:40:32'),(5,'MEDICAL_CAMP','Rural Health Camp - Mulshi','General health screening and medicine distribution in rural Mulshi area.','2026-02-08 08:00:00','2026-02-08 17:00:00','Mulshi Gram Panchayat Hall','Mulshi Village','Mulshi','Maharashtra','412108','COMPLETED',1,1,'2026-02-01 10:00:00','2026-02-13 21:40:32'),(6,'EDUCATIONAL_SEMINAR','Nutrition & Child Health Workshop','Interactive workshop on child nutrition for new mothers.','2026-02-20 14:00:00','2026-02-20 17:00:00','Community Health Center','Kothrud','Pune','Maharashtra','411038','DRAFT',1,10,'2026-02-12 09:00:00','2026-02-13 21:40:32'),(7,'MEETING','Monthly Staff Review Meeting','Review of patient outcomes, camp reports, and upcoming schedule.','2026-02-14 16:00:00','2026-02-14 17:30:00','D3S3 Conference Room','Office Campus','Pune','Maharashtra','411001','SCHEDULED',1,1,'2026-02-10 14:00:00','2026-02-13 21:40:32');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `message_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `patient_id` int(10) unsigned NOT NULL,
  `sender_type` enum('PATIENT','STAFF') NOT NULL,
  `sender_user_id` int(10) unsigned DEFAULT NULL COMMENT 'NULL if sent by patient',
  `subject` varchar(255) DEFAULT NULL,
  `message_text` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `case_sheet_id` bigint(20) unsigned DEFAULT NULL,
  `sent_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`message_id`),
  KEY `idx_messages_patient` (`patient_id`,`sent_at`),
  KEY `idx_messages_unread` (`is_read`,`sent_at`),
  KEY `idx_messages_case` (`case_sheet_id`),
  CONSTRAINT `fk_messages_case` FOREIGN KEY (`case_sheet_id`) REFERENCES `case_sheets` (`case_sheet_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,5,'PATIENT',NULL,'Question about my blood pressure medicine','Dear Doctor, I started taking the Amlodipine as prescribed. I am feeling a little dizzy in the mornings after taking it. Is this normal? Should I continue the medicine? My BP readings at home have been around 135/85. Thank you.',1,'2026-02-12 10:30:00',1,'2026-02-12 09:15:00'),(2,5,'STAFF',4,'RE: Question about my blood pressure medicine','Dear Sunita, mild dizziness can occur in the first few days as your body adjusts to the medication. Your BP of 135/85 shows good improvement. Please continue the medicine and take it at bedtime instead of morning — this should help with the dizziness. If dizziness persists beyond a week, please visit us. Keep recording your BP daily.',1,'2026-02-12 15:00:00',1,'2026-02-12 10:45:00'),(3,8,'PATIENT',NULL,'Diabetic diet question','Doctor sahab, I am confused about what I can eat. You said strict diabetic diet but can I eat rice? And what about fruits? My sugar was 280 this morning fasting. Please guide.',1,'2026-02-12 14:00:00',4,'2026-02-12 11:30:00'),(4,8,'STAFF',5,'RE: Diabetic diet question','Dear Mohammed, a fasting sugar of 280 is still quite high. For rice — you can have small portions of brown rice, but white rice should be avoided. For fruits — you can eat apple, guava, and papaya in small amounts. Avoid mango, banana, grapes, and chikoo completely. Please take your medicines regularly and walk for 30 minutes after dinner. We will review your sugars at your next visit on Feb 17.',0,NULL,4,'2026-02-12 14:30:00'),(5,10,'PATIENT',NULL,'Back pain update','Hello Doctor, I have been resting as advised. The back pain has reduced somewhat but the numbness in my left foot is still there. Should I be concerned? When can I go back to work?',1,'2026-02-13 09:00:00',6,'2026-02-13 07:45:00'),(6,10,'STAFF',5,'RE: Back pain update','Dear Rajesh, it is good that the pain is reducing. Persistent numbness after a week needs attention — please come in for a review this week so we can assess whether an MRI is needed sooner. Do not return to work involving lifting until we clear you. Continue the Pregabalin as prescribed.',0,NULL,6,'2026-02-13 09:15:00'),(7,13,'PATIENT',NULL,'When should I get blood tests done?','Hi, I wanted to ask — should I get the blood tests done on an empty stomach? And where should I go for the pelvic ultrasound? Can you recommend a lab nearby?',0,NULL,9,'2026-02-13 10:00:00'),(8,11,'PATIENT',NULL,'Rash is clearing up','Doctor, just wanted to let you know the rash on my arms is much better after using the cream. I threw away the old detergent. Thank you for the help!',1,'2026-02-13 11:00:00',7,'2026-02-13 08:30:00'),(9,11,'STAFF',4,'RE: Rash is clearing up','That is great to hear, Anjali! You can taper the cream — apply once daily for 3 more days then stop. Continue using hypoallergenic products. No need for a follow-up visit unless it recurs.',0,NULL,7,'2026-02-13 11:15:00');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
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
  PRIMARY KEY (`seq_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_daily_sequence`
--

LOCK TABLES `patient_daily_sequence` WRITE;
/*!40000 ALTER TABLE `patient_daily_sequence` DISABLE KEYS */;
INSERT INTO `patient_daily_sequence` VALUES ('2026-02-04',1),('2026-02-06',3),('2026-02-10',4),('2026-02-11',3),('2026-02-12',2),('2026-02-13',1),('2026-02-18',2);
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
  PRIMARY KEY (`feedback_id`),
  KEY `idx_feedback_patient` (`patient_id`,`created_at`),
  KEY `idx_feedback_status` (`status`),
  KEY `idx_feedback_type` (`feedback_type`),
  KEY `idx_feedback_related_user` (`related_user_id`),
  CONSTRAINT `fk_feedback_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_feedback`
--

LOCK TABLES `patient_feedback` WRITE;
/*!40000 ALTER TABLE `patient_feedback` DISABLE KEYS */;
INSERT INTO `patient_feedback` VALUES (1,5,4,'POSITIVE',5,'Dr. Desai was very patient and explained my condition clearly. She took time to answer all my questions about blood pressure. The camp was well organized.','REVIEWED','Shared with Dr. Desai. Good feedback.','2026-02-10 16:00:00','2026-02-13 21:40:32'),(2,6,NULL,'SUGGESTION',NULL,'The waiting time at the camp was very long — almost 2 hours. It would be nice if there was a token system so we know our turn. Also, more chairs would help for elderly patients.','ACTIONED','Will implement token system for next camp. Added to logistics checklist.','2026-02-10 16:30:00','2026-02-13 21:40:32'),(3,7,5,'POSITIVE',4,'Good consultation. Dr. Patel was helpful. Only suggestion is that it would be nice to get a printed summary of the advice given during the visit.','REVIEWED',NULL,'2026-02-10 17:00:00','2026-02-13 21:40:32'),(4,9,8,'POSITIVE',5,'Meena at the registration desk was very helpful and efficient. Got my paperwork done quickly and she was very friendly. Thank you!','NEW',NULL,'2026-02-11 12:00:00','2026-02-13 21:40:32'),(5,12,NULL,'COMPLAINT',2,'I came with severe stomach pain and had to wait 20 minutes before anyone attended to me. For emergency cases there should be immediate attention. The treatment itself was good once the doctor saw me.','REVIEWED','Discussed with team. Implementing triage protocol for emergency walk-ins to ensure immediate assessment.','2026-02-12 14:00:00','2026-02-13 21:40:32'),(6,13,4,'POSITIVE',4,'Dr. Desai was thorough in her examination and ordered all the right tests. I appreciated that she explained why each test was needed. Clinic was clean and comfortable.','NEW',NULL,'2026-02-12 11:00:00','2026-02-13 21:40:32'),(7,14,NULL,'SUGGESTION',NULL,'It would be great if the clinic could offer online appointment booking instead of walk-in only. Hard to take time off work without knowing the wait time.','NEW',NULL,'2026-02-13 09:00:00','2026-02-13 21:40:32'),(8,8,6,'POSITIVE',5,'Nurse Sneha was very caring when checking my vitals and explaining how to use the glucose monitor. She made me feel comfortable despite my fear of needles.','NEW',NULL,'2026-02-11 11:00:00','2026-02-13 21:40:32');
/*!40000 ALTER TABLE `patient_feedback` ENABLE KEYS */;
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
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `uq_patients_patient_code` (`patient_code`),
  UNIQUE KEY `uq_patients_username` (`username`),
  UNIQUE KEY `uq_patients_email` (`email`),
  KEY `idx_patients_name` (`last_name`,`first_name`),
  KEY `idx_patients_phone` (`phone_e164`),
  KEY `idx_patients_first_seen` (`first_seen_date`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'20260204001','2026-02-04','Rahul','Sharma','MALE',NULL,NULL,'+919876543210',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-04 20:07:09','2026-02-18 12:15:03'),(2,'20260206001','2026-02-06','Test','Patient1','MALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-06 19:26:14','2026-02-18 12:15:03'),(3,'20260206002','2026-02-06','Test','Patient2','MALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-06 19:26:14','2026-02-18 12:15:03'),(4,'20260206003','2026-02-06','Test','Patient3','MALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-06 19:26:14','2026-02-18 12:15:03'),(5,'20260210001','2026-02-10','Sunita','Devi','FEMALE','1985-03-15',40,'+919900100001','sunita.d@email.com','42 MG Road','Pune','Maharashtra','411001','B+',NULL,'Rajesh Devi','+919900100099',NULL,NULL,NULL,1,'2026-02-10 09:15:00','2026-02-18 12:15:03'),(6,'20260210002','2026-02-10','Arun','Kumar','MALE','1972-08-22',53,'+919900100002',NULL,'15 Station Road','Pune','Maharashtra','411002','O+','Penicillin','Lakshmi Kumar','+919900100098',NULL,NULL,NULL,1,'2026-02-10 09:30:00','2026-02-18 12:15:03'),(7,'20260210003','2026-02-10','Lakshmi','Iyer','FEMALE','1990-11-05',35,'+919900100003','lakshmi.i@email.com','8 Temple Street','Pune','Maharashtra','411003','A+',NULL,'Venkat Iyer','+919900100097',NULL,NULL,NULL,1,'2026-02-10 10:00:00','2026-02-18 12:15:03'),(8,'20260210004','2026-02-10','Mohammed','Ansari','MALE','1968-01-30',58,'+919900100004',NULL,'22 Park Avenue','Pune','Maharashtra','411004','AB+','Sulfa drugs','Fatima Ansari','+919900100096',NULL,NULL,NULL,1,'2026-02-10 10:30:00','2026-02-18 12:15:03'),(9,'20260211001','2026-02-11','Kavita','Reddy','FEMALE','1995-06-18',30,'+919900100005','kavita.r@email.com','5 Jubilee Hills','Hyderabad','Telangana','500033','O-',NULL,'Suresh Reddy','+919900100095',NULL,NULL,NULL,1,'2026-02-11 09:00:00','2026-02-18 12:15:03'),(10,'20260211002','2026-02-11','Rajesh','Verma','MALE','1980-12-01',45,'+919900100006',NULL,'71 Civil Lines','Nagpur','Maharashtra','440001','B-','Aspirin','Suman Verma','+919900100094',NULL,NULL,NULL,1,'2026-02-11 09:45:00','2026-02-18 12:15:03'),(11,'20260211003','2026-02-11','Anjali','Nair','FEMALE','2000-04-10',25,'+919900100007','anjali.n@email.com','33 Beach Road','Kochi','Kerala','682001','A-',NULL,'Vijay Nair','+919900100093',NULL,NULL,NULL,1,'2026-02-11 10:30:00','2026-02-18 12:15:03'),(12,'20260212001','2026-02-12','Suresh','Yadav','MALE','1955-09-25',70,'+919900100008',NULL,'18 Gandhi Nagar','Pune','Maharashtra','411005','O+','Ibuprofen, Codeine','Kamla Yadav','+919900100092',NULL,NULL,NULL,1,'2026-02-12 08:30:00','2026-02-18 12:15:03'),(13,'20260212002','2026-02-12','Pooja','Bhatt','FEMALE','1988-07-14',37,'+919900100009','pooja.b@email.com','9 Lakeview Colony','Pune','Maharashtra','411006','AB-',NULL,'Dinesh Bhatt','+919900100091',NULL,NULL,NULL,1,'2026-02-12 09:15:00','2026-02-18 12:15:03'),(14,'20260213001','2026-02-13','Ramesh','Chauhan','MALE','1975-02-28',51,'+919900100010',NULL,'55 Industrial Area','Pune','Maharashtra','411007','A+',NULL,'Geeta Chauhan','+919900100090',NULL,NULL,NULL,1,'2026-02-13 08:00:00','2026-02-18 12:15:03'),(15,'20260218001','2026-02-18','Test','Patient','MALE','2020-01-07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-18 12:11:22','2026-02-18 12:15:03'),(16,'20260218002','2026-02-18','Test','Patient04','FEMALE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'2026-02-18 16:44:12','2026-02-18 16:44:12');
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
  PRIMARY KEY (`pref_id`),
  UNIQUE KEY `uq_prefs_account` (`account_type`,`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preferences`
--

LOCK TABLES `user_preferences` WRITE;
/*!40000 ALTER TABLE `user_preferences` DISABLE KEYS */;
INSERT INTO `user_preferences` VALUES (1,'STAFF',1,'light','en','normal','DD/MM/YYYY',30,1,'2026-02-17 13:41:02','2026-02-17 13:41:44');
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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_email` (`email`),
  UNIQUE KEY `uq_users_username` (`username`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_active` (`is_active`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Andrew','Hawkinson','hawk@d3s3.com',NULL,'Hawkinson','$2y$10$lO.z3dxebDVH.eVN9UATbO4WmZXs9gOw8X23BGpEKffE1aSaAmXF.','SUPER_ADMIN',1,'2026-02-18 18:47:20','2026-02-04 14:41:37','2026-02-18 18:47:20'),(2,'Admin','Account','admin1@d3s3.com',NULL,'admin1','$2y$10$wH/SJPGCqIxx1wmYUrPzCe7i6JOgeFBk.6a.xrQ4Nl.MuEEUxoASG','ADMIN',0,NULL,'2026-02-04 14:49:41','2026-02-06 18:32:55'),(3,'Gary','Marks','g.marks@d3s3.com',NULL,'gmarks','$2y$10$SW6AIjBtzZU8SkQXsy0EOO84g6Ffe5XlEtKYmm/yGm0QKZUWLxCAa','SUPER_ADMIN',1,NULL,'2026-02-04 18:26:01','2026-02-06 18:34:57'),(12,'Doctor','Test01','dr.test01@d3s3.org',NULL,'doctortest01','$2y$10$GC7ovqcoTdukg932/4fYR.Ad9qn3jvAUKfX7589cL8Z61wccmfvK.','DOCTOR',1,'2026-02-18 19:17:23','2026-02-17 13:46:17','2026-02-18 19:17:23'),(13,'Nurse','Test01','nurse.test01@d3s3.org',NULL,'nurseTest01','$2y$10$q0fIC2.MjrnY2YOSBptMnepi0ef5AeBncceS6KRl9m8YIu/AXmYW.','NURSE',1,'2026-02-18 19:01:28','2026-02-17 13:48:12','2026-02-18 19:01:28'),(14,'Triage','NurseTest01','triage.nurse.test01@d3s3.org',NULL,'triageTest01','$2y$10$D1L4NiKVNN.3xy6Xg2FOIuEAM4TYSotcjUCbH9pQvgxLowutdqqhq','TRIAGE_NURSE',1,NULL,'2026-02-17 13:49:36','2026-02-18 18:51:46');
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

-- Dump completed on 2026-02-23 13:46:40
