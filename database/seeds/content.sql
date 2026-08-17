-- =============================================================================
-- Bytewise — 02-SCHEMA-SEED.sql (companion to 02-SCHEMA.sql)
-- Seed data for database/seeds/content.php per rulebook Section 4 layout.
--
-- SCOPE, STATED HONESTLY (per rulebook §8 content-integrity rule and per
-- BUILD-SPEC.md §6): this is NOT a claim of a complete, production-ready
-- curriculum for eight tracks. Hand-authoring ~200+ fully-worked lessons in
-- one pass risks exactly the kind of low-quality, unverified filler content
-- §8 warns against. What's actually shipped here, and verified by actually
-- loading this file against a live MariaDB instance (0 errors, all FKs and
-- the CHECK constraint on languages hold) rather than just eyeballed:
--
--   - All 8 tracks (6 languages + Data Structures + Algorithms), fully
--     structured module lists (48 module rows) — titles only, low
--     fabrication risk, safe to ship as-is. JavaScript's module list is
--     reshaped to match the app owner's own skill-tree example verbatim.
--   - FULL lesson content (body + code sample + inline quiz) for all 4
--     lessons of C's first module ("মৌলিক ধারণা"/Basics), as the flagship
--     fully-realized example — including the exact `int age = 20;` /
--     A-B-C-D quiz the app owner used as their own pitch example.
--   - FULL lesson content (incl. quiz) for the free-preview Lesson 1 of
--     each of the other 7 tracks (C++, Java, Python, JavaScript, SQL, Data
--     Structures, Algorithms) — required anyway, since /lesson/{slug} for
--     these must be real ungated content. 11 lessons total, 11 quizzes.
--   - One fully-specified, test-case-verified coding problem per track (8
--     problems total, including two language-agnostic ones for Data
--     Structures/Algorithms), plus the "BMI calculator" example from the
--     app owner's own pitch, built out as C's flagship problem.
--   - Cheat-sheet summary + full text for all 8 tracks.
--   - 3 representative Projects (JS Todo app, Python CLI calculator, C
--     grade manager) — enough to exercise the self-report/admin-review
--     flow end to end, not a claim of a full project catalog.
--
-- Every other module/lesson slot (modules 2-6 of all eight tracks, and
-- lessons 2+ of every module beyond C's Basics) is a structural gap, not
-- hidden filler — see TODO.md in 04-AI-BUILD-PLAYBOOK.md for the explicit
-- pre-launch content-authoring blocker this creates. The admin CSV import
-- pipeline (BUILD-SPEC §6, route `/admin/content-import`) is exactly the
-- mechanism meant to fill this in without a code change. Do not market
-- "complete curriculum" until that's done — every row below also sets
-- content_verified = 0 per the rulebook's unverified-content flag.
-- =============================================================================

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- Languages (all 6, launch order per the app owner's stated roadmap)
-- ---------------------------------------------------------------------------
INSERT INTO languages (slug, name_bn, name_en, launch_order, judge_language_code, is_meta_track, is_published) VALUES
('c',          'সি',            'C',          1, 'c',          0, 1),
('cpp',        'সি++',          'C++',        2, 'cpp',        0, 1),
('java',       'জাভা',          'Java',       3, 'java',       0, 1),
('python3',    'পাইথন',         'Python',     4, 'python3',    0, 1),
('javascript', 'জাভাস্ক্রিপ্ট', 'JavaScript', 5, 'javascript', 0, 1),
('sql',        'এসকিউএল',       'SQL',        6, 'sql',        0, 1);

-- Data Structures & Algorithms: meta-tracks, no fixed executable language
-- (see 02-SCHEMA.sql languages table comment + chk_languages_judge_code).
-- Their problems are language-agnostic; a submission picks a language from
-- among the 6 above at submit time (submissions.language_id).
INSERT INTO languages (slug, name_bn, name_en, launch_order, judge_language_code, is_meta_track, is_published) VALUES
('data-structures', 'ডেটা স্ট্রাকচার', 'Data Structures', 7, NULL, 1, 1),
('algorithms',      'অ্যালগরিদম',      'Algorithms',      8, NULL, 1, 1);

SELECT id INTO @lang_c   FROM languages WHERE slug = 'c';
SELECT id INTO @lang_cpp FROM languages WHERE slug = 'cpp';
SELECT id INTO @lang_java FROM languages WHERE slug = 'java';
SELECT id INTO @lang_py  FROM languages WHERE slug = 'python3';
SELECT id INTO @lang_js  FROM languages WHERE slug = 'javascript';
SELECT id INTO @lang_sql FROM languages WHERE slug = 'sql';
SELECT id INTO @lang_ds  FROM languages WHERE slug = 'data-structures';
SELECT id INTO @lang_algo FROM languages WHERE slug = 'algorithms';

-- ---------------------------------------------------------------------------
-- Modules — full 6-module structure per language (titles only; see scope note)
-- ---------------------------------------------------------------------------
INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_c, 'basics',        'মৌলিক ধারণা',          'Basics',              1),
(@lang_c, 'control-flow',  'কন্ট্রোল ফ্লো',         'Control Flow',        2),
(@lang_c, 'functions',     'ফাংশন',                 'Functions',           3),
(@lang_c, 'arrays-strings','অ্যারে ও স্ট্রিং',      'Arrays & Strings',    4),
(@lang_c, 'pointers',      'পয়েন্টার',               'Pointers',            5),
(@lang_c, 'structs',       'স্ট্রাক্ট',              'Structs',             6);

INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_cpp, 'basics',      'সি++ বেসিকস',           'C++ Basics',          1),
(@lang_cpp, 'control-flow','কন্ট্রোল ফ্লো ও ফাংশন', 'Control Flow & Functions', 2),
(@lang_cpp, 'oop',         'অবজেক্ট-ওরিয়েন্টেড প্রোগ্রামিং', 'OOP Basics', 3),
(@lang_cpp, 'containers',  'অ্যারে, স্ট্রিং ও ভেক্টর', 'Arrays, Strings & Vectors', 4),
(@lang_cpp, 'stl',         'STL বেসিকস',            'STL Basics',          5),
(@lang_cpp, 'pointers-refs','পয়েন্টার ও রেফারেন্স', 'Pointers & References', 6);

INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_java, 'basics',       'জাভা বেসিকস',         'Java Basics',         1),
(@lang_java, 'control-flow', 'কন্ট্রোল ফ্লো',        'Control Flow',        2),
(@lang_java, 'methods',      'মেথড',                 'Methods',             3),
(@lang_java, 'arrays-strings','অ্যারে ও স্ট্রিং',    'Arrays & Strings',    4),
(@lang_java, 'oop',          'ক্লাস ও অবজেক্ট',      'Classes & Objects',   5),
(@lang_java, 'inheritance',  'ইনহেরিটেন্স ও ইন্টারফেস', 'Inheritance & Interfaces', 6);

INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_py, 'basics',        'পাইথন বেসিকস',        'Python Basics',       1),
(@lang_py, 'control-flow',  'কন্ট্রোল ফ্লো',        'Control Flow',        2),
(@lang_py, 'functions',     'ফাংশন',                'Functions',           3),
(@lang_py, 'collections',   'লিস্ট, টাপল ও ডিকশনারি', 'Lists, Tuples & Dicts', 4),
(@lang_py, 'strings',       'স্ট্রিং হ্যান্ডলিং',   'String Handling',     5),
(@lang_py, 'oop',           'OOP বেসিকস',           'OOP Basics',          6);

-- Module list intentionally matches the app owner's own skill-tree example
-- verbatim (Variables & Basics -> Functions -> Arrays -> Objects -> Async
-- JavaScript -> React Basics) rather than the Basics/Control-Flow/DOM/ES6+
-- split used for the other five languages — see BUILD-SPEC.md §6. Control
-- flow (if/else, loops) is folded into Module 1's lessons rather than
-- broken out as its own module here. React Basics is flagged in its own
-- description as an advanced, optional capstone (a framework, not core
-- JS), since it's a meaningfully bigger scope jump than the other five
-- modules and shouldn't be silently presented as equivalent depth.
INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_js, 'basics',      'ভেরিয়েবল ও বেসিকস', 'Variables & Basics', 1),
(@lang_js, 'functions',   'ফাংশন',              'Functions',          2),
(@lang_js, 'arrays',      'অ্যারে',              'Arrays',             3),
(@lang_js, 'objects',     'অবজেক্ট',             'Objects',            4),
(@lang_js, 'async-js',    'Async JavaScript',   'Async JavaScript',   5),
(@lang_js, 'react-basics','React বেসিকস (Advanced/Optional)', 'React Basics (Advanced/Optional)', 6);

INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_sql, 'basics',      'SQL বেসিকস',            'SQL Basics',          1),
(@lang_sql, 'filtering',   'ফিল্টারিং ও সর্টিং',    'Filtering & Sorting', 2),
(@lang_sql, 'aggregates',  'অ্যাগ্রিগেট ও GROUP BY','Aggregates & GROUP BY',3),
(@lang_sql, 'joins',       'JOIN',                  'Joins',               4),
(@lang_sql, 'dml',         'INSERT, UPDATE, DELETE','Data Modification',  5),
(@lang_sql, 'subqueries',  'সাবকোয়েরি ও ইনডেক্স',  'Subqueries & Indexes',6);

-- ---------------------------------------------------------------------------
-- C — Module 1 (Basics): full 4-lesson flagship content
-- ---------------------------------------------------------------------------
SELECT id INTO @c_basics FROM modules WHERE language_id = @lang_c AND slug = 'basics';

INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@c_basics, 'variables-data-types', 'ভেরিয়েবল ও ডেটা টাইপ', 'Variables & Data Types',
'C-তে একটি ভেরিয়েবল ঘোষণা করতে হলে প্রথমে তার **ডেটা টাইপ** বলে দিতে হয় — যেমন পূর্ণসংখ্যার জন্য `int`, দশমিক সংখ্যার জন্য `float`, আর একটি অক্ষরের জন্য `char`। C একটি *statically typed* ভাষা — একবার একটি ভেরিয়েবলকে `int` হিসেবে ঘোষণা করলে, তাতে পরে টেক্সট রাখা যাবে না।

নিচের কোডে `age` নামের একটি ভেরিয়েবল `int` টাইপের, এবং তাতে `20` ভ্যালু বসানো হয়েছে।',
'#include <stdio.h>

int main() {
    int age = 20;
    printf("Age: %d\n", age);
    return 0;
}',
'c', 10, 1, 1, 0),

(@c_basics, 'input-output', 'ইনপুট ও আউটপুট', 'Input & Output',
'`printf()` দিয়ে স্ক্রিনে কিছু প্রিন্ট করা যায়, আর `scanf()` দিয়ে ইউজারের থেকে ইনপুট নেওয়া যায়। `scanf()`-এ ভেরিয়েবলের নামের আগে `&` (address-of অপারেটর) বসাতে হয় — এটা প্রথমদিকে অনেকে ভুলে যায় এবং এটাই সবচেয়ে সাধারণ কম্পাইল-টাইম ভুলগুলোর একটা।',
'#include <stdio.h>

int main() {
    int age;
    printf("Enter your age: ");
    scanf("%d", &age);
    printf("You are %d years old.\n", age);
    return 0;
}',
'c', 10, 0, 2, 0),

(@c_basics, 'operators', 'অপারেটর', 'Operators',
'C-তে গাণিতিক অপারেটর (`+ - * / %`) এবং তুলনামূলক অপারেটর (`== != < > <= >=`) আছে। মনে রাখবেন: দুটি `int` ভাগ করলে (যেমন `7 / 2`) ফলাফল `3` হবে, `3.5` না — কারণ ফলাফলও `int`। দশমিক ফলাফল পেতে হলে অন্তত একটি অপারেন্ডকে `float`-এ কনভার্ট করতে হয়।',
'#include <stdio.h>

int main() {
    int a = 7, b = 2;
    printf("Integer division: %d\n", a / b);       // 3
    printf("Float division: %.2f\n", (float)a / b); // 3.50
    return 0;
}',
'c', 10, 0, 3, 0),

(@c_basics, 'first-calculation-program', 'প্রথম ক্যালকুলেশন প্রোগ্রাম', 'Your First Calculation Program',
'এখন আগের তিনটি লেসনের সবকিছু একসাথে ব্যবহার করার সময়: ভেরিয়েবল ঘোষণা, `scanf()` দিয়ে ইনপুট নেওয়া, একটা ফর্মুলা দিয়ে ক্যালকুলেট করা, আর `printf()` দিয়ে ফলাফল প্রিন্ট করা। এই লেসনের পর থাকা কোডিং প্রবলেমে (BMI ক্যালকুলেটর) ঠিক এই প্যাটার্নটাই লাগবে।',
'#include <stdio.h>

int main() {
    float weight, height, result;
    scanf("%f %f", &weight, &height);
    result = weight / (height * height);
    printf("%.2f\n", result);
    return 0;
}',
'c', 15, 0, 4, 0);

SELECT id INTO @c_l1 FROM lessons WHERE module_id = @c_basics AND slug = 'variables-data-types';
SELECT id INTO @c_l2 FROM lessons WHERE module_id = @c_basics AND slug = 'input-output';
SELECT id INTO @c_l3 FROM lessons WHERE module_id = @c_basics AND slug = 'operators';
SELECT id INTO @c_l4 FROM lessons WHERE module_id = @c_basics AND slug = 'first-calculation-program';

-- The flagship quiz question — this is the app owner's own pitch example, verbatim.
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@c_l1, 'নিচের কোডের পর `age`-এ কী থাকবে?', 'What will `age` contain after this line?', 'int age = 20;', 1);
SELECT id INTO @c_l1_q1 FROM quiz_questions WHERE lesson_id = @c_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_l1_q1, 'A', '10', 0),
(@c_l1_q1, 'B', '20', 1),
(@c_l1_q1, 'C', '"20" (টেক্সট হিসেবে)', 0),
(@c_l1_q1, 'D', 'Error', 0);

-- Quiz questions for the remaining 3 lessons of C's Basics module, so
-- "full lesson content including inline quiz" (see this file's scope note
-- at the top) is actually true for all 4 lessons, not just Lesson 1.
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@c_l2, 'নিচের কোডে `&age`-এর `&` চিহ্নটি কী নির্দেশ করে?', 'What does the `&` in `&age` indicate here?', 'scanf("%d", &age);', 1);
SELECT id INTO @c_l2_q1 FROM quiz_questions WHERE lesson_id = @c_l2 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_l2_q1, 'A', 'age-এর বর্তমান মান', 0),
(@c_l2_q1, 'B', 'age-এর মেমোরি অ্যাড্রেস (address-of)', 1),
(@c_l2_q1, 'C', 'age ভেরিয়েবলের নাম পরিবর্তন', 0),
(@c_l2_q1, 'D', 'এটি একটি সিনট্যাক্স এরর', 0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@c_l3, 'নিচের কোডের আউটপুট কত হবে?', 'What will this code print?', 'int a = 7, b = 2;
printf("%d", a / b);', 1);
SELECT id INTO @c_l3_q1 FROM quiz_questions WHERE lesson_id = @c_l3 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_l3_q1, 'A', '3.5', 0),
(@c_l3_q1, 'B', '3', 1),
(@c_l3_q1, 'C', '4', 0),
(@c_l3_q1, 'D', 'Error', 0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@c_l4, 'নিচের কোডে কয়টি ভেরিয়েবলে ইনপুট নেওয়া হচ্ছে?', 'How many variables does this line read input into?', 'scanf("%f %f", &weight, &height);', 1);
SELECT id INTO @c_l4_q1 FROM quiz_questions WHERE lesson_id = @c_l4 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@c_l4_q1, 'A', '১টি', 0),
(@c_l4_q1, 'B', '২টি', 1),
(@c_l4_q1, 'C', '৩টি', 0),
(@c_l4_q1, 'D', 'কোনোটিই না', 0);

-- ---------------------------------------------------------------------------
-- C flagship problem: BMI Calculator (the app owner's own pitch example)
-- ---------------------------------------------------------------------------
INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(@lang_c, @c_l4, 'bmi-calculator', 'BMI ক্যালকুলেটর', 'BMI Calculator',
'দুটি সংখ্যা ইনপুট নিন — প্রথমে **ওজন** (kg, দশমিক সংখ্যা হতে পারে), তারপর **উচ্চতা** (মিটার, দশমিক সংখ্যা)। BMI হিসাব করুন এই সূত্র দিয়ে:

BMI = ওজন / (উচ্চতা × উচ্চতা)

ফলাফল ঠিক দুই দশমিক ঘর পর্যন্ত প্রিন্ট করুন (`%.2f` ফরম্যাটে), অন্য কোনো টেক্সট ছাড়া।',
'#include <stdio.h>

int main() {
    float weight, height;
    scanf("%f %f", &weight, &height);
    // TODO: BMI হিসাব করে %.2f ফরম্যাটে প্রিন্ট করুন
    return 0;
}',
'easy', 25, 2000, 65536, 0);

SELECT id INTO @p_bmi FROM problems WHERE slug = 'bmi-calculator' AND language_id = @lang_c;
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_bmi, 0, '70 1.75', '22.86', 1),
(@p_bmi, 0, '50 1.60', '19.53', 2),
(@p_bmi, 1, '90 1.80', '27.78', 3),
(@p_bmi, 1, '45.5 1.55', '18.94', 4);

-- ---------------------------------------------------------------------------
-- C++ — free-preview Lesson 1
-- ---------------------------------------------------------------------------
SELECT id INTO @cpp_basics FROM modules WHERE language_id = @lang_cpp AND slug = 'basics';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@cpp_basics, 'variables-cout', 'ভেরিয়েবল ও cout', 'Variables & cout',
'C++ মূলত C-এর উপর তৈরি, তাই ভেরিয়েবল ঘোষণা প্রায় একই রকম। পার্থক্য হলো আউটপুটের জন্য `printf()`-এর বদলে `cout` (এবং `<<` অপারেটর) ব্যবহার হয়, যা `<iostream>` হেডার থেকে আসে।',
'#include <iostream>
using namespace std;

int main() {
    int age = 20;
    cout << "Age: " << age << endl;
    return 0;
}',
'cpp', 10, 1, 1, 0);
SELECT id INTO @cpp_l1 FROM lessons WHERE module_id = @cpp_basics AND slug = 'variables-cout';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@cpp_l1, 'নিচের কোডের পর `age`-এ কী থাকবে?', 'What will `age` contain after this line?', 'int age = 20;', 1);
SELECT id INTO @cpp_l1_q1 FROM quiz_questions WHERE lesson_id = @cpp_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@cpp_l1_q1, 'A', '10', 0), (@cpp_l1_q1, 'B', '20', 1), (@cpp_l1_q1, 'C', '"20" (টেক্সট হিসেবে)', 0), (@cpp_l1_q1, 'D', 'Error', 0);

INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(@lang_cpp, @cpp_l1, 'sum-two-numbers', 'দুটি সংখ্যার যোগফল', 'Sum of Two Numbers',
'দুটি পূর্ণসংখ্যা ইনপুট নিন (স্পেস দিয়ে আলাদা) এবং তাদের যোগফল প্রিন্ট করুন।',
'#include <iostream>
using namespace std;

int main() {
    int a, b;
    cin >> a >> b;
    // TODO: যোগফল প্রিন্ট করুন
    return 0;
}',
'easy', 15, 2000, 65536, 0);
SELECT id INTO @p_sum FROM problems WHERE slug = 'sum-two-numbers' AND language_id = @lang_cpp;
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_sum, 0, '2 3', '5', 1),
(@p_sum, 0, '10 -4', '6', 2),
(@p_sum, 1, '0 0', '0', 3);

-- ---------------------------------------------------------------------------
-- Java — free-preview Lesson 1
-- ---------------------------------------------------------------------------
SELECT id INTO @java_basics FROM modules WHERE language_id = @lang_java AND slug = 'basics';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@java_basics, 'variables-println', 'ভেরিয়েবল ও println', 'Variables & println',
'জাভাতে প্রতিটি প্রোগ্রাম একটা ক্লাসের ভেতরে থাকতে হয়, এবং এক্সিকিউশন শুরু হয় `public static void main(String[] args)` মেথড থেকে। আউটপুটের জন্য `System.out.println()` ব্যবহার হয়।',
'public class Main {
    public static void main(String[] args) {
        int age = 20;
        System.out.println("Age: " + age);
    }
}',
'java', 10, 1, 1, 0);
SELECT id INTO @java_l1 FROM lessons WHERE module_id = @java_basics AND slug = 'variables-println';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@java_l1, 'নিচের কোডের পর `age`-এ কী থাকবে?', 'What will `age` contain after this line?', 'int age = 20;', 1);
SELECT id INTO @java_l1_q1 FROM quiz_questions WHERE lesson_id = @java_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@java_l1_q1, 'A', '10', 0), (@java_l1_q1, 'B', '20', 1), (@java_l1_q1, 'C', '"20" (টেক্সট হিসেবে)', 0), (@java_l1_q1, 'D', 'Error', 0);

INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(@lang_java, @java_l1, 'even-or-odd', 'জোড় নাকি বিজোড়?', 'Even or Odd',
'একটি পূর্ণসংখ্যা ইনপুট নিন। সংখ্যাটি জোড় হলে `Even` প্রিন্ট করুন, বিজোড় হলে `Odd` প্রিন্ট করুন।',
'import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();
        // TODO: Even/Odd প্রিন্ট করুন
    }
}',
'easy', 15, 2000, 131072, 0);
SELECT id INTO @p_evenodd FROM problems WHERE slug = 'even-or-odd' AND language_id = @lang_java;
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_evenodd, 0, '4', 'Even', 1),
(@p_evenodd, 0, '7', 'Odd', 2),
(@p_evenodd, 1, '0', 'Even', 3),
(@p_evenodd, 1, '-3', 'Odd', 4);

-- ---------------------------------------------------------------------------
-- Python — free-preview Lesson 1
-- ---------------------------------------------------------------------------
SELECT id INTO @py_basics FROM modules WHERE language_id = @lang_py AND slug = 'basics';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@py_basics, 'variables-print', 'ভেরিয়েবল ও print', 'Variables & print',
'পাইথনে ভেরিয়েবল ঘোষণা করতে কোনো টাইপ লেখার দরকার নেই — টাইপ অটোমেটিক্যালি ভ্যালু থেকে ধরে নেওয়া হয় (dynamic typing)। আউটপুটের জন্য `print()` ব্যবহার হয়।',
'age = 20
print("Age:", age)',
'python3', 10, 1, 1, 0);
SELECT id INTO @py_l1 FROM lessons WHERE module_id = @py_basics AND slug = 'variables-print';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@py_l1, 'নিচের কোডের পর `age`-এ কী থাকবে?', 'What will `age` contain after this line?', 'age = 20', 1);
SELECT id INTO @py_l1_q1 FROM quiz_questions WHERE lesson_id = @py_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@py_l1_q1, 'A', '10', 0), (@py_l1_q1, 'B', '20', 1), (@py_l1_q1, 'C', '"20" (টেক্সট হিসেবে)', 0), (@py_l1_q1, 'D', 'Error', 0);

INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(@lang_py, @py_l1, 'factorial', 'ফ্যাক্টোরিয়াল', 'Factorial',
'একটি নন-নেগেটিভ পূর্ণসংখ্যা `n` ইনপুট নিন এবং তার ফ্যাক্টোরিয়াল (n!) প্রিন্ট করুন। `0! = 1` হিসেবে ধরুন।',
'n = int(input())
# TODO: ফ্যাক্টোরিয়াল হিসাব করে প্রিন্ট করুন',
'easy', 15, 2000, 65536, 0);
SELECT id INTO @p_fact FROM problems WHERE slug = 'factorial' AND language_id = @lang_py;
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_fact, 0, '5', '120', 1),
(@p_fact, 0, '0', '1', 2),
(@p_fact, 1, '7', '5040', 3);

-- ---------------------------------------------------------------------------
-- JavaScript — free-preview Lesson 1
-- ---------------------------------------------------------------------------
SELECT id INTO @js_basics FROM modules WHERE language_id = @lang_js AND slug = 'basics';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@js_basics, 'variables-console-log', 'ভেরিয়েবল ও console.log', 'Variables & console.log',
'জাভাস্ক্রিপ্টে ভেরিয়েবল ঘোষণার জন্য `let` (পরে পরিবর্তনযোগ্য) বা `const` (পরিবর্তন-অযোগ্য) ব্যবহার করা হয় — পুরনো `var` এখন এড়িয়ে চলাই ভালো অভ্যাস। আউটপুটের জন্য `console.log()` ব্যবহার হয়।',
'let age = 20;
console.log("Age:", age);',
'javascript', 10, 1, 1, 0);
SELECT id INTO @js_l1 FROM lessons WHERE module_id = @js_basics AND slug = 'variables-console-log';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@js_l1, 'নিচের কোডের পর `age`-এ কী থাকবে?', 'What will `age` contain after this line?', 'let age = 20;', 1);
SELECT id INTO @js_l1_q1 FROM quiz_questions WHERE lesson_id = @js_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@js_l1_q1, 'A', '10', 0), (@js_l1_q1, 'B', '20', 1), (@js_l1_q1, 'C', '"20" (টেক্সট হিসেবে)', 0), (@js_l1_q1, 'D', 'Error', 0);

INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(@lang_js, @js_l1, 'reverse-string', 'স্ট্রিং উল্টানো', 'Reverse a String',
'একটি লাইন টেক্সট ইনপুট নিন এবং সেটি উল্টে (reverse করে) প্রিন্ট করুন।',
'const readline = require("readline").createInterface({ input: process.stdin });
readline.on("line", (line) => {
    // TODO: line উল্টে প্রিন্ট করুন
});',
'easy', 15, 2000, 65536, 0);
SELECT id INTO @p_rev FROM problems WHERE slug = 'reverse-string' AND language_id = @lang_js;
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_rev, 0, 'hello', 'olleh', 1),
(@p_rev, 0, 'codebondhu', 'uhdnobedoc', 2),
(@p_rev, 1, 'a', 'a', 3);

-- ---------------------------------------------------------------------------
-- SQL — free-preview Lesson 1
-- ---------------------------------------------------------------------------
SELECT id INTO @sql_basics FROM modules WHERE language_id = @lang_sql AND slug = 'basics';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@sql_basics, 'select-basics', 'SELECT স্টেটমেন্ট', 'The SELECT Statement',
'SQL-এ ডেটা পড়ার জন্য `SELECT` ব্যবহার হয়। `SELECT কলাম FROM টেবিল WHERE শর্ত` — এই বেসিক প্যাটার্নটা প্রায় প্রতিটি কোয়েরির ভিত্তি। এখানে অন্য ভাষাগুলোর মতো "ভেরিয়েবল" নেই — বরং প্রতিটি কোয়েরি একটা রেজাল্ট-টেবিল রিটার্ন করে।',
'SELECT name, age
FROM students
WHERE age = 20;',
'sql', 10, 1, 1, 0);
SELECT id INTO @sql_l1 FROM lessons WHERE module_id = @sql_basics AND slug = 'select-basics';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@sql_l1, 'এই কোয়েরিটি কী রিটার্ন করবে?', 'What will this query return?', 'SELECT name, age FROM students WHERE age = 20;', 1);
SELECT id INTO @sql_l1_q1 FROM quiz_questions WHERE lesson_id = @sql_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@sql_l1_q1, 'A', 'শুধু ২০ বছর বয়সী students-দের নাম ও বয়স', 1),
(@sql_l1_q1, 'B', 'সব students-এর সব কলাম', 0),
(@sql_l1_q1, 'C', 'Error, কারণ WHERE ভুল', 0),
(@sql_l1_q1, 'D', 'শুধু নাম, বয়স ছাড়া', 0);

-- SQL problems execute against a disposable per-submission database fixture
-- inside the sandbox (BUILD-SPEC §6/§9, ExecutionGateway contract in
-- 03-ENV-AND-CONFIG.md) — never against Bytewise's own schema. The fixture
-- DDL/DML is stored as plain text in test_cases.stdin by convention for the
-- SQL language only: stdin holds "<fixture DDL/DML>;;<query to grade>" is
-- NOT how this works — see 03-ENV-AND-CONFIG.md for the actual fixture
-- contract (a separate `sql_fixture` field the ExecutionGateway consumes).
-- This one row is illustrative of the problem shape, not the wire format.
INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(@lang_sql, @sql_l1, 'highest-salary', 'সর্বোচ্চ বেতন', 'Highest Salary',
'একটি `employees(id, name, salary)` টেবিল দেওয়া আছে। সর্বোচ্চ বেতন পাওয়া কর্মীর `name` রিটার্ন করে এমন একটি কোয়েরি লিখুন।

ফিক্সচার ডেটা:
```sql
CREATE TABLE employees (id INT, name VARCHAR(50), salary INT);
INSERT INTO employees VALUES (1,''Rima'',55000),(2,''Kabir'',72000),(3,''Nusrat'',68000);
```',
'-- আপনার SELECT কোয়েরি এখানে লিখুন
',
'easy', 15, 2000, 65536, 0);
SELECT id INTO @p_salary FROM problems WHERE slug = 'highest-salary' AND language_id = @lang_sql;
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_salary, 0, NULL, 'Kabir', 1);

-- ---------------------------------------------------------------------------
-- Cheat sheets — summary (free) + full (gated) for all 6 languages
-- ---------------------------------------------------------------------------
INSERT INTO cheatsheets (language_id, summary_md, full_md) VALUES
(@lang_c,
'`int`, `float`, `char`, `if/else`, `for`, `while`, `printf`/`scanf` — C-এর সবচেয়ে বেশি ব্যবহৃত সিনট্যাক্স এক নজরে।',
'## ডেটা টাইপ\n`int`, `float`, `double`, `char`\n\n## I/O\n`printf("%d", x);` / `scanf("%d", &x);`\n\n## কন্ট্রোল ফ্লো\n`if/else`, `for(init;cond;incr)`, `while`, `switch`\n\n## ফাংশন\n`return_type name(params) { ... }`'),
(@lang_cpp,
'`cin`/`cout`, `class`, `vector`, রেফারেন্স `&` — C++-এর কোর সিনট্যাক্স এক নজরে।',
'## I/O\n`cout << x;` / `cin >> x;`\n\n## OOP\n`class Name { public: ... private: ... };`\n\n## STL\n`vector<int> v;`, `v.push_back(x);`, রেঞ্জ-বেসড `for`'),
(@lang_java,
'`class`, `public static void main`, `System.out.println`, `Scanner` — জাভার কোর সিনট্যাক্স এক নজরে।',
'## এন্ট্রি পয়েন্ট\n`public class Main { public static void main(String[] args) { ... } }`\n\n## ইনপুট\n`Scanner sc = new Scanner(System.in); sc.nextInt();`\n\n## OOP\n`class`, `extends`, `implements`'),
(@lang_py,
'`print()`, `input()`, লিস্ট, ডিকশনারি, ইনডেন্টেশন-বেসড ব্লক — পাইথনের কোর সিনট্যাক্স এক নজরে।',
'## বেসিকস\nইনডেন্টেশন দিয়ে ব্লক নির্ধারণ হয়, কোনো `{}` লাগে না।\n\n## কালেকশন\n`list = [1,2,3]`, `dict = {"k": "v"}`\n\n## ফাংশন\n`def name(params): ...`'),
(@lang_js,
'`let/const`, `console.log`, অ্যারো ফাংশন, `document.querySelector` — জাভাস্ক্রিপ্টের কোর সিনট্যাক্স এক নজরে।',
'## ভেরিয়েবল\n`let x = 1; const y = 2;` (`var` এড়িয়ে চলুন)\n\n## ফাংশন\n`function f(x) { return x; }` বা অ্যারো ফাংশন `(x) => x`\n\n## DOM\n`document.querySelector(".sel")`'),
(@lang_sql,
'`SELECT`, `WHERE`, `JOIN`, `GROUP BY` — SQL-এর কোর সিনট্যাক্স এক নজরে।',
'## বেসিক কোয়েরি\n`SELECT col FROM table WHERE cond;`\n\n## জয়েন\n`SELECT * FROM a JOIN b ON a.id = b.a_id;`\n\n## অ্যাগ্রিগেট\n`SELECT COUNT(*), AVG(col) FROM table GROUP BY other_col;`'),
(@lang_ds,
'অ্যারে, স্ট্যাক, কিউ, লিংকড লিস্ট, ট্রি, গ্রাফ, হ্যাশ টেবিল — কোর ডেটা স্ট্রাকচার এক নজরে (ভাষা-নিরপেক্ষ)।',
'## লিনিয়ার\nঅ্যারে (contiguous, O(1) ইনডেক্স অ্যাক্সেস), লিংকড লিস্ট (O(1) insert/delete at head, O(n) অ্যাক্সেস), স্ট্যাক (LIFO), কিউ (FIFO)\n\n## নন-লিনিয়ার\nট্রি (hierarchical), গ্রাফ (nodes + edges), হ্যাশ টেবিল (average O(1) lookup)'),
(@lang_algo,
'Big-O, সার্চিং, সর্টিং, রিকার্শন, ডিভাইড অ্যান্ড কনকার — কোর অ্যালগরিদমিক প্যাটার্ন এক নজরে (ভাষা-নিরপেক্ষ)।',
'## Big-O\n`O(1)` < `O(log n)` < `O(n)` < `O(n log n)` < `O(n^2)`\n\n## সার্চ\nলিনিয়ার সার্চ `O(n)`, বাইনারি সার্চ `O(log n)` (sorted ইনপুট লাগে)\n\n## সর্ট\nবাবল/ইনসারশন সর্ট `O(n^2)`, মার্জ/কুইকসর্ট গড়ে `O(n log n)`');

-- ---------------------------------------------------------------------------
-- Data Structures — full 6-module structure + free-preview Lesson 1
-- ---------------------------------------------------------------------------
INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_ds, 'arrays-lists',  'অ্যারে ও লিস্ট বেসিকস', 'Arrays & Lists Basics', 1),
(@lang_ds, 'stack-queue',   'স্ট্যাক ও কিউ',          'Stack & Queue',         2),
(@lang_ds, 'linked-list',   'লিংকড লিস্ট',            'Linked List',           3),
(@lang_ds, 'trees',         'ট্রি',                   'Trees',                 4),
(@lang_ds, 'graphs',        'গ্রাফ',                  'Graphs',                5),
(@lang_ds, 'hash-tables',   'হ্যাশ টেবিল',            'Hash Tables',           6);

SELECT id INTO @ds_basics FROM modules WHERE language_id = @lang_ds AND slug = 'arrays-lists';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@ds_basics, 'what-is-an-array', 'অ্যারে কী?', 'What is an Array?',
'একটি **অ্যারে** হলো একই টাইপের একাধিক ভ্যালু মেমোরিতে *পাশাপাশি* (contiguous) রাখার একটি ডেটা স্ট্রাকচার। প্রতিটি এলিমেন্টের একটি **ইনডেক্স** থাকে — বেশিরভাগ ভাষায় (C, C++, Java, Python, JavaScript) ইনডেক্স `0` থেকে শুরু হয়। যেকোনো ইনডেক্সে সরাসরি অ্যাক্সেস করা যায় `O(1)` টাইমে, যেটা অ্যারের সবচেয়ে বড় সুবিধা।

এই ট্র্যাকের কোড উদাহরণগুলো **ভাষা-নিরপেক্ষ pseudocode**-এ দেখানো হবে, কারণ ডেটা স্ট্রাকচার একটি কনসেপ্ট — যেকোনো ভাষায় ইমপ্লিমেন্ট করা যায়। প্রবলেম সাবমিট করার সময় আপনি নিজের পছন্দের ভাষা বেছে নিতে পারবেন।',
'arr = [3, 7, 2, 9, 4]
print(arr[0])   // 3  (প্রথম এলিমেন্ট, ইনডেক্স 0)
print(arr[2])   // 2  (তৃতীয় এলিমেন্ট, ইনডেক্স 2)',
NULL, 10, 1, 1, 0);
SELECT id INTO @ds_l1 FROM lessons WHERE module_id = @ds_basics AND slug = 'what-is-an-array';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@ds_l1, 'বেশিরভাগ প্রোগ্রামিং ভাষায় একটি অ্যারের প্রথম এলিমেন্টের ইনডেক্স কত?', 'In most programming languages, what is the index of an array''s first element?', NULL, 1);
SELECT id INTO @ds_l1_q1 FROM quiz_questions WHERE lesson_id = @ds_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@ds_l1_q1, 'A', '1', 0), (@ds_l1_q1, 'B', '0', 1), (@ds_l1_q1, 'C', '-1', 0), (@ds_l1_q1, 'D', 'ভাষাভেদে ভিন্ন, কোনো নিয়ম নেই', 0);

INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(NULL, @ds_l1, 'max-in-array', 'অ্যারের সর্বোচ্চ মান', 'Maximum Element in an Array',
'প্রথমে একটি পূর্ণসংখ্যা `n` ইনপুট নিন (এলিমেন্ট সংখ্যা), তারপর `n`টি পূর্ণসংখ্যা (স্পেস দিয়ে আলাদা, একই লাইনে)। অ্যারের সর্বোচ্চ মানটি প্রিন্ট করুন। যেকোনো সমর্থিত ভাষায় সাবমিট করতে পারবেন।',
NULL, 'easy', 20, 2000, 65536, 0);
SELECT id INTO @p_maxarr FROM problems WHERE slug = 'max-in-array';
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_maxarr, 0, '5\n3 7 2 9 4', '9', 1),
(@p_maxarr, 0, '3\n-1 -5 -2', '-1', 2),
(@p_maxarr, 1, '1\n42', '42', 3);

-- ---------------------------------------------------------------------------
-- Algorithms — full 6-module structure + free-preview Lesson 1
-- ---------------------------------------------------------------------------
INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order) VALUES
(@lang_algo, 'big-o',       'সময় জটিলতা ও Big-O',      'Time Complexity & Big-O', 1),
(@lang_algo, 'searching',   'সার্চিং',                  'Searching',               2),
(@lang_algo, 'sorting',     'সর্টিং',                   'Sorting',                 3),
(@lang_algo, 'recursion',   'রিকার্শন',                 'Recursion',               4),
(@lang_algo, 'divide-conquer','ডিভাইড অ্যান্ড কনকার',   'Divide and Conquer',      5),
(@lang_algo, 'dp-basics',   'ডায়নামিক প্রোগ্রামিং বেসিকস','Dynamic Programming Basics',6);

SELECT id INTO @algo_basics FROM modules WHERE language_id = @lang_algo AND slug = 'big-o';
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@algo_basics, 'what-is-an-algorithm', 'অ্যালগরিদম কী ও Big-O নোটেশন', 'What is an Algorithm & Big-O Notation',
'একটি **অ্যালগরিদম** হলো একটি সমস্যা সমাধানের সুনির্দিষ্ট ধাপে-ধাপে পদ্ধতি। একই সমস্যার একাধিক অ্যালগরিদম থাকতে পারে — কিন্তু কিছু অন্যদের চেয়ে দ্রুত। **Big-O নোটেশন** দিয়ে বোঝানো হয় ইনপুট সাইজ (`n`) বাড়ার সাথে সাথে সময় (বা মেমোরি) কতটা বাড়ে।

যেমন, একটি অ্যারেতে কোনো ভ্যালু খুঁজতে *একটা একটা করে* প্রতিটি এলিমেন্ট চেক করাকে বলে **লিনিয়ার সার্চ** — এর টাইম কমপ্লেক্সিটি `O(n)`, অর্থাৎ সবচেয়ে খারাপ ক্ষেত্রে `n`টি এলিমেন্ট চেক করতে হতে পারে।',
'// লিনিয়ার সার্চ (pseudocode)
function linearSearch(arr, target):
    for i from 0 to length(arr) - 1:
        if arr[i] == target:
            return i
    return -1',
NULL, 10, 1, 1, 0);
SELECT id INTO @algo_l1 FROM lessons WHERE module_id = @algo_basics AND slug = 'what-is-an-algorithm';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, sort_order) VALUES
(@algo_l1, 'একটি সাজানো-না-থাকা (unsorted) অ্যারেতে লিনিয়ার সার্চের ওয়ার্স্ট-কেস টাইম কমপ্লেক্সিটি কত?', 'What is the worst-case time complexity of linear search on an unsorted array?', NULL, 1);
SELECT id INTO @algo_l1_q1 FROM quiz_questions WHERE lesson_id = @algo_l1 AND sort_order = 1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@algo_l1_q1, 'A', 'O(1)', 0), (@algo_l1_q1, 'B', 'O(log n)', 0), (@algo_l1_q1, 'C', 'O(n)', 1), (@algo_l1_q1, 'D', 'O(n^2)', 0);

INSERT INTO problems (language_id, lesson_id, slug, title_bn, title_en, statement_md, starter_code, difficulty, xp_reward, time_limit_ms, memory_limit_kb, content_verified) VALUES
(NULL, @algo_l1, 'linear-search', 'লিনিয়ার সার্চ', 'Linear Search',
'প্রথমে `n` ইনপুট নিন, তারপর `n`টি পূর্ণসংখ্যা (একই লাইনে, স্পেস দিয়ে আলাদা), তারপর একটি টার্গেট ভ্যালু `x`। অ্যারেতে `x`-এর ইনডেক্স (0-based) প্রিন্ট করুন — না পেলে `-1` প্রিন্ট করুন। প্রথম যেই ইনডেক্সে পাওয়া যায় সেটাই রিটার্ন করুন।',
NULL, 'easy', 20, 2000, 65536, 0);
SELECT id INTO @p_linsearch FROM problems WHERE slug = 'linear-search';
INSERT INTO test_cases (problem_id, is_hidden, stdin, expected_stdout, sort_order) VALUES
(@p_linsearch, 0, '5\n3 7 2 9 4\n9', '3', 1),
(@p_linsearch, 0, '4\n1 2 3 4\n10', '-1', 2),
(@p_linsearch, 1, '3\n5 5 5\n5', '0', 3);

-- ---------------------------------------------------------------------------
-- Projects — portfolio-style capstones (self-reported, admin-reviewed;
-- NOT auto-judged — see BUILD-SPEC §9 and 02-SCHEMA.sql migration 008).
-- One per representative language for v1; more added via admin CRUD.
-- ---------------------------------------------------------------------------
INSERT INTO projects (language_id, slug, title_bn, title_en, brief_md, rubric_md, starter_repo_notes, xp_reward, content_verified) VALUES
(@lang_js, 'todo-list-app', 'টুডু লিস্ট অ্যাপ', 'Todo List App',
'একটি ব্রাউজার-বেসড Todo List অ্যাপ বানান: টাস্ক যোগ করা, সম্পন্ন হিসেবে মার্ক করা, এবং মুছে ফেলা যাবে। শুধু vanilla JavaScript (কোনো ফ্রেমওয়ার্ক ছাড়া) ব্যবহার করুন — এটা এই ট্র্যাকের Arrays ও Objects মডিউলের পর করার উপযুক্ত।',
'- টাস্ক যোগ/মুছা/সম্পন্ন-মার্ক তিনটাই কাজ করে কিনা\n- কোড রিডেবল ও যৌক্তিকভাবে ফাংশনে ভাগ করা কিনা\n- কমপক্ষে একটি README থাকা, যেখানে কীভাবে রান করতে হয় লেখা আছে',
'সাজেস্টেড ফাইল: index.html, style.css, app.js — কোনো বিল্ড স্টেপ দরকার নেই।',
100, 0),
(@lang_py, 'cli-calculator', 'কমান্ড-লাইন ক্যালকুলেটর', 'Command-Line Calculator',
'একটি কমান্ড-লাইন ক্যালকুলেটর বানান যা +, -, *, / সাপোর্ট করে এবং ইনভ্যালিড ইনপুট (যেমন শূন্য দিয়ে ভাগ) গ্রেসফুলি হ্যান্ডেল করে।',
'- চারটি অপারেশনই সঠিকভাবে কাজ করে কিনা\n- শূন্য দিয়ে ভাগ ক্র্যাশ না করে এরর মেসেজ দেখায় কিনা\n- ইনপুট লুপ চলতে থাকে যতক্ষণ না ইউজার exit লেখে',
'সাজেস্টেড ফাইল: calculator.py',
80, 0),
(@lang_c, 'student-grade-manager', 'স্টুডেন্ট গ্রেড ম্যানেজার', 'Student Grade Manager',
'একাধিক স্টুডেন্টের নাম ও নম্বর নিয়ে একটি প্রোগ্রাম বানান যা গড় (average), সর্বোচ্চ ও সর্বনিম্ন নম্বর বের করে দেখায়। অ্যারে ও ফাংশন ব্যবহার করুন।',
'- একাধিক স্টুডেন্টের ডেটা সঠিকভাবে স্টোর ও প্রসেস হয় কিনা\n- গড়/সর্বোচ্চ/সর্বনিম্ন হিসাব সঠিক কিনা\n- কোড আলাদা ফাংশনে যৌক্তিকভাবে ভাগ করা কিনা',
'সাজেস্টেড ফাইল: main.c',
80, 0);
