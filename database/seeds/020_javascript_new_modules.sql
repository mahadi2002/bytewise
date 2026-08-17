-- JavaScript track: 1 new Arrays lesson (Sets & Maps — capstone already
-- renumbered to slot 5 by 015) + Error Handling + ES6 Classes (new modules
-- 7-8, inserted before the existing react-basics module 6 in track order
-- but after it in sort_order since React was already module 6).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_js FROM languages WHERE slug = 'javascript';
SELECT id INTO @m_arr FROM modules WHERE language_id=@lang_js AND slug='arrays';
SELECT id INTO @m_err FROM modules WHERE language_id=@lang_js AND slug='error-handling';
SELECT id INTO @m_cls FROM modules WHERE language_id=@lang_js AND slug='classes';

-- ── Arrays expansion: Sets & Maps ────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_arr, 'sets-maps-js', 'Set ও Map', 'Set & Map',
'`Set` শুধু ইউনিক ভ্যালু রাখে — ডুপ্লিকেট নিজে থেকেই বাদ পড়ে। `Map` key-value পেয়ার রাখে, প্লেইন অবজেক্টের মতোই, কিন্তু যেকোনো টাইপের key নিতে পারে (শুধু স্ট্রিং নয়) এবং `.size` দিয়ে সাইজ জানা যায়।',
'let nums = new Set([1, 2, 2, 3, 3, 3]);
console.log(nums.size); // 3 (duplicates removed)

let ages = new Map();
ages.set("Rafi", 20);
console.log(ages.get("Rafi")); // 20',
'javascript', 10, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_arr AND slug='sets-maps-js';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'nums.size এর মান কত হবে?', 'What is nums.size?', 'let nums = new Set([1, 2, 2, 3, 3, 3]);
nums.size',
'`Set` ডুপ্লিকেট বাদ দেয় — [1, 2, 2, 3, 3, 3] থেকে ইউনিক ভ্যালু থাকে {1, 2, 3}, তাই `.size` হলো `3`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','6',0),(@q,'B','3',1),(@q,'C','1',0),(@q,'D','undefined',0);

-- ── Error Handling ───────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_err, 'try-catch-js', 'try, catch ও finally', 'try, catch & finally',
'জাভাস্ক্রিপ্টে সমস্যা হলে একটা এরর "throw" হয়, যা না ধরলে প্রোগ্রাম (বা সেই ফাংশন) থেমে যায়। `try` ব্লকে ঝুঁকিপূর্ণ কোড রাখা হয়, `catch` সেটা ধরে, আর `finally` ব্লক এরর হোক বা না হোক সবসময় চলে।',
'try {
    let result = JSON.parse("not valid json");
} catch (error) {
    console.log("Caught:", error.message);
} finally {
    console.log("This always runs");
}',
'javascript', 10, 0, 1, 0),

(@m_err, 'throw-custom-errors', 'throw ও কাস্টম এরর', 'throw & Custom Errors',
'`throw` দিয়ে নিজে থেকেই একটা এরর তৈরি করা যায় — সাধারণত `new Error("message")` দিয়ে। `Error`-কে `extends` করে নিজের কাস্টম এরর ক্লাসও বানানো যায়, নির্দিষ্ট এরর টাইপ বোঝাতে।',
'class InvalidAgeError extends Error {
    constructor(message) {
        super(message);
        this.name = "InvalidAgeError";
    }
}

function checkAge(age) {
    if (age < 0) {
        throw new InvalidAgeError("Age cannot be negative");
    }
}

try {
    checkAge(-5);
} catch (e) {
    console.log(e.name + ": " + e.message);
}',
'javascript', 10, 0, 2, 0),

(@m_err, 'error-types-js', 'কমন এরর টাইপ', 'Common Error Types',
'জাভাস্ক্রিপ্টের কিছু বিল্ট-ইন এরর টাইপ: `TypeError` (ভুল টাইপে অপারেশন, যেমন `undefined`-এর প্রপার্টি অ্যাক্সেস), `ReferenceError` (না-ঘোষণা করা ভেরিয়েবল ব্যবহার), `SyntaxError` (ভুল সিনট্যাক্স, সাধারণত `JSON.parse()`-এ)। এরর টাইপ চিনলে সমস্যা দ্রুত ধরা যায়।',
'try {
    let x;
    x.someProperty; // TypeError: Cannot read properties of undefined
} catch (e) {
    console.log(e.constructor.name); // "TypeError"
}',
'javascript', 10, 0, 3, 0),

(@m_err, 'error-handling-capstone-js', 'ক্যাপস্টোন: নিরাপদ JSON পার্সিং', 'Capstone: Safe JSON Parsing',
'ইউজারের থেকে আসা টেক্সট সবসময় বৈধ JSON না-ও হতে পারে — `try/catch` দিয়ে সেটা নিরাপদে পার্স করে, ব্যর্থ হলে একটা ডিফল্ট ভ্যালু ব্যবহার করা হচ্ছে।',
'function safeParseJSON(text, fallback) {
    try {
        return JSON.parse(text);
    } catch (e) {
        console.log("Invalid JSON, using fallback");
        return fallback;
    }
}

console.log(safeParseJSON(''{"name": "Rafi"}'', {})); // { name: "Rafi" }
console.log(safeParseJSON("not json", {}));            // {} (fallback)',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_err AND slug='try-catch-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_err AND slug='throw-custom-errors';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_err AND slug='error-types-js';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_err AND slug='error-handling-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'finally ব্লক কখন চলে?', 'When does finally run?', 'try { ... } catch (error) { ... } finally {
    console.log("This always runs");
}',
'`finally` ব্লক সবসময় চলে — এরর হোক বা না হোক, `catch` ধরুক বা না ধরুক। রিসোর্স ক্লিনআপের জন্য এটা ব্যবহার হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু এরর হলে',0),(@q,'B','সবসময়',1),(@q,'C','কখনোই না',0),(@q,'D','শুধু catch ব্লক থাকলে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'checkAge(-5) কল করলে কী হবে?', 'What happens calling checkAge(-5)?', 'function checkAge(age) {
    if (age < 0) throw new InvalidAgeError("Age cannot be negative");
}
try { checkAge(-5); } catch (e) { console.log(e.name + ": " + e.message); }',
'`-5 < 0` সত্যি হওয়ায় `throw` চলে, যা `catch (e)`-এ ধরা পড়ে এবং "InvalidAgeError: Age cannot be negative" প্রিন্ট হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কিছুই প্রিন্ট হয় না',0),(@q,'B','"InvalidAgeError: Age cannot be negative" প্রিন্ট হয়',1),(@q,'C','প্রোগ্রাম ক্র্যাশ করে',0),(@q,'D','SyntaxError হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'undefined-এর প্রপার্টি অ্যাক্সেস করলে কোন এরর টাইপ হয়?', 'What error type from accessing a property of undefined?', 'let x;
x.someProperty; // ???',
'`x` ঘোষণা করা হয়েছে কিন্তু কোনো ভ্যালু দেওয়া হয়নি (তাই `undefined`)। `undefined`-এর কোনো প্রপার্টি নেই, তাই এটা অ্যাক্সেস করতে গেলে জাভাস্ক্রিপ্ট `TypeError` ছোড়ে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','SyntaxError',0),(@q,'B','TypeError',1),(@q,'C','ReferenceError',0),(@q,'D','কোনো এরর হয় না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, "safeParseJSON('not json', {}) কী রিটার্ন করবে?", "What does safeParseJSON('not json', {}) return?", 'function safeParseJSON(text, fallback) {
    try { return JSON.parse(text); }
    catch (e) { return fallback; }
}',
'"not json" বৈধ JSON নয়, তাই `JSON.parse()` একটা এরর ছোড়ে — `catch` ব্লক সেটা ধরে দেওয়া `fallback` (এখানে `{}`) রিটার্ন করে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','"not json"',0),(@q,'B','{} (fallback)',1),(@q,'C','undefined',0),(@q,'D','প্রোগ্রাম ক্র্যাশ করে',0);

-- ── ES6 Classes ──────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_cls, 'class-basics-js', 'ক্লাস: constructor ও মেথড', 'Classes: constructor & Methods',
'ES6-এ `class` কীওয়ার্ড দিয়ে সরাসরি ক্লাস লেখা যায় (আগে ফাংশন দিয়ে সিমুলেট করতে হতো)। `constructor` অবজেক্ট তৈরি হওয়ার সাথে সাথে চলে, আর `this` দিয়ে সেই নির্দিষ্ট অবজেক্টটাকে বোঝানো হয়।',
'class Dog {
    constructor(name) {
        this.name = name;
    }
    bark() {
        console.log(this.name + " says Woof!");
    }
}

const d = new Dog("Tommy");
d.bark(); // Tommy says Woof!',
'javascript', 10, 0, 1, 0),

(@m_cls, 'class-inheritance-js', 'ইনহেরিটেন্স: extends ও super', 'Inheritance: extends & super',
'`extends` দিয়ে একটা ক্লাস আরেকটা ক্লাসের সব প্রপার্টি ও মেথড উত্তরাধিকার সূত্রে পায়। চাইল্ড ক্লাসের `constructor`-এ `super(...)` দিয়ে প্যারেন্টের কনস্ট্রাক্টর কল করতে হয়, `this` ব্যবহারের আগেই।',
'class Animal {
    constructor(name) {
        this.name = name;
    }
    eat() {
        console.log(this.name + " is eating");
    }
}

class Cat extends Animal {
    constructor(name) {
        super(name); // must call before using `this`
    }
}

const c = new Cat("Whiskers");
c.eat(); // inherited from Animal',
'javascript', 10, 0, 2, 0),

(@m_cls, 'getters-setters-js', 'গেটার ও সেটার', 'Getters & Setters',
'`get`/`set` দিয়ে এমন একটা মেথড বানানো যায়, যেটা দেখতে একটা সাধারণ প্রপার্টির মতো ব্যবহার হয় (`()` ছাড়াই), কিন্তু আসলে একটা ফাংশন — অ্যাক্সেস বা পরিবর্তনের সময় লজিক চালানো যায়, যেমন ভ্যালিডেশন।',
'class Circle {
    constructor(radius) {
        this._radius = radius;
    }
    get area() {
        return 3.14159 * this._radius * this._radius;
    }
}

const c = new Circle(5);
console.log(c.area); // 78.53975 — called like a property, not a method',
'javascript', 10, 0, 3, 0),

(@m_cls, 'classes-capstone-js', 'ক্যাপস্টোন: BankAccount ক্লাস', 'Capstone: A BankAccount Class',
'একটা ক্লাস, কনস্ট্রাক্টর, আর একটা মেথড যা ব্যালেন্স পরিবর্তনের আগে ভ্যালিডেশন করে — আগের তিনটা লেসনের ধারণা একসাথে।',
'class BankAccount {
    constructor(balance) {
        this.balance = balance;
    }
    deposit(amount) {
        if (amount > 0) {
            this.balance += amount;
        }
    }
}

const acc = new BankAccount(100);
acc.deposit(50);
console.log(acc.balance); // 150',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_cls AND slug='class-basics-js';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_cls AND slug='class-inheritance-js';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_cls AND slug='getters-setters-js';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_cls AND slug='classes-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'new Dog("Tommy") লেখার সাথে সাথে কোন মেথডটা চলে?', 'Which method runs when new Dog("Tommy") executes?', 'class Dog {
    constructor(name) { this.name = name; }
    bark() { ... }
}
const d = new Dog("Tommy");',
'`constructor` মেথডটা `new` দিয়ে অবজেক্ট তৈরি হওয়ার মুহূর্তেই অটোমেটিক্যালি চলে এবং `this.name`-কে `"Tommy"` সেট করে। `bark()` তখনই চলে যখন আলাদাভাবে কল করা হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','bark()',0),(@q,'B','constructor()',1),(@q,'C','দুটোই একসাথে',0),(@q,'D','কোনোটাই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'super(name) কেন লেখা হয়েছে?', 'Why is super(name) called here?', 'class Cat extends Animal {
    constructor(name) {
        super(name); // must call before using `this`
    }
}',
'`Cat`, `Animal`-কে extend করেছে — `super(name)` প্যারেন্ট ক্লাসের (`Animal`) কনস্ট্রাক্টরকে কল করে, যা `this.name` সেট করে। `super()` কল না করে `this` ব্যবহার করলে এরর হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্যারেন্ট ক্লাসের কনস্ট্রাক্টর কল করতে',1),(@q,'B','একটা নতুন ক্লাস তৈরি করতে',0),(@q,'C','এটা ঐচ্ছিক, কোনো কাজ করে না',0),(@q,'D','মেথড ওভাররাইড বন্ধ করতে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'c.area লিখতে () লাগছে না কেন?', 'Why no () needed for c.area?', 'get area() {
    return 3.14159 * this._radius * this._radius;
}
c.area // no parentheses',
'`get` কীওয়ার্ড দিয়ে বানানো মেথড একটা সাধারণ প্রপার্টির মতো অ্যাক্সেস করা হয়, `()` ছাড়াই — ভেতরে যদিও এটা একটা ফাংশন, বাইরে থেকে দেখতে ঠিক প্রপার্টির মতোই লাগে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','get দিয়ে বানানো মেথড প্রপার্টির মতো অ্যাক্সেস হয়',1),(@q,'B','এটা একটা সিনট্যাক্স এরর',0),(@q,'C','area আসলে একটা ভেরিয়েবল',0),(@q,'D','() ঐচ্ছিক, যেকোনো মেথডে বাদ দেওয়া যায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'acc.balance এর ফাইনাল মান কত হবে?', 'What is the final acc.balance?', 'const acc = new BankAccount(100);
acc.deposit(50);
acc.balance;',
'কনস্ট্রাক্টর `this.balance = 100` সেট করে। `deposit(50)` কল হলে `amount > 0` সত্যি হওয়ায় `this.balance += 50` চলে, তাই ফাইনাল মান `150`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','100',0),(@q,'B','150',1),(@q,'C','50',0),(@q,'D','undefined',0);
