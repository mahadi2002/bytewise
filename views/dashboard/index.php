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

    <?php if (!empty($continueLesson)): ?>
    <section class="continue-lesson-card">
        <div class="continue-lesson-info">
            <span class="continue-lesson-label">যেখানে রেখেছিলেন সেখান থেকে চালিয়ে যান</span>
            <strong class="continue-lesson-title"><?= e($continueLesson['lesson_title']) ?></strong>
            <span class="hint"><?= e($continueLesson['language_name']) ?> · <?= e($continueLesson['module_title']) ?></span>
        </div>
        <a href="<?= e(url('/lessons/' . $continueLesson['lesson_id'])) ?>" class="btn btn-accent">চালিয়ে যান →</a>
    </section>
    <?php endif; ?>

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
    <ul class="skill-legend">
        <li><span class="skill-legend-dot is-complete">✓</span>সম্পন্ন</li>
        <li><span class="skill-legend-dot is-partial">%</span>চলছে</li>
        <li><span class="skill-legend-dot">0%</span>শুরু হয়নি</li>
        <li><span class="skill-legend-dot">🔒</span>লক করা</li>
    </ul>
    <div class="dashboard-trees">
        <?php foreach ($trees as $t): ?>
            <div class="dashboard-tree-card">
                <?= \App\Core\View::partial('partials/skill-tree', ['tree' => $t['tree'], 'language' => $t['language']]) ?>
                <a href="<?= e(url('/courses/' . $t['language']['slug'])) ?>" class="btn btn-link">ট্র্যাক দেখুন →</a>
            </div>
        <?php endforeach; ?>
    </div>
</section>
