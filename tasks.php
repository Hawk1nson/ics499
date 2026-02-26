<?php
/**
 * tasks.php – To-Do / Task List entry-point (all authenticated users).
 */

require_once __DIR__ . '/app/config/session.php';

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

require_once __DIR__ . '/app/middleware/auth.php';
require_once __DIR__ . '/app/controllers/TaskController.php';

$controller = new TaskController();
$controller->index();
