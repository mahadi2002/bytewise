-- Data Structures: AVL Trees & Balancing (new module 8).
-- Algorithms: Backtracking (new module 8).
-- Pseudocode throughout, matching the rest of these two tracks.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_ds   FROM languages WHERE slug = 'data-structures';
SELECT id INTO @lang_algo FROM languages WHERE slug = 'algorithms';
SELECT id INTO @m_avl   FROM modules WHERE language_id=@lang_ds AND slug='avl-trees';
SELECT id INTO @m_back  FROM modules WHERE language_id=@lang_algo AND slug='backtracking';

-- ── AVL Trees & Balancing ────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_avl, 'why-balance-matters', 'BST কেন "স্কিউড" হয়ে যেতে পারে', 'Why a BST Can Become Skewed',
'আগে দেখা BST-এ ভ্যালু যদি ইতিমধ্যে সর্টেড ক্রমে insert করা হয় (যেমন 1, 2, 3, 4, 5), তাহলে ট্রি একটা লম্বা "লাইন"-এর মতো হয়ে যায় — প্রতিটা নোডের শুধু একটা চাইল্ড থাকে। তখন সার্চের টাইম কমপ্লেক্সিটি `O(log n)`-এর বদলে `O(n)` হয়ে যায় — অ্যারেতে লিনিয়ার সার্চের মতোই ধীর, BST-এর মূল সুবিধাটাই হারিয়ে যায়।',
'// Inserting 1, 2, 3, 4, 5 in order into a plain BST:
1
 \
  2
   \
    3
     \
      4
       \
        5
// height = 5, same as a linked list — no better than O(n) search',
NULL, 10, 0, 1, 0),

(@m_avl, 'avl-balance-factor', 'AVL ট্রি: ব্যালান্স ফ্যাক্টর', 'AVL Trees: Balance Factor',
'একটা **AVL ট্রি** হলো এমন একটা BST, যা প্রতিটা insert/delete-এর পর নিজে থেকেই "ব্যালান্স" ঠিক রাখে। প্রতিটা নোডের **ব্যালান্স ফ্যাক্টর** (left সাবট্রির উচ্চতা − right সাবট্রির উচ্চতা) সবসময় `-1`, `0`, বা `1`-এর মধ্যে রাখা হয় — এর বাইরে গেলেই ট্রি পুনর্গঠন করা হয়।',
'// balance factor = height(left subtree) - height(right subtree)
// AVL rule: every node''s balance factor must be -1, 0, or 1

     8         balance factor of 8: height(left)=1, height(right)=1 -> 0 (balanced)
    / \
   3   10',
NULL, 10, 0, 2, 0),

(@m_avl, 'avl-rotations', 'রোটেশন: ব্যালান্স ঠিক করা', 'Rotations: Fixing the Balance',
'ব্যালান্স ফ্যাক্টর সীমা ছাড়িয়ে গেলে, একটা **রোটেশন** (নোডগুলোর অবস্থান পুনর্বিন্যাস, ভ্যালু পরিবর্তন ছাড়াই) দিয়ে ঠিক করা হয়। চারটা কেস: Left-Left, Right-Right, Left-Right, Right-Left — প্রতিটার জন্য নির্দিষ্ট রোটেশন প্যাটার্ন আছে। মূল ধারণা: রোটেশনের পরেও BST-এর "left < node < right" নিয়ম অক্ষত থাকে।',
'// Right-Right case: a single "left rotation" fixes it
    1                  2
     \                / \
      2      -->     1   3
       \
        3
// after rotation: balanced, and BST ordering is still valid',
NULL, 10, 0, 3, 0),

(@m_avl, 'avl-capstone', 'ক্যাপস্টোন: কেন AVL সার্চের গ্যারান্টি দেয়', 'Capstone: Why AVL Guarantees Search Time',
'একটা প্লেইন BST-এর ওয়ার্স্ট কেস `O(n)` (স্কিউড হয়ে গেলে), কিন্তু AVL ট্রি প্রতিটা অপারেশনের পর ব্যালান্স ঠিক রাখে বলে এর উচ্চতা সবসময় `O(log n)`-এর মধ্যে থাকে — তাই সার্চ, insert, delete, সবকিছুরই ওয়ার্স্ট-কেস গ্যারান্টি `O(log n)`, ইনপুট যেভাবেই আসুক না কেন।',
'// Plain BST worst case (sorted input): O(n) height -> O(n) search
// AVL tree: rotations keep height at O(log n), ALWAYS
//   -> search, insert, delete are all guaranteed O(log n)
//      even for adversarial/sorted input, unlike a plain BST',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_avl AND slug='why-balance-matters';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_avl AND slug='avl-balance-factor';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_avl AND slug='avl-rotations';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_avl AND slug='avl-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, '1,2,3,4,5 সর্টেড ক্রমে insert করলে প্লেইন BST-এর সার্চ কমপ্লেক্সিটি কত হয়ে যায়?', 'What does search complexity become for sorted-order insertion?', '// Inserting sorted values creates a "linked list" shaped tree',
'সর্টেড ক্রমে insert করলে প্রতিটা নতুন ভ্যালু সবসময় আগেরটার right চাইল্ড হয়ে যায় — ট্রি একটা লম্বা লাইনে পরিণত হয়, উচ্চতা `n`-এর সমান। তাই সার্চ `O(log n)`-এর বদলে `O(n)` হয়ে যায়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(log n), অপরিবর্তিত থাকে',0),(@q,'B','O(n)',1),(@q,'C','O(1)',0),(@q,'D','O(n^2)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'AVL ট্রিতে একটা নোডের বৈধ ব্যালান্স ফ্যাক্টর কী কী হতে পারে?', 'What are valid balance factors in an AVL tree?', '// balance factor = height(left) - height(right)',
'AVL-এর নিয়ম অনুযায়ী প্রতিটা নোডের ব্যালান্স ফ্যাক্টর অবশ্যই `-1`, `0`, বা `1`-এর একটা হতে হবে — এর বাইরে গেলেই ট্রি "আনব্যালান্সড" ধরা হয় এবং রোটেশন লাগে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু 0',0),(@q,'B','-1, 0, বা 1',1),(@q,'C','যেকোনো সংখ্যা',0),(@q,'D','শুধু ধনাত্মক সংখ্যা',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'রোটেশনের পরেও কী অক্ষত থাকে?', 'What remains intact after a rotation?', '// rotation rearranges node positions, values unchanged',
'রোটেশন শুধু নোডগুলোর *অবস্থান* পুনর্বিন্যাস করে, কোনো ভ্যালু মুছে বা পরিবর্তন করে না — এবং সবচেয়ে গুরুত্বপূর্ণ, BST-এর "left < node < right" অর্ডারিং নিয়মটা সবসময় অক্ষত রাখে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','BST-এর অর্ডারিং নিয়ম',1),(@q,'B','কিছুই অক্ষত থাকে না',0),(@q,'C','নোডের সংখ্যা কমে যায়',0),(@q,'D','ভ্যালুগুলো পরিবর্তিত হয়ে যায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'একটা প্লেইন BST-এর চেয়ে AVL ট্রির মূল সুবিধা কী?', 'What is the main advantage of AVL over a plain BST?', '// AVL guarantees O(log n) height always, even for sorted input',
'প্লেইন BST-এ ওয়ার্স্ট কেসে (যেমন সর্টেড ইনপুট) উচ্চতা `O(n)` হয়ে যেতে পারে। AVL ট্রি প্রতিটা অপারেশনের পর রোটেশন দিয়ে ব্যালান্স বজায় রাখে, তাই তার উচ্চতা সবসময় `O(log n)`-এর মধ্যে থাকার গ্যারান্টি দেয়, ইনপুট যাই হোক না কেন।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','AVL কম মেমোরি ব্যবহার করে',0),(@q,'B','AVL সবসময় O(log n) উচ্চতার গ্যারান্টি দেয়',1),(@q,'C','AVL ডুপ্লিকেট ভ্যালু রাখতে পারে',0),(@q,'D','কোনো পার্থক্য নেই',0);

-- ── Backtracking ─────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_back, 'backtracking-intro', 'ব্যাকট্র্যাকিং: চেষ্টা করো, ব্যর্থ হলে ফিরে যাও', 'Backtracking: Try, and Undo If It Fails',
'**ব্যাকট্র্যাকিং** একটা সমাধান ধাপে ধাপে বানায়, আর যেই মুহূর্তে বোঝা যায় বর্তমান পথটা কাজ করবে না, সাথে সাথে পেছনে ফিরে (ব্যাকট্র্যাক) অন্য একটা পথ চেষ্টা করে — পুরো সমাধান শেষ করে তারপর ভুল ধরার বদলে, যত দ্রুত সম্ভব ভুল পথ বাদ দিয়ে দেয়। এটা মূলত একটা "স্মার্ট" ব্রুট-ফোর্স।',
'// General backtracking shape:
function solve(state):
    if state is a complete solution:
        record it
        return
    for each choice available from state:
        make the choice
        solve(newState)     // recurse deeper
        undo the choice     // backtrack — try the next choice',
NULL, 10, 0, 1, 0),

(@m_back, 'n-queens-intro', 'উদাহরণ: N-Queens প্রবলেম', 'Example: The N-Queens Problem',
'ক্লাসিক ব্যাকট্র্যাকিং প্রবলেম — একটা `N×N` দাবার বোর্ডে `N`টা রানী (queen) এমনভাবে বসাও, যাতে কোনো দুটো রানী একে অপরকে আক্রমণ করতে না পারে (একই সারি, কলাম, বা কর্ণে না থাকে)। প্রতিটা সারিতে একটা করে রানী বসিয়ে, কোনো সংঘর্ষ হলে সেই বসানো বাতিল করে পরের অবস্থান চেষ্টা করা হয়।',
'function solveNQueens(board, row):
    if row == N:
        recordSolution(board)
        return
    for col from 0 to N-1:
        if isSafe(board, row, col):
            place(board, row, col)
            solveNQueens(board, row + 1)
            remove(board, row, col)  // backtrack',
NULL, 10, 0, 2, 0),

(@m_back, 'backtracking-vs-brute-force', 'ব্যাকট্র্যাকিং বনাম ব্রুট-ফোর্স', 'Backtracking vs Brute Force',
'একটা সাধারণ ব্রুট-ফোর্স সমাধান *সব* সম্ভাব্য কম্বিনেশন তৈরি করে, তারপর প্রতিটা যাচাই করে। ব্যাকট্র্যাকিং একই কাজ করে, কিন্তু যেই মুহূর্তে একটা আংশিক সমাধান স্পষ্টভাবে ভুল প্রমাণিত হয়, সেই শাখাটাই আর এগোয় না ("prune" করে দেয়) — অনেক অপ্রয়োজনীয় কাজ এড়িয়ে যায়, তাই ব্যবহারিকভাবে অনেক দ্রুত, যদিও ওয়ার্স্ট-কেস কমপ্লেক্সিটি একই থাকতে পারে।',
'// Brute force: generate all N^N placements, then check each
// Backtracking: check safety WHILE placing — invalid branches
//   are abandoned immediately, never fully explored
// Same worst-case complexity class, but backtracking prunes
// huge portions of the search space in practice',
NULL, 10, 0, 3, 0),

(@m_back, 'backtracking-capstone', 'ক্যাপস্টোন: সাবসেট তৈরি করা', 'Capstone: Generating Subsets',
'একটা সেটের সব সম্ভাব্য সাবসেট (উপসেট) খুঁজে বের করা — প্রতিটা এলিমেন্টের জন্য দুটো পথ আছে: "নাও" অথবা "নিও না"। এটাই ব্যাকট্র্যাকিং-এর সবচেয়ে সহজ, মৌলিক উদাহরণগুলোর একটা।',
'function findSubsets(nums, index, current):
    if index == length(nums):
        recordSubset(current)
        return

    // choice 1: include nums[index]
    current.append(nums[index])
    findSubsets(nums, index + 1, current)
    current.removeLast()  // backtrack

    // choice 2: exclude nums[index]
    findSubsets(nums, index + 1, current)

// findSubsets([1, 2], 0, []) produces: [], [1], [2], [1,2]',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_back AND slug='backtracking-intro';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_back AND slug='n-queens-intro';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_back AND slug='backtracking-vs-brute-force';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_back AND slug='backtracking-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'undo the choice লাইনটার (ব্যাকট্র্যাক করা) কাজ কী?', 'What does the "undo the choice" line do?', 'for each choice available from state:
    make the choice
    solve(newState)
    undo the choice     // backtrack',
'রিকার্সিভ কল ফিরে আসার পর, "undo" ধাপটা সেই choice-টা বাতিল করে দেয় যাতে পরের choice-টা একটা "পরিষ্কার" state থেকে চেষ্টা করা যায় — এটাই ব্যাকট্র্যাকিং-এর মূল কৌশল, একটা path শেষ করার পর আগের অবস্থায় ফিরে যাওয়া।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','পরের choice চেষ্টা করার আগে state-কে আগের অবস্থায় ফিরিয়ে আনে',1),(@q,'B','পুরো প্রোগ্রাম বন্ধ করে দেয়',0),(@q,'C','একটা নতুন সমাধান রেকর্ড করে',0),(@q,'D','কিছুই করে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'isSafe() মিথ্যা হলে কী হয়?', 'What happens if isSafe() is false?', 'for col from 0 to N-1:
    if isSafe(board, row, col):
        place(board, row, col)
        solveNQueens(board, row + 1)
        remove(board, row, col)',
'`isSafe()` মিথ্যা হলে সেই কলামে রানী বসানোই হয় না — `if` ব্লকের ভেতরের কোড (place/recurse/remove) স্কিপ হয়ে যায়, লুপ পরের কলাম চেষ্টা করে। এভাবেই ব্যাকট্র্যাকিং অবৈধ পথ আগেভাগেই বাদ দেয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সেই কলামে রানী বসানো স্কিপ হয়ে যায়, পরের কলাম চেষ্টা হয়',1),(@q,'B','প্রোগ্রাম থেমে যায়',0),(@q,'C','পুরো বোর্ড খালি হয়ে যায়',0),(@q,'D','সমাধান রেকর্ড হয়ে যায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'ব্যাকট্র্যাকিং ব্রুট-ফোর্সের চেয়ে ব্যবহারিকভাবে দ্রুত কেন?', 'Why is backtracking practically faster than brute force?', '// invalid branches are abandoned immediately, never fully explored',
'ব্যাকট্র্যাকিং একটা আংশিক সমাধান ভুল প্রমাণিত হওয়া মাত্র সেই শাখাটা বাদ দিয়ে দেয় ("prune"), পুরো শাখাটা শেষ পর্যন্ত এক্সপ্লোর না করেই — ব্রুট-ফোর্স সব কম্বিনেশন সম্পূর্ণ তৈরি করে তারপর চেক করে, অনেক বেশি অপ্রয়োজনীয় কাজ করে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা অবৈধ শাখা আগেভাগেই বাদ দিয়ে দেয়',1),(@q,'B','এটা কম মেমোরি ব্যবহার করে',0),(@q,'C','আসলে কোনো পার্থক্য নেই',0),(@q,'D','এটা সবসময় সঠিক উত্তর স্কিপ করে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'findSubsets([1, 2], 0, []) মোট কয়টা সাবসেট তৈরি করবে?', 'How many subsets does findSubsets([1,2], 0, []) produce?', '// findSubsets([1, 2], 0, []) produces: [], [1], [2], [1,2]',
'প্রতিটা এলিমেন্টের জন্য দুটো পথ (নাও/নিও না) থাকায়, ২টা এলিমেন্টে মোট `2^2 = 4`টা সাবসেট তৈরি হয়: [], [1], [2], [1,2]।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','2',0),(@q,'B','4',1),(@q,'C','8',0),(@q,'D','1',0);
