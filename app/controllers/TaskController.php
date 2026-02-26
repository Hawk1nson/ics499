<?php
/**
 * app/controllers/TaskController.php
 *
 * To-Do / Task list management.
 * All authenticated users have RW access (no additional role guard beyond auth).
 * Admins (SUPER_ADMIN, ADMIN) can view/update/delete any task.
 * Others can only manage tasks they created or tasks assigned to them.
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../config/permissions.php';

class TaskController
{
	public function index(): void
	{
		$action = $_GET['action'] ?? 'list';

		if ($action === 'create') {
			$this->create();
		} elseif ($action === 'delete' && $_SERVER['REQUEST_METHOD'] === 'POST') {
			$this->delete();
		} elseif ($action === 'update' && $_SERVER['REQUEST_METHOD'] === 'POST') {
			$this->update();
		} else {
			$this->listing();
		}
	}

	// ── List ─────────────────────────────────────────────────

	private function listing(): void
	{
		$pdo    = getDBConnection();
		$userId = (int)$_SESSION['user_id'];
		$role   = $_SESSION['user_role'] ?? '';
		$isAdmin = can($role, 'users'); // SUPER_ADMIN / ADMIN

		$flashSuccess = null;
		if (isset($_SESSION['tasks_success'])) {
			$flashSuccess = $_SESSION['tasks_success'];
			unset($_SESSION['tasks_success']);
		}

		$tab = $_GET['tab'] ?? 'mine';

		if ($isAdmin && $tab === 'all') {
			$stmt = $pdo->prepare(
				'SELECT t.*,
				        c.first_name AS creator_first, c.last_name AS creator_last,
				        a.first_name AS assignee_first, a.last_name AS assignee_last
				   FROM tasks t
				   LEFT JOIN users c ON t.created_by_user_id  = c.user_id
				   LEFT JOIN users a ON t.assigned_to_user_id = a.user_id
				  ORDER BY
				        FIELD(t.status,"IN_PROGRESS","PENDING","DONE"),
				        FIELD(t.priority,"HIGH","MEDIUM","LOW"),
				        t.due_date ASC,
				        t.created_at DESC'
			);
			$stmt->execute();
		} else {
			$stmt = $pdo->prepare(
				'SELECT t.*,
				        c.first_name AS creator_first, c.last_name AS creator_last,
				        a.first_name AS assignee_first, a.last_name AS assignee_last
				   FROM tasks t
				   LEFT JOIN users c ON t.created_by_user_id  = c.user_id
				   LEFT JOIN users a ON t.assigned_to_user_id = a.user_id
				  WHERE t.created_by_user_id = ? OR t.assigned_to_user_id = ?
				  ORDER BY
				        FIELD(t.status,"IN_PROGRESS","PENDING","DONE"),
				        FIELD(t.priority,"HIGH","MEDIUM","LOW"),
				        t.due_date ASC,
				        t.created_at DESC'
			);
			$stmt->execute([$userId, $userId]);
		}

		$tasks = $stmt->fetchAll();

		require __DIR__ . '/../views/tasks.php';
	}

	// ── Create ───────────────────────────────────────────────

	private function create(): void
	{
		$pdo    = getDBConnection();
		$userId = (int)$_SESSION['user_id'];

		$formError = null;

		if ($_SERVER['REQUEST_METHOD'] === 'POST') {
			$formError = $this->processCreate();
			// On success exits via redirect
		}

		// Fetch active users for assignment dropdown
		$stmt = $pdo->prepare(
			'SELECT user_id, first_name, last_name, role
			   FROM users
			  WHERE is_active = 1
			  ORDER BY last_name, first_name'
		);
		$stmt->execute();
		$allUsers = $stmt->fetchAll();

		$view = 'create';
		require __DIR__ . '/../views/tasks.php';
	}

	// ── Processors ──────────────────────────────────────────

	private function processCreate(): ?string
	{
		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			return 'Invalid request token.';
		}

		$title       = trim($_POST['title'] ?? '');
		$description = trim($_POST['description'] ?? '');
		$priority    = $_POST['priority'] ?? 'MEDIUM';
		$dueDate     = trim($_POST['due_date'] ?? '');
		$assignedTo  = !empty($_POST['assigned_to_user_id']) ? (int)$_POST['assigned_to_user_id'] : null;

		if ($title === '') {
			return 'Title is required.';
		}
		if (strlen($title) > 200) {
			return 'Title may not exceed 200 characters.';
		}
		if (!in_array($priority, ['LOW', 'MEDIUM', 'HIGH'], true)) {
			return 'Invalid priority value.';
		}
		if ($dueDate !== '' && !preg_match('/^\d{4}-\d{2}-\d{2}$/', $dueDate)) {
			return 'Invalid due date format.';
		}

		$pdo  = getDBConnection();
		$stmt = $pdo->prepare(
			'INSERT INTO tasks (title, description, priority, due_date, assigned_to_user_id, created_by_user_id)
			 VALUES (?, ?, ?, ?, ?, ?)'
		);
		$stmt->execute([
			$title,
			$description ?: null,
			$priority,
			$dueDate ?: null,
			$assignedTo,
			$_SESSION['user_id'],
		]);

		$_SESSION['tasks_success'] = 'Task created successfully.';
		header('Location: tasks.php');
		exit;
	}

	private function update(): void
	{
		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			$_SESSION['tasks_error'] = 'Invalid request token.';
			header('Location: tasks.php');
			exit;
		}

		$taskId  = isset($_POST['task_id']) ? (int)$_POST['task_id'] : 0;
		$status  = $_POST['status'] ?? '';
		$role    = $_SESSION['user_role'] ?? '';
		$userId  = (int)$_SESSION['user_id'];
		$isAdmin = can($role, 'users');

		$validStatuses = ['PENDING', 'IN_PROGRESS', 'DONE'];
		if (!in_array($status, $validStatuses, true) || $taskId <= 0) {
			header('Location: tasks.php');
			exit;
		}

		$pdo  = getDBConnection();
		$stmt = $pdo->prepare('SELECT * FROM tasks WHERE task_id = ?');
		$stmt->execute([$taskId]);
		$task = $stmt->fetch();

		if (!$task) {
			header('Location: tasks.php');
			exit;
		}

		// Only owner, assignee, or admin may update
		if (!$isAdmin
			&& (int)$task['created_by_user_id'] !== $userId
			&& (int)($task['assigned_to_user_id'] ?? 0) !== $userId
		) {
			header('Location: tasks.php');
			exit;
		}

		$pdo->prepare('UPDATE tasks SET status = ? WHERE task_id = ?')
		    ->execute([$status, $taskId]);

		$_SESSION['tasks_success'] = 'Task updated.';
		header('Location: tasks.php');
		exit;
	}

	private function delete(): void
	{
		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			header('Location: tasks.php');
			exit;
		}

		$taskId  = isset($_POST['task_id']) ? (int)$_POST['task_id'] : 0;
		$role    = $_SESSION['user_role'] ?? '';
		$userId  = (int)$_SESSION['user_id'];
		$isAdmin = can($role, 'users');

		if ($taskId <= 0) {
			header('Location: tasks.php');
			exit;
		}

		$pdo  = getDBConnection();
		$stmt = $pdo->prepare('SELECT created_by_user_id FROM tasks WHERE task_id = ?');
		$stmt->execute([$taskId]);
		$task = $stmt->fetch();

		if (!$task) {
			header('Location: tasks.php');
			exit;
		}

		if (!$isAdmin && (int)$task['created_by_user_id'] !== $userId) {
			header('Location: tasks.php');
			exit;
		}

		$pdo->prepare('DELETE FROM tasks WHERE task_id = ?')->execute([$taskId]);

		$_SESSION['tasks_success'] = 'Task deleted.';
		header('Location: tasks.php');
		exit;
	}
}
