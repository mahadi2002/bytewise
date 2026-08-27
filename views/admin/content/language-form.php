<?php $this->layout('layouts/admin', ['title' => 'Edit Language', 'admin' => true]); ?>
<section>
    <h1>Edit Language #<?= e((string) $language['id']) ?> (<?= e($language['slug']) ?>)</h1>
    <form method="post" action="<?= e(url('/admin/languages/' . $language['id'])) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Name (BN)</label><input type="text" name="name_bn" value="<?= e($language['name_bn']) ?>" required>
        <label>Name (EN)</label><input type="text" name="name_en" value="<?= e($language['name_en']) ?>" required>
        <label>Launch Order</label><input type="number" name="launch_order" value="<?= e((string) $language['launch_order']) ?>" required>
        <label>Judge Language Code</label>
        <input type="text" name="judge_language_code" value="<?= e((string) ($language['judge_language_code'] ?? '')) ?>">
        <p class="hint">Required unless "Meta-track" is checked — DB rejects the save otherwise.</p>
        <label><input type="checkbox" name="is_meta_track" value="1" <?= $language['is_meta_track'] ? 'checked' : '' ?>> Meta-track (no direct judge execution, e.g. Data Structures/Algorithms)</label>
        <label><input type="checkbox" name="is_published" value="1" <?= $language['is_published'] ? 'checked' : '' ?>> Published</label>
        <button type="submit" class="btn btn-accent">Save</button>
    </form>
    <h2>Danger zone</h2>
    <form method="post" action="<?= e(url('/admin/languages/' . $language['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this language track? This cascades to every module, lesson, and problem under it — cannot be undone.">
        <?= csrf_field() ?>
        <button type="submit" class="btn btn-link">Delete track</button>
    </form>
</section>
