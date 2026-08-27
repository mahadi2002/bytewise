<?php $this->layout('layouts/admin', ['title' => 'Languages', 'admin' => true]); ?>
<section>
    <h1>Languages / Tracks</h1>
    <table class="admin-table">
        <thead><tr><th>Slug</th><th>Name (BN)</th><th>Name (EN)</th><th>Meta-track</th><th>Published</th><th></th></tr></thead>
        <tbody>
        <?php foreach ($languages as $lang): ?>
            <tr>
                <td><?= e($lang['slug']) ?></td>
                <td><?= e($lang['name_bn']) ?></td>
                <td><?= e($lang['name_en']) ?></td>
                <td><?= $lang['is_meta_track'] ? 'Yes' : 'No' ?></td>
                <td><?= $lang['is_published'] ? 'Yes' : 'No' ?></td>
                <td>
                    <a href="<?= e(url('/admin/languages/' . $lang['id'] . '/edit')) ?>">Edit</a>
                    <form method="post" action="<?= e(url('/admin/languages/' . $lang['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this language track? This cascades to every module, lesson, and problem under it.">
                        <?= csrf_field() ?>
                        <button type="submit" class="btn btn-link">Delete</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
    <p class="hint">New tracks aren't created from this form (BUILD-SPEC §6 fixes the set at 8 — a 9th track needs seed content, judge-language wiring, and CSS to go with it, not just a row); edit/delete of the existing 8 is supported above.</p>
</section>
