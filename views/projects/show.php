<?php $this->layout('layouts/public', ['title' => $project['title_bn']]); ?>
<?php
$statusLabels = [
    'pending'            => 'রিভিউ হচ্ছে…',
    'approved'           => '✓ Approved',
    'changes_requested'  => 'পরিবর্তন প্রয়োজন',
];
$isHybrid = count($eligibility['languages']) > 1;
?>
<section class="project-page">
    <h1><?= e($project['title_bn']) ?></h1>

    <div class="language-chips">
        <?php foreach ($eligibility['languages'] as $entry): ?>
            <span class="language-chip <?= $entry['complete'] ? 'is-complete' : '' ?>">
                <?= $entry['complete'] ? '✓' : '' ?> <?= e($entry['language']['name_bn']) ?>
                <?php if (!$entry['complete']): ?>(<?= e((string) $entry['percent']) ?>%)<?php endif; ?>
            </span>
        <?php endforeach; ?>
        <?php if ($isHybrid): ?><span class="hybrid-badge">Hybrid</span><?php endif; ?>
    </div>

    <div class="project-brief"><?= \App\Support\Markdown::toHtml($project['brief_md']) ?></div>

    <h2>Rubric</h2>
    <div class="project-rubric"><?= \App\Support\Markdown::toHtml($project['rubric_md']) ?></div>

    <?php if (!empty($project['starter_repo_notes'])): ?>
        <p class="hint"><?= e($project['starter_repo_notes']) ?></p>
    <?php endif; ?>

    <?php if ($submission !== null): ?>
        <div class="submission-status-card">
            <p>স্ট্যাটাস: <strong><?= e($statusLabels[$submission['review_status']] ?? $submission['review_status']) ?></strong></p>
            <?php if (!empty($submission['reviewer_notes'])): ?>
                <p>Admin নোট: <?= e($submission['reviewer_notes']) ?></p>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <?php if ($submission === null || $submission['review_status'] === 'changes_requested'): ?>
        <?php if ($eligibility['ready']): ?>
            <form method="post" action="<?= e(url('/projects/' . $project['id'] . '/submit')) ?>" class="project-submit-form">
                <?= csrf_field() ?>
                <label for="submission_link">আপনার কাজের লিংক (GitHub/CodePen ইত্যাদি)</label>
                <input type="url" id="submission_link" name="submission_link" placeholder="https://github.com/..." required>
                <label for="student_notes">নোট (ঐচ্ছিক)</label>
                <textarea id="student_notes" name="student_notes" rows="3"></textarea>
                <button type="submit" class="btn btn-accent">জমা দিন</button>
            </form>
        <?php else: ?>
            <div class="lesson-locked-card">
                <p>🔒 এই প্রজেক্ট জমা দিতে হলে উপরের সব ভাষা ট্র্যাক ১০০% সম্পন্ন করতে হবে।</p>
                <?php foreach ($eligibility['languages'] as $entry): ?>
                    <?php if (!$entry['complete']): ?>
                        <a href="<?= e(url('/courses/' . $entry['language']['slug'])) ?>" class="btn btn-accent">
                            <?= e($entry['language']['name_bn']) ?> চালিয়ে যান (<?= e((string) $entry['percent']) ?>%)
                        </a>
                    <?php endif; ?>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    <?php endif; ?>
</section>
