-- Python track: 1 new Collections lesson (Sets — capstone already
-- renumbered to slot 5 by 015) + Error Handling + File Handling +
-- Modules & Packages (new modules 7-9).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_py FROM languages WHERE slug = 'python3';
SELECT id INTO @m_coll FROM modules WHERE language_id=@lang_py AND slug='collections';
SELECT id INTO @m_err  FROM modules WHERE language_id=@lang_py AND slug='error-handling';
SELECT id INTO @m_file FROM modules WHERE language_id=@lang_py AND slug='file-handling';
SELECT id INTO @m_mod  FROM modules WHERE language_id=@lang_py AND slug='modules-packages';

-- ── Collections expansion: sets ──────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_coll, 'sets-python', 'সেট: ইউনিক ভ্যালুর কালেকশন', 'Sets: A Collection of Unique Values',
'পাইথনের `set` শুধু ইউনিক ভ্যালু রাখে (ডুপ্লিকেট নিজে থেকেই বাদ পড়ে) এবং কোনো নির্দিষ্ট ক্রম গ্যারান্টি করে না। `{}` দিয়ে তৈরি হয় (খালি সেটের জন্য `set()`, কারণ খালি `{}` মানে ডিকশনারি)। দুটো লিস্টের কমন এলিমেন্ট বা ডুপ্লিকেট বাদ দিতে খুবই কাজের।',
'nums = [1, 2, 2, 3, 3, 3]
unique = set(nums)
print(unique)       # {1, 2, 3}
print(len(unique))  # 3',
'python3', 10, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_coll AND slug='sets-python';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'len(unique) এর মান কত হবে?', 'What is len(unique)?', 'nums = [1, 2, 2, 3, 3, 3]
unique = set(nums)
len(unique)',
'`set()` লিস্টের সব ডুপ্লিকেট বাদ দিয়ে ইউনিক ভ্যালু রাখে — {1, 2, 2, 3, 3, 3} থেকে হয় {1, 2, 3}, যার দৈর্ঘ্য `3`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','6',0),(@q,'B','3',1),(@q,'C','1',0),(@q,'D','Error',0);

-- ── Error Handling ───────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_err, 'try-except-python', 'try, except ও finally', 'try, except & finally',
'পাইথনে সমস্যা হলে একটা এক্সেপশন "raise" হয়, যা না ধরলে প্রোগ্রাম থেমে যায়। `try` ব্লকে ঝুঁকিপূর্ণ কোড রাখা হয়, `except` সেটা ধরে, আর `finally` ব্লক এক্সেপশন হোক বা না হোক সবসময় চলে।',
'try:
    result = 10 / 0
except ZeroDivisionError as e:
    print("Caught:", e)
finally:
    print("This always runs")',
'python3', 10, 0, 1, 0),

(@m_err, 'multiple-except', 'একাধিক except ও except Exception', 'Multiple except Blocks & except Exception',
'একটা `try`-এর পর একাধিক `except` ব্লক থাকতে পারে, প্রতিটা ভিন্ন এক্সেপশন টাইপের জন্য। `except Exception` দিয়ে প্রায় যেকোনো এক্সেপশন ধরা যায়, সাধারণত সবার শেষে একটা "catch-all" হিসেবে।',
'try:
    value = int("not a number")
except ValueError:
    print("Invalid number format")
except ZeroDivisionError:
    print("Cannot divide by zero")
except Exception as e:
    print("Unexpected error:", e)',
'python3', 10, 0, 2, 0),

(@m_err, 'raise-custom-exceptions', 'raise ও কাস্টম এক্সেপশন', 'raise & Custom Exceptions',
'`raise` দিয়ে নিজে থেকেই একটা এক্সেপশন তৈরি করা যায় — যখন কোনো শর্ত মেটে না তখন কলার-কে জানাতে। `Exception`-কে ইনহেরিট করে নিজের এক্সেপশন ক্লাসও বানানো যায়, নির্দিষ্ট এরর টাইপ বোঝাতে।',
'class InvalidAgeError(Exception):
    pass

def check_age(age):
    if age < 0:
        raise InvalidAgeError("Age cannot be negative")

try:
    check_age(-5)
except InvalidAgeError as e:
    print("Error:", e)',
'python3', 10, 0, 3, 0),

(@m_err, 'error-handling-capstone-python', 'ক্যাপস্টোন: নিরাপদ ইনপুট পার্সিং', 'Capstone: Safe Input Parsing',
'ইউজারের ইনপুট সংখ্যায় কনভার্ট করার সময় ভুল ফরম্যাট দিলে কী হয়, সেটা `try/except` দিয়ে সামলানো হচ্ছে — প্রোগ্রাম ক্র্যাশ না করিয়ে একটা পরিষ্কার মেসেজ দেখিয়ে।',
'def safe_divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        print("Cannot divide by zero")
        return None

print(safe_divide(10, 2))  # 5.0
print(safe_divide(10, 0))  # None, with a message',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_err AND slug='try-except-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_err AND slug='multiple-except';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_err AND slug='raise-custom-exceptions';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_err AND slug='error-handling-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'finally ব্লক কখন চলে?', 'When does finally run?', 'try: ...
except ...: ...
finally:
    print("This always runs")',
'`finally` ব্লক সবসময় চলে — এক্সেপশন হোক বা না হোক, `except` ধরুক বা না ধরুক। সাধারণত ফাইল বন্ধ করা বা রিসোর্স ক্লিনআপের জন্য ব্যবহার হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু এক্সেপশন হলে',0),(@q,'B','সবসময়',1),(@q,'C','কখনোই না',0),(@q,'D','শুধু except না মিললে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'int("not a number") কোন except ব্লক ধরবে?', 'Which except block catches int("not a number")?', 'try:
    value = int("not a number")
except ValueError:
    print("Invalid number format")
except ZeroDivisionError: ...',
'`int()`-এ একটা অ-সংখ্যা স্ট্রিং দিলে পাইথন `ValueError` raise করে — তাই প্রথম `except ValueError` ব্লকটাই ধরে ফেলে, "Invalid number format" প্রিন্ট হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','except ValueError',1),(@q,'B','except ZeroDivisionError',0),(@q,'C','কোনোটাই ধরবে না',0),(@q,'D','প্রোগ্রাম ক্র্যাশ করবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'check_age(-5) কল করলে কী হবে?', 'What happens calling check_age(-5)?', 'def check_age(age):
    if age < 0:
        raise InvalidAgeError("Age cannot be negative")
check_age(-5)',
'`-5 < 0` সত্যি হওয়ায় `raise InvalidAgeError(...)` চলে — এটা একটা কাস্টম এক্সেপশন তৈরি করে "ছুড়ে" দেয়, যা `try/except InvalidAgeError`-এ ধরা যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কিছুই হয় না',0),(@q,'B','InvalidAgeError raise হয়',1),(@q,'C','age স্বয়ংক্রিয়ভাবে 0 হয়ে যায়',0),(@q,'D','SyntaxError হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'safe_divide(10, 0) কী রিটার্ন করবে?', 'What does safe_divide(10, 0) return?', 'def safe_divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        print("Cannot divide by zero")
        return None',
'`10 / 0` `ZeroDivisionError` raise করে, তাই `except` ব্লক চলে — একটা মেসেজ প্রিন্ট করে `None` রিটার্ন করে, প্রোগ্রাম ক্র্যাশ করে না।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5.0',0),(@q,'B','None',1),(@q,'C','Error, প্রোগ্রাম ক্র্যাশ করে',0),(@q,'D','0',0);

-- ── File Handling ────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_file, 'open-with-python', 'ফাইল খোলা: open() ও with', 'Opening Files: open() & with',
'`open(filename, mode)` দিয়ে ফাইল খোলা হয় — `"r"` (read), `"w"` (write), `"a"` (append)। কিন্তু ম্যানুয়ালি `close()` ভুলে যাওয়া সহজ, তাই পাইথনে **`with` স্টেটমেন্ট** ব্যবহার করা ভালো অভ্যাস — ব্লক শেষ হলে ফাইল নিজে থেকেই বন্ধ হয়ে যায়, এমনকি এক্সেপশন হলেও।',
'with open("notes.txt", "w") as f:
    f.write("Hello, file!\n")
# file is automatically closed here, even if an error occurred',
'python3', 10, 0, 1, 0),

(@m_file, 'reading-python', 'ফাইল থেকে পড়া: read, readline, readlines', 'Reading Files: read, readline, readlines',
'`.read()` পুরো ফাইল একটা স্ট্রিং হিসেবে পড়ে, `.readline()` এক লাইন পড়ে, আর `.readlines()` প্রতিটা লাইনকে একটা লিস্টের এলিমেন্ট হিসেবে দেয়। একটা ফাইল সরাসরি `for line in f:` দিয়ে লুপ করাও যায় — মেমোরি-বান্ধব উপায়।',
'with open("notes.txt", "r") as f:
    for line in f:
        print(line.strip())  # strip() removes the trailing newline',
'python3', 10, 0, 2, 0),

(@m_file, 'writing-python', 'লেখা ও যোগ করা', 'Writing & Appending',
'`"w"` মোড ফাইলের পুরনো কনটেন্ট মুছে নতুন করে লেখে, `"a"` (append) মোড আগের কনটেন্টের শেষে যোগ করে। `.write()` একটা স্ট্রিং লেখে — নতুন লাইনের জন্য নিজে `\\n` যোগ করতে হয়, `print()`-এর মতো অটোমেটিক নয়।',
'with open("log.txt", "a") as f:
    f.write("New log entry\n")  # appends, does not overwrite',
'python3', 10, 0, 3, 0),

(@m_file, 'file-handling-capstone-python', 'ক্যাপস্টোন: ফাইলে লিখে আবার পড়া', 'Capstone: Write Then Read Back',
'একটা ফাইলে কয়েকটা সংখ্যা লিখে, তারপর সেই ফাইল আবার পড়ে যোগফল বের করা হচ্ছে — লেখা আর পড়া দুটো ধাপই `with` দিয়ে নিরাপদে।',
'with open("nums.txt", "w") as f:
    f.write("10\n20\n30\n")

total = 0
with open("nums.txt", "r") as f:
    for line in f:
        total += int(line.strip())

print(total)  # 60',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_file AND slug='open-with-python';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_file AND slug='reading-python';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_file AND slug='writing-python';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_file AND slug='file-handling-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'with ব্লক ব্যবহারের প্রধান সুবিধা কী?', 'What is the main benefit of using with?', 'with open("notes.txt", "w") as f:
    f.write("Hello, file!\n")',
'`with` ব্লক শেষ হওয়ার সাথে সাথে ফাইল স্বয়ংক্রিয়ভাবে বন্ধ (close) হয়ে যায় — এমনকি ব্লকের ভেতরে কোনো এক্সেপশন হলেও। ম্যানুয়ালি `close()` কল করার দরকার নেই, ভুলে যাওয়ার ঝুঁকিও থাকে না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ফাইল স্বয়ংক্রিয়ভাবে বন্ধ হয়ে যায়',1),(@q,'B','ফাইল দ্রুত পড়া যায়',0),(@q,'C','কোনো সুবিধা নেই',0),(@q,'D','ফাইল এনক্রিপ্ট হয়ে যায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'line.strip() কেন ব্যবহার করা হয়েছে?', 'Why is line.strip() used here?', 'for line in f:
    print(line.strip())',
'ফাইলের প্রতিটা লাইনের শেষে একটা নিউলাইন ক্যারেক্টার (`\n`) থাকে, যা `print()`-এর নিজস্ব নিউলাইনের সাথে মিলে অতিরিক্ত ফাঁকা লাইন তৈরি করত। `.strip()` সেই অতিরিক্ত হোয়াইটস্পেস/নিউলাইন সরিয়ে দেয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','লাইনের শুরু-শেষের হোয়াইটস্পেস/নিউলাইন সরাতে',1),(@q,'B','লাইনটা বড় হাতের করতে',0),(@q,'C','লাইনটা সংখ্যায় রূপান্তর করতে',0),(@q,'D','কোনো কারণ নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, '"a" মোডে লিখলে পুরনো কনটেন্টের কী হবে?', 'What happens to old content in "a" mode?', 'with open("log.txt", "a") as f:
    f.write("New log entry\n")',
'`"a"` (append) মোড পুরনো কনটেন্ট অক্ষত রেখে তার *শেষে* নতুন লেখা যোগ করে — `"w"`-এর মতো মুছে ফেলে না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','মুছে যায়',0),(@q,'B','অক্ষত থাকে, নতুন লেখা শেষে যোগ হয়',1),(@q,'C','ফাইলটাই ডিলিট হয়',0),(@q,'D','Error হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'total-এর ফাইনাল মান কত হবে?', 'What is the final value of total?', 'with open("nums.txt", "w") as f:
    f.write("10\n20\n30\n")
total = 0
with open("nums.txt", "r") as f:
    for line in f:
        total += int(line.strip())',
'ফাইলে "10", "20", "30" — এই তিনটা লাইন লেখা হয়েছিল। পড়ার সময় প্রতিটা লাইনকে `int()`-এ কনভার্ট করে `total`-এ যোগ করা হয়: `10+20+30 = 60`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','30',0),(@q,'B','60',1),(@q,'C','"102030"',0),(@q,'D','0',0);

-- ── Modules & Packages ───────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_mod, 'import-basics', 'import ও বিল্ট-ইন মডিউল', 'import & Built-in Modules',
'একটা **মডিউল** হলো একটা `.py` ফাইল, যাতে রেডিমেড ফাংশন/ক্লাস থাকে। `import` দিয়ে সেগুলো নিজের কোডে ব্যবহার করা যায় — যেমন `math` মডিউলে `sqrt()`, `pi` ইত্যাদি আছে, প্রতিটা নিজে লিখতে হয় না।',
'import math

print(math.sqrt(16))  # 4.0
print(math.pi)         # 3.14159...',
'python3', 10, 0, 1, 0),

(@m_mod, 'from-import-as', 'from...import ও as দিয়ে alias', 'from...import & Aliasing with as',
'`from module import name` দিয়ে পুরো মডিউলের বদলে শুধু নির্দিষ্ট জিনিস ইম্পোর্ট করা যায় (`math.` বারবার লেখা লাগে না)। `as` দিয়ে একটা মডিউল বা ফাংশনকে ছোট নাম (alias) দেওয়া যায় — যেমন `import pandas as pd` খুবই কমন কনভেনশন।',
'from math import sqrt, pi

print(sqrt(25))  # 5.0, no "math." prefix needed
print(pi)',
'python3', 10, 0, 2, 0),

(@m_mod, 'own-modules', 'নিজের মডিউল বানানো', 'Creating Your Own Module',
'যেকোনো `.py` ফাইল নিজেই একটা মডিউল — অন্য ফাইল থেকে সেটার নাম (এক্সটেনশন ছাড়া) দিয়ে `import` করা যায়। বড় প্রোগ্রামকে একাধিক ফাইলে ভাগ করে সংগঠিত রাখতে এটাই ভিত্তি।',
'# in helpers.py:
def greet(name):
    return "Hello, " + name

# in main.py:
import helpers
print(helpers.greet("Rafi"))  # Hello, Rafi',
'python3', 10, 0, 3, 0),

(@m_mod, 'modules-capstone-python', 'ক্যাপস্টোন: random মডিউল দিয়ে ছোট গেম', 'Capstone: A Tiny Game with the random Module',
'বিল্ট-ইন `random` মডিউল ব্যবহার করে একটা এলোমেলো সংখ্যা তৈরি করে একটা সাধারণ গেসিং-গেমের ভিত্তি — বাস্তব মডিউল ব্যবহারের একটা উদাহরণ।',
'import random

secret = random.randint(1, 10)
guess = 7

if guess == secret:
    print("Correct!")
else:
    print("Try again. The number was", secret)',
'python3', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_mod AND slug='import-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_mod AND slug='from-import-as';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_mod AND slug='own-modules';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_mod AND slug='modules-capstone-python';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'math.sqrt(16) এর মান কত হবে?', 'What is math.sqrt(16)?', 'import math
math.sqrt(16)',
'`math.sqrt()` বর্গমূল বের করে — `16`-এর বর্গমূল `4.0` (ফলাফল float হয়, `4` int নয়)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','4.0',1),(@q,'B','16',0),(@q,'C','256',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'from math import sqrt এর পর sqrt(25) লিখতে math. প্রিফিক্স লাগে কেন না?', 'Why no math. prefix needed after from math import sqrt?', 'from math import sqrt
sqrt(25)',
'`from module import name` দিয়ে `sqrt`-কে সরাসরি বর্তমান ফাইলের নেমস্পেসে নিয়ে আসা হয় — তাই এটাকে সরাসরি `sqrt(25)` লেখা যায়, `import math` করলে যেমন `math.sqrt(25)` লিখতে হতো তা লাগে না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','from...import নির্দিষ্ট নামটা সরাসরি নেমস্পেসে আনে',1),(@q,'B','পাইথন স্বয়ংক্রিয়ভাবে prefix বাদ দেয়',0),(@q,'C','এটা আসলে ভুল, prefix লাগবেই',0),(@q,'D','sqrt একটা বিল্ট-ইন কিওয়ার্ড',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'helpers.greet("Rafi") কল করতে main.py-তে কী দরকার?', 'What does main.py need to call helpers.greet("Rafi")?', '# in main.py:
import helpers
helpers.greet("Rafi")',
'`helpers.py` ফাইলটাকে `import helpers` দিয়ে একটা মডিউল হিসেবে আনতে হবে, তারপর তার ভেতরের `greet` ফাংশন `helpers.greet(...)` লিখে অ্যাক্সেস করা যায় — ঠিক বিল্ট-ইন মডিউলের মতোই।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','import helpers লিখতে হবে',1),(@q,'B','কিছুই লাগবে না, স্বয়ংক্রিয়ভাবে পাওয়া যায়',0),(@q,'C','helpers.py ফাইলটা মুছে ফেলতে হবে',0),(@q,'D','দুটো ফাইল একসাথে করতে হবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'random.randint(1, 10) কী রিটার্ন করে?', 'What does random.randint(1, 10) return?', 'secret = random.randint(1, 10)',
'`random.randint(1, 10)` ১ থেকে ১০-এর মধ্যে (দুই প্রান্তসহ) যেকোনো একটা এলোমেলো পূর্ণসংখ্যা রিটার্ন করে — প্রতিবার চালালে ভিন্ন হতে পারে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','১ থেকে ১০-এর মধ্যে একটা র‍্যান্ডম পূর্ণসংখ্যা',1),(@q,'B','সবসময় ঠিক 10',0),(@q,'C','একটা দশমিক সংখ্যা',0),(@q,'D','একটা স্ট্রিং',0);
