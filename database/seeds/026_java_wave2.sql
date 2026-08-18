-- Java track: Enum & Generics (new module 9).
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_java FROM languages WHERE slug = 'java';
SELECT id INTO @m_gen FROM modules WHERE language_id=@lang_java AND slug='enum-generics';

INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_gen, 'enum-basics-java', 'Enum: টাইপ-নিরাপদ ধ্রুবক', 'Enum: Type-Safe Constants',
'জাভার `enum` একটা বিশেষ ক্লাস — নির্দিষ্ট কয়েকটা মানের একটা সেট নিশ্চিত করে (যেমন সপ্তাহের দিন)। স্ট্রিং বা সংখ্যার তুলনায় এটা টাইপ-নিরাপদ — ভুল বানানের স্ট্রিং বা অবৈধ সংখ্যা বসানোর ঝুঁকি থাকে না।',
'public class Main {
    enum Day { MON, TUE, WED, THU, FRI, SAT, SUN }

    public static void main(String[] args) {
        Day today = Day.WED;
        System.out.println(today); // WED
    }
}',
'java', 10, 0, 1, 0),

(@m_gen, 'enum-switch-methods', 'enum-এ switch ও মেথড', 'switch and Methods on enum',
'enum প্রায়ই `switch`-এর সাথে ব্যবহার হয়। জাভার enum আরও শক্তিশালী — এর ভেতরে মেথডও রাখা যায়, এমনকি প্রতিটা মেম্বারের জন্য নিজস্ব বিহেভিয়ারও ঠিক করা যায়, যা অন্য অনেক ভাষার enum-এ সম্ভব নয়।',
'public class Main {
    enum Status { PENDING, ACTIVE, EXPIRED }

    public static void main(String[] args) {
        Status s = Status.ACTIVE;
        switch (s) {
            case PENDING -> System.out.println("Pending");
            case ACTIVE  -> System.out.println("Active");
            case EXPIRED -> System.out.println("Expired");
        }
    }
}',
'java', 10, 0, 2, 0),

(@m_gen, 'generics-basics', 'Generics: টাইপ-নিরাপদ কালেকশন', 'Generics: Type-Safe Collections',
'`ArrayList<Integer>`-এর `<Integer>` অংশটাই **generics** — এটা কম্পাইলারকে বলে দেয় লিস্টে শুধু `Integer` থাকবে, অন্য কোনো টাইপ ভুলে ঢুকে গেলে কম্পাইল-টাইমেই ধরা পড়ে, রানটাইমে ক্র্যাশ করার বদলে। নিজের ক্লাস/মেথডেও generics ব্যবহার করা যায়, যেকোনো টাইপে কাজ করানোর জন্য।',
'public class Box<T> {
    private T content;
    public void set(T value) { content = value; }
    public T get() { return content; }
}

public class Main {
    public static void main(String[] args) {
        Box<String> box = new Box<>();
        box.set("Hello");
        System.out.println(box.get()); // Hello
    }
}',
'java', 10, 0, 3, 0),

(@m_gen, 'generics-capstone-java', 'ক্যাপস্টোন: জেনেরিক Pair ক্লাস', 'Capstone: A Generic Pair Class',
'দুটো আলাদা টাইপের ভ্যালু একসাথে রাখতে পারা একটা জেনেরিক `Pair` ক্লাস — দুটো টাইপ প্যারামিটার (`<A, B>`) ব্যবহার করে, generics কতটা নমনীয় হতে পারে তার একটা উদাহরণ।',
'public class Pair<A, B> {
    private A first;
    private B second;

    public Pair(A first, B second) {
        this.first = first;
        this.second = second;
    }

    public String describe() {
        return first + " - " + second;
    }
}

public class Main {
    public static void main(String[] args) {
        Pair<String, Integer> p = new Pair<>("Rafi", 85);
        System.out.println(p.describe()); // Rafi - 85
    }
}',
'java', 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_gen AND slug='enum-basics-java';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_gen AND slug='enum-switch-methods';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_gen AND slug='generics-basics';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_gen AND slug='generics-capstone-java';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'System.out.println(today) কী প্রিন্ট করবে?', 'What does this print?', 'enum Day { MON, TUE, WED, THU, FRI, SAT, SUN }
Day today = Day.WED;
System.out.println(today);',
'জাভার enum-এর `toString()` ডিফল্টভাবে মেম্বারের নাম প্রিন্ট করে, সংখ্যা নয় — তাই এটা "WED" প্রিন্ট করবে, `2` নয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','2',0),(@q,'B','WED',1),(@q,'C','Day.WED',0),(@q,'D','Error',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 's = Status.ACTIVE হলে কী প্রিন্ট হবে?', 'What prints when s = Status.ACTIVE?', 'switch (s) {
    case PENDING -> System.out.println("Pending");
    case ACTIVE  -> System.out.println("Active");
    case EXPIRED -> System.out.println("Expired");
}',
'`s`-এর মান `ACTIVE`, তাই `switch` `case ACTIVE`-এ গিয়ে "Active" প্রিন্ট করে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Pending',0),(@q,'B','Active',1),(@q,'C','Expired',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'Box<String> এ box.set(5) লিখলে কী হবে?', 'What happens with box.set(5) on a Box<String>?', 'Box<String> box = new Box<>();
box.set(5); // ???',
'`Box<String>` মানে `T` এখানে `String`-এ ফিক্স করা হয়েছে। `set()`-এ একটা `int` (5) দিলে টাইপ মিলবে না, তাই কম্পাইলার কম্পাইল-টাইমেই এরর দেবে — রানটাইম পর্যন্ত অপেক্ষা করতে হয় না।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ঠিকভাবেই চলবে, 5 কে String-এ কনভার্ট করবে',0),(@q,'B','কম্পাইল-টাইম টাইপ এরর',1),(@q,'C','রানটাইমে ক্র্যাশ করবে',0),(@q,'D','চুপচাপ 5 উপেক্ষা করবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'p.describe() এর ফলাফল কী হবে?', 'What does p.describe() return?', 'Pair<String, Integer> p = new Pair<>("Rafi", 85);
p.describe(); // returns first + " - " + second',
'`first = "Rafi"`, `second = 85` — `describe()` তাদের মাঝে " - " বসিয়ে জোড়া লাগায়, ফলাফল "Rafi - 85"।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Rafi85',0),(@q,'B','Rafi - 85',1),(@q,'C','85 - Rafi',0),(@q,'D','Error',0);
