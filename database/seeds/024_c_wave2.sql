-- C track: Enums & Unions + Dynamic Memory Management (new modules 9-10).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_c FROM languages WHERE slug = 'c';
SELECT id INTO @m_enum FROM modules WHERE language_id=@lang_c AND slug='enums-unions';
SELECT id INTO @m_mem  FROM modules WHERE language_id=@lang_c AND slug='memory-mgmt';

-- ── Enums & Unions ───────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_enum, 'enum-basics', 'এনাম: নামযুক্ত ধ্রুবক', 'Enums: Named Constants',
'সংখ্যার বদলে অর্থবহ নাম ব্যবহার করতে `enum` কাজে লাগে — যেমন দিনের নাম বা স্ট্যাটাস কোড। ডিফল্টভাবে প্রথম মানটা `0`, তারপর প্রতিটা পরের মান আগেরটার চেয়ে ১ বেশি — কিন্তু চাইলে নিজে থেকেও নির্দিষ্ট মান দেওয়া যায়।',
'#include <stdio.h>

enum Day { MON, TUE, WED, THU, FRI, SAT, SUN };

int main() {
    enum Day today = WED;
    printf("%d\n", today); // 2 — WED is the 3rd member, index 2
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_enum, 'union-basics', 'ইউনিয়ন: শেয়ার করা মেমোরি', 'Unions: Shared Memory',
'`union` দেখতে `struct`-এর মতোই, কিন্তু বড় পার্থক্য: struct-এর প্রতিটা মেম্বারের নিজস্ব আলাদা মেমোরি থাকে, কিন্তু union-এর সব মেম্বার *একই* মেমোরি শেয়ার করে — একসাথে শুধু একটা মেম্বারের মানই বৈধ থাকে। union-এর সাইজ তার সবচেয়ে বড় মেম্বারের সমান।',
'#include <stdio.h>

union Value {
    int i;
    float f;
};

int main() {
    union Value v;
    v.i = 10;
    printf("As int: %d\n", v.i);

    v.f = 3.14; // overwrites the same memory i used
    printf("As float: %.2f\n", v.f);
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_enum, 'enum-in-switch', 'switch-এর সাথে enum', 'Enums with switch',
'enum প্রায়ই `switch` স্টেটমেন্টের সাথে ব্যবহার হয় — সংখ্যার বদলে অর্থবহ নাম দিয়ে কোড অনেক বেশি পড়ার-উপযোগী হয়। কম্পাইলার প্রায়ই ওয়ার্নিং দেয় যদি enum-এর কোনো মান `switch`-এ handle না করা হয়, যা ভুল ধরতে সাহায্য করে।',
'#include <stdio.h>

enum Status { PENDING, ACTIVE, EXPIRED };

int main() {
    enum Status s = ACTIVE;
    switch (s) {
        case PENDING: printf("Pending\n"); break;
        case ACTIVE:  printf("Active\n");  break;
        case EXPIRED: printf("Expired\n"); break;
    }
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_enum, 'enum-union-capstone', 'ক্যাপস্টোন: ট্যাগড ইউনিয়ন', 'Capstone: A Tagged Union',
'union-এর একটা সমস্যা: এটা নিজে থেকে জানে না তার ভেতরে বর্তমানে কোন টাইপের মান আছে। enum দিয়ে একটা "ট্যাগ" রেখে সেই সমস্যা সমাধান করা হচ্ছে — একটা খুবই কমন, বাস্তব প্যাটার্ন।',
'#include <stdio.h>

enum Type { AS_INT, AS_FLOAT };

struct Tagged {
    enum Type type;
    union {
        int i;
        float f;
    } value;
};

int main() {
    struct Tagged t;
    t.type = AS_FLOAT;
    t.value.f = 9.5;

    if (t.type == AS_FLOAT) {
        printf("Float: %.1f\n", t.value.f);
    }
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_enum AND slug='enum-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_enum AND slug='union-basics';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_enum AND slug='enum-in-switch';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_enum AND slug='enum-union-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'enum Day { MON, TUE, WED, ... } এ WED এর মান কত?', 'What is the value of WED?', 'enum Day { MON, TUE, WED, THU, FRI, SAT, SUN };',
'ডিফল্টভাবে enum-এর প্রথম মেম্বার `0` থেকে শুরু হয়ে প্রতিটা পরেরটা ১ করে বাড়ে — MON=0, TUE=1, WED=2।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','2',1),(@q,'C','"WED"',0),(@q,'D','0',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'v.f = 3.14 লেখার পর v.i এর মান কী হবে?', 'What happens to v.i after v.f = 3.14?', 'union Value { int i; float f; };
union Value v;
v.i = 10;
v.f = 3.14;',
'union-এর সব মেম্বার একই মেমোরি শেয়ার করে — `v.f`-এ নতুন মান লেখা মানে সেই একই মেমোরিতে লেখা, যেখানে আগে `v.i` ছিল। তাই `v.i` আর `10` থাকে না, এটা এখন `v.f`-এর বাইট-প্যাটার্নকে int হিসেবে ভুলভাবে পড়া একটা অর্থহীন মান দেখাবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এখনও 10',0),(@q,'B','একটা অর্থহীন মান, কারণ মেমোরি শেয়ার্ড',1),(@q,'C','0',0),(@q,'D','3',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 's = ACTIVE হলে switch-এ কী প্রিন্ট হবে?', 'What prints when s = ACTIVE?', 'enum Status { PENDING, ACTIVE, EXPIRED };
enum Status s = ACTIVE;
switch (s) {
    case PENDING: printf("Pending"); break;
    case ACTIVE:  printf("Active");  break;
    case EXPIRED: printf("Expired"); break;
}',
'`s`-এর মান `ACTIVE`, তাই `switch` সেই `case ACTIVE`-এ গিয়ে "Active" প্রিন্ট করে এবং `break` দিয়ে থেমে যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Pending',0),(@q,'B','Active',1),(@q,'C','Expired',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 't.type == AS_FLOAT চেক করার কারণ কী?', 'Why check t.type == AS_FLOAT?', 'if (t.type == AS_FLOAT) {
    printf("Float: %.1f\n", t.value.f);
}',
'union নিজে থেকে জানে না তার ভেতরে বর্তমানে কোন টাইপের মান আছে — তাই `type` ফিল্ডটা একটা "ট্যাগ" হিসেবে রাখা হয়েছে, যা বলে দেয় union-এর `value`-কে কোন মেম্বার হিসেবে পড়া নিরাপদ। ট্যাগ না দেখে union পড়লে ভুল টাইপ হিসেবে পড়ার ঝুঁকি থাকে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','union কোন টাইপে আছে তা নিরাপদে জানতে',1),(@q,'B','এটা ঐচ্ছিক, কোনো কারণ নেই',0),(@q,'C','মেমোরি বাঁচাতে',0),(@q,'D','কম্পাইল এরর ঠেকাতে',0);

-- ── Dynamic Memory Management ────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_mem, 'malloc-free', 'malloc() ও free()', 'malloc() & free()',
'এতদিনের অ্যারে কম্পাইল-টাইমে ফিক্সড সাইজের ছিল। `malloc()` দিয়ে রানটাইমে (প্রোগ্রাম চলাকালীন) দরকারমতো মেমোরি চাওয়া যায় — একে **heap মেমোরি** বলে। ব্যবহার শেষে `free()` দিয়ে সেটা ফেরত দিতে *হয়*, নাহলে **মেমোরি লিক** হয় — মেমোরি ব্যবহারযোগ্য থেকে যায় কিন্তু আর কখনো ফেরত দেওয়া হয় না।',
'#include <stdio.h>
#include <stdlib.h>

int main() {
    int *arr = malloc(5 * sizeof(int)); // room for 5 ints
    if (arr == NULL) return 1;

    for (int i = 0; i < 5; i++) {
        arr[i] = i * i;
    }
    printf("%d\n", arr[3]); // 9

    free(arr); // give the memory back
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_mem, 'calloc-realloc', 'calloc() ও realloc()', 'calloc() & realloc()',
'`calloc()` `malloc()`-এর মতোই, কিন্তু বরাদ্দ করা মেমোরি স্বয়ংক্রিয়ভাবে `0`-তে সেট করে দেয় (malloc করে না — নতুন মেমোরিতে যা আগে থেকে ছিল তাই থাকে)। `realloc()` দিয়ে আগে থেকে বরাদ্দ করা মেমোরির সাইজ বদলানো যায় — যেমন একটা ডাইনামিক অ্যারে বড় করা।',
'#include <stdio.h>
#include <stdlib.h>

int main() {
    int *arr = calloc(3, sizeof(int)); // {0, 0, 0}
    printf("%d\n", arr[0]); // 0, guaranteed

    arr = realloc(arr, 5 * sizeof(int)); // grow to 5 ints
    arr[3] = 100;
    printf("%d\n", arr[3]); // 100

    free(arr);
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_mem, 'memory-leaks', 'মেমোরি লিক ও ডাংলিং পয়েন্টার', 'Memory Leaks & Dangling Pointers',
'`free()` করতে ভুলে গেলে **মেমোরি লিক** হয়। কিন্তু `free()` করার পর সেই পয়েন্টার আবার ব্যবহার করলে (বা দুইবার `free()` করলে) সেটাও বিপজ্জনক — একে **ডাংলিং পয়েন্টার** বলে। `free()`-এর পর পয়েন্টারকে `NULL` বসিয়ে দেওয়া একটা ভালো অভ্যাস, যাতে ভুলে আবার ব্যবহার হলে সহজে ধরা পড়ে।',
'#include <stdio.h>
#include <stdlib.h>

int main() {
    int *p = malloc(sizeof(int));
    *p = 42;
    free(p);
    p = NULL; // good practice: avoid a dangling pointer

    if (p != NULL) {
        printf("%d\n", *p); // never reached — safe
    }
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_mem, 'memory-mgmt-capstone', 'ক্যাপস্টোন: ডাইনামিক অ্যারে বড় করা', 'Capstone: Growing a Dynamic Array',
'একটা ছোট অ্যারে দিয়ে শুরু করে, দরকার হলে `realloc()` দিয়ে বড় করে নতুন এলিমেন্ট যোগ করার প্যাটার্ন — ঠিক এভাবেই C++-এর `vector` বা Python-এর `list`-এর মতো ডাইনামিক কালেকশন ভেতরে ভেতরে কাজ করে।',
'#include <stdio.h>
#include <stdlib.h>

int main() {
    int capacity = 2;
    int count = 0;
    int *arr = malloc(capacity * sizeof(int));

    for (int i = 1; i <= 5; i++) {
        if (count == capacity) {
            capacity *= 2;
            arr = realloc(arr, capacity * sizeof(int));
        }
        arr[count++] = i;
    }

    printf("Last: %d, capacity: %d\n", arr[count - 1], capacity); // 5, 8
    free(arr);
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_mem AND slug='malloc-free';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_mem AND slug='calloc-realloc';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_mem AND slug='memory-leaks';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_mem AND slug='memory-mgmt-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'free(arr) না করলে কী হবে?', 'What happens if free(arr) is skipped?', 'int *arr = malloc(5 * sizeof(int));
// ... use arr ...
// free(arr); <- skipped',
'`malloc()`-এ পাওয়া মেমোরি ফেরত না দিলে সেটা "লিক" হয়ে যায় — প্রোগ্রাম চলাকালীন সেই মেমোরি আর কখনো ব্যবহারযোগ্য হিসেবে ফেরত আসে না, বারবার এমন হতে থাকলে প্রোগ্রাম ধীরে ধীরে বেশি বেশি মেমোরি দখল করতে থাকে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রোগ্রাম সাথে সাথে ক্র্যাশ করে',0),(@q,'B','মেমোরি লিক হয় — সেই মেমোরি আর ফেরত পাওয়া যায় না',1),(@q,'C','কিছুই হয় না, C নিজে থেকে পরিষ্কার করে',0),(@q,'D','arr স্বয়ংক্রিয়ভাবে NULL হয়ে যায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'calloc(3, sizeof(int)) এর পর arr[0] এর মান কত হবে?', 'What is arr[0] after calloc?', 'int *arr = calloc(3, sizeof(int));
arr[0]',
'`malloc()`-এর মতো `calloc()`-ও মেমোরি বরাদ্দ করে, কিন্তু অতিরিক্ত সুবিধা হিসেবে সেই মেমোরি স্বয়ংক্রিয়ভাবে `0`-তে সেট করে দেয় — তাই `arr[0]` নিশ্চিতভাবে `0`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','অনির্দিষ্ট (garbage) মান',0),(@q,'B','0',1),(@q,'C','3',0),(@q,'D','NULL',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'free(p) এর পর p = NULL; লেখার কারণ কী?', 'Why set p = NULL after free(p)?', 'free(p);
p = NULL; // good practice',
'`free()` করার পর `p` এখনও পুরনো (এখন অবৈধ) অ্যাড্রেসটাই ধরে রাখে — এটাকে "ডাংলিং পয়েন্টার" বলে, ভুলে আবার ব্যবহার করলে বিপজ্জনক। `NULL` বসিয়ে দিলে পরে ভুলে `*p` ব্যবহার করার চেষ্টা হলে তা সহজে ধরা পড়ে (NULL চেক দিয়ে ঠেকানো যায়), বাগ খুঁজে বের করা অনেক সহজ হয়ে যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ডাংলিং পয়েন্টার ভুলে ব্যবহার হলে সহজে ধরা পড়ে',1),(@q,'B','এটা মেমোরি বাঁচায়',0),(@q,'C','এটা বাধ্যতামূলক, নাহলে কম্পাইল এরর হয়',0),(@q,'D','কোনো কারণ নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'লুপ শেষে capacity এর মান কত হবে?', 'What is capacity at the end?', 'int capacity = 2;
// doubles capacity via realloc() whenever count == capacity, for 5 inserts',
'শুরুতে capacity=2। ৩য় এলিমেন্ট ঢোকানোর সময় count(2)==capacity(2), তাই capacity দ্বিগুণ হয়ে ৪ হয়। ৫ম এলিমেন্টের সময় আবার count(4)==capacity(4), capacity দ্বিগুণ হয়ে ৮ হয়। তাই লুপ শেষে capacity = 8।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','8',1),(@q,'C','4',0),(@q,'D','2',0);
