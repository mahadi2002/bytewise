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

<section class="landing-demo" aria-label="কোড লেসনের প্রিভিউ">
    <p class="landing-demo-caption">ঠিক এভাবেই আপনার প্রথম লেসনে কোড লিখবেন —</p>
    <pre class="code-sample landing-demo-code" data-demo-code><code>#include &lt;stdio.h&gt;

int main() {
    printf("আমি এখন কোড লিখছি!\n");
    return 0;
}</code><span class="landing-demo-cursor" aria-hidden="true"></span></pre>
    <div class="landing-demo-output" data-demo-output>
        <span class="landing-demo-output-prompt">$</span>আমি এখন কোড লিখছি!
    </div>
</section>

<section class="landing-cta">
    <p class="cta-line">🚀 এখনই শুরু করুন — সম্পূর্ণ ফ্রি</p>
    <p class="cta-body">
        রেজিস্ট্রেশন করুন আর সাথে সাথে পেয়ে যান ৬টি ভাষার সম্পূর্ণ কোর্স,
        ইন্টারঅ্যাকটিভ কুইজ, রিয়েল কোড এক্সিকিউশন এনভায়রনমেন্ট, এবং প্রতিদিনের নতুন
        চ্যালেঞ্জ। XP অর্জন করুন, স্ট্রিক ধরে রাখুন, নিজের প্রোগ্রেস চোখে দেখুন — আর
        প্রতিদিন একটু একটু করে প্রকৃত ডেভেলপার হয়ে উঠুন।
    </p>
    <a href="<?= e(url('/register')) ?>" class="btn btn-accent">Get Started</a>
</section>
