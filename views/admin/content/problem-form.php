<?php $this->layout('layouts/admin', ['title' => 'Edit Problem', 'admin' => true]); ?>
<section>
    <h1>Edit Problem #<?= e((string) $problem['id']) ?> (<?= e($problem['slug']) ?>)</h1>
    <form method="post" action="<?= e(url('/admin/content/problems/' . $problem['id'])) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Title (BN)</label><input type="text" name="title_bn" value="<?= e($problem['title_bn']) ?>" required>
        <label>Title (EN)</label><input type="text" name="title_en" value="<?= e($problem['title_en']) ?>" required>
        <label>Statement (Markdown)</label><textarea name="statement_md" rows="5" required><?= e($problem['statement_md']) ?></textarea>
        <label>Starter Code</label><textarea name="starter_code" rows="4"><?= e($problem['starter_code'] ?? '') ?></textarea>
        <label>Difficulty</label>
        <select name="difficulty">
            <?php foreach (['easy', 'medium', 'hard'] as $d): ?>
                <option value="<?= e($d) ?>" <?= $problem['difficulty'] === $d ? 'selected' : '' ?>><?= e($d) ?></option>
            <?php endforeach; ?>
        </select>
        <label>XP Reward</label><input type="number" name="xp_reward" value="<?= e((string) $problem['xp_reward']) ?>">
        <label>Time Limit (ms)</label><input type="number" name="time_limit_ms" value="<?= e((string) $problem['time_limit_ms']) ?>">
        <label>Memory Limit (KB)</label><input type="number" name="memory_limit_kb" value="<?= e((string) $problem['memory_limit_kb']) ?>">
        <label><input type="checkbox" name="is_published" value="1" <?= $problem['is_published'] ? 'checked' : '' ?>> Published</label>
        <button type="submit" class="btn btn-accent">Save</button>
    </form>
    <p class="hint">Test cases aren't editable from this form yet (TODO.md follow-up) — insert via database/seeds or a direct migration for now.</p>
    <h2>Danger zone</h2>
    <form method="post" action="<?= e(url('/admin/content/problems/' . $problem['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this problem? This cascades to its test cases and submissions — cannot be undone.">
        <?= csrf_field() ?>
        <button type="submit" class="btn btn-link">Delete problem</button>
    </form>
</section>
