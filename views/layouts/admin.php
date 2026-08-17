<!doctype html>
<html lang="bn">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($title ?? 'Admin') ?> — Bytewise Admin</title>
    <link rel="stylesheet" href="<?= e(asset('css/app.css')) ?>">
    <link rel="stylesheet" href="<?= e(asset('css/admin.css')) ?>">
</head>
<body class="admin-body">
<?php if (($admin ?? false)): ?>
<nav class="admin-nav">
    <a class="brand" href="<?= e(url('/admin/dashboard')) ?>">Bytewise Admin</a>
    <form method="post" action="<?= e(url('/admin/logout')) ?>">
        <?= csrf_field() ?>
        <button type="submit" class="btn btn-link">Logout</button>
    </form>
</nav>
<?php endif; ?>
<main class="admin-main">
<?php if (!empty($notice)): ?>
    <div class="notice notice-<?= e($notice['type']) ?>" role="status" aria-live="polite"><?= e($notice['text']) ?></div>
<?php endif; ?>
<?= $content ?? '' ?>
</main>
<script src="<?= e(asset('js/app.js')) ?>" defer></script>
</body>
</html>
