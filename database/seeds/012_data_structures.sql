-- Data Structures track: finish Arrays & Lists (3 more) + all 5 remaining
-- modules. Pseudocode throughout (code_sample_language = NULL), matching
-- lesson 1's language-agnostic style — this track is unlocked by ANY one
-- completed language (requires_any_language), not part of the strict chain.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'data-structures';
SELECT id INTO @m_arr  FROM modules WHERE language_id=@lang AND slug='arrays-lists';
SELECT id INTO @m_sq   FROM modules WHERE language_id=@lang AND slug='stack-queue';
SELECT id INTO @m_ll   FROM modules WHERE language_id=@lang AND slug='linked-list';
SELECT id INTO @m_tree FROM modules WHERE language_id=@lang AND slug='trees';
SELECT id INTO @m_gr   FROM modules WHERE language_id=@lang AND slug='graphs';
SELECT id INTO @m_hash FROM modules WHERE language_id=@lang AND slug='hash-tables';

-- ── Arrays & Lists (lessons 2-4) ────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_arr, 'array-operations', 'অ্যারে অপারেশন: insert, delete, search', 'Array Operations: Insert, Delete, Search',
'অ্যারেতে ইনডেক্স দিয়ে অ্যাক্সেস `O(1)` হলেও, মাঝখানে কোনো এলিমেন্ট **insert** বা **delete** করা `O(n)` — কারণ তার পরের সবগুলো এলিমেন্টকে একঘর করে সরাতে হয়। কোনো নির্দিষ্ট ভ্যালু **search** করাও (ইনডেক্স না জানা থাকলে) `O(n)` — প্রতিটা এলিমেন্ট একে একে চেক করা লাগে।',
'arr = [3, 7, 2, 9, 4]

// insert 100 at index 1: everything after must shift right
// [3, 100, 7, 2, 9, 4]  -- O(n)

// delete index 0: everything after must shift left
// [7, 2, 9, 4]  -- O(n)',
NULL, 10, 0, 2, 0),

(@m_arr, 'dynamic-arrays', 'ডাইনামিক অ্যারে: সাইজ বদলানো', 'Dynamic Arrays: Resizing',
'C-এর মতো ফিক্সড-সাইজ অ্যারের বদলে, বেশিরভাগ ভাষার built-in লিস্ট (Python-এর list, Java-এর ArrayList, C++-এর vector) **ডাইনামিক** — জায়গা শেষ হয়ে গেলে ভেতরে ভেতরে একটা বড় নতুন অ্যারে বানিয়ে সব ডেটা কপি করে নেয়। এই কপি করাটা মাঝেমধ্যে ঘটে বলে, গড়ে (amortized) শেষে এলিমেন্ট যোগ করা এখনও `O(1)`-এর কাছাকাছি ধরা হয়।',
'// conceptually:
list = []          // starts with small internal capacity
list.append(1)     // O(1) usually
list.append(2)     // O(1) usually
// ... capacity full ...
list.append(100)   // O(n) this one time: copies everything to a bigger array',
NULL, 10, 0, 3, 0),

(@m_arr, 'arrays-capstone-ds', 'ক্যাপস্টোন: দ্বিতীয় সর্বোচ্চ ভ্যালু খুঁজে বের করা', 'Capstone: Finding the Second Largest',
'একটা ক্লাসিক প্রবলেম — একবারই অ্যারে লুপ করে (দুইবার নয়) সবচেয়ে বড় আর দ্বিতীয় সবচেয়ে বড় ভ্যালু খুঁজে বের করা, `O(n)` টাইমে।',
'arr = [12, 45, 7, 89, 34]
largest = -infinity
secondLargest = -infinity

for x in arr:
    if x > largest:
        secondLargest = largest
        largest = x
    else if x > secondLargest:
        secondLargest = x

// largest = 89, secondLargest = 45',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_arr AND slug='array-operations';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_arr AND slug='dynamic-arrays';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_arr AND slug='arrays-capstone-ds';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'অ্যারের মাঝখানে একটা এলিমেন্ট insert করার টাইম কমপ্লেক্সিটি কত?', 'What is the time complexity of inserting in the middle of an array?', '// insert at index 1: everything after must shift right',
'মাঝখানে insert করলে তার পরের সব এলিমেন্টকে একঘর করে ডানদিকে সরাতে হয় — সবচেয়ে খারাপ ক্ষেত্রে (শুরুতে insert করলে) প্রায় পুরো অ্যারে সরাতে হতে পারে, তাই এটা `O(n)`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(1)',0),(@q,'B','O(n)',1),(@q,'C','O(n^2)',0),(@q,'D','O(log n)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'ডাইনামিক অ্যারের ক্যাপাসিটি শেষ হয়ে গেলে কী হয়?', 'What happens when a dynamic array''s capacity runs out?', 'list.append(100)   // capacity full — what happens?',
'একটা বড় নতুন অ্যারে তৈরি হয় এবং পুরনো সব ডেটা সেখানে কপি করা হয় — এই একটা অপারেশন `O(n)`, কিন্তু এটা কালেভদ্রে ঘটে বলে গড়ে (amortized) প্রতি `append()`-কে প্রায় `O(1)` ধরা হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রোগ্রাম ক্র্যাশ করে',0),(@q,'B','একটা বড় নতুন অ্যারে বানিয়ে সব ডেটা কপি হয়',1),(@q,'C','পুরনো ডেটা মুছে যায়',0),(@q,'D','কিছুই হয় না, এলিমেন্ট হারিয়ে যায়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'arr = [12, 45, 7, 89, 34] — secondLargest এর মান কত হবে?', 'What is secondLargest for this array?', 'arr = [12, 45, 7, 89, 34]
// finds the two largest values in one pass',
'সবচেয়ে বড় ভ্যালু `89`। বাকি ভ্যালুগুলোর (12, 45, 7, 34) মধ্যে সবচেয়ে বড় হলো `45` — তাই `secondLargest = 45`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','89',0),(@q,'B','45',1),(@q,'C','34',0),(@q,'D','7',0);

-- ── Stack & Queue ────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_sq, 'stack-basics', 'স্ট্যাক: LIFO', 'Stack: LIFO',
'একটা **স্ট্যাক** একগাদা প্লেটের মতো কাজ করে — যেটা সবার শেষে রাখা হয়েছে, সেটাই সবার আগে বের হয় (**LIFO**: Last In, First Out)। মূল দুটো অপারেশন: `push` (উপরে রাখা) আর `pop` (উপর থেকে সরানো) — দুটোই `O(1)`।',
'stack = []
stack.push(1)   // [1]
stack.push(2)   // [1, 2]
stack.push(3)   // [1, 2, 3]

top = stack.pop()  // removes and returns 3 — the LAST one pushed
// stack is now [1, 2]',
NULL, 10, 0, 1, 0),

(@m_sq, 'stack-applications', 'স্ট্যাকের ব্যবহার: ব্যালান্সড ব্র্যাকেট', 'Stack Applications: Balanced Brackets',
'ব্র্যাকেট (`()`, `[]`, `{}`) ব্যালান্সড কিনা চেক করার একটা ক্লাসিক প্রবলেম স্ট্যাক দিয়ে সহজে সমাধান করা যায় — ওপেনিং ব্র্যাকেট পেলে push, ক্লোজিং পেলে pop করে মিলিয়ে দেখা।',
'function isBalanced(s):
    stack = []
    for ch in s:
        if ch is an opening bracket:
            stack.push(ch)
        else if ch is a closing bracket:
            if stack is empty or stack.pop() does not match ch:
                return false
    return stack is empty  // must have popped everything',
NULL, 10, 0, 2, 0),

(@m_sq, 'queue-basics', 'কিউ: FIFO', 'Queue: FIFO',
'একটা **কিউ** লাইনে দাঁড়ানোর মতো — যে আগে এসেছে, সে আগে বের হয় (**FIFO**: First In, First Out)। মূল দুটো অপারেশন: `enqueue` (পেছনে যোগ করা) আর `dequeue` (সামনে থেকে সরানো)।',
'queue = []
queue.enqueue(1)  // [1]
queue.enqueue(2)  // [1, 2]
queue.enqueue(3)  // [1, 2, 3]

front = queue.dequeue()  // removes and returns 1 — the FIRST one enqueued
// queue is now [2, 3]',
NULL, 10, 0, 3, 0),

(@m_sq, 'stack-queue-capstone', 'ক্যাপস্টোন: স্ট্যাক দিয়ে স্ট্রিং রিভার্স করা', 'Capstone: Reversing a String with a Stack',
'স্ট্যাকের LIFO বৈশিষ্ট্য ব্যবহার করে একটা স্ট্রিং উল্টে দেওয়া হচ্ছে — প্রতিটা অক্ষর push করে, তারপর সব pop করলে উল্টো ক্রমে বের হয়ে আসে।',
'function reverse(s):
    stack = []
    for ch in s:
        stack.push(ch)

    result = ""
    while stack is not empty:
        result = result + stack.pop()
    return result

// reverse("hello") -> "olleh"',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_sq AND slug='stack-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_sq AND slug='stack-applications';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_sq AND slug='queue-basics';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_sq AND slug='stack-queue-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'stack.pop() কোন এলিমেন্টটা রিটার্ন করবে?', 'Which element does stack.pop() return?', 'stack.push(1); stack.push(2); stack.push(3);
stack.pop();',
'স্ট্যাক LIFO (Last In, First Out) — সবার শেষে push হওয়া এলিমেন্টই সবার আগে pop হয়। এখানে সবার শেষে push হয়েছিল `3`, তাই `pop()` রিটার্ন করবে `3`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','1',0),(@q,'B','2',0),(@q,'C','3',1),(@q,'D','সবগুলো একসাথে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'ব্র্যাকেট ব্যালান্স চেক করার সময় ক্লোজিং ব্র্যাকেট পেলে কী করা হয়?', 'What happens on a closing bracket?', 'else if ch is a closing bracket:
    if stack is empty or stack.pop() does not match ch:
        return false',
'ক্লোজিং ব্র্যাকেট পেলে স্ট্যাক থেকে সর্বশেষ ওপেনিং ব্র্যাকেটটা pop করে মেলানো হয় — যদি স্ট্যাক খালি থাকে (মেলানোর মতো কিছু নেই) বা মিল না খায়, তাহলে ব্যালান্সড নয় বলে সাথে সাথে `false` রিটার্ন করা হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','স্ট্যাকে আরেকটা push করা হয়',0),(@q,'B','স্ট্যাক থেকে pop করে মেলানো হয়',1),(@q,'C','কিছুই করা হয় না',0),(@q,'D','স্ট্যাক খালি করে দেওয়া হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'queue.dequeue() কোন এলিমেন্টটা রিটার্ন করবে?', 'Which element does queue.dequeue() return?', 'queue.enqueue(1); queue.enqueue(2); queue.enqueue(3);
queue.dequeue();',
'কিউ FIFO (First In, First Out) — সবার আগে enqueue হওয়া এলিমেন্টই সবার আগে dequeue হয়। এখানে সবার আগে enqueue হয়েছিল `1`, তাই `dequeue()` রিটার্ন করবে `1`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','1',1),(@q,'B','2',0),(@q,'C','3',0),(@q,'D','সবগুলো একসাথে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'reverse("abc") এর ফলাফল কী হবে?', 'What does reverse("abc") return?', 'function reverse(s):
    stack = []
    for ch in s: stack.push(ch)
    // then pop everything',
'"a", "b", "c" ক্রমে push হয় (স্ট্যাক: a,b,c — c উপরে)। pop করলে প্রথমে "c", তারপর "b", তারপর "a" বের হয় — ফলাফল "cba"।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','abc',0),(@q,'B','cba',1),(@q,'C','bac',0),(@q,'D','খালি স্ট্রিং',0);

-- ── Linked List ──────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_ll, 'linked-list-basics', 'লিংকড লিস্ট: নোড ও পরের দিকে নির্দেশ', 'Linked Lists: Nodes & next Pointers',
'একটা **লিংকড লিস্ট** অ্যারের মতো একগাদা ভ্যালু পাশাপাশি রাখে না — বরং প্রতিটা **নোড**-এ একটা ভ্যালু আর পরের নোডের রেফারেন্স (`next`) থাকে। শেষ নোডের `next` হয় `null`। মেমোরিতে নোডগুলো পাশাপাশি থাকতে হয় না, যেখানে জায়গা পাওয়া যায় সেখানেই থাকতে পারে।',
'// node: { value, next }
head -> {1, next} -> {2, next} -> {3, next} -> null

// to read value 3, you must walk from head:
// head.next.next.value == 3',
NULL, 10, 0, 1, 0),

(@m_ll, 'linked-list-insert-delete', 'লিংকড লিস্টে insert ও delete', 'Insert & Delete in a Linked List',
'শুরুতে insert/delete করা লিংকড লিস্টে `O(1)` — শুধু কয়েকটা `next` পয়েন্টার বদলাতে হয়, অ্যারের মতো বাকি সব এলিমেন্ট সরাতে হয় না। কিন্তু মাঝখানের কোনো নির্দিষ্ট নোড খুঁজতে হলে শুরু থেকে হেঁটে যেতে হয় (`O(n)`), অ্যারের ইনডেক্স অ্যাক্সেসের মতো সরাসরি `O(1)`-এ যাওয়া যায় না।',
'// insert 100 at the head: O(1)
newNode.next = head
head = newNode

// delete the head: O(1)
head = head.next',
NULL, 10, 0, 2, 0),

(@m_ll, 'linked-list-vs-array', 'লিংকড লিস্ট বনাম অ্যারে', 'Linked List vs Array',
'অ্যারে: ইনডেক্স অ্যাক্সেস `O(1)`, কিন্তু মাঝখানে insert/delete `O(n)`। লিংকড লিস্ট: শুরুতে insert/delete `O(1)`, কিন্তু ইনডেক্স অ্যাক্সেস করতে `O(n)` (হেঁটে যেতে হয়)। কোনটা ব্যবহার হবে তা নির্ভর করে বেশি কোন অপারেশন লাগবে তার উপর।',
'// Array:        fast random access, slow middle insert/delete
// Linked List:   slow random access, fast insert/delete at the ends',
NULL, 10, 0, 3, 0),

(@m_ll, 'linked-list-capstone', 'ক্যাপস্টোন: লিংকড লিস্ট উল্টানো', 'Capstone: Reversing a Linked List',
'একটা ক্লাসিক ইন্টারভিউ প্রবলেম — লিংকড লিস্টের প্রতিটা নোডের `next` পয়েন্টার উল্টে দিয়ে পুরো লিস্টটা রিভার্স করা, কোনো নতুন লিস্ট বা অ্যারে ছাড়াই।',
'function reverse(head):
    prev = null
    current = head
    while current is not null:
        nextNode = current.next
        current.next = prev   // reverse the pointer
        prev = current
        current = nextNode
    return prev  // new head',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_ll AND slug='linked-list-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_ll AND slug='linked-list-insert-delete';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_ll AND slug='linked-list-vs-array';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_ll AND slug='linked-list-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'শেষ নোডের next কী হয়?', 'What is the last node''s next?', 'head -> {1, next} -> {2, next} -> {3, next} -> null',
'লিংকড লিস্টের শেষ নোড কোনো পরের নোডকে নির্দেশ করে না — এটাই লিস্টের শেষ বলে চিহ্নিত করার উপায়। তাই শেষ নোডের `next` হয় `null`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রথম নোডকে নির্দেশ করে',0),(@q,'B','null',1),(@q,'C','নিজেকেই নির্দেশ করে',0),(@q,'D','একটা সংখ্যা',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'লিস্টের শুরুতে (head-এ) একটা নোড insert করার টাইম কমপ্লেক্সিটি কত?', 'What is the time complexity of inserting at the head?', 'newNode.next = head
head = newNode',
'শুধু দুটো পয়েন্টার বদলালেই কাজ শেষ — বাকি কোনো নোড সরাতে হয় না, কোনো লুপও লাগে না। তাই এটা `O(1)`।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(1)',1),(@q,'B','O(n)',0),(@q,'C','O(n^2)',0),(@q,'D','O(log n)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'অ্যারে আর লিংকড লিস্টের মধ্যে প্রধান পার্থক্য কী?', 'What is the key tradeoff between array and linked list?', '// Array: fast random access, slow middle insert/delete
// Linked List: slow random access, fast insert/delete at ends',
'অ্যারেতে ইনডেক্স অ্যাক্সেস দ্রুত (`O(1)`) কিন্তু মাঝখানে insert/delete ধীর (`O(n)`)। লিংকড লিস্টে উল্টো — শুরুতে insert/delete দ্রুত (`O(1)`) কিন্তু কোনো নির্দিষ্ট ইনডেক্সে পৌঁছাতে ধীর (`O(n)`, হেঁটে যেতে হয়)।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','দুটোই সবক্ষেত্রে সমান',0),(@q,'B','অ্যারে দ্রুত অ্যাক্সেস দেয়, লিংকড লিস্ট দ্রুত insert/delete দেয় (শুরুতে)',1),(@q,'C','লিংকড লিস্ট সবসময় দ্রুত',0),(@q,'D','অ্যারে সবসময় দ্রুত',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'reverse() ফাংশনে current.next = prev লাইনটার কাজ কী?', 'What does current.next = prev do here?', 'current.next = prev   // reverse the pointer
prev = current
current = nextNode',
'এটাই আসল "রিভার্স" করার কাজ — বর্তমান নোডটির `next` পয়েন্টার আগের দিকে (`prev`-এর দিকে) ঘুরিয়ে দেওয়া হয়, ফরওয়ার্ড দিকের বদলে ব্যাকওয়ার্ড দিকে নির্দেশ করানো হয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','নোডটা মুছে ফেলে',0),(@q,'B','পয়েন্টারের দিক উল্টে দেয়, পেছনের নোডের দিকে',1),(@q,'C','একটা নতুন নোড তৈরি করে',0),(@q,'D','কিছুই করে না',0);

-- ── Trees ────────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_tree, 'tree-basics', 'ট্রি: root, node ও leaf', 'Trees: Root, Node & Leaf',
'একটা **ট্রি** হলো এমন একটা স্ট্রাকচার, যেখানে প্রতিটা নোডের একটা প্যারেন্ট থাকে (root ছাড়া), আর একাধিক চাইল্ড থাকতে পারে। যে নোডের কোনো চাইল্ড নেই তাকে **leaf** বলে। একটা **বাইনারি ট্রি**-তে প্রতিটা নোডের সর্বোচ্চ ২টা চাইল্ড থাকতে পারে (left আর right)।',
'        1        <- root
      /   \
     2     3      <- 2 and 3 are children of 1
    / \
   4   5          <- 4 and 5 are leaves (no children)',
NULL, 10, 0, 1, 0),

(@m_tree, 'binary-search-tree', 'বাইনারি সার্চ ট্রি (BST)', 'Binary Search Tree (BST)',
'একটা **BST**-এ একটা বিশেষ নিয়ম মানা হয়: প্রতিটা নোডের left সাবট্রির সব ভ্যালু তার চেয়ে ছোট, আর right সাবট্রির সব ভ্যালু তার চেয়ে বড়। এই নিয়মের কারণেই BST-তে সার্চ, insert, delete — গড়ে `O(log n)` টাইমে করা যায় (ব্যালান্সড থাকলে)।',
'        8
      /   \
     3     10
    / \      \
   1   6      14

// searching for 6: 8 -> go left (6<8) -> 3 -> go right (6>3) -> found it
// only visited 3 nodes, not all 6',
NULL, 10, 0, 2, 0),

(@m_tree, 'tree-traversal', 'ট্রি ট্রাভার্সাল: inorder, preorder, postorder', 'Tree Traversal: Inorder, Preorder, Postorder',
'একটা ট্রির সব নোড ভিজিট করার তিনটা কমন উপায়: **inorder** (left → node → right — BST-তে এটা ছোট থেকে বড় ক্রমে ভ্যালু দেয়), **preorder** (node → left → right), **postorder** (left → right → node)।',
'        1
      /   \
     2     3

// inorder:   2, 1, 3
// preorder:  1, 2, 3
// postorder: 2, 3, 1',
NULL, 10, 0, 3, 0),

(@m_tree, 'trees-capstone', 'ক্যাপস্টোন: ট্রির উচ্চতা বের করা', 'Capstone: Finding a Tree''s Height',
'রিকার্শন দিয়ে একটা বাইনারি ট্রির **উচ্চতা** (root থেকে সবচেয়ে দূরের leaf পর্যন্ত দূরত্ব) বের করা হচ্ছে — প্রতিটা সাবট্রির উচ্চতা রিকার্সিভলি বের করে, বড়টা নিয়ে ১ যোগ করা।',
'function height(node):
    if node is null:
        return 0  // base case: empty tree has height 0
    leftHeight = height(node.left)
    rightHeight = height(node.right)
    return 1 + max(leftHeight, rightHeight)',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_tree AND slug='tree-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_tree AND slug='binary-search-tree';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_tree AND slug='tree-traversal';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_tree AND slug='trees-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'নিচের ট্রিতে কোন নোডগুলো leaf?', 'Which nodes are leaves here?', '        1
      /   \
     2     3
    / \
   4   5',
'যে নোডের কোনো চাইল্ড নেই তাকে leaf বলে — এখানে `4`, `5`, আর `3`-এর কোনো চাইল্ড নেই, তাই তিনটাই leaf। `1` আর `2`-এর চাইল্ড আছে, তাই তারা leaf নয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুধু 1',0),(@q,'B','4, 5, এবং 3',1),(@q,'C','2 এবং 3',0),(@q,'D','সবগুলো নোড',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'BST-তে 6 খুঁজতে গেলে root (8) থেকে কোন দিকে যাওয়া হবে?', 'From root 8, which way do you go searching for 6?', '        8
      /   \
     3     10
    / \
   1   6',
'BST-এর নিয়ম: বর্তমান নোডের চেয়ে ছোট হলে বামে যাও, বড় হলে ডানে। `6 < 8`, তাই বামে (`3`-এর দিকে) যেতে হবে — ডানের সাবট্রি (১০, যার সব ভ্যালু ৮-এর চেয়ে বড়) চেকই করা লাগে না।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ডানে (10-এর দিকে)',0),(@q,'B','বামে (3-এর দিকে)',1),(@q,'C','দুই দিকেই একসাথে',0),(@q,'D','কোনো দিকেই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'একটা BST-তে inorder ট্রাভার্সাল কী ক্রমে ভ্যালু দেয়?', 'What order does inorder traversal give on a BST?', '// inorder: left -> node -> right',
'BST-এর "left < node < right" নিয়মের কারণে, inorder ট্রাভার্সাল (left → node → right) BST-তে সবসময় ভ্যালুগুলো ছোট থেকে বড় (sorted) ক্রমে দেয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এলোমেলো ক্রমে',0),(@q,'B','ছোট থেকে বড় (sorted) ক্রমে',1),(@q,'C','বড় থেকে ছোট ক্রমে',0),(@q,'D','root সবসময় প্রথমে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'height(node) এ node null হলে কী রিটার্ন হয়?', 'What does height(node) return if node is null?', 'function height(node):
    if node is null:
        return 0',
'এটাই এই রিকার্সিভ ফাংশনের base case — একটা খালি (null) সাবট্রির উচ্চতা `0` ধরা হয়, যা রিকার্শনকে থামিয়ে দেয় (base case ছাড়া রিকার্শন অসীমবার চলতে থাকত)।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',1),(@q,'B','-1',0),(@q,'C','1',0),(@q,'D','Error',0);

-- ── Graphs ───────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_gr, 'graph-basics', 'গ্রাফ: vertex, edge ও directed/undirected', 'Graphs: Vertices, Edges & Directed/Undirected',
'একটা **গ্রাফ** হলো **vertex** (নোড) আর তাদের মধ্যে সংযোগকারী **edge**-এর সমষ্টি — ট্রির চেয়ে বেশি ফ্লেক্সিবল, কোনো একক root বা নির্দিষ্ট প্যারেন্ট-চাইল্ড কাঠামো নেই। **Directed** গ্রাফে edge-এর একটা দিক থাকে (A → B মানে B → A নাও হতে পারে), **undirected**-এ সম্পর্কটা দুই দিকেই সমান।',
'// undirected graph:
A -- B
|    |
C -- D

// edges: A-B, A-C, B-D, C-D',
NULL, 10, 0, 1, 0),

(@m_gr, 'graph-representation', 'গ্রাফ রিপ্রেজেন্টেশন: adjacency list', 'Graph Representation: Adjacency List',
'একটা গ্রাফকে কোডে রাখার সবচেয়ে কমন উপায় **adjacency list** — প্রতিটা vertex-এর জন্য একটা লিস্ট, যাতে তার সরাসরি সংযুক্ত প্রতিবেশীরা থাকে। বেশিরভাগ বাস্তব গ্রাফে (edge সংখ্যা vertex-এর তুলনায় কম) এটা adjacency matrix-এর চেয়ে জায়গা কম নেয়।',
'graph = {
    "A": ["B", "C"],
    "B": ["A", "D"],
    "C": ["A", "D"],
    "D": ["B", "C"]
}',
NULL, 10, 0, 2, 0),

(@m_gr, 'bfs-dfs', 'BFS ও DFS: গ্রাফ ট্রাভার্সাল', 'BFS & DFS: Graph Traversal',
'**BFS** (Breadth-First Search) একটা **কিউ** ব্যবহার করে স্তরে স্তরে (কাছের প্রতিবেশী আগে) ঘোরে — শর্টেস্ট পাথ বের করতে কাজে লাগে। **DFS** (Depth-First Search) একটা **স্ট্যাক** (বা রিকার্শন) ব্যবহার করে একটা পথ যতদূর যাওয়া যায় ততদূর গিয়ে তারপর ফিরে আসে।',
'function bfs(start):
    queue = [start]
    visited = {start}
    while queue is not empty:
        node = queue.dequeue()
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.enqueue(neighbor)',
NULL, 10, 0, 3, 0),

(@m_gr, 'graphs-capstone', 'ক্যাপস্টোন: দুটো নোডের মধ্যে পথ আছে কিনা', 'Capstone: Is There a Path Between Two Nodes?',
'BFS ব্যবহার করে একটা গ্রাফে দুটো নির্দিষ্ট নোডের মধ্যে কোনো পথ আছে কিনা চেক করা হচ্ছে — start থেকে শুরু করে সবাইকে ভিজিট করতে করতে target পাওয়া গেলে সাথে সাথে true রিটার্ন।',
'function hasPath(graph, start, target):
    queue = [start]
    visited = {start}
    while queue is not empty:
        node = queue.dequeue()
        if node == target:
            return true
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.enqueue(neighbor)
    return false',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_gr AND slug='graph-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_gr AND slug='graph-representation';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_gr AND slug='bfs-dfs';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_gr AND slug='graphs-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'Directed গ্রাফে A -> B থাকলে কি B -> A ও থাকতে হবে?', 'In a directed graph, if A -> B exists, must B -> A exist too?', '// directed: A -> B does NOT imply B -> A',
'Directed গ্রাফে প্রতিটা edge-এর একটা নির্দিষ্ট দিক থাকে — `A -> B` মানে A থেকে B-তে যাওয়া যায়, কিন্তু এর মানে এই নয় যে B থেকে A-তেও যাওয়া যাবে। উদাহরণ: টুইটার ফলো করা একমুখী সম্পর্ক।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','হ্যাঁ, সবসময় থাকতে হবে',0),(@q,'B','না, directed edge একমুখী',1),(@q,'C','শুধু undirected গ্রাফে এটা সম্ভব',0),(@q,'D','এটা গ্রাফের সংজ্ঞার বিরুদ্ধে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'graph["A"] এই adjacency list-এ কী রাখে?', 'What does graph["A"] store in an adjacency list?', 'graph = {
    "A": ["B", "C"],
    ...
}',
'Adjacency list-এ প্রতিটা vertex-এর key-তে তার *সরাসরি সংযুক্ত প্রতিবেশীদের* একটা লিস্ট থাকে — `graph["A"] = ["B", "C"]` মানে A সরাসরি B আর C-এর সাথে সংযুক্ত।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','A-এর সরাসরি প্রতিবেশীদের লিস্ট',1),(@q,'B','পুরো গ্রাফের সব vertex',0),(@q,'C','A-এর একটা সংখ্যাসূচক মান',0),(@q,'D','কিছুই না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'BFS কোন ডেটা স্ট্রাকচার ব্যবহার করে?', 'Which data structure does BFS use?', 'function bfs(start):
    queue = [start]
    ...',
'BFS একটা **কিউ** (FIFO) ব্যবহার করে — এই কারণেই এটা স্তরে স্তরে ঘোরে, কাছের নোড আগে ভিজিট হয়। DFS বরং একটা স্ট্যাক (বা রিকার্শন) ব্যবহার করে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','স্ট্যাক',0),(@q,'B','কিউ',1),(@q,'C','অ্যারে (সর্টেড)',0),(@q,'D','হ্যাশ টেবিল',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'hasPath()-এ visited সেট রাখার কারণ কী?', 'Why does hasPath() keep a visited set?', 'if neighbor not in visited:
    visited.add(neighbor)
    queue.enqueue(neighbor)',
'`visited` না রাখলে একই নোড বারবার কিউতে যোগ হতে পারত (বিশেষ করে সাইকেল থাকা গ্রাফে), যার ফলে প্রোগ্রাম অসীমবার লুপ করতে থাকত। প্রতিটা নোড একবারই ভিজিট নিশ্চিত করতেই `visited` লাগে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কোড সুন্দর দেখানোর জন্য',0),(@q,'B','একই নোড বারবার ভিজিট/ইনফিনিট লুপ ঠেকাতে',1),(@q,'C','মেমোরি বাঁচাতে',0),(@q,'D','কোনো কারণ নেই, ঐচ্ছিক',0);

-- ── Hash Tables ──────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_hash, 'hash-table-basics', 'হ্যাশ টেবিল: key-value ও হ্যাশ ফাংশন', 'Hash Tables: Key-Value & Hash Functions',
'একটা **হ্যাশ টেবিল** key-value পেয়ার রাখে (Python-এর dict, JavaScript-এর object, Java-এর HashMap — সবই আসলে হ্যাশ টেবিল)। একটা **হ্যাশ ফাংশন** প্রতিটা key-কে একটা সংখ্যায় (index) রূপান্তর করে, যেখানে ভ্যালুটা সরাসরি রাখা হয় — এই কারণেই key দিয়ে অ্যাক্সেস গড়ে `O(1)`, লিস্টে লুপ করে খোঁজার (`O(n)`) দরকার হয় না।',
'// conceptually:
hash("Rafi") -> 7   // some index
table[7] = { "Rafi": 20 }

// lookup: hash("Rafi") -> 7 -> directly check table[7]. O(1) average.',
NULL, 10, 0, 1, 0),

(@m_hash, 'collision-handling', 'কলিশন হ্যান্ডলিং', 'Collision Handling',
'দুটো ভিন্ন key কখনো কখনো একই index-এ হ্যাশ হয়ে যেতে পারে — একে **কলিশন** বলে। সবচেয়ে সাধারণ সমাধান **চেইনিং**: একই index-এ একাধিক এন্ট্রি রাখতে সেখানে একটা ছোট লিংকড লিস্ট রাখা হয়। ভালো হ্যাশ ফাংশন কলিশন কম করে, কিন্তু পুরোপুরি এড়ানো যায় না।',
'// two keys hash to the same index (collision):
hash("Rafi") -> 7
hash("Nadia") -> 7  // collision!

// chaining: index 7 holds a small list
table[7] = [("Rafi", 20), ("Nadia", 22)]',
NULL, 10, 0, 2, 0),

(@m_hash, 'hash-table-use-cases', 'হ্যাশ টেবিল কখন ব্যবহার করবেন', 'When to Use a Hash Table',
'"এই ভ্যালুটা কি আগে দেখা হয়েছে?" বা "এই key-এর ভ্যালু কী?" — এই ধরনের প্রশ্নের জন্য হ্যাশ টেবিল আদর্শ, কারণ গড়ে `O(1)` লুকআপ দেয়। যেখানে ক্রম (order) গুরুত্বপূর্ণ, সেখানে হ্যাশ টেবিল উপযুক্ত নয় — সাধারণত কোনো নির্দিষ্ট ক্রম গ্যারান্টি করে না।',
'// classic use case: checking for duplicates
seen = {}
for num in [1, 2, 3, 2, 4]:
    if num in seen:
        print("Duplicate found:", num)  // 2
    seen[num] = true',
NULL, 10, 0, 3, 0),

(@m_hash, 'hash-table-capstone', 'ক্যাপস্টোন: শব্দের ফ্রিকোয়েন্সি গোনা', 'Capstone: Counting Word Frequency',
'একটা টেক্সটে প্রতিটা শব্দ কতবার এসেছে, তা হ্যাশ টেবিল দিয়ে `O(n)` টাইমে গোনা হচ্ছে — প্রতিটা শব্দ একবার পড়েই কাউন্ট আপডেট হয়, আর যেকোনো শব্দের কাউন্ট দেখতে `O(1)`।',
'function countWords(words):
    freq = {}
    for word in words:
        if word in freq:
            freq[word] = freq[word] + 1
        else:
            freq[word] = 1
    return freq

// countWords(["a", "b", "a", "c", "a"]) -> {"a": 3, "b": 1, "c": 1}',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_hash AND slug='hash-table-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_hash AND slug='collision-handling';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_hash AND slug='hash-table-use-cases';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_hash AND slug='hash-table-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'key দিয়ে হ্যাশ টেবিলে লুকআপের গড় টাইম কমপ্লেক্সিটি কত?', 'What is the average lookup time by key?', 'hash("Rafi") -> 7 -> directly check table[7]',
'হ্যাশ ফাংশন সরাসরি key থেকে index বের করে দেয়, তাই বাকি এন্ট্রিগুলো চেক করার দরকার হয় না — গড়ে এটা `O(1)`, যেখানে লিস্টে লুপ করে খুঁজলে `O(n)` লাগত।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(n)',0),(@q,'B','O(1) গড়ে',1),(@q,'C','O(n^2)',0),(@q,'D','O(log n)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'দুটো key একই index-এ হ্যাশ হলে তাকে কী বলে?', 'What is it called when two keys hash to the same index?', "hash('Rafi') -> 7
hash('Nadia') -> 7  // ???",
'দুটো ভিন্ন key একই index-এ হ্যাশ হয়ে যাওয়াকে **কলিশন** বলে — এটা হ্যাশ টেবিলের একটা স্বাভাবিক ঘটনা, যা চেইনিং-এর মতো টেকনিক দিয়ে সামলানো হয়।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কলিশন',1),(@q,'B','ওভারফ্লো',0),(@q,'C','ডুপ্লিকেশন',0),(@q,'D','এটা কখনো ঘটে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'নিচের কোডে কোন সংখ্যাটা "Duplicate found" হিসেবে প্রিন্ট হবে?', 'Which number prints as a duplicate?', 'seen = {}
for num in [1, 2, 3, 2, 4]:
    if num in seen:
        print("Duplicate found:", num)
    seen[num] = true',
'`1, 2, 3` প্রথমবার দেখা যায় (এখনো `seen`-এ নেই)। যখন দ্বিতীয় `2` আসে, সেটা আগে থেকেই `seen`-এ আছে (`in seen` সত্যি), তাই "Duplicate found: 2" প্রিন্ট হয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','1',0),(@q,'B','2',1),(@q,'C','3',0),(@q,'D','4',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'countWords(["a", "b", "a"]) এর ফলাফল কী হবে?', 'What does countWords(["a", "b", "a"]) return?', 'function countWords(words):
    freq = {}
    for word in words:
        if word in freq: freq[word] += 1
        else: freq[word] = 1
    return freq',
'"a" দুইবার এসেছে, "b" একবার — লুপটা প্রতিটা শব্দের কাউন্ট বাড়ায় বা নতুন এন্ট্রি যোগ করে। ফলাফল: `{"a": 2, "b": 1}`।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','{"a": 1, "b": 1}',0),(@q,'B','{"a": 2, "b": 1}',1),(@q,'C','{"a": 3}',0),(@q,'D','[a, b, a]',0);
