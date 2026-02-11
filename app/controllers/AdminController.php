<?php
/**
 * app/controllers/AdminController.php
 *
 * Handles routing and rendering for all admin-related views.
 */

require_once __DIR__ . '/../config/database.php';

class AdminController
{
    public function dashboard(): void
    {
        require __DIR__ . '/../views/admin/dashboard.php';
    }

    // ── User Management ─────────────────────────────────────────

    /**
     * GET  – render the employee list or the edit form.
     * POST – validate and persist an employee edit (PRG on success).
     */
    public function users(): void
    {
        $pdo = getDBConnection();

        // ── Role guard: ADMIN or SUPER_ADMIN only ──────────────
        $stmt = $pdo->prepare('SELECT role FROM users WHERE user_id = ?');
        $stmt->execute([$_SESSION['user_id']]);
        $currentUser = $stmt->fetch();

        if (!in_array($currentUser['role'] ?? '', ['ADMIN', 'SUPER_ADMIN'])) {
            $_SESSION['dashboard_notice'] = 'You do not have permission to access this page.';
            header('Location: dashboard.php');
            exit;
        }

        // ── One-time flash ──────────────────────────────────────
        $flashSuccess = null;
        if (isset($_SESSION['users_success'])) {
            $flashSuccess = $_SESSION['users_success'];
            unset($_SESSION['users_success']);
        }

        // ── Determine view mode ─────────────────────────────────
        $action   = $_GET['action'] ?? 'list';
        $editId   = isset($_GET['id']) ? (int)$_GET['id'] : null;
        $formError = null;
        $editUser = null;

        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            // TODO: Uncomment the registration-code block below once .env is
            //       writable by the web server (chmod 664 .env or similar).
            //       This lets a Super Admin change the registration code from
            //       the User Management page without FTP access.
            //
            // $formAction = $_POST['form_action'] ?? 'edit_user';
            //
            // if ($formAction === 'update_registration_code') {
            //     $regCodeError = $this->processUpdateRegistrationCode($currentUser['role']);
            // } else {

            $formError = $this->processEditUser();
            // Success exits via PRG; reaching here means $formError is the error string.
            $action = 'edit';
            $editUser = [
                'user_id'    => (int)($_POST['user_id']        ?? 0),
                'first_name' => trim($_POST['first_name']      ?? ''),
                'last_name'  => trim($_POST['last_name']       ?? ''),
                'email'      => trim($_POST['email']           ?? ''),
                'username'   => trim($_POST['username']        ?? ''),
                'role'       =>      $_POST['role']            ?? '',
                'is_active'  => isset($_POST['is_active']) ? 1 : 0,
            ];

            // } // end of else block for registration-code feature
        } elseif ($action === 'edit' && $editId !== null) {
            $stmt = $pdo->prepare('SELECT * FROM users WHERE user_id = ?');
            $stmt->execute([$editId]);
            $editUser = $stmt->fetch();
            if (!$editUser) {
                $action = 'list';
            }
        }

        // ── Fetch all users for the list table ──────────────
        $users = $pdo->query(
            'SELECT user_id, first_name, last_name, email, username, role, is_active, last_login_at
                FROM users ORDER BY last_name, first_name'
        )->fetchAll();

        // ── Registration code (read-only display) ────────────
        $registrationCode = getenv('REGISTRATION_CODE') ?: '';

        // TODO: Uncomment when the registration-code EDIT UI is enabled (see TODO above).
        // $regCodeError = $regCodeError ?? null;

        require __DIR__ . '/../views/admin/users.php';
    }

    /**
     * Validate and persist an employee edit.
     * Returns an error string on failure, or exits via redirect on success.
     */
    private function processEditUser(): ?string
    {
        // ── CSRF guard ──────────────────────────────────────────
        if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
            return 'Invalid request.';
        }

        $userId      = (int)($_POST['user_id']          ?? 0);
        $firstName   = trim($_POST['first_name']        ?? '');
        $lastName    = trim($_POST['last_name']         ?? '');
        $email       = trim($_POST['email']             ?? '');
        $username    = trim($_POST['username']          ?? '');
        $role        =      $_POST['role']              ?? '';
        $isActive    = isset($_POST['is_active']) ? 1 : 0;
        $newPassword =      $_POST['new_password']      ?? '';
        $confirmPwd  =      $_POST['confirm_password']  ?? '';

        if ($userId === 0) {
            return 'Invalid user.';
        }

        // ── Basic validation ────────────────────────────────────
        if ($firstName === '' || $lastName === '' || $email === '' || $username === '') {
            return 'All fields are required.';
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return 'Please enter a valid email address.';
        }

        if (!preg_match('/^[a-zA-Z0-9_-]{3,60}$/', $username)) {
            return 'Username must be 3–60 characters (letters, numbers, underscores, or hyphens only).';
        }

        $validRoles = ['SUPER_ADMIN', 'ADMIN', 'DATA_ENTRY_OPERATOR'];
        if (!in_array($role, $validRoles, true)) {
            return 'Invalid role selected.';
        }

        $pdo = getDBConnection();

        // ── Uniqueness checks (exclude current user) ─────────────
        $stmt = $pdo->prepare('SELECT 1 FROM users WHERE email = ? AND user_id != ? LIMIT 1');
        $stmt->execute([$email, $userId]);
        if ($stmt->fetch()) {
            return 'An account with this email already exists.';
        }

        $stmt = $pdo->prepare('SELECT 1 FROM users WHERE username = ? AND user_id != ? LIMIT 1');
        $stmt->execute([$username, $userId]);
        if ($stmt->fetch()) {
            return 'This username is already taken.';
        }

        // ── Build UPDATE ────────────────────────────────────────
        $sets   = ['first_name = ?', 'last_name = ?', 'email = ?',
                    'username = ?', 'role = ?', 'is_active = ?'];
        $params = [$firstName, $lastName, $email, $username, $role, $isActive];

        if ($newPassword !== '') {
            if (strlen($newPassword) < 8) {
                return 'New password must be at least 8 characters.';
            }
            if ($newPassword !== $confirmPwd) {
                return 'Passwords do not match.';
            }
            $sets[]   = 'password_hash = ?';
            $params[] = password_hash($newPassword, PASSWORD_DEFAULT);
        }

        $params[] = $userId;
        $pdo->prepare('UPDATE users SET ' . implode(', ', $sets) . ' WHERE user_id = ?')
            ->execute($params);

        // ── PRG ─────────────────────────────────────────────────
        $_SESSION['users_success'] = 'User updated successfully.';
        header('Location: users.php');
        exit;
    }

    /**
     * Validate and update the REGISTRATION_CODE in .env.
     * Returns an error string on failure, or exits via redirect on success.
     */
    private function processUpdateRegistrationCode(string $currentRole): ?string
    {
        if ($currentRole !== 'SUPER_ADMIN') {
            return 'Only Super Admins can change the registration code.';
        }

        if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
            return 'Invalid request.';
        }

        $newCode = trim($_POST['registration_code'] ?? '');
        if ($newCode === '') {
            return 'Registration code cannot be empty.';
        }

        if (!preg_match('/^[a-zA-Z0-9_@!#$%&*+=?-]{4,100}$/', $newCode)) {
            return 'Code must be 4–100 characters (letters, numbers, and common symbols).';
        }

        // ── Rewrite the .env file ─────────────────────────────
        $envPath = __DIR__ . '/../../.env';
        if (!is_writable($envPath)) {
            return 'Cannot write to .env file. Check file permissions.';
        }

        $lines = file($envPath, FILE_IGNORE_NEW_LINES);
        $found = false;
        foreach ($lines as $i => $line) {
            if (preg_match('/^\s*REGISTRATION_CODE\s*=/', $line)) {
                $lines[$i] = 'REGISTRATION_CODE=' . $newCode;
                $found = true;
                break;
            }
        }
        if (!$found) {
            $lines[] = 'REGISTRATION_CODE=' . $newCode;
        }

        file_put_contents($envPath, implode("\n", $lines) . "\n", LOCK_EX);
        putenv('REGISTRATION_CODE=' . $newCode);

        $_SESSION['users_success'] = 'Registration code updated successfully.';
        header('Location: users.php');
        exit;
    }
}
