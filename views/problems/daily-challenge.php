<?php $this->layout('layouts/public', ['title' => 'ডেইলি চ্যালেঞ্জ']); ?>
<section class="daily-challenge-page">
    <h1>ডেইলি চ্যালেঞ্জ</h1>
    <p>প্রতিদিন প্রতিটি ট্র্যাকে একটি নতুন প্রবলেম — সবার জন্য একই প্রবলেম, তাই লিডারবোর্ডে তুলনা করা যায়।</p>

    <div class="daily-challenge-grid">
        <?php foreach ($challenges as $c): ?>
            <div class="daily-challenge-card">
                <h2><?= e($c['language']['name_bn']) ?></h2>
                <?php if ($c['challenge'] !== null): ?>
                    <a href="<?= e(url('/problems/' . $c['challenge']['problem_id'])) ?>"><?= e($c['challenge']['title_bn']) ?></a>
                <?php else: ?>
                    <p class="hint">আজকের চ্যালেঞ্জ এখনো সেট হয়নি।</p>
                <?php endif; ?>
            </div>
        <?php endforeach; ?>
    </div>
</section>
