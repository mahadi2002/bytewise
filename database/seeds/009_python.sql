-- Python track: finish Basics (3 more) + all 5 remaining modules.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'python3';
SELECT id INTO @m_basics FROM modules WHERE language_id=@lang AND slug='basics';
SELECT id INTO @m_cf     FROM modules WHERE language_id=@lang AND slug='control-flow';
SELECT id INTO @m_fn     FROM modules WHERE language_id=@lang AND slug='functions';
SELECT id INTO @m_coll   FROM modules WHERE language_id=@lang AND slug='collections';
SELECT id INTO @m_str    FROM modules WHERE language_id=@lang AND slug='strings';
SELECT id INTO @m_oop    FROM modules WHERE language_id=@lang AND slug='oop';

-- ── Basics (lessons 2-4) ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_basics, 'input-python', 'ইনপুট নেওয়া: input()', 'Taking Input: input()',
'পাইথনে `input()` দিয়ে ইউজারের থেকে ইনপুট নেওয়া হয় — কিন্তু গুরুত্বপূর্ণ ব্যাপার, `input()` সবসময় একটা **স্ট্রিং** রিটার্ন করে, সংখ্যা নয়। সংখ্যা হিসেবে ব্যবহার করতে হলে `int()` বা `float()` দিয়ে কনভার্ট করতে হয়।',
'age = input("Enter your age: ")  # returns a string!
age = int(age)                    # convert to integer
print("You are", age, "years old.")',
'python3', 10, 0, 2, 0),

(@m_basics, 'operators-python', 'অপারেটর', 'Operators',
'পাইথনের গাণিতিক অপারেটর: `+ - * /` (`/` সবসময় ভাগফল ভাসমান বিন্দুতে দেয়, যেমন `7 / 2 = 3.5`), আর পূর্ণসংখ্যা ভাগের জন্য আলাদা অপারেটর `//` (floor division, `7 // 2 = 3`)। এটা C/Java-এর `/`-এর চেয়ে আলাদা আচরণ — পাইথনে দুটোই স্পষ্টভাবে আলাদা।',
'a, b = 7, 2
print(a / b)   # 3.5 (always float division)
print(a // b)  # 3   (floor/integer division)',
'python3', 10, 0, 3, 0),

(@m_basics, 'first-program-python', 'প্রথম ক্যালকুলেশন প্রোগ্রাম', 'Your First Calculation Program',
'ভেরিয়েবল ঘোষণা, `input()` দিয়ে ইনপুট নেওয়া (আর `float()`-এ কনভার্ট করা), ফর্মুলা ক্যালকুলেট করা, আর `print()` দিয়ে ফলাফল দেখানো — সব একসাথে।',
'weight = float(input())
height = float(input())
bmi = weight / (height * height)
print(bmi)',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_basics AND slug='input-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_basics AND slug='operators-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_basics AND slug='first-program-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'input() সবসময় কী টাইপ রিটার্ন করে?', 'What type does input() always return?', 'age = input("Enter your age: ")',
'`input()` ইউজার যাই টাইপ করুক না কেন, সবসময় একটা **স্ট্রিং** রিটার্ন করে। সংখ্যা হিসেবে ব্যবহার করতে (যেমন যোগ-বিয়োগ) `int()` বা `float()` দিয়ে কনভার্ট করা লাগে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','int',0),(@q,'B','str (স্ট্রিং)',1),(@q,'C','float',0),(@q,'D','ইনপুটের ধরন অনুযায়ী পাল্টায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'a / b এর আউটপুট কত হবে?', 'What does a / b print?', 'a, b = 7, 2
print(a / b)',
'পাইথনে `/` সবসময় ভাসমান বিন্দুর (float) ফলাফল দেয়, দুটো অপারেন্ড পূর্ণসংখ্যা হলেও — তাই `7 / 2 = 3.5`, C/Java-এর মতো `3` নয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','3.5',1),(@q,'C','4',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'input()-এর ফলাফলকে float()-এ কনভার্ট না করলে কী হতো?', 'What would happen without float() around input()?', 'weight = float(input())
height = float(input())
bmi = weight / (height * height)',
'কনভার্ট না করলে `weight` আর `height` স্ট্রিং হিসেবে থেকে যেত, আর স্ট্রিংয়ে `*` বা গাণিতিক অপারেশন করতে গেলে পাইথন `TypeError` দিত — সংখ্যা আর স্ট্রিং সরাসরি গুণ/ভাগ করা যায় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ঠিকভাবেই চলত',0),(@q,'B','TypeError হতো',1),(@q,'C','ফলাফল সবসময় 0 হতো',0),(@q,'D','প্রোগ্রাম নিজে থেকেই কনভার্ট করে নিত',0);

-- ── Control Flow ─────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_cf, 'if-else-python', 'শর্ত ও if-else', 'Conditions & If-Else',
'পাইথনে `if`/`elif`/`else` ব্যবহার হয় (অন্য ভাষার `else if`-এর বদলে `elif`)। সবচেয়ে বড় পার্থক্য: কোনো `{}` ব্র্যাকেট নেই — **ইন্ডেন্টেশন** (স্পেস) দিয়েই কোন কোড কোন ব্লকের ভেতরে সেটা বোঝানো হয়। ভুল ইন্ডেন্টেশন মানেই সিনট্যাক্স এরর।',
'marks = 65

if marks >= 80:
    print("Grade: A")
elif marks >= 60:
    print("Grade: B")
else:
    print("Grade: C")',
'python3', 10, 0, 1, 0),

(@m_cf, 'logical-operators-python', 'লজিক্যাল অপারেটর: and, or, not', 'Logical Operators: and, or, not',
'পাইথনে `&&`/`||`/`!`-এর বদলে সরাসরি ইংরেজি শব্দ ব্যবহার হয়: `and`, `or`, `not`। এগুলো পড়তেও প্রায় ইংরেজি বাক্যের মতোই লাগে।',
'age = 20
has_id = True

if age >= 18 and has_id:
    print("Entry allowed")
else:
    print("Entry denied")',
'python3', 10, 0, 2, 0),

(@m_cf, 'loops-python', 'লুপ: for ও while', 'Loops: for & while',
'পাইথনের `for` লুপ সাধারণত কোনো একটা সিকোয়েন্স (যেমন `range()`) নিয়ে চলে — C/Java-এর মতো `i = 0; i < 5; i++` লেখা লাগে না। `range(1, 6)` মানে `1` থেকে `5` পর্যন্ত (৬ অন্তর্ভুক্ত নয়)।',
'for i in range(1, 6):
    print(i, end=" ")
print()',
'python3', 10, 0, 3, 0),

(@m_cf, 'control-flow-capstone-python', 'ক্যাপস্টোন: FizzBuzz', 'Capstone: FizzBuzz',
'১ থেকে ১৫ পর্যন্ত সংখ্যা প্রিন্ট করো, ৩-এর গুণিতক হলে "Fizz", ৫-এর গুণিতক হলে "Buzz", দুটোরই গুণিতক হলে "FizzBuzz" — লুপ, শর্ত, আর `%` অপারেটর, সব একসাথে।',
'for i in range(1, 16):
    if i % 15 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_cf AND slug='if-else-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_cf AND slug='logical-operators-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_cf AND slug='loops-python';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_cf AND slug='control-flow-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'নিচের কোডের আউটপুট কী হবে?', 'What does this print?', 'marks = 65
if marks >= 80:
    print("A")
elif marks >= 60:
    print("B")
else:
    print("C")',
'৬৫, ৮০-এর কম কিন্তু ৬০-এর বেশি বা সমান, তাই `elif marks >= 60` সত্যি হয় এবং "B" প্রিন্ট হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','A',0),(@q,'B','B',1),(@q,'C','C',0),(@q,'D','SyntaxError',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'age >= 18 and has_id — এটা কখন সত্যি হবে?', 'When is age >= 18 and has_id true?', 'if age >= 18 and has_id:
    print("Entry allowed")',
'`and` মানে দুটো শর্তই সত্যি হতে হবে — বয়স ১৮+ এবং `has_id` অবশ্যই `True` হতে হবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু বয়স ১৮+ হলেই',0),(@q,'B','শুধু has_id সত্যি হলেই',0),(@q,'C','দুটো শর্তই সত্যি হলে',1),(@q,'D','কখনোই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'range(1, 6) দিয়ে লুপ কয়বার চলবে?', 'How many times does range(1, 6) loop?', 'for i in range(1, 6):
    print(i, end=" ")',
'`range(1, 6)` মানে `1` থেকে শুরু করে `6`-এর *আগ পর্যন্ত* — অর্থাৎ 1,2,3,4,5, মোট ৫ বার। শেষ সংখ্যাটা (৬) অন্তর্ভুক্ত হয় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','৫ বার',1),(@q,'B','৬ বার',0),(@q,'C','৪ বার',0),(@q,'D','ইনফিনিট',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'i = 15 হলে কী প্রিন্ট হবে?', 'What prints when i = 15?', 'if i % 15 == 0: print("FizzBuzz")
elif i % 3 == 0: print("Fizz")
elif i % 5 == 0: print("Buzz")',
'১৫, ৩ এবং ৫ দুটোরই গুণিতক — `i % 15 == 0` প্রথমেই সত্যি হয়, তাই "FizzBuzz" প্রিন্ট হয় (elif চেইনে বাকিগুলো আর চেক হয় না)।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Fizz',0),(@q,'B','Buzz',0),(@q,'C','FizzBuzz',1),(@q,'D','15',0);

-- ── Functions ────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_fn, 'function-basics-python', 'ফাংশন: def ও return', 'Functions: def & return',
'পাইথনে ফাংশন ঘোষণা হয় `def` কীওয়ার্ড দিয়ে — কোনো রিটার্ন টাইপ লেখার দরকার নেই (dynamic typing, ভেরিয়েবলের মতোই)। `return` না লিখলে ফাংশনটি অটোমেটিক্যালি `None` রিটার্ন করে।',
'def square(x):
    return x * x

result = square(5)
print(result)  # 25',
'python3', 10, 0, 1, 0),

(@m_fn, 'function-parameters-python', 'ডিফল্ট ও কীওয়ার্ড আর্গুমেন্ট', 'Default & Keyword Arguments',
'পাইথনে প্যারামিটারের একটা ডিফল্ট ভ্যালু দেওয়া যায় (`def greet(name="Guest")`), আর ফাংশন কল করার সময় প্যারামিটারের নাম উল্লেখ করেও ভ্যালু পাঠানো যায় (কীওয়ার্ড আর্গুমেন্ট), যেটা ক্রম নিয়ে চিন্তা কমায়।',
'def greet(name, greeting="Hello"):
    print(greeting + ", " + name + "!")

greet("Rafi")                    # Hello, Rafi!
greet("Nadia", greeting="Hi")    # Hi, Nadia!',
'python3', 10, 0, 2, 0),

(@m_fn, 'scope-python', 'স্কোপ: লোকাল ও গ্লোবাল', 'Scope: Local vs Global',
'ফাংশনের ভেতরে ঘোষণা করা ভেরিয়েবল সেই ফাংশনের বাইরে দেখা যায় না (লোকাল স্কোপ)। ফাংশনের ভেতর থেকে একটা গ্লোবাল ভেরিয়েবল *পরিবর্তন* করতে চাইলে `global` কীওয়ার্ড লিখতে হয় — নাহলে পাইথন ধরে নেয় আপনি একটা নতুন লোকাল ভেরিয়েবল বানাচ্ছেন।',
'counter = 0

def increment():
    global counter
    counter += 1

increment()
increment()
print(counter)  # 2',
'python3', 10, 0, 3, 0),

(@m_fn, 'recursion-python', 'ক্যাপস্টোন: রিকার্শন দিয়ে factorial', 'Capstone: Factorial with Recursion',
'একটা ফাংশন নিজেকেই কল করলে তাকে রিকার্শন বলে — অবশ্যই একটা base case থাকতে হবে, নাহলে ফাংশন অসীমবার কল হতে থাকবে (RecursionError)।',
'def factorial(n):
    if n <= 1:
        return 1  # base case
    return n * factorial(n - 1)

print(factorial(5))  # 120',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_fn AND slug='function-basics-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_fn AND slug='function-parameters-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_fn AND slug='scope-python';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_fn AND slug='recursion-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'square(5) কী রিটার্ন করবে?', 'What does square(5) return?', 'def square(x):
    return x * x
square(5)',
'`square(5)` কল হলে `x = 5`, ফাংশনটি `x * x = 25` রিটার্ন করে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','10',0),(@q,'C','25',1),(@q,'D','None',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'greet("Rafi") কল করলে কোন greeting ব্যবহার হবে?', 'What greeting does greet("Rafi") use?', 'def greet(name, greeting="Hello"):
    print(greeting + ", " + name + "!")
greet("Rafi")',
'`greeting`-এর জন্য কোনো ভ্যালু দেওয়া হয়নি, তাই এটা তার ডিফল্ট ভ্যালু `"Hello"` ব্যবহার করবে। ফলাফল: "Hello, Rafi!"।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','খালি স্ট্রিং',0),(@q,'B','"Hello" (ডিফল্ট)',1),(@q,'C','Error, greeting আবশ্যক',0),(@q,'D','"Rafi"',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'global counter না লিখলে increment() কী করত?', 'What if global counter were omitted?', 'def increment():
    global counter
    counter += 1',
'`global` ছাড়া, `counter += 1` লিখলে পাইথন ধরে নিত এটা একটা নতুন *লোকাল* ভেরিয়েবল — এবং `UnboundLocalError` দিত, কারণ `counter += 1` মানে আগে থেকে `counter`-এর একটা মান থাকা দরকার, যা লোকাল স্কোপে নেই।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ঠিকভাবেই গ্লোবাল counter বদলাত',0),(@q,'B','UnboundLocalError দিত',1),(@q,'C','counter সবসময় 0 থাকত',0),(@q,'D','কোনো পার্থক্য হতো না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'factorial(3) কল করলে কত রিটার্ন হবে?', 'What does factorial(3) return?', 'def factorial(n):
    if n <= 1: return 1
    return n * factorial(n - 1)
factorial(3)',
'`factorial(3) = 3 * factorial(2) = 3 * 2 * factorial(1) = 3 * 2 * 1 = 6`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','6',1),(@q,'C','9',0),(@q,'D','RecursionError',0);

-- ── Lists, Tuples & Dicts ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_coll, 'lists-python', 'লিস্ট: সাইজ-বদলযোগ্য কালেকশন', 'Lists: Resizable Collections',
'পাইথনের `list` C/Java-এর অ্যারের চেয়ে অনেক বেশি ফ্লেক্সিবল — সাইজ ফিক্সড নয়, `.append()` দিয়ে নতুন এলিমেন্ট যোগ করা যায়, আর যেকোনো টাইপ মিশিয়ে রাখা যায়। ইনডেক্স `0` থেকে শুরু, ঠিক অন্য ভাষার মতোই।',
'scores = [90, 85, 78]
scores.append(95)

print(scores)      # [90, 85, 78, 95]
print(scores[0])   # 90
print(len(scores)) # 4',
'python3', 10, 0, 1, 0),

(@m_coll, 'tuples-python', 'টাপল: পরিবর্তন-অযোগ্য লিস্ট', 'Tuples: Immutable Lists',
'`tuple` দেখতে লিস্টের মতোই (কিন্তু `()` দিয়ে), তবে একবার তৈরি হলে তার এলিমেন্ট বদলানো যায় না — **immutable**। যেসব ডেটা কখনো বদলাবে না বলে জানা আছে (যেমন একটা কো-অর্ডিনেট) সেখানে টাপল ব্যবহার করা ভালো অভ্যাস।',
'point = (3, 7)
print(point[0])  # 3

# point[0] = 5  # this would raise TypeError!',
'python3', 10, 0, 2, 0),

(@m_coll, 'dictionaries-python', 'ডিকশনারি: key-value পেয়ার', 'Dictionaries: Key-Value Pairs',
'`dict` key-value পেয়ার আকারে ডেটা রাখে — ইনডেক্স নাম্বারের বদলে নিজের পছন্দের "কী" দিয়ে ভ্যালু খুঁজে পাওয়া যায়। এটা অন্য অনেক ভাষার HashMap/অবজেক্টের সমতুল্য।',
'student = {"name": "Rafi", "age": 20}
print(student["name"])  # Rafi

student["age"] = 21  # update a value
print(student)',
'python3', 10, 0, 3, 0),

(@m_coll, 'collections-capstone-python', 'ক্যাপস্টোন: লিস্ট ও ডিকশনারি একসাথে', 'Capstone: Lists & Dicts Together',
'একটা লিস্টে একাধিক ডিকশনারি (প্রতিটা একটা স্টুডেন্টের রেকর্ড) রেখে, লুপ করে সবচেয়ে বেশি মার্কসপ্রাপ্ত স্টুডেন্ট বের করা হচ্ছে — বাস্তব প্রোগ্রামে এই প্যাটার্ন খুবই সাধারণ।',
'students = [
    {"name": "Rafi", "marks": 85},
    {"name": "Nadia", "marks": 92},
]

top = students[0]
for s in students:
    if s["marks"] > top["marks"]:
        top = s

print("Top scorer:", top["name"])  # Nadia',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_coll AND slug='lists-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_coll AND slug='tuples-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_coll AND slug='dictionaries-python';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_coll AND slug='collections-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'append(95) এর পর len(scores) কত হবে?', 'What is len(scores) after append(95)?', 'scores = [90, 85, 78]
scores.append(95)',
'শুরুতে লিস্টে ৩টি এলিমেন্ট ছিল। `.append(95)` শেষে নতুন একটা এলিমেন্ট যোগ করে, তাই `len()` হয়ে যায় ৪।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','4',1),(@q,'C','95',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'point[0] = 5 লিখলে কী হবে?', 'What happens with point[0] = 5?', 'point = (3, 7)
point[0] = 5',
'`tuple` immutable — একবার তৈরি হলে তার এলিমেন্ট পরিবর্তন করা যায় না। এই লাইনটি চালালে পাইথন `TypeError` দেবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ঠিকভাবেই বদলে যাবে',0),(@q,'B','TypeError দেবে',1),(@q,'C','নতুন একটা tuple তৈরি হবে',0),(@q,'D','কিছুই হবে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'student["name"] এর মান কত হবে?', 'What is student["name"]?', 'student = {"name": "Rafi", "age": 20}
print(student["name"])',
'`"name"` কী-এর সাথে `"Rafi"` ভ্যালুটা এক্সপ্লিসিটভাবে সেট করা আছে, তাই `student["name"]` হলো `"Rafi"`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',1),(@q,'B','20',0),(@q,'C','name',0),(@q,'D','KeyError',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'top["name"] শেষে কী হবে?', 'What is top["name"] at the end?', 'students = [
    {"name": "Rafi", "marks": 85},
    {"name": "Nadia", "marks": 92},
]
// loop finds the student with the highest marks',
'Rafi-র মার্কস ৮৫, Nadia-র ৯২ — Nadia-র মার্কস বেশি, তাই লুপ শেষে `top` হবে Nadia-র ডিকশনারি, এবং `top["name"]` হলো `"Nadia"`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','Nadia',1),(@q,'C','সবাই সমান',0),(@q,'D','KeyError',0);

-- ── String Handling ──────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_str, 'string-basics-python', 'স্ট্রিং ইনডেক্সিং ও স্লাইসিং', 'String Indexing & Slicing',
'পাইথনে স্ট্রিংও একটা সিকোয়েন্স — `s[0]` দিয়ে প্রথম অক্ষর, আর `s[start:end]` (**স্লাইসিং**) দিয়ে একটা অংশ বের করা যায়। স্ট্রিং **immutable** — একবার তৈরি হলে তার একটা অক্ষরও সরাসরি বদলানো যায় না।',
's = "Bytewise"
print(s[0])     # B
print(s[0:4])   # Byte
print(s[-1])    # e (last character, negative indexing)',
'python3', 10, 0, 1, 0),

(@m_str, 'string-methods-python', 'স্ট্রিং মেথড: split, join, strip', 'String Methods: split, join, strip',
'`.split()` দিয়ে স্ট্রিংকে টুকরো টুকরো করে একটা লিস্ট বানানো যায়, `.join()` দিয়ে উল্টোটা (লিস্ট জোড়া লাগানো), আর `.strip()` দিয়ে সামনে-পেছনের অতিরিক্ত স্পেস সরানো যায়।',
's = "  hello world  "
print(s.strip())              # "hello world"
words = s.strip().split(" ")  # ["hello", "world"]
print("-".join(words))        # "hello-world"',
'python3', 10, 0, 2, 0),

(@m_str, 'f-strings', 'ফরম্যাটেড স্ট্রিং: f-string', 'Formatted Strings: f-strings',
'`f"..."` (f-string) দিয়ে সরাসরি স্ট্রিংয়ের ভেতরে `{}` ব্যবহার করে ভেরিয়েবল বসানো যায় — `+` দিয়ে জোড়া লাগানোর চেয়ে অনেক পরিষ্কার আর পড়তে সহজ।',
'name = "Rafi"
age = 20
print(f"{name} is {age} years old")  # Rafi is 20 years old',
'python3', 10, 0, 3, 0),

(@m_str, 'strings-capstone-python', 'ক্যাপস্টোন: শব্দ গোনা', 'Capstone: Counting Words',
'একটা বাক্যকে স্পেস দিয়ে ভেঙে (`split()`) কয়টা শব্দ আছে সেটা বের করা হচ্ছে — স্ট্রিং মেথড আর লিস্টের `len()` একসাথে।',
'sentence = "Bytewise makes learning to code fun"
words = sentence.split(" ")
print(f"Word count: {len(words)}")  # Word count: 6',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_str AND slug='string-basics-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_str AND slug='string-methods-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_str AND slug='f-strings';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_str AND slug='strings-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 's[0:4] এর ফলাফল কী হবে?', 'What does s[0:4] give?', 's = "Bytewise"
print(s[0:4])',
'`s[0:4]` মানে ইনডেক্স `0` থেকে শুরু করে ইনডেক্স `4`-এর *আগ পর্যন্ত* (৪টি অক্ষর: 0,1,2,3) — "Bytewise"-এর প্রথম ৪টি অক্ষর হলো "Byte"।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Byte',1),(@q,'B','Bytewise',0),(@q,'C','wise',0),(@q,'D','B',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, '"-".join(["hello", "world"]) এর ফলাফল কী?', 'What does "-".join(["hello", "world"]) give?', '"-".join(["hello", "world"])',
'`.join()` লিস্টের এলিমেন্টগুলোকে দেওয়া সেপারেটর (এখানে `"-"`) দিয়ে জোড়া লাগায় — "hello" আর "world" মাঝে `-` বসিয়ে হয়ে যায় "hello-world"।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','hello world',0),(@q,'B','hello-world',1),(@q,'C','["hello", "world"]',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'f"{name} is {age}" এ {} এর ভেতরে কী বসে?', 'What goes inside {} in an f-string?', 'name = "Rafi"
age = 20
print(f"{name} is {age} years old")',
'f-string-এর `{}`-এর ভেতরে ভেরিয়েবল (বা যেকোনো পাইথন এক্সপ্রেশন) লিখলে, সেটার আসল মান স্ট্রিংয়ে বসে যায় — এখানে `{name}` মানে `"Rafi"`, `{age}` মানে `20`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','স্ট্রিং লিটারেল, হুবহু',0),(@q,'B','ভেরিয়েবলের আসল মান',1),(@q,'C','কমেন্ট',0),(@q,'D','কিছুই বসে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'sentence.split(" ") দিয়ে কয়টা শব্দ পাওয়া যাবে?', 'How many words does split(" ") give?', 'sentence = "Bytewise makes learning to code fun"
words = sentence.split(" ")',
'বাক্যটিতে স্পেস দিয়ে আলাদা করা ৬টি শব্দ আছে: Bytewise, makes, learning, to, code, fun। `split(" ")` প্রতিটি স্পেসে ভেঙে একটা লিস্ট বানায়, তাই `len(words) = 6`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','6',1),(@q,'C','1',0),(@q,'D','36 (অক্ষর সংখ্যা)',0);

-- ── OOP Basics ───────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_oop, 'classes-objects-python', 'ক্লাস, __init__ ও self', 'Classes, __init__ & self',
'পাইথনে ক্লাস `class` কীওয়ার্ড দিয়ে লেখা হয়। `__init__` হলো কনস্ট্রাক্টর — অবজেক্ট তৈরি হওয়ার সাথে সাথে চলে। প্রতিটা মেথডের প্রথম প্যারামিটার `self` — এটা "এই নির্দিষ্ট অবজেক্টটাকে" বোঝায়, কল করার সময় নিজে থেকেই পাস হয়ে যায়।',
'class Dog:
    def __init__(self, name):
        self.name = name

    def bark(self):
        print(self.name + " says Woof!")

d = Dog("Tommy")
d.bark()',
'python3', 10, 0, 1, 0),

(@m_oop, 'methods-python', 'ইনস্ট্যান্স মেথড', 'Instance Methods',
'ক্লাসের ভেতরের ফাংশনগুলোকে **মেথড** বলে, আর সেগুলো `self` দিয়ে সেই নির্দিষ্ট অবজেক্টের ডেটা অ্যাক্সেস করতে পারে। একই ক্লাস থেকে তৈরি প্রতিটা অবজেক্টের নিজস্ব `self.name` (বা অন্য যেকোনো ফিল্ড) আলাদা থাকে।',
'class Account:
    def __init__(self, balance):
        self.balance = balance

    def deposit(self, amount):
        if amount > 0:
            self.balance += amount

acc = Account(100)
acc.deposit(50)
print(acc.balance)  # 150',
'python3', 10, 0, 2, 0),

(@m_oop, 'inheritance-python', 'ইনহেরিটেন্স', 'Inheritance',
'একটা ক্লাস আরেকটা ক্লাসের সব বৈশিষ্ট্য "উত্তরাধিকার সূত্রে" পেতে পারে — প্যারেন্ট ক্লাসের নাম বন্ধনীতে লিখে (`class Cat(Animal):`)। `super().__init__()` দিয়ে প্যারেন্টের কনস্ট্রাক্টর কল করা যায়।',
'class Animal:
    def __init__(self, name):
        self.name = name
    def eat(self):
        print(self.name + " is eating")

class Cat(Animal):
    def __init__(self, name):
        super().__init__(name)

c = Cat("Whiskers")
c.eat()  # inherited from Animal',
'python3', 10, 0, 3, 0),

(@m_oop, 'oop-capstone-python', 'ক্যাপস্টোন: Rectangle ক্লাস', 'Capstone: A Rectangle Class',
'একটা ক্লাস, `__init__` কনস্ট্রাক্টর, আর একটা মেথড যা এরিয়া ক্যালকুলেট করে — আগের তিনটা লেসনের সবকিছু একসাথে।',
'class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

r = Rectangle(5, 3)
print(r.area())  # 15',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_oop AND slug='classes-objects-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_oop AND slug='methods-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_oop AND slug='inheritance-python';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_oop AND slug='oop-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, '__init__ মেথডটি কখন চলে?', 'When does __init__ run?', 'class Dog:
    def __init__(self, name):
        self.name = name
d = Dog("Tommy")',
'`__init__` হলো কনস্ট্রাক্টর — `Dog("Tommy")` লিখে নতুন অবজেক্ট তৈরি করার সাথে সাথেই এটা অটোমেটিক্যালি চলে এবং `self.name`-কে `"Tommy"` সেট করে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','যখন নতুন অবজেক্ট তৈরি হয়',1),(@q,'B','যখন bark() কল হয়',0),(@q,'C','প্রোগ্রাম শেষে',0),(@q,'D','ম্যানুয়ালি কল করলে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'acc.balance এর ফাইনাল মান কত হবে?', 'What is acc.balance at the end?', 'acc = Account(100)
acc.deposit(50)
print(acc.balance)',
'`Account(100)` দিয়ে `self.balance = 100` সেট হয়। `deposit(50)` কল হলে `self.balance += 50`, তাই ফাইনাল মান `150`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','100',0),(@q,'B','150',1),(@q,'C','50',0),(@q,'D','AttributeError',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'c.eat() কল করা যাচ্ছে কেন, যদিও Cat ক্লাসে eat() লেখাই হয়নি?', 'Why can c.eat() be called if Cat never defines eat()?', 'class Cat(Animal):
    def __init__(self, name):
        super().__init__(name)
c = Cat("Whiskers")
c.eat()',
'`Cat(Animal)` মানে `Cat`, `Animal`-কে ইনহেরিট করেছে — তাই `Animal`-এর সব মেথড (যেমন `eat()`) অটোমেটিক্যালি `Cat`-ও পেয়ে যায়, আলাদাভাবে আবার লিখতে হয় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা AttributeError দেবে',0),(@q,'B','Cat, Animal থেকে eat() ইনহেরিট করেছে',1),(@q,'C','পাইথন নিজে থেকে eat() লিখে দেয়',0),(@q,'D','এটা একটা ভুল কোড',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'r.area() এর ফলাফল কত হবে?', 'What does r.area() return?', 'r = Rectangle(5, 3)
r.area()  # self.width * self.height',
'কনস্ট্রাক্টর `self.width = 5`, `self.height = 3` সেট করে। `area()` রিটার্ন করে `5 * 3 = 15`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','8',0),(@q,'B','15',1),(@q,'C','53',0),(@q,'D','AttributeError',0);
