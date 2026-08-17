-- SQL track: finish Basics (3 more) + all 5 remaining modules.
-- Uses one consistent fictional schema across every lesson's examples:
--   students(id, name, age, marks, class_id)
--   classes(id, class_name)
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'sql';
SELECT id INTO @m_basics FROM modules WHERE language_id=@lang AND slug='basics';
SELECT id INTO @m_filt   FROM modules WHERE language_id=@lang AND slug='filtering';
SELECT id INTO @m_agg    FROM modules WHERE language_id=@lang AND slug='aggregates';
SELECT id INTO @m_join   FROM modules WHERE language_id=@lang AND slug='joins';
SELECT id INTO @m_dml    FROM modules WHERE language_id=@lang AND slug='dml';
SELECT id INTO @m_sub    FROM modules WHERE language_id=@lang AND slug='subqueries';

-- ── Basics (lessons 2-4) ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_basics, 'column-aliases-distinct', 'কলাম alias ও DISTINCT', 'Column Aliases & DISTINCT',
'`AS` দিয়ে একটা কলাম বা রেজাল্টকে সাময়িকভাবে অন্য নাম (**alias**) দেওয়া যায় — রিপোর্টে পরিষ্কার নাম দেখাতে কাজে লাগে। `DISTINCT` দিয়ে ডুপ্লিকেট ভ্যালু বাদ দিয়ে শুধু ইউনিক ভ্যালুগুলো দেখা যায়।',
'SELECT name AS student_name
FROM students;

SELECT DISTINCT class_id
FROM students;',
'sql', 10, 0, 2, 0),

(@m_basics, 'limit-clause', 'LIMIT দিয়ে ফলাফল সীমিত করা', 'Limiting Results with LIMIT',
'`LIMIT` দিয়ে একটা কোয়েরির ফলাফল থেকে সর্বোচ্চ কতগুলো রো (row) দেখানো হবে তা ঠিক করা যায় — বড় টেবিলে সবকিছু না এনে শুধু একটা নমুনা দেখতে এটা খুবই কাজের।',
'SELECT name, marks
FROM students
LIMIT 3;',
'sql', 10, 0, 3, 0),

(@m_basics, 'first-query-capstone', 'ক্যাপস্টোন: alias, DISTINCT ও LIMIT একসাথে', 'Capstone: Alias, DISTINCT & LIMIT Together',
'আগের তিনটা লেসনের সবকিছু একসাথে — একটা কোয়েরি যা কলাম alias দেয়, ডুপ্লিকেট বাদ দেয়, আর ফলাফল সীমিত করে।',
'SELECT DISTINCT class_id AS class
FROM students
LIMIT 5;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_basics AND slug='column-aliases-distinct';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_basics AND slug='limit-clause';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_basics AND slug='first-query-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'SELECT DISTINCT class_id FROM students; — এটা কী রিটার্ন করবে?', 'What does this query return?', 'SELECT DISTINCT class_id FROM students;',
'`DISTINCT` ডুপ্লিকেট ভ্যালু বাদ দিয়ে দেয় — অনেক স্টুডেন্ট একই `class_id`-তে থাকতে পারে, কিন্তু এই কোয়েরি প্রতিটা `class_id` মাত্র একবার দেখাবে, প্রতিটা স্টুডেন্টের জন্য আলাদা রো নয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রতিটা স্টুডেন্টের class_id, ডুপ্লিকেট সহ',0),(@q,'B','প্রতিটা ইউনিক class_id, একবার করে',1),(@q,'C','স্টুডেন্টের মোট সংখ্যা',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'LIMIT 3 লেখা থাকলে ফলাফলে কয়টা রো থাকবে?', 'How many rows with LIMIT 3?', 'SELECT name, marks FROM students LIMIT 3;',
'`LIMIT 3` মানে ফলাফল থেকে সর্বোচ্চ ৩টা রো দেখানো হবে — যদি টেবিলে তার বেশি স্টুডেন্ট থাকে, বাকিগুলো ফলাফলে আসবে না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ঠিক ৩টা',1),(@q,'B','সব রো',0),(@q,'C','০টা',0),(@q,'D','টেবিলের নামের উপর নির্ভর করে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'SELECT DISTINCT class_id AS class FROM students LIMIT 5; — class শব্দটা এখানে কী?', 'What is "class" here?', 'SELECT DISTINCT class_id AS class FROM students LIMIT 5;',
'`AS class` দিয়ে `class_id` কলামটাকে ফলাফলে `class` নামে দেখানো হচ্ছে — এটা শুধু ফলাফলের কলাম-হেডারের একটা alias, আসল টেবিলের কলামের নাম বদলায় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','class_id কলামের একটা alias (ফলাফলে দেখানোর নাম)',1),(@q,'B','একটা নতুন টেবিল',0),(@q,'C','একটা এরর',0),(@q,'D','class_id-এর মান বদলে দেয়',0);

-- ── Filtering & Sorting ──────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_filt, 'where-clause', 'WHERE দিয়ে ফিল্টার করা', 'Filtering with WHERE',
'`WHERE` দিয়ে শর্ত মিলিয়ে নির্দিষ্ট রো বেছে নেওয়া যায় — `= != < > <= >=` অপারেটর, আর `AND`/`OR` দিয়ে একাধিক শর্ত একসাথে যাচাই করা যায়।',
'SELECT name, marks
FROM students
WHERE marks >= 80 AND age < 22;',
'sql', 10, 0, 1, 0),

(@m_filt, 'like-in-between', 'LIKE, IN ও BETWEEN', 'LIKE, IN & BETWEEN',
'`LIKE` দিয়ে টেক্সট প্যাটার্ন মেলানো যায় (`%` মানে যেকোনো অক্ষরের সিকোয়েন্স), `IN` দিয়ে একাধিক নির্দিষ্ট ভ্যালুর যেকোনো একটার সাথে মেলানো যায়, আর `BETWEEN` দিয়ে একটা রেঞ্জের মধ্যে আছে কিনা চেক করা যায়।',
'SELECT name FROM students WHERE name LIKE ''R%'';        -- starts with R
SELECT name FROM students WHERE class_id IN (1, 2, 3);
SELECT name FROM students WHERE marks BETWEEN 60 AND 90;',
'sql', 10, 0, 2, 0),

(@m_filt, 'order-by', 'ORDER BY দিয়ে সাজানো', 'Sorting with ORDER BY',
'`ORDER BY` দিয়ে ফলাফল কোনো কলাম অনুযায়ী সাজানো যায় — `ASC` (ছোট থেকে বড়, ডিফল্ট) বা `DESC` (বড় থেকে ছোট)।',
'SELECT name, marks
FROM students
ORDER BY marks DESC;',
'sql', 10, 0, 3, 0),

(@m_filt, 'filtering-capstone', 'ক্যাপস্টোন: ফিল্টার করে সাজানো', 'Capstone: Filter, then Sort',
'`WHERE` দিয়ে প্রথমে ফিল্টার, তারপর `ORDER BY` দিয়ে সাজানো — একটা টিপিক্যাল রিপোর্ট-স্টাইল কোয়েরির প্যাটার্ন, "৬০-এর বেশি মার্কস পাওয়া স্টুডেন্টদের মার্কস অনুযায়ী সাজিয়ে দেখাও"।',
'SELECT name, marks
FROM students
WHERE marks > 60
ORDER BY marks DESC;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_filt AND slug='where-clause';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_filt AND slug='like-in-between';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_filt AND slug='order-by';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_filt AND slug='filtering-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'marks >= 80 AND age < 22 — এই শর্তে কোন স্টুডেন্ট ফলাফলে আসবে?', 'Which student matches this condition?', 'WHERE marks >= 80 AND age < 22',
'`AND` মানে দুটো শর্তই সত্যি হতে হবে — মার্কস ৮০ বা তার বেশি *এবং* বয়স ২২-এর কম, দুটোই একসাথে মিলতে হবে, শুধু একটা মিললে চলবে না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','যাদের শুধু মার্কস ৮০+',0),(@q,'B','যাদের মার্কস ৮০+ এবং বয়স ২২-এর কম, দুটোই',1),(@q,'C','যাদের বয়স ২২-এর বেশি',0),(@q,'D','সব স্টুডেন্ট',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, "WHERE name LIKE 'R%' — এটা কী মেলাবে?", "What does this match?", "WHERE name LIKE 'R%'",
"`%` মানে যেকোনো (শূন্য বা তার বেশি) অক্ষরের সিকোয়েন্স। `'R%'` মানে যে নামগুলো 'R' দিয়ে শুরু হয় — যেমন 'Rafi', 'Rina' — তাদের সবাইকে মেলাবে।", 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু "R" নামের স্টুডেন্ট',0),(@q,'B','যেসব নাম "R" দিয়ে শুরু হয়',1),(@q,'C','যেসব নামে "R" আছে যেকোনো জায়গায়',0),(@q,'D','যেসব নাম "R" দিয়ে শেষ হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'ORDER BY marks DESC — ফলাফল কীভাবে সাজানো থাকবে?', 'How are results ordered?', 'SELECT name, marks FROM students ORDER BY marks DESC;',
'`DESC` মানে বড় থেকে ছোট (descending) — সবচেয়ে বেশি মার্কসপ্রাপ্ত স্টুডেন্ট সবার উপরে থাকবে, তারপর ক্রমান্বয়ে কম মার্কসের দিকে যাবে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সবচেয়ে কম মার্কস সবার উপরে',0),(@q,'B','সবচেয়ে বেশি মার্কস সবার উপরে',1),(@q,'C','নাম অনুযায়ী বর্ণানুক্রমে',0),(@q,'D','র‍্যান্ডম ক্রমে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'WHERE আর ORDER BY একসাথে থাকলে কোনটা আগে প্রয়োগ হয়?', 'Which applies first, WHERE or ORDER BY?', 'SELECT name, marks FROM students
WHERE marks > 60
ORDER BY marks DESC;',
'প্রথমে `WHERE` দিয়ে অপ্রয়োজনীয় রো বাদ দেওয়া হয় (ফিল্টার), তারপর যা বাকি থাকে সেগুলো `ORDER BY` দিয়ে সাজানো হয় — ফিল্টার সবসময় সর্টিংয়ের আগে হয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','WHERE আগে, তারপর ORDER BY',1),(@q,'B','ORDER BY আগে, তারপর WHERE',0),(@q,'C','দুটো একসাথে, ক্রম গুরুত্বপূর্ণ নয়',0),(@q,'D','এটা অবৈধ কম্বিনেশন',0);

-- ── Aggregates & GROUP BY ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_agg, 'aggregate-functions', 'অ্যাগ্রিগেট ফাংশন: COUNT, SUM, AVG, MAX, MIN', 'Aggregate Functions',
'অ্যাগ্রিগেট ফাংশন একাধিক রোকে মিলিয়ে একটা ভ্যালু বের করে: `COUNT()` কয়টা রো, `SUM()` যোগফল, `AVG()` গড়, `MAX()`/`MIN()` সর্বোচ্চ/সর্বনিম্ন।',
'SELECT COUNT(*) FROM students;
SELECT AVG(marks) FROM students;
SELECT MAX(marks) FROM students;',
'sql', 10, 0, 1, 0),

(@m_agg, 'group-by-basics', 'GROUP BY: গ্রুপ ভিত্তিক ফলাফল', 'GROUP BY: Results per Group',
'`GROUP BY` দিয়ে একটা কলামের একই ভ্যালু থাকা রো-গুলোকে একেকটা গ্রুপে ভাগ করে, প্রতিটা গ্রুপের জন্য আলাদাভাবে অ্যাগ্রিগেট ফাংশন হিসাব করা যায় — যেমন "প্রতিটা ক্লাসের গড় মার্কস কত"।',
'SELECT class_id, AVG(marks) AS avg_marks
FROM students
GROUP BY class_id;',
'sql', 10, 0, 2, 0),

(@m_agg, 'having-clause', 'HAVING: গ্রুপের উপর ফিল্টার', 'HAVING: Filtering Groups',
'`WHERE` সাধারণ রো ফিল্টার করে, কিন্তু গ্রুপ-করা ফলাফলের (যেমন `AVG()`-এর উপর) ফিল্টার করতে `HAVING` লাগে — `WHERE` অ্যাগ্রিগেট ফাংশনে সরাসরি কাজ করে না।',
'SELECT class_id, AVG(marks) AS avg_marks
FROM students
GROUP BY class_id
HAVING AVG(marks) > 75;',
'sql', 10, 0, 3, 0),

(@m_agg, 'aggregates-capstone', 'ক্যাপস্টোন: প্রতি ক্লাসের সেরা ফলাফল', 'Capstone: Best Class Average',
'GROUP BY আর HAVING একসাথে ব্যবহার করে শুধু সেই ক্লাসগুলো বের করা হচ্ছে, যাদের গড় মার্কস ৮০-এর বেশি।',
'SELECT class_id, COUNT(*) AS total_students, AVG(marks) AS avg_marks
FROM students
GROUP BY class_id
HAVING AVG(marks) > 80
ORDER BY avg_marks DESC;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_agg AND slug='aggregate-functions';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_agg AND slug='group-by-basics';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_agg AND slug='having-clause';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_agg AND slug='aggregates-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'COUNT(*) কী রিটার্ন করে?', 'What does COUNT(*) return?', 'SELECT COUNT(*) FROM students;',
'`COUNT(*)` টেবিলে (অথবা ফিল্টারের পর) মোট কয়টা রো আছে সেটা গুনে দেয় — এখানে `students` টেবিলে মোট কয়জন স্টুডেন্ট আছে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','মোট রো সংখ্যা',1),(@q,'B','মার্কসের যোগফল',0),(@q,'C','সবচেয়ে বেশি মার্কস',0),(@q,'D','একটা কলামের নাম',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'GROUP BY class_id — এটা কী করে?', 'What does GROUP BY class_id do?', 'SELECT class_id, AVG(marks) FROM students GROUP BY class_id;',
'`GROUP BY class_id` একই `class_id` থাকা স্টুডেন্টদের একেকটা গ্রুপে ভাগ করে, তারপর প্রতিটা গ্রুপের জন্য আলাদাভাবে `AVG(marks)` হিসাব করে — পুরো টেবিলের একটা গড় নয়, প্রতিটা ক্লাসের আলাদা গড়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রতিটা ক্লাসের জন্য আলাদা গড় হিসাব করে',1),(@q,'B','সব স্টুডেন্ট মুছে ফেলে',0),(@q,'C','পুরো টেবিলের একটা গড় দেয়',0),(@q,'D','class_id কলাম সরিয়ে দেয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'WHERE-এর বদলে HAVING কেন লাগে এখানে?', 'Why HAVING instead of WHERE here?', 'GROUP BY class_id
HAVING AVG(marks) > 75;',
'`WHERE` গ্রুপ-করার *আগে* রো ফিল্টার করে, তাই সেখানে `AVG()`-এর মতো অ্যাগ্রিগেট ফাংশন সরাসরি ব্যবহার করা যায় না। `HAVING` গ্রুপ-করার *পরে* ফিল্টার করে, তাই গ্রুপ-ভিত্তিক অ্যাগ্রিগেট ভ্যালুর উপর শর্ত দিতে এটাই লাগে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','WHERE গ্রুপ-করার পরে অ্যাগ্রিগেটের উপর কাজ করতে পারে না, HAVING করতে পারে',1),(@q,'B','দুটো একই জিনিস, যেকোনোটা লেখা যেত',0),(@q,'C','HAVING দ্রুত চলে',0),(@q,'D','WHERE ব্যবহার করলে Error হতো না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'HAVING AVG(marks) > 80 — কোন ক্লাসগুলো ফলাফলে থাকবে?', 'Which classes appear in the result?', 'GROUP BY class_id
HAVING AVG(marks) > 80',
'শুধু সেই ক্লাসগুলো ফলাফলে থাকবে, যাদের ছাত্রছাত্রীদের গড় মার্কস ৮০-এর বেশি — ৮০ বা তার কম গড় থাকা ক্লাসগুলো `HAVING` শর্তে বাদ পড়ে যাবে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সব ক্লাস',0),(@q,'B','শুধু যাদের গড় মার্কস ৮০-এর বেশি',1),(@q,'C','শুধু যাদের একজনও স্টুডেন্ট আছে',0),(@q,'D','কোনো ক্লাসই না',0);

-- ── Joins ────────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_join, 'inner-join', 'INNER JOIN: দুটো টেবিল জোড়া লাগানো', 'INNER JOIN: Combining Two Tables',
'বাস্তব ডেটাবেসে তথ্য একাধিক টেবিলে ভাগ করা থাকে — যেমন `students`-এর `class_id` আসলে `classes` টেবিলের একটা রেফারেন্স। `INNER JOIN` দুটো টেবিলকে একটা কমন কলাম দিয়ে জোড়া লাগায়, শুধু সেই রো-গুলো রাখে যাদের দুই টেবিলেই মিল আছে।',
'SELECT students.name, classes.class_name
FROM students
INNER JOIN classes ON students.class_id = classes.id;',
'sql', 10, 0, 1, 0),

(@m_join, 'left-join', 'LEFT JOIN: বাম টেবিলের সব রো রাখা', 'LEFT JOIN: Keeping All Rows from the Left Table',
'`LEFT JOIN`-এ বাম টেবিলের (এখানে `students`) সব রো থাকে, ডান টেবিলে (`classes`) মিল না পেলেও — শুধু সেই ক্ষেত্রে ডান টেবিলের কলামগুলো `NULL` হয়ে যায়। কোনো ক্লাসে বরাদ্দ না হওয়া স্টুডেন্টও দেখাতে চাইলে এটা লাগে।',
'SELECT students.name, classes.class_name
FROM students
LEFT JOIN classes ON students.class_id = classes.id;',
'sql', 10, 0, 2, 0),

(@m_join, 'join-with-filter', 'JOIN-এর সাথে WHERE ও ORDER BY', 'JOIN with WHERE & ORDER BY',
'JOIN-এর পর সাধারণ `WHERE`/`ORDER BY` একইভাবে কাজ করে — জোড়া লাগানো ফলাফলের উপরেই ফিল্টার আর সর্টিং প্রয়োগ হয়, যেন এটা একটা সাধারণ টেবিলের মতোই আচরণ করে।',
'SELECT students.name, classes.class_name, students.marks
FROM students
INNER JOIN classes ON students.class_id = classes.id
WHERE students.marks > 70
ORDER BY students.marks DESC;',
'sql', 10, 0, 3, 0),

(@m_join, 'joins-capstone', 'ক্যাপস্টোন: ক্লাস-ভিত্তিক স্টুডেন্ট লিস্ট', 'Capstone: Students Listed by Class',
'একটা সম্পূর্ণ কোয়েরি — দুটো টেবিল জোড়া লাগানো, ফিল্টার করা, আর ক্লাসের নাম অনুযায়ী সাজানো, যেন একটা রিপোর্ট তৈরি হয়।',
'SELECT classes.class_name, students.name, students.marks
FROM students
INNER JOIN classes ON students.class_id = classes.id
WHERE students.marks >= 60
ORDER BY classes.class_name, students.marks DESC;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_join AND slug='inner-join';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_join AND slug='left-join';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_join AND slug='join-with-filter';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_join AND slug='joins-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'INNER JOIN কোন রো-গুলো রাখে?', 'Which rows does INNER JOIN keep?', 'FROM students
INNER JOIN classes ON students.class_id = classes.id;',
'`INNER JOIN` শুধু সেই রো-গুলো রাখে, যাদের দুই টেবিলেই (এখানে `students.class_id` আর `classes.id`) মিল আছে — কোনো একটাতে মিল না পেলে সেই রো ফলাফলে আসে না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু students-এর সব রো',0),(@q,'B','যাদের দুই টেবিলেই মিল আছে',1),(@q,'C','যাদের কোথাও মিল নেই',0),(@q,'D','classes-এর সব রো',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'কোনো class_id-তে বরাদ্দ না হওয়া স্টুডেন্টের class_name কী দেখাবে LEFT JOIN-এ?', 'What shows for class_name if a student has no matching class in LEFT JOIN?', 'FROM students
LEFT JOIN classes ON students.class_id = classes.id;',
'`LEFT JOIN`-এ বাম টেবিলের (students) সব রো থাকে, ডান টেবিলে মিল না পেলে সেই কলামগুলো (এখানে `class_name`) `NULL` হয়ে যায় — রোটা বাদ পড়ে না, যেমনটা `INNER JOIN`-এ হতো।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সেই স্টুডেন্টের রোটাই ফলাফল থেকে বাদ পড়ে যায়',0),(@q,'B','NULL',1),(@q,'C','একটা এরর দেখায়',0),(@q,'D','খালি স্ট্রিং',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'JOIN-এর পরে WHERE students.marks > 70 কখন প্রয়োগ হয়?', 'When does WHERE apply after a JOIN?', 'FROM students
INNER JOIN classes ON students.class_id = classes.id
WHERE students.marks > 70',
'প্রথমে দুই টেবিল জোড়া লাগানো হয় (JOIN), তারপর সেই জোড়া-লাগানো ফলাফলের উপর `WHERE` ফিল্টার প্রয়োগ হয় — যেন এটা একটা কমবাইন্ড টেবিলের সাধারণ ফিল্টার।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','JOIN হওয়ার আগে',0),(@q,'B','JOIN হওয়ার পর, কমবাইন্ড ফলাফলের উপর',1),(@q,'C','কখনোই প্রয়োগ হয় না',0),(@q,'D','শুধু classes টেবিলে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'ORDER BY classes.class_name, students.marks DESC — প্রথমে কীসের ভিত্তিতে সাজাবে?', 'What is the primary sort key here?', 'ORDER BY classes.class_name, students.marks DESC',
'`ORDER BY`-তে প্রথমে লেখা কলামটাই প্রধান সর্ট-কী — প্রথমে `class_name` অনুযায়ী (বর্ণানুক্রমে) সাজানো হবে, আর একই ক্লাসের ভেতরে থাকা স্টুডেন্টরা `marks`-এর ভিত্তিতে (বড় থেকে ছোট) সাজানো থাকবে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','class_name',1),(@q,'B','marks',0),(@q,'C','দুটো সমান গুরুত্বপূর্ণ, ক্রম গুরুত্বহীন',0),(@q,'D','এলোমেলোভাবে',0);

-- ── Data Modification (DML) ──────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_dml, 'insert-statement', 'INSERT: নতুন ডেটা যোগ করা', 'INSERT: Adding New Data',
'`INSERT INTO` দিয়ে একটা টেবিলে নতুন রো যোগ করা হয় — কোন কলামে কী ভ্যালু যাবে তা নির্দিষ্ট করতে হয়, কলাম আর ভ্যালুর ক্রম মিলিয়ে।',
'INSERT INTO students (name, age, marks, class_id)
VALUES (''Farzana'', 21, 88, 1);',
'sql', 10, 0, 1, 0),

(@m_dml, 'update-statement', 'UPDATE: বিদ্যমান ডেটা পরিবর্তন করা', 'UPDATE: Modifying Existing Data',
'`UPDATE ... SET ... WHERE` দিয়ে বিদ্যমান রো-এর ভ্যালু বদলানো হয়। **`WHERE` ছাড়া `UPDATE` চালালে টেবিলের সব রো একসাথে বদলে যাবে** — এটা SQL-এর সবচেয়ে বিপজ্জনক ভুলগুলোর একটা, তাই `WHERE` কখনো ভুলে যাওয়া চলবে না।',
'UPDATE students
SET marks = 95
WHERE name = ''Farzana'';',
'sql', 10, 0, 2, 0),

(@m_dml, 'delete-statement', 'DELETE: ডেটা মুছে ফেলা', 'DELETE: Removing Data',
'`DELETE FROM ... WHERE` দিয়ে রো মুছে ফেলা হয়। `UPDATE`-এর মতোই — **`WHERE` ছাড়া `DELETE` চালালে পুরো টেবিলের সব ডেটা মুছে যাবে**, তাই সবসময় প্রথমে একই `WHERE` শর্ত দিয়ে `SELECT` চালিয়ে দেখে নেওয়া ভালো অভ্যাস, কোন রো-গুলো প্রভাবিত হবে।',
'DELETE FROM students
WHERE marks < 40;',
'sql', 10, 0, 3, 0),

(@m_dml, 'dml-capstone', 'ক্যাপস্টোন: যোগ, পরিবর্তন, মোছা', 'Capstone: Insert, Update, Delete',
'একটা স্টুডেন্টের জীবনচক্র — ভর্তি হওয়া (`INSERT`), পরীক্ষার পর মার্কস আপডেট হওয়া (`UPDATE`), আর কোর্স ছেড়ে দিলে রেকর্ড মোছা (`DELETE`) — সবসময় `WHERE` দিয়ে সাবধানে নির্দিষ্ট করে।',
'INSERT INTO students (name, age, marks, class_id) VALUES (''Imran'', 20, 0, 2);
UPDATE students SET marks = 76 WHERE name = ''Imran'';
DELETE FROM students WHERE name = ''Imran'' AND marks < 40;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_dml AND slug='insert-statement';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_dml AND slug='update-statement';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_dml AND slug='delete-statement';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_dml AND slug='dml-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'INSERT-এ কলাম আর VALUES-এর ক্রম না মিললে কী হবে?', 'What happens if column and VALUES order don''t match?', "INSERT INTO students (name, age, marks, class_id)
VALUES ('Farzana', 21, 88, 1);",
'`INSERT`-এ কলামের তালিকা আর `VALUES`-এর ভ্যালুগুলো *পজিশন অনুযায়ী* মেলানো হয় — প্রথম কলামের সাথে প্রথম ভ্যালু, দ্বিতীয়র সাথে দ্বিতীয়টা। ক্রম না মিললে ভুল কলামে ভুল ডেটা বসে যাবে (বা টাইপ না মিললে এরর হবে)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','SQL নিজে থেকে ঠিক কলামে বসিয়ে দেয়',0),(@q,'B','ভুল কলামে ভুল ডেটা বসতে পারে বা এরর হতে পারে',1),(@q,'C','কিছুই যোগ হবে না, নীরবে বাদ যাবে',0),(@q,'D','সবসময় ঠিকভাবেই যোগ হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'UPDATE students SET marks = 0; (WHERE ছাড়া) — কী হবে?', 'What happens with UPDATE and no WHERE?', 'UPDATE students SET marks = 0;',
'`WHERE` ছাড়া `UPDATE` টেবিলের *প্রতিটা* রো-তে প্রভাব ফেলে — এখানে সব স্টুডেন্টের `marks` একসাথে `0` হয়ে যাবে, শুধু একজনের নয়। এজন্যই `WHERE` ভুলে যাওয়া এত বিপজ্জনক।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কোনো রো বদলাবে না',0),(@q,'B','টেবিলের সব রো-র marks 0 হয়ে যাবে',1),(@q,'C','এটা একটা সিনট্যাক্স এরর',0),(@q,'D','শুধু প্রথম রো বদলাবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'DELETE চালানোর আগে কী করা ভালো অভ্যাস?', 'What is good practice before running DELETE?', 'DELETE FROM students WHERE marks < 40;',
'একই `WHERE` শর্ত দিয়ে আগে একটা `SELECT` চালিয়ে দেখে নেওয়া ভালো, ঠিক কোন কোন রো প্রভাবিত হবে — যেহেতু `DELETE` স্থায়ীভাবে ডেটা মুছে ফেলে, ভুল `WHERE` শর্তে অপ্রত্যাশিত ডেটা হারানোর ঝুঁকি থাকে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সরাসরি DELETE চালিয়ে দেওয়া',0),(@q,'B','একই WHERE দিয়ে আগে SELECT চালিয়ে যাচাই করা',1),(@q,'C','টেবিলটাই মুছে ফেলা',0),(@q,'D','কিছু করার দরকার নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'নিচের তিনটা স্টেটমেন্ট কোন ক্রমে চলা উচিত?', 'In what order should these three statements run?', "INSERT INTO students (...) VALUES ('Imran', ...);
UPDATE students SET marks = 76 WHERE name = 'Imran';
DELETE FROM students WHERE name = 'Imran' AND marks < 40;",
'যৌক্তিক ক্রম: আগে `INSERT` দিয়ে স্টুডেন্ট তৈরি হবে, তারপর `UPDATE` দিয়ে তার মার্কস বসবে, সবশেষে (যদি দরকার হয়) `DELETE` দিয়ে মোছা হবে — উল্টো ক্রমে চালালে `UPDATE`/`DELETE` কোনো ম্যাচিং রো-ই পাবে না।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','INSERT → UPDATE → DELETE',1),(@q,'B','DELETE → UPDATE → INSERT',0),(@q,'C','ক্রম কোনো ব্যাপার না',0),(@q,'D','UPDATE → INSERT → DELETE',0);

-- ── Subqueries & Indexes ─────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_sub, 'subqueries-basics', 'সাবকোয়েরি: WHERE-এর ভেতরে একটা কোয়েরি', 'Subqueries: A Query Inside WHERE',
'একটা **সাবকোয়েরি** হলো অন্য একটা কোয়েরির ভেতরে বসানো কোয়েরি — সাধারণত `WHERE`-এর ভেতরে, যখন একটা শর্তের ভ্যালুটা নিজেও একটা কোয়েরি চালিয়ে বের করতে হয়।',
'SELECT name, marks
FROM students
WHERE marks > (SELECT AVG(marks) FROM students);',
'sql', 10, 0, 1, 0),

(@m_sub, 'subqueries-in-select', 'SELECT-এর ভেতরে সাবকোয়েরি', 'Subqueries in SELECT',
'সাবকোয়েরি `SELECT`-এর কলাম লিস্টেও বসানো যায় — প্রতিটা রো-এর জন্য একটা এক্সট্রা হিসাব করা মান দেখাতে, যেমন প্রতিটা স্টুডেন্টের মার্কসের সাথে সামগ্রিক গড়ও পাশাপাশি দেখানো।',
'SELECT name, marks,
    (SELECT AVG(marks) FROM students) AS class_average
FROM students;',
'sql', 10, 0, 2, 0),

(@m_sub, 'indexes-basics', 'ইনডেক্স: SELECT দ্রুত করার উপায়', 'Indexes: Speeding Up SELECT',
'একটা **ইনডেক্স** কোনো কলামের জন্য আলাদা একটা দ্রুত-খোঁজার স্ট্রাকচার তৈরি করে — টেবিলে লক্ষ লক্ষ রো থাকলে, ইনডেক্স ছাড়া প্রতিটা রো একে একে চেক করতে হয় (`O(n)`), ইনডেক্স থাকলে অনেক দ্রুত খুঁজে পাওয়া যায়। তবে প্রতিটা `INSERT`/`UPDATE`-এ ইনডেক্সও আপডেট করতে হয়, তাই সব কলামে ইনডেক্স বসানো ঠিক না।',
'CREATE INDEX idx_students_marks ON students (marks);

-- Now this query can use the index instead of scanning every row:
SELECT name FROM students WHERE marks > 90;',
'sql', 10, 0, 3, 0),

(@m_sub, 'subqueries-capstone', 'ক্যাপস্টোন: গড়ের চেয়ে বেশি মার্কস পাওয়া স্টুডেন্ট', 'Capstone: Above-Average Students',
'সাবকোয়েরি ব্যবহার করে শুধু সেই স্টুডেন্টদের বের করা হচ্ছে, যাদের মার্কস সামগ্রিক গড়ের চেয়ে বেশি — এবং ফলাফল মার্কস অনুযায়ী সাজানো।',
'SELECT name, marks
FROM students
WHERE marks > (SELECT AVG(marks) FROM students)
ORDER BY marks DESC;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_sub AND slug='subqueries-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_sub AND slug='subqueries-in-select';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_sub AND slug='indexes-basics';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_sub AND slug='subqueries-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, '(SELECT AVG(marks) FROM students) — এই সাবকোয়েরিটা কখন চলে?', 'When does this subquery run?', 'WHERE marks > (SELECT AVG(marks) FROM students);',
'ভেতরের সাবকোয়েরিটা (`SELECT AVG(marks) FROM students`) আগে চলে গড় বের করে, তারপর সেই একটা ভ্যালুর সাথে বাইরের কোয়েরির `WHERE marks >` তুলনা করা হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','বাইরের কোয়েরির প্রতিটা রো-এর জন্য একবার করে',0),(@q,'B','গড় হিসাব করার জন্য, WHERE-এর তুলনায় ব্যবহারের আগে',1),(@q,'C','এটা কখনো চলে না',0),(@q,'D','প্রোগ্রাম শেষে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'class_average কলামে সব রো-তে কী মান দেখাবে?', 'What value does class_average show in every row?', 'SELECT name, marks,
    (SELECT AVG(marks) FROM students) AS class_average
FROM students;',
'সাবকোয়েরিটা `students`-এর সামগ্রিক গড় বের করে, এবং এই একই মানটা ফলাফলের *প্রতিটা* রো-তে `class_average` কলামে পাশাপাশি দেখানো হবে — প্রতিটা স্টুডেন্টের নিজের মার্কসের পাশে গোটা ক্লাসের গড় তুলনার জন্য।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রতিটা রো-তে একই সামগ্রিক গড়',1),(@q,'B','প্রতিটা রো-তে আলাদা আলাদা গড়',0),(@q,'C','সবসময় NULL',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'ইনডেক্স বসানোর প্রধান সুবিধা কী?', 'What is the main benefit of an index?', 'CREATE INDEX idx_students_marks ON students (marks);',
'ইনডেক্স ছাড়া বড় টেবিলে `WHERE`-এ প্রতিটা রো একে একে চেক করতে হয়। ইনডেক্স থাকলে সেই কলামে খোঁজা অনেক দ্রুত হয় — বিশেষ করে লক্ষ লক্ষ রো-এর টেবিলে এই পার্থক্য বিশাল।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ডেটা সাংগঠনিকভাবে সুন্দর দেখায়',0),(@q,'B','সেই কলামে SELECT দ্রুত হয়',1),(@q,'C','INSERT/UPDATE দ্রুত হয়',0),(@q,'D','ডুপ্লিকেট ডেটা বাদ দেয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'এই কোয়েরির ফলাফল কীভাবে সাজানো থাকবে?', 'How is this result ordered?', 'WHERE marks > (SELECT AVG(marks) FROM students)
ORDER BY marks DESC;',
'প্রথমে সাবকোয়েরি দিয়ে গড়ের চেয়ে বেশি মার্কস পাওয়া স্টুডেন্টদের বাছাই করা হয়, তারপর `ORDER BY marks DESC` দিয়ে তাদের সবচেয়ে বেশি মার্কস থেকে কম মার্কসের ক্রমে সাজানো হয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সবচেয়ে বেশি মার্কস থেকে কমের দিকে',1),(@q,'B','সবচেয়ে কম মার্কস থেকে বেশির দিকে',0),(@q,'C','নাম অনুযায়ী',0),(@q,'D','এলোমেলোভাবে',0);
