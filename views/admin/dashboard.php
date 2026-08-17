<?php $this->layout('layouts/admin', ['title' => 'Dashboard', 'admin' => true]); ?>
<section class="admin-dashboard">
    <h1>Admin Dashboard</h1>
    <ul class="admin-nav-list">
        <li><a href="<?= e(url('/admin/languages')) ?>">Languages</a></li>
        <li><a href="<?= e(url('/admin/modules')) ?>">Modules</a></li>
        <li><a href="<?= e(url('/admin/content/lessons')) ?>">Lessons</a></li>
        <li><a href="<?= e(url('/admin/content/problems')) ?>">Problems</a></li>
        <li><a href="<?= e(url('/admin/content/projects')) ?>">Projects</a></li>
        <li><a href="<?= e(url('/admin/content-import')) ?>">Content Import (CSV)</a></li>
        <li><a href="<?= e(url('/admin/project-submissions')) ?>">Project Submissions</a></li>
        <li><a href="<?= e(url('/admin/contact-messages')) ?>">Contact Messages</a></li>
        <li><a href="<?= e(url('/admin/users')) ?>">Users</a></li>
        <li><a href="<?= e(url('/admin/audit-log')) ?>">Audit Log</a></li>
    </ul>
</section>
