<?php $this->layout('layouts/public', ['title' => 'প্রজেক্ট']); ?>
<?php
$statusLabels = [
    'pending'            => ['রিভিউ হচ্ছে…', 'is-pending'],
    'approved'           => ['✓ সম্পন্ন', 'is-approved'],
    'changes_requested'  => ['পরিবর্তন প্রয়োজন', 'is-changes'],
];
?>
<section class="projects-index">
    <h1>প্রজেক্ট</h1>
    <p>পোর্টফোলিও-স্টাইল ক্যাপস্টোন প্রজেক্ট — নিজে বানান, লিংক জমা দিন, Admin রিভিউ করবে। কিছু প্রজেক্ট একাধিক ভাষা মিলিয়ে (hybrid) — সবগুলো ভাষা সম্পূর্ণ করলেই জমা দেওয়া যাবে।</p>
    <div class="track-grid">
        <?php foreach ($projects as $p): ?>
            <?php
            $isReady = $eligibility[$p['id']] ?? false;
            $status  = $statuses[$p['id']] ?? null;
            [$badgeText, $badgeClass] = match (true) {
                $status !== null && isset($statusLabels[$status]) => $statusLabels[$status],
                $isReady => ['✓ Ready', 'is-ready'],
                default  => ['🔒 Recommended: finish the language(s) above first', 'is-locked'],
            };
            ?>
            <a class="track-card project-card <?= $badgeClass ?>" href="<?= e(url('/projects/' . $p['id'])) ?>">
                <h2><?= e($p['title_bn']) ?></h2>
                <p class="track-en"><?= e($p['title_en']) ?></p>
                <div class="language-chips">
                    <?php foreach ($languagesByProject[$p['id']] ?? [] as $lang): ?>
                        <span class="language-chip"><?= e($lang['name_bn']) ?></span>
                    <?php endforeach; ?>
                </div>
                <p class="readiness-badge <?= $badgeClass ?>"><?= e($badgeText) ?></p>
            </a>
        <?php endforeach; ?>
    </div>
</section>
