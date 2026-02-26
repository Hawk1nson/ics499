<?php
/**
 * get_case_sheet.php
 * API endpoint to fetch case sheet information.
 */

error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

require_once __DIR__ . '/app/config/session.php';
require_once __DIR__ . '/app/config/permissions.php';
header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
	echo json_encode(['success' => false, 'message' => 'Unauthorized']);
	exit;
}

if (!can($_SESSION['user_role'] ?? '', 'case_sheets')) {
	echo json_encode(['success' => false, 'message' => 'Forbidden']);
	exit;
}

require_once __DIR__ . '/app/config/database.php';
$pdo = getDBConnection();

$case_sheet_id = $_GET['case_sheet_id'] ?? null;

if (!$case_sheet_id) {
	echo json_encode(['success' => false, 'message' => 'Case sheet ID required']);
	exit;
}

try {
	$stmt = $pdo->prepare('SELECT * FROM case_sheets WHERE case_sheet_id = ?');
	$stmt->execute([$case_sheet_id]);
	$caseSheet = $stmt->fetch(PDO::FETCH_ASSOC);

	if ($caseSheet) {
		echo json_encode(['success' => true, 'case_sheet' => $caseSheet]);
	} else {
		echo json_encode(['success' => false, 'message' => 'Case sheet not found']);
	}
} catch (PDOException $e) {
	error_log('Database error in get_case_sheet.php: ' . $e->getMessage());
	echo json_encode(['success' => false, 'message' => 'A database error occurred.']);
}
