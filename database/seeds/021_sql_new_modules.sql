-- SQL track: Database Design & Constraints + Views & Set Operations
-- (new modules 7-8). Continues the same fictional schema
-- (students(id, name, age, marks, class_id), classes(id, class_name)).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_sql FROM languages WHERE slug = 'sql';
SELECT id INTO @m_design FROM modules WHERE language_id=@lang_sql AND slug='schema-design';
SELECT id INTO @m_views  FROM modules WHERE language_id=@lang_sql AND slug='views-set-ops';

-- ── Database Design & Constraints ────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_design, 'create-table', 'CREATE TABLE: টেবিল বানানো', 'CREATE TABLE: Building a Table',
'এতদিন `students`/`classes` টেবিল ধরে নিয়ে কোয়েরি লেখা হয়েছে — এখন সেগুলো আসলে কীভাবে *তৈরি* হয় সেটা দেখা হচ্ছে। `CREATE TABLE`-এ প্রতিটা কলামের নাম আর ডেটা টাইপ (`INT`, `VARCHAR`, ইত্যাদি) দিতে হয়।',
'CREATE TABLE classes (
    id INT PRIMARY KEY,
    class_name VARCHAR(50)
);

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    marks INT,
    class_id INT
);',
'sql', 10, 0, 1, 0),

(@m_design, 'primary-foreign-keys', 'PRIMARY KEY ও FOREIGN KEY', 'PRIMARY KEY & FOREIGN KEY',
'**PRIMARY KEY** প্রতিটা রো-কে ইউনিকভাবে চেনায় — দুটো রো একই প্রাইমারি কী শেয়ার করতে পারে না। **FOREIGN KEY** একটা টেবিলের কলামকে আরেকটা টেবিলের প্রাইমারি কী-এর সাথে সংযুক্ত রাখে — এটাই আগের JOIN লেসনে `students.class_id = classes.id`-এর ভিত্তি, আর ডাটাবেস নিজে থেকেই নিশ্চিত করে অস্তিত্বহীন `class_id` বসানো যাবে না।',
'CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(id)
);',
'sql', 10, 0, 2, 0),

(@m_design, 'not-null-unique-default', 'NOT NULL, UNIQUE ও DEFAULT', 'NOT NULL, UNIQUE & DEFAULT',
'`NOT NULL` কনস্ট্রেইন্ট দিলে সেই কলামে খালি (NULL) ভ্যালু বসানো যাবে না। `UNIQUE` দিলে সেই কলামে কোনো ডুপ্লিকেট ভ্যালু থাকতে পারবে না (প্রাইমারি কী না হলেও)। `DEFAULT` দিয়ে ভ্যালু না দিলে একটা ডিফল্ট বসানো যায়।',
'CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    marks INT DEFAULT 0
);',
'sql', 10, 0, 3, 0),

(@m_design, 'schema-design-capstone', 'ক্যাপস্টোন: সম্পূর্ণ স্কিমা ডিজাইন', 'Capstone: A Complete Schema Design',
'একটা সম্পূর্ণ, সম্পর্কযুক্ত দুই-টেবিলের স্কিমা — প্রাইমারি কী, ফরেন কী, আর কনস্ট্রেইন্ট সবকিছু একসাথে ব্যবহার করে।',
'CREATE TABLE classes (
    id INT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    marks INT DEFAULT 0,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(id)
);',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_design AND slug='create-table';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_design AND slug='primary-foreign-keys';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_design AND slug='not-null-unique-default';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_design AND slug='schema-design-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'CREATE TABLE-এ প্রতিটা কলামের জন্য কী দিতে হয়?', 'What must be given for each column in CREATE TABLE?', 'CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    ...
);',
'প্রতিটা কলামের একটা নাম আর একটা ডেটা টাইপ (যেমন `INT`, `VARCHAR(100)`) দিতে হয় — টাইপটা বলে দেয় সেই কলামে কী ধরনের ডেটা রাখা হবে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু নাম',0),(@q,'B','নাম ও ডেটা টাইপ',1),(@q,'C','শুধু ডেটা টাইপ',0),(@q,'D','কিছুই লাগে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'FOREIGN KEY (class_id) REFERENCES classes(id) — এটা কী নিশ্চিত করে?', 'What does this FOREIGN KEY ensure?', 'FOREIGN KEY (class_id) REFERENCES classes(id)',
'এটা নিশ্চিত করে যে `students.class_id`-তে শুধু সেই ভ্যালুই বসানো যাবে, যা `classes.id`-তে সত্যিই আছে — একটা অস্তিত্বহীন `class_id` (যেমন ৯৯৯) বসাতে গেলে ডাটাবেস এরর দেবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','class_id সবসময় NULL হতে হবে',0),(@q,'B','class_id-তে শুধু classes.id-তে থাকা ভ্যালুই বসানো যাবে',1),(@q,'C','class_id স্বয়ংক্রিয়ভাবে বাড়তে থাকবে',0),(@q,'D','কোনো প্রভাব নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'marks INT DEFAULT 0 — কোনো ভ্যালু না দিয়ে INSERT করলে marks কী হবে?', 'What is marks if not specified on INSERT?', 'CREATE TABLE students (
    ...
    marks INT DEFAULT 0
);
INSERT INTO students (id, name) VALUES (1, ''Rafi'');',
'`marks`-এর জন্য `DEFAULT 0` সেট করা আছে — INSERT-এ `marks`-এর ভ্যালু না দিলে এটা স্বয়ংক্রিয়ভাবে `0` বসিয়ে দেবে, `NULL` নয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','NULL',0),(@q,'B','0',1),(@q,'C','INSERT ব্যর্থ হবে',0),(@q,'D','খালি স্ট্রিং',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'class_name VARCHAR(50) NOT NULL UNIQUE — এই কলামে কী করা যাবে না?', 'What is disallowed for this column?', 'class_name VARCHAR(50) NOT NULL UNIQUE',
'`NOT NULL` মানে খালি রাখা যাবে না, আর `UNIQUE` মানে একই `class_name` দুইবার থাকতে পারবে না — দুটো কনস্ট্রেইন্টই একসাথে প্রযোজ্য।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','খালি রাখা বা ডুপ্লিকেট ভ্যালু দেওয়া',1),(@q,'B','শুধু খালি রাখা',0),(@q,'C','শুধু ডুপ্লিকেট দেওয়া',0),(@q,'D','কোনো নিষেধ নেই',0);

-- ── Views & Set Operations ───────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_views, 'create-view', 'VIEW: সেভ করা কোয়েরি', 'Views: Saved Queries',
'একটা **VIEW** হলো একটা কোয়েরির নামকরণ করা "ভার্চুয়াল টেবিল" — জটিল JOIN বা ফিল্টার বারবার না লিখে, একবার VIEW বানিয়ে সেটাকেই সাধারণ টেবিলের মতো `SELECT` করা যায়। আসল ডেটা কোথাও ডুপ্লিকেট হয় না, প্রতিবার আসল কোয়েরিটাই আবার চলে।',
'CREATE VIEW top_students AS
SELECT name, marks FROM students WHERE marks >= 80;

SELECT * FROM top_students; -- just like querying a normal table',
'sql', 10, 0, 1, 0),

(@m_views, 'union-basics', 'UNION: দুটো রেজাল্ট এক করা', 'UNION: Combining Two Results',
'`UNION` দুটো `SELECT`-এর ফলাফল একসাথে জোড়া লাগায় (কলাম সংখ্যা ও টাইপ মিলতে হবে) এবং ডুপ্লিকেট রো নিজে থেকেই বাদ দেয়। ডুপ্লিকেট রাখতে চাইলে `UNION ALL` ব্যবহার করতে হয়, যা দ্রুতও।',
'SELECT name FROM students WHERE marks >= 90
UNION
SELECT name FROM students WHERE age < 18;
-- rows appearing in both conditions show up only once',
'sql', 10, 0, 2, 0),

(@m_views, 'union-all', 'UNION বনাম UNION ALL', 'UNION vs UNION ALL',
'`UNION` ডুপ্লিকেট বাদ দিতে গিয়ে পুরো ফলাফল সর্ট/তুলনা করে, যা বড় টেবিলে ধীর হতে পারে। ডুপ্লিকেট থাকলেও সমস্যা নেই এমন ক্ষেত্রে `UNION ALL` ব্যবহার করা উচিত — এটা শুধু জোড়া লাগায়, কোনো ডুপ্লিকেট-চেক করে না, তাই দ্রুত।',
'SELECT name FROM students WHERE class_id = 1
UNION ALL
SELECT name FROM students WHERE class_id = 2;
-- keeps every row, even if a name appears in both classes',
'sql', 10, 0, 3, 0),

(@m_views, 'views-capstone', 'ক্যাপস্টোন: VIEW দিয়ে রিপোর্ট সহজ করা', 'Capstone: Simplifying a Report with a View',
'ক্লাসের নামসহ প্রতিটা স্টুডেন্টের রেজাল্ট দেখানো একটা জটিল JOIN কোয়েরিকে VIEW বানিয়ে সহজ করে দেওয়া হচ্ছে, যাতে বারবার সেই লম্বা কোয়েরি লিখতে না হয়।',
'CREATE VIEW student_report AS
SELECT students.name, classes.class_name, students.marks
FROM students
INNER JOIN classes ON students.class_id = classes.id;

SELECT * FROM student_report WHERE marks >= 80;',
'sql', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_views AND slug='create-view';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_views AND slug='union-basics';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_views AND slug='union-all';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_views AND slug='views-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'SELECT * FROM top_students; — এটা আসলে কী করে?', 'What does this actually do?', 'CREATE VIEW top_students AS
SELECT name, marks FROM students WHERE marks >= 80;
SELECT * FROM top_students;',
'`top_students` কোনো আসল টেবিল নয় — এটা একটা VIEW, যা সংরক্ষিত কোয়েরির নাম মাত্র। `SELECT * FROM top_students` চালালে আসলে ভেতরের `SELECT name, marks FROM students WHERE marks >= 80` কোয়েরিটাই আবার চলে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ভেতরের সংরক্ষিত কোয়েরিটা আবার চালায়',1),(@q,'B','একটা নতুন ডুপ্লিকেট টেবিল তৈরি করে',0),(@q,'C','সব স্টুডেন্টের ডেটা মুছে ফেলে',0),(@q,'D','Error দেয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'একই নাম দুই শর্তেই মিললে UNION-এ কতবার দেখাবে?', 'How many times does a matching name appear with UNION?', 'SELECT name FROM students WHERE marks >= 90
UNION
SELECT name FROM students WHERE age < 18;',
'`UNION` (বিনা `ALL`) ডুপ্লিকেট রো নিজে থেকেই বাদ দেয় — কোনো নাম দুই শর্তেই মিললে ফলাফলে সেটা মাত্র *একবার* দেখাবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','দুইবার',0),(@q,'B','একবার',1),(@q,'C','কখনোই দেখাবে না',0),(@q,'D','Error হবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'UNION-এর বদলে UNION ALL ব্যবহারের সুবিধা কী?', 'What is the advantage of UNION ALL over UNION?', 'SELECT name FROM students WHERE class_id = 1
UNION ALL
SELECT name FROM students WHERE class_id = 2;',
'`UNION ALL` ডুপ্লিকেট-চেক না করেই সরাসরি রো জোড়া লাগায়, তাই `UNION`-এর চেয়ে দ্রুত — ডুপ্লিকেট থাকলেও সমস্যা না হলে এটাই ব্যবহার করা উচিত।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা দ্রুত, কারণ ডুপ্লিকেট-চেক করে না',1),(@q,'B','এটা স্বয়ংক্রিয়ভাবে সর্ট করে',0),(@q,'C','কোনো পার্থক্য নেই',0),(@q,'D','এটা কম রো রিটার্ন করে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'student_report VIEW ব্যবহারের সুবিধা কী?', 'What is the benefit of the student_report view?', 'CREATE VIEW student_report AS
SELECT students.name, classes.class_name, students.marks
FROM students INNER JOIN classes ON students.class_id = classes.id;',
'জটিল JOIN কোয়েরিটা একবার VIEW হিসেবে সংরক্ষণ করার পর, বারবার সেই লম্বা JOIN না লিখে শুধু `SELECT * FROM student_report ...` লিখলেই চলে — কোড ছোট ও পরিষ্কার থাকে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','বারবার জটিল JOIN লেখা লাগে না',1),(@q,'B','ডেটা দ্রুত সেভ হয়',0),(@q,'C','স্টুডেন্ট সংখ্যা বেড়ে যায়',0),(@q,'D','কোনো সুবিধা নেই',0);
