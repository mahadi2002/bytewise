<?php $this->layout('layouts/admin', ['title' => 'Lessons', 'admin' => true]); ?>
<section>
    <h1>Lessons</h1>
    <p><a href="<?= e(url('/admin/content/lessons/new')) ?>" class="btn btn-accent">+ New Lesson</a>
       <a href="<?= e(url('/admin/content-import')) ?>" class="btn btn-link">CSV Import</a></p>
    <table class="admin-table">
        <thead><tr><th>ID</th><th>Track</th><th>Module</th><th>Title</th><th>Published</th><th></th></tr></thead>
        <tbody>
        <?php foreach ($lessons as $l): ?>
            <tr>
                <td><?= e((string) $l['id']) ?></td>
                <td><?= e($l['language_name']) ?></td>
                <td><?= e($l['module_title']) ?></td>
                <td><?= e($l['title_bn']) ?> (<?= e($l['slug']) ?>)</td>
                <td><?= $l['is_published'] ? 'Yes' : 'No' ?></td>
                <td>
                    <a href="<?= e(url('/admin/content/lessons/' . $l['id'] . '/edit')) ?>">Edit</a>
                    <form method="post" action="<?= e(url('/admin/content/lessons/' . $l['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this lesson?">
                        <?= csrf_field() ?>
                        <button type="submit" class="btn btn-link">Delete</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</section>
