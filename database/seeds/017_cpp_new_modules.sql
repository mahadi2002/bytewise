-- C++ track: 2 new OOP lessons (Inheritance, Polymorphism — capstone
-- already renumbered to slot 6 by 015) + Exception Handling + Templates &
-- More STL (new modules 7-8).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_cpp FROM languages WHERE slug = 'cpp';
SELECT id INTO @m_oop  FROM modules WHERE language_id=@lang_cpp AND slug='oop';
SELECT id INTO @m_exc  FROM modules WHERE language_id=@lang_cpp AND slug='exceptions';
SELECT id INTO @m_tmpl FROM modules WHERE language_id=@lang_cpp AND slug='templates';

-- ── OOP expansion: Inheritance, Polymorphism ────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_oop, 'inheritance-cpp', 'ইনহেরিটেন্স', 'Inheritance',
'একটা ক্লাস আরেকটা ক্লাসের সব ফিল্ড ও মেথড "উত্তরাধিকার সূত্রে" পেতে পারে `: public` সিনট্যাক্স দিয়ে — একই কোড বারবার লিখতে হয় না। চাইল্ড ক্লাসের কনস্ট্রাক্টর থেকে প্যারেন্টের কনস্ট্রাক্টর কল করতে ইনিশিয়ালাইজার লিস্ট ব্যবহার হয়।',
'#include <iostream>
using namespace std;

class Animal {
public:
    string name;
    Animal(string n) : name(n) {}
    void eat() { cout << name << " is eating" << endl; }
};

class Dog : public Animal {
public:
    Dog(string n) : Animal(n) {} // calls Animal''s constructor
};

int main() {
    Dog d("Tommy");
    d.eat(); // inherited from Animal
    return 0;
}',
'cpp', 10, 0, 4, 0),

(@m_oop, 'polymorphism-cpp', 'পলিমরফিজম: virtual ফাংশন', 'Polymorphism: Virtual Functions',
'একটা মেথডকে `virtual` ঘোষণা করলে, চাইল্ড ক্লাস সেটাকে নিজের মতো করে ওভাররাইড করতে পারে — আর প্যারেন্ট-টাইপের পয়েন্টার/রেফারেন্স দিয়ে কল করলেও *আসল* (চাইল্ডের) ভার্সনটাই চলে। এটাকে **পলিমরফিজম** বলে — `virtual` ছাড়া এটা কাজ করবে না।',
'#include <iostream>
using namespace std;

class Animal {
public:
    virtual void makeSound() { cout << "Some sound" << endl; }
};

class Dog : public Animal {
public:
    void makeSound() override { cout << "Woof!" << endl; }
};

int main() {
    Animal *a = new Dog();
    a->makeSound(); // "Woof!" — the Dog version runs
    delete a;
    return 0;
}',
'cpp', 10, 0, 5, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_oop AND slug='inheritance-cpp';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_oop AND slug='polymorphism-cpp';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'd.eat() কল করা যাচ্ছে কেন, যদিও Dog ক্লাসে eat() লেখাই হয়নি?', 'Why can d.eat() be called if Dog never defines eat()?', 'class Dog : public Animal { ... };
d.eat();',
'`Dog : public Animal` মানে `Dog`, `Animal`-কে ইনহেরিট করেছে — তাই `Animal`-এর সব পাবলিক মেথড (যেমন `eat()`) অটোমেটিক্যালি `Dog`-ও পেয়ে যায়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা কম্পাইল এরর দেবে',0),(@q,'B','Dog, Animal থেকে eat() ইনহেরিট করেছে',1),(@q,'C','C++ নিজে থেকে eat() লিখে দেয়',0),(@q,'D','এটা একটা টাইপো',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'a->makeSound() কী প্রিন্ট করবে?', 'What does a->makeSound() print?', 'Animal *a = new Dog();
a->makeSound();',
'`a` একটা `Animal*` টাইপের পয়েন্টার হলেও, এটা আসলে একটা `Dog` অবজেক্টকে নির্দেশ করছে। `makeSound()` `virtual` হওয়ায়, C++ রানটাইমে দেখে নেয় *আসল* অবজেক্টটা কী টাইপের — তাই `Dog`-এর ওভাররাইড করা ভার্সন ("Woof!") চলে, `Animal`-এরটা নয়।', 5);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=5;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Some sound',0),(@q,'B','Woof!',1),(@q,'C','দুটোই প্রিন্ট হবে',0),(@q,'D','Compile error',0);

-- ── Exception Handling ───────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_exc, 'try-catch-cpp', 'try, catch ও throw', 'try, catch & throw',
'C-তে এরর হ্যান্ডলিং রিটার্ন ভ্যালু চেক করে করতে হতো — C++-এ `try`/`catch`/`throw` দিয়ে আরও পরিষ্কারভাবে করা যায়। `try` ব্লকের ভেতর কোনো সমস্যা হলে `throw` দিয়ে একটা এক্সেপশন "ছুড়ে" দেওয়া হয়, আর সেটা `catch` ব্লক ধরে ফেলে।',
'#include <iostream>
using namespace std;

int divide(int a, int b) {
    if (b == 0) {
        throw runtime_error("Division by zero!");
    }
    return a / b;
}

int main() {
    try {
        cout << divide(10, 0) << endl;
    } catch (const runtime_error &e) {
        cout << "Caught: " << e.what() << endl;
    }
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_exc, 'exception-types', 'বিল্ট-ইন এক্সেপশন টাইপ', 'Built-in Exception Types',
'`<stdexcept>` হেডারে কিছু রেডিমেড এক্সেপশন ক্লাস আছে — `runtime_error`, `out_of_range`, `invalid_argument` ইত্যাদি। এগুলো ব্যবহার করলে নিজে থেকে নতুন এক্সেপশন ক্লাস বানাতে হয় না, আর কোড অন্যদের কাছে সহজে বোঝা যায়।',
'#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> nums = {1, 2, 3};
    try {
        cout << nums.at(10) << endl; // .at() throws out_of_range
    } catch (const out_of_range &e) {
        cout << "Out of range: " << e.what() << endl;
    }
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_exc, 'multiple-catch', 'একাধিক catch ব্লক', 'Multiple catch Blocks',
'একটা `try`-এর পর একাধিক `catch` ব্লক থাকতে পারে, প্রতিটা ভিন্ন টাইপের এক্সেপশনের জন্য — C++ প্রথম যেটার সাথে মিলে যায় সেটাই চালায়। `catch (...)` দিয়ে "যেকোনো টাইপের" এক্সেপশন ধরা যায়, সাধারণত সবার শেষে।',
'#include <iostream>
using namespace std;

int main() {
    try {
        throw invalid_argument("bad input");
    } catch (const out_of_range &e) {
        cout << "Range error" << endl;
    } catch (const invalid_argument &e) {
        cout << "Invalid: " << e.what() << endl;
    } catch (...) {
        cout << "Unknown error" << endl;
    }
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_exc, 'exceptions-capstone', 'ক্যাপস্টোন: নিরাপদ ক্যালকুলেটর', 'Capstone: A Safe Calculator',
'একটা ফাংশন যা শূন্য দিয়ে ভাগ করলে exception ছোড়ে, আর `main()`-এ সেটা ধরে প্রোগ্রাম ক্র্যাশ না করিয়ে একটা পরিষ্কার মেসেজ দেখায়।',
'#include <iostream>
using namespace std;

double safeDivide(double a, double b) {
    if (b == 0) {
        throw runtime_error("Cannot divide by zero");
    }
    return a / b;
}

int main() {
    try {
        cout << safeDivide(10, 2) << endl; // 5
        cout << safeDivide(10, 0) << endl; // throws
    } catch (const runtime_error &e) {
        cout << "Error: " << e.what() << endl;
    }
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_exc AND slug='try-catch-cpp';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_exc AND slug='exception-types';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_exc AND slug='multiple-catch';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_exc AND slug='exceptions-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'divide(10, 0) কল করলে কী হবে?', 'What happens calling divide(10, 0)?', 'if (b == 0) throw runtime_error("Division by zero!");
...
try { divide(10, 0); } catch (const runtime_error &e) { ... }',
'`b == 0` সত্যি হওয়ায় `throw` চলে — এটা সরাসরি `try` ব্লক থেকে বেরিয়ে সংশ্লিষ্ট `catch` ব্লকে চলে যায়, ফাংশনের বাকি কোড (এখানে `a / b`) আর চলে না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রোগ্রাম ক্র্যাশ করে',0),(@q,'B','catch ব্লকে চলে যায়, "Caught: ..." প্রিন্ট হয়',1),(@q,'C','0 রিটার্ন করে',0),(@q,'D','ইনফিনিট লুপ হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'nums.at(10) কেন exception ছোড়ে?', 'Why does nums.at(10) throw?', 'vector<int> nums = {1, 2, 3};
nums.at(10);',
'`nums`-এ মাত্র ৩টা এলিমেন্ট আছে (ইনডেক্স 0-2), কিন্তু `.at(10)` ইনডেক্স ১০ চাইছে, যা অ্যারের সীমার বাইরে — `.at()` (সাধারণ `[]`-এর বদলে) এই ভুলটা ধরে `out_of_range` এক্সেপশন ছোড়ে, চুপচাপ undefined behavior না দিয়ে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ইনডেক্স 10 অ্যারের সীমার বাইরে',1),(@q,'B','vector-এ .at() মেথড নেই',0),(@q,'C','10 একটা অবৈধ সংখ্যা',0),(@q,'D','এটা কখনো এক্সেপশন ছোড়ে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'throw invalid_argument("bad input") হলে কোন catch ব্লক চলবে?', 'Which catch block runs?', 'try { throw invalid_argument("bad input"); }
catch (const out_of_range &e) { ... }
catch (const invalid_argument &e) { ... }
catch (...) { ... }',
'C++ ছোড়া এক্সেপশনের টাইপের সাথে মিলে যাওয়া প্রথম `catch` ব্লক খুঁজে বের করে — এখানে `invalid_argument` টাইপ মিলে যায় দ্বিতীয় `catch`-এর সাথে, তাই সেটাই চলে, `catch (...)`-এ যাওয়ার দরকার হয় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রথম catch (out_of_range)',0),(@q,'B','দ্বিতীয় catch (invalid_argument)',1),(@q,'C','catch (...)',0),(@q,'D','কোনোটাই না, প্রোগ্রাম ক্র্যাশ করে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'safeDivide(10, 0) কল করার পর প্রোগ্রামের কী হবে?', 'What happens after safeDivide(10, 0)?', 'try {
    cout << safeDivide(10, 2) << endl; // 5
    cout << safeDivide(10, 0) << endl; // throws
} catch (const runtime_error &e) {
    cout << "Error: " << e.what() << endl;
}',
'প্রথম কলটা স্বাভাবিকভাবে `5` প্রিন্ট করে। দ্বিতীয় কলে `b == 0` হওয়ায় exception ছোড়ে, `try` ব্লক তৎক্ষণাৎ থেমে যায় (দ্বিতীয় `cout` লাইনের বাকি অংশ আর চলে না) এবং `catch` ব্লকে গিয়ে "Error: Cannot divide by zero" প্রিন্ট হয় — প্রোগ্রাম ক্র্যাশ করে না।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রোগ্রাম ক্র্যাশ করে',0),(@q,'B','"Error: Cannot divide by zero" প্রিন্ট হয়ে প্রোগ্রাম চলতে থাকে',1),(@q,'C','কিছুই প্রিন্ট হয় না',0),(@q,'D','ইনফিনিট লুপ হয়',0);

-- ── Templates & More STL ─────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_tmpl, 'function-templates', 'ফাংশন টেমপ্লেট', 'Function Templates',
'একই লজিকের জন্য `int`, `double`, `string` — প্রতিটা টাইপে আলাদা ফাংশন লেখার বদলে, **টেমপ্লেট** দিয়ে একটাই "জেনেরিক" ফাংশন লেখা যায়, যা যেকোনো টাইপে কাজ করে। কম্পাইলার ব্যবহারের সময় দেখে নেয় কোন টাইপ লাগবে।',
'#include <iostream>
using namespace std;

template <typename T>
T maxOf(T a, T b) {
    return (a > b) ? a : b;
}

int main() {
    cout << maxOf(3, 7) << endl;       // works with int
    cout << maxOf(2.5, 1.2) << endl;   // works with double
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_tmpl, 'stack-queue-stl', 'STL-এর stack ও queue', 'STL''s stack & queue',
'জেনেরিক ডেটা স্ট্রাকচার ট্র্যাকে stack/queue *কনসেপ্ট* শেখা হয়েছিল — C++-এর STL-এ সেগুলোর রেডিমেড ইমপ্লিমেন্টেশন আছে: `std::stack` (LIFO) আর `std::queue` (FIFO), নিজে হাতে লেখার দরকার নেই।',
'#include <iostream>
#include <stack>
#include <queue>
using namespace std;

int main() {
    stack<int> s;
    s.push(1); s.push(2); s.push(3);
    cout << s.top() << endl; // 3 (last in)

    queue<int> q;
    q.push(1); q.push(2); q.push(3);
    cout << q.front() << endl; // 1 (first in)
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_tmpl, 'sets-stl', 'STL-এর set', 'STL''s set',
'`std::set` স্বয়ংক্রিয়ভাবে সর্টেড থাকে এবং শুধু ইউনিক ভ্যালু রাখে — একই ভ্যালু দুইবার `insert()` করলে দ্বিতীয়টা চুপচাপ উপেক্ষা করা হয়। ডুপ্লিকেট বাদ দেওয়া বা কোনো ভ্যালু আছে কিনা `O(log n)`-এ চেক করার জন্য এটা খুবই কাজের।',
'#include <iostream>
#include <set>
using namespace std;

int main() {
    set<int> s;
    s.insert(5);
    s.insert(2);
    s.insert(5); // duplicate — ignored
    s.insert(8);

    cout << s.size() << endl; // 3, not 4
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_tmpl, 'templates-capstone-cpp', 'ক্যাপস্টোন: জেনেরিক stack ব্যবহার করে ব্যালান্স চেক', 'Capstone: Balanced Brackets with a Generic Stack',
'একটা ক্লাসিক প্রবলেম — `std::stack` ব্যবহার করে একটা স্ট্রিংয়ের ব্র্যাকেট ব্যালান্সড কিনা চেক করা, DS ট্র্যাকের কনসেপ্টটাই এবার STL দিয়ে বাস্তবায়ন করে।',
'#include <iostream>
#include <stack>
using namespace std;

bool isBalanced(string s) {
    stack<char> st;
    for (char ch : s) {
        if (ch == ''('') st.push(ch);
        else if (ch == '')'') {
            if (st.empty()) return false;
            st.pop();
        }
    }
    return st.empty();
}

int main() {
    cout << isBalanced("(())") << endl; // 1 (true)
    cout << isBalanced("(()")  << endl; // 0 (false)
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_tmpl AND slug='function-templates';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_tmpl AND slug='stack-queue-stl';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_tmpl AND slug='sets-stl';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_tmpl AND slug='templates-capstone-cpp';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'maxOf(3, 7) এবং maxOf(2.5, 1.2) একই ফাংশন দিয়ে কাজ করছে কীভাবে?', 'How does the same function work for both calls?', 'template <typename T>
T maxOf(T a, T b) { return (a > b) ? a : b; }',
'`template <typename T>` দিয়ে `T` একটা "যেকোনো টাইপ" হিসেবে কাজ করে — কম্পাইলার প্রতিটা কলের আর্গুমেন্ট দেখে সেই টাইপের জন্য আলাদা ভার্সন তৈরি করে দেয় (একবার `int`-এর জন্য, একবার `double`-এর জন্য)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','টেমপ্লেট প্যারামিটার T যেকোনো টাইপে বসতে পারে',1),(@q,'B','এটা আসলে দুটো আলাদা ফাংশন',0),(@q,'C','C++ স্বয়ংক্রিয়ভাবে টাইপ কনভার্ট করে',0),(@q,'D','এটা কম্পাইলই হবে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 's.top() এর মান কত হবে?', 'What is s.top()?', 'stack<int> s;
s.push(1); s.push(2); s.push(3);
s.top();',
'`stack` হলো LIFO — সবশেষে push হওয়া `3` সবার উপরে থাকবে, তাই `.top()` রিটার্ন করবে `3`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','1',0),(@q,'B','3',1),(@q,'C','2',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 's.size() এর মান কত হবে?', 'What is s.size()?', 'set<int> s;
s.insert(5); s.insert(2); s.insert(5); s.insert(8);
s.size();',
'`set` শুধু ইউনিক ভ্যালু রাখে — `5` দুইবার insert করা হলেও দ্বিতীয়টা উপেক্ষা করা হয়। তাই সেটে থাকে {2, 5, 8}, সাইজ `3`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','4',0),(@q,'B','3',1),(@q,'C','2',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'isBalanced("(()") কী রিটার্ন করবে?', 'What does isBalanced("(()") return?', 'bool isBalanced(string s) {
    stack<char> st;
    // ( pushes, ) pops — must end empty to be balanced
}',
'"(()"-এ ৩টা "(" আর ১টা ")" আছে — দুটো "(" push হয়, একটা ")" একটা "(" pop করে, কিন্তু শেষে স্ট্যাকে একটা "(" থেকে যায় (খালি নয়), তাই `isBalanced` `false` (0) রিটার্ন করে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','true (1)',0),(@q,'B','false (0)',1),(@q,'C','Error',0),(@q,'D','খালি স্ট্রিং',0);
