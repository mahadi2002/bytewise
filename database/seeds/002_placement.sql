-- =============================================================================
-- Bytewise — 002_placement.sql (supplementary seed, NOT part of the
-- app-owner-provided 02-SCHEMA-SEED.sql)
--
-- 02-SCHEMA-SEED.sql seeds no placement_questions/placement_options rows at
-- all, but BUILD-SPEC §5/04-AI-BUILD-PLAYBOOK.md Phase 8 requires the
-- placement test to actually complete and recommend a module for at least
-- one track. This file adds a minimal, assistant-authored question set —
-- same content-integrity flag as the rest of the seed data (rulebook §8):
-- unverified, not sourced from a reviewed curriculum, safe as a structural
-- placeholder, not a launch-ready diagnostic.
--
-- Originally the C track only (5 questions); now all 8 tracks have 5
-- questions each, difficulty_weight/sort_order 1-5, one per concept tier
-- through that track's first 5 modules (PlacementService::score() stops
-- counting at the first wrong answer, then maps raw_score directly to
-- modules[raw_score] — a perfect score recommends the 6th module as the
-- next checkpoint, same logic the original C set established). The
-- PlacementTestController "coming soon" degrade-gracefully path for a
-- language with zero questions stays in place as defense for any future
-- 9th track added without placement content yet, not because one is
-- expected soon.
-- =============================================================================

SET NAMES utf8mb4;

SELECT id INTO @lang_c FROM languages WHERE slug = 'c';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_c, 'নিচের কোডে `age` ভেরিয়েবলের টাইপ কী?', 'int age = 20;', 1, 1),
(@lang_c, 'নিচের কোডের আউটপুট কী হবে?', 'int x = 5;
if (x > 3) {
    printf("A");
} else {
    printf("B");
}', 2, 2),
(@lang_c, 'নিচের ফাংশনটি কী রিটার্ন করে?', 'int add(int a, int b) {
    return a + b;
}', 3, 3),
(@lang_c, 'নিচের কোডে `arr[2]`-এর মান কত?', 'int arr[] = {10, 20, 30, 40};', 4, 4),
(@lang_c, 'নিচের কোডে `*p`-এর মান কত?', 'int x = 7;
int *p = &x;', 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_c AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_c AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_c AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_c AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_c AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'int', 1), (@pq1, 'B', 'float', 0), (@pq1, 'C', 'char', 0), (@pq1, 'D', 'string', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'A', 1), (@pq2, 'B', 'B', 0), (@pq2, 'C', 'AB', 0), (@pq2, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', 'a ও b-এর গুণফল', 0), (@pq3, 'B', 'a ও b-এর যোগফল', 1), (@pq3, 'C', 'কিছুই না', 0), (@pq3, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', '10', 0), (@pq4, 'B', '20', 0), (@pq4, 'C', '30', 1), (@pq4, 'D', '40', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', 'x-এর মেমোরি অ্যাড্রেস', 0), (@pq5, 'B', '৭', 1), (@pq5, 'C', 'p-এর নিজের অ্যাড্রেস', 0), (@pq5, 'D', 'Error', 0);

-- ---------------------------------------------------------------------------
-- C++ — modules tested: basics, control-flow, oop, containers, stl
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_cpp FROM languages WHERE slug = 'cpp';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_cpp, 'নিচের কোডে `age` ভেরিয়েবলের টাইপ কী?', 'int age = 20;', 1, 1),
(@lang_cpp, 'নিচের কোডের আউটপুট কী হবে?', 'int x = 5;
if (x > 3) {
    cout << "A";
} else {
    cout << "B";
}', 2, 2),
(@lang_cpp, 'নিচের কোডের আউটপুট কী হবে?', 'class Car {
public:
    int speed = 80;
};

int main() {
    Car c;
    cout << c.speed;
}', 3, 3),
(@lang_cpp, 'নিচের কোডে `v[1]`-এর মান কত?', 'vector<int> v = {10, 20, 30};', 4, 4),
(@lang_cpp, 'নিচের কোডের পর `v.size()` কত হবে?', 'vector<int> v = {1, 2, 3};
v.push_back(4);', 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_cpp AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_cpp AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_cpp AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_cpp AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_cpp AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'int', 1), (@pq1, 'B', 'float', 0), (@pq1, 'C', 'char', 0), (@pq1, 'D', 'string', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'A', 1), (@pq2, 'B', 'B', 0), (@pq2, 'C', 'AB', 0), (@pq2, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', '80', 1), (@pq3, 'B', '0', 0), (@pq3, 'C', 'speed', 0), (@pq3, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', '10', 0), (@pq4, 'B', '20', 1), (@pq4, 'C', '30', 0), (@pq4, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', '3', 0), (@pq5, 'B', '4', 1), (@pq5, 'C', '5', 0), (@pq5, 'D', 'Error', 0);

-- ---------------------------------------------------------------------------
-- Java — modules tested: basics, control-flow, methods, arrays-strings, oop
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_java FROM languages WHERE slug = 'java';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_java, 'নিচের কোডে `age` ভেরিয়েবলের টাইপ কী?', 'int age = 20;', 1, 1),
(@lang_java, 'নিচের কোডের আউটপুট কী হবে?', 'int x = 5;
if (x > 3) {
    System.out.println("A");
} else {
    System.out.println("B");
}', 2, 2),
(@lang_java, 'নিচের মেথডটি কী রিটার্ন করে?', 'static int add(int a, int b) {
    return a + b;
}', 3, 3),
(@lang_java, 'নিচের কোডে `arr[2]`-এর মান কত?', 'int[] arr = {10, 20, 30, 40};', 4, 4),
(@lang_java, 'নিচের কোডের আউটপুট কী হবে?', 'class Dog {
    int age = 3;
}

public class Main {
    public static void main(String[] args) {
        Dog d = new Dog();
        System.out.println(d.age);
    }
}', 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_java AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_java AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_java AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_java AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_java AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'int', 1), (@pq1, 'B', 'double', 0), (@pq1, 'C', 'char', 0), (@pq1, 'D', 'String', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'A', 1), (@pq2, 'B', 'B', 0), (@pq2, 'C', 'AB', 0), (@pq2, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', 'a ও b-এর গুণফল', 0), (@pq3, 'B', 'a ও b-এর যোগফল', 1), (@pq3, 'C', 'কিছুই না', 0), (@pq3, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', '10', 0), (@pq4, 'B', '20', 0), (@pq4, 'C', '30', 1), (@pq4, 'D', '40', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', '3', 1), (@pq5, 'B', '0', 0), (@pq5, 'C', 'age', 0), (@pq5, 'D', 'Error', 0);

-- ---------------------------------------------------------------------------
-- Python — modules tested: basics, control-flow, functions, collections, strings
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_py FROM languages WHERE slug = 'python3';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_py, 'নিচের কোডে `age` ভেরিয়েবলের টাইপ কী?', 'age = 20', 1, 1),
(@lang_py, 'নিচের কোডের আউটপুট কী হবে?', 'x = 5
if x > 3:
    print("A")
else:
    print("B")', 2, 2),
(@lang_py, 'নিচের ফাংশনটি কী রিটার্ন করে?', 'def add(a, b):
    return a + b', 3, 3),
(@lang_py, 'নিচের কোডে `arr[2]`-এর মান কত?', 'arr = [10, 20, 30, 40]', 4, 4),
(@lang_py, 'নিচের কোডের আউটপুট কী হবে?', 's = "hello"
print(len(s))', 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_py AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_py AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_py AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_py AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_py AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'int', 1), (@pq1, 'B', 'float', 0), (@pq1, 'C', 'str', 0), (@pq1, 'D', 'list', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'A', 1), (@pq2, 'B', 'B', 0), (@pq2, 'C', 'AB', 0), (@pq2, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', 'a ও b-এর গুণফল', 0), (@pq3, 'B', 'a ও b-এর যোগফল', 1), (@pq3, 'C', 'কিছুই না', 0), (@pq3, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', '10', 0), (@pq4, 'B', '20', 0), (@pq4, 'C', '30', 1), (@pq4, 'D', '40', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', '4', 0), (@pq5, 'B', '5', 1), (@pq5, 'C', '6', 0), (@pq5, 'D', 'Error', 0);

-- ---------------------------------------------------------------------------
-- JavaScript — modules tested: basics, functions, arrays, objects, async-js
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_js FROM languages WHERE slug = 'javascript';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_js, 'নিচের কোডে `age` ভেরিয়েবলের টাইপ কী?', 'let age = 20;', 1, 1),
(@lang_js, 'নিচের ফাংশনটি কী রিটার্ন করে?', 'function add(a, b) {
    return a + b;
}', 2, 2),
(@lang_js, 'নিচের কোডে `arr[2]`-এর মান কত?', 'let arr = [10, 20, 30, 40];', 3, 3),
(@lang_js, 'নিচের কোডের আউটপুট কী হবে?', 'let user = { name: "Rimi", age: 22 };
console.log(user.age);', 4, 4),
(@lang_js, 'নিচের কোডের আউটপুট কোন অর্ডারে প্রিন্ট হবে?', 'console.log("A");
setTimeout(() => console.log("B"), 0);
console.log("C");', 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_js AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_js AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_js AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_js AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_js AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'number', 1), (@pq1, 'B', 'string', 0), (@pq1, 'C', 'boolean', 0), (@pq1, 'D', 'undefined', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'a ও b-এর গুণফল', 0), (@pq2, 'B', 'a ও b-এর যোগফল', 1), (@pq2, 'C', 'কিছুই না', 0), (@pq2, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', '10', 0), (@pq3, 'B', '20', 0), (@pq3, 'C', '30', 1), (@pq3, 'D', '40', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', 'Rimi', 0), (@pq4, 'B', '22', 1), (@pq4, 'C', 'undefined', 0), (@pq4, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', 'A, B, C', 0), (@pq5, 'B', 'A, C, B', 1), (@pq5, 'C', 'B, A, C', 0), (@pq5, 'D', 'C, B, A', 0);

-- ---------------------------------------------------------------------------
-- SQL — modules tested: basics (SELECT), filtering, aggregates, joins, dml
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_sql FROM languages WHERE slug = 'sql';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_sql, 'নিচের কোয়েরিটি কী রিটার্ন করবে?', 'SELECT name FROM students;', 1, 1),
(@lang_sql, 'নিচের কোয়েরিটি কোন students দেখাবে?', 'SELECT * FROM students WHERE age > 20;', 2, 2),
(@lang_sql, 'নিচের কোয়েরিটি কী গণনা করবে?', 'SELECT COUNT(*) FROM students;', 3, 3),
(@lang_sql, 'নিচের কোয়েরিতে `JOIN` কী কাজ করে?', 'SELECT s.name, c.title FROM students s JOIN courses c ON s.course_id = c.id;', 4, 4),
(@lang_sql, 'নিচের কোয়েরির পর কী পরিবর্তন হবে?', 'UPDATE students SET age = 21 WHERE id = 1;', 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_sql AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_sql AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_sql AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_sql AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_sql AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'শুধু name কলামের সব মান', 1), (@pq1, 'B', 'পুরো টেবিল', 0), (@pq1, 'C', 'শুধু প্রথম সারি', 0), (@pq1, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'যাদের বয়স ২০-এর বেশি', 1), (@pq2, 'B', 'যাদের বয়স ২০-এর কম', 0), (@pq2, 'C', 'সবাইকে', 0), (@pq2, 'D', 'কাউকে না', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', 'মোট students-এর সংখ্যা', 1), (@pq3, 'B', 'সব বয়সের যোগফল', 0), (@pq3, 'C', 'সর্বোচ্চ বয়স', 0), (@pq3, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', 'দুই টেবিলের সম্পর্কিত সারিগুলো একসাথে যুক্ত করে', 1), (@pq4, 'B', 'একটি টেবিল মুছে ফেলে', 0), (@pq4, 'C', 'নতুন টেবিল তৈরি করে', 0), (@pq4, 'D', 'কোনো প্রভাব নেই', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', 'id=1 এর student-এর age পরিবর্তন হয়ে 21 হবে', 1), (@pq5, 'B', 'সব students-এর age 21 হবে', 0), (@pq5, 'C', 'নতুন সারি যোগ হবে', 0), (@pq5, 'D', 'কোনো পরিবর্তন হবে না', 0);

-- ---------------------------------------------------------------------------
-- Data Structures (language-agnostic) — modules tested: arrays-lists,
-- stack-queue, linked-list, trees, graphs
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_ds FROM languages WHERE slug = 'data-structures';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_ds, 'নিচের অ্যারেতে `arr[2]`-এর মান কত?', 'arr = [10, 20, 30, 40]', 1, 1),
(@lang_ds, 'একটি স্ট্যাকে পরপর 1, 2, 3 push করার পর `pop()` করলে কী পাওয়া যাবে?', 'push(1)
push(2)
push(3)
pop()', 2, 2),
(@lang_ds, 'একটি সিঙ্গলি লিংকড লিস্টের প্রতিটি নোডে সাধারণত কী কী থাকে?', NULL, 3, 3),
(@lang_ds, 'একটি বাইনারি ট্রি-তে যে নোডের কোনো চাইল্ড নেই, তাকে কী বলা হয়?', NULL, 4, 4),
(@lang_ds, 'একটি গ্রাফে দুইটি নোডের (vertex) মধ্যে সংযোগকে কী বলা হয়?', NULL, 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_ds AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_ds AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_ds AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_ds AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_ds AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', '10', 0), (@pq1, 'B', '20', 0), (@pq1, 'C', '30', 1), (@pq1, 'D', '40', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', '1', 0), (@pq2, 'B', '2', 0), (@pq2, 'C', '3', 1), (@pq2, 'D', 'কিছুই না', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', 'শুধু ডেটা', 0), (@pq3, 'B', 'ডেটা ও পরের নোডের রেফারেন্স', 1), (@pq3, 'C', 'ডেটা ও ইনডেক্স', 0), (@pq3, 'D', 'শুধু একটি পয়েন্টার', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', 'রুট', 0), (@pq4, 'B', 'প্যারেন্ট', 0), (@pq4, 'C', 'লিফ', 1), (@pq4, 'D', 'এজ', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', 'নোড', 0), (@pq5, 'B', 'এজ', 1), (@pq5, 'C', 'পাথ', 0), (@pq5, 'D', 'সাইকেল', 0);

-- ---------------------------------------------------------------------------
-- Algorithms (language-agnostic) — modules tested: big-o, searching,
-- sorting, recursion, divide-conquer
-- ---------------------------------------------------------------------------
SELECT id INTO @lang_algo FROM languages WHERE slug = 'algorithms';

INSERT INTO placement_questions (language_id, question_bn, code_snippet, difficulty_weight, sort_order) VALUES
(@lang_algo, 'নিচের কমপ্লেক্সিটিগুলোর মধ্যে কোনটি সবচেয়ে দ্রুত (বড় ইনপুটের জন্য)?', NULL, 1, 1),
(@lang_algo, 'বাইনারি সার্চ ব্যবহার করার আগে অ্যারেটি কেমন হতে হবে?', NULL, 2, 2),
(@lang_algo, 'নিচের কোন সর্টিং অ্যালগরিদমের গড় (average) টাইম কমপ্লেক্সিটি O(n log n)?', NULL, 3, 3),
(@lang_algo, 'নিচের ফাংশনটি `factorial(3)` কল করলে কী রিটার্ন করবে?', 'function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}', 4, 4),
(@lang_algo, 'ডিভাইড অ্যান্ড কনকার পদ্ধতিতে মার্জ সর্ট প্রথমে কী করে?', NULL, 5, 5);

SELECT id INTO @pq1 FROM placement_questions WHERE language_id = @lang_algo AND sort_order = 1;
SELECT id INTO @pq2 FROM placement_questions WHERE language_id = @lang_algo AND sort_order = 2;
SELECT id INTO @pq3 FROM placement_questions WHERE language_id = @lang_algo AND sort_order = 3;
SELECT id INTO @pq4 FROM placement_questions WHERE language_id = @lang_algo AND sort_order = 4;
SELECT id INTO @pq5 FROM placement_questions WHERE language_id = @lang_algo AND sort_order = 5;

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq1, 'A', 'O(n^2)', 0), (@pq1, 'B', 'O(n)', 0), (@pq1, 'C', 'O(log n)', 1), (@pq1, 'D', 'O(n log n)', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq2, 'A', 'সাজানো (sorted)', 1), (@pq2, 'B', 'উল্টো সাজানো', 0), (@pq2, 'C', 'র‍্যান্ডম', 0), (@pq2, 'D', 'কোনো শর্ত নেই', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq3, 'A', 'বাবল সর্ট', 0), (@pq3, 'B', 'ইনসারশন সর্ট', 0), (@pq3, 'C', 'মার্জ সর্ট', 1), (@pq3, 'D', 'লিনিয়ার সার্চ', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq4, 'A', '3', 0), (@pq4, 'B', '6', 1), (@pq4, 'C', '9', 0), (@pq4, 'D', 'Error', 0);

INSERT INTO placement_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@pq5, 'A', 'পুরো অ্যারে একসাথে সর্ট করে', 0), (@pq5, 'B', 'অ্যারেটিকে ছোট ছোট অংশে ভাগ করে', 1), (@pq5, 'C', 'শুধু প্রথম এলিমেন্ট সরায়', 0), (@pq5, 'D', 'কিছুই করে না', 0);
