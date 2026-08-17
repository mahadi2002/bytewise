<?php $this->layout('layouts/public', ['title' => 'আলোচনা']); ?>
<section class="discussion-page">
    <h1>আলোচনা</h1>

    <div class="discussion-list">
        <?php foreach ($posts as $post): ?>
            <div class="discussion-post <?= $post['parent_post_id'] !== null ? 'is-reply' : '' ?>">
                <p class="post-author"><?= e($post['display_name'] ?: ('Student #' . $post['user_id'])) ?><?= $post['is_pinned'] ? ' 📌' : '' ?></p>
                <p class="post-body"><?= e($post['body_md']) ?></p>
            </div>
        <?php endforeach; ?>
        <?php if (empty($posts)): ?>
            <p class="hint">এখনো কোনো আলোচনা নেই — প্রথম প্রশ্নটি আপনিই করুন।</p>
        <?php endif; ?>
    </div>

    <form method="post" action="<?= e(url('/discussion/' . $contextType . '/' . $contextId)) ?>" class="discussion-form">
        <?= csrf_field() ?>
        <textarea name="body_md" rows="3" placeholder="প্রশ্ন বা মন্তব্য লিখুন..." required></textarea>
        <button type="submit" class="btn btn-accent">পোস্ট করুন</button>
    </form>
</section>
