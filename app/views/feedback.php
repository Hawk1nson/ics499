<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>Feedback | CareSystem</title>
	<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
	<link rel="stylesheet" href="assets/icons/css/all.min.css" />
	<link rel="stylesheet" href="assets/css/adminlte.min.css" />
	<link rel="stylesheet" href="assets/css/theme.css" />
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
			<li class="nav-item d-flex align-items-center mr-3">
				<div class="custom-control custom-switch theme-switch">
					<input type="checkbox" class="custom-control-input" id="themeToggleFeedback" data-theme-toggle />
					<label class="custom-control-label" for="themeToggleFeedback">Dark mode</label>
				</div>
			</li>
			<li class="nav-item">
				<a class="btn btn-sm btn-outline-secondary" href="dashboard.php" role="button">
					<i class="fas fa-arrow-left mr-1"></i>Dashboard
				</a>
			</li>
		</ul>
	</nav>

	<?php require __DIR__ . '/_sidebar.php'; ?>

	<div class="content-wrapper">
		<div class="content-header">
			<div class="container-fluid">
				<div class="row mb-2 align-items-center">
					<div class="col-sm-6">
						<h1 class="m-0 text-dark">Feedback &amp; Grievances</h1>
						<p class="text-muted mb-0"><?= $canWrite ? 'Submit and manage feedback records.' : 'View submitted feedback.' ?></p>
					</div>
					<?php if ($canWrite): ?>
					<div class="col-sm-6 text-right">
						<a href="feedback.php?action=submit" class="btn btn-primary">
							<i class="fas fa-plus mr-1"></i>Submit Feedback
						</a>
					</div>
					<?php endif; ?>
				</div>
			</div>
		</div>

		<section class="content">
			<div class="container-fluid">

				<?php if ($flashSuccess !== null): ?>
				<div class="alert alert-success alert-dismissible fade show" role="alert">
					<i class="fas fa-check-circle mr-2"></i><?= htmlspecialchars($flashSuccess) ?>
					<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<?php endif; ?>

				<?php
				$statusColors = [
					'OPEN'         => 'badge-danger',
					'UNDER_REVIEW' => 'badge-warning',
					'RESOLVED'     => 'badge-success',
					'CLOSED'       => 'badge-secondary',
				];
				$statusLabels = [
					'OPEN'         => 'Open',
					'UNDER_REVIEW' => 'Under Review',
					'RESOLVED'     => 'Resolved',
					'CLOSED'       => 'Closed',
				];
				?>

				<div class="card">
					<div class="card-header border-0">
						<h3 class="card-title mb-0">
							<i class="fas fa-comment-dots mr-2 text-primary"></i>Feedback Records
						</h3>
					</div>
					<div class="card-body p-0">
						<div class="table-responsive">
							<table class="table table-hover mb-0">
								<thead class="thead-light">
									<tr>
										<th>#</th>
										<th>Subject</th>
										<th>Status</th>
										<?php if ($canWrite): ?><th>Submitted By</th><?php endif; ?>
										<th>Date</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<?php foreach ($feedbackList as $item): ?>
									<tr>
										<td class="text-muted small"><?= (int)$item['feedback_id'] ?></td>
										<td><?= htmlspecialchars($item['subject']) ?></td>
										<td>
											<span class="badge <?= $statusColors[$item['status']] ?? 'badge-secondary' ?>">
												<?= $statusLabels[$item['status']] ?? htmlspecialchars($item['status']) ?>
											</span>
										</td>
										<?php if ($canWrite): ?>
										<td><?= htmlspecialchars($item['submitter_first'] . ' ' . $item['submitter_last']) ?></td>
										<?php endif; ?>
										<td class="text-muted small"><?= htmlspecialchars(date('d M Y', strtotime($item['created_at']))) ?></td>
										<td>
											<a href="feedback.php?action=view&amp;id=<?= (int)$item['feedback_id'] ?>"
											   class="btn btn-sm btn-outline-primary">
												<i class="fas fa-eye mr-1"></i>View
											</a>
										</td>
									</tr>
									<?php endforeach; ?>
									<?php if (empty($feedbackList)): ?>
									<tr>
										<td colspan="6" class="text-center text-muted py-4">No feedback records found.</td>
									</tr>
									<?php endif; ?>
								</tbody>
							</table>
						</div>
					</div>
				</div>

			</div>
		</section>
	</div>

	<footer class="main-footer">
		<strong>D3S3 CareSystem</strong>
	</footer>
</div>
<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/adminlte.min.js"></script>
<script src="assets/js/theme.js"></script>
</body>
</html>
