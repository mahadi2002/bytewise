<?php $this->layout('layouts/public', ['title' => 'ফলাফল']); ?>
<section class="placement-result">
    <h1><?= e($language['name_bn']) ?> — ফলাফল</h1>
    <p>আপনি <?= e((string) $result['total']) ?>টির মধ্যে <?= e((string) $result['raw_score']) ?>টি সঠিক দিয়েছেন।</p>

    <?php if ($result['recommended_module'] !== null): ?>
        <div class="recommendation-card">
            <p>সাজেস্টেড শুরুর মডিউল:</p>
            <h2><?= e($result['recommended_module']['title_bn']) ?></h2>
            <a href="<?= e(url('/explore/' . $language['slug'])) ?>" class="btn btn-accent">ট্র্যাক দেখুন</a>
        </div>
    <?php else: ?>
        <p>এই ট্র্যাকের জন্য এখনো কোনো মডিউল সাজেস্ট করা যায়নি।</p>
    <?php endif; ?>
</section>
