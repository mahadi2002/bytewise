<?php $this->layout('layouts/public', ['title' => 'নতুন পাসওয়ার্ড']); ?>
<section class="auth-page">
    <h1>নতুন পাসওয়ার্ড দিন</h1>

    <form method="post" action="<?= e(url('/reset-password/' . $token)) ?>" class="auth-form">
        <?= csrf_field() ?>
        <label for="password">নতুন পাসওয়ার্ড</label>
        <input type="password" id="password" name="password" minlength="8" required autofocus>
        <?php if (error_for('password')): ?><p class="form-error"><?= e(error_for('password')) ?></p><?php endif; ?>
        <p class="hint">কমপক্ষে ৮ অক্ষর</p>

        <label for="password_confirmation">পাসওয়ার্ড আবার লিখুন</label>
        <input type="password" id="password_confirmation" name="password_confirmation" minlength="8" required>
        <?php if (error_for('password_confirmation')): ?><p class="form-error"><?= e(error_for('password_confirmation')) ?></p><?php endif; ?>

        <button type="submit" class="btn btn-accent">পাসওয়ার্ড পরিবর্তন করুন</button>
    </form>
</section>
