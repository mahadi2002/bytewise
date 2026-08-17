<?php $this->layout('layouts/public', ['title' => $language['name_bn']]); ?>
<section class="track-page">
    <h1><?= e($language['name_bn']) ?> <span class="track-en">(<?= e($language['name_en']) ?>)</span></h1>

    <?= \App\Core\View::partial('partials/skill-tree', ['tree' => $tree, 'language' => $language]) ?>

    <?php if ($gated ?? false): ?>
        <p class="hint">সম্পূর্ণ কনটেন্ট আনলক করতে <a href="<?= e(url('/#subscribe')) ?>">Subscribe করুন</a>।</p>
    <?php endif; ?>
</section>
