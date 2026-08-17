<?php $this->layout('layouts/admin', ['title' => 'Contact Messages', 'admin' => true]); ?>
<section>
    <h1>Contact Messages</h1>
    <?php foreach ($messages as $m): ?>
        <div class="queue-item">
            <p><strong><?= e($m['name']) ?></strong> (<?= e($m['email_or_mobile']) ?>) — <?= e($m['status']) ?></p>
            <p><?= e($m['message']) ?></p>
            <form method="post" action="<?= e(url('/admin/contact-messages/' . $m['id'])) ?>">
                <?= csrf_field() ?>
                <select name="status" data-auto-submit>
                    <option value="new" <?= $m['status'] === 'new' ? 'selected' : '' ?>>New</option>
                    <option value="read" <?= $m['status'] === 'read' ? 'selected' : '' ?>>Read</option>
                    <option value="resolved" <?= $m['status'] === 'resolved' ? 'selected' : '' ?>>Resolved</option>
                </select>
                <button type="submit" class="btn btn-link">Update</button>
            </form>
        </div>
    <?php endforeach; ?>
    <?php if (empty($messages)): ?><p>No messages yet.</p><?php endif; ?>
</section>
