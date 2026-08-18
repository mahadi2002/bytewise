-- SQL track: CASE, NULL Functions & Stored Procedures (new module 9).
-- Continues the same fictional schema (students/classes).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_sql FROM languages WHERE slug = 'sql';
SELECT id INTO @m_case FROM modules WHERE language_id=@lang_sql AND slug='case-nulls-procs';

INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_case, 'case-expressions', 'CASE: কোয়েরির ভেতরে if-else', 'CASE: If-Else Inside a Query',
'`CASE` দিয়ে একটা কোয়েরির ভেতরেই শর্ত-ভিত্তিক ভ্যালু তৈরি করা যায় — অনেকটা অন্য ভাষার if-else-এর মতো, কিন্তু SQL-এর জন্য। রেজাল্টে একটা নতুন "কম্পিউটেড" কলাম হিসেবে ব্যবহার হয়।',
'SELECT name, marks,
    CASE
        WHEN marks >= 80 THEN ''A''
        WHEN marks >= 60 THEN ''B''
        ELSE ''C''
    END AS grade
FROM students;',
'sql', 10, 0, 1, 0),

(@m_case, 'null-functions', 'NULL ফাংশন: COALESCE ও IFNULL', 'NULL Functions: COALESCE & IFNULL',
'কোনো কলামের ভ্যালু `NULL` হলে তার বদলে একটা ডিফল্ট দেখাতে `COALESCE()` ব্যবহার হয় — একাধিক আর্গুমেন্ট দিলে প্রথম non-NULL ভ্যালুটা রিটার্ন করে। MySQL-এ দুটো আর্গুমেন্টের সহজ ভার্সন `IFNULL()`ও আছে।',
'SELECT name, COALESCE(email, ''no email provided'') AS contact
FROM students;

-- equivalent, MySQL-specific shorthand for exactly 2 arguments:
SELECT name, IFNULL(email, ''no email provided'') AS contact
FROM students;',
'sql', 10, 0, 2, 0),

(@m_case, 'stored-procedures-intro', 'Stored Procedure পরিচিতি', 'Introduction to Stored Procedures',
'একটা **stored procedure** হলো ডাটাবেসের ভেতরেই সংরক্ষিত, একাধিক SQL স্টেটমেন্টের একটা নামকরণ করা ব্লক — বারবার একই জটিল লজিক না লিখে, একবার সংজ্ঞায়িত করে `CALL`-এর মাধ্যমে বারবার চালানো যায়। এটা প্যারামিটারও নিতে পারে, ঠিক একটা ফাংশনের মতো।',
'DELIMITER //
CREATE PROCEDURE GetTopStudents(IN minMarks INT)
BEGIN
    SELECT name, marks FROM students WHERE marks >= minMarks;
END //
DELIMITER ;

CALL GetTopStudents(80);',
'sql', 10, 0, 3, 0),

(@m_case, 'case-null-proc-capstone', 'ক্যাপস্টোন: গ্রেড রিপোর্ট প্রসিডিউর', 'Capstone: A Grade Report Procedure',
'CASE, COALESCE, আর একটা stored procedure — তিনটাই একসাথে ব্যবহার করে একটা সম্পূর্ণ, পুনর্ব্যবহারযোগ্য গ্রেড-রিপোর্ট কোয়েরি বানানো হচ্ছে।',
'DELIMITER //
CREATE PROCEDURE GradeReport()
BEGIN
    SELECT
        name,
        COALESCE(email, ''N/A'') AS contact,
        CASE
            WHEN marks >= 80 THEN ''A''
            WHEN marks >= 60 THEN ''B''
            ELSE ''C''
        END AS grade
    FROM students;
END //
DELIMITER ;

CALL GradeReport();',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_case AND slug='case-expressions';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_case AND slug='null-functions';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_case AND slug='stored-procedures-intro';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_case AND slug='case-null-proc-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'marks = 65 হলে grade কলামে কী দেখাবে?', 'What does grade show when marks = 65?', 'CASE
    WHEN marks >= 80 THEN ''A''
    WHEN marks >= 60 THEN ''B''
    ELSE ''C''
END AS grade',
'৬৫, ৮০-এর কম কিন্তু ৬০-এর বেশি বা সমান — তাই দ্বিতীয় `WHEN marks >= 60` শর্তটা সত্যি হয় এবং `grade` কলামে "B" বসে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','A',0),(@q,'B','B',1),(@q,'C','C',0),(@q,'D','NULL',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'email কলাম NULL হলে COALESCE(email, ''no email provided'') কী রিটার্ন করবে?', 'What does COALESCE return when email is NULL?', "COALESCE(email, 'no email provided')",
'`COALESCE()` তার আর্গুমেন্টগুলোর মধ্যে প্রথম non-NULL ভ্যালুটা রিটার্ন করে — `email` NULL হওয়ায় প্রথমটা বাদ পড়ে, দ্বিতীয় আর্গুমেন্ট ''no email provided'' রিটার্ন হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','NULL',0),(@q,'B','''no email provided''',1),(@q,'C','খালি স্ট্রিং',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'CALL GetTopStudents(80); কী করে?', 'What does CALL GetTopStudents(80) do?', 'CREATE PROCEDURE GetTopStudents(IN minMarks INT)
BEGIN
    SELECT name, marks FROM students WHERE marks >= minMarks;
END',
'`CALL` স্টেটমেন্টটা `GetTopStudents` প্রসিডিউরটা চালায়, `minMarks` প্যারামিটারে `80` পাস করে — প্রসিডিউরের ভেতরের কোয়েরি তখন `WHERE marks >= 80` দিয়ে চলে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটা নতুন টেবিল তৈরি করে',0),(@q,'B','marks >= 80 শর্তে স্টুডেন্টদের নাম-মার্কস দেখায়',1),(@q,'C','সব স্টুডেন্ট ডিলিট করে',0),(@q,'D','কিছুই করে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'CALL GradeReport(); কতবার লিখে জটিল কোয়েরিটা আবার চালানো যায়?', 'How many times can this complex query be re-run with one line?', 'CALL GradeReport();',
'একবার প্রসিডিউর হিসেবে সংরক্ষণ করার পর, পুরো জটিল কোয়েরিটা (CASE + COALESCE সহ) যতবার দরকার ততবার শুধু `CALL GradeReport();` লিখেই চালানো যায় — পুরো কোয়েরিটা বারবার নতুন করে লেখার দরকার নেই।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','মাত্র একবার',0),(@q,'B','যতবার দরকার ততবার, পুরো কোয়েরি না লিখেই',1),(@q,'C','কখনোই না',0),(@q,'D','শুধু একজন ইউজারের জন্য',0);
