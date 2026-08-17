<!doctype html>
<html lang="bn">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($title ?? $appName) ?> — Bytewise (বাইটওয়াইজ)</title>
    <link rel="stylesheet" href="<?= e(asset('css/app.css')) ?>">
</head>
<body>
<?= \App\Core\View::partial('partials/nav') ?>
<main class="site-main">
<?php if (!empty($notice)): ?>
    <div class="notice notice-<?= e($notice['type']) ?>" role="status" aria-live="polite"><?= e($notice['text']) ?></div>
<?php endif; ?>
<?= $content ?? '' ?>
</main>
<?= \App\Core\View::partial('partials/footer') ?>
<script src="<?= e(asset('js/app.js')) ?>" defer></script>
</body>
</html>
