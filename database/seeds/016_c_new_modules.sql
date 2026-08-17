-- C track: File Handling + Error Handling & Preprocessor (new modules 7-8).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_c FROM languages WHERE slug = 'c';
SELECT id INTO @m_file FROM modules WHERE language_id=@lang_c AND slug='file-handling';
SELECT id INTO @m_err  FROM modules WHERE language_id=@lang_c AND slug='error-handling';

-- ── File Handling ────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_file, 'opening-files', 'ফাইল খোলা ও বন্ধ করা: fopen, fclose', 'Opening & Closing Files: fopen, fclose',
'একটা ফাইল নিয়ে কাজ করতে হলে প্রথমে `fopen()` দিয়ে সেটা খুলতে হয় — মোড হিসেবে `"r"` (read), `"w"` (write, পুরনো কনটেন্ট মুছে যায়), বা `"a"` (append) দেওয়া যায়। `fopen()` ব্যর্থ হলে (যেমন ফাইল না থাকলে) `NULL` রিটার্ন করে — তাই সবসময় চেক করা উচিত। কাজ শেষে `fclose()` দিয়ে ফাইল বন্ধ করতে ভুলা যাবে না।',
'#include <stdio.h>

int main() {
    FILE *fp = fopen("notes.txt", "w");
    if (fp == NULL) {
        printf("Could not open file\n");
        return 1;
    }
    fprintf(fp, "Hello, file!\n");
    fclose(fp);
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_file, 'reading-files', 'ফাইল থেকে পড়া: fgets, fscanf', 'Reading From Files: fgets, fscanf',
'`"r"` মোডে ফাইল খুলে `fgets()` দিয়ে এক লাইন করে পড়া যায়, অথবা `fscanf()` দিয়ে `scanf()`-এর মতোই ফরম্যাট-ভিত্তিক পড়া যায়। ফাইলের শেষে পৌঁছালে `fgets()` `NULL` রিটার্ন করে — এটাই লুপ থামানোর সিগন্যাল।',
'#include <stdio.h>

int main() {
    FILE *fp = fopen("notes.txt", "r");
    if (fp == NULL) return 1;

    char line[100];
    while (fgets(line, sizeof(line), fp) != NULL) {
        printf("%s", line);
    }
    fclose(fp);
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_file, 'writing-appending', 'লেখা ও যোগ করা: fprintf, append মোড', 'Writing & Appending: fprintf, Append Mode',
'`"w"` মোড ফাইলের পুরনো সবকিছু মুছে নতুন করে লেখে, কিন্তু `"a"` (append) মোড আগের কনটেন্টের শেষে নতুন লেখা যোগ করে, কিছু মুছে না। লগ ফাইলের মতো জায়গায় `"a"` মোড ব্যবহার করা হয়।',
'#include <stdio.h>

int main() {
    FILE *fp = fopen("log.txt", "a"); // append, not overwrite
    if (fp == NULL) return 1;

    fprintf(fp, "New log entry\n");
    fclose(fp);
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_file, 'file-handling-capstone', 'ক্যাপস্টোন: ফাইলে সংখ্যা লিখে আবার পড়া', 'Capstone: Write Numbers, Then Read Them Back',
'একটা ফাইলে কয়েকটা সংখ্যা লিখে, তারপর সেই ফাইল আবার খুলে পড়ে যোগফল বের করা হচ্ছে — লেখা আর পড়া, দুটো ধাপই একসাথে ব্যবহার করে।',
'#include <stdio.h>

int main() {
    FILE *fp = fopen("nums.txt", "w");
    fprintf(fp, "10 20 30\n");
    fclose(fp);

    fp = fopen("nums.txt", "r");
    int a, b, c, total;
    fscanf(fp, "%d %d %d", &a, &b, &c);
    fclose(fp);

    total = a + b + c;
    printf("Total: %d\n", total); // 60
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_file AND slug='opening-files';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_file AND slug='reading-files';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_file AND slug='writing-appending';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_file AND slug='file-handling-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'fopen() ব্যর্থ হলে (ফাইল খোলা না গেলে) কী রিটার্ন করে?', 'What does fopen() return on failure?', 'FILE *fp = fopen("notes.txt", "w");
if (fp == NULL) { ... }',
'`fopen()` ব্যর্থ হলে `NULL` রিটার্ন করে — যেমন পারমিশন না থাকলে বা ডিস্ক ফুল থাকলে। সবসময় `NULL` চেক করা উচিত, নাহলে পরের `fprintf`/`fclose` কল ক্র্যাশ করাতে পারে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',0),(@q,'B','NULL',1),(@q,'C','একটা এরর মেসেজ (স্ট্রিং)',0),(@q,'D','প্রোগ্রাম ক্র্যাশ করে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'ফাইলের শেষে পৌঁছালে fgets() কী রিটার্ন করে?', 'What does fgets() return at end of file?', 'while (fgets(line, sizeof(line), fp) != NULL) { ... }',
'ফাইলের সব লাইন পড়া শেষ হয়ে গেলে `fgets()` আর কোনো নতুন লাইন পড়তে না পেরে `NULL` রিটার্ন করে — এটাই `while` লুপের থামার শর্ত।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটা খালি স্ট্রিং',0),(@q,'B','NULL',1),(@q,'C','0',0),(@q,'D','পুরনো লাইনটাই আবার',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, '"a" মোডে ফাইল খুললে কী হয়?', 'What happens when opening a file in "a" mode?', 'FILE *fp = fopen("log.txt", "a");',
'`"a"` (append) মোড ফাইলের আগের কনটেন্ট অক্ষত রেখে তার *শেষে* নতুন লেখা যোগ করে — `"w"`-এর মতো পুরনো কনটেন্ট মুছে যায় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','পুরনো কনটেন্ট মুছে নতুন করে লেখা শুরু হয়',0),(@q,'B','পুরনো কনটেন্টের শেষে নতুন লেখা যোগ হয়',1),(@q,'C','ফাইলটা ডিলিট হয়ে যায়',0),(@q,'D','শুধু পড়া যায়, লেখা যায় না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'নিচের কোডে total-এর মান কত হবে?', 'What is total here?', 'fprintf(fp, "10 20 30\n");
...
fscanf(fp, "%d %d %d", &a, &b, &c);
total = a + b + c;',
'ফাইলে লেখা হয়েছিল "10 20 30", পরে সেটাই `fscanf()` দিয়ে পড়ে `a=10, b=20, c=30` বসানো হয়েছে। `total = 10+20+30 = 60`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','30',0),(@q,'B','60',1),(@q,'C','102030',0),(@q,'D','Error',0);

-- ── Error Handling & Preprocessor ────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_err, 'errno-perror', 'errno ও perror() দিয়ে এরর জানা', 'Knowing Errors: errno & perror()',
'C-তে try/catch নেই — সিস্টেম-লেভেল ফাংশন (যেমন `fopen`) ব্যর্থ হলে গ্লোবাল ভেরিয়েবল `errno`-তে একটা এরর কোড বসিয়ে দেয়, আর `perror()` সেই কোডের সহজে-পড়া মেসেজ প্রিন্ট করে (`<errno.h>` লাগবে)।',
'#include <stdio.h>
#include <errno.h>

int main() {
    FILE *fp = fopen("does_not_exist.txt", "r");
    if (fp == NULL) {
        perror("Error opening file");
        return 1;
    }
    fclose(fp);
    return 0;
}',
'c', 10, 0, 1, 0),

(@m_err, 'defensive-checks', 'রিটার্ন ভ্যালু চেক করা: defensive coding', 'Checking Return Values: Defensive Coding',
'C-তে বেশিরভাগ ফাংশন (যেমন `malloc`, `fopen`, `scanf`) ব্যর্থ হলে একটা নির্দিষ্ট ভ্যালু (`NULL`, `-1`, ইত্যাদি) রিটার্ন করে জানিয়ে দেয়। এই রিটার্ন ভ্যালু চেক না করাটাই C-এর প্রোগ্রামে ক্র্যাশ আর undefined behavior-এর সবচেয়ে বড় কারণ।',
'#include <stdio.h>

int main() {
    int age;
    if (scanf("%d", &age) != 1) { // scanf returns how many values it read
        printf("Invalid input!\n");
        return 1;
    }
    printf("Age: %d\n", age);
    return 0;
}',
'c', 10, 0, 2, 0),

(@m_err, 'macros-define', 'ম্যাক্রো ও #define', 'Macros & #define',
'`#define` দিয়ে কোড কম্পাইল হওয়ার *আগেই* টেক্সট রিপ্লেস করা যায় — কনস্ট্যান্ট নাম দেওয়া যায় (`#define PI 3.14159`), এমনকি ছোট ফাংশনের মতো ম্যাক্রোও বানানো যায়। এটা কম্পাইল-টাইমে হয়, রানটাইমে কোনো খরচ নেই।',
'#include <stdio.h>

#define PI 3.14159
#define SQUARE(x) ((x) * (x))

int main() {
    printf("PI = %f\n", PI);
    printf("Square of 5 = %d\n", SQUARE(5)); // 25
    return 0;
}',
'c', 10, 0, 3, 0),

(@m_err, 'error-handling-capstone', 'ক্যাপস্টোন: নিরাপদ ইনপুট নেওয়া', 'Capstone: Safe Input Handling',
'আগের তিনটা ধারণা একসাথে — `scanf()`-এর রিটার্ন ভ্যালু চেক করে ভুল ইনপুট ধরা, আর একটা ম্যাক্রো দিয়ে একটা রেঞ্জ-চেক সহজ করে দেওয়া।',
'#include <stdio.h>

#define IS_VALID_AGE(a) ((a) > 0 && (a) < 130)

int main() {
    int age;
    if (scanf("%d", &age) != 1) {
        printf("Invalid input!\n");
        return 1;
    }
    if (!IS_VALID_AGE(age)) {
        printf("Age out of range!\n");
        return 1;
    }
    printf("Valid age: %d\n", age);
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_err AND slug='errno-perror';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_err AND slug='defensive-checks';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_err AND slug='macros-define';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_err AND slug='error-handling-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'perror() কী প্রিন্ট করে?', 'What does perror() print?', 'perror("Error opening file");',
'`perror()` দেওয়া মেসেজের পাশাপাশি বর্তমান `errno`-এর সিস্টেম-জেনারেটেড, মানুষের পড়ার-উপযোগী ব্যাখ্যা প্রিন্ট করে — যেমন "Error opening file: No such file or directory"।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু দেওয়া মেসেজটাই',0),(@q,'B','দেওয়া মেসেজ + errno-এর সিস্টেম ব্যাখ্যা',1),(@q,'C','শুধু একটা সংখ্যা',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'scanf() কী রিটার্ন করে?', 'What does scanf() return?', 'if (scanf("%d", &age) != 1) { ... }',
'`scanf()` সফলভাবে কয়টা ভ্যালু পড়তে পেরেছে সেই সংখ্যা রিটার্ন করে — এখানে একটা `%d` আছে, তাই সফল হলে `1` রিটার্ন করা উচিত। `1` না হলে বোঝা যায় ইনপুটে সমস্যা ছিল।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ইনপুট করা ভ্যালুটাই',0),(@q,'B','সফলভাবে কয়টা ভ্যালু পড়া গেছে',1),(@q,'C','সবসময় 0',0),(@q,'D','কিছুই রিটার্ন করে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'SQUARE(5) এর ফলাফল কত হবে?', 'What is SQUARE(5)?', '#define SQUARE(x) ((x) * (x))
SQUARE(5)',
'কম্পাইল হওয়ার আগে `SQUARE(5)` টেক্সট হিসেবে `((5) * (5))`-এ রিপ্লেস হয়ে যায়, যার ফলাফল `25`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','10',0),(@q,'B','25',1),(@q,'C','5',0),(@q,'D','Compile error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'IS_VALID_AGE(150) এর ফলাফল কী হবে?', 'What is IS_VALID_AGE(150)?', '#define IS_VALID_AGE(a) ((a) > 0 && (a) < 130)
IS_VALID_AGE(150)',
'`150 > 0` সত্যি, কিন্তু `150 < 130` মিথ্যা — `&&` দিয়ে দুটোই সত্যি হতে হবে, তাই পুরো এক্সপ্রেশনটা মিথ্যা (0)।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সত্যি (1)',0),(@q,'B','মিথ্যা (0)',1),(@q,'C','150',0),(@q,'D','Compile error',0);
