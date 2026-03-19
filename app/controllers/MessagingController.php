<?php
/**
 * app/controllers/MessagingController.php
 *
 * Internal messaging between users.
 * All authenticated users have RW access (no additional role guard required
 * beyond session authentication, which is enforced by app/middleware/auth.php).
 */

require_once __DIR__ . '/../config/database.php';

class MessagingController
{
	public function index(): void
	{
		$action = $_GET['action'] ?? 'inbox';

		if ($action === 'compose') {
			$this->compose();
		} elseif ($action === 'view' && isset($_GET['id'])) {
			$this->view((int)$_GET['id']);
		} elseif ($action === 'sent') {
			$this->sent();
		} else {
			$this->inbox();
		}
	}

	// ── Inbox ────────────────────────────────────────────────

	private function inbox(): void
	{
		$pdo    = getDBConnection();
		$userId = (int)$_SESSION['user_id'];

		$flashSuccess = null;
		if (isset($_SESSION['messages_success'])) {
			$flashSuccess = $_SESSION['messages_success'];
			unset($_SESSION['messages_success']);
		}

		$flashError = null;
		if (isset($_SESSION['messages_error'])) {
			$flashError = $_SESSION['messages_error'];
			unset($_SESSION['messages_error']);
		}

		$stmt = $pdo->prepare(
			'SELECT m.*, u.first_name AS sender_first, u.last_name AS sender_last
			   FROM messages m
			   JOIN users u ON m.sender_user_id = u.user_id
			  WHERE m.recipient_user_id = ?
			  ORDER BY m.sent_at DESC'
		);
		$stmt->execute([$userId]);
		$messages = $stmt->fetchAll();

		// Count unread
		$stmt = $pdo->prepare(
			'SELECT COUNT(*) FROM messages WHERE recipient_user_id = ? AND is_read = 0'
		);
		$stmt->execute([$userId]);
		$unreadCount = (int)$stmt->fetchColumn();

		$view = 'inbox';
		require __DIR__ . '/../views/messages.php';
	}

	// ── Sent ─────────────────────────────────────────────────

	private function sent(): void
	{
		$pdo    = getDBConnection();
		$userId = (int)$_SESSION['user_id'];

		$flashSuccess = null;

		$stmt = $pdo->prepare(
			'SELECT m.*, u.first_name AS recipient_first, u.last_name AS recipient_last
			   FROM messages m
			   JOIN users u ON m.recipient_user_id = u.user_id
			  WHERE m.sender_user_id = ?
			  ORDER BY m.sent_at DESC'
		);
		$stmt->execute([$userId]);
		$messages = $stmt->fetchAll();

		$unreadCount = 0;
		$view        = 'sent';
		require __DIR__ . '/../views/messages.php';
	}

	// ── Compose ──────────────────────────────────────────────

	private function compose(): void
	{
		$pdo    = getDBConnection();
		$userId = (int)$_SESSION['user_id'];

		$formError = null;

		if ($_SERVER['REQUEST_METHOD'] === 'POST') {
			$formError = $this->processSend();
			// On success processSend() exits via redirect
		}

		// Fetch active users (excluding self) for recipient dropdown
		$stmt = $pdo->prepare(
			'SELECT user_id, first_name, last_name, role
			   FROM users
			  WHERE is_active = 1 AND user_id != ?
			  ORDER BY last_name, first_name'
		);
		$stmt->execute([$userId]);
		$recipients = $stmt->fetchAll();

		$view = 'compose';
		require __DIR__ . '/../views/messages.php';
	}

	// ── View single message ──────────────────────────────────

	private function view(int $id): void
	{
		$pdo    = getDBConnection();
		$userId = (int)$_SESSION['user_id'];

		$stmt = $pdo->prepare(
			'SELECT m.*,
			        s.first_name AS sender_first,    s.last_name AS sender_last,
			        r.first_name AS recipient_first, r.last_name AS recipient_last
			   FROM messages m
			   JOIN users s ON m.sender_user_id    = s.user_id
			   JOIN users r ON m.recipient_user_id = r.user_id
			  WHERE m.message_id = ?'
		);
		$stmt->execute([$id]);
		$message = $stmt->fetch();

		if (!$message) {
			$_SESSION['messages_error'] = 'Message not found.';
			header('Location: messages.php');
			exit;
		}

		// Only sender or recipient may read the message
		if ((int)$message['sender_user_id'] !== $userId && (int)$message['recipient_user_id'] !== $userId) {
			$_SESSION['messages_error'] = 'You do not have permission to view that message.';
			header('Location: messages.php');
			exit;
		}

		// Mark as read if current user is the recipient
		if ((int)$message['recipient_user_id'] === $userId && !$message['is_read']) {
			$pdo->prepare('UPDATE messages SET is_read = 1 WHERE message_id = ?')
			    ->execute([$id]);
			$message['is_read'] = 1;
		}

		$view = 'view';
		require __DIR__ . '/../views/messages.php';
	}

	// ── Processor ────────────────────────────────────────────

	private function processSend(): ?string
	{
		if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
			return 'Invalid request token.';
		}

		$recipientId = isset($_POST['recipient_user_id']) ? (int)$_POST['recipient_user_id'] : 0;
		$subject     = trim($_POST['subject'] ?? '');
		$body        = trim($_POST['body'] ?? '');

		if ($recipientId <= 0) {
			return 'Please select a recipient.';
		}
		if ($subject === '') {
			return 'Subject is required.';
		}
		if ($body === '') {
			return 'Message body is required.';
		}
		if (strlen($subject) > 200) {
			return 'Subject may not exceed 200 characters.';
		}
		if (strlen($body) > 10000) {
			return 'Message body may not exceed 10,000 characters.';
		}

		// Verify recipient exists and is active
		$pdo  = getDBConnection();
		$stmt = $pdo->prepare('SELECT user_id FROM users WHERE user_id = ? AND is_active = 1');
		$stmt->execute([$recipientId]);
		if (!$stmt->fetch()) {
			return 'Selected recipient does not exist.';
		}

		$stmt = $pdo->prepare(
			'INSERT INTO messages (sender_user_id, recipient_user_id, subject, body)
			 VALUES (?, ?, ?, ?)'
		);
		$stmt->execute([$_SESSION['user_id'], $recipientId, $subject, $body]);

		$_SESSION['messages_success'] = 'Message sent successfully.';
		header('Location: messages.php?action=sent');
		exit;
	}
}
