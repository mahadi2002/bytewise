-- C++ track: finish Basics (3 more lessons) + all 5 remaining modules.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'cpp';
SELECT id INTO @m_basics FROM modules WHERE language_id=@lang AND slug='basics';
SELECT id INTO @m_cf     FROM modules WHERE language_id=@lang AND slug='control-flow';
SELECT id INTO @m_oop    FROM modules WHERE language_id=@lang AND slug='oop';
SELECT id INTO @m_cont   FROM modules WHERE language_id=@lang AND slug='containers';
SELECT id INTO @m_stl    FROM modules WHERE language_id=@lang AND slug='stl';
SELECT id INTO @m_ptr    FROM modules WHERE language_id=@lang AND slug='pointers-refs';

-- ── Basics (lessons 2-4; lesson 1 "variables-cout" already exists) ────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_basics, 'input-cin', 'ইনপুট নেওয়া: cin', 'Taking Input: cin',
'C-তে `scanf()` দিয়ে ইনপুট নেওয়া হয়, C++-এ তার বদলে `cin` আর `>>` (extraction) অপারেটর ব্যবহার হয় — কোনো `&` লাগে না, যেটা প্রায়ই C থেকে আসা মানুষদের কনফিউজ করে।',
'#include <iostream>
using namespace std;

int main() {
    int age;
    cout << "Enter your age: ";
    cin >> age;
    cout << "You are " << age << " years old." << endl;
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_basics, 'operators-cpp', 'অপারেটর', 'Operators',
'C++-এর গাণিতিক ও তুলনামূলক অপারেটরগুলো C-এর মতোই — `+ - * / %` এবং `== != < > <= >=`। দুটো `int` ভাগ করলে ফলাফলও `int` হয় (দশমিক অংশ কেটে যায়), ঠিক C-এর মতোই।',
'#include <iostream>
using namespace std;

int main() {
    int a = 7, b = 2;
    cout << "Integer division: " << a / b << endl;
    cout << "Float division: " << (float)a / b << endl;
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_basics, 'first-program-cpp', 'প্রথম ক্যালকুলেশন প্রোগ্রাম', 'Your First Calculation Program',
'আগের তিনটা লেসনের সবকিছু একসাথে: ভেরিয়েবল ঘোষণা, `cin` দিয়ে ইনপুট, একটা ফর্মুলা ক্যালকুলেট করা, আর `cout` দিয়ে ফলাফল প্রিন্ট করা।',
'#include <iostream>
using namespace std;

int main() {
    float weight, height;
    cin >> weight >> height;
    float bmi = weight / (height * height);
    cout << bmi << endl;
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_basics AND slug='input-cin';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_basics AND slug='operators-cpp';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_basics AND slug='first-program-cpp';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'cin দিয়ে ইনপুট নিতে ভেরিয়েবলের আগে কী বসাতে হয়?', 'What must precede a variable when reading with cin?', 'cin >> age;',
'C++-এর `cin >> age`-এ কোনো `&` লাগে না — এটা C-এর `scanf("%d", &age)`-এর চেয়ে আলাদা। `>>` অপারেটরই ইনপুট স্ট্রিমটাকে ভেরিয়েবলের দিকে "extract" করে দেয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','& (যেমন C-তে)',0),(@q,'B','কিছুই লাগে না, শুধু >> ব্যবহার করলেই চলে',1),(@q,'C','*',0),(@q,'D','$',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'a / b এর আউটপুট কত হবে?', 'What does a / b print?', 'int a = 7, b = 2;
cout << a / b;',
'`a` আর `b` দুটোই `int`, তাই ভাগের ফলাফলও `int` — দশমিক অংশ কেটে যায়। `7 / 2 = 3` (৩.৫ নয়)।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3.5',0),(@q,'B','3',1),(@q,'C','4',0),(@q,'D','3.0',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'cin >> weight >> height; — এখানে কয়টি ভ্যালু ইনপুট নেওয়া হচ্ছে?', 'How many values does this line read?', 'cin >> weight >> height;',
'`>>` অপারেটর চেইন করা যায় — এক লাইনে `cin >> weight >> height` মানে পরপর দুটো ভ্যালু, প্রথমটা `weight`-এ আর দ্বিতীয়টা `height`-এ যাবে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','১টি',0),(@q,'B','২টি',1),(@q,'C','৩টি',0),(@q,'D','Compile error',0);

-- ── Control Flow & Functions ────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_cf, 'if-else-cpp', 'শর্ত ও if-else', 'Conditions & If-Else',
'C++-এর `if`/`else if`/`else` সিনট্যাক্স হুবহু C-এর মতোই। পার্থক্য হলো C++-এ একটা আসল `bool` টাইপ আছে (`true`/`false`), C-তে যেটা `<stdbool.h>` লাগে বা `0`/`1` দিয়ে সিমুলেট করতে হয়।',
'#include <iostream>
using namespace std;

int main() {
    int marks = 65;
    if (marks >= 80) {
        cout << "Grade: A" << endl;
    } else if (marks >= 60) {
        cout << "Grade: B" << endl;
    } else {
        cout << "Grade: C" << endl;
    }
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_cf, 'loops-cpp', 'লুপ: while ও for', 'Loops: While & For',
'`while` আর `for` লুপ C-এর মতোই কাজ করে। C++-এ আরেকটা সুবিধাজনক ফর্ম আছে — **range-based for loop** — যা পরের মডিউলে (Vectors) কনটেইনার লুপ করার সময় অনেক বেশি ব্যবহার হবে।',
'#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 5; i++) {
        cout << i << " ";
    }
    cout << endl;
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_cf, 'functions-cpp', 'ফাংশন ঘোষণা ও কল করা', 'Declaring & Calling Functions',
'C++-এ ফাংশন ঘোষণা C-এর মতোই — রিটার্ন টাইপ, নাম, প্যারামিটার। একটা এক্সট্রা সুবিধা: **default parameter** — কোনো আর্গুমেন্ট না দিলে একটা ডিফল্ট ভ্যালু ব্যবহার হয়, যা C-তে সরাসরি সম্ভব না।',
'#include <iostream>
using namespace std;

int add(int a, int b = 10) { // b defaults to 10
    return a + b;
}

int main() {
    cout << add(5, 3) << endl; // 8
    cout << add(5) << endl;    // 15 (uses default b=10)
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_cf, 'control-flow-capstone-cpp', 'ক্যাপস্টোন: FizzBuzz', 'Capstone: FizzBuzz',
'একটা ক্লাসিক প্রবলেম — ১ থেকে ১৫ পর্যন্ত সংখ্যা প্রিন্ট করো, কিন্তু ৩-এর গুণিতক হলে "Fizz", ৫-এর গুণিতক হলে "Buzz", আর দুটোরই গুণিতক হলে "FizzBuzz" প্রিন্ট করো। এতে লুপ, শর্ত, আর মডুলাস (`%`) অপারেটর — সবকিছু একসাথে লাগে।',
'#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 15; i++) {
        if (i % 15 == 0) cout << "FizzBuzz" << endl;
        else if (i % 3 == 0) cout << "Fizz" << endl;
        else if (i % 5 == 0) cout << "Buzz" << endl;
        else cout << i << endl;
    }
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_cf AND slug='if-else-cpp';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_cf AND slug='loops-cpp';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_cf AND slug='functions-cpp';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_cf AND slug='control-flow-capstone-cpp';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'নিচের কোডের আউটপুট কী হবে?', 'What does this print?', 'int marks = 65;
if (marks >= 80) cout << "A";
else if (marks >= 60) cout << "B";
else cout << "C";',
'৬৫, ৮০-এর কম কিন্তু ৬০-এর বেশি বা সমান, তাই `else if (marks >= 60)` সত্যি হয় এবং "B" প্রিন্ট হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','A',0),(@q,'B','B',1),(@q,'C','C',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'এই লুপটি কতবার চলবে?', 'How many times does this run?', 'for (int i = 1; i <= 5; i++) {
    cout << i << " ";
}',
'`i` ১ থেকে শুরু হয়ে `i <= 5` সত্যি থাকা পর্যন্ত চলে — অর্থাৎ 1,2,3,4,5, মোট ৫ বার।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','৪ বার',0),(@q,'B','৫ বার',1),(@q,'C','৬ বার',0),(@q,'D','ইনফিনিট',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'add(5) কল করলে কী রিটার্ন হবে?', 'What does add(5) return?', 'int add(int a, int b = 10) { return a + b; }
add(5);',
'`add(5)`-এ শুধু `a`-এর জন্য ভ্যালু দেওয়া হয়েছে, `b` দেওয়া হয়নি — তাই `b` তার ডিফল্ট ভ্যালু `10` নেবে। ফলাফল: `5 + 10 = 15`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','15',1),(@q,'C','Compile error (b missing)',0),(@q,'D','0',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'i = 15 হলে কী প্রিন্ট হবে?', 'What prints when i = 15?', 'if (i % 15 == 0) cout << "FizzBuzz";
else if (i % 3 == 0) cout << "Fizz";
else if (i % 5 == 0) cout << "Buzz";',
'১৫, ৩ এবং ৫ — দুটোরই গুণিতক, তাই `15 % 15 == 0` সত্যি হয় এবং সবার আগে "FizzBuzz" প্রিন্ট হয় (else if চেইনে প্রথম সত্যি শর্তটাই চলে)।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Fizz',0),(@q,'B','Buzz',0),(@q,'C','FizzBuzz',1),(@q,'D','15',0);

-- ── OOP Basics ───────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_oop, 'classes-objects', 'ক্লাস ও অবজেক্ট', 'Classes & Objects',
'একটা **ক্লাস** হলো একটা ব্লুপ্রিন্ট — কী কী ডেটা (মেম্বার ভ্যারিয়েবল) আর কী কী কাজ (মেম্বার ফাংশন) থাকবে তার বর্ণনা। সেই ব্লুপ্রিন্ট থেকে তৈরি প্রতিটা জিনিসকে বলে **অবজেক্ট**। struct-এর সাথে মূল পার্থক্য: ক্লাসে ডেটা আর সেই ডেটা নিয়ে কাজ করা ফাংশন — দুটোই একসাথে থাকে।',
'#include <iostream>
using namespace std;

class Dog {
public:
    string name;
    void bark() {
        cout << name << " says Woof!" << endl;
    }
};

int main() {
    Dog d;
    d.name = "Tommy";
    d.bark();
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_oop, 'constructors', 'কনস্ট্রাক্টর', 'Constructors',
'একটা অবজেক্ট তৈরি হওয়ার সাথে সাথেই যদি কিছু ভ্যালু সেট করতে চান, তার জন্য **কনস্ট্রাক্টর** ব্যবহার হয় — ক্লাসের নামেই একটা বিশেষ ফাংশন, যেটা `new` অবজেক্ট তৈরি হওয়ার মুহূর্তেই অটোমেটিক্যালি চলে।',
'#include <iostream>
using namespace std;

class Dog {
public:
    string name;
    Dog(string n) { // constructor
        name = n;
    }
    void bark() { cout << name << " says Woof!" << endl; }
};

int main() {
    Dog d("Tommy"); // constructor runs here
    d.bark();
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_oop, 'encapsulation-access', 'এনক্যাপসুলেশন: public ও private', 'Encapsulation: Public & Private',
'ক্লাসের মেম্বারদের `public` (বাইরে থেকে সরাসরি অ্যাক্সেসযোগ্য) বা `private` (শুধু ক্লাসের নিজের ফাংশন থেকে অ্যাক্সেসযোগ্য) করা যায়। ডেটাকে `private` রেখে শুধু নির্দিষ্ট ফাংশনের (getter/setter) মাধ্যমে অ্যাক্সেস দেওয়াকে **এনক্যাপসুলেশন** বলে — এতে ভুল ভ্যালু সেট হওয়া ঠেকানো যায়।',
'#include <iostream>
using namespace std;

class Account {
private:
    double balance;
public:
    Account(double b) { balance = b; }
    void deposit(double amt) {
        if (amt > 0) balance += amt; // guards against invalid input
    }
    double getBalance() { return balance; }
};

int main() {
    Account acc(100);
    acc.deposit(50);
    cout << acc.getBalance() << endl; // 150
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_oop, 'oop-capstone-cpp', 'ক্যাপস্টোন: Rectangle ক্লাস', 'Capstone: A Rectangle Class',
'আগের তিনটা লেসনের সবকিছু একসাথে — একটা ক্লাস, একটা কনস্ট্রাক্টর, আর `private` ডেটার সাথে একটা পাবলিক মেথড, যা এরিয়া ক্যালকুলেট করে।',
'#include <iostream>
using namespace std;

class Rectangle {
private:
    double width, height;
public:
    Rectangle(double w, double h) {
        width = w;
        height = h;
    }
    double area() {
        return width * height;
    }
};

int main() {
    Rectangle r(5, 3);
    cout << "Area: " << r.area() << endl; // 15
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_oop AND slug='classes-objects';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_oop AND slug='constructors';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_oop AND slug='encapsulation-access';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_oop AND slug='oop-capstone-cpp';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'd.bark() কল করলে কী প্রিন্ট হবে?', 'What does d.bark() print?', 'Dog d;
d.name = "Tommy";
d.bark(); // prints name + " says Woof!"',
'`d.name`-কে `"Tommy"` সেট করা হয়েছে, তারপর `bark()` কল হলে সেই `name` ব্যবহার করেই প্রিন্ট করে — "Tommy says Woof!"।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Dog says Woof!',0),(@q,'B','Tommy says Woof!',1),(@q,'C','Woof!',0),(@q,'D','Compile error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'কনস্ট্রাক্টর কখন চলে?', 'When does a constructor run?', 'Dog d("Tommy"); // constructor runs here',
'কনস্ট্রাক্টর একটা নতুন অবজেক্ট তৈরি হওয়ার মুহূর্তেই অটোমেটিক্যালি চলে — এখানে `Dog d("Tommy")` লেখার সাথে সাথে `name = "Tommy"` সেট হয়ে যায়, আলাদা করে কল করতে হয় না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রোগ্রাম শেষ হওয়ার আগে',0),(@q,'B','অবজেক্ট তৈরি হওয়ার সাথে সাথেই, অটোমেটিক্যালি',1),(@q,'C','যখন bark() কল হয়',0),(@q,'D','আলাদা করে কল করতে হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'balance-কে private রাখার সুবিধা কী?', 'Why keep balance private?', 'private:
    double balance;
public:
    void deposit(double amt) {
        if (amt > 0) balance += amt;
    }',
'`private` রাখলে বাইরে থেকে সরাসরি `acc.balance = -1000` লিখে ভুল ভ্যালু বসানো যায় না — শুধু `deposit()`-এর মতো নিয়ন্ত্রিত ফাংশন দিয়েই বদলানো যায়, যেখানে ভ্যালিডেশন (যেমন `amt > 0` চেক) বসানো যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কোড ছোট হয়',0),(@q,'B','সরাসরি বাইরে থেকে অবৈধ ভ্যালু বসানো ঠেকানো যায়',1),(@q,'C','প্রোগ্রাম দ্রুত চলে',0),(@q,'D','কোনো সুবিধা নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'r.area() এর ফলাফল কত হবে?', 'What does r.area() return?', 'Rectangle r(5, 3);
cout << r.area();',
'কনস্ট্রাক্টর `width = 5`, `height = 3` সেট করে। `area()` রিটার্ন করে `width * height = 5 * 3 = 15`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','8',0),(@q,'B','15',1),(@q,'C','53',0),(@q,'D','Compile error',0);

-- ── Arrays, Strings & Vectors ───────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_cont, 'vectors-basics', 'ভেক্টর: সাইজ-বদলযোগ্য অ্যারে', 'Vectors: Resizable Arrays',
'C-এর অ্যারের সাইজ ফিক্সড, কিন্তু C++-এর `std::vector` দরকারমতো বড়-ছোট হতে পারে — তাই বাস্তব প্রোগ্রামে সাধারণ অ্যারের চেয়ে ভেক্টরই বেশি ব্যবহৃত হয়। `push_back()` দিয়ে শেষে নতুন এলিমেন্ট যোগ করা যায়।',
'#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> scores = {90, 85, 78};
    scores.push_back(95); // adds to the end

    cout << "Size: " << scores.size() << endl; // 4
    cout << "First: " << scores[0] << endl;
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_cont, 'cpp-strings', 'C++ স্ট্রিং: std::string', 'C++ Strings: std::string',
'C-তে স্ট্রিং মানে `char` অ্যারে, কিন্তু C++-এ `std::string` একটা পূর্ণ টাইপ — `+` দিয়ে জোড়া লাগানো, `.length()` দিয়ে দৈর্ঘ্য, আর `==` দিয়েই কনটেন্ট তুলনা করা যায় (C-এর `strcmp()` লাগে না)।',
'#include <iostream>
using namespace std;

int main() {
    string first = "Byte";
    string second = "wise";
    string full = first + second; // concatenation with +

    cout << full << endl;          // Bytewise
    cout << full.length() << endl; // 8
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_cont, 'range-based-for', 'range-based for লুপ', 'Range-Based For Loop',
'ভেক্টর বা অ্যারে লুপ করার সময় ইনডেক্স হাতে ম্যানেজ না করে **range-based for** ব্যবহার করলে কোড অনেক পরিষ্কার হয় — এটা সরাসরি প্রতিটা এলিমেন্ট একে একে দিয়ে দেয়।',
'#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> nums = {10, 20, 30};

    for (int n : nums) { // "for each n in nums"
        cout << n << " ";
    }
    cout << endl;
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_cont, 'containers-capstone-cpp', 'ক্যাপস্টোন: গড় বের করা', 'Capstone: Computing an Average',
'একটা ভেক্টরে বেশ কয়েকটা মার্কস রেখে, range-based for দিয়ে যোগফল বের করে, তারপর গড় ক্যালকুলেট করা হচ্ছে — ভেক্টর, লুপ, আর গাণিতিক অপারেটর, সব একসাথে।',
'#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> marks = {80, 90, 70, 60};
    int total = 0;

    for (int m : marks) {
        total += m;
    }
    double average = (double) total / marks.size();
    cout << "Average: " << average << endl; // 75
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_cont AND slug='vectors-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_cont AND slug='cpp-strings';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_cont AND slug='range-based-for';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_cont AND slug='containers-capstone-cpp';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'push_back(95) এর পর scores.size() কত হবে?', 'What is scores.size() after push_back(95)?', 'vector<int> scores = {90, 85, 78};
scores.push_back(95);',
'শুরুতে ভেক্টরে ৩টি এলিমেন্ট ছিল (90, 85, 78)। `push_back(95)` শেষে নতুন একটা এলিমেন্ট যোগ করে, তাই সাইজ হয়ে যায় ৪।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','4',1),(@q,'C','95',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'first + second এর ফলাফল কী?', 'What does first + second give?', 'string first = "Byte";
string second = "wise";
string full = first + second;',
'`std::string`-এর জন্য `+` অপারেটর কনক্যাটেনেশন (জোড়া লাগানো) করে — "Byte" আর "wise" জোড়া লেগে হয় "Bytewise"।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Byte wise (স্পেস সহ)',0),(@q,'B','Bytewise',1),(@q,'C','Compile error',0),(@q,'D','8 (দৈর্ঘ্য)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'for (int n : nums) — এখানে n কী বোঝায়?', 'What does n represent here?', 'vector<int> nums = {10, 20, 30};
for (int n : nums) { cout << n << " "; }',
'range-based for-এ `n` প্রতি ধাপে `nums`-এর একেকটা এলিমেন্টের মান ধারণ করে — প্রথম ধাপে 10, তারপর 20, তারপর 30। এখানে কোনো ইনডেক্স ম্যানুয়ালি ম্যানেজ করতে হয় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটা ইনডেক্স (0, 1, 2...)',0),(@q,'B','প্রতি ধাপে nums-এর একেকটা এলিমেন্টের মান',1),(@q,'C','পুরো vector-টা',0),(@q,'D','vector-এর সাইজ',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'নিচের কোডের average কত হবে?', 'What is the average here?', 'vector<int> marks = {80, 90, 70, 60};
// total = sum of all marks
double average = (double) total / marks.size();',
'যোগফল `80+90+70+60 = 300`, এলিমেন্ট সংখ্যা ৪টি। `300 / 4 = 75`। `(double)` cast না করলে `int` ভাগ হয়ে যেত, কিন্তু এখানে ভাগফল ঠিক পূর্ণসংখ্যা হওয়ায় ফলাফল একই থাকত।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','70',0),(@q,'B','75',1),(@q,'C','300',0),(@q,'D','4',0);

-- ── STL Basics ───────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_stl, 'stl-intro', 'STL পরিচিতি', 'Introduction to the STL',
'**Standard Template Library (STL)** হলো C++-এর সাথে আসা রেডিমেড ডেটা স্ট্রাকচার আর অ্যালগরিদমের একটা লাইব্রেরি — `vector` তার একটা অংশ মাত্র। এগুলো নিজে হাতে লেখার দরকার নেই — টেস্টেড, অপ্টিমাইজড কোড রেডি থাকে।',
'#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<string> languages = {"C", "C++", "Python"};
    cout << "Total languages: " << languages.size() << endl;
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_stl, 'stl-algorithms', '<algorithm> হেডার: sort() ও find()', 'The <algorithm> Header: sort() & find()',
'`<algorithm>` হেডারে অনেক রেডিমেড ফাংশন আছে। `sort()` একটা কনটেইনারকে সাজিয়ে দেয় (ডিফল্টে ascending), আর `find()` কোনো ভ্যালু খুঁজে বের করে।',
'#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    vector<int> nums = {5, 2, 8, 1};
    sort(nums.begin(), nums.end());

    for (int n : nums) cout << n << " "; // 1 2 5 8
    cout << endl;
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_stl, 'maps-sets', 'map ও set পরিচিতি', 'Introduction to map & set',
'`std::map` key-value পেয়ার রাখে (Python-এর dict-এর মতো), আর `std::set` শুধু ইউনিক ভ্যালু রাখে (ডুপ্লিকেট নিজে থেকেই বাদ পড়ে যায়)। দুটোই স্বয়ংক্রিয়ভাবে সর্টেড থাকে।',
'#include <iostream>
#include <map>
using namespace std;

int main() {
    map<string, int> ages;
    ages["Rafi"] = 20;
    ages["Nadia"] = 22;

    cout << ages["Rafi"] << endl; // 20
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_stl, 'stl-capstone', 'ক্যাপস্টোন: সর্ট করে সবচেয়ে ছোট বের করা', 'Capstone: Sort & Find the Smallest',
'একটা ভেক্টর সর্ট করে তার প্রথম এলিমেন্টটাই যে সবচেয়ে ছোট ভ্যালু, সেটা প্রিন্ট করা হচ্ছে — sort() আর ভেক্টর ইনডেক্সিং একসাথে ব্যবহার করে।',
'#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main() {
    vector<int> nums = {45, 12, 78, 3, 90};
    sort(nums.begin(), nums.end());
    cout << "Smallest: " << nums[0] << endl; // 3
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_stl AND slug='stl-intro';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_stl AND slug='stl-algorithms';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_stl AND slug='maps-sets';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_stl AND slug='stl-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'languages.size() কত রিটার্ন করবে?', 'What does languages.size() return?', 'vector<string> languages = {"C", "C++", "Python"};
cout << languages.size();',
'ভেক্টরে ৩টা স্ট্রিং আছে ("C", "C++", "Python"), তাই `size()` রিটার্ন করে `3`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','2',0),(@q,'B','3',1),(@q,'C','C++',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'sort() এর পর nums এর প্রথম এলিমেন্ট কী হবে?', 'What is the first element after sort()?', 'vector<int> nums = {5, 2, 8, 1};
sort(nums.begin(), nums.end());',
'`sort()` ডিফল্টভাবে ছোট থেকে বড় (ascending) সাজায় — {5,2,8,1} সর্ট হয়ে হবে {1,2,5,8}। তাই প্রথম এলিমেন্ট (`nums[0]`) হলো `1`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','1',1),(@q,'C','8',0),(@q,'D','অপরিবর্তিত থাকবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'ages["Rafi"] এর মান কত হবে?', 'What is ages["Rafi"]?', 'map<string, int> ages;
ages["Rafi"] = 20;
ages["Nadia"] = 22;',
'`map`-এ `"Rafi"` কী-এর সাথে `20` ভ্যালুটা এক্সপ্লিসিটভাবে সেট করা হয়েছে, তাই `ages["Rafi"]` হলো `20`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','20',1),(@q,'B','22',0),(@q,'C','Rafi',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'sort() এর পর nums[0] এ কী থাকবে?', 'What is nums[0] after sort()?', 'vector<int> nums = {45, 12, 78, 3, 90};
sort(nums.begin(), nums.end());',
'সর্ট করার পর {45,12,78,3,90} হয়ে যায় {3,12,45,78,90} (ছোট থেকে বড়)। তাই `nums[0]` (প্রথম এলিমেন্ট) হলো `3` — অ্যারের সবচেয়ে ছোট ভ্যালু।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','45',0),(@q,'B','90',0),(@q,'C','3',1),(@q,'D','12',0);

-- ── Pointers & References ───────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_ptr, 'cpp-pointers', 'পয়েন্টার রিক্যাপ', 'Pointers Recap',
'C++-এর পয়েন্টার C-এর মতোই কাজ করে — `&` দিয়ে অ্যাড্রেস, `*` দিয়ে dereference। তবে C++-এ প্রায়ই পয়েন্টারের বদলে **রেফারেন্স** ব্যবহার করা হয়, যা পরের লেসনে দেখা যাবে — সেটা লিখতে সহজ এবং নিরাপদ।',
'#include <iostream>
using namespace std;

int main() {
    int age = 25;
    int *ptr = &age;
    cout << *ptr << endl; // 25
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_ptr, 'references', 'রেফারেন্স: পয়েন্টারের সহজ বিকল্প', 'References: A Simpler Alternative to Pointers',
'একটা **রেফারেন্স** (`&`) হলো একই ভেরিয়েবলের আরেকটা নাম — কোনো `*` দিয়ে dereference করার দরকার নেই, সরাসরি ব্যবহার করা যায়। রেফারেন্স একবার কোনো ভেরিয়েবলের সাথে বাঁধা হলে, সেটা আর অন্য ভেরিয়েবলের দিকে নির্দেশ করতে পারে না (পয়েন্টারের মতো "রিসিট" করা যায় না)।',
'#include <iostream>
using namespace std;

int main() {
    int age = 25;
    int &ref = age; // ref is another name for age

    ref = 30; // this changes age too!
    cout << age << endl; // 30
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_ptr, 'pass-by-reference', 'ফাংশনে pass-by-reference', 'Pass-by-Reference in Functions',
'ফাংশনের প্যারামিটার রেফারেন্স হিসেবে নিলে (`int &x`), ফাংশনের ভেতরে পরিবর্তন সরাসরি আসল ভেরিয়েবলে প্রতিফলিত হয় — C-তে যেটা করতে পয়েন্টার (`int *x`) আর `*x` লিখতে হতো, C++-এ সেটা রেফারেন্স দিয়ে সহজেই করা যায়।',
'#include <iostream>
using namespace std;

void increment(int &x) { // reference parameter
    x++;
}

int main() {
    int num = 5;
    increment(num); // no & needed at call site
    cout << num << endl; // 6
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_ptr, 'reference-swap-capstone', 'ক্যাপস্টোন: রেফারেন্স দিয়ে swap', 'Capstone: Swap with References',
'C-তে পয়েন্টার দিয়ে swap লেখা হয়েছিল — এবার সেই একই কাজ C++-এর রেফারেন্স দিয়ে, আরও পরিষ্কারভাবে, কোনো `*` বা `&` (কল করার সময়) ছাড়াই।',
'#include <iostream>
using namespace std;

void swap(int &a, int &b) {
    int temp = a;
    a = b;
    b = temp;
}

int main() {
    int x = 1, y = 2;
    swap(x, y); // no & needed here
    cout << "x=" << x << " y=" << y << endl; // x=2 y=1
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_ptr AND slug='cpp-pointers';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_ptr AND slug='references';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_ptr AND slug='pass-by-reference';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_ptr AND slug='reference-swap-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, '*ptr এর মান কী হবে?', 'What is *ptr?', 'int age = 25;
int *ptr = &age;
cout << *ptr;',
'`ptr`-এ `age`-এর অ্যাড্রেস আছে। `*ptr` dereference করলে সেই অ্যাড্রেসের ভ্যালু পাওয়া যায় — `25`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','25',1),(@q,'B','একটা অ্যাড্রেস',0),(@q,'C','0',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'ref = 30; এর পর age এর মান কত হবে?', 'What is age after ref = 30?', 'int age = 25;
int &ref = age;
ref = 30;
cout << age;',
'`ref` হলো `age`-এর আরেকটা নাম, একই মেমোরি লোকেশন — তাই `ref`-কে বদলানো মানে সরাসরি `age`-কেই বদলানো। ফলে `age` হয়ে যায় `30`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','25 (অপরিবর্তিত)',0),(@q,'B','30',1),(@q,'C','0',0),(@q,'D','Compile error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'increment(num) কল করার পর num এর মান কত?', 'What is num after increment(num)?', 'void increment(int &x) { x++; }
int num = 5;
increment(num);',
'`x` একটা রেফারেন্স প্যারামিটার — `num`-এরই আরেকটা নাম হয়ে যায়, কোনো কপি তৈরি হয় না। `x++` সরাসরি `num`-কেই বাড়ায়, তাই `num` হয় `6`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5 (অপরিবর্তিত)',0),(@q,'B','6',1),(@q,'C','Error',0),(@q,'D','undefined',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'swap(x, y) কল করার পর x ও y এর মান কত হবে?', 'What are x and y after swap(x, y)?', 'void swap(int &a, int &b) {
    int temp = a; a = b; b = temp;
}
int x = 1, y = 2;
swap(x, y);',
'রেফারেন্স প্যারামিটার হওয়ায় `a` আর `b` সরাসরি `x` আর `y`-কেই নির্দেশ করে — ফাংশনের ভেতরের অদল-বদল সরাসরি আসল ভেরিয়েবলে প্রতিফলিত হয়। ফলাফল: `x=2, y=1`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','x=1, y=2 (অপরিবর্তিত)',0),(@q,'B','x=2, y=1',1),(@q,'C','Compile error',0),(@q,'D','x=0, y=0',0);
