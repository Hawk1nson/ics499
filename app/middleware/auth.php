<?php
/**
 * app/middleware/auth.php
 *
 * Session-based authentication guard.
 * Require this file at the top of every protected entry-point.
 * Unauthenticated requests are redirected to login.php.
 */

require_once __DIR__ . '/../config/session.php';

if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit;
}
?>
