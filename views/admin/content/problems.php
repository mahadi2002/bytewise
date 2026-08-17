<?php $this->layout('layouts/admin', ['title' => 'Problems', 'admin' => true]); ?>
<section>
    <h1>Problems</h1>
    <table class="admin-table">
        <thead><tr><th>ID</th><th>Track</th><th>Title</th><th>Difficulty</th><th>Published</th></tr></thead>
        <tbody>
        <?php foreach ($problems as $p): ?>
            <tr>
                <td><?= e((string) $p['id']) ?></td>
                <td><?= e($p['language_name'] ?? 'Agnostic') ?></td>
                <td><?= e($p['title_bn']) ?> (<?= e($p['slug']) ?>)</td>
                <td><?= e($p['difficulty']) ?></td>
                <td><?= $p['is_published'] ? 'Yes' : 'No' ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>

    <h2>New Problem</h2>
    <form method="post" action="<?= e(url('/admin/content/problems')) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Language (leave blank for language-agnostic DS/Algo problem)</label>
        <select name="language_id">
            <option value="">-- agnostic --</option>
            <?php foreach ($languages as $lang): ?>
                <option value="<?= e((string) $lang['id']) ?>"><?= e($lang['name_bn']) ?></option>
            <?php endforeach; ?>
        </select>
        <label>Lesson ID (optional)</label><input type="number" name="lesson_id">
        <label>Slug</label><input type="text" name="slug" required>
        <label>Title (BN)</label><input type="text" name="title_bn" required>
        <label>Title (EN)</label><input type="text" name="title_en" required>
        <label>Statement (Markdown)</label><textarea name="statement_md" rows="5" required></textarea>
        <label>Starter Code</label><textarea name="starter_code" rows="4"></textarea>
        <label>Difficulty</label>
        <select name="difficulty"><option>easy</option><option>medium</option><option>hard</option></select>
        <label>XP Reward</label><input type="number" name="xp_reward" value="25">
        <label>Time Limit (ms)</label><input type="number" name="time_limit_ms" value="2000">
        <label>Memory Limit (KB)</label><input type="number" name="memory_limit_kb" value="65536">
        <button type="submit" class="btn btn-accent">Create</button>
    </form>
    <p class="hint">Test cases aren't editable from this form yet (TODO.md follow-up) — insert via database/seeds or a direct migration for now.</p>
</section>
