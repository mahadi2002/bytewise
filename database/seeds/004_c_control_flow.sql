-- C track, Module 2 (Control Flow): 4 lessons + quiz, following the exact
-- pattern content.sql established for Module 1 (Basics) — one concept
-- cluster per lesson, one output-prediction quiz question per lesson, the
-- last lesson a small applied "capstone" combining the module's concepts.
-- Run manually (not part of migrate.php --seed's auto-glob): mysql ... < 004_c_control_flow.sql

SELECT id INTO @lang_c FROM languages WHERE slug = 'c';
SELECT id INTO @c_cf FROM modules WHERE language_id = @lang_c AND slug = 'control-flow';

INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@c_cf, 'if-else', 'শর্ত ও if-else', 'Conditions & If-Else',
'`if` দিয়ে একটি শর্ত সত্যি হলে একটি ব্লক কোড চালানো যায়, আর `else` দিয়ে শর্ত মিথ্যা হলে অন্য একটি ব্লক। C-তে `==` দিয়ে সমতা যাচাই করতে হয় — একটা `=` (অ্যাসাইনমেন্ট) ভুল করে লিখলে কোড কম্পাইল হয়ে যায় কিন্তু ভুল ফলাফল দেয়, তাই এটা C-এর সবচেয়ে সাধারণ বাগগুলোর একটা।

একাধিক শর্ত পরপর যাচাই করতে `else if` ব্যবহার করা যায়।',
'#include <stdio.h>

int main() {
    int marks = 65;

    if (marks >= 80) {
        printf("Grade: A\n");
    } else if (marks >= 60) {
        printf("Grade: B\n");
    } else {
        printf("Grade: C\n");
    }
    return 0;
}',
'c', 10, 0, 1, 0),

(@c_cf, 'logical-operators', 'লজিক্যাল অপারেটর ও নেস্টেড if', 'Logical Operators & Nested If',
'দুই বা ততোধিক শর্ত একসাথে যাচাই করতে লজিক্যাল অপারেটর লাগে: `&&` (এবং — দুটোই সত্যি হতে হবে), `||` (অথবা — একটা সত্যি হলেই চলবে), আর `!` (না — উল্টে দেয়)। C-তে `0` মানে মিথ্যা, আর অন্য যেকোনো সংখ্যা মানে সত্যি — তাই `if (age)` লেখা মানেই `if (age != 0)`।

একটা `if`-এর ভেতরে আরেকটা `if` বসালে সেটাকে নেস্টেড if বলে।',
'#include <stdio.h>

int main() {
    int age = 20;
    int hasId = 1;

    if (age >= 18 && hasId) {
        printf("Entry allowed\n");
    } else {
        printf("Entry denied\n");
    }
    return 0;
}',
'c', 10, 0, 2, 0),

(@c_cf, 'while-for-loops', 'লুপ: while ও for', 'Loops: While & For',
'একই কাজ বারবার করতে হলে লুপ লাগে। `while` লুপ ব্যবহার হয় যখন কতবার চলবে তা আগে থেকে জানা না-ও থাকতে পারে — শুধু শর্তটা সত্যি থাকা পর্যন্ত চলে। `for` লুপ ব্যবহার হয় যখন ঠিক কতবার চলবে সেটা আগে থেকেই জানা থাকে — শুরু, শর্ত, আর প্রতি ধাপে কী বদলাবে, এই তিনটাই এক লাইনে লেখা যায়।

লুপের শর্ত ভুলে গেলে (বা কখনো মিথ্যা না হলে) সেটা *ইনফিনিট লুপ* হয়ে যায় — প্রোগ্রাম আটকে থাকে।',
'#include <stdio.h>

int main() {
    // for loop: exactly 5 times, i known in advance
    for (int i = 1; i <= 5; i++) {
        printf("%d ", i);
    }
    printf("\n");

    // while loop: runs until the condition fails
    int n = 20;
    while (n > 1) {
        n = n / 2;
    }
    printf("n reached: %d\n", n);
    return 0;
}',
'c', 10, 0, 3, 0),

(@c_cf, 'break-continue', 'break, continue ও একটা ছোট প্রোগ্রাম', 'Break, Continue & a Small Program',
'`break` লুপ থেকে সাথে সাথে বের করে দেয়, `continue` শুধু বর্তমান ধাপ স্কিপ করে পরের ধাপে যায়। এই লেসনে আগের তিনটা লেসনের সবকিছু একসাথে ব্যবহার করে ১ থেকে ৩০ পর্যন্ত জোড় সংখ্যাগুলো প্রিন্ট করা হচ্ছে, কিন্তু ২০-এ পৌঁছালে থেমে যাচ্ছে — এটাই এই মডিউলের শেষ কোডিং প্রবলেমে (FizzBuzz) লাগবে এমন প্যাটার্ন।',
'#include <stdio.h>

int main() {
    for (int i = 1; i <= 30; i++) {
        if (i == 20) {
            break; // stop the loop entirely
        }
        if (i % 2 != 0) {
            continue; // skip odd numbers
        }
        printf("%d ", i);
    }
    printf("\n");
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @c_cf_l1 FROM lessons WHERE module_id = @c_cf AND slug = 'if-else';
SELECT id INTO @c_cf_l2 FROM lessons WHERE module_id = @c_cf AND slug = 'logical-operators';
SELECT id INTO @c_cf_l3 FROM lessons WHERE module_id = @c_cf AND slug = 'while-for-loops';
SELECT id INTO @c_cf_l4 FROM lessons WHERE module_id = @c_cf AND slug = 'break-continue';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_cf_l1, 'নিচের কোডের আউটপুট কী হবে?', 'What will this code print?',
'int marks = 65;
if (marks >= 80) {
    printf("A");
} else if (marks >= 60) {
    printf("B");
} else {
    printf("C");
}',
'৬৫, ৮০-এর চেয়ে কম, তাই প্রথম `if` মিথ্যা। কিন্তু ৬০-এর চেয়ে বেশি বা সমান, তাই `else if (marks >= 60)` সত্যি হয় এবং "B" প্রিন্ট হয় — এরপর বাকি `else`-টা আর চেক-ই হয় না।',
1);
SELECT id INTO @c_cf_q1 FROM quiz_questions WHERE lesson_id = @c_cf_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_cf_q1, 'A', 'A', 0),
(@c_cf_q1, 'B', 'B', 1),
(@c_cf_q1, 'C', 'C', 0),
(@c_cf_q1, 'D', 'কিছুই প্রিন্ট হবে না', 0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_cf_l2, 'নিচের শর্তটি কখন সত্যি হবে?', 'When is this condition true?',
'if (age >= 18 && hasId)',
'`&&` মানে দুটো শর্তই সত্যি হতে হবে — শুধু বয়স ১৮+ হলেই চলবে না, `hasId`-ও অবশ্যই non-zero (সত্যি) হতে হবে। একটা মিথ্যা হলেই পুরো শর্তটা মিথ্যা।',
1);
SELECT id INTO @c_cf_q2 FROM quiz_questions WHERE lesson_id = @c_cf_l2 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_cf_q2, 'A', 'বয়স ১৮ বা তার বেশি হলেই, hasId না দেখে', 0),
(@c_cf_q2, 'B', 'hasId সত্যি হলেই, বয়স না দেখে', 0),
(@c_cf_q2, 'C', 'বয়স ১৮+ এবং hasId — দুটোই সত্যি হলে', 1),
(@c_cf_q2, 'D', 'কখনোই সত্যি হবে না', 0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_cf_l3, 'নিচের for লুপটি কতবার চলবে?', 'How many times does this for loop run?',
'for (int i = 1; i <= 5; i++) {
    printf("%d ", i);
}',
'`i` শুরু হয় ১ থেকে, আর `i <= 5` শর্ত সত্যি থাকা পর্যন্ত চলে — অর্থাৎ i = 1, 2, 3, 4, 5, মোট ৫ বার। i = 6 হলে শর্তটা মিথ্যা হয়ে লুপ থেমে যায়।',
1);
SELECT id INTO @c_cf_q3 FROM quiz_questions WHERE lesson_id = @c_cf_l3 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_cf_q3, 'A', '৪ বার', 0),
(@c_cf_q3, 'B', '৫ বার', 1),
(@c_cf_q3, 'C', '৬ বার', 0),
(@c_cf_q3, 'D', 'অসীম বার (ইনফিনিট লুপ)', 0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_cf_l4, 'নিচের লুপে `break` চলার পর প্রোগ্রামের কী হবে?', 'After `break` runs in this loop, what happens?',
'for (int i = 1; i <= 30; i++) {
    if (i == 20) {
        break;
    }
    printf("%d ", i);
}',
'`break` পুরো লুপটাই সাথে সাথে বন্ধ করে দেয় — `continue`-এর মতো শুধু একটা ধাপ স্কিপ করে না। তাই i = 20 হওয়া মাত্র লুপ থেমে যায়, ২০ থেকে ৩০ পর্যন্ত কিছুই প্রিন্ট হয় না এবং প্রোগ্রাম লুপের পরের লাইনে চলে যায়।',
1);
SELECT id INTO @c_cf_q4 FROM quiz_questions WHERE lesson_id = @c_cf_l4 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_cf_q4, 'A', 'লুপ সাথে সাথে থেমে যায়, প্রোগ্রাম পরের লাইনে চলে যায়', 1),
(@c_cf_q4, 'B', 'শুধু ২০ স্কিপ হয়ে লুপ চলতে থাকে', 0),
(@c_cf_q4, 'C', 'প্রোগ্রাম ক্র্যাশ করে', 0),
(@c_cf_q4, 'D', 'লুপ আবার ১ থেকে শুরু হয়', 0);
