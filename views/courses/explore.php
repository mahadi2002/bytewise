<?php $this->layout('layouts/public', ['title' => 'ট্র্যাক এক্সপ্লোর করুন']); ?>
<section class="explore-index">
    <h1>ট্র্যাক এক্সপ্লোর করুন</h1>
    <p>C, C++, Java, Python, JavaScript, SQL, Data Structures ও Algorithms — ৮টি ট্র্যাক, যেকোনোটি দিয়ে শুরু করা যায়, কোনো প্রি-রিকুইজিট ছাড়াই।</p>

    <div class="track-grid">
        <?php foreach ($languages as $lang): ?>
            <a class="track-card" href="<?= e(url('/explore/' . $lang['slug'])) ?>">
                <h2><?= e($lang['name_bn']) ?></h2>
                <p class="track-en"><?= e($lang['name_en']) ?></p>
            </a>
        <?php endforeach; ?>
    </div>
</section>
