<?php
/**
 * demonstrating GitHub.
 * index.php – application entry-point.
 *
 * Redirects authenticated users to the dashboard;
 * everyone else lands on the login page.
 */

require_once __DIR__ . '/app/config/session.php';

header('Location: ' . (isset($_SESSION['user_id']) ? 'dashboard.php' : 'login.php'));
exit;
?>
