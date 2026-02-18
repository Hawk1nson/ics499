<?php
/**
 * update_case_sheet.php
 * API endpoint to update case sheet information.
 * Supports direct columns and JSON-stored fields across multiple JSON columns:
 *   - vitals_json: vitals, personal/reproductive, general exam fields
 *   - exam_notes (JSON): examination fields (exam_*)
 *   - assessment (JSON): history/condition fields (condition_*, family_history_*, surgical_history)
 *   - diagnosis (JSON): lab/cytology fields (lab_*, cytology_*)
 *   - plan_notes (JSON): summary fields (summary_*)
 */

error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

require_once __DIR__ . '/app/config/session.php';
header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
	echo json_encode(['success' => false, 'message' => 'Unauthorized']);
	exit;
}

// Accept JSON body (original pattern) or POST form
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
	$input = $_POST;
}

// CSRF check (from JSON body or header)
$token = $input['csrf_token'] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? '');
if (!hash_equals($_SESSION['csrf_token'] ?? '', $token)) {
	echo json_encode(['success' => false, 'message' => 'Invalid request token.']);
	exit;
}

require_once __DIR__ . '/app/config/database.php';
$pdo = getDBConnection();

$case_sheet_id = $input['case_sheet_id'] ?? null;
$field = $input['field'] ?? null;
$value = $input['value'] ?? null;

if (!$case_sheet_id || !$field) {
	echo json_encode(['success' => false, 'message' => 'Missing required parameters']);
	exit;
}

// Whitelist of allowed direct columns
$allowed_columns = [
	'visit_type', 'chief_complaint', 'history_present_illness',
	'prescriptions', 'advice', 'follow_up_date',
	'referral_to', 'referral_reason', 'follow_up_notes', 'disposition',
];

// Fields stored inside vitals_json (vitals, personal/reproductive, general exam)
$vitals_fields = [
	'bp_systolic', 'bp_diastolic', 'pulse', 'temperature',
	'weight_kg', 'height_cm', 'spo2', 'respiratory_rate', 'blood_sugar',
	'bmi', 'obesity_overweight',
	// Personal tab fields
	'symptoms_complaints', 'duration_of_symptoms',
	'number_of_children', 'has_uterus',
	'type_of_delivery', 'delivery_location', 'delivery_source',
	'menstrual_age_of_onset', 'menstrual_cycle_frequency',
	'menstrual_duration_of_flow', 'menstrual_lmp', 'menstrual_mh',
	// General tab fields
	'general_pulse', 'general_bp_systolic', 'general_bp_diastolic',
	'general_height', 'general_weight', 'general_bmi', 'general_obesity_overweight',
	'general_heart', 'general_lungs', 'general_liver', 'general_spleen', 'general_lymph_glands',
];

// Fields stored inside exam_notes (JSON) — examinations tab
$exam_fields = [
	'exam_mouth', 'exam_lips', 'exam_buccal_mucosa',
	'exam_teeth', 'exam_tongue', 'exam_oropharynx',
	'exam_hypo', 'exam_naso_pharynx', 'exam_larynx',
	'exam_nose', 'exam_ears', 'exam_neck',
	'exam_bones_joints', 'exam_abdomen_genital',
	'exam_breast_left', 'exam_breast_right', 'exam_breast_axillary_nodes',
	'exam_pelvic_cervix', 'exam_pelvic_uterus', 'exam_pelvic_ovaries', 'exam_pelvic_adnexa',
	'exam_rectal_skin', 'exam_rectal_remarks',
	'exam_gynae_ps', 'exam_gynae_pv', 'exam_gynae_via', 'exam_gynae_vili',
];

// Fields stored inside assessment (JSON) — history tab
$history_fields = [
	'condition_dm', 'condition_htn', 'condition_tsh', 'condition_heart_disease',
	'condition_others', 'surgical_history',
	'family_history_cancer', 'family_history_tuberculosis', 'family_history_diabetes',
	'family_history_bp', 'family_history_thyroid', 'family_history_other',
];

// Fields stored inside diagnosis (JSON) — labs tab
$lab_fields = [
	'lab_hb_percentage', 'lab_hb_gms', 'lab_fbs', 'lab_tsh', 'lab_sr_creatinine',
	'lab_others',
	'cytology_papsmear', 'cytology_papsmear_notes',
	'cytology_colposcopy', 'cytology_colposcopy_notes',
	'cytology_biopsy', 'cytology_biopsy_notes',
];

// Fields stored inside plan_notes (JSON) — summary tab
$summary_fields = [
	'summary_risk_level', 'summary_referral',
	'summary_patient_acceptance', 'summary_doctor_summary',
];

/**
 * Merge a field into a JSON column.
 */
function mergeJsonField(PDO $pdo, string $column, string $field, $value, $case_sheet_id): void
{
	$stmt = $pdo->prepare("SELECT `$column` FROM case_sheets WHERE case_sheet_id = ?");
	$stmt->execute([$case_sheet_id]);
	$currentJson = $stmt->fetchColumn();
	$data = ($currentJson && is_string($currentJson)) ? json_decode($currentJson, true) : [];
	if (!is_array($data)) {
		$data = [];
	}
	$data[$field] = $value;

	$pdo->prepare("UPDATE case_sheets SET `$column` = ?, updated_at = NOW() WHERE case_sheet_id = ?")
	    ->execute([json_encode($data), $case_sheet_id]);
}

try {
	if (in_array($field, $allowed_columns, true)) {
		$stmt = $pdo->prepare(
			"UPDATE case_sheets SET `$field` = ?, updated_at = NOW() WHERE case_sheet_id = ?"
		);
		$stmt->execute([$value, $case_sheet_id]);
	} elseif (in_array($field, $vitals_fields, true)) {
		mergeJsonField($pdo, 'vitals_json', $field, $value, $case_sheet_id);
	} elseif (in_array($field, $exam_fields, true)) {
		mergeJsonField($pdo, 'exam_notes', $field, $value, $case_sheet_id);
	} elseif (in_array($field, $history_fields, true)) {
		mergeJsonField($pdo, 'assessment', $field, $value, $case_sheet_id);
	} elseif (in_array($field, $lab_fields, true)) {
		mergeJsonField($pdo, 'diagnosis', $field, $value, $case_sheet_id);
	} elseif (in_array($field, $summary_fields, true)) {
		mergeJsonField($pdo, 'plan_notes', $field, $value, $case_sheet_id);
	} else {
		echo json_encode(['success' => false, 'message' => 'Invalid field']);
		exit;
	}

	echo json_encode(['success' => true, 'message' => 'Case sheet updated', 'field' => $field]);
} catch (PDOException $e) {
	error_log('Database error in update_case_sheet.php: ' . $e->getMessage());
	echo json_encode(['success' => false, 'message' => 'A database error occurred.']);
}
