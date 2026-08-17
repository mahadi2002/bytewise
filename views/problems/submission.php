<?php $this->layout('layouts/public', ['title' => 'সাবমিশন ফলাফল']); ?>
<?php
$statusLabels = [
    'queued'  => 'যাচাই করা হচ্ছে…',
    'running' => 'যাচাই করা হচ্ছে…',
    'passed'  => '✓ Passed',
    'failed'  => '✗ Failed',
    'compile_error' => 'Compile Error',
    'runtime_error' => 'Runtime Error',
    'time_limit_exceeded' => 'Time Limit Exceeded',
    'memory_limit_exceeded' => 'Memory Limit Exceeded',
    'gateway_error' => 'যাচাই করা যায়নি',
];
$isPending = in_array($submission['status'], ['queued', 'running'], true);
?>
<section class="submission-page" data-submission-id="<?= e((string) $submission['id']) ?>" data-pending="<?= $isPending ? '1' : '0' ?>">
    <h1>সাবমিশন ফলাফল</h1>
    <p class="submission-status status-<?= e($submission['status']) ?>"><?= e($statusLabels[$submission['status']] ?? $submission['status']) ?></p>

    <?php if (!$isPending): ?>
        <p><?= e((string) $submission['passed_count']) ?> / <?= e((string) $submission['total_count']) ?> টেস্ট কেস পাস।
            <?php if ((int) $submission['xp_awarded'] > 0): ?>+<?= e((string) $submission['xp_awarded']) ?> XP<?php endif; ?></p>

        <?php if (!empty($submission['stderr_excerpt'])): ?>
            <pre class="code-sample stderr"><?= e($submission['stderr_excerpt']) ?></pre>
        <?php endif; ?>

        <?php foreach ($testResults as $r): ?>
            <div class="test-result <?= $r['passed'] ? 'test-pass' : 'test-fail' ?>">
                <?= $r['passed'] ? '✓' : '✗' ?>
                <?= $r['is_hidden'] ? 'Hidden Test Case' : e((string) ($r['actual_stdout_excerpt'] ?? '')) ?>
            </div>
        <?php endforeach; ?>
    <?php else: ?>
        <p class="hint" id="poll-hint">একটু অপেক্ষা করুন — এই পাতা কয়েক সেকেন্ড পরপর নিজে থেকে আপডেট হবে।</p>
        <script src="<?= e(asset('js/submission-poll.js')) ?>" defer></script>
    <?php endif; ?>
</section>
