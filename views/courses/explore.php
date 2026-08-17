<?php $this->layout('layouts/public', ['title' => 'ট্র্যাক এক্সপ্লোর করুন']); ?>
<section class="explore-index">
    <h1>ট্র্যাক এক্সপ্লোর করুন</h1>
    <p>C দিয়ে শুরু করে C++, Java, Python, JavaScript, SQL, তারপর Data Structures ও Algorithms — ৮টি ট্র্যাক, নির্দিষ্ট ক্রমে আনলক হয়।</p>

    <div class="track-grid">
        <?php foreach ($languages as $lang): ?>
            <?php $isLocked = isset($unlocked[$lang['id']]) && !$unlocked[$lang['id']]; ?>
            <a class="track-card <?= $isLocked ? 'is-track-locked' : '' ?>" href="<?= e(url('/explore/' . $lang['slug'])) ?>">
                <h2><?= e($lang['name_bn']) ?><?= $isLocked ? ' 🔒' : '' ?></h2>
                <p class="track-en"><?= e($lang['name_en']) ?></p>
            </a>
        <?php endforeach; ?>
    </div>
</section>
