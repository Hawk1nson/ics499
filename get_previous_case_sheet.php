<?php
/**
 * get_previous_case_sheet.php
 * API endpoint to fetch the most recent previous case sheet for a patient.
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

require_once __DIR__ . '/app/config/database.php';
$pdo = getDBConnection();

$patient_id = $_GET['patient_id'] ?? null;
$current_case_sheet_id = $_GET['current_case_sheet_id'] ?? null;

if (!$patient_id || !$current_case_sheet_id) {
	echo json_encode(['success' => false, 'message' => 'Patient ID and current case sheet ID required']);
	exit;
}

try {
	$stmt = $pdo->prepare(
		'SELECT case_sheet_id, visit_datetime, visit_type, status,
		        chief_complaint, history_present_illness,
		        vitals_json, assessment, diagnosis, plan_notes
		   FROM case_sheets
		  WHERE patient_id = ?
		    AND case_sheet_id < ?
		  ORDER BY case_sheet_id DESC
		  LIMIT 1'
	);
	$stmt->execute([$patient_id, $current_case_sheet_id]);
	$previous = $stmt->fetch(PDO::FETCH_ASSOC);

	if ($previous) {
		echo json_encode(['success' => true, 'previous_case_sheet' => $previous]);
	} else {
		echo json_encode(['success' => false, 'message' => 'No previous case sheet found']);
	}
} catch (PDOException $e) {
	error_log('Database error in get_previous_case_sheet.php: ' . $e->getMessage());
	echo json_encode(['success' => false, 'message' => 'A database error occurred.']);
}
