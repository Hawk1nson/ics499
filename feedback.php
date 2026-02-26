<?php
/**
 * feedback.php – Feedback / Grievance Management entry-point.
 */

require_once __DIR__ . '/app/config/session.php';

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

require_once __DIR__ . '/app/middleware/auth.php';
require_once __DIR__ . '/app/controllers/FeedbackController.php';

$controller = new FeedbackController();
$controller->index();
