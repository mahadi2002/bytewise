-- Python track: 1 new OOP lesson (Polymorphism & Encapsulation — capstone
-- already renumbered to slot 5 by 023) + Iterators, Lambda & Comprehensions
-- (new module 10).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_py FROM languages WHERE slug = 'python3';
SELECT id INTO @m_oop  FROM modules WHERE language_id=@lang_py AND slug='oop';
SELECT id INTO @m_iter FROM modules WHERE language_id=@lang_py AND slug='iterators-lambda';

-- ── OOP expansion: Polymorphism & Encapsulation ─────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_oop, 'polymorphism-encapsulation-python', 'পলিমরফিজম ও এনক্যাপসুলেশন', 'Polymorphism & Encapsulation',
'**পলিমরফিজম** মানে ভিন্ন ভিন্ন ক্লাসের অবজেক্ট একই মেথড কল করলেও যার যার মতো আলাদা আচরণ করতে পারে — একই ইন্টারফেস, ভিন্ন বাস্তবায়ন। **এনক্যাপসুলেশন** মানে ডেটা লুকিয়ে রেখে শুধু মেথডের মাধ্যমে নিয়ন্ত্রিত অ্যাক্সেস দেওয়া — পাইথনে কনভেনশন হিসেবে নামের আগে `_` (protected) বা `__` (private) বসিয়ে বোঝানো হয়, কারণ পাইথনে সত্যিকারের অ্যাক্সেস-নিয়ন্ত্রণ নেই, শুধু "ইঙ্গিত"।',
'class Animal:
    def speak(self):
        return "Some sound"

class Dog(Animal):
    def speak(self):  # overrides — polymorphism
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"

for animal in [Dog(), Cat()]:
    print(animal.speak())  # Woof! then Meow! — same call, different result',
'python3', 10, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_oop AND slug='polymorphism-encapsulation-python';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'একই animal.speak() কল দুটো ভিন্ন আউটপুট দিচ্ছে কেন?', 'Why does animal.speak() give two different outputs?', 'for animal in [Dog(), Cat()]:
    print(animal.speak())',
'`Dog` আর `Cat` দুটোই `Animal`-কে ইনহেরিট করেছে এবং প্রত্যেকে নিজের মতো `speak()` ওভাররাইড করেছে — এটাই পলিমরফিজম: একই মেথড কল, কিন্তু অবজেক্টের আসল টাইপ অনুযায়ী ভিন্ন ভিন্ন ফলাফল।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা একটা বাগ',0),(@q,'B','পলিমরফিজম — প্রতিটা ক্লাস speak() নিজের মতো ওভাররাইড করেছে',1),(@q,'C','Cat আসলে Dog-এর সাবক্লাস',0),(@q,'D','পাইথন র‍্যান্ডমলি ফলাফল বেছে নেয়',0);

-- ── Iterators, Lambda & Comprehensions ───────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_iter, 'list-comprehensions', 'লিস্ট কম্প্রিহেনশন', 'List Comprehensions',
'একটা `for` লুপ দিয়ে নতুন লিস্ট বানানোর বদলে, **লিস্ট কম্প্রিহেনশন** দিয়ে এক লাইনেই একই কাজ করা যায় — এটা পাইথনের সবচেয়ে চেনা, idiomatic ফিচারগুলোর একটা। `[expression for item in iterable if condition]` — এই প্যাটার্নটাই মূল।',
'nums = [1, 2, 3, 4, 5]

# traditional way
squares = []
for n in nums:
    squares.append(n * n)

# list comprehension — same result, one line
squares = [n * n for n in nums]
print(squares)  # [1, 4, 9, 16, 25]

evens = [n for n in nums if n % 2 == 0]
print(evens)  # [2, 4]',
'python3', 10, 0, 1, 0),

(@m_iter, 'lambda-functions', 'Lambda: ছোট, নামহীন ফাংশন', 'Lambda: Small, Anonymous Functions',
'`lambda` দিয়ে এক লাইনে একটা ছোট, নামহীন ফাংশন লেখা যায় — `def` দিয়ে আলাদা ফাংশন ডিফাইন করার দরকার নেই। প্রায়ই `sorted()`, `filter()`, `map()`-এর মতো ফাংশনে "একবারই ব্যবহার হবে" এমন ছোট লজিক পাস করতে ব্যবহার হয়।',
'nums = [5, 2, 8, 1]

# a lambda that squares its argument
square = lambda x: x * x
print(square(4))  # 16

# sorting by a custom key using lambda
students = [("Rafi", 85), ("Nadia", 92)]
students.sort(key=lambda s: s[1], reverse=True)
print(students)  # [("Nadia", 92), ("Rafi", 85)]',
'python3', 10, 0, 2, 0),

(@m_iter, 'iterators-basics', 'ইটারেটর: iter() ও next()', 'Iterators: iter() & next()',
'একটা `for` লুপ ভেতরে ভেতরে যা করে তা হলো: `iter()` দিয়ে একটা **ইটারেটর** বানানো, তারপর বারবার `next()` কল করে একটা একটা ভ্যালু বের করা, যতক্ষণ না `StopIteration` ওঠে। এই মেকানিজম বোঝা দরকার কারণ কাস্টম ক্লাসকেও "লুপযোগ্য" বানানো যায় এভাবেই।',
'nums = [10, 20, 30]
it = iter(nums)

print(next(it))  # 10
print(next(it))  # 20
print(next(it))  # 30
# next(it) again would raise StopIteration',
'python3', 10, 0, 3, 0),

(@m_iter, 'iterators-capstone-python', 'ক্যাপস্টোন: কম্প্রিহেনশন ও lambda একসাথে', 'Capstone: Comprehensions & Lambda Together',
'একদল স্টুডেন্টের মধ্যে যাদের মার্কস ৮০-এর বেশি, তাদের নাম বের করে মার্কস অনুযায়ী সাজানো হচ্ছে — লিস্ট কম্প্রিহেনশন আর lambda একসাথে, বাস্তব ডেটা প্রসেসিংয়ে খুবই কমন একটা প্যাটার্ন।',
'students = [
    {"name": "Rafi", "marks": 85},
    {"name": "Nadia", "marks": 92},
    {"name": "Tanvir", "marks": 78},
]

top_names = [s["name"] for s in students if s["marks"] > 80]
top_names.sort(key=lambda name: name)  # alphabetical
print(top_names)  # ["Nadia", "Rafi"]',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_iter AND slug='list-comprehensions';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_iter AND slug='lambda-functions';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_iter AND slug='iterators-basics';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_iter AND slug='iterators-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, '[n for n in nums if n % 2 == 0] এর ফলাফল কী?', 'What does this comprehension give?', 'nums = [1, 2, 3, 4, 5]
[n for n in nums if n % 2 == 0]',
'`if n % 2 == 0` শর্তটা শুধু জোড় সংখ্যাগুলো রাখে — [1,2,3,4,5] থেকে জোড় হলো 2 আর 4, তাই ফলাফল [2, 4]।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','[1, 3, 5]',0),(@q,'B','[2, 4]',1),(@q,'C','[1, 2, 3, 4, 5]',0),(@q,'D','[]',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'square(4) এর ফলাফল কত হবে?', 'What is square(4)?', 'square = lambda x: x * x
square(4)',
'`lambda x: x * x` মানে একটা ফাংশন যা `x` নেয় আর `x * x` রিটার্ন করে — `square(4)` মানে `4 * 4 = 16`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','8',0),(@q,'B','16',1),(@q,'C','4',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'nums-এর সব ভ্যালু শেষ হওয়ার পর next(it) কল করলে কী হয়?', 'What happens calling next(it) after all values are exhausted?', 'nums = [10, 20, 30]
it = iter(nums)
next(it); next(it); next(it)
next(it)  # 4th call — what happens?',
'ইটারেটরের সব ভ্যালু একবার দেওয়া হয়ে গেলে, আরেকবার `next()` কল করলে পাইথন `StopIteration` এক্সেপশন raise করে — এটাই `for` লুপকে ভেতরে ভেতরে বলে দেয় কখন থামতে হবে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0 রিটার্ন করে',0),(@q,'B','StopIteration এক্সেপশন raise করে',1),(@q,'C','আবার 10 থেকে শুরু করে',0),(@q,'D','None রিটার্ন করে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'top_names এর ফাইনাল মান কী হবে?', 'What is the final top_names?', 'students = [
    {"name": "Rafi", "marks": 85},
    {"name": "Nadia", "marks": 92},
    {"name": "Tanvir", "marks": 78},
]
top_names = [s["name"] for s in students if s["marks"] > 80]
top_names.sort()',
'৮০-এর বেশি মার্কস আছে Rafi (85) আর Nadia (92)-এর — Tanvir (78) বাদ পড়ে। কম্প্রিহেনশনের পর ["Rafi", "Nadia"], তারপর `.sort()` বর্ণানুক্রমে সাজায়: ["Nadia", "Rafi"]।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','["Rafi", "Nadia", "Tanvir"]',0),(@q,'B','["Nadia", "Rafi"]',1),(@q,'C','["Tanvir"]',0),(@q,'D','[]',0);
