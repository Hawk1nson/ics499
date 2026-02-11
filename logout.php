<?php
require_once __DIR__ . '/app/config/session.php';
session_destroy();
header('Location: login.php');
exit;
?>
