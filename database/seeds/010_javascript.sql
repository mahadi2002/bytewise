-- JavaScript track: finish Basics (3 more) + all 5 remaining modules.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'javascript';
SELECT id INTO @m_basics FROM modules WHERE language_id=@lang AND slug='basics';
SELECT id INTO @m_fn     FROM modules WHERE language_id=@lang AND slug='functions';
SELECT id INTO @m_arr    FROM modules WHERE language_id=@lang AND slug='arrays';
SELECT id INTO @m_obj    FROM modules WHERE language_id=@lang AND slug='objects';
SELECT id INTO @m_async  FROM modules WHERE language_id=@lang AND slug='async-js';
SELECT id INTO @m_react  FROM modules WHERE language_id=@lang AND slug='react-basics';

-- ── Basics (lessons 2-4) ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_basics, 'data-types-js', 'ডেটা টাইপ ও typeof', 'Data Types & typeof',
'জাভাস্ক্রিপ্ট **dynamically typed** — কোনো টাইপ লেখা লাগে না, রানটাইমে ভ্যালু থেকে টাইপ ঠিক হয়। `typeof` অপারেটর দিয়ে কোনো ভ্যালুর টাইপ চেক করা যায়। মূল প্রিমিটিভ টাইপ: `number`, `string`, `boolean`, `undefined`।',
'let age = 20;
let name = "Rafi";
let isStudent = true;

console.log(typeof age);       // "number"
console.log(typeof name);      // "string"
console.log(typeof isStudent); // "boolean"',
'javascript', 10, 0, 2, 0),

(@m_basics, 'operators-js', 'অপারেটর: == বনাম ===', 'Operators: == vs ===',
'জাভাস্ক্রিপ্টে গাণিতিক অপারেটর (`+ - * / %`) সাধারণ, কিন্তু তুলনায় সাবধান থাকতে হয়: `==` তুলনার আগে টাইপ কনভার্ট করার চেষ্টা করে (যেমন `"5" == 5` → `true`), যা প্রায়ই অপ্রত্যাশিত ফলাফল দেয়। `===` টাইপ *ও* ভ্যালু দুটোই মিলিয়ে দেখে — তাই সবসময় `===` ব্যবহার করাই নিরাপদ অভ্যাস।',
'console.log("5" == 5);   // true  (type coercion — avoid relying on this)
console.log("5" === 5);  // false (different types: string vs number)
console.log(5 === 5);    // true',
'javascript', 10, 0, 3, 0),

(@m_basics, 'first-program-js', 'প্রথম ক্যালকুলেশন প্রোগ্রাম', 'Your First Calculation Program',
'ভেরিয়েবল ঘোষণা, একটা ফর্মুলা ক্যালকুলেট করা, আর `console.log()` দিয়ে ফলাফল দেখানো — সব একসাথে।',
'let weight = 70;
let height = 1.75;
let bmi = weight / (height * height);

console.log(bmi.toFixed(2)); // 22.86',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_basics AND slug='data-types-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_basics AND slug='operators-js';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_basics AND slug='first-program-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'typeof age এর ফলাফল কী হবে?', 'What does typeof age give?', 'let age = 20;
console.log(typeof age);',
'`age`-এর ভ্যালু `20`, একটা সংখ্যা — তাই `typeof age` রিটার্ন করে `"number"` (স্ট্রিং হিসেবে টাইপের নাম)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','"number"',1),(@q,'B','"int"',0),(@q,'C','20',0),(@q,'D','"string"',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, '"5" === 5 এর ফলাফল কী হবে?', 'What does "5" === 5 give?', 'console.log("5" === 5);',
'`===` টাইপ *ও* ভ্যালু দুটোই মিলিয়ে দেখে — `"5"` একটা স্ট্রিং, `5` একটা সংখ্যা, টাইপ আলাদা হওয়ায় ফলাফল `false`। (`==` হলে `true` হতো, কারণ সেটা টাইপ কনভার্ট করার চেষ্টা করে।)', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','true',0),(@q,'B','false',1),(@q,'C','"5"',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'bmi.toFixed(2) কী করে?', 'What does bmi.toFixed(2) do?', 'let bmi = weight / (height * height);
console.log(bmi.toFixed(2));',
'`.toFixed(2)` সংখ্যাটিকে ঠিক ২ ঘর দশমিক পর্যন্ত রাউন্ড করে একটা স্ট্রিং হিসেবে রিটার্ন করে — দশমিকের পর অতিরিক্ত অঙ্ক ছাঁটাই করার জন্য এটা খুবই কমন একটা মেথড।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সংখ্যাটাকে পূর্ণসংখ্যায় রূপান্তর করে',0),(@q,'B','ঠিক ২ ঘর দশমিক পর্যন্ত রাউন্ড করে',1),(@q,'C','সংখ্যাটাকে ২ দিয়ে গুণ করে',0),(@q,'D','কিছুই করে না',0);

-- ── Functions ────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_fn, 'function-basics-js', 'ফাংশন ঘোষণা', 'Declaring Functions',
'জাভাস্ক্রিপ্টে ফাংশন `function` কীওয়ার্ড দিয়ে ঘোষণা করা যায়। রিটার্ন টাইপ লেখা লাগে না (dynamic typing)। `return` না লিখলে ফাংশনটি `undefined` রিটার্ন করে।',
'function square(x) {
    return x * x;
}

console.log(square(5)); // 25',
'javascript', 10, 0, 1, 0),

(@m_fn, 'arrow-functions', 'অ্যারো ফাংশন', 'Arrow Functions',
'ES6-এ একটা ছোট সিনট্যাক্স যোগ হয়েছে: **অ্যারো ফাংশন** (`=>`)। ছোট, এক-লাইনের ফাংশনের জন্য এটা অনেক জনপ্রিয় — বিশেষ করে `map()`/`filter()`-এর মতো জায়গায়, যা পরের মডিউলে দেখা যাবে।',
'const square = (x) => x * x; // same as function(x) { return x * x; }

console.log(square(5)); // 25',
'javascript', 10, 0, 2, 0),

(@m_fn, 'function-parameters-js', 'ডিফল্ট প্যারামিটার', 'Default Parameters',
'ES6 থেকে প্যারামিটারের ডিফল্ট ভ্যালু সরাসরি লেখা যায় — কল করার সময় সেই আর্গুমেন্ট না দিলে ডিফল্ট ভ্যালুটাই ব্যবহার হয়।',
'function greet(name, greeting = "Hello") {
    console.log(greeting + ", " + name + "!");
}

greet("Rafi");           // Hello, Rafi!
greet("Nadia", "Hi");    // Hi, Nadia!',
'javascript', 10, 0, 3, 0),

(@m_fn, 'functions-capstone-js', 'ক্যাপস্টোন: ছোট ক্যালকুলেটর', 'Capstone: A Small Calculator',
'একাধিক অ্যারো ফাংশন মিলিয়ে একটা ছোট ক্যালকুলেটর — যোগ আর বিয়োগের জন্য আলাদা ফাংশন।',
'const add = (a, b) => a + b;
const subtract = (a, b) => a - b;

console.log(add(10, 5));      // 15
console.log(subtract(10, 5)); // 5',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_fn AND slug='function-basics-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_fn AND slug='arrow-functions';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_fn AND slug='function-parameters-js';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_fn AND slug='functions-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'square(5) কী রিটার্ন করবে?', 'What does square(5) return?', 'function square(x) { return x * x; }
square(5);',
'`square(5)` কল হলে `x = 5`, ফাংশনটি `x * x = 25` রিটার্ন করে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','10',0),(@q,'C','25',1),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'নিচের অ্যারো ফাংশনটি সাধারণ কোন ফাংশনের সমতুল্য?', 'What is this arrow function equivalent to?', 'const square = (x) => x * x;',
'`(x) => x * x` হলো `function(x) { return x * x; }`-এর শর্টহ্যান্ড — একটা এক্সপ্রেশনের অ্যারো ফাংশনে `return` এবং `{}` লেখার দরকার নেই, ফলাফলটাই অটোমেটিক্যালি রিটার্ন হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','function(x) { return x * x; }',1),(@q,'B','function square() { }',0),(@q,'C','একটা ভেরিয়েবল, ফাংশন নয়',0),(@q,'D','x-কে ২ দিয়ে গুণ করা',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'greet("Rafi") কল করলে কোন greeting ব্যবহার হবে?', 'What greeting does greet("Rafi") use?', 'function greet(name, greeting = "Hello") { ... }
greet("Rafi");',
'`greeting`-এর জন্য কোনো আর্গুমেন্ট দেওয়া হয়নি, তাই সেটা তার ডিফল্ট ভ্যালু `"Hello"` নেবে। ফলাফল: "Hello, Rafi!"।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','undefined',0),(@q,'B','"Hello" (ডিফল্ট)',1),(@q,'C','Error, greeting আবশ্যক',0),(@q,'D','"Rafi"',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'subtract(10, 5) কী রিটার্ন করবে?', 'What does subtract(10, 5) return?', 'const subtract = (a, b) => a - b;
subtract(10, 5);',
'`a = 10`, `b = 5`, ফাংশনটি `a - b = 10 - 5 = 5` রিটার্ন করে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','15',0),(@q,'B','5',1),(@q,'C','50',0),(@q,'D','-5',0);

-- ── Arrays ───────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_arr, 'arrays-js', 'অ্যারে: তৈরি করা ও অ্যাক্সেস', 'Arrays: Create & Access',
'জাভাস্ক্রিপ্টের অ্যারে `[]` দিয়ে তৈরি হয়, সাইজ ফিক্সড নয় — দরকারমতো বড়-ছোট হতে পারে। ইনডেক্স `0` থেকে শুরু, আর `.length` দিয়ে সাইজ পাওয়া যায় (একটা প্রপার্টি, ফাংশন নয়)।',
'let scores = [90, 85, 78];
scores.push(95); // adds to the end

console.log(scores.length); // 4
console.log(scores[0]);     // 90',
'javascript', 10, 0, 1, 0),

(@m_arr, 'array-methods-js', 'অ্যারে মেথড: map ও filter', 'Array Methods: map & filter',
'`.map()` প্রতিটা এলিমেন্টে একটা ফাংশন চালিয়ে একটা *নতুন* অ্যারে বানায় (আসলটা পরিবর্তন করে না), আর `.filter()` শর্ত মেলা এলিমেন্টগুলো নিয়ে একটা নতুন অ্যারে বানায়। দুটোই ফাংশনাল-স্টাইল কোডের ভিত্তি।',
'let nums = [1, 2, 3, 4, 5];

let doubled = nums.map(n => n * 2);       // [2, 4, 6, 8, 10]
let evens = nums.filter(n => n % 2 === 0); // [2, 4]

console.log(doubled);
console.log(evens);',
'javascript', 10, 0, 2, 0),

(@m_arr, 'loops-js', 'অ্যারে লুপ করা: for...of', 'Looping Arrays: for...of',
'`for...of` দিয়ে একটা অ্যারের প্রতিটা এলিমেন্ট সরাসরি লুপ করা যায় — ইনডেক্স ম্যানুয়ালি ম্যানেজ করতে হয় না, C-স্টাইল `for (let i = 0; ...)`-এর চেয়ে অনেক পরিষ্কার।',
'let fruits = ["apple", "banana", "mango"];

for (let fruit of fruits) {
    console.log(fruit);
}',
'javascript', 10, 0, 3, 0),

(@m_arr, 'arrays-capstone-js', 'ক্যাপস্টোন: সবচেয়ে বড় ভ্যালু খুঁজে বের করা', 'Capstone: Finding the Max Value',
'একটা অ্যারে `for...of` দিয়ে লুপ করে সবচেয়ে বড় ভ্যালুটা বের করা হচ্ছে — একটা "রানিং" ভেরিয়েবলে সবচেয়ে বড় ভ্যালু ট্র্যাক রেখে।',
'let nums = [12, 45, 7, 89, 34];
let maxVal = nums[0];

for (let n of nums) {
    if (n > maxVal) {
        maxVal = n;
    }
}
console.log("Max:", maxVal); // 89',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_arr AND slug='arrays-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_arr AND slug='array-methods-js';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_arr AND slug='loops-js';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_arr AND slug='arrays-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'push(95) এর পর scores.length কত হবে?', 'What is scores.length after push(95)?', 'let scores = [90, 85, 78];
scores.push(95);',
'শুরুতে অ্যারেতে ৩টা এলিমেন্ট ছিল। `.push(95)` শেষে নতুন একটা এলিমেন্ট যোগ করে, তাই `.length` হয়ে যায় ৪।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','4',1),(@q,'C','95',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'nums.map(n => n * 2) এর ফলাফল কী?', 'What does nums.map(n => n * 2) give?', 'let nums = [1, 2, 3];
nums.map(n => n * 2);',
'`.map()` প্রতিটা এলিমেন্টে ফাংশনটা চালিয়ে একটা নতুন অ্যারে বানায় — `1*2=2, 2*2=4, 3*2=6` — ফলাফল `[2, 4, 6]`। আসল `nums` অপরিবর্তিত থাকে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','[1, 2, 3]',0),(@q,'B','[2, 4, 6]',1),(@q,'C','6',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'for (let fruit of fruits) — এখানে fruit কী বোঝায়?', 'What does fruit represent here?', 'let fruits = ["apple", "banana"];
for (let fruit of fruits) { console.log(fruit); }',
'`for...of`-এ `fruit` প্রতি ধাপে অ্যারের একেকটা এলিমেন্টের মান ধারণ করে — প্রথমে "apple", তারপর "banana"। কোনো ইনডেক্স ম্যানুয়ালি ম্যানেজ করা লাগে না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটা ইনডেক্স (0, 1...)',0),(@q,'B','প্রতি ধাপে অ্যারের একেকটা এলিমেন্টের মান',1),(@q,'C','পুরো অ্যারেটা',0),(@q,'D','অ্যারের সাইজ',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'নিচের কোডে maxVal-এর ফাইনাল মান কত হবে?', 'What is the final maxVal?', 'let nums = [12, 45, 7, 89, 34];
// loop tracks the largest value seen so far',
'অ্যারেতে সবচেয়ে বড় ভ্যালু `89`। লুপটি প্রতিটা এলিমেন্ট চেক করে `maxVal`-এর চেয়ে বড় হলে আপডেট করে, তাই লুপ শেষে `maxVal = 89`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','12',0),(@q,'B','34',0),(@q,'C','89',1),(@q,'D','45',0);

-- ── Objects ──────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_obj, 'objects-basics-js', 'অবজেক্ট: key-value পেয়ার', 'Objects: Key-Value Pairs',
'জাভাস্ক্রিপ্টের অবজেক্ট `{}` দিয়ে key-value পেয়ার আকারে ডেটা রাখে। `.` (ডট) অথবা `[]` (ব্র্যাকেট) দিয়ে অ্যাক্সেস করা যায় — ব্র্যাকেট নোটেশন কাজে লাগে যখন key-টা কোনো ভেরিয়েবলে রাখা থাকে।',
'let student = { name: "Rafi", age: 20 };

console.log(student.name);     // dot notation: Rafi
console.log(student["age"]);   // bracket notation: 20',
'javascript', 10, 0, 1, 0),

(@m_obj, 'objects-methods', 'অবজেক্টের মেথড ও this', 'Object Methods & this',
'অবজেক্টের ভেতরে ফাংশনও রাখা যায় — তাকে **মেথড** বলে। মেথডের ভেতরে `this` দিয়ে সেই অবজেক্টটাকেই বোঝানো হয় (যার উপর মেথডটা কল হয়েছে)।',
'let dog = {
    name: "Tommy",
    bark: function () {
        console.log(this.name + " says Woof!");
    }
};

dog.bark(); // Tommy says Woof!',
'javascript', 10, 0, 2, 0),

(@m_obj, 'array-of-objects', 'অবজেক্টের অ্যারে', 'Arrays of Objects',
'একই আকারের একাধিক অবজেক্ট একটা অ্যারেতে রাখা খুবই সাধারণ প্যাটার্ন — যেমন একাধিক স্টুডেন্টের রেকর্ড। `for...of` দিয়ে লুপ করে প্রতিটা অবজেক্টের ফিল্ড অ্যাক্সেস করা যায়।',
'let students = [
    { name: "Rafi", marks: 85 },
    { name: "Nadia", marks: 92 },
];

for (let s of students) {
    console.log(s.name + ": " + s.marks);
}',
'javascript', 10, 0, 3, 0),

(@m_obj, 'objects-capstone-js', 'ক্যাপস্টোন: সবচেয়ে বেশি মার্কস কার', 'Capstone: Finding the Top Scorer',
'একটা অবজেক্টের অ্যারে লুপ করে কে সবচেয়ে বেশি মার্কস পেয়েছে সেটা বের করা হচ্ছে — অবজেক্ট আর অ্যারে একসাথে ব্যবহার করার ক্লাসিক প্যাটার্ন।',
'let students = [
    { name: "Rafi", marks: 85 },
    { name: "Nadia", marks: 92 },
    { name: "Tanvir", marks: 78 },
];

let top = students[0];
for (let s of students) {
    if (s.marks > top.marks) {
        top = s;
    }
}
console.log("Top scorer:", top.name); // Nadia',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_obj AND slug='objects-basics-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_obj AND slug='objects-methods';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_obj AND slug='array-of-objects';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_obj AND slug='objects-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'student["age"] এর মান কত হবে?', 'What is student["age"]?', 'let student = { name: "Rafi", age: 20 };
console.log(student["age"]);',
'`"age"` কী-এর সাথে `20` ভ্যালুটা সেট করা আছে। ব্র্যাকেট নোটেশন (`["age"]`) ডট নোটেশনের (`.age`) মতোই কাজ করে — ফলাফল `20`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','20',1),(@q,'C','"age"',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'dog.bark() কল করলে this.name কী বোঝায়?', 'What does this.name refer to in dog.bark()?', 'let dog = {
    name: "Tommy",
    bark: function () { console.log(this.name); }
};
dog.bark();',
'`bark()`-কে `dog` অবজেক্টের উপর কল করা হয়েছে (`dog.bark()`), তাই মেথডের ভেতরে `this` মানে `dog`-কেই বোঝায়, আর `this.name` হলো `"Tommy"`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','undefined',0),(@q,'B','"Tommy" (dog অবজেক্টের name)',1),(@q,'C','"bark"',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'নিচের লুপে s.name কী কী প্রিন্ট করবে?', 'What does s.name print in this loop?', 'let students = [
    { name: "Rafi", marks: 85 },
    { name: "Nadia", marks: 92 },
];
for (let s of students) {
    console.log(s.name);
}',
'`for...of` অ্যারের প্রতিটা অবজেক্ট একে একে `s`-এ দেয় — প্রথমে Rafi-র অবজেক্ট, তারপর Nadia-র। তাই দুটো লাইনে "Rafi" এবং "Nadia" প্রিন্ট হবে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','"Rafi" তারপর "Nadia"',1),(@q,'B','শুধু "Rafi"',0),(@q,'C','85 তারপর 92',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'top.name শেষে কী হবে?', 'What is top.name at the end?', 'let students = [
    { name: "Rafi", marks: 85 },
    { name: "Nadia", marks: 92 },
    { name: "Tanvir", marks: 78 },
];
// loop finds the highest marks',
'মার্কস অনুযায়ী: Rafi 85, Nadia 92, Tanvir 78 — সবচেয়ে বেশি মার্কস Nadia-র, তাই লুপ শেষে `top` হবে Nadia-র অবজেক্ট, এবং `top.name` হলো `"Nadia"`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','Nadia',1),(@q,'C','Tanvir',0),(@q,'D','সবাই সমান',0);

-- ── Async JavaScript ─────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_async, 'callbacks-js', 'কলব্যাক: পরে চলার জন্য ফাংশন পাঠানো', 'Callbacks: Functions to Run Later',
'জাভাস্ক্রিপ্ট **সিঙ্গল-থ্রেডেড** — একসাথে একটাই কাজ করতে পারে, কিন্তু সময়সাপেক্ষ কাজ (যেমন সার্ভার থেকে ডেটা আনা) হলে পুরো প্রোগ্রাম আটকে থাকতে পারে না। তাই একটা ফাংশনকে আরেকটা ফাংশনের আর্গুমেন্ট হিসেবে পাঠিয়ে, কাজ শেষ হলে সেটা "পরে" কল করার প্যাটার্ন ব্যবহার হয় — একে **কলব্যাক** বলে।',
'function fetchData(callback) {
    setTimeout(function () {
        callback("Data loaded!");
    }, 1000); // simulates a 1-second delay
}

fetchData(function (result) {
    console.log(result); // "Data loaded!" (after ~1 second)
});',
'javascript', 10, 0, 1, 0),

(@m_async, 'promises-js', 'Promise: কলব্যাকের পরিষ্কার বিকল্প', 'Promises: A Cleaner Alternative to Callbacks',
'অনেকগুলো কলব্যাক একটার ভেতর আরেকটা বসালে কোড পড়া কঠিন হয়ে যায় ("callback hell")। **Promise** একটা ভবিষ্যতের ভ্যালুর প্রতিনিধিত্ব করে — `.then()` দিয়ে সফল হলে কী হবে, `.catch()` দিয়ে ব্যর্থ হলে কী হবে, তা চেইন করে লেখা যায়।',
'function fetchData() {
    return new Promise((resolve) => {
        setTimeout(() => resolve("Data loaded!"), 1000);
    });
}

fetchData()
    .then((result) => console.log(result))
    .catch((err) => console.log("Error:", err));',
'javascript', 10, 0, 2, 0),

(@m_async, 'async-await-js', 'async/await', 'async/await',
'`async`/`await` হলো Promise-এর উপরে বানানো একটা সিনট্যাক্স, যা asynchronous কোডকে দেখতে সাধারণ, পরপর-চলা কোডের মতো করে দেয় — `.then()` চেইন করার দরকার নেই। `await` শুধু `async` ফাংশনের ভেতরেই ব্যবহার করা যায়।',
'async function loadData() {
    let result = await fetchData(); // waits here, without blocking the whole program
    console.log(result);
}

loadData();',
'javascript', 10, 0, 3, 0),

(@m_async, 'async-capstone-js', 'ক্যাপস্টোন: দুটো ধাপে ডেটা লোড করা', 'Capstone: Loading Data in Two Steps',
'`async`/`await` দিয়ে দুটো asynchronous কাজ পরপর করা হচ্ছে — প্রথমটা শেষ না হওয়া পর্যন্ত দ্বিতীয়টা শুরু হয় না, কিন্তু কোড দেখতে সাধারণ পরপর-চলা কোডের মতোই।',
'function getUser() {
    return new Promise((resolve) => setTimeout(() => resolve("Rafi"), 500));
}
function getScore(user) {
    return new Promise((resolve) => setTimeout(() => resolve(user + ": 95"), 500));
}

async function run() {
    let user = await getUser();
    let score = await getScore(user);
    console.log(score); // "Rafi: 95"
}

run();',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_async AND slug='callbacks-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_async AND slug='promises-js';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_async AND slug='async-await-js';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_async AND slug='async-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'ফাংশন callback(result) কখন কল হবে?', 'When is callback(result) called?', 'function fetchData(callback) {
    setTimeout(function () { callback("Data loaded!"); }, 1000);
}',
'`setTimeout` ১০০০ মিলিসেকেন্ড (১ সেকেন্ড) পরে দেওয়া ফাংশনটা চালায় — তাই `callback("Data loaded!")` তখনই কল হয়, সাথে সাথে নয়। এই দেরি চলাকালীন প্রোগ্রামের বাকি অংশ আটকে থাকে না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সাথে সাথে',0),(@q,'B','প্রায় ১ সেকেন্ড পরে',1),(@q,'C','কখনোই না',0),(@q,'D','প্রোগ্রাম শেষ হলে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, '.then() কখন চলে?', 'When does .then() run?', 'fetchData()
    .then((result) => console.log(result));',
'`.then()`-এর ভেতরের ফাংশনটা তখনই চলে, যখন Promise-টা সফলভাবে "resolve" হয় — অর্থাৎ asynchronous কাজটা শেষ হয়ে ফলাফল রেডি হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সাথে সাথে, Promise শুরু হওয়ার আগেই',0),(@q,'B','Promise সফলভাবে resolve হলে',1),(@q,'C','শুধু error হলে',0),(@q,'D','কখনো চলে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'await কোথায় ব্যবহার করা যায়?', 'Where can await be used?', 'async function loadData() {
    let result = await fetchData();
}',
'`await` শুধু `async` কীওয়ার্ড দেওয়া ফাংশনের ভেতরেই ব্যবহার করা যায় — এটাই সেই ফাংশনটাকে বলে দেয় যে এখানে একটা asynchronous ফলাফলের জন্য অপেক্ষা করতে হবে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','যেকোনো ফাংশনে',0),(@q,'B','শুধু async ফাংশনের ভেতরে',1),(@q,'C','শুধু main() ফাংশনে',0),(@q,'D','কোথাও ব্যবহার করা যায় না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'run() চালালে score-এর মান কী হবে?', 'What is score when run() executes?', 'let user = await getUser();       // "Rafi"
let score = await getScore(user); // user + ": 95"',
'`await getUser()` প্রথমে `"Rafi"` রিটার্ন করে, তারপর `await getScore("Rafi")` চলে যা `"Rafi: 95"` রিটার্ন করে — দুটো ধাপ পরপর, একটা শেষ হওয়ার পরই আরেকটা শুরু হয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','"Rafi"',0),(@q,'B','"Rafi: 95"',1),(@q,'C','undefined',0),(@q,'D','Error',0);

-- ── React Basics (Advanced/Optional) ─────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_react, 'jsx-basics', 'JSX পরিচিতি', 'Introduction to JSX',
'**React** একটা জাভাস্ক্রিপ্ট লাইব্রেরি, যা দিয়ে UI বানানো হয়। **JSX** হলো জাভাস্ক্রিপ্টের ভেতরে সরাসরি HTML-এর মতো সিনট্যাক্স লেখার একটা এক্সটেনশন — এটা সরাসরি ব্রাউজার বোঝে না, একটা টুল (যেমন Babel) দিয়ে সাধারণ জাভাস্ক্রিপ্টে কনভার্ট হয়।',
'const element = <h1>Hello, Bytewise!</h1>;
// JSX looks like HTML, but it is actually JavaScript underneath',
'javascript', 10, 0, 1, 0),

(@m_react, 'components-basics', 'কম্পোনেন্ট: React-এর বিল্ডিং ব্লক', 'Components: React''s Building Blocks',
'React অ্যাপ ছোট ছোট **কম্পোনেন্ট** দিয়ে তৈরি হয় — প্রতিটা কম্পোনেন্ট আসলে একটা ফাংশন, যা JSX রিটার্ন করে। একটা কম্পোনেন্ট আরেকটা কম্পোনেন্টের ভেতরে ব্যবহার করা যায়, ঠিক HTML ট্যাগের মতোই।',
'function Welcome() {
    return <h1>Welcome to Bytewise</h1>;
}

function App() {
    return (
        <div>
            <Welcome />
        </div>
    );
}',
'javascript', 10, 0, 2, 0),

(@m_react, 'props-basics', 'Props: কম্পোনেন্টে ডেটা পাঠানো', 'Props: Passing Data to Components',
'**Props** (properties) দিয়ে একটা প্যারেন্ট কম্পোনেন্ট থেকে চাইল্ড কম্পোনেন্টে ডেটা পাঠানো যায় — অনেকটা ফাংশনের প্যারামিটারের মতো। প্রপস শুধু পড়া যায়, চাইল্ড কম্পোনেন্ট থেকে বদলানো যায় না।',
'function Greeting(props) {
    return <h1>Hello, {props.name}!</h1>;
}

function App() {
    return <Greeting name="Rafi" />; // passes "Rafi" as a prop
}',
'javascript', 10, 0, 3, 0),

(@m_react, 'react-capstone', 'ক্যাপস্টোন: একটা স্টুডেন্ট কার্ড কম্পোনেন্ট', 'Capstone: A Student Card Component',
'Props ব্যবহার করে একটা রিইউজেবল `StudentCard` কম্পোনেন্ট বানানো হচ্ছে, যা একাধিকবার আলাদা আলাদা ডেটা দিয়ে ব্যবহার করা যায়।',
'function StudentCard(props) {
    return (
        <div>
            <h2>{props.name}</h2>
            <p>Marks: {props.marks}</p>
        </div>
    );
}

function App() {
    return (
        <div>
            <StudentCard name="Rafi" marks={85} />
            <StudentCard name="Nadia" marks={92} />
        </div>
    );
}',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_react AND slug='jsx-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_react AND slug='components-basics';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_react AND slug='props-basics';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_react AND slug='react-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'JSX ব্রাউজারে সরাসরি চালানোর আগে কী হয়?', 'What happens to JSX before the browser runs it?', 'const element = <h1>Hello, Bytewise!</h1>;',
'ব্রাউজার সরাসরি JSX বোঝে না — একটা টুল (যেমন Babel) দিয়ে JSX-কে সাধারণ জাভাস্ক্রিপ্ট ফাংশন কলে কনভার্ট করা হয়, তারপরই সেটা ব্রাউজারে চলে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কিছুই হয় না, ব্রাউজার সরাসরি বোঝে',0),(@q,'B','একটা টুল দিয়ে সাধারণ জাভাস্ক্রিপ্টে কনভার্ট হয়',1),(@q,'C','এটা HTML ফাইলে সেভ হয়ে যায়',0),(@q,'D','এটা একটা এরর',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'একটা React কম্পোনেন্ট আসলে কী?', 'What is a React component, really?', 'function Welcome() {
    return <h1>Welcome to Bytewise</h1>;
}',
'একটা React কম্পোনেন্ট আসলে একটা সাধারণ জাভাস্ক্রিপ্ট ফাংশন, যা JSX রিটার্ন করে — এখানে `Welcome` একটা ফাংশন, যা কল হলে `<h1>...</h1>` রিটার্ন করে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটা HTML ফাইল',0),(@q,'B','একটা ফাংশন যা JSX রিটার্ন করে',1),(@q,'C','একটা CSS ক্লাস',0),(@q,'D','একটা ডেটাবেস টেবিল',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'props.name এর মান কী হবে?', 'What is props.name here?', 'function Greeting(props) {
    return <h1>Hello, {props.name}!</h1>;
}
<Greeting name="Rafi" />',
'`<Greeting name="Rafi" />` লেখার মাধ্যমে `"Rafi"` একটা prop হিসেবে পাঠানো হয়েছে — কম্পোনেন্টের ভেতরে `props.name` দিয়ে সেটা অ্যাক্সেস করা যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','undefined',0),(@q,'B','"Rafi"',1),(@q,'C','"name"',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, '<StudentCard name="Rafi" marks={85} /> দুইবার ভিন্ন ডেটা দিয়ে ব্যবহার করা যাচ্ছে কেন?', 'Why can StudentCard be reused with different data?', '<StudentCard name="Rafi" marks={85} />
<StudentCard name="Nadia" marks={92} />',
'`StudentCard` কম্পোনেন্টটা props (`name`, `marks`) থেকে ডেটা নেয়, নিজের ভেতরে হার্ডকোড করা কোনো ভ্যালু নেই — তাই একই কম্পোনেন্ট প্রতিবার আলাদা props দিয়ে আলাদা ডেটা দেখাতে পারে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কম্পোনেন্টটা props থেকে ডেটা নেয়, হার্ডকোড করা নয়',1),(@q,'B','React প্রতিবার একটা নতুন কম্পোনেন্ট তৈরি করে',0),(@q,'C','এটা আসলে কাজ করবে না',0),(@q,'D','name আর marks গ্লোবাল ভেরিয়েবল',0);
