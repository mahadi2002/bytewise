<?php $this->layout('layouts/public', ['title' => $language['name_bn'] . ' চিট শিট']); ?>
<section class="cheatsheet-page">
    <h1><?= e($language['name_bn']) ?> চিট শিট</h1>

    <?php if ($sheet === null): ?>
        <p>এই ট্র্যাকের চিট শিট শীঘ্রই আসছে।</p>
    <?php else: ?>
        <div class="cheatsheet-summary"><?= \App\Support\Markdown::toHtml($sheet['summary_md']) ?></div>

        <?php if ($full): ?>
            <div class="cheatsheet-full"><?= \App\Support\Markdown::toHtml($sheet['full_md']) ?></div>
        <?php else: ?>
            <div class="lesson-locked-card">
                <p>🔒 সম্পূর্ণ চিট শিট দেখতে লগইন করুন।</p>
                <a href="<?= e(url('/register')) ?>" class="btn btn-accent">রেজিস্ট্রেশন করুন</a>
            </div>
        <?php endif; ?>
    <?php endif; ?>
</section>
