<?php $this->layout('layouts/admin', ['title' => 'Project Submissions', 'admin' => true]); ?>
<section class="admin-queue">
    <h1>Project Submissions — Pending Review</h1>
    <?php foreach ($queue as $item): ?>
        <div class="queue-item">
            <p><strong><?= e($item['display_name'] ?: ('Student #' . $item['user_id'])) ?></strong> — <?= e($item['project_title']) ?></p>
            <p><a href="<?= e($item['submission_link']) ?>" target="_blank" rel="noopener noreferrer"><?= e($item['submission_link']) ?></a></p>
            <?php if (!empty($item['student_notes'])): ?><p class="hint"><?= e($item['student_notes']) ?></p><?php endif; ?>
            <form method="post" action="<?= e(url('/admin/project-submissions/' . $item['id'] . '/approve')) ?>" class="inline-form">
                <?= csrf_field() ?>
                <button type="submit" class="btn btn-accent">Approve</button>
            </form>
            <form method="post" action="<?= e(url('/admin/project-submissions/' . $item['id'] . '/changes')) ?>" class="inline-form">
                <?= csrf_field() ?>
                <button type="submit" class="btn btn-link">Request Changes</button>
            </form>
        </div>
    <?php endforeach; ?>
    <?php if (empty($queue)): ?><p>কোনো Pending Submission নেই।</p><?php endif; ?>
</section>
