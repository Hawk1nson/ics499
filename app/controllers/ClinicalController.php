<?php

/**
 * app/controllers/ClinicalController.php
 *
 * Handles the patient intake workflow:
 *   - intake form: Step 1 (patient selection) + Step 2 (full tabbed form)
 *   - patient search (AJAX)
 *   - new patient registration (AJAX)
 *   - complete intake (POST)
 *   - doctor claim-for-review (POST)
 */

require_once __DIR__ . '/../config/database.php';

class ClinicalController
{
	private const CLINICAL_ROLES = ['DOCTOR', 'TRIAGE_NURSE', 'NURSE'];

	// ── Intake form ─────────────────────────────────────────

	public function intake(): void
	{
		$this->requireClinicalRole();

		$flashSuccess = null;
		if (isset($_SESSION['intake_success'])) {
			$flashSuccess = $_SESSION['intake_success'];
			unset($_SESSION['intake_success']);
		}

		$formError = null;
		$caseSheet = null;
		$patient = null;

		// Step 2: If case_sheet_id in URL, load the full form
		$caseSheetId = (int)($_GET['case_sheet_id'] ?? 0);
		if ($caseSheetId > 0) {
			$pdo = getDBConnection();
			$stmt = $pdo->prepare('SELECT * FROM case_sheets WHERE case_sheet_id = ?');
			$stmt->execute([$caseSheetId]);
			$caseSheet = $stmt->fetch();

			if ($caseSheet) {
				$stmt = $pdo->prepare(
					'SELECT patient_id, patient_code, first_name, last_name, sex, date_of_birth,
					        age_years, phone_e164, address_line1, city, state_province, postal_code,
					        blood_group, allergies, emergency_contact_name, emergency_contact_phone
					   FROM patients WHERE patient_id = ?'
				);
				$stmt->execute([$caseSheet['patient_id']]);
				$patient = $stmt->fetch();
			}
		}

		// Step 1: POST creates the case sheet and redirects to Step 2
		if ($_SERVER['REQUEST_METHOD'] === 'POST' && !$caseSheetId) {
			$formError = $this->processCreateCaseSheet();
		}

		require __DIR__ . '/../views/intake.php';
	}

	// ── Complete intake (mark as INTAKE_COMPLETE) ────────────

	public function completeIntake(): void
	{
		$this->requireClinicalRole();

		if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
			header('Location: intake.php');
			exit;
		}

		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			$_SESSION['intake_error'] = 'Invalid request token.';
			header('Location: intake.php');
			exit;
		}

		$caseSheetId = (int)($_POST['case_sheet_id'] ?? 0);
		if ($caseSheetId <= 0) {
			header('Location: intake.php');
			exit;
		}

		$pdo = getDBConnection();

		// Get patient info for the flash message
		$stmt = $pdo->prepare(
			'SELECT cs.case_sheet_id, p.first_name, p.last_name, p.patient_code
			   FROM case_sheets cs
			   JOIN patients p ON p.patient_id = cs.patient_id
			  WHERE cs.case_sheet_id = ?'
		);
		$stmt->execute([$caseSheetId]);
		$row = $stmt->fetch();

		if (!$row) {
			header('Location: intake.php');
			exit;
		}

		// Update status to INTAKE_COMPLETE
		$pdo->prepare('UPDATE case_sheets SET status = ? WHERE case_sheet_id = ? AND status = ?')
		    ->execute(['INTAKE_COMPLETE', $caseSheetId, 'INTAKE_IN_PROGRESS']);

		$_SESSION['intake_success'] = 'Intake completed for '
			. htmlspecialchars($row['first_name'] . ' ' . ($row['last_name'] ?? ''))
			. ' (' . htmlspecialchars($row['patient_code']) . '). Case sheet is now in the doctor queue.';

		header('Location: intake.php');
		exit;
	}

	// ── Patient search (AJAX) ───────────────────────────────

	public function patientSearch(): void
	{
		$this->requireClinicalRole();
		header('Content-Type: application/json');

		$q = trim($_GET['q'] ?? '');
		if (strlen($q) < 2) {
			echo json_encode(['success' => true, 'patients' => []]);
			exit;
		}

		$pdo = getDBConnection();
		$like = '%' . $q . '%';
		$stmt = $pdo->prepare(
			'SELECT patient_id, patient_code, first_name, last_name,
			        sex, age_years, phone_e164
			   FROM patients
			  WHERE is_active = 1
			    AND (patient_code LIKE ?
			      OR first_name LIKE ?
			      OR last_name LIKE ?
			      OR phone_e164 LIKE ?)
			  ORDER BY last_name, first_name
			  LIMIT 10'
		);
		$stmt->execute([$like, $like, $like, $like]);

		echo json_encode(['success' => true, 'patients' => $stmt->fetchAll()]);
		exit;
	}

	// ── Register new patient (AJAX) ─────────────────────────

	public function registerPatient(): void
	{
		$this->requireClinicalRole();
		header('Content-Type: application/json');

		if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
			echo json_encode(['success' => false, 'message' => 'POST required']);
			exit;
		}

		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			echo json_encode(['success' => false, 'message' => 'Invalid request token.']);
			exit;
		}

		$firstName = trim($_POST['first_name'] ?? '');
		$lastName  = trim($_POST['last_name'] ?? '');
		$sex       = $_POST['sex'] ?? 'UNKNOWN';
		$dob       = $_POST['date_of_birth'] ?? null;
		$ageYears  = $_POST['age_years'] ?? null;
		$phone     = trim($_POST['phone_e164'] ?? '');

		if ($firstName === '') {
			echo json_encode(['success' => false, 'message' => 'First name is required.']);
			exit;
		}

		$validSex = ['MALE', 'FEMALE', 'OTHER', 'UNKNOWN'];
		if (!in_array($sex, $validSex, true)) {
			$sex = 'UNKNOWN';
		}

		if ($dob !== null && $dob !== '') {
			$dob = date('Y-m-d', strtotime($dob)) ?: null;
		} else {
			$dob = null;
		}

		$ageYears = ($ageYears !== null && $ageYears !== '') ? (int)$ageYears : null;

		$pdo = getDBConnection();
		$stmt = $pdo->prepare(
			'INSERT INTO patients (first_name, last_name, sex, date_of_birth, age_years, phone_e164, first_seen_date)
			 VALUES (?, ?, ?, ?, ?, ?, CURDATE())'
		);
		$stmt->execute([$firstName, $lastName ?: null, $sex, $dob, $ageYears, $phone ?: null]);
		$patientId = (int)$pdo->lastInsertId();

		// Fetch the auto-generated patient_code from the trigger
		$row = $pdo->prepare('SELECT patient_code FROM patients WHERE patient_id = ?');
		$row->execute([$patientId]);
		$patientCode = $row->fetchColumn();

		echo json_encode([
			'success'      => true,
			'patient_id'   => $patientId,
			'patient_code' => $patientCode,
			'first_name'   => $firstName,
			'last_name'    => $lastName,
		]);
		exit;
	}

	// ── Doctor claims case sheet for review ──────────────────

	public function claimForReview(): void
	{
		$this->requireDoctorRole();

		if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
			header('Location: dashboard.php');
			exit;
		}

		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			$_SESSION['intake_error'] = 'Invalid request token.';
			header('Location: dashboard.php');
			exit;
		}

		$caseSheetId = (int)($_POST['case_sheet_id'] ?? 0);
		if ($caseSheetId <= 0) {
			header('Location: dashboard.php');
			exit;
		}

		$pdo = getDBConnection();

		// Only claim if still INTAKE_COMPLETE (prevents double-claim)
		$stmt = $pdo->prepare(
			'UPDATE case_sheets
			    SET status = ?, assigned_doctor_user_id = ?
			  WHERE case_sheet_id = ? AND status = ?'
		);
		$stmt->execute(['DOCTOR_REVIEW', $_SESSION['user_id'], $caseSheetId, 'INTAKE_COMPLETE']);

		if ($stmt->rowCount() === 0) {
			$_SESSION['intake_error'] = 'This case sheet is no longer available for review.';
			header('Location: dashboard.php');
			exit;
		}

		// Get patient_id for the redirect
		$row = $pdo->prepare('SELECT patient_id FROM case_sheets WHERE case_sheet_id = ?');
		$row->execute([$caseSheetId]);
		$patientId = $row->fetchColumn();

		header('Location: case-sheet.php?case_sheet_id=' . $caseSheetId . '&patient_id=' . $patientId);
		exit;
	}

	// ── Create case sheet (Step 1 POST) ─────────────────────

	private function processCreateCaseSheet(): ?string
	{
		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			return 'Invalid request token.';
		}

		$patientId      = (int)($_POST['patient_id'] ?? 0);
		$visitType      = $_POST['visit_type'] ?? '';
		$chiefComplaint = trim($_POST['chief_complaint'] ?? '');

		if ($patientId <= 0) {
			return 'Please select a patient.';
		}

		$validTypes = ['CAMP', 'CLINIC', 'FOLLOW_UP', 'EMERGENCY', 'OTHER'];
		if (!in_array($visitType, $validTypes, true)) {
			return 'Please select a valid visit type.';
		}

		if ($chiefComplaint === '') {
			return 'Chief complaint is required.';
		}

		// Verify patient exists
		$pdo = getDBConnection();
		$stmt = $pdo->prepare('SELECT patient_id FROM patients WHERE patient_id = ? AND is_active = 1');
		$stmt->execute([$patientId]);
		if (!$stmt->fetch()) {
			return 'Patient not found.';
		}

		// Create case sheet with INTAKE_IN_PROGRESS status
		$stmt = $pdo->prepare(
			'INSERT INTO case_sheets
			    (patient_id, visit_type, status, created_by_user_id, chief_complaint)
			 VALUES (?, ?, ?, ?, ?)'
		);
		$stmt->execute([
			$patientId,
			$visitType,
			'INTAKE_IN_PROGRESS',
			$_SESSION['user_id'],
			$chiefComplaint,
		]);

		$newId = (int)$pdo->lastInsertId();

		// Redirect to Step 2 (full form)
		header('Location: intake.php?case_sheet_id=' . $newId);
		exit;
	}

	// ── Role guards ─────────────────────────────────────────

	private function requireClinicalRole(): void
	{
		$role = $_SESSION['user_role'] ?? '';
		if (!in_array($role, self::CLINICAL_ROLES, true)) {
			$_SESSION['dashboard_notice'] = 'You do not have permission to access this page.';
			header('Location: dashboard.php');
			exit;
		}
	}

	private function requireDoctorRole(): void
	{
		if (($_SESSION['user_role'] ?? '') !== 'DOCTOR') {
			$_SESSION['dashboard_notice'] = 'You do not have permission to access this page.';
			header('Location: dashboard.php');
			exit;
		}
	}
}
