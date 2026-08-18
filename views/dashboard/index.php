<?php $this->layout('layouts/public', ['title' => 'ড্যাশবোর্ড']); ?>
<section class="dashboard-page">
    <div class="dashboard-stats">
        <div class="stat-tile">
            <span class="stat-icon">⚡</span>
            <span class="stat-value"><?= e((string) $xpTotal) ?></span>
            <span class="stat-label">Total XP</span>
        </div>
        <div class="stat-tile">
            <span class="stat-icon">🔥</span>
            <span class="stat-value"><?= e((string) $streak['current_streak_days']) ?></span>
            <span class="stat-label">দিনের স্ট্রিক</span>
        </div>
        <div class="stat-tile">
            <span class="stat-icon">🏆</span>
            <span class="stat-value"><?= e((string) $streak['longest_streak_days']) ?></span>
            <span class="stat-label">সেরা স্ট্রিক</span>
        </div>
    </div>

    <?php if (!empty($daily)): ?>
    <section class="daily-challenge-strip">
        <h2>আজকের চ্যালেঞ্জ</h2>
        <div class="daily-challenge-grid">
            <?php foreach ($daily as $d): ?>
                <a class="daily-challenge-card" href="<?= e(url('/problems/' . $d['challenge']['problem_id'])) ?>">
                    <strong><?= e($d['language']['name_bn']) ?></strong>
                    <span><?= e($d['challenge']['title_bn']) ?></span>
                </a>
            <?php endforeach; ?>
        </div>
    </section>
    <?php endif; ?>

    <h2>আমার স্কিল ট্রি</h2>
    <p class="hint">সব ভাষা ও প্রতিটি মডিউল যেকোনো সময় শুরু করা যায় — কোনো প্রি-রিকুইজিট নেই। যেখান থেকে ইচ্ছা সেখান থেকে শিখুন।</p>
    <div class="dashboard-trees">
        <?php foreach ($trees as $t): ?>
            <div class="dashboard-tree-card <?= $t['unlocked'] ? '' : 'is-track-locked' ?>">
                <?php if ($t['unlocked']): ?>
                    <?= \App\Core\View::partial('partials/skill-tree', ['tree' => $t['tree'], 'language' => $t['language']]) ?>
                    <a href="<?= e(url('/courses/' . $t['language']['slug'])) ?>" class="btn btn-link">ট্র্যাক দেখুন →</a>
                <?php else: ?>
                    <p class="skill-tree-track"><?= e($t['language']['name_bn']) ?></p>
                    <p class="track-lock-note">🔒 <?= e(\App\Services\TrackAccessService::lockMessage($t['reason'])) ?></p>
                <?php endif; ?>
            </div>
        <?php endforeach; ?>
    </div>
</section>
