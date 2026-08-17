<?php $this->layout('layouts/admin', ['title' => 'Projects', 'admin' => true]); ?>
<section>
    <h1>Projects</h1>
    <table class="admin-table">
        <thead><tr><th>ID</th><th>Slug</th><th>Title</th><th>Languages</th></tr></thead>
        <tbody>
        <?php foreach ($projects as $p): ?>
            <tr>
                <td><?= e((string) $p['id']) ?></td>
                <td><?= e($p['slug']) ?></td>
                <td><?= e($p['title_bn']) ?></td>
                <td><?= e(implode(' + ', array_map(static fn(array $l): string => $l['name_bn'], $languagesByProject[$p['id']] ?? []))) ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>

    <h2>New Project</h2>
    <form method="post" action="<?= e(url('/admin/content/projects')) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Language(s) — hold Ctrl/Cmd to select more than one; a hybrid project requires ALL selected languages complete</label>
        <select name="language_ids[]" multiple size="8" required>
            <?php foreach ($languages as $lang): ?>
                <option value="<?= e((string) $lang['id']) ?>"><?= e($lang['name_bn']) ?></option>
            <?php endforeach; ?>
        </select>
        <label>Slug</label><input type="text" name="slug" required>
        <label>Title (BN)</label><input type="text" name="title_bn" required>
        <label>Title (EN)</label><input type="text" name="title_en" required>
        <label>Brief (Markdown)</label><textarea name="brief_md" rows="4" required></textarea>
        <label>Rubric (Markdown)</label><textarea name="rubric_md" rows="4" required></textarea>
        <label>Starter Repo Notes</label><textarea name="starter_repo_notes" rows="2"></textarea>
        <label>XP Reward</label><input type="number" name="xp_reward" value="100">
        <button type="submit" class="btn btn-accent">Create</button>
    </form>
</section>
