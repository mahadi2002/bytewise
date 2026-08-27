<?php $this->layout('layouts/admin', ['title' => 'Edit Module', 'admin' => true]); ?>
<section>
    <h1>Edit Module #<?= e((string) $module['id']) ?> (<?= e($module['slug']) ?>)</h1>
    <form method="post" action="<?= e(url('/admin/modules/' . $module['id'])) ?>" class="admin-form">
        <?= csrf_field() ?>
        <label>Title (BN)</label><input type="text" name="title_bn" value="<?= e($module['title_bn']) ?>" required>
        <label>Title (EN)</label><input type="text" name="title_en" value="<?= e($module['title_en']) ?>" required>
        <label>Sort Order</label><input type="number" name="sort_order" value="<?= e((string) $module['sort_order']) ?>" required>
        <label><input type="checkbox" name="is_published" value="1" <?= $module['is_published'] ? 'checked' : '' ?>> Published</label>
        <button type="submit" class="btn btn-accent">Save</button>
    </form>
    <h2>Danger zone</h2>
    <form method="post" action="<?= e(url('/admin/modules/' . $module['id'] . '/delete')) ?>" class="inline-form" data-confirm="Delete this module? This cascades to every lesson in it — cannot be undone.">
        <?= csrf_field() ?>
        <button type="submit" class="btn btn-link">Delete module</button>
    </form>
</section>
