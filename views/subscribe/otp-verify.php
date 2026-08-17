<?php $this->layout('layouts/public', ['title' => 'OTP যাচাই করুন']); ?>
<section class="otp-verify">
    <h1>OTP যাচাই করুন</h1>
    <p><?= e($mobile) ?> নম্বরে পাঠানো ৬-সংখ্যার কোডটি দিন।</p>

    <form method="post" action="<?= e(url('/otp/verify')) ?>" class="otp-form">
        <?= csrf_field() ?>
        <label for="otp">OTP কোড</label>
        <input type="text" id="otp" name="otp" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" required autofocus>
        <button type="submit" class="btn btn-accent">যাচাই করুন</button>
    </form>

    <form method="post" action="<?= e(url('/otp/resend')) ?>" class="otp-resend-form">
        <?= csrf_field() ?>
        <button type="submit" class="btn btn-link">নতুন কোড চান (৬০ সেকেন্ড পর)</button>
    </form>
</section>
