<?php $this->layout('layouts/public', ['title' => 'লিডারবোর্ড']); ?>
<section class="leaderboard-page">
    <h1>লিডারবোর্ড</h1>
    <ol class="leaderboard-list">
        <?php foreach ($entries as $i => $entry): ?>
            <li class="<?= (int) $entry['id'] === $currentUserId ? 'is-you' : '' ?>">
                <span class="rank">#<?= e((string) ($i + 1)) ?></span>
                <span class="name"><?= e($entry['display_name'] ?: ('Student #' . $entry['id'])) ?></span>
                <span class="xp"><?= e((string) $entry['total_xp']) ?> XP</span>
            </li>
        <?php endforeach; ?>
        <?php if (empty($entries)): ?>
            <li class="hint">এখনো কোনো XP অর্জিত হয়নি।</li>
        <?php endif; ?>
    </ol>
</section>
