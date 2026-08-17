-- Backfills explanation_bn (added by migration 010, after content.sql's
-- Module 1 quiz questions were originally written) for the 4 Basics-module
-- questions, so the outcome/result view has an explanation for every quiz
-- a subscriber sees, not just the newer modules. Idempotent (plain UPDATEs
-- keyed by lesson slug + sort_order, safe to re-run).

UPDATE quiz_questions qq
JOIN lessons l ON l.id = qq.lesson_id
JOIN modules m ON m.id = l.module_id
JOIN languages lang ON lang.id = m.language_id
SET qq.explanation_bn = '২০ ভ্যালু নিয়ে `age`-কে `int` হিসেবে ঘোষণা করা হয়েছে, আর C-তে অ্যাসাইনমেন্টের পর ভেরিয়েবলে সেই ভ্যালুটাই থাকে — কোনো রূপান্তর হয় না, তাই `age` মানে সরাসরি `20` (সংখ্যা, টেক্সট নয়)।'
WHERE lang.slug = 'c' AND m.slug = 'basics' AND l.slug = 'variables-data-types' AND qq.sort_order = 1;

UPDATE quiz_questions qq
JOIN lessons l ON l.id = qq.lesson_id
JOIN modules m ON m.id = l.module_id
JOIN languages lang ON lang.id = m.language_id
SET qq.explanation_bn = '`scanf()` ইউজারের ইনপুট সরাসরি ভেরিয়েবলের মেমোরি লোকেশনে লিখে দেয়, তাই ভেরিয়েবলের ভ্যালু না দিয়ে তার *অ্যাড্রেস* দিতে হয় — `&` (address-of অপারেটর) দিয়েই সেটা পাওয়া যায়। `&` ভুলে গেলে কম্পাইলার প্রায়ই ওয়ার্নিং দেয়, কিন্তু প্রোগ্রাম ক্র্যাশও করতে পারে।'
WHERE lang.slug = 'c' AND m.slug = 'basics' AND l.slug = 'input-output' AND qq.sort_order = 1;

UPDATE quiz_questions qq
JOIN lessons l ON l.id = qq.lesson_id
JOIN modules m ON m.id = l.module_id
JOIN languages lang ON lang.id = m.language_id
SET qq.explanation_bn = '`a` আর `b` দুটোই `int`, তাই `a / b`-এর ফলাফলও `int` হবে — দশমিক অংশ (`.5`) বাদ পড়ে যায় (রাউন্ড হয় না, শুধু কেটে যায়)। দশমিক ফলাফল পেতে হলে অন্তত একটাকে `(float)` দিয়ে কনভার্ট করতে হয়, যেমন কোডের দ্বিতীয় লাইনে দেখানো হয়েছে।'
WHERE lang.slug = 'c' AND m.slug = 'basics' AND l.slug = 'operators' AND qq.sort_order = 1;

UPDATE quiz_questions qq
JOIN lessons l ON l.id = qq.lesson_id
JOIN modules m ON m.id = l.module_id
JOIN languages lang ON lang.id = m.language_id
SET qq.explanation_bn = '`scanf("%f %f", &weight, &height)`-এ দুটো `%f` ফরম্যাট স্পেসিফায়ার আছে, প্রতিটার জন্য একটা করে অ্যাড্রেস (`&weight`, `&height`) — মানে দুটো আলাদা ভেরিয়েবলে ইনপুট নেওয়া হচ্ছে, একটাতে নয়।'
WHERE lang.slug = 'c' AND m.slug = 'basics' AND l.slug = 'first-calculation-program' AND qq.sort_order = 1;
