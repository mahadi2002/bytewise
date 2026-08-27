<?php $this->layout('layouts/admin', ['title' => 'Modules', 'admin' => true]); ?>
<section>
    <h1>Modules</h1>
    <?php foreach ($languages as $lang): ?>
        <h2><?= e($lang['name_bn']) ?></h2>
        <ol>
            <?php foreach ($modulesByLanguage[$lang['id']] as $m): ?>
                <li>
                    <?= e($m['title_bn']) ?> (<?= e($m['slug']) ?>)
                    <a href="<?= e(url('/admin/modules/' . $m['id'] . '/edit')) ?>">Edit</a>
                    <form method="post" action="<?= e(url('/admin/modules/' . $m['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this module? This cascades to every lesson in it.">
                        <?= csrf_field() ?>
                        <button type="submit" class="btn btn-link">Delete</button>
                    </form>
                </li>
            <?php endforeach; ?>
        </ol>
    <?php endforeach; ?>

    <h2>Add Module</h2>
    <form method="post" action="<?= e(url('/admin/modules')) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Language</label>
        <select name="language_id" required>
            <?php foreach ($languages as $lang): ?>
                <option value="<?= e((string) $lang['id']) ?>"><?= e($lang['name_bn']) ?></option>
            <?php endforeach; ?>
        </select>
        <label>Slug</label><input type="text" name="slug" required>
        <label>Title (BN)</label><input type="text" name="title_bn" required>
        <label>Title (EN)</label><input type="text" name="title_en" required>
        <label>Sort Order</label><input type="number" name="sort_order" value="1" required>
        <button type="submit" class="btn btn-accent">Create</button>
    </form>
</section>
