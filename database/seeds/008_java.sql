-- Java track: finish Basics (3 more) + all 5 remaining modules.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'java';
SELECT id INTO @m_basics FROM modules WHERE language_id=@lang AND slug='basics';
SELECT id INTO @m_cf     FROM modules WHERE language_id=@lang AND slug='control-flow';
SELECT id INTO @m_meth   FROM modules WHERE language_id=@lang AND slug='methods';
SELECT id INTO @m_arr    FROM modules WHERE language_id=@lang AND slug='arrays-strings';
SELECT id INTO @m_oop    FROM modules WHERE language_id=@lang AND slug='oop';
SELECT id INTO @m_inh    FROM modules WHERE language_id=@lang AND slug='inheritance';

-- ── Basics (lessons 2-4) ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_basics, 'input-scanner', 'ইনপুট নেওয়া: Scanner', 'Taking Input: Scanner',
'জাভাতে ইউজারের থেকে ইনপুট নিতে `Scanner` ক্লাস ব্যবহার হয় (`java.util` প্যাকেজ থেকে `import` করতে হয়)। `nextInt()` দিয়ে একটা সংখ্যা, `nextLine()` দিয়ে একটা পুরো লাইন টেক্সট পড়া যায়।',
'import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("Enter your age: ");
        int age = sc.nextInt();
        System.out.println("You are " + age + " years old.");
    }
}',
'java', 10, 0, 2, 0),

(@m_basics, 'operators-java', 'অপারেটর', 'Operators',
'জাভার গাণিতিক ও তুলনামূলক অপারেটর C/C++-এর মতোই — `+ - * / %` এবং `== != < > <= >=`। দুটো `int` ভাগ করলে ফলাফলও `int` হয়, দশমিক অংশ কেটে যায়।',
'public class Main {
    public static void main(String[] args) {
        int a = 7, b = 2;
        System.out.println(a / b);          // 3
        System.out.println((double) a / b); // 3.5
    }
}',
'java', 10, 0, 3, 0),

(@m_basics, 'first-program-java', 'প্রথম ক্যালকুলেশন প্রোগ্রাম', 'Your First Calculation Program',
'ভেরিয়েবল ঘোষণা, `Scanner` দিয়ে ইনপুট নেওয়া, একটা ফর্মুলা ক্যালকুলেট করা, আর `println()` দিয়ে ফলাফল প্রিন্ট করা — সব একসাথে।',
'import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        double weight = sc.nextDouble();
        double height = sc.nextDouble();
        double bmi = weight / (height * height);
        System.out.println(bmi);
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_basics AND slug='input-scanner';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_basics AND slug='operators-java';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_basics AND slug='first-program-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'একটা পূর্ণসংখ্যা ইনপুট নিতে Scanner-এর কোন মেথড ব্যবহার হয়?', 'Which Scanner method reads an integer?', 'Scanner sc = new Scanner(System.in);
int age = sc.nextInt();',
'`nextInt()` মেথডটি ইনপুট স্ট্রিম থেকে পরবর্তী টোকেনটি একটা `int` হিসেবে পড়ে। টেক্সট লাইন পড়তে `nextLine()`, আর দশমিক সংখ্যার জন্য `nextDouble()` ব্যবহার হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','nextLine()',0),(@q,'B','nextInt()',1),(@q,'C','read()',0),(@q,'D','scan()',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'a / b এর আউটপুট কত হবে?', 'What does a / b print?', 'int a = 7, b = 2;
System.out.println(a / b);',
'`a` আর `b` দুটোই `int`, তাই ভাগের ফলাফলও `int` — দশমিক অংশ কেটে যায়। `7 / 2 = 3`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3.5',0),(@q,'B','3',1),(@q,'C','4',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'sc.nextDouble() কী রিটার্ন করে?', 'What does sc.nextDouble() return?', 'double weight = sc.nextDouble();',
'`nextDouble()` ইনপুট থেকে একটা দশমিক সংখ্যা (`double` টাইপ) পড়ে নিয়ে আসে — যেমন ওজন বা উচ্চতার মতো ভগ্নাংশ ভ্যালুর জন্য এটাই ব্যবহার হয়, `nextInt()` নয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একটা পূর্ণসংখ্যা',0),(@q,'B','একটা দশমিক সংখ্যা',1),(@q,'C','একটা টেক্সট লাইন',0),(@q,'D','কিছুই না',0);

-- ── Control Flow ─────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_cf, 'if-else-java', 'শর্ত ও if-else', 'Conditions & If-Else',
'জাভার `if`/`else if`/`else` সিনট্যাক্স C/C++-এর মতোই। জাভাতে শর্তের ভেতরে সংখ্যা লেখা যায় না (`if (1)` অবৈধ) — শর্ত অবশ্যই `boolean` (`true`/`false`) টাইপের হতে হবে।',
'public class Main {
    public static void main(String[] args) {
        int marks = 65;
        if (marks >= 80) {
            System.out.println("Grade: A");
        } else if (marks >= 60) {
            System.out.println("Grade: B");
        } else {
            System.out.println("Grade: C");
        }
    }
}',
'java', 10, 0, 1, 0),

(@m_cf, 'logical-operators-java', 'লজিক্যাল অপারেটর', 'Logical Operators',
'`&&` (এবং), `||` (অথবা), `!` (না) — একাধিক শর্ত একসাথে যাচাই করতে ব্যবহার হয়, C/C++-এর মতোই। জাভাতে এগুলো সবসময় `boolean` অপারেন্ডে কাজ করে, C-এর মতো `0`/non-zero-এ নয়।',
'public class Main {
    public static void main(String[] args) {
        int age = 20;
        boolean hasId = true;

        if (age >= 18 && hasId) {
            System.out.println("Entry allowed");
        } else {
            System.out.println("Entry denied");
        }
    }
}',
'java', 10, 0, 2, 0),

(@m_cf, 'loops-java', 'লুপ: while ও for', 'Loops: While & For',
'`while` আর `for` লুপ C/C++-এর মতোই কাজ করে — শর্ত সত্যি থাকা পর্যন্ত রিপিট হয়। এনহ্যান্সড for-loop (`for (int n : arr)`) দিয়ে অ্যারে বা কালেকশন লুপ করাও যায়, যা পরের মডিউলে দেখা যাবে।',
'public class Main {
    public static void main(String[] args) {
        for (int i = 1; i <= 5; i++) {
            System.out.print(i + " ");
        }
        System.out.println();
    }
}',
'java', 10, 0, 3, 0),

(@m_cf, 'control-flow-capstone-java', 'ক্যাপস্টোন: FizzBuzz', 'Capstone: FizzBuzz',
'১ থেকে ১৫ পর্যন্ত সংখ্যা প্রিন্ট করো, কিন্তু ৩-এর গুণিতক হলে "Fizz", ৫-এর গুণিতক হলে "Buzz", দুটোরই গুণিতক হলে "FizzBuzz"। লুপ, শর্ত, আর মডুলাস (`%`) — সবকিছু একসাথে।',
'public class Main {
    public static void main(String[] args) {
        for (int i = 1; i <= 15; i++) {
            if (i % 15 == 0) System.out.println("FizzBuzz");
            else if (i % 3 == 0) System.out.println("Fizz");
            else if (i % 5 == 0) System.out.println("Buzz");
            else System.out.println(i);
        }
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_cf AND slug='if-else-java';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_cf AND slug='logical-operators-java';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_cf AND slug='loops-java';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_cf AND slug='control-flow-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'নিচের কোডের আউটপুট কী হবে?', 'What does this print?', 'int marks = 65;
if (marks >= 80) System.out.println("A");
else if (marks >= 60) System.out.println("B");
else System.out.println("C");',
'৬৫, ৮০-এর কম কিন্তু ৬০-এর বেশি বা সমান, তাই দ্বিতীয় শর্ত সত্যি হয় এবং "B" প্রিন্ট হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','A',0),(@q,'B','B',1),(@q,'C','C',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'age >= 18 && hasId কখন সত্যি হবে?', 'When is age >= 18 && hasId true?', 'if (age >= 18 && hasId) { ... }',
'`&&` মানে দুটো শর্তই সত্যি হতে হবে — বয়স ১৮+ এবং `hasId` অবশ্যই `true` হতে হবে, শুধু একটা সত্যি হলে চলবে না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু বয়স ১৮+ হলেই',0),(@q,'B','শুধু hasId সত্যি হলেই',0),(@q,'C','দুটো শর্তই সত্যি হলে',1),(@q,'D','কখনোই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'এই লুপটি কতবার চলবে?', 'How many times does this run?', 'for (int i = 1; i <= 5; i++) {
    System.out.print(i + " ");
}',
'`i` ১ থেকে শুরু হয়ে `i <= 5` সত্যি থাকা পর্যন্ত চলে — 1,2,3,4,5, মোট ৫ বার।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','৪ বার',0),(@q,'B','৫ বার',1),(@q,'C','৬ বার',0),(@q,'D','ইনফিনিট',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'i = 15 হলে কী প্রিন্ট হবে?', 'What prints when i = 15?', 'if (i % 15 == 0) ... "FizzBuzz"
else if (i % 3 == 0) ... "Fizz"
else if (i % 5 == 0) ... "Buzz"',
'১৫ হলো ৩ এবং ৫ দুটোরই গুণিতক, তাই `i % 15 == 0` সবার আগে সত্যি হয় এবং "FizzBuzz" প্রিন্ট হয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Fizz',0),(@q,'B','Buzz',0),(@q,'C','FizzBuzz',1),(@q,'D','15',0);

-- ── Methods ──────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_meth, 'method-basics', 'মেথড ঘোষণা ও কল করা', 'Declaring & Calling Methods',
'জাভায় ফাংশনকে বলা হয় **মেথড**, এবং সবসময় কোনো না কোনো ক্লাসের ভেতরে থাকতে হয়। একটা মেথডের একটা রিটার্ন টাইপ, নাম, আর প্যারামিটার থাকে — `void` মানে কিছু রিটার্ন করে না।',
'public class Main {
    static int square(int x) {
        return x * x;
    }

    public static void main(String[] args) {
        System.out.println(square(5)); // 25
    }
}',
'java', 10, 0, 1, 0),

(@m_meth, 'method-parameters', 'প্যারামিটার ও pass-by-value', 'Parameters & Pass-by-Value',
'জাভায় প্রিমিটিভ টাইপ (`int`, `double` ইত্যাদি) মেথডে pass-by-value-এ যায় — মেথডের ভেতরে প্যারামিটার বদলালে আসল ভেরিয়েবলে কোনো প্রভাব পড়ে না।',
'public class Main {
    static void tryToChange(int x) {
        x = 100; // only changes the local copy
    }

    public static void main(String[] args) {
        int num = 5;
        tryToChange(num);
        System.out.println(num); // 5, unchanged
    }
}',
'java', 10, 0, 2, 0),

(@m_meth, 'method-overloading', 'মেথড ওভারলোডিং', 'Method Overloading',
'জাভায় একই নামের একাধিক মেথড থাকতে পারে, যদি তাদের প্যারামিটারের সংখ্যা বা টাইপ আলাদা হয় — একে বলে **ওভারলোডিং**। জাভা কম্পাইলার কল করার সময় দেওয়া আর্গুমেন্ট দেখে ঠিক করে কোন ভার্সনটা চালাতে হবে।',
'public class Main {
    static int add(int a, int b) {
        return a + b;
    }
    static double add(double a, double b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println(add(2, 3));     // 5 (int version)
        System.out.println(add(2.5, 3.5)); // 6.0 (double version)
    }
}',
'java', 10, 0, 3, 0),

(@m_meth, 'methods-capstone-java', 'ক্যাপস্টোন: ছোট ক্যালকুলেটর', 'Capstone: A Small Calculator',
'একাধিক মেথড মিলিয়ে একটা ছোট ক্যালকুলেটর — প্রতিটা অপারেশনের জন্য আলাদা মেথড, আর `main()` থেকে সেগুলোকে কল করা।',
'public class Main {
    static int add(int a, int b) { return a + b; }
    static int subtract(int a, int b) { return a - b; }

    public static void main(String[] args) {
        System.out.println(add(10, 5));      // 15
        System.out.println(subtract(10, 5)); // 5
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_meth AND slug='method-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_meth AND slug='method-parameters';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_meth AND slug='method-overloading';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_meth AND slug='methods-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'square(5) কী রিটার্ন করবে?', 'What does square(5) return?', 'static int square(int x) { return x * x; }
square(5);',
'`square(5)` কল হলে `x = 5`, ফাংশনটি `x * x = 5 * 5 = 25` রিটার্ন করে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',0),(@q,'B','10',0),(@q,'C','25',1),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'tryToChange(num) কল করার পর num-এর মান কত?', 'What is num after tryToChange(num)?', 'static void tryToChange(int x) { x = 100; }
int num = 5;
tryToChange(num);',
'প্রিমিটিভ `int` pass-by-value-এ যায় — মেথডটি `num`-এর একটা কপি (`x`) পায় এবং সেই কপিটাই বদলায়। আসল `num` অপরিবর্তিত থাকে, `5`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','5',1),(@q,'B','100',0),(@q,'C','0',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'add(2, 3) কোন ভার্সনটা কল করবে?', 'Which version does add(2, 3) call?', 'static int add(int a, int b) { ... }
static double add(double a, double b) { ... }
add(2, 3);',
'`2` আর `3` দুটোই `int` লিটারেল, তাই কম্পাইলার প্যারামিটার টাইপ মিলিয়ে `int add(int, int)` ভার্সনটাই বেছে নেয় — এটাই ওভারলোডিং, যেখানে আর্গুমেন্টের টাইপ অনুযায়ী সঠিক মেথড অটোমেটিক্যালি বাছাই হয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','int ভার্সন',1),(@q,'B','double ভার্সন',0),(@q,'C','Compile error',0),(@q,'D','দুটোই চলবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'subtract(10, 5) কী রিটার্ন করবে?', 'What does subtract(10, 5) return?', 'static int subtract(int a, int b) { return a - b; }
subtract(10, 5);',
'`a = 10`, `b = 5`, ফাংশনটি `a - b = 10 - 5 = 5` রিটার্ন করে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','15',0),(@q,'B','5',1),(@q,'C','50',0),(@q,'D','-5',0);

-- ── Arrays & Strings ─────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_arr, 'java-arrays', 'জাভা অ্যারে', 'Java Arrays',
'জাভাতে অ্যারে ঘোষণা করতে হয় `int[] arr = {1, 2, 3};` — সাইজ ফিক্সড, ইনডেক্স `0` থেকে শুরু। `arr.length` দিয়ে সাইজ পাওয়া যায় (এটা ফাংশন নয়, একটা প্রপার্টি — শেষে `()` লাগে না)।',
'public class Main {
    public static void main(String[] args) {
        int[] scores = {90, 85, 78};

        for (int i = 0; i < scores.length; i++) {
            System.out.print(scores[i] + " ");
        }
        System.out.println();
    }
}',
'java', 10, 0, 1, 0),

(@m_arr, 'java-strings', 'জাভা স্ট্রিং: immutable', 'Java Strings: Immutable',
'জাভায় `String` একটা অবজেক্ট, char অ্যারে নয়। সবচেয়ে গুরুত্বপূর্ণ ব্যাপার: জাভার `String` **immutable** — একবার তৈরি হলে তার কনটেন্ট বদলানো যায় না, `+` দিয়ে জোড়া লাগালে আসলে একটা নতুন `String` তৈরি হয়।',
'public class Main {
    public static void main(String[] args) {
        String first = "Byte";
        String second = "wise";
        String full = first + second; // creates a NEW string

        System.out.println(full); // Bytewise
    }
}',
'java', 10, 0, 2, 0),

(@m_arr, 'string-methods-java', 'স্ট্রিং মেথড: length, charAt, equals', 'String Methods: length, charAt, equals',
'`String`-এর কিছু কমন মেথড: `.length()` দৈর্ঘ্য, `.charAt(i)` নির্দিষ্ট ইনডেক্সের অক্ষর, `.substring()` অংশবিশেষ। কনটেন্ট তুলনায় `==` নয়, `.equals()` ব্যবহার করতে হয় — `==` অবজেক্টের রেফারেন্স তুলনা করে, কনটেন্ট নয়।',
'public class Main {
    public static void main(String[] args) {
        String s = "hello";
        System.out.println(s.length());     // 5
        System.out.println(s.equals("hello")); // true
    }
}',
'java', 10, 0, 3, 0),

(@m_arr, 'arrays-strings-capstone-java', 'ক্যাপস্টোন: সবচেয়ে লম্বা নাম খুঁজে বের করা', 'Capstone: Finding the Longest Name',
'একটা নামের অ্যারে লুপ করে, `.length()` ব্যবহার করে সবচেয়ে লম্বা নামটা বের করা হচ্ছে — অ্যারে, স্ট্রিং মেথড, আর "রানিং সেরা" ট্র্যাক রাখার প্যাটার্ন, সব একসাথে।',
'public class Main {
    public static void main(String[] args) {
        String[] names = {"Rafi", "Nadia", "Al"};
        String longest = names[0];

        for (int i = 1; i < names.length; i++) {
            if (names[i].length() > longest.length()) {
                longest = names[i];
            }
        }
        System.out.println("Longest: " + longest); // Nadia
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_arr AND slug='java-arrays';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_arr AND slug='java-strings';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_arr AND slug='string-methods-java';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_arr AND slug='arrays-strings-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'scores.length এর মান কত হবে?', 'What is scores.length?', 'int[] scores = {90, 85, 78};
System.out.println(scores.length);',
'অ্যারেতে ৩টা এলিমেন্ট আছে, তাই `scores.length` হলো `3`। খেয়াল করুন এটা একটা প্রপার্টি, `.length()` মেথড নয় (স্ট্রিং-এর ক্ষেত্রে যা `()` সহ কল হয়)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','2',0),(@q,'B','3',1),(@q,'C','90',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'first + second এর পর first-এর কনটেন্ট কী হবে?', 'What is first after first + second?', 'String first = "Byte";
String second = "wise";
String full = first + second;',
'জাভার `String` immutable — `+` কনক্যাটেনেশন `first`-কে বদলায় না, বরং একটা সম্পূর্ণ নতুন `String` (`full`) তৈরি করে। `first` এখনও `"Byte"`-ই থাকে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','"Byte" (অপরিবর্তিত)',1),(@q,'B','"Bytewise"',0),(@q,'C','"" (খালি)',0),(@q,'D','Compile error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'দুটো String-এর কনটেন্ট তুলনা করতে কী ব্যবহার করা উচিত?', 'What should you use to compare String content?', 's.equals("hello")',
'জাভায় `==` স্ট্রিং অবজেক্টের রেফারেন্স তুলনা করে, কনটেন্ট নয় — প্রায়ই ভুল ফলাফল দেয়। কনটেন্ট (আসল টেক্সট) তুলনা করতে `.equals()` ব্যবহার করা উচিত।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','==',0),(@q,'B','.equals()',1),(@q,'C','.length()',0),(@q,'D','.charAt()',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'নিচের কোডে longest-এর ফাইনাল মান কী হবে?', 'What is the final value of longest?', 'String[] names = {"Rafi", "Nadia", "Al"};
// loop finds the longest name by .length()',
'দৈর্ঘ্য অনুযায়ী: "Rafi" (4), "Nadia" (5), "Al" (2) — এদের মধ্যে "Nadia" সবচেয়ে লম্বা, তাই লুপ শেষে `longest = "Nadia"`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi',0),(@q,'B','Nadia',1),(@q,'C','Al',0),(@q,'D','সবাই সমান',0);

-- ── Classes & Objects (OOP) ──────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_oop, 'classes-objects-java', 'ক্লাস ও অবজেক্ট', 'Classes & Objects',
'জাভাতে সবকিছুই একটা ক্লাসের ভেতরে থাকে — এটা আগে থেকেই জানা। এখন একটা কাস্টম ক্লাস বানানো হচ্ছে, যেখানে ডেটা (ফিল্ড) আর কাজ (মেথড) একসাথে থাকবে। `new` কীওয়ার্ড দিয়ে একটা ক্লাস থেকে অবজেক্ট তৈরি হয়।',
'public class Dog {
    String name;
    void bark() {
        System.out.println(name + " says Woof!");
    }

    public static void main(String[] args) {
        Dog d = new Dog();
        d.name = "Tommy";
        d.bark();
    }
}',
'java', 10, 0, 1, 0),

(@m_oop, 'constructors-java', 'কনস্ট্রাক্টর', 'Constructors',
'একটা অবজেক্ট `new` দিয়ে তৈরি হওয়ার সাথে সাথেই ভ্যালু সেট করতে **কনস্ট্রাক্টর** ব্যবহার হয় — ক্লাসের নামেই একটা বিশেষ মেথড, কোনো রিটার্ন টাইপ ছাড়া, যা অবজেক্ট তৈরির মুহূর্তে অটোমেটিক্যালি চলে।',
'public class Dog {
    String name;
    Dog(String n) { // constructor
        name = n;
    }
    void bark() {
        System.out.println(name + " says Woof!");
    }

    public static void main(String[] args) {
        Dog d = new Dog("Tommy"); // constructor runs here
        d.bark();
    }
}',
'java', 10, 0, 2, 0),

(@m_oop, 'encapsulation-java', 'এনক্যাপসুলেশন: private ও getter/setter', 'Encapsulation: Private Fields & Getters/Setters',
'ফিল্ডকে `private` করে রাখলে ক্লাসের বাইরে থেকে সরাসরি অ্যাক্সেস করা যায় না — শুধু পাবলিক মেথড (getter/setter) দিয়েই অ্যাক্সেস দেওয়া হয়, যেখানে ভ্যালিডেশন বসানো যায়। এটাই OOP-এর **এনক্যাপসুলেশন** নীতি।',
'public class Account {
    private double balance;

    public Account(double b) { balance = b; }

    public void deposit(double amt) {
        if (amt > 0) balance += amt; // validated here
    }

    public double getBalance() { return balance; }

    public static void main(String[] args) {
        Account acc = new Account(100);
        acc.deposit(50);
        System.out.println(acc.getBalance()); // 150
    }
}',
'java', 10, 0, 3, 0),

(@m_oop, 'oop-capstone-java', 'ক্যাপস্টোন: Rectangle ক্লাস', 'Capstone: A Rectangle Class',
'একটা ক্লাস, একটা কনস্ট্রাক্টর, আর `private` ফিল্ডের সাথে একটা পাবলিক মেথড যা এরিয়া ক্যালকুলেট করে — আগের তিনটা লেসনের সবকিছু একসাথে।',
'public class Rectangle {
    private double width, height;

    public Rectangle(double w, double h) {
        width = w;
        height = h;
    }

    public double area() {
        return width * height;
    }

    public static void main(String[] args) {
        Rectangle r = new Rectangle(5, 3);
        System.out.println(r.area()); // 15.0
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_oop AND slug='classes-objects-java';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_oop AND slug='constructors-java';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_oop AND slug='encapsulation-java';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_oop AND slug='oop-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'new Dog() কী তৈরি করে?', 'What does new Dog() create?', 'Dog d = new Dog();
d.name = "Tommy";',
'`new Dog()` হলো `Dog` ক্লাসের ব্লুপ্রিন্ট থেকে একটা নতুন অবজেক্ট (instance) তৈরি করা, যা `d` ভেরিয়েবলে রাখা হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Dog ক্লাসের একটা নতুন অবজেক্ট',1),(@q,'B','একটা টেক্সট স্ট্রিং',0),(@q,'C','একটা মেথড',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'কনস্ট্রাক্টর কখন চলে?', 'When does a constructor run?', 'Dog d = new Dog("Tommy"); // constructor runs here',
'কনস্ট্রাক্টর `new` দিয়ে অবজেক্ট তৈরি হওয়ার মুহূর্তেই অটোমেটিক্যালি চলে — আলাদাভাবে কল করার দরকার হয় না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','যখন new দিয়ে অবজেক্ট তৈরি হয়',1),(@q,'B','প্রোগ্রাম শেষ হওয়ার সময়',0),(@q,'C','bark() কল হলে',0),(@q,'D','ম্যানুয়ালি কল করলে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'balance-কে private রাখার সুবিধা কী?', 'Why keep balance private?', 'private double balance;
public void deposit(double amt) {
    if (amt > 0) balance += amt;
}',
'`private` রাখলে বাইরে থেকে সরাসরি ভুল ভ্যালু বসানো যায় না — শুধু `deposit()`-এর মতো নিয়ন্ত্রিত মেথড দিয়েই বদলানো যায়, যেখানে ভ্যালিডেশন বসানো আছে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কোড ছোট হয়',0),(@q,'B','সরাসরি বাইরে থেকে অবৈধ ভ্যালু বসানো ঠেকানো যায়',1),(@q,'C','প্রোগ্রাম দ্রুত চলে',0),(@q,'D','কোনো সুবিধা নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'r.area() এর ফলাফল কত হবে?', 'What does r.area() return?', 'Rectangle r = new Rectangle(5, 3);
r.area();',
'কনস্ট্রাক্টর `width = 5`, `height = 3` সেট করে। `area()` রিটার্ন করে `width * height = 5 * 3 = 15.0`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','8.0',0),(@q,'B','15.0',1),(@q,'C','53.0',0),(@q,'D','Compile error',0);

-- ── Inheritance & Interfaces ─────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_inh, 'inheritance-basics', 'ইনহেরিটেন্স: extends', 'Inheritance: extends',
'একটা ক্লাস আরেকটা ক্লাসের সব ফিল্ড ও মেথড "উত্তরাধিকার সূত্রে" পেতে পারে `extends` কীওয়ার্ড দিয়ে — একে **ইনহেরিটেন্স** বলে। এতে একই কোড বারবার লেখা লাগে না। `super()` দিয়ে প্যারেন্ট ক্লাসের কনস্ট্রাক্টর কল করা যায়।',
'public class Animal {
    String name;
    Animal(String n) { name = n; }
    void eat() { System.out.println(name + " is eating"); }
}

public class Dog extends Animal {
    Dog(String n) { super(n); } // calls Animal''s constructor

    public static void main(String[] args) {
        Dog d = new Dog("Tommy");
        d.eat(); // inherited from Animal
    }
}',
'java', 10, 0, 1, 0),

(@m_inh, 'method-overriding', 'মেথড ওভাররাইডিং', 'Method Overriding',
'চাইল্ড ক্লাস প্যারেন্টের কোনো মেথডকে নিজের মতো করে নতুনভাবে লিখতে পারে — একে **ওভাররাইডিং** বলে (`@Override` দিয়ে চিহ্নিত করা ভালো অভ্যাস)। এটা ওভারলোডিং থেকে আলাদা: ওভাররাইডিং হয় প্যারেন্ট-চাইল্ডের মধ্যে, একই সিগনেচারে।',
'public class Animal {
    void makeSound() { System.out.println("Some sound"); }
}

public class Dog extends Animal {
    @Override
    void makeSound() { System.out.println("Woof!"); }

    public static void main(String[] args) {
        Dog d = new Dog();
        d.makeSound(); // "Woof!" — the overridden version
    }
}',
'java', 10, 0, 2, 0),

(@m_inh, 'interfaces-java', 'ইন্টারফেস', 'Interfaces',
'একটা **ইন্টারফেস** শুধু বলে দেয় কোন কোন মেথড থাকতে *হবে*, কিন্তু কীভাবে কাজ করবে তা বলে না — সেটা যে ক্লাস ইন্টারফেসটি `implements` করে, তাকেই লিখতে হয়। এটা একটা "কন্ট্র্যাক্ট"-এর মতো কাজ করে।',
'interface Movable {
    void move(); // no body — just a contract
}

public class Car implements Movable {
    public void move() {
        System.out.println("Car is driving");
    }

    public static void main(String[] args) {
        Car c = new Car();
        c.move();
    }
}',
'java', 10, 0, 3, 0),

(@m_inh, 'inheritance-capstone-java', 'ক্যাপস্টোন: Shape hierarchy', 'Capstone: A Shape Hierarchy',
'একটা প্যারেন্ট ক্লাস `Shape` আর তার চাইল্ড `Circle`, যেখানে `Circle` নিজের মতো `area()` মেথড ওভাররাইড করে — ইনহেরিটেন্স আর ওভাররাইডিং একসাথে।',
'public class Shape {
    double area() { return 0; }
}

public class Circle extends Shape {
    double radius;
    Circle(double r) { radius = r; }

    @Override
    double area() {
        return 3.14159 * radius * radius;
    }

    public static void main(String[] args) {
        Circle c = new Circle(5);
        System.out.println(c.area()); // ~78.54
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_inh AND slug='inheritance-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_inh AND slug='method-overriding';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_inh AND slug='interfaces-java';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_inh AND slug='inheritance-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'd.eat() কল করা যাচ্ছে কেন, যদিও Dog ক্লাসে eat() লেখাই হয়নি?', 'Why can d.eat() be called if Dog never defines eat()?', 'public class Dog extends Animal { ... }
d.eat();',
'`Dog`, `Animal`-কে `extends` করেছে, তাই `Animal`-এর সব মেথড (যেমন `eat()`) অটোমেটিক্যালি `Dog`-ও পেয়ে যায় — এটাই ইনহেরিটেন্সের মূল সুবিধা, একই কোড আবার লিখতে হয় না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা আসলে কল করা যাবে না, Error হবে',0),(@q,'B','Dog, Animal থেকে eat() ইনহেরিট করেছে',1),(@q,'C','জাভা নিজে থেকে eat() লিখে দেয়',0),(@q,'D','এটা একটা টাইপো',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'd.makeSound() কী প্রিন্ট করবে?', 'What does d.makeSound() print?', 'class Animal { void makeSound() { print("Some sound"); } }
class Dog extends Animal {
    @Override void makeSound() { print("Woof!"); }
}
Dog d = new Dog();
d.makeSound();',
'`Dog`, `Animal`-এর `makeSound()` মেথডটি ওভাররাইড করেছে — তাই `Dog`-এর অবজেক্টে `makeSound()` কল করলে চাইল্ড ক্লাসের ভার্সনটাই চলে, প্যারেন্টেরটা নয়। ফলাফল: "Woof!"।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Some sound',0),(@q,'B','Woof!',1),(@q,'C','দুটোই প্রিন্ট হবে',0),(@q,'D','Compile error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'Movable ইন্টারফেসের move() মেথডে কোনো বডি (কোড) নেই কেন?', 'Why does move() in the interface have no body?', 'interface Movable {
    void move();
}',
'ইন্টারফেস শুধু বলে দেয় কোন মেথড *থাকতে হবে* — কীভাবে কাজ করবে তা নয়। যে ক্লাস `implements Movable` লেখে, তাকেই `move()`-এর আসল বডি (কোড) লিখতে হয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা একটা ভুল, বডি থাকা উচিত ছিল',0),(@q,'B','ইন্টারফেস শুধু মেথড থাকার "কন্ট্র্যাক্ট" দেয়, বাস্তবায়ন implements-করা ক্লাস লেখে',1),(@q,'C','জাভা এটা নিজে থেকে পূরণ করে দেয়',0),(@q,'D','এই কোডটি কম্পাইলই হবে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'c.area() প্রায় কত রিটার্ন করবে?', 'What does c.area() return approximately?', 'Circle c = new Circle(5);
c.area(); // 3.14159 * radius * radius',
'`Circle`-এর ওভাররাইড করা `area()` চলে (Shape-এর `return 0` নয়) — `3.14159 * 5 * 5 ≈ 78.54`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',0),(@q,'B','25',0),(@q,'C','প্রায় 78.54',1),(@q,'D','15.7',0);
