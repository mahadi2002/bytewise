-- C track: Functions, Arrays & Strings, Pointers, Structs — the last 4
-- modules, closing out the C track. Same pattern as 004_c_control_flow.sql.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_c FROM languages WHERE slug = 'c';
SELECT id INTO @m_fn   FROM modules WHERE language_id = @lang_c AND slug = 'functions';
SELECT id INTO @m_arr  FROM modules WHERE language_id = @lang_c AND slug = 'arrays-strings';
SELECT id INTO @m_ptr  FROM modules WHERE language_id = @lang_c AND slug = 'pointers';
SELECT id INTO @m_st   FROM modules WHERE language_id = @lang_c AND slug = 'structs';

-- ── Functions ────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_fn, 'function-basics', 'ফাংশন ঘোষণা ও কল করা', 'Declaring & Calling Functions',
'একই কোড বারবার লিখতে না হয়, তার জন্য **ফাংশন** ব্যবহার করা হয়। একটি ফাংশনের একটি রিটার্ন টাইপ (যেমন `int`), একটি নাম, আর প্যারামিটার লিস্ট থাকে। `void` মানে ফাংশনটি কিছু রিটার্ন করে না।

`main()`-এর আগে বা `.h` ফাইলে ফাংশন *ডিক্লেয়ার* করলে, `main()`-এর পরে সেটা *ডিফাইন* করা যায় — কম্পাইলার আগেই জেনে যায় ফাংশনের সিগনেচার কী।',
'#include <stdio.h>

int square(int x) {
    return x * x;
}

int main() {
    int result = square(5);
    printf("Square: %d\n", result);
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_fn, 'function-parameters', 'প্যারামিটার ও pass-by-value', 'Parameters & Pass-by-Value',
'C-তে ফাংশনে আর্গুমেন্ট পাঠানো হয় **pass-by-value**-এ — মানে ফাংশনের ভেতরে প্যারামিটারের ভ্যালু পরিবর্তন করলে, আসল (কলার-সাইড) ভেরিয়েবলে তার কোনো প্রভাব পড়ে না। ফাংশনটা শুধু ভ্যালুর একটা *কপি* পায়।',
'#include <stdio.h>

void tryToChange(int x) {
    x = 100; // only changes the local copy
}

int main() {
    int num = 5;
    tryToChange(num);
    printf("num is still: %d\n", num); // 5, unchanged
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_fn, 'scope', 'স্কোপ: লোকাল ও গ্লোবাল ভেরিয়েবল', 'Scope: Local vs Global Variables',
'একটি ফাংশনের ভেতরে ঘোষণা করা ভেরিয়েবল সেই ফাংশনের বাইরে থেকে দেখা যায় না — এটাকে **লোকাল স্কোপ** বলে। সব ফাংশনের বাইরে ঘোষণা করা ভেরিয়েবল **গ্লোবাল** — পুরো ফাইলের যেকোনো ফাংশন থেকে অ্যাক্সেস করা যায়। গ্লোবাল ভেরিয়েবল বেশি ব্যবহার করলে কোড বোঝা কঠিন হয়ে যায়, তাই যতটা সম্ভব লোকাল ভেরিয়েবল ব্যবহার করাই ভালো অভ্যাস।',
'#include <stdio.h>

int counter = 0; // global

void increment() {
    counter++; // accesses the global
}

int main() {
    increment();
    increment();
    printf("Counter: %d\n", counter); // 2
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_fn, 'recursion-intro', 'রিকার্শন: নিজেকে কল করা ফাংশন', 'Recursion: A Function That Calls Itself',
'একটি ফাংশন নিজেকেই কল করলে তাকে **রিকার্শন** বলে। প্রতিটি রিকার্সিভ ফাংশনের একটি **base case** থাকতে হবে — যেখানে ফাংশনটি নিজেকে আর কল না করে সরাসরি একটা মান রিটার্ন করে। base case না থাকলে ফাংশনটি অসীমবার কল হতে থাকবে এবং প্রোগ্রাম ক্র্যাশ করবে (stack overflow)।',
'#include <stdio.h>

int factorial(int n) {
    if (n <= 1) {
        return 1; // base case
    }
    return n * factorial(n - 1); // recursive case
}

int main() {
    printf("5! = %d\n", factorial(5)); // 120
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @c_fn_l1 FROM lessons WHERE module_id=@m_fn AND slug='function-basics';
SELECT id INTO @c_fn_l2 FROM lessons WHERE module_id=@m_fn AND slug='function-parameters';
SELECT id INTO @c_fn_l3 FROM lessons WHERE module_id=@m_fn AND slug='scope';
SELECT id INTO @c_fn_l4 FROM lessons WHERE module_id=@m_fn AND slug='recursion-intro';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_fn_l1, 'নিচের কোডের আউটপুট কী হবে?', 'What does this print?', 'int square(int x) { return x * x; }
printf("%d", square(5));',
'`square(5)` কল হলে `x = 5`, আর ফাংশনটি `x * x` অর্থাৎ `5 * 5 = 25` রিটার্ন করে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_fn_l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','10',0),(@q,'C','25',1),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_fn_l2, 'নিচের কোডের পর num-এর মান কত হবে?', 'What is num after this?', 'void tryToChange(int x) { x = 100; }
int num = 5;
tryToChange(num);',
'C-তে আর্গুমেন্ট pass-by-value-এ যায় — `tryToChange` শুধু `num`-এর একটা কপি (`x`) পায় এবং সেই কপিটাই বদলায়। আসল `num` অপরিবর্তিত থাকে, তাই এখনও `5`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_fn_l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',1),(@q,'B','100',0),(@q,'C','0',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_fn_l3, 'নিচের কোডে counter-এর ফাইনাল ভ্যালু কত?', 'What is the final value of counter?', 'int counter = 0;
void increment() { counter++; }
increment();
increment();',
'`counter` একটি গ্লোবাল ভেরিয়েবল, তাই `increment()`-এর প্রতিটি কল একই `counter`-কে পরিবর্তন করে — দুইবার কল করায় `0 → 1 → 2`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_fn_l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',0),(@q,'B','1',0),(@q,'C','2',1),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_fn_l4, 'factorial(3) কল করলে ফলাফল কত হবে?', 'What does factorial(3) return?', 'int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}',
'`factorial(3) = 3 * factorial(2) = 3 * (2 * factorial(1)) = 3 * 2 * 1 = 6`। `factorial(1)` base case-এ পৌঁছে `1` রিটার্ন করে, তারপর প্রতিটি কল পেছনের দিকে গুণ করতে করতে ফলাফল তৈরি হয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_fn_l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','6',1),(@q,'C','9',0),(@q,'D','Infinite loop',0);

-- ── Arrays & Strings ─────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_arr, 'arrays-basics', 'অ্যারে: একাধিক ভ্যালু একসাথে রাখা', 'Arrays: Storing Multiple Values',
'একই টাইপের একাধিক ভ্যালু একসাথে রাখতে **অ্যারে** ব্যবহার হয়। C-তে অ্যারের সাইজ ঘোষণার সময়েই ফিক্সড হয়ে যায়, আর ইনডেক্স `0` থেকে শুরু হয় — তাই সাইজ `5`-এর অ্যারের শেষ ইনডেক্স `4`, `5` নয়।',
'#include <stdio.h>

int main() {
    int scores[5] = {90, 85, 78, 92, 88};

    for (int i = 0; i < 5; i++) {
        printf("%d ", scores[i]);
    }
    printf("\n");
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_arr, 'strings-in-c', 'C-তে স্ট্রিং: char অ্যারে', 'Strings in C: Char Arrays',
'C-তে আলাদা কোনো "string" টাইপ নেই — স্ট্রিং আসলে `char`-দের একটি অ্যারে, যার শেষে একটি বিশেষ null character (`\\0`) থাকে যা বলে দেয় স্ট্রিংটা কোথায় শেষ। `printf()`-এ `%s` দিয়ে পুরো স্ট্রিং প্রিন্ট করা যায়।',
'#include <stdio.h>

int main() {
    char name[20] = "Bytewise";
    printf("Hello, %s!\n", name);
    printf("First letter: %c\n", name[0]);
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_arr, 'string-functions', 'স্ট্রিং ফাংশন: strlen, strcpy, strcmp', 'String Functions: strlen, strcpy, strcmp',
'`<string.h>` হেডারে অনেক রেডিমেড স্ট্রিং ফাংশন আছে। `strlen()` দিয়ে স্ট্রিংয়ের দৈর্ঘ্য (null character বাদে) পাওয়া যায়, `strcpy()` দিয়ে এক স্ট্রিং আরেকটাতে কপি করা যায়, আর `strcmp()` দিয়ে দুটো স্ট্রিং তুলনা করা যায় — মনে রাখবেন, স্ট্রিং তুলনায় `==` কাজ করে না, কারণ সেটা অ্যাড্রেস তুলনা করে, কনটেন্ট নয়।',
'#include <stdio.h>
#include <string.h>

int main() {
    char a[20] = "hello";
    printf("Length: %d\n", (int) strlen(a));

    if (strcmp(a, "hello") == 0) {
        printf("Strings are equal\n");
    }
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_arr, 'array-string-capstone', 'ক্যাপস্টোন: সবচেয়ে বড় ভ্যালু খুঁজে বের করা', 'Capstone: Finding the Maximum Value',
'আগের তিনটা লেসনের ধারণা একসাথে ব্যবহার করে এখন একটা ছোট প্রোগ্রাম লেখা হচ্ছে — একটা অ্যারে লুপ করে তার মধ্যে সবচেয়ে বড় ভ্যালুটা বের করা। এই প্যাটার্নটাই (একটা "রানিং" ভেরিয়েবলে সবচেয়ে ভালো উত্তরটা রেখে দেওয়া) এই মডিউলের কোডিং প্রবলেমে লাগবে।',
'#include <stdio.h>

int main() {
    int nums[5] = {12, 45, 7, 89, 34};
    int maxVal = nums[0];

    for (int i = 1; i < 5; i++) {
        if (nums[i] > maxVal) {
            maxVal = nums[i];
        }
    }
    printf("Max: %d\n", maxVal);
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @c_arr_l1 FROM lessons WHERE module_id=@m_arr AND slug='arrays-basics';
SELECT id INTO @c_arr_l2 FROM lessons WHERE module_id=@m_arr AND slug='strings-in-c';
SELECT id INTO @c_arr_l3 FROM lessons WHERE module_id=@m_arr AND slug='string-functions';
SELECT id INTO @c_arr_l4 FROM lessons WHERE module_id=@m_arr AND slug='array-string-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_arr_l1, 'int scores[5] অ্যারেতে বৈধ ইনডেক্স কোনগুলো?', 'Which indices are valid for int scores[5]?', 'int scores[5] = {90, 85, 78, 92, 88};',
'সাইজ `5`-এর অ্যারেতে ইনডেক্স `0` থেকে শুরু হয়ে `size - 1` অর্থাৎ `4` পর্যন্ত বৈধ — মোট ৫টি ইনডেক্স (0,1,2,3,4)। `scores[5]` অ্যাক্সেস করলে অ্যারের বাইরে চলে যায় (undefined behavior)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_arr_l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','1 থেকে 5',0),(@q,'B','0 থেকে 4',1),(@q,'C','0 থেকে 5',0),(@q,'D','1 থেকে 4',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_arr_l2, 'C-তে একটি স্ট্রিং আসলে কী?', 'What is a string in C, really?', 'char name[20] = "Bytewise";',
'C-তে আলাদা "string" টাইপ নেই — এটা `char`-দের একটি অ্যারে, যার শেষে একটি null character (`\0`) থাকে যা স্ট্রিংয়ের শেষ চিহ্নিত করে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_arr_l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটি আলাদা built-in স্ট্রিং টাইপ',0),(@q,'B','একটি char অ্যারে, শেষে null character সহ',1),(@q,'C','একটি সংখ্যা',0),(@q,'D','একটি পয়েন্টার, যার কোনো ডেটা নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_arr_l3, 'দুটো স্ট্রিংয়ের কনটেন্ট তুলনা করতে কী ব্যবহার করা উচিত?', 'What should you use to compare two strings by content?', 'if (strcmp(a, "hello") == 0) { ... }',
'`==` স্ট্রিংয়ের ক্ষেত্রে অ্যাড্রেস তুলনা করে, কনটেন্ট নয় — তাই প্রায় সবসময় ভুল ফলাফল দেয়। `strcmp()` কনটেন্ট তুলনা করে এবং সমান হলে `0` রিটার্ন করে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_arr_l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','== অপারেটর',0),(@q,'B','strcmp()',1),(@q,'C','strlen()',0),(@q,'D','strcpy()',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_arr_l4, 'নিচের কোডে maxVal-এর ফাইনাল মান কত হবে?', 'What is the final value of maxVal?', 'int nums[5] = {12, 45, 7, 89, 34};
int maxVal = nums[0];
for (int i = 1; i < 5; i++) {
    if (nums[i] > maxVal) maxVal = nums[i];
}',
'লুপটি প্রতিটি এলিমেন্ট চেক করে, বর্তমান `maxVal`-এর চেয়ে বড় হলে আপডেট করে — `12 → 45 → 45 → 89 → 89`। অ্যারেতে `89` সবচেয়ে বড়, তাই ফাইনাল `maxVal = 89`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_arr_l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','12',0),(@q,'B','34',0),(@q,'C','89',1),(@q,'D','45',0);

-- ── Pointers ─────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_ptr, 'pointer-basics', 'পয়েন্টার: & আর *', 'Pointer Basics: & and *',
'একটি **পয়েন্টার** হলো এমন একটি ভেরিয়েবল, যাতে ভ্যালুর বদলে অন্য একটি ভেরিয়েবলের **মেমোরি অ্যাড্রেস** রাখা হয়। `&` (address-of) দিয়ে কোনো ভেরিয়েবলের অ্যাড্রেস পাওয়া যায়, আর `*` (dereference) দিয়ে সেই অ্যাড্রেসে থাকা ভ্যালুতে অ্যাক্সেস করা যায়। এটাই `scanf()`-এ `&age` লেখার আসল কারণ, যা আগের একটা লেসনে দেখা গিয়েছিল।',
'#include <stdio.h>

int main() {
    int age = 25;
    int *ptr = &age; // ptr stores age''s address

    printf("Value: %d\n", *ptr); // dereference: 25
    printf("Address: %p\n", (void*) ptr);
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_ptr, 'pointers-and-arrays', 'পয়েন্টার ও অ্যারের সম্পর্ক', 'Pointers and Arrays',
'C-তে একটি অ্যারের নাম আসলে তার প্রথম এলিমেন্টের অ্যাড্রেসের মতো আচরণ করে — তাই `arr` আর `&arr[0]` একই জিনিস বোঝায়। **পয়েন্টার অ্যারিথমেটিক**-এ `ptr + 1` মানে পরের এলিমেন্টের অ্যাড্রেস (টাইপের সাইজ অনুযায়ী নিজে থেকেই এগিয়ে যায়, ১ বাইট নয়)।',
'#include <stdio.h>

int main() {
    int nums[3] = {10, 20, 30};
    int *ptr = nums; // same as &nums[0]

    printf("%d\n", *ptr);       // 10
    printf("%d\n", *(ptr + 1)); // 20
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_ptr, 'pointers-and-functions', 'পয়েন্টার দিয়ে ফাংশনে ভ্যালু পরিবর্তন', 'Modifying Values via Function with Pointers',
'আগে দেখা গিয়েছিল pass-by-value-এ ফাংশনের ভেতর থেকে আসল ভেরিয়েবল বদলানো যায় না। কিন্তু ভ্যালুর বদলে *অ্যাড্রেস* পাঠালে, ফাংশনটি সেই অ্যাড্রেসে গিয়ে সরাসরি আসল ভ্যালু পরিবর্তন করতে পারে — এটাই `swap`-জাতীয় ফাংশনের ভিত্তি।',
'#include <stdio.h>

void increment(int *x) {
    (*x)++; // modifies the original value
}

int main() {
    int num = 5;
    increment(&num);
    printf("num is now: %d\n", num); // 6
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_ptr, 'pointer-swap-capstone', 'ক্যাপস্টোন: দুটি ভ্যালু swap করা', 'Capstone: Swapping Two Values',
'এই লেসনে আগের তিনটা ধারণা একসাথে ব্যবহার করে একটা ক্লাসিক প্রবলেম সমাধান করা হচ্ছে — পয়েন্টার দিয়ে দুটো ভ্যারিয়েবলের ভ্যালু অদল-বদল করা, কোনো তৃতীয় গ্লোবাল ভেরিয়েবল ছাড়াই।',
'#include <stdio.h>

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int x = 1, y = 2;
    swap(&x, &y);
    printf("x=%d y=%d\n", x, y); // x=2 y=1
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @c_ptr_l1 FROM lessons WHERE module_id=@m_ptr AND slug='pointer-basics';
SELECT id INTO @c_ptr_l2 FROM lessons WHERE module_id=@m_ptr AND slug='pointers-and-arrays';
SELECT id INTO @c_ptr_l3 FROM lessons WHERE module_id=@m_ptr AND slug='pointers-and-functions';
SELECT id INTO @c_ptr_l4 FROM lessons WHERE module_id=@m_ptr AND slug='pointer-swap-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_ptr_l1, '*ptr কী রিটার্ন করবে?', 'What does *ptr give here?', 'int age = 25;
int *ptr = &age;
printf("%d", *ptr);',
'`ptr`-এ `age`-এর অ্যাড্রেস রাখা আছে। `*ptr` (dereference) মানে সেই অ্যাড্রেসে গিয়ে সেখানকার ভ্যালু নিয়ে আসা — যা `age`-এর মান, অর্থাৎ `25`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_ptr_l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','25',1),(@q,'B','age ভেরিয়েবলের অ্যাড্রেস',0),(@q,'C','0',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_ptr_l2, '*(ptr + 1) এর মান কত হবে?', 'What is *(ptr + 1)?', 'int nums[3] = {10, 20, 30};
int *ptr = nums;
printf("%d", *(ptr + 1));',
'`ptr`, `nums`-এর প্রথম এলিমেন্টের (index 0, ভ্যালু 10) অ্যাড্রেস ধারণ করে। `ptr + 1` মানে পরের এলিমেন্টের (index 1) অ্যাড্রেস — সেটা dereference করলে পাওয়া যায় `20`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_ptr_l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','10',0),(@q,'B','20',1),(@q,'C','30',0),(@q,'D','একটা অ্যাড্রেস, সংখ্যা নয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_ptr_l3, 'increment(&num) কল করার পর num-এর মান কত হবে?', 'What is num after increment(&num)?', 'void increment(int *x) { (*x)++; }
int num = 5;
increment(&num);',
'এবার `num`-এর ভ্যালুর বদলে তার *অ্যাড্রেস* পাঠানো হয়েছে, তাই ফাংশনটি সরাসরি আসল `num`-কেই পরিবর্তন করে — `(*x)++` মানে সেই অ্যাড্রেসের ভ্যালু ১ বাড়ানো, ফলে `num` হয়ে যায় `6`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_ptr_l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5 (অপরিবর্তিত)',0),(@q,'B','6',1),(@q,'C','Error',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_ptr_l4, 'swap(&x, &y) কল করার পর x এবং y-এর মান কত হবে?', 'What are x and y after swap(&x, &y)?', 'void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
int x = 1, y = 2;
swap(&x, &y);',
'দুটো ভেরিয়েবলের *অ্যাড্রেস* পাঠানোয় `swap()` সরাসরি আসল `x`, `y`-কে বদলাতে পারে — `temp`-এ `x`-এর পুরনো মান (1) রেখে, `x`-এ `y`-এর মান (2) বসানো হয়, তারপর `y`-এ `temp` (1) বসানো হয়। ফলাফল: `x=2, y=1`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_ptr_l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','x=1, y=2 (অপরিবর্তিত)',0),(@q,'B','x=2, y=1',1),(@q,'C','x=0, y=0',0),(@q,'D','Compile error',0);

-- ── Structs ──────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_st, 'struct-basics', 'স্ট্রাক্ট: একসাথে সম্পর্কিত ডেটা রাখা', 'Structs: Grouping Related Data',
'একটা student-এর নাম, বয়স, আর মার্কস — এই তিনটে আলাদা ভেরিয়েবলে না রেখে, C-তে **struct** দিয়ে একসাথে একটা কাস্টম টাইপ বানানো যায়। `.` (ডট) অপারেটর দিয়ে struct-এর মেম্বার অ্যাক্সেস করা হয়।',
'#include <stdio.h>

struct Student {
    char name[20];
    int age;
    float gpa;
};

int main() {
    struct Student s1 = {"Rafi", 20, 3.8};
    printf("%s is %d years old\n", s1.name, s1.age);
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_st, 'struct-and-functions', 'স্ট্রাক্ট ফাংশনে পাঠানো', 'Passing Structs to Functions',
'স্ট্রাক্টও একটা ভেরিয়েবলের মতোই ফাংশনে পাঠানো যায় — ডিফল্টভাবে সেটাও pass-by-value (পুরো স্ট্রাক্টের একটা কপি ফাংশন পায়)। বড় স্ট্রাক্টের জন্য এটা স্লো হতে পারে, তখন পয়েন্টার (`struct Student *`) পাঠানো ভালো — কিন্তু ছোট স্ট্রাক্টে সরাসরি পাঠানোই যথেষ্ট।',
'#include <stdio.h>

struct Point { int x, y; };

void printPoint(struct Point p) {
    printf("(%d, %d)\n", p.x, p.y);
}

int main() {
    struct Point p1 = {3, 7};
    printPoint(p1);
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_st, 'array-of-structs', 'স্ট্রাক্টের অ্যারে', 'Arrays of Structs',
'একই টাইপের একাধিক struct একসাথে রাখতে সাধারণ অ্যারের মতোই struct-এর অ্যারে বানানো যায় — যেমন একাধিক স্টুডেন্টের রেকর্ড। এটাই বাস্তব প্রোগ্রামে (যেমন একটা ছোট ডাটাবেস) সবচেয়ে বেশি ব্যবহৃত প্যাটার্নগুলোর একটা।',
'#include <stdio.h>

struct Student { char name[20]; int marks; };

int main() {
    struct Student students[2] = {
        {"Rafi", 85},
        {"Nadia", 92}
    };

    for (int i = 0; i < 2; i++) {
        printf("%s: %d\n", students[i].name, students[i].marks);
    }
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_st, 'struct-capstone', 'ক্যাপস্টোন: সবচেয়ে বেশি মার্কস কার', 'Capstone: Finding the Top Scorer',
'আগের তিনটা লেসনের সবকিছু একসাথে — struct-এর অ্যারে লুপ করে, কোন স্টুডেন্টের মার্কস সবচেয়ে বেশি সেটা বের করা। এই একই প্যাটার্ন (অ্যারে লুপ করে "সেরা"টা ট্র্যাক রাখা) আগে সাধারণ অ্যারেতেও দেখা গিয়েছিল — এখন সেটা struct-এর সাথে প্রয়োগ করা হচ্ছে।',
'#include <stdio.h>

struct Student { char name[20]; int marks; };

int main() {
    struct Student students[3] = {
        {"Rafi", 85}, {"Nadia", 92}, {"Tanvir", 78}
    };

    int topIndex = 0;
    for (int i = 1; i < 3; i++) {
        if (students[i].marks > students[topIndex].marks) {
            topIndex = i;
        }
    }
    printf("Top scorer: %s\n", students[topIndex].name);
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @c_st_l1 FROM lessons WHERE module_id=@m_st AND slug='struct-basics';
SELECT id INTO @c_st_l2 FROM lessons WHERE module_id=@m_st AND slug='struct-and-functions';
SELECT id INTO @c_st_l3 FROM lessons WHERE module_id=@m_st AND slug='array-of-structs';
SELECT id INTO @c_st_l4 FROM lessons WHERE module_id=@m_st AND slug='struct-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_st_l1, 's1.age এর মান কত হবে?', 'What is s1.age?', 'struct Student { char name[20]; int age; float gpa; };
struct Student s1 = {"Rafi", 20, 3.8};',
'struct-এর মেম্বারগুলো ঘোষণার একই ক্রমে ভ্যালু পায় — `name = "Rafi"`, `age = 20`, `gpa = 3.8`। তাই `s1.age` হলো `20`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_st_l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','20',1),(@q,'C','3.8',0),(@q,'D','0',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_st_l2, 'printPoint(p1) কল করার পর p1 কি পরিবর্তিত হবে?', 'After printPoint(p1), is p1 modified?', 'void printPoint(struct Point p) { ... }
printPoint(p1);',
'ডিফল্টভাবে struct-ও pass-by-value — `printPoint` `p1`-এর একটা কপি পায়, আসল `p1` অপরিবর্তিত থাকে। মূল স্ট্রাক্টকে সত্যিই পরিবর্তন করতে হলে পয়েন্টার পাঠাতে হতো (`struct Point *p`)।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_st_l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','হ্যাঁ, সবসময় পরিবর্তিত হবে',0),(@q,'B','না, কারণ এটা একটা কপি পেয়েছে',1),(@q,'C','শুধু x পরিবর্তিত হবে',0),(@q,'D','Compile error হবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_st_l3, 'students[1].name এর মান কী হবে?', 'What is students[1].name?', 'struct Student students[2] = {
    {"Rafi", 85},
    {"Nadia", 92}
};',
'`students` একটা struct-এর অ্যারে, যেখানে ইনডেক্স `0` = Rafi, ইনডেক্স `1` = Nadia। তাই `students[1].name` হলো `"Nadia"`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_st_l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','Nadia',1),(@q,'C','85',0),(@q,'D','92',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@c_st_l4, 'নিচের কোডে কে "Top scorer" হিসেবে প্রিন্ট হবে?', 'Who gets printed as Top scorer?', 'struct Student students[3] = {
    {"Rafi", 85}, {"Nadia", 92}, {"Tanvir", 78}
};
// loop finds the student with the highest marks',
'মার্কস অনুযায়ী: Rafi 85, Nadia 92, Tanvir 78 — এদের মধ্যে সবচেয়ে বেশি মার্কস Nadia-র (92), তাই লুপ শেষে `topIndex` তার ইনডেক্সে থাকবে এবং "Nadia" প্রিন্ট হবে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@c_st_l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','Nadia',1),(@q,'C','Tanvir',0),(@q,'D','সবাই সমান',0);
