-- JavaScript track: DOM Basics + ES6+ Features (new modules 9-10).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_js FROM languages WHERE slug = 'javascript';
SELECT id INTO @m_dom FROM modules WHERE language_id=@lang_js AND slug='dom-basics';
SELECT id INTO @m_es6 FROM modules WHERE language_id=@lang_js AND slug='es6-features';

-- ── DOM Basics ───────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_dom, 'query-select', 'এলিমেন্ট খুঁজে বের করা: querySelector', 'Finding Elements: querySelector',
'ব্রাউজারে চলা জাভাস্ক্রিপ্টের সবচেয়ে বড় শক্তি হলো ওয়েব পেজের HTML — যাকে **DOM (Document Object Model)** বলে — সরাসরি নিয়ন্ত্রণ করতে পারা। `document.querySelector(selector)` দিয়ে CSS সিলেক্টরের মতো করে একটা এলিমেন্ট খুঁজে বের করা যায়, আর `querySelectorAll()` দিয়ে সবগুলো ম্যাচিং এলিমেন্ট।',
'// Assuming HTML has: <h1 id="title">Hello</h1>
const heading = document.querySelector("#title");
console.log(heading.textContent); // "Hello"

const allParagraphs = document.querySelectorAll("p");
console.log(allParagraphs.length);',
'javascript', 10, 0, 1, 0),

(@m_dom, 'changing-content', 'কনটেন্ট ও স্টাইল বদলানো', 'Changing Content & Style',
'একটা এলিমেন্ট খুঁজে পাওয়ার পর, `.textContent` দিয়ে তার টেক্সট বদলানো যায়, `.innerHTML` দিয়ে HTML-সহ কনটেন্ট বসানো যায় (সাবধান: ইউজার-দেওয়া টেক্সট সরাসরি `innerHTML`-এ বসালে XSS নিরাপত্তা ঝুঁকি হতে পারে), আর `.style` দিয়ে CSS প্রপার্টি সরাসরি বদলানো যায়।',
'const heading = document.querySelector("#title");
heading.textContent = "Welcome!";
heading.style.color = "green";
heading.style.fontSize = "24px";',
'javascript', 10, 0, 2, 0),

(@m_dom, 'event-listeners', 'ইভেন্ট লিসেনার: addEventListener', 'Event Listeners: addEventListener',
'ইউজার ক্লিক করলে, টাইপ করলে, বা ফর্ম সাবমিট করলে — এই ধরনের ঘটনায় প্রতিক্রিয়া জানাতে `addEventListener()` ব্যবহার হয়। প্রথম আর্গুমেন্ট ইভেন্টের নাম (যেমন `"click"`), দ্বিতীয়টা একটা ফাংশন যা ইভেন্ট ঘটলে চলে।',
'const button = document.querySelector("#myButton");

button.addEventListener("click", function () {
    console.log("Button was clicked!");
});',
'javascript', 10, 0, 3, 0),

(@m_dom, 'dom-capstone-js', 'ক্যাপস্টোন: ক্লিক কাউন্টার', 'Capstone: A Click Counter',
'querySelector, ইভেন্ট লিসেনার, আর কনটেন্ট বদলানো — তিনটাই একসাথে ব্যবহার করে একটা ছোট ক্লিক-কাউন্টার বানানো হচ্ছে, বাস্তব ইন্টারেক্টিভ UI-এর মূল প্যাটার্ন।',
'let count = 0;
const button = document.querySelector("#counterBtn");
const display = document.querySelector("#countDisplay");

button.addEventListener("click", function () {
    count++;
    display.textContent = count;
});',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_dom AND slug='query-select';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_dom AND slug='changing-content';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_dom AND slug='event-listeners';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_dom AND slug='dom-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'document.querySelectorAll("p") কী রিটার্ন করে?', 'What does querySelectorAll("p") return?', 'const allParagraphs = document.querySelectorAll("p");',
'`querySelectorAll()` পেজের সব ম্যাচিং এলিমেন্টের একটা লিস্টের মতো কালেকশন (NodeList) রিটার্ন করে — এখানে পেজের প্রতিটা `<p>` এলিমেন্ট, একটামাত্র নয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু প্রথম <p> এলিমেন্ট',0),(@q,'B','সব <p> এলিমেন্টের একটা কালেকশন',1),(@q,'C','<p> এলিমেন্টের সংখ্যা (একটা সংখ্যা)',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'heading.textContent = "Welcome!"; এর পর কী হবে?', 'What happens after this line?', 'const heading = document.querySelector("#title");
heading.textContent = "Welcome!";',
'`.textContent`-এ নতুন ভ্যালু বসালে সেই এলিমেন্টের ভেতরের টেক্সট সরাসরি বদলে যায় — পেজে এখন "Hello"-র বদলে "Welcome!" দেখাবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এলিমেন্টের টেক্সট বদলে "Welcome!" হয়ে যায়',1),(@q,'B','একটা নতুন এলিমেন্ট তৈরি হয়',0),(@q,'C','কিছুই হয় না',0),(@q,'D','পেজ রিলোড হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'addEventListener("click", fn) এ fn কখন চলে?', 'When does fn run here?', 'button.addEventListener("click", function () {
    console.log("Button was clicked!");
});',
'দেওয়া ফাংশনটা তখনই চলে, যখন ইউজার সেই বাটনে ক্লিক করে — পেজ লোড হওয়ার সাথে সাথে নয়, বরং ক্লিক ইভেন্টের অপেক্ষায় থাকে এবং ইভেন্ট ঘটলেই ট্রিগার হয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','পেজ লোড হওয়ার সাথে সাথে',0),(@q,'B','ইউজার বাটনে ক্লিক করলে',1),(@q,'C','প্রতি সেকেন্ডে',0),(@q,'D','কখনো চলে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, '৩ বার ক্লিক করার পর display-তে কী দেখাবে?', 'What does display show after 3 clicks?', 'let count = 0;
button.addEventListener("click", function () {
    count++;
    display.textContent = count;
});',
'প্রতিবার ক্লিকে `count++` চলে, তাই ৩ বার ক্লিকের পর `count` হয় ৩, আর `display.textContent = count` সেই মানটাই দেখায়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',0),(@q,'B','3',1),(@q,'C','1',0),(@q,'D','undefined',0);

-- ── ES6+ Features ────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_es6, 'destructuring', 'ডিস্ট্রাকচারিং', 'Destructuring',
'**ডিস্ট্রাকচারিং** দিয়ে একটা অ্যারে বা অবজেক্ট থেকে একাধিক ভ্যালু এক লাইনেই আলাদা আলাদা ভেরিয়েবলে বের করে আনা যায় — একটা একটা করে `arr[0]`, `arr[1]` লেখার বদলে।',
'// array destructuring
const [first, second] = [10, 20];
console.log(first, second); // 10 20

// object destructuring
const student = { name: "Rafi", age: 20 };
const { name, age } = student;
console.log(name, age); // Rafi 20',
'javascript', 10, 0, 1, 0),

(@m_es6, 'spread-rest', 'Spread ও Rest অপারেটর', 'Spread & Rest Operators',
'`...` (তিনটা ডট) দুইভাবে ব্যবহার হয়। **Spread**: একটা অ্যারে/অবজেক্টকে "ছড়িয়ে" দেয় (কপি করতে, বা একসাথে জোড়া লাগাতে)। **Rest**: একাধিক আর্গুমেন্টকে একটা অ্যারেতে "গুটিয়ে" নেয় (ফাংশন প্যারামিটারে)।',
'// spread: copy and merge arrays
const a = [1, 2];
const b = [...a, 3, 4]; // [1, 2, 3, 4]

// rest: collect remaining arguments
function sum(...numbers) {
    return numbers.reduce((total, n) => total + n, 0);
}
console.log(sum(1, 2, 3)); // 6',
'javascript', 10, 0, 2, 0),

(@m_es6, 'template-modules', 'টেমপ্লেট লিটারেল ও Modules', 'Template Literals & Modules',
'ব্যাকটিক (`` ` ``) দিয়ে লেখা **টেমপ্লেট লিটারেল**-এ সরাসরি `${}` দিয়ে ভেরিয়েবল বসানো যায়, `+` দিয়ে জোড়া লাগানোর দরকার নেই। বড় প্রোগ্রামকে একাধিক ফাইলে ভাগ করতে ES6 **modules** (`export`/`import`) ব্যবহার হয়।',
'const name = "Rafi";
const age = 20;
console.log(`${name} is ${age} years old`); // Rafi is 20 years old

// in math.js:  export function square(x) { return x * x; }
// in main.js:  import { square } from "./math.js";',
'javascript', 10, 0, 3, 0),

(@m_es6, 'es6-capstone-js', 'ক্যাপস্টোন: ডিস্ট্রাকচারিং ও স্প্রেড একসাথে', 'Capstone: Destructuring & Spread Together',
'একটা স্টুডেন্ট অবজেক্ট থেকে ডিস্ট্রাকচারিং দিয়ে ভ্যালু বের করে, স্প্রেড দিয়ে একটা আপডেট করা নতুন অবজেক্ট বানানো হচ্ছে — মূল অবজেক্টকে না বদলিয়ে।',
'const student = { name: "Rafi", marks: 85 };
const { name, marks } = student;

const updated = { ...student, marks: 95 }; // copy, then override marks
console.log(updated); // { name: "Rafi", marks: 95 }
console.log(student.marks); // 85 — original unchanged',
'javascript', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_es6 AND slug='destructuring';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_es6 AND slug='spread-rest';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_es6 AND slug='template-modules';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_es6 AND slug='es6-capstone-js';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'const { name, age } = student; এর পর name এর মান কত?', 'What is name after this?', 'const student = { name: "Rafi", age: 20 };
const { name, age } = student;',
'অবজেক্ট ডিস্ট্রাকচারিং প্রপার্টির নাম মিলিয়ে ভ্যালু বের করে আনে — `student.name`-এর মান "Rafi", তাই `name` ভেরিয়েবলে "Rafi" বসে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','undefined',0),(@q,'B','Rafi',1),(@q,'C','20',0),(@q,'D','"name"',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'sum(1, 2, 3) কী রিটার্ন করবে?', 'What does sum(1, 2, 3) return?', 'function sum(...numbers) {
    return numbers.reduce((total, n) => total + n, 0);
}
sum(1, 2, 3)',
'`...numbers` (rest) তিনটা আর্গুমেন্টকে `[1, 2, 3]` অ্যারেতে গুটিয়ে নেয়, তারপর `reduce()` সেগুলো যোগ করে: `1+2+3 = 6`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','[1, 2, 3]',0),(@q,'B','6',1),(@q,'C','123',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, '`${name} is ${age}` — এখানে ${} এর কাজ কী?', 'What does ${} do here?', 'const name = "Rafi";
console.log(`${name} is ...`);',
'টেমপ্লেট লিটারেলে `${}`-এর ভেতরে যেকোনো জাভাস্ক্রিপ্ট এক্সপ্রেশন (এখানে একটা ভেরিয়েবল) লিখলে তার আসল মান সরাসরি স্ট্রিংয়ে বসে যায় — `+` দিয়ে জোড়া লাগানোর দরকার নেই।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ভেরিয়েবলের আসল মান স্ট্রিংয়ে বসিয়ে দেয়',1),(@q,'B','একটা কমেন্ট',0),(@q,'C','হুবহু "${name}" টেক্সট হিসেবে থাকে',0),(@q,'D','একটা এরর দেয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'updated তৈরি হওয়ার পর student.marks এর মান কত থাকবে?', 'What is student.marks after creating updated?', 'const student = { name: "Rafi", marks: 85 };
const updated = { ...student, marks: 95 };
student.marks',
'`{ ...student, marks: 95 }` `student`-এর একটা *নতুন কপি* বানায় যেখানে `marks` ওভাররাইড করা হয়েছে — আসল `student` অবজেক্ট অপরিবর্তিত থাকে, তাই `student.marks` এখনও `85`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','95',0),(@q,'B','85',1),(@q,'C','undefined',0),(@q,'D','0',0);
