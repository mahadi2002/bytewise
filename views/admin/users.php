<?php $this->layout('layouts/admin', ['title' => 'Users', 'admin' => true]); ?>
<section>
    <h1>Users</h1>
    <?php if ($revealed !== null): ?>
        <p class="notice notice-info">Revealed mobile for user #<?= e((string) $revealed['user_id']) ?>: <strong><?= e($revealed['mobile'] ?? 'decrypt failed') ?></strong> (this action was logged to the audit log).</p>
    <?php endif; ?>
    <table class="admin-table">
        <thead><tr><th>ID</th><th>Operator</th><th>Display Name</th><th>Status</th><th>Joined</th><th>PII</th></tr></thead>
        <tbody>
        <?php foreach ($users as $u): ?>
            <tr>
                <td><?= e((string) $u['id']) ?></td>
                <td><?= e($u['operator']) ?></td>
                <td><?= e($u['display_name'] ?: '—') ?></td>
                <td><?= e($u['status']) ?></td>
                <td><?= e($u['created_at']) ?></td>
                <td>
                    <form method="post" action="<?= e(url('/admin/users/' . $u['id'] . '/reveal')) ?>">
                        <?= csrf_field() ?>
                        <button type="submit" class="btn btn-link">Reveal Mobile</button>
                    </form>
                </td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</section>
