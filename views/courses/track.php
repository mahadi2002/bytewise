<?php $this->layout('layouts/public', ['title' => $language['name_bn']]); ?>
<section class="track-page">
    <h1><?= e($language['name_bn']) ?> <span class="track-en">(<?= e($language['name_en']) ?>)</span></h1>

    <ul class="skill-legend">
        <li><span class="skill-legend-dot is-complete">✓</span>সম্পন্ন</li>
        <li><span class="skill-legend-dot is-partial">%</span>চলছে</li>
        <li><span class="skill-legend-dot">0%</span>শুরু হয়নি</li>
        <li><span class="skill-legend-dot">🔒</span>লক করা</li>
    </ul>

    <?= \App\Core\View::partial('partials/skill-tree', ['tree' => $tree, 'language' => $language]) ?>

    <?php if ($gated ?? false): ?>
        <p class="hint">সম্পূর্ণ কনটেন্ট দেখতে <a href="<?= e(url('/register')) ?>">রেজিস্ট্রেশন করুন</a> অথবা <a href="<?= e(url('/login')) ?>">লগইন করুন</a>।</p>
    <?php endif; ?>
</section>
