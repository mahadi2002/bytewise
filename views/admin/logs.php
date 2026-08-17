<?php $this->layout('layouts/admin', ['title' => 'Audit Log', 'admin' => true]); ?>
<section>
    <h1>Audit Log</h1>
    <table class="admin-table">
        <thead><tr><th>When</th><th>Actor</th><th>Action</th><th>Target</th><th>Meta</th></tr></thead>
        <tbody>
        <?php foreach ($entries as $e): ?>
            <tr>
                <td><?= e($e['occurred_at']) ?></td>
                <td><?= e($e['actor_type']) ?>#<?= e((string) $e['actor_id']) ?></td>
                <td><?= e($e['action']) ?></td>
                <td><?= e(($e['target_type'] ?? '') . '#' . ($e['target_id'] ?? '')) ?></td>
                <td><code><?= e($e['meta_json'] ?? '') ?></code></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</section>
