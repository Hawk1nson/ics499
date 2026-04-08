<?php
/**
 * update_patient.php
 * API endpoint to update patient information from case sheet verification tab.
 *
 * Every field write is whitelisted before touching the DB.
 */

require_once __DIR__ . '/app/config/session.php';
require_once __DIR__ . '/app/config/permissions.php';
header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
	echo json_encode(['success' => false, 'message' => 'Unauthorized']);
	exit;
}

if (!can($_SESSION['user_role'] ?? '', 'patient_data', 'W')) {
	echo json_encode(['success' => false, 'message' => 'Forbidden']);
	exit;
}

// Accept JSON body
$input = json_decode(file_get_contents('php://input'), true);
if (!$input) {
	echo json_encode(['success' => false, 'message' => 'Invalid input']);
	exit;
}

// CSRF check
$token = $input['csrf_token'] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? '');
if (!hash_equals($_SESSION['csrf_token'] ?? '', $token)) {
	echo json_encode(['success' => false, 'message' => 'Invalid request token.']);
	exit;
}

require_once __DIR__ . '/app/config/database.php';
$pdo = getDBConnection();

$patientId = (int)($input['patient_id'] ?? 0);
$field     = $input['field'] ?? null;
$value     = $input['value'] ?? null;

if (!$patientId || !$field) {
	echo json_encode(['success' => false, 'message' => 'Missing required parameters']);
	exit;
}

// Whitelist of allowed fields to update
$allowedFields = [
	'first_name', 'last_name', 'aadhaar_number',
	'age_years', 'sex', 'date_of_birth',
	'address_line1', 'address_line2', 'city', 'state_province', 'postal_code',
	'phone_e164', 'emergency_contact_name', 'emergency_contact_phone',
	'blood_group', 'allergies',
	'medicine_sources', 'occupation', 'education', 'diet',
];

if (!in_array($field, $allowedFields, true)) {
	echo json_encode(['success' => false, 'message' => 'Invalid field']);
	exit;
}

// Defence-in-depth: after whitelist check, assert $field is a safe SQL identifier.
// PDO cannot parameterize column names; the whitelist above is the primary guard,
// but this regex ensures interpolation is safe even if the whitelist is ever misedited.
if (!preg_match('/^[a-z][a-z0-9_]*$/', $field)) {
	echo json_encode(['success' => false, 'message' => 'Invalid field']);
	exit;
}

try {
	$stmt = $pdo->prepare("UPDATE patients SET `$field` = :value, updated_at = NOW() WHERE patient_id = :patient_id");
	$stmt->execute([':value' => $value, ':patient_id' => $patientId]);

	echo json_encode(['success' => true, 'field' => $field]);

} catch (PDOException $e) {
	error_log('Database error in update_patient.php: ' . $e->getMessage());
	echo json_encode(['success' => false, 'message' => 'A database error occurred.']);
}
