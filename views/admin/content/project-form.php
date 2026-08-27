<?php $this->layout('layouts/admin', ['title' => 'Edit Project', 'admin' => true]); ?>
<section>
    <h1>Edit Project #<?= e((string) $project['id']) ?> (<?= e($project['slug']) ?>)</h1>
    <form method="post" action="<?= e(url('/admin/content/projects/' . $project['id'])) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Language(s) — hold Ctrl/Cmd to select more than one; a hybrid project requires ALL selected languages complete</label>
        <select name="language_ids[]" multiple size="8" required>
            <?php foreach ($languages as $lang): ?>
                <option value="<?= e((string) $lang['id']) ?>" <?= in_array((int) $lang['id'], $selectedLanguageIds, true) ? 'selected' : '' ?>><?= e($lang['name_bn']) ?></option>
            <?php endforeach; ?>
        </select>
        <label>Title (BN)</label><input type="text" name="title_bn" value="<?= e($project['title_bn']) ?>" required>
        <label>Title (EN)</label><input type="text" name="title_en" value="<?= e($project['title_en']) ?>" required>
        <label>Brief (Markdown)</label><textarea name="brief_md" rows="4" required><?= e($project['brief_md']) ?></textarea>
        <label>Rubric (Markdown)</label><textarea name="rubric_md" rows="4" required><?= e($project['rubric_md']) ?></textarea>
        <label>Starter Repo Notes</label><textarea name="starter_repo_notes" rows="2"><?= e($project['starter_repo_notes'] ?? '') ?></textarea>
        <label>XP Reward</label><input type="number" name="xp_reward" value="<?= e((string) $project['xp_reward']) ?>">
        <label><input type="checkbox" name="is_published" value="1" <?= $project['is_published'] ? 'checked' : '' ?>> Published</label>
        <button type="submit" class="btn btn-accent">Save</button>
    </form>
    <h2>Danger zone</h2>
    <form method="post" action="<?= e(url('/admin/content/projects/' . $project['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this project? This cascades to every student submission for it — cannot be undone.">
        <?= csrf_field() ?>
        <button type="submit" class="btn btn-link">Delete project</button>
    </form>
</section>
