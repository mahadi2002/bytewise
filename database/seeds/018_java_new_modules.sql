-- Java track: 1 new Inheritance lesson (Polymorphism/Abstraction — capstone
-- already renumbered to slot 5 by 015) + Exception Handling + Collections
-- Framework (new modules 7-8).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_java FROM languages WHERE slug = 'java';
SELECT id INTO @m_inh  FROM modules WHERE language_id=@lang_java AND slug='inheritance';
SELECT id INTO @m_exc  FROM modules WHERE language_id=@lang_java AND slug='exceptions';
SELECT id INTO @m_coll FROM modules WHERE language_id=@lang_java AND slug='collections';

-- ── Inheritance expansion: abstract classes ──────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_inh, 'abstract-classes-java', 'অ্যাবস্ট্র্যাক্ট ক্লাস', 'Abstract Classes',
'একটা **অ্যাবস্ট্র্যাক্ট ক্লাস**-কে সরাসরি `new` দিয়ে অবজেক্ট বানানো যায় না — এটা শুধু অন্য ক্লাসের এক্সটেন্ড করার জন্য একটা বেস। এতে `abstract` মেথড থাকতে পারে (শুধু ঘোষণা, বডি নেই — ঠিক ইন্টারফেসের মতো), যা চাইল্ড ক্লাসকে অবশ্যই ইমপ্লিমেন্ট করতে হয়। ইন্টারফেসের সাথে পার্থক্য: অ্যাবস্ট্র্যাক্ট ক্লাসে কিছু সাধারণ (non-abstract) মেথডও থাকতে পারে।',
'abstract class Shape {
    abstract double area(); // no body — subclasses must implement

    void describe() { // regular method, shared by all subclasses
        System.out.println("This shape has area: " + area());
    }
}

class Circle extends Shape {
    double radius;
    Circle(double r) { radius = r; }
    double area() { return 3.14159 * radius * radius; }
}

public class Main {
    public static void main(String[] args) {
        Circle c = new Circle(5);
        c.describe();
    }
}',
'java', 10, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_inh AND slug='abstract-classes-java';
INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'new Shape() লেখা হলে কী হবে?', 'What happens with new Shape()?', 'abstract class Shape {
    abstract double area();
}
Shape s = new Shape(); // ???',
'`Shape` একটা `abstract` ক্লাস — একে সরাসরি `new` দিয়ে ইনস্ট্যান্স তৈরি করা যায় না, কারণ এর `area()` মেথডের কোনো বাস্তবায়ন (বডি) নেই। এটা কম্পাইল-টাইম এরর দেবে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ঠিকভাবেই একটা Shape অবজেক্ট তৈরি হবে',0),(@q,'B','Compile error — abstract ক্লাসের ইনস্ট্যান্স তৈরি করা যায় না',1),(@q,'C','area() স্বয়ংক্রিয়ভাবে 0 রিটার্ন করে',0),(@q,'D','প্রোগ্রাম ক্র্যাশ করে',0);

-- ── Exception Handling ───────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_exc, 'try-catch-java', 'try, catch ও finally', 'try, catch & finally',
'জাভায় রানটাইম সমস্যা (যেমন `0` দিয়ে ভাগ করা) একটা **এক্সেপশন** ছোড়ে, যা না ধরলে প্রোগ্রাম ক্র্যাশ করে। `try` ব্লকে ঝুঁকিপূর্ণ কোড রাখা হয়, `catch` সেই এক্সেপশন ধরে, আর `finally` ব্লক এক্সেপশন হোক বা না হোক — সবসময় চলে (যেমন ফাইল/কানেকশন বন্ধ করার জন্য)।',
'public class Main {
    public static void main(String[] args) {
        try {
            int result = 10 / 0;
        } catch (ArithmeticException e) {
            System.out.println("Caught: " + e.getMessage());
        } finally {
            System.out.println("This always runs");
        }
    }
}',
'java', 10, 0, 1, 0),

(@m_exc, 'checked-unchecked', 'Checked বনাম Unchecked এক্সেপশন', 'Checked vs Unchecked Exceptions',
'জাভায় দুই ধরনের এক্সেপশন আছে। **Checked** এক্সেপশন (যেমন `IOException`) কম্পাইলার জোর করে হয় `catch` করতে বাধ্য করে, নাহলে `throws` দিয়ে ঘোষণা করতে হয়। **Unchecked** এক্সেপশন (যেমন `ArithmeticException`, `NullPointerException`) `RuntimeException`-এর সাবক্লাস — এগুলো ধরা বাধ্যতামূলক নয়।',
'public class Main {
    static void risky() throws Exception { // checked — must declare
        throw new Exception("Checked exception");
    }

    public static void main(String[] args) {
        try {
            risky();
        } catch (Exception e) {
            System.out.println("Caught: " + e.getMessage());
        }
    }
}',
'java', 10, 0, 2, 0),

(@m_exc, 'custom-exceptions-java', 'কাস্টম এক্সেপশন ক্লাস', 'Custom Exception Classes',
'`Exception`-কে এক্সটেন্ড করে নিজের এক্সেপশন ক্লাস বানানো যায় — যখন বিল্ট-ইন এক্সেপশন টাইপগুলো যথেষ্ট স্পষ্ট নয়, তখন এভাবে ডোমেইন-নির্দিষ্ট এক্সেপশন তৈরি করা ভালো অভ্যাস।',
'class InvalidAgeException extends Exception {
    InvalidAgeException(String message) {
        super(message);
    }
}

public class Main {
    static void checkAge(int age) throws InvalidAgeException {
        if (age < 0) {
            throw new InvalidAgeException("Age cannot be negative");
        }
    }

    public static void main(String[] args) {
        try {
            checkAge(-5);
        } catch (InvalidAgeException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}',
'java', 10, 0, 3, 0),

(@m_exc, 'exceptions-capstone-java', 'ক্যাপস্টোন: নিরাপদ অ্যারে অ্যাক্সেস', 'Capstone: Safe Array Access',
'একটা অ্যারের বাইরের ইনডেক্স অ্যাক্সেস করলে জাভা `ArrayIndexOutOfBoundsException` ছোড়ে — সেটা ধরে প্রোগ্রাম ক্র্যাশ না করিয়ে একটা পরিষ্কার মেসেজ দেখানো হচ্ছে।',
'public class Main {
    public static void main(String[] args) {
        int[] nums = {10, 20, 30};
        try {
            System.out.println(nums[5]); // out of bounds
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Invalid index!");
        }
        System.out.println("Program continues normally");
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_exc AND slug='try-catch-java';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_exc AND slug='checked-unchecked';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_exc AND slug='custom-exceptions-java';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_exc AND slug='exceptions-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'finally ব্লক কখন চলে?', 'When does the finally block run?', 'try { ... } catch (...) { ... } finally {
    System.out.println("This always runs");
}',
'`finally` ব্লক সবসময় চলে — এক্সেপশন হোক বা না হোক, `catch` ধরুক বা না ধরুক। এটা সাধারণত রিসোর্স ক্লিনআপের (ফাইল/কানেকশন বন্ধ করা) জন্য ব্যবহার হয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু এক্সেপশন হলে',0),(@q,'B','শুধু এক্সেপশন না হলে',0),(@q,'C','সবসময়, এক্সেপশন হোক বা না হোক',1),(@q,'D','কখনোই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'checked এক্সেপশনের জন্য কী বাধ্যতামূলক?', 'What is mandatory for a checked exception?', 'static void risky() throws Exception { ... }',
'Checked এক্সেপশন কম্পাইলার জোর করে হয় `try/catch` দিয়ে ধরতে, নাহলে মেথড সিগনেচারে `throws` দিয়ে ঘোষণা করতে বাধ্য করে — নাহলে কোড কম্পাইলই হবে না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কিছুই না, ঐচ্ছিক',0),(@q,'B','catch করা অথবা throws দিয়ে ঘোষণা করা',1),(@q,'C','শুধু catch করা, throws চলবে না',0),(@q,'D','প্রোগ্রাম রিস্টার্ট করা',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'InvalidAgeException ক্লাসটা কীভাবে বানানো হয়েছে?', 'How is InvalidAgeException built?', 'class InvalidAgeException extends Exception {
    InvalidAgeException(String message) { super(message); }
}',
'`Exception`-কে `extends` করে একটা কাস্টম এক্সেপশন ক্লাস বানানো হয়েছে, আর কনস্ট্রাক্টর `super(message)` দিয়ে প্যারেন্ট (`Exception`)-এর কনস্ট্রাক্টরকে মেসেজটা পাঠিয়ে দেয়, যা পরে `getMessage()`-এ পাওয়া যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Exception ক্লাসকে extends করে',1),(@q,'B','এটা জাভার একটা বিল্ট-ইন ক্লাস',0),(@q,'C','interface ব্যবহার করে',0),(@q,'D','এটা আসলে একটা মেথড, ক্লাস নয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'nums[5] অ্যাক্সেস করার পর প্রোগ্রামের কী হবে?', 'What happens after accessing nums[5]?', 'int[] nums = {10, 20, 30};
try {
    System.out.println(nums[5]); // out of bounds
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("Invalid index!");
}
System.out.println("Program continues normally");',
'`nums`-এ মাত্র ৩টা এলিমেন্ট (ইনডেক্স 0-2), তাই `nums[5]` `ArrayIndexOutOfBoundsException` ছোড়ে। `catch` সেটা ধরে "Invalid index!" প্রিন্ট করে, তারপর প্রোগ্রাম স্বাভাবিকভাবে চলতে থাকে — ক্র্যাশ করে না।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রোগ্রাম ক্র্যাশ করে',0),(@q,'B','"Invalid index!" প্রিন্ট হয়ে প্রোগ্রাম চলতে থাকে',1),(@q,'C','30 প্রিন্ট হয়',0),(@q,'D','কিছুই প্রিন্ট হয় না',0);

-- ── Collections Framework ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_coll, 'arraylist-java', 'ArrayList: সাইজ-বদলযোগ্য লিস্ট', 'ArrayList: A Resizable List',
'জাভার সাধারণ অ্যারের সাইজ ফিক্সড, কিন্তু `ArrayList` দরকারমতো বড়-ছোট হতে পারে — `java.util` প্যাকেজ থেকে আসে। `.add()` দিয়ে যোগ করা, `.get(i)` দিয়ে অ্যাক্সেস করা যায়।',
'import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<Integer> scores = new ArrayList<>();
        scores.add(90);
        scores.add(85);
        scores.add(95);

        System.out.println(scores.size()); // 3
        System.out.println(scores.get(0)); // 90
    }
}',
'java', 10, 0, 1, 0),

(@m_coll, 'hashmap-java', 'HashMap: key-value পেয়ার', 'HashMap: Key-Value Pairs',
'`HashMap` key-value পেয়ার রাখে (Python-এর dict-এর সমতুল্য) — `.put()` দিয়ে যোগ, `.get()` দিয়ে অ্যাক্সেস। কোনো নির্দিষ্ট ক্রম গ্যারান্টি করে না, কিন্তু গড়ে `O(1)` লুকআপ দেয়।',
'import java.util.HashMap;

public class Main {
    public static void main(String[] args) {
        HashMap<String, Integer> ages = new HashMap<>();
        ages.put("Rafi", 20);
        ages.put("Nadia", 22);

        System.out.println(ages.get("Rafi")); // 20
    }
}',
'java', 10, 0, 2, 0),

(@m_coll, 'hashset-java', 'HashSet: ইউনিক ভ্যালু', 'HashSet: Unique Values',
'`HashSet` শুধু ইউনিক ভ্যালু রাখে — একই ভ্যালু দুইবার `.add()` করলে দ্বিতীয়টা চুপচাপ উপেক্ষা হয়। কোনো তালিকায় ডুপ্লিকেট আছে কিনা দ্রুত চেক করতে এটা কাজে লাগে।',
'import java.util.HashSet;

public class Main {
    public static void main(String[] args) {
        HashSet<Integer> nums = new HashSet<>();
        nums.add(5);
        nums.add(2);
        nums.add(5); // duplicate — ignored

        System.out.println(nums.size()); // 2
    }
}',
'java', 10, 0, 3, 0),

(@m_coll, 'collections-capstone-java', 'ক্যাপস্টোন: HashMap দিয়ে শব্দ গোনা', 'Capstone: Counting Words with HashMap',
'একটা স্ট্রিং অ্যারের প্রতিটা শব্দ কতবার এসেছে, তা `HashMap` দিয়ে গোনা হচ্ছে — ArrayList আর HashMap একসাথে ব্যবহার করার বাস্তব উদাহরণ।',
'import java.util.HashMap;

public class Main {
    public static void main(String[] args) {
        String[] words = {"a", "b", "a", "c", "a"};
        HashMap<String, Integer> freq = new HashMap<>();

        for (String w : words) {
            freq.put(w, freq.getOrDefault(w, 0) + 1);
        }
        System.out.println(freq.get("a")); // 3
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_coll AND slug='arraylist-java';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_coll AND slug='hashmap-java';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_coll AND slug='hashset-java';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_coll AND slug='collections-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'scores.size() এর মান কত হবে?', 'What is scores.size()?', 'ArrayList<Integer> scores = new ArrayList<>();
scores.add(90); scores.add(85); scores.add(95);',
'তিনবার `.add()` কল করা হয়েছে, তাই লিস্টে ৩টা এলিমেন্ট আছে — `.size()` রিটার্ন করে `3`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','2',0),(@q,'B','3',1),(@q,'C','90',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'ages.get("Rafi") এর মান কত হবে?', 'What is ages.get("Rafi")?', 'HashMap<String, Integer> ages = new HashMap<>();
ages.put("Rafi", 20);
ages.put("Nadia", 22);',
'`"Rafi"` কী-এর সাথে `20` ভ্যালুটা `put()` করা হয়েছে, তাই `ages.get("Rafi")` রিটার্ন করে `20`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','20',1),(@q,'B','22',0),(@q,'C','null',0),(@q,'D','"Rafi"',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'nums.size() এর মান কত হবে?', 'What is nums.size()?', 'HashSet<Integer> nums = new HashSet<>();
nums.add(5); nums.add(2); nums.add(5);',
'`HashSet` ডুপ্লিকেট রাখে না — `5` দুইবার যোগ করা হলেও দ্বিতীয়টা উপেক্ষা হয়। সেটে থাকে {5, 2}, সাইজ `2`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','2',1),(@q,'C','1',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'freq.get("a") এর মান কত হবে?', 'What is freq.get("a")?', 'String[] words = {"a", "b", "a", "c", "a"};
// counts occurrences of each word',
'"a" শব্দটা অ্যারেতে ৩ বার এসেছে ("a", "a", "a") — লুপ প্রতিবার `freq.get("a")` পাওয়া কাউন্ট ১ বাড়িয়ে আবার বসায়, তাই শেষে `freq.get("a") = 3`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','1',0),(@q,'B','3',1),(@q,'C','5',0),(@q,'D','null',0);
