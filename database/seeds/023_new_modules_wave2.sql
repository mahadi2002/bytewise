-- Wave 2 of curriculum depth: next tier of genuine gaps found by re-checking
-- W3Schools' full per-language chapter lists (GfG/W3Schools structural
-- research from CONTENT-PLAN.md, continued). See docs/CONTENT-PLAN.md.
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
(@lang_c,    'enums-unions',    'এনাম ও ইউনিয়ন',              'Enums & Unions',              9, 1),
(@lang_c,    'memory-mgmt',     'ডায়নামিক মেমোরি ম্যানেজমেন্ট', 'Dynamic Memory Management',   10, 1),

(@lang_cpp,  'enums-namespaces','এনাম ও নেমস্পেস',              'Enums & Namespaces',          9, 1),

(@lang_java, 'enum-generics',   'Enum ও Generics',              'Enum & Generics',             9, 1),

(@lang_py,   'iterators-lambda','ইটারেটর, Lambda ও কম্প্রিহেনশন', 'Iterators, Lambda & Comprehensions', 10, 1),

(@lang_js,   'dom-basics',      'DOM বেসিকস',                   'DOM Basics',                  9, 1),
(@lang_js,   'es6-features',    'ES6+ ফিচার',                   'ES6+ Features',               10, 1),

(@lang_sql,  'case-nulls-procs','CASE, NULL ফাংশন ও Stored Procedures', 'CASE, NULL Functions & Stored Procedures', 9, 1),

(@lang_ds,   'avl-trees',       'AVL ট্রি ও ব্যালান্সিং',        'AVL Trees & Balancing',       8, 1),

(@lang_algo, 'backtracking',    'ব্যাকট্র্যাকিং',                'Backtracking',                8, 1);

-- Make room in Python's OOP module for a Polymorphism & Encapsulation
-- lesson ahead of its capstone.
UPDATE lessons l JOIN modules m ON m.id = l.module_id
SET l.sort_order = 5
WHERE m.language_id = @lang_py AND m.slug = 'oop' AND l.slug = 'oop-capstone-python';
