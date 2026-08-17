<?php $this->layout('layouts/admin', ['title' => 'Content Import', 'admin' => true]); ?>
<section>
    <h1>Content Import — Lessons CSV</h1>
    <p>Header row required: <code>module_id,slug,title_bn,title_en,body_md,code_sample,code_sample_language,xp_reward,is_free_preview,sort_order</code></p>

    <form method="post" action="<?= e(url('/admin/content-import')) ?>" enctype="multipart/form-data" class="admin-form">
        <?= csrf_field() ?>
        <input type="file" name="csv" accept=".csv" required>
        <button type="submit" class="btn btn-accent">Import</button>
    </form>

    <?php if ($report !== null): ?>
        <?php if (isset($report['error'])): ?>
            <p class="form-error"><?= e($report['error']) ?></p>
        <?php else: ?>
            <h2>Import Report</h2>
            <p><?= count($report['ok']) ?> imported, <?= count($report['skipped']) ?> skipped.</p>
            <?php foreach ($report['ok'] as $line): ?><p class="report-ok"><?= e($line) ?></p><?php endforeach; ?>
            <?php foreach ($report['skipped'] as $line): ?><p class="report-skip"><?= e($line) ?></p><?php endforeach; ?>
        <?php endif; ?>
    <?php endif; ?>
</section>
