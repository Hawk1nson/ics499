<?php
/**
 * emp_register.php – create-employee entry-point.
 */

require_once __DIR__ . '/app/config/session.php';

if (!isset($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

require_once __DIR__ . '/app/controllers/UserController.php';

$controller = new UserController();
$controller->createAccount();
?>
