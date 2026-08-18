-- C++ track: Enums & Namespaces (new module 9).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_cpp FROM languages WHERE slug = 'cpp';
SELECT id INTO @m_enum FROM modules WHERE language_id=@lang_cpp AND slug='enums-namespaces';

INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_enum, 'enum-class-cpp', 'enum ও enum class', 'enum & enum class',
'C++-এ সাধারণ `enum` C-এর মতোই কাজ করে, কিন্তু আধুনিক C++ **`enum class`** পছন্দ করে — এর মেম্বারগুলো বাইরে থেকে সরাসরি অ্যাক্সেসযোগ্য নয় (`Color::RED` লিখতে হয়, শুধু `RED` নয়), যা নাম-সংঘর্ষ ঠেকায় এবং টাইপ-নিরাপদ।',
'#include <iostream>
using namespace std;

enum class Color { RED, GREEN, BLUE };

int main() {
    Color c = Color::GREEN;
    if (c == Color::GREEN) {
        cout << "It is green" << endl;
    }
    return 0;
}',
'cpp', 10, 0, 1, 0),

(@m_enum, 'namespace-basics', 'নেমস্পেস: নাম-সংঘর্ষ এড়ানো', 'Namespaces: Avoiding Name Collisions',
'বড় প্রোজেক্টে একই নামের দুটো ফাংশন/ক্লাস বিভিন্ন লাইব্রেরি থেকে আসতে পারে — **নেমস্পেস** দিয়ে সেগুলো আলাদা "গ্রুপে" রাখা যায়, নাম-সংঘর্ষ এড়াতে। `using namespace std;` আসলে `std` নেমস্পেসের সবকিছু সরাসরি ব্যবহারযোগ্য করে দেয়, যা এতদিন ব্যবহার করা হয়েছে।',
'#include <iostream>
using namespace std;

namespace Math {
    int square(int x) { return x * x; }
}

int main() {
    cout << Math::square(5) << endl; // 25, must qualify with Math::
    return 0;
}',
'cpp', 10, 0, 2, 0),

(@m_enum, 'nested-namespaces', 'নেস্টেড নেমস্পেস', 'Nested Namespaces',
'একটা নেমস্পেসের ভেতরে আরেকটা নেমস্পেস রাখা যায় — বড় প্রোজেক্টে সংগঠিত রাখতে (যেমন `Company::Module::function()`)। C++17 থেকে `namespace A::B { ... }` লিখে সংক্ষেপেও লেখা যায়, প্রতিটার জন্য আলাদা `namespace` ব্লক না লিখেই।',
'#include <iostream>
using namespace std;

namespace App {
    namespace Utils {
        int doubleIt(int x) { return x * 2; }
    }
}

int main() {
    cout << App::Utils::doubleIt(5) << endl; // 10
    return 0;
}',
'cpp', 10, 0, 3, 0),

(@m_enum, 'enum-namespace-capstone', 'ক্যাপস্টোন: নেমস্পেসে থাকা enum class', 'Capstone: An enum class Inside a Namespace',
'একটা নেমস্পেসের ভেতরে `enum class` রেখে, দুটো ধারণাই একসাথে ব্যবহার করা হচ্ছে — একটা ছোট স্টেটাস-চেকিং প্রোগ্রাম।',
'#include <iostream>
using namespace std;

namespace Order {
    enum class Status { PENDING, SHIPPED, DELIVERED };
}

int main() {
    Order::Status s = Order::Status::SHIPPED;
    if (s == Order::Status::SHIPPED) {
        cout << "Your order is on the way!" << endl;
    }
    return 0;
}',
'cpp', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_enum AND slug='enum-class-cpp';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_enum AND slug='namespace-basics';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_enum AND slug='nested-namespaces';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_enum AND slug='enum-namespace-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'enum class Color-এর GREEN মেম্বার অ্যাক্সেস করতে কী লিখতে হয়?', 'How do you access GREEN?', 'enum class Color { RED, GREEN, BLUE };
Color c = ???;',
'`enum class`-এর মেম্বার সরাসরি (শুধু `GREEN`) অ্যাক্সেসযোগ্য নয় — এনামের নাম দিয়ে qualify করতে হয়: `Color::GREEN`। এটাই সাধারণ `enum`-এর চেয়ে `enum class`-এর মূল পার্থক্য।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','GREEN',0),(@q,'B','Color::GREEN',1),(@q,'C','Color.GREEN',0),(@q,'D','enum::GREEN',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'Math::square(5) এ Math:: কেন লিখতে হয়েছে?', 'Why is Math:: needed here?', 'namespace Math {
    int square(int x) { return x * x; }
}
Math::square(5);',
'`square` ফাংশনটা `Math` নেমস্পেসের ভেতরে ঘোষণা করা হয়েছে, তাই সেটা অ্যাক্সেস করতে নেমস্পেসের নাম দিয়ে qualify করতে হয় (`Math::square`) — এটাই নেমস্পেসের কাজ, একই নামের ফাংশন অন্য কোথাও থাকলেও সংঘর্ষ হবে না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','square, Math নেমস্পেসের ভেতরে ঘোষিত',1),(@q,'B','এটা একটা টাইপো, দরকার নেই',0),(@q,'C','square একটা কিওয়ার্ড',0),(@q,'D','Math:: ঐচ্ছিক এবং কোনো প্রভাব ফেলে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'App::Utils::doubleIt(5) এর ফলাফল কত হবে?', 'What does App::Utils::doubleIt(5) return?', 'namespace App { namespace Utils {
    int doubleIt(int x) { return x * 2; }
} }
App::Utils::doubleIt(5);',
'`doubleIt` নেস্টেড নেমস্পেস `App::Utils`-এর ভেতরে আছে, তাই পুরো পথ দিয়ে qualify করতে হয়। ফাংশনটা `5 * 2 = 10` রিটার্ন করে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','10',1),(@q,'C','Compile error',0),(@q,'D','25',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 's == Order::Status::SHIPPED কখন সত্যি হবে?', 'When is this comparison true?', 'Order::Status s = Order::Status::SHIPPED;
s == Order::Status::SHIPPED',
'`s`-কে ঠিক `Order::Status::SHIPPED` দিয়েই ইনিশিয়ালাইজ করা হয়েছে, তাই তুলনাটা সত্যি হবে এবং "Your order is on the way!" প্রিন্ট হবে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সত্যি',1),(@q,'B','মিথ্যা',0),(@q,'C','Compile error',0),(@q,'D','সবসময় অনির্দিষ্ট',0);
