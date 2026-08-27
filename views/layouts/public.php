<!doctype html>
<html lang="bn">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csp-nonce" content="<?= e($cspNonce ?? '') ?>">
    <title><?= e($title ?? $appName) ?> — Bytewise (বাইটওয়াইজ)</title>
    <link rel="stylesheet" href="<?= e(asset('dist/styles.css')) ?>">
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
<?php foreach ($extraScripts ?? [] as $src): ?>
<script type="module" src="<?= e(asset($src)) ?>"></script>
<?php endforeach; ?>
<script type="module" src="<?= e(asset('dist/main.js')) ?>"></script>
</body>
</html>
