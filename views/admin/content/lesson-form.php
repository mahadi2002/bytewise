<?php $this->layout('layouts/admin', ['title' => $lesson === null ? 'New Lesson' : 'Edit Lesson', 'admin' => true]); ?>
<section>
    <h1><?= $lesson === null ? 'New Lesson' : 'Edit Lesson #' . e((string) $lesson['id']) ?></h1>
    <form method="post" action="<?= e($lesson === null ? url('/admin/content/lessons') : url('/admin/content/lessons/' . $lesson['id'])) ?>" class="admin-form">
        <?= csrf_field() ?>
        <?php if ($lesson === null): ?>
            <label>Module ID</label>
            <input type="number" name="module_id" required>
            <p class="hint">See <a href="<?= e(url('/admin/modules')) ?>">/admin/modules</a> for module IDs, or use CSV import for bulk adds.</p>
            <label>Slug</label><input type="text" name="slug" required>
        <?php endif; ?>
        <label>Title (BN)</label><input type="text" name="title_bn" value="<?= e($lesson['title_bn'] ?? '') ?>" required>
        <label>Title (EN)</label><input type="text" name="title_en" value="<?= e($lesson['title_en'] ?? '') ?>" required>
        <label>Body (Markdown)</label>
        <textarea name="body_md" rows="6" required><?= e($lesson['body_md'] ?? '') ?></textarea>
        <label>Code Sample</label>
        <textarea name="code_sample" rows="4"><?= e($lesson['code_sample'] ?? '') ?></textarea>
        <label>Code Sample Language</label>
        <input type="text" name="code_sample_language" value="<?= e($lesson['code_sample_language'] ?? '') ?>">
        <label>XP Reward</label><input type="number" name="xp_reward" value="<?= e((string) ($lesson['xp_reward'] ?? 10)) ?>">
        <label><input type="checkbox" name="is_free_preview" value="1" <?= ($lesson['is_free_preview'] ?? 0) ? 'checked' : '' ?>> Free Preview</label>
        <label>Sort Order</label><input type="number" name="sort_order" value="<?= e((string) ($lesson['sort_order'] ?? 1)) ?>">
        <label><input type="checkbox" name="is_published" value="1" checked> Published</label>
        <button type="submit" class="btn btn-accent">Save</button>
    </form>
</section>
