<?php $this->layout('layouts/admin', ['title' => 'Languages', 'admin' => true]); ?>
<section>
    <h1>Languages / Tracks</h1>
    <table class="admin-table">
        <thead><tr><th>Slug</th><th>Name (BN)</th><th>Name (EN)</th><th>Meta-track</th><th>Published</th></tr></thead>
        <tbody>
        <?php foreach ($languages as $lang): ?>
            <tr>
                <td><?= e($lang['slug']) ?></td>
                <td><?= e($lang['name_bn']) ?></td>
                <td><?= e($lang['name_en']) ?></td>
                <td><?= $lang['is_meta_track'] ? 'Yes' : 'No' ?></td>
                <td><?= $lang['is_published'] ? 'Yes' : 'No' ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
    <p class="hint">Language rows are fixed at 8 tracks per BUILD-SPEC §6 — add/edit here is a documented follow-up (TODO.md), not silently missing; the set is stable enough that migration-time seeding covers v1.</p>
</section>
