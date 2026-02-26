<?php
/**
 * messages.php – Internal Messaging entry-point (all authenticated users).
 */

require_once __DIR__ . '/app/config/session.php';

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

require_once __DIR__ . '/app/middleware/auth.php';
require_once __DIR__ . '/app/controllers/MessagingController.php';

$controller = new MessagingController();
$controller->index();
