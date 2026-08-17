<?php $this->layout('layouts/admin', ['title' => 'Admin Login']); ?>
<section class="admin-login">
    <h1>Bytewise Admin</h1>
    <form method="post" action="<?= e(url('/admin/login')) ?>" class="admin-login-form">
        <?= csrf_field() ?>
        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="<?= e(old('email')) ?>" required autofocus>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <label for="totp">Authenticator কোড (৬ সংখ্যা)</label>
        <input type="text" id="totp" name="totp" inputmode="numeric" pattern="[0-9]{6}" maxlength="6" required>

        <button type="submit" class="btn btn-accent">Login</button>
    </form>
</section>
