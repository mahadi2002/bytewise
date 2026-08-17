-- Adds new modules across all 8 tracks (filling genuine curriculum gaps
-- found via GfG/W3Schools research — Error/Exception Handling, File
-- Handling, and language-specific practical containers were entirely
-- missing) and renumbers 4 existing modules' capstone lessons to make room
-- for expansion lessons. See docs/CONTENT-PLAN.md "Curriculum expansion"
-- section for the full rationale per track.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_c    FROM languages WHERE slug = 'c';
SELECT id INTO @lang_cpp  FROM languages WHERE slug = 'cpp';
SELECT id INTO @lang_java FROM languages WHERE slug = 'java';
SELECT id INTO @lang_py   FROM languages WHERE slug = 'python3';
SELECT id INTO @lang_js   FROM languages WHERE slug = 'javascript';
SELECT id INTO @lang_sql  FROM languages WHERE slug = 'sql';
SELECT id INTO @lang_ds   FROM languages WHERE slug = 'data-structures';
SELECT id INTO @lang_algo FROM languages WHERE slug = 'algorithms';

INSERT INTO modules (language_id, slug, title_bn, title_en, sort_order, is_published) VALUES
(@lang_c,    'file-handling',   'ফাইল হ্যান্ডলিং',              'File Handling',              7, 1),
(@lang_c,    'error-handling',  'এরর হ্যান্ডলিং ও প্রিপ্রসেসর',   'Error Handling & Preprocessor', 8, 1),

(@lang_cpp,  'exceptions',      'এক্সেপশন হ্যান্ডলিং',           'Exception Handling',         7, 1),
(@lang_cpp,  'templates',       'টেমপ্লেট ও আরও STL',            'Templates & More STL',       8, 1),

(@lang_java, 'exceptions',      'এক্সেপশন হ্যান্ডলিং',           'Exception Handling',         7, 1),
(@lang_java, 'collections',     'কালেকশন ফ্রেমওয়ার্ক',           'Collections Framework',      8, 1),

(@lang_py,   'error-handling',  'এরর হ্যান্ডলিং',                'Error Handling',             7, 1),
(@lang_py,   'file-handling',   'ফাইল হ্যান্ডলিং',               'File Handling',              8, 1),
(@lang_py,   'modules-packages','মডিউল ও প্যাকেজ',               'Modules & Packages',         9, 1),

(@lang_js,   'error-handling',  'এরর হ্যান্ডলিং',                'Error Handling',             7, 1),
(@lang_js,   'classes',         'ES6 ক্লাস',                     'ES6 Classes',                8, 1),

(@lang_sql,  'schema-design',   'ডেটাবেস ডিজাইন ও কনস্ট্রেইন্ট',  'Database Design & Constraints', 7, 1),
(@lang_sql,  'views-set-ops',   'ভিউ ও সেট অপারেশন',             'Views & Set Operations',     8, 1),

(@lang_ds,   'heaps',           'হিপ ও প্রায়োরিটি কিউ',          'Heaps & Priority Queues',    7, 1),

(@lang_algo, 'greedy',          'গ্রিডি অ্যালগরিদম',             'Greedy Algorithms',          7, 1);

-- Make room for expansion lessons in 4 existing modules by pushing their
-- capstone lesson to a later sort_order (new lessons will be inserted
-- ahead of it by the per-track seed files that follow).
UPDATE lessons l JOIN modules m ON m.id = l.module_id
SET l.sort_order = 6
WHERE m.language_id = @lang_cpp AND m.slug = 'oop' AND l.slug = 'oop-capstone-cpp';

UPDATE lessons l JOIN modules m ON m.id = l.module_id
SET l.sort_order = 5
WHERE m.language_id = @lang_java AND m.slug = 'inheritance' AND l.slug = 'inheritance-capstone-java';

UPDATE lessons l JOIN modules m ON m.id = l.module_id
SET l.sort_order = 5
WHERE m.language_id = @lang_py AND m.slug = 'collections' AND l.slug = 'collections-capstone-python';

UPDATE lessons l JOIN modules m ON m.id = l.module_id
SET l.sort_order = 5
WHERE m.language_id = @lang_js AND m.slug = 'arrays' AND l.slug = 'arrays-capstone-js';
