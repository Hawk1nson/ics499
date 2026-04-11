<?php
/**
 * create_test_portal_accounts.php
 *
 * One-off script to create patient portal test accounts for developers.
 * Run once via browser or CLI, then DELETE this file.
 *
 * Usage: http://localhost/d3s3/create_test_portal_accounts.php
 *   or:  php create_test_portal_accounts.php
 *
 * !! DELETE THIS FILE AFTER USE !!
 */

// Very basic IP guard — only allow localhost
$ip = $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
if (!in_array($ip, ['127.0.0.1', '::1'], true) && PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit('Access denied.');
}

require_once __DIR__ . '/app/config/database.php';

// ── Define the test accounts to create ──────────────────────────────────────
// patient_id must match an existing row in the patients table.
// Adjust IDs and credentials to match your local test data.

$accounts = [
    [
        'patient_id' => 1,
        'email'      => 'patient1@test.local',
        'username'   => 'testpatient1',
        'password'   => 'DevPortal@1',
    ],
    [
        'patient_id' => 2,
        'email'      => 'patient2@test.local',
        'username'   => 'testpatient2',
        'password'   => 'DevPortal@2',
    ],
    [
        'patient_id' => 3,
        'email'      => 'patient3@test.local',
        'username'   => 'testpatient3',
        'password'   => 'DevPortal@3',
    ],
];

// ── Run ──────────────────────────────────────────────────────────────────────

$pdo     = getDBConnection();
$results = [];

foreach ($accounts as $acct) {
    $patientId = (int)$acct['patient_id'];

    // Check patient exists
    $stmt = $pdo->prepare('SELECT first_name, last_name FROM patients WHERE patient_id = ?');
    $stmt->execute([$patientId]);
    $patient = $stmt->fetch();

    if (!$patient) {
        $results[] = "❌ Patient ID {$patientId} not found — skipped.";
        continue;
    }

    // Check no existing account
    $stmt = $pdo->prepare('SELECT patient_account_id FROM patient_accounts WHERE patient_id = ?');
    $stmt->execute([$patientId]);
    if ($stmt->fetch()) {
        $results[] = "⚠️  Patient ID {$patientId} ({$patient['first_name']} {$patient['last_name']}) already has a portal account — skipped.";
        continue;
    }

    // Insert
    try {
        $pdo->prepare(
            'INSERT INTO patient_accounts (patient_id, username, email, password_hash, is_active)
             VALUES (?, ?, ?, ?, 1)'
        )->execute([
            $patientId,
            $acct['username'],
            $acct['email'],
            password_hash($acct['password'], PASSWORD_DEFAULT),
        ]);

        $results[] = "✅ Created portal account for patient ID {$patientId} "
                   . "({$patient['first_name']} {$patient['last_name']}) "
                   . "— login: <strong>{$acct['email']}</strong> / <strong>{$acct['password']}</strong>";
    } catch (Throwable $e) {
        $results[] = "❌ Patient ID {$patientId}: " . htmlspecialchars($e->getMessage());
    }
}

// ── Output ───────────────────────────────────────────────────────────────────

if (PHP_SAPI === 'cli') {
    foreach ($results as $r) {
        echo strip_tags($r) . "\n";
    }
    echo "\nDone. Delete this file now.\n";
} else {
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Create Test Portal Accounts</title>
        <style>
            body { font-family: sans-serif; max-width: 640px; margin: 3rem auto; padding: 0 1rem; }
            h2   { color: #2e7d5e; }
            li   { margin: .5rem 0; line-height: 1.5; }
            .warn { background: #fff3cd; border: 1px solid #ffc107; border-radius: 6px;
                    padding: .75rem 1rem; margin-top: 1.5rem; font-size: .9rem; }
        </style>
    </head>
    <body>
        <h2>Patient Portal — Test Accounts</h2>
        <ul>
            <?php foreach ($results as $r): ?>
            <li><?= $r ?></li>
            <?php endforeach; ?>
        </ul>
        <div class="warn">
            ⚠️ <strong>Delete this file immediately</strong> once you're done:<br />
            <code>rm create_test_portal_accounts.php</code><br /><br />
            Patients log in at: <a href="patient_login.php">patient_login.php</a>
        </div>
    </body>
    </html>
    <?php
}
