<?php
/**
 * app/views/messages.php
 *
 * Two-panel split layout for tablet-first messaging.
 * $panelOnly = true  → outputs only the right-panel inner HTML (AJAX fragment).
 * $panelOnly = false → outputs the full page (sidebar, left list, right panel).
 */
$roleLabels = [
	'SUPER_ADMIN'         => 'Super Admin',
	'ADMIN'               => 'Admin',
	'DOCTOR'              => 'Doctor',
	'TRIAGE_NURSE'        => 'Triage Nurse',
	'NURSE'               => 'Nurse',
	'PARAMEDIC'           => 'Paramedic',
	'GRIEVANCE_OFFICER'   => 'Grievance Officer',
	'EDUCATION_TEAM'      => 'Education Team',
	'DATA_ENTRY_OPERATOR' => 'Data Entry Operator',
];
?>
<?php if (!($panelOnly ?? false)): ?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Messages | CareSystem</title>
	<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
	<link rel="stylesheet" href="assets/icons/css/all.min.css" />
	<link rel="stylesheet" href="assets/css/adminlte.min.css" />
	<link rel="stylesheet" href="assets/css/theme.css" />
	<style>
		/* ── Two-panel shell ──────────────────────────────────────────── */
		.msg-shell {
			display: flex;
			height: calc(100vh - 57px - 56px - 46px); /* navbar + header + footer */
			min-height: 420px;
		}
		.msg-list-panel {
			width: 38%;
			min-width: 260px;
			max-width: 400px;
			border-right: 1px solid var(--border-soft, #dee2e6);
			display: flex;
			flex-direction: column;
			overflow: hidden;
			flex-shrink: 0;
		}
		.msg-list-tabs {
			display: flex;
			border-bottom: 1px solid var(--border-soft, #dee2e6);
			flex-shrink: 0;
		}
		.msg-list-tab {
			flex: 1;
			padding: 12px 8px;
			text-align: center;
			font-size: .82rem;
			font-weight: 600;
			color: var(--text-muted, #6c757d);
			text-decoration: none;
			border-bottom: 2px solid transparent;
			transition: color .15s, border-color .15s;
		}
		.msg-list-tab:hover { color: var(--brand-primary, #0f8fa9); text-decoration: none; }
		.msg-list-tab.active {
			color: var(--brand-primary, #0f8fa9);
			border-bottom-color: var(--brand-primary, #0f8fa9);
		}
		.msg-list-scroll { flex: 1; overflow-y: auto; }

		/* ── Message rows ─────────────────────────────────────────────── */
		.msg-row {
			display: flex;
			align-items: flex-start;
			padding: 13px 14px;
			border-bottom: 1px solid var(--border-soft, #dee2e6);
			cursor: pointer;
			min-height: 62px;
			text-decoration: none;
			color: inherit;
			transition: background .12s;
		}
		.msg-row:hover { background: rgba(15,143,169,.06); text-decoration: none; color: inherit; }
		.msg-row.msg-active { background: rgba(15,143,169,.13); }
		.msg-row.msg-unread { font-weight: 700; }
		.msg-dot-wrap { width: 14px; flex-shrink: 0; padding-top: 3px; }
		.msg-dot {
			width: 8px; height: 8px; border-radius: 50%;
			background: var(--brand-primary, #0f8fa9);
			display: inline-block;
		}
		.msg-meta { min-width: 0; flex: 1; }
		.msg-from { font-size: .86rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
		.msg-subj { font-size: .77rem; color: var(--text-muted, #6c757d); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }
		.msg-date { font-size: .72rem; color: var(--text-muted, #6c757d); white-space: nowrap; margin-left: 8px; flex-shrink: 0; padding-top: 2px; }

		/* ── Right (content) panel ────────────────────────────────────── */
		.msg-content-panel { flex: 1; overflow-y: auto; background: var(--surface, #f4f6f9); }

		/* ── Welcome state ────────────────────────────────────────────── */
		.msg-welcome {
			height: 100%;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			color: var(--text-muted, #6c757d);
			padding: 2rem;
			text-align: center;
		}

		/* ── Compose / View card ──────────────────────────────────────── */
		.msg-panel-body { padding: 1.5rem; }

		/* ── Chip recipient input ─────────────────────────────────────── */
		.chip-wrap {
			border: 1px solid #ced4da;
			border-radius: .25rem;
			padding: 5px 8px;
			min-height: 44px;
			display: flex;
			flex-wrap: wrap;
			gap: 5px;
			cursor: text;
			background: #fff;
			transition: border-color .15s, box-shadow .15s;
		}
		.chip-wrap:focus-within {
			border-color: #80bdff;
			box-shadow: 0 0 0 .2rem rgba(0,123,255,.25);
		}
		.chip-item {
			display: inline-flex;
			align-items: center;
			background: var(--brand-primary, #0f8fa9);
			color: #fff;
			border-radius: 3px;
			padding: 3px 8px 3px 10px;
			font-size: .82rem;
			line-height: 1.4;
		}
		.chip-remove {
			margin-left: 7px;
			cursor: pointer;
			font-size: 1.1rem;
			line-height: 1;
			opacity: .75;
			background: none;
			border: none;
			color: #fff;
			padding: 0;
		}
		.chip-remove:hover { opacity: 1; }
		.chip-search {
			border: none;
			outline: none;
			flex: 1;
			min-width: 140px;
			font-size: .875rem;
			background: transparent;
			padding: 2px 4px;
			min-height: 32px;
		}
		.chip-dropdown-wrap { position: relative; }
		.chip-dropdown {
			position: absolute;
			z-index: 1055;
			background: #fff;
			border: 1px solid #dee2e6;
			border-radius: .25rem;
			box-shadow: 0 4px 16px rgba(0,0,0,.12);
			max-height: 260px;
			overflow-y: auto;
			width: 100%;
			top: 2px;
		}
		.chip-option {
			padding: 11px 14px;
			cursor: pointer;
			font-size: .875rem;
			display: flex;
			align-items: center;
			justify-content: space-between;
			min-height: 46px;
		}
		.chip-option:hover, .chip-option.chip-highlighted { background: rgba(15,143,169,.08); }
		.chip-option-role { font-size: .75rem; color: #6c757d; }

		/* ── Compose textarea ─────────────────────────────────────────── */
		#msgBody { min-height: 180px; }

		/* ── Mobile: stack panels ─────────────────────────────────────── */
		@media (max-width: 767px) {
			.msg-shell { flex-direction: column; height: auto; }
			.msg-list-panel { width: 100%; max-width: 100%; border-right: none; border-bottom: 1px solid var(--border-soft, #dee2e6); max-height: 45vh; }
			.msg-content-panel { min-height: 50vh; }
		}

		body.dark-mode .chip-wrap { background: #2d3748; border-color: #4a5568; }
		body.dark-mode .chip-dropdown { background: #2d3748; border-color: #4a5568; }
		body.dark-mode .chip-option:hover, body.dark-mode .chip-option.chip-highlighted { background: rgba(15,143,169,.15); }
	</style>
</head>
<body class="hold-transition sidebar-mini layout-fixed layout-navbar-fixed<?= ($_SESSION['font_size'] ?? 'normal') === 'large' ? ' font-size-large' : '' ?>"
      data-theme-server="<?= htmlspecialchars($_SESSION['theme'] ?? 'system') ?>">
<div class="wrapper">

	<nav class="main-header navbar navbar-expand navbar-white navbar-light">
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" data-widget="pushmenu" href="#" role="button" aria-label="Toggle sidebar">
					<i class="fas fa-bars"></i>
				</a>
			</li>
			<li class="nav-item d-none d-sm-inline-block">
				<span class="navbar-brand mb-0 h6 text-primary">CareSystem</span>
			</li>
		</ul>
		<ul class="navbar-nav ml-auto">
			<li class="nav-item d-flex align-items-center">
				<button id="gearBtn" aria-label="Display settings" title="Display settings">
					<i class="fas fa-cog fa-lg"></i>
				</button>
			</li>
			<li class="nav-item">
				<a class="btn btn-sm btn-outline-secondary" href="dashboard.php" role="button">
					<i class="fas fa-arrow-left mr-1"></i>Dashboard
				</a>
			</li>
		</ul>
	</nav>

	<!-- Slide-down display settings panel -->
	<div id="settingsPanel" role="dialog" aria-label="Display settings">
		<span class="panel-label">Display settings</span>
		<div class="custom-control custom-switch mb-3">
			<input type="checkbox" class="custom-control-input" id="themeTogglePanel" data-theme-toggle />
			<label class="custom-control-label" for="themeTogglePanel">Dark mode</label>
		</div>
		<div>
			<span class="panel-label">Language</span>
			<div class="btn-group lang-btn-group" role="group" aria-label="Language">
				<button type="button" class="btn btn-sm <?= ($_SESSION['language'] ?? 'en') === 'en' ? 'btn-primary' : 'btn-outline-secondary' ?>" data-lang="en">English</button>
				<button type="button" class="btn btn-sm <?= ($_SESSION['language'] ?? 'en') === 'te' ? 'btn-primary' : 'btn-outline-secondary' ?>" data-lang="te">తెలుగు</button>
			</div>
		</div>
		<input type="hidden" name="csrf_token" value="<?= htmlspecialchars($_SESSION['csrf_token'] ?? '') ?>">
	</div>

	<?php require __DIR__ . '/_sidebar.php'; ?>

	<div class="content-wrapper" style="overflow:hidden">

		<!-- Page header -->
		<div class="content-header" style="padding-bottom:.5rem">
			<div class="container-fluid">
				<div class="row align-items-center">
					<div class="col-sm-6">
						<h1 class="m-0 text-dark" style="font-size:1.3rem">
							Messages
							<?php if (!empty($unreadCount)): ?>
							<span class="badge badge-danger ml-1"><?= (int)$unreadCount ?></span>
							<?php endif; ?>
						</h1>
					</div>
					<div class="col-sm-6 text-right">
						<a href="messages.php?action=compose" id="composeBtn"
						   class="btn btn-primary btn-sm">
							<i class="fas fa-pen mr-1"></i>Compose
						</a>
					</div>
				</div>
			</div>
		</div>

		<?php if (!empty($flashSuccess) || !empty($flashError)): ?>
		<div class="container-fluid px-3 pb-1">
			<?php if (!empty($flashSuccess)): ?>
			<div class="alert alert-success alert-dismissible fade show py-2 mb-1" role="alert">
				<i class="fas fa-check-circle mr-1"></i><?= htmlspecialchars($flashSuccess) ?>
				<button type="button" class="close py-2" data-dismiss="alert"><span>&times;</span></button>
			</div>
			<?php endif; ?>
			<?php if (!empty($flashError)): ?>
			<div class="alert alert-danger alert-dismissible fade show py-2 mb-1" role="alert">
				<i class="fas fa-exclamation-circle mr-1"></i><?= htmlspecialchars($flashError) ?>
				<button type="button" class="close py-2" data-dismiss="alert"><span>&times;</span></button>
			</div>
			<?php endif; ?>
		</div>
		<?php endif; ?>

		<!-- Two-panel shell -->
		<div class="msg-shell">

			<!-- ── LEFT PANEL: message list ── -->
			<div class="msg-list-panel">
				<div class="msg-list-tabs">
					<a href="messages.php"
					   class="msg-list-tab <?= $listTab === 'inbox' ? 'active' : '' ?>"
					   data-panel-url="messages.php?panel=right">
						<i class="fas fa-inbox mr-1"></i>Inbox
						<?php if (!empty($unreadCount)): ?>
						<span class="badge badge-danger ml-1" id="inboxBadge"><?= (int)$unreadCount ?></span>
						<?php endif; ?>
					</a>
					<a href="messages.php?action=sent"
					   class="msg-list-tab <?= $listTab === 'sent' ? 'active' : '' ?>"
					   data-panel-url="messages.php?action=sent&panel=right">
						<i class="fas fa-paper-plane mr-1"></i>Sent
					</a>
				</div>

				<div class="msg-list-scroll" id="msgListScroll">
					<?php if (empty($listMessages)): ?>
					<div class="text-center text-muted py-5" style="font-size:.85rem">
						<?= $listTab === 'sent' ? 'No sent messages.' : 'Your inbox is empty.' ?>
					</div>
					<?php else: ?>
					<?php foreach ($listMessages as $msg): ?>
					<?php
					$msgId   = (int)$msg['message_id'];
					$isUnread = ($listTab === 'inbox' && !$msg['is_read']);
					$isActive = ($rightView === 'view' && isset($message) && (int)$message['message_id'] === $msgId);
					?>
					<a href="messages.php?action=view&id=<?= $msgId ?>"
					   class="msg-row <?= $isUnread ? 'msg-unread' : '' ?> <?= $isActive ? 'msg-active' : '' ?>"
					   data-msg-id="<?= $msgId ?>">
						<div class="msg-dot-wrap">
							<?php if ($isUnread): ?>
							<span class="msg-dot" title="Unread"></span>
							<?php endif; ?>
						</div>
						<div class="msg-meta">
							<div class="msg-from">
								<?php if ($listTab === 'inbox'): ?>
								<?= htmlspecialchars($msg['sender_first'] . ' ' . $msg['sender_last']) ?>
								<?php else: ?>
								<?= htmlspecialchars($msg['recipients_list'] ?? '') ?>
								<?php if (($msg['recipient_count'] ?? 1) > 1): ?>
								<span class="badge badge-secondary" style="font-size:.65rem;vertical-align:middle"><?= (int)$msg['recipient_count'] ?></span>
								<?php endif; ?>
								<?php endif; ?>
							</div>
							<div class="msg-subj"><?= htmlspecialchars($msg['subject']) ?></div>
						</div>
						<div class="msg-date"><?= htmlspecialchars(date('d M', strtotime($msg['sent_at']))) ?></div>
					</a>
					<?php endforeach; ?>
					<?php endif; ?>
				</div>
			</div><!-- /.msg-list-panel -->

			<!-- ── RIGHT PANEL: content ── -->
			<div class="msg-content-panel" id="msgContentPanel">
<?php endif; /* end full-page wrapper */ ?>

<!-- ═══════════════════════════════════════════════════════════════════
     RIGHT PANEL INNER CONTENT  (rendered for both full page and AJAX)
     ═══════════════════════════════════════════════════════════════════ -->

<?php if ($rightView === 'view' && $message): ?>
<!-- ── View message ─────────────────────────────────── -->
<div class="msg-panel-body">
	<?php if (!empty($flashError)): ?>
	<div class="alert alert-danger py-2"><i class="fas fa-exclamation-circle mr-1"></i><?= htmlspecialchars($flashError) ?></div>
	<?php endif; ?>
	<div class="card shadow-sm">
		<div class="card-header">
			<h5 class="card-title mb-0"><?= htmlspecialchars($message['subject']) ?></h5>
		</div>
		<div class="card-body">
			<dl class="row small text-muted mb-3">
				<dt class="col-4 col-sm-2">From</dt>
				<dd class="col-8 col-sm-10 mb-1"><?= htmlspecialchars($message['sender_first'] . ' ' . $message['sender_last']) ?></dd>
				<dt class="col-4 col-sm-2">To</dt>
				<dd class="col-8 col-sm-10 mb-1">
					<?php if (!empty($threadRecipients)): ?>
						<?= htmlspecialchars(implode(', ', array_map(
							fn($r) => $r['first_name'] . ' ' . $r['last_name'],
							$threadRecipients
						))) ?>
					<?php else: ?>
						<?= htmlspecialchars(($message['recipient_first'] ?? '') . ' ' . ($message['recipient_last'] ?? '')) ?>
					<?php endif; ?>
				</dd>
				<dt class="col-4 col-sm-2">Date</dt>
				<dd class="col-8 col-sm-10 mb-0"><?= htmlspecialchars(date('d M Y H:i', strtotime($message['sent_at']))) ?></dd>
			</dl>
			<hr class="mt-2 mb-3" />
			<p class="mb-0" style="white-space:pre-wrap;word-break:break-word"><?= nl2br(htmlspecialchars($message['body'])) ?></p>
		</div>
		<?php if ((int)$message['recipient_user_id'] === (int)$_SESSION['user_id']): ?>
		<div class="card-footer d-flex justify-content-end" style="gap:.5rem">
			<a href="messages.php?action=compose&reply_to=<?= (int)$message['sender_user_id'] ?>&reply_subject=<?= urlencode('Re: ' . $message['subject']) ?>"
			   class="btn btn-outline-primary btn-sm" data-compose-link>
				<i class="fas fa-reply mr-1"></i>Reply
			</a>
			<?php if (count($threadRecipients) > 1): ?>
			<a href="messages.php?action=compose&reply_all_thread=<?= urlencode($message['thread_id']) ?>&reply_subject=<?= urlencode('Re: ' . $message['subject']) ?>"
			   class="btn btn-primary btn-sm" data-compose-link>
				<i class="fas fa-reply-all mr-1"></i>Reply All
			</a>
			<?php endif; ?>
		</div>
		<?php endif; ?>
	</div>
</div>

<?php elseif ($rightView === 'compose'): ?>
<!-- ── Compose ──────────────────────────────────────── -->
<div class="msg-panel-body">
	<?php if (!empty($formError)): ?>
	<div class="alert alert-danger alert-dismissible py-2 mb-3" id="composeError" role="alert">
		<i class="fas fa-exclamation-circle mr-1"></i><?= htmlspecialchars($formError) ?>
		<button type="button" class="close py-2" data-dismiss="alert"><span>&times;</span></button>
	</div>
	<?php endif; ?>
	<div class="card shadow-sm">
		<div class="card-header">
			<h5 class="card-title mb-0"><i class="fas fa-pen mr-2"></i>New Message</h5>
		</div>
		<div class="card-body">
			<form id="composeForm" method="post" action="messages.php?action=compose">
				<input type="hidden" name="csrf_token" value="<?= htmlspecialchars($_SESSION['csrf_token']) ?>" />

				<!-- Recipient chip input -->
				<div class="form-group">
					<label>To <span class="text-danger">*</span></label>
					<div class="chip-dropdown-wrap">
						<div class="chip-wrap" id="chipWrap" tabindex="-1">
							<!-- chips injected here by JS -->
							<input type="text" id="chipSearch" class="chip-search"
							       placeholder="Type a name…"
							       autocomplete="off" />
						</div>
						<div class="chip-dropdown d-none" id="chipDropdown"></div>
					</div>
					<!-- hidden inputs submitted with form -->
					<div id="chipHiddenInputs"></div>
				</div>

				<div class="form-group">
					<label for="msgSubject">Subject <span class="text-danger">*</span></label>
					<input type="text" name="subject" id="msgSubject" class="form-control"
					       maxlength="200" required
					       value="<?= htmlspecialchars($_POST['subject'] ?? $prefillSubject) ?>" />
				</div>

				<div class="form-group mb-2">
					<label for="msgBody">Message <span class="text-danger">*</span></label>
					<textarea name="body" id="msgBody" class="form-control"
					          rows="9" required><?= htmlspecialchars($_POST['body'] ?? '') ?></textarea>
				</div>

				<div class="d-flex justify-content-end" style="gap:.5rem">
					<a href="messages.php" class="btn btn-outline-secondary btn-sm" id="cancelCompose">Cancel</a>
					<button type="submit" class="btn btn-primary btn-sm" id="sendBtn">
						<i class="fas fa-paper-plane mr-1"></i>Send
					</button>
				</div>
			</form>
		</div>
	</div>
</div>

<?php else: ?>
<!-- ── Welcome / empty state ────────────────────────── -->
<div class="msg-welcome">
	<i class="fas fa-envelope-open-text fa-4x mb-3"></i>
	<p class="mb-3">Select a message to read, or compose a new one.</p>
	<a href="messages.php?action=compose" class="btn btn-primary" data-compose-link>
		<i class="fas fa-pen mr-1"></i>Compose
	</a>
</div>
<?php endif; ?>

<!-- ═══════════════════════════════════════════════════════════════════ -->

<?php if (!($panelOnly ?? false)): ?>
			</div><!-- /.msg-content-panel -->
		</div><!-- /.msg-shell -->

	</div><!-- /.content-wrapper -->

	<footer class="main-footer">
		<strong>D3S3 CareSystem</strong>
	</footer>
</div><!-- /.wrapper -->

<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/adminlte.min.js"></script>
<script src="assets/js/theme-toggle.js"></script>
<script>
(function () {
'use strict';

// ── Recipient data for chip input ─────────────────────────────────────
var ALL_USERS = <?= json_encode(array_map(function ($r) use ($roleLabels) {
	return [
		'id'   => (int)$r['user_id'],
		'name' => $r['first_name'] . ' ' . $r['last_name'],
		'role' => $roleLabels[$r['role']] ?? $r['role'],
	];
}, $recipients ?? []), JSON_HEX_TAG | JSON_HEX_AMP) ?>;

var PRESELECTED = <?= json_encode(array_map('intval', $preselectedIds ?? [])) ?>;

// ── Chip input widget ─────────────────────────────────────────────────
var chipWrap    = document.getElementById('chipWrap');
var chipSearch  = document.getElementById('chipSearch');
var chipDrop    = document.getElementById('chipDropdown');
var hiddenWrap  = document.getElementById('chipHiddenInputs');

if (chipWrap) {
	var selected = {};   // id → name map
	var hlIndex  = -1;

	function buildHidden() {
		if (!hiddenWrap) return;
		hiddenWrap.innerHTML = '';
		Object.keys(selected).forEach(function (id) {
			var inp = document.createElement('input');
			inp.type = 'hidden';
			inp.name = 'recipient_user_ids[]';
			inp.value = id;
			hiddenWrap.appendChild(inp);
		});
	}

	function renderChips() {
		// Remove existing chips (keep the search input)
		chipWrap.querySelectorAll('.chip-item').forEach(function (c) { c.remove(); });
		Object.keys(selected).forEach(function (id) {
			var chip = document.createElement('span');
			chip.className = 'chip-item';
			chip.innerHTML =
				'<span>' + escHtml(selected[id]) + '</span>' +
				'<button type="button" class="chip-remove" aria-label="Remove" data-id="' + id + '">&times;</button>';
			chipWrap.insertBefore(chip, chipSearch);
		});
		buildHidden();
	}

	function addChip(id, name) {
		selected[id] = name;
		renderChips();
		chipSearch.value = '';
		closeDrop();
		chipSearch.focus();
	}

	function removeChip(id) {
		delete selected[id];
		renderChips();
	}

	function escHtml(s) {
		return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
	}

	function openDrop(query) {
		if (!chipDrop) return;
		var q = query.toLowerCase().trim();
		var opts = ALL_USERS.filter(function (u) {
			return !(u.id in selected) && (
				u.name.toLowerCase().indexOf(q) !== -1 ||
				u.role.toLowerCase().indexOf(q) !== -1
			);
		}).slice(0, 10);

		if (!opts.length) { closeDrop(); return; }

		chipDrop.innerHTML = opts.map(function (u, i) {
			return '<div class="chip-option" data-id="' + u.id + '" data-name="' + escHtml(u.name) + '" data-idx="' + i + '">' +
				'<span>' + escHtml(u.name) + '</span>' +
				'<span class="chip-option-role">' + escHtml(u.role) + '</span>' +
			'</div>';
		}).join('');
		chipDrop.classList.remove('d-none');
		hlIndex = -1;
	}

	function closeDrop() {
		if (chipDrop) chipDrop.classList.add('d-none');
		hlIndex = -1;
	}

	function highlight(dir) {
		var opts = chipDrop.querySelectorAll('.chip-option');
		if (!opts.length) return;
		opts.forEach(function (o) { o.classList.remove('chip-highlighted'); });
		hlIndex = (hlIndex + dir + opts.length) % opts.length;
		opts[hlIndex].classList.add('chip-highlighted');
		opts[hlIndex].scrollIntoView({ block: 'nearest' });
	}

	chipSearch.addEventListener('input', function () {
		if (this.value.trim()) openDrop(this.value);
		else closeDrop();
	});

	chipSearch.addEventListener('keydown', function (e) {
		if (e.key === 'ArrowDown')  { e.preventDefault(); highlight(1); return; }
		if (e.key === 'ArrowUp')    { e.preventDefault(); highlight(-1); return; }
		if ((e.key === 'Enter' || e.key === 'Tab') && hlIndex >= 0) {
			e.preventDefault();
			var opt = chipDrop.querySelector('.chip-highlighted');
			if (opt) addChip(opt.dataset.id, opt.dataset.name);
			return;
		}
		if (e.key === 'Backspace' && this.value === '') {
			var ids = Object.keys(selected);
			if (ids.length) removeChip(ids[ids.length - 1]);
		}
		if (e.key === 'Escape') closeDrop();
	});

	chipDrop.addEventListener('mousedown', function (e) {
		var opt = e.target.closest('.chip-option');
		if (opt) { e.preventDefault(); addChip(opt.dataset.id, opt.dataset.name); }
	});

	chipWrap.addEventListener('click', function (e) {
		var rm = e.target.closest('.chip-remove');
		if (rm) { removeChip(rm.dataset.id); return; }
		chipSearch.focus();
	});

	document.addEventListener('click', function (e) {
		if (!chipWrap.contains(e.target)) closeDrop();
	});

	// Pre-populate chips (reply / reply-all / POST repopulate)
	PRESELECTED.forEach(function (id) {
		var u = ALL_USERS.find(function (x) { return x.id === id; });
		if (u) addChip(String(u.id), u.name);
	});
}

// ── AJAX right-panel loading ──────────────────────────────────────────
var contentPanel = document.getElementById('msgContentPanel');

function loadPanel(url, pushUrl) {
	if (!contentPanel) return;
	contentPanel.style.opacity = '.5';
	fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
		.then(function (r) { return r.text(); })
		.then(function (html) {
			contentPanel.innerHTML = html;
			contentPanel.style.opacity = '1';
			contentPanel.scrollTop = 0;
			if (pushUrl) history.pushState({ panelUrl: url }, '', pushUrl);
			initPanelScripts();
		})
		.catch(function () { contentPanel.style.opacity = '1'; });
}

function initPanelScripts() {
	// Re-bind compose-link clicks inside the newly loaded panel
	contentPanel.querySelectorAll('[data-compose-link]').forEach(function (el) {
		el.addEventListener('click', function (e) {
			e.preventDefault();
			var href = el.getAttribute('href');
			loadPanel(href + '&panel=right', href);
			updateListActiveRow(null);
		});
	});

	// Re-init chip widget if compose was loaded
	initChipWidget();

	// AJAX compose form submit
	var form = contentPanel.querySelector('#composeForm');
	if (form) {
		form.addEventListener('submit', function (e) {
			e.preventDefault();
			var btn = form.querySelector('#sendBtn');
			if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i>Sending…'; }

			var data = new FormData(form);
			fetch(form.action, {
				method: 'POST',
				headers: { 'X-Requested-With': 'XMLHttpRequest' },
				body: data
			})
			.then(function (r) { return r.json(); })
			.then(function (res) {
				if (res.success) {
					contentPanel.innerHTML =
						'<div class="msg-welcome">' +
						'<i class="fas fa-check-circle fa-4x mb-3 text-success"></i>' +
						'<p class="font-weight-bold mb-3">Sent to ' + res.sent_count +
						' recipient' + (res.sent_count !== 1 ? 's' : '') + '!</p>' +
						'<a href="messages.php?action=compose" class="btn btn-outline-primary" data-compose-link>' +
						'<i class="fas fa-pen mr-1"></i>Compose Another</a>' +
						'</div>';
					history.pushState({}, '', 'messages.php?action=sent');
					// Refresh left panel list
					refreshList('sent');
					initPanelScripts();
				} else {
					if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fas fa-paper-plane mr-1"></i>Send'; }
					showFormError(res.error || 'An error occurred.');
				}
			})
			.catch(function () {
				if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fas fa-paper-plane mr-1"></i>Send'; }
				showFormError('Network error. Please try again.');
			});
		});
	}
}

function showFormError(msg) {
	var el = contentPanel.querySelector('#composeError');
	if (!el) {
		el = document.createElement('div');
		el.id = 'composeError';
		el.className = 'alert alert-danger alert-dismissible py-2 mb-3';
		el.innerHTML = '<button type="button" class="close py-2" data-dismiss="alert"><span>&times;</span></button>';
		var form = contentPanel.querySelector('#composeForm');
		if (form) form.insertBefore(el, form.firstChild);
	}
	el.innerHTML = '<i class="fas fa-exclamation-circle mr-1"></i>' +
		msg.replace(/&/g,'&amp;').replace(/</g,'&lt;') +
		'<button type="button" class="close py-2" data-dismiss="alert"><span>&times;</span></button>';
	el.classList.remove('d-none');
}

function initChipWidget() {
	// Re-run chip init for dynamically loaded compose form
	var cw = contentPanel.querySelector('#chipWrap');
	var cs = contentPanel.querySelector('#chipSearch');
	var cd = contentPanel.querySelector('#chipDropdown');
	var hw = contentPanel.querySelector('#chipHiddenInputs');
	if (!cw || !cs) return;

	var sel2 = {};
	var hlIdx2 = -1;

	function bh2() {
		hw.innerHTML = '';
		Object.keys(sel2).forEach(function (id) {
			var inp = document.createElement('input');
			inp.type = 'hidden'; inp.name = 'recipient_user_ids[]'; inp.value = id;
			hw.appendChild(inp);
		});
	}
	function rc2() {
		cw.querySelectorAll('.chip-item').forEach(function (c) { c.remove(); });
		Object.keys(sel2).forEach(function (id) {
			var chip = document.createElement('span');
			chip.className = 'chip-item';
			chip.innerHTML = '<span>' + esc2(sel2[id]) + '</span><button type="button" class="chip-remove" data-id="' + id + '">&times;</button>';
			cw.insertBefore(chip, cs);
		});
		bh2();
	}
	function addC2(id, name) { sel2[id] = name; rc2(); cs.value = ''; clo2(); cs.focus(); }
	function remC2(id) { delete sel2[id]; rc2(); }
	function esc2(s) { return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

	function opn2(q) {
		q = q.toLowerCase().trim();
		var opts = ALL_USERS.filter(function (u) {
			return !(u.id in sel2) && (u.name.toLowerCase().indexOf(q) !== -1 || u.role.toLowerCase().indexOf(q) !== -1);
		}).slice(0,10);
		if (!opts.length) { clo2(); return; }
		cd.innerHTML = opts.map(function (u, i) {
			return '<div class="chip-option" data-id="' + u.id + '" data-name="' + esc2(u.name) + '" data-idx="' + i + '">' +
				'<span>' + esc2(u.name) + '</span><span class="chip-option-role">' + esc2(u.role) + '</span></div>';
		}).join('');
		cd.classList.remove('d-none');
		hlIdx2 = -1;
	}
	function clo2() { cd.classList.add('d-none'); hlIdx2 = -1; }
	function hl2(dir) {
		var opts = cd.querySelectorAll('.chip-option');
		if (!opts.length) return;
		opts.forEach(function (o) { o.classList.remove('chip-highlighted'); });
		hlIdx2 = (hlIdx2 + dir + opts.length) % opts.length;
		opts[hlIdx2].classList.add('chip-highlighted');
		opts[hlIdx2].scrollIntoView({ block:'nearest' });
	}

	cs.addEventListener('input', function () { this.value.trim() ? opn2(this.value) : clo2(); });
	cs.addEventListener('keydown', function (e) {
		if (e.key === 'ArrowDown')  { e.preventDefault(); hl2(1); return; }
		if (e.key === 'ArrowUp')    { e.preventDefault(); hl2(-1); return; }
		if ((e.key === 'Enter' || e.key === 'Tab') && hlIdx2 >= 0) {
			e.preventDefault();
			var opt = cd.querySelector('.chip-highlighted');
			if (opt) addC2(opt.dataset.id, opt.dataset.name);
			return;
		}
		if (e.key === 'Backspace' && this.value === '') {
			var ids = Object.keys(sel2); if (ids.length) remC2(ids[ids.length-1]);
		}
		if (e.key === 'Escape') clo2();
	});
	cd.addEventListener('mousedown', function (e) {
		var opt = e.target.closest('.chip-option');
		if (opt) { e.preventDefault(); addC2(opt.dataset.id, opt.dataset.name); }
	});
	cw.addEventListener('click', function (e) {
		var rm = e.target.closest('.chip-remove');
		if (rm) { remC2(rm.dataset.id); return; }
		cs.focus();
	});
	document.addEventListener('click', function (e) { if (!cw.contains(e.target)) clo2(); });

	// Pre-select from URL params (reply/reply-all)
	var urlParams = new URLSearchParams(window.location.search);
	var replyTo = urlParams.get('reply_to');
	var replyThread = urlParams.get('reply_all_thread');
	if (replyTo) {
		var u = ALL_USERS.find(function (x) { return String(x.id) === replyTo; });
		if (u) addC2(String(u.id), u.name);
	}
	// Note: reply_all_thread pre-selection is handled server-side via PRESELECTED
	PRESELECTED.forEach(function (id) {
		var u = ALL_USERS.find(function (x) { return x.id === id; });
		if (u && !(u.id in sel2)) addC2(String(u.id), u.name);
	});
}

function updateListActiveRow(msgId) {
	document.querySelectorAll('.msg-row').forEach(function (r) {
		r.classList.toggle('msg-active', String(r.dataset.msgId) === String(msgId));
	});
}

function refreshList(tab) {
	// Simple approach: reload the page to refresh the list after a send
	// Only navigate if we're already on the sent tab or just sent
	var target = tab === 'sent' ? 'messages.php?action=sent' : 'messages.php';
	window.location.href = target;
}

// ── Message row click → AJAX right panel ─────────────────────────────
document.querySelectorAll('.msg-row').forEach(function (row) {
	row.addEventListener('click', function (e) {
		e.preventDefault();
		var msgId = row.dataset.msgId;
		var url   = 'messages.php?action=view&id=' + msgId;
		loadPanel(url + '&panel=right', url);
		updateListActiveRow(msgId);
		// Remove unread dot from this row
		var dot = row.querySelector('.msg-dot');
		if (dot) { dot.remove(); row.classList.remove('msg-unread'); }
		// Decrement badge
		var badge = document.getElementById('inboxBadge');
		if (badge) {
			var n = parseInt(badge.textContent, 10) - 1;
			if (n <= 0) badge.remove(); else badge.textContent = n;
		}
	});
});

// ── Compose button → AJAX right panel ────────────────────────────────
var composeBtn = document.getElementById('composeBtn');
if (composeBtn) {
	composeBtn.addEventListener('click', function (e) {
		e.preventDefault();
		loadPanel('messages.php?action=compose&panel=right', 'messages.php?action=compose');
		updateListActiveRow(null);
	});
}

// ── Init panel scripts on first load ─────────────────────────────────
initPanelScripts();

// ── Browser back/forward ─────────────────────────────────────────────
window.addEventListener('popstate', function (e) {
	var url = window.location.href;
	if (url.indexOf('action=view') !== -1 || url.indexOf('action=compose') !== -1) {
		loadPanel(url + (url.indexOf('?') !== -1 ? '&' : '?') + 'panel=right', null);
	} else if (contentPanel) {
		contentPanel.innerHTML = document.querySelector('.msg-welcome')
			? contentPanel.innerHTML  // already welcome
			: '<div class="msg-welcome"><i class="fas fa-envelope-open-text fa-4x mb-3"></i><p>Select a message or compose a new one.</p></div>';
	}
});

})();
</script>
</body>
</html>
<?php endif; ?>
