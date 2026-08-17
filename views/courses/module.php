<?php $this->layout('layouts/public', ['title' => $module['title_bn']]); ?>
<?php
$statusLabel = [
    'completed'    => '✓ সম্পন্ন',
    'in_progress'  => 'চলছে',
    'not_started'  => 'শুরু হয়নি',
];
?>
<section class="module-page">
    <p class="hint"><a href="<?= e(url('/courses/' . $language['slug'])) ?>">← <?= e($language['name_bn']) ?> ট্র্যাকে ফিরে যান</a></p>
    <h1><?= e($module['title_bn']) ?></h1>

    <?php if (empty($lessons)): ?>
        <p class="hint">এই মডিউলে এখনো কোনো লেসন যোগ করা হয়নি — শীঘ্রই আসছে।</p>
    <?php else: ?>
        <ol class="lesson-list">
            <?php foreach ($lessons as $lesson): ?>
                <?php $status = $progress[$lesson['id']]['status'] ?? 'not_started'; ?>
                <li class="lesson-list-item status-<?= e($status) ?>">
                    <a href="<?= e(url('/lessons/' . $lesson['id'])) ?>">
                        <span class="lesson-status-icon"><?= $status === 'completed' ? '✓' : ($status === 'in_progress' ? '●' : '○') ?></span>
                        <span class="lesson-list-title"><?= e($lesson['title_bn']) ?></span>
                        <span class="lesson-list-status"><?= e($statusLabel[$status] ?? $status) ?></span>
                    </a>
                </li>
            <?php endforeach; ?>
        </ol>
    <?php endif; ?>
</section>
