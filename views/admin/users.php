<?php $this->layout('layouts/admin', ['title' => 'Users', 'admin' => true]); ?>
<section>
    <h1>Users</h1>
    <table class="admin-table">
        <thead><tr><th>ID</th><th>Email</th><th>Display Name</th><th>Status</th><th>Joined</th></tr></thead>
        <tbody>
        <?php foreach ($users as $u): ?>
            <tr>
                <td><?= e((string) $u['id']) ?></td>
                <td><?= e($u['email']) ?></td>
                <td><?= e($u['display_name'] ?: '—') ?></td>
                <td><?= e($u['status']) ?></td>
                <td><?= e($u['created_at']) ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</section>
