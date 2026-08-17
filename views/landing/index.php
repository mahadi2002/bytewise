<?php $this->layout('layouts/public', ['title' => 'হোম']); ?>

<section class="landing-hero">
    <h1>বাইটওয়াইজ (Bytewise)</h1>
    <p class="lede">
        বাইটওয়াইজ হলো বাংলাদেশের বিগিনারদের জন্য একটি ইন্টারঅ্যাকটিভ প্রোগ্রামিং শেখার
        প্ল্যাটফর্ম। C দিয়ে শুরু করে C++, Java, Python, JavaScript ও SQL পর্যন্ত —
        প্রতিটি লেসনে ছোট কোড উদাহরণ, কুইজ, এবং হাতে-কলমে কোডিং প্রবলেম। নিজের কোড
        লিখুন, সাথে সাথে রান করুন, রেজাল্ট দেখুন — কোনো সফটওয়্যার ইনস্টল ছাড়াই, শুধু
        ব্রাউজার থেকে।
    </p>
</section>

<section class="landing-cta">
    <p class="cta-line">🚀 এখনই Start করুন — <?= e(price_line('full')) ?></p>
    <p class="cta-sub">Robi &amp; Airtel Users Only&nbsp;&nbsp;|&nbsp;&nbsp;যেকোনো সময় Unsubscribe করুন</p>
    <p class="cta-body">
        একটা ভালো প্রোগ্রামিং কোর্স কিনতে হাজার হাজার টাকা লাগে। বাইটওয়াইজতে প্রতিদিন
        মাত্র ৳2.78 (এক কাপ চায়ের দামের চেয়েও কম) দিয়ে পাবেন ৬টি ভাষার সম্পূর্ণ কোর্স,
        ইন্টারঅ্যাকটিভ কুইজ, রিয়েল কোড এক্সিকিউশন এনভায়রনমেন্ট, এবং প্রতিদিনের নতুন
        চ্যালেঞ্জ। XP অর্জন করুন, স্ট্রিক ধরে রাখুন, নিজের প্রোগ্রেস চোখে দেখুন — আর
        প্রতিদিন একটু একটু করে প্রকৃত ডেভেলপার হয়ে উঠুন। যেকোনো সময় বন্ধ করে দিতে
        পারবেন, কোনো লক-ইন নেই।
    </p>
    <a href="<?= e(url('/#subscribe')) ?>" class="btn btn-accent">Subscribe Now</a>
</section>

<?= \App\Core\View::partial('partials/subscribe-box') ?>

<?= \App\Core\View::partial('partials/billing-warning') ?>
