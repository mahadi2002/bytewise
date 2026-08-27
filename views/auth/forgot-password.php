<?php $this->layout('layouts/public', ['title' => 'পাসওয়ার্ড ভুলে গেছেন']); ?>
<section class="auth-page">
    <h1>পাসওয়ার্ড ভুলে গেছেন</h1>
    <p class="hint">আপনার ইমেইল দিন — একটি রিসেট লিংক পাঠানো হবে।</p>

    <form method="post" action="<?= e(url('/forgot-password')) ?>" class="auth-form">
        <?= csrf_field() ?>
        <label for="email">ইমেইল</label>
        <input type="email" id="email" name="email" value="<?= e(old('email')) ?>" required autofocus>
        <?php if (error_for('email')): ?><p class="form-error"><?= e(error_for('email')) ?></p><?php endif; ?>

        <button type="submit" class="btn btn-accent">রিসেট লিংক পাঠান</button>
    </form>

    <p class="hint"><a href="<?= e(url('/login')) ?>">লগইনে ফিরে যান</a></p>
</section>
