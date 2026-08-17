<?php use App\Core\Session; ?>
<nav class="site-nav">
    <a class="brand" href="<?= e(url('/')) ?>">Bytewise <span class="brand-bn">বাইটওয়াইজ</span></a>

    <?php if (Session::userId() !== null): ?>
        <div class="nav-links">
            <a href="<?= e(url('/dashboard')) ?>">ড্যাশবোর্ড</a>
            <a href="<?= e(url('/explore')) ?>">এক্সপ্লোর</a>
            <a href="<?= e(url('/daily-challenge')) ?>">ডেইলি চ্যালেঞ্জ</a>
            <a href="<?= e(url('/projects')) ?>">প্রজেক্ট</a>
            <a href="<?= e(url('/leaderboard')) ?>">লিডারবোর্ড</a>
            <a href="<?= e(url('/account')) ?>">অ্যাকাউন্ট</a>
            <form method="post" action="<?= e(url('/logout')) ?>" class="inline-form">
                <?= csrf_field() ?>
                <button type="submit" class="btn btn-link">লগআউট</button>
            </form>
        </div>
    <?php else: ?>
        <div class="nav-links">
            <a href="<?= e(url('/explore')) ?>">এক্সপ্লোর</a>
            <a href="<?= e(url('/placement-test')) ?>">প্লেসমেন্ট টেস্ট</a>
            <a class="btn btn-price" href="<?= e(url('/#subscribe')) ?>"><?= e(price_line('short')) ?></a>
        </div>
    <?php endif; ?>
</nav>
