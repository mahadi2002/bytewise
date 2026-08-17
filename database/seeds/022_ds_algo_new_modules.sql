-- Data Structures: Heaps & Priority Queues (new module 7).
-- Algorithms: Greedy Algorithms (new module 7).
-- Pseudocode throughout, matching the rest of these two tracks.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang_ds   FROM languages WHERE slug = 'data-structures';
SELECT id INTO @lang_algo FROM languages WHERE slug = 'algorithms';
SELECT id INTO @m_heap    FROM modules WHERE language_id=@lang_ds AND slug='heaps';
SELECT id INTO @m_greedy  FROM modules WHERE language_id=@lang_algo AND slug='greedy';

-- ── Heaps & Priority Queues ──────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_heap, 'heap-basics', 'হিপ: বিশেষ ধরনের ট্রি', 'Heaps: A Special Kind of Tree',
'একটা **হিপ** হলো এমন একটা বাইনারি ট্রি, যেখানে প্রতিটা প্যারেন্ট নোড তার চাইল্ডদের চেয়ে ছোট (**min-heap**) বা বড় (**max-heap**) থাকে। BST-এর মতো পুরোপুরি সর্টেড নয়, শুধু এই একটা নিয়ম মানা হয় — যার সুবিধা হলো, সবচেয়ে ছোট (বা বড়) ভ্যালুটা সবসময় root-এ থাকে, `O(1)`-এ পাওয়া যায়।',
'          1              <- min-heap: root is always the smallest
        /   \
       3     5
      / \   /
     7   9 6',
NULL, 10, 0, 1, 0),

(@m_heap, 'priority-queue-basics', 'প্রায়োরিটি কিউ', 'Priority Queues',
'সাধারণ কিউ FIFO মেনে চলে, কিন্তু **প্রায়োরিটি কিউ**-এ প্রতিটা এলিমেন্টের একটা "প্রায়োরিটি" থাকে — সবচেয়ে বেশি (বা কম) প্রায়োরিটির এলিমেন্টটাই আগে বের হয়, সেটা কখন যোগ হয়েছিল তা বিবেচ্য নয়। হিপ দিয়েই প্রায়োরিটি কিউ বাস্তবায়ন করা হয়, কারণ hasChild-চেক দ্রুত root-এ সবচেয়ে গুরুত্বপূর্ণ এলিমেন্ট রাখে।',
'// priority queue (min-priority): lower number = more urgent
pq.insert(task="Fix bug", priority=1)
pq.insert(task="Write docs", priority=3)
pq.insert(task="Server down!", priority=0)

pq.extractMin() // "Server down!" comes out first — priority 0, most urgent',
NULL, 10, 0, 2, 0),

(@m_heap, 'heap-operations', 'হিপ অপারেশন: insert ও extract', 'Heap Operations: Insert & Extract',
'হিপে নতুন এলিমেন্ট **insert** করলে সেটা শেষে বসিয়ে "উপরের দিকে বাবল" করানো হয় (প্যারেন্টের চেয়ে ছোট হওয়া পর্যন্ত সোয়াপ করতে থাকে)। root **extract** করলে শেষ এলিমেন্টটা root-এ বসিয়ে "নিচের দিকে বাবল" করানো হয়। দুটো অপারেশনই `O(log n)`, কারণ হিপের উচ্চতা `log n`।',
'// insert: place at the end, then "bubble up"
// extract-min: remove root, move last element to root, "bubble down"
// both operations are O(log n) — the height of a heap with n elements',
NULL, 10, 0, 3, 0),

(@m_heap, 'heap-capstone', 'ক্যাপস্টোন: k-টা সবচেয়ে ছোট ভ্যালু বের করা', 'Capstone: Finding the K Smallest Values',
'একটা মিন-হিপ ব্যবহার করে একটা অ্যারে থেকে সবচেয়ে ছোট `k`-টা ভ্যালু বের করা হচ্ছে — পুরো অ্যারে সর্ট করার (`O(n log n)`) চেয়ে দ্রুত একটা প্যাটার্ন।',
'function kSmallest(arr, k):
    heap = buildMinHeap(arr)
    result = []
    for i from 1 to k:
        result.append(heap.extractMin())
    return result

// kSmallest([9, 3, 7, 1, 8, 2], 3) -> [1, 2, 3]',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_heap AND slug='heap-basics';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_heap AND slug='priority-queue-basics';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_heap AND slug='heap-operations';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_heap AND slug='heap-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'একটা min-heap-এর root-এ কী থাকে?', 'What is at the root of a min-heap?', '          1
        /   \
       3     5',
'min-heap-এর নিয়মই হলো প্রতিটা প্যারেন্ট তার চাইল্ডদের চেয়ে ছোট — এই নিয়ম পুরো ট্রি জুড়ে প্রযোজ্য হওয়ায়, সবচেয়ে ছোট ভ্যালুটা সবসময় root-এ থাকে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সবচেয়ে বড় ভ্যালু',0),(@q,'B','সবচেয়ে ছোট ভ্যালু',1),(@q,'C','মাঝামাঝি ভ্যালু',0),(@q,'D','এলোমেলো যেকোনো ভ্যালু',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'pq.extractMin() প্রথমে কোন টাস্কটা বের করবে?', 'Which task does extractMin() return first?', 'pq.insert("Fix bug", priority=1)
pq.insert("Write docs", priority=3)
pq.insert("Server down!", priority=0)',
'প্রায়োরিটি কিউ কখন যোগ হয়েছে তা দেখে না, শুধু প্রায়োরিটি দেখে — এখানে সবচেয়ে কম প্রায়োরিটি সংখ্যা (`0`, সবচেয়ে জরুরি) হলো "Server down!", তাই সেটাই প্রথমে বের হবে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Fix bug (প্রথমে যোগ হয়েছিল)',0),(@q,'B','Server down! (সবচেয়ে বেশি জরুরি)',1),(@q,'C','Write docs (শেষে যোগ হয়েছিল)',0),(@q,'D','সবগুলো একসাথে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'হিপে insert বা extract-এর টাইম কমপ্লেক্সিটি কত?', 'What is the time complexity of insert/extract?', '// both operations are O(log n)',
'হিপ সবসময় একটা "ব্যালান্সড" বাইনারি ট্রি আকারে থাকে, যার উচ্চতা `n`টা এলিমেন্টে `log n`-এর সমানুপাতিক। "বাবল আপ/ডাউন" প্রতি ধাপে একটা লেভেল উপরে/নিচে যায়, তাই সর্বোচ্চ `log n` ধাপ লাগে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(1)',0),(@q,'B','O(log n)',1),(@q,'C','O(n)',0),(@q,'D','O(n^2)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'kSmallest([9, 3, 7, 1, 8, 2], 3) এর ফলাফল কী হবে?', 'What does kSmallest([9,3,7,1,8,2], 3) return?', 'function kSmallest(arr, k):
    heap = buildMinHeap(arr)
    // extracts k times from the min-heap',
'অ্যারেটা সাজালে হয় [1, 2, 3, 7, 8, 9] — সবচেয়ে ছোট ৩টা ভ্যালু হলো 1, 2, 3। মিন-হিপ থেকে ৩ বার `extractMin()` করলে এই তিনটাই ছোট থেকে বড় ক্রমে বের হবে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','[9, 8, 7]',0),(@q,'B','[1, 2, 3]',1),(@q,'C','[9, 3, 7]',0),(@q,'D','[1, 8, 2]',0);

-- ── Greedy Algorithms ────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_greedy, 'greedy-intro', 'গ্রিডি অ্যালগরিদম: প্রতি ধাপে সেরা পছন্দ', 'Greedy Algorithms: Best Choice at Each Step',
'একটা **গ্রিডি** অ্যালগরিদম প্রতিটা ধাপে সেই মুহূর্তে সবচেয়ে ভালো মনে হওয়া সিদ্ধান্তটা নেয়, পরে সেটা বদলানোর কথা চিন্তা না করেই। ডিভাইড-অ্যান্ড-কনকার বা DP-এর চেয়ে সহজ ও দ্রুত, কিন্তু সবসময় সেরা (optimal) ফলাফল দেয় না — শুধু নির্দিষ্ট কিছু সমস্যায় কাজ করে।',
'// Example problem: minimum number of coins to make change
// Greedy: always pick the largest coin that fits
// coins = [1, 5, 10, 25], target = 30
// pick 25 -> remaining 5 -> pick 5 -> remaining 0. Done: 2 coins.',
NULL, 10, 0, 1, 0),

(@m_greedy, 'coin-change-greedy', 'উদাহরণ: কয়েন চেঞ্জ', 'Example: Coin Change',
'সবচেয়ে ছোট সংখ্যক কয়েন দিয়ে একটা টাকার অঙ্ক বানানো — প্রতিবার সবচেয়ে বড় কয়েনটা বেছে নেওয়া হয়, যতক্ষণ সেটা বাকি টাকার চেয়ে বড় না হয়ে যায়।',
'function greedyCoinChange(coins, amount):
    // coins sorted largest to smallest
    count = 0
    for coin in coins:
        while amount >= coin:
            amount -= coin
            count += 1
    return count

// greedyCoinChange([25, 10, 5, 1], 30) -> 2 (one 25 + one 5)',
NULL, 10, 0, 2, 0),

(@m_greedy, 'when-greedy-fails', 'গ্রিডি কখন ব্যর্থ হয়', 'When Greedy Fails',
'গ্রিডি সবসময় সেরা উত্তর দেয় না। যেমন কয়েন সেট `[1, 3, 4]` দিয়ে `6` বানাতে গ্রিডি প্রথমে `4` বেছে নেবে (বাকি `2`), তারপর দুটো `1` (মোট ৩টা কয়েন: 4+1+1) — কিন্তু সেরা উত্তর হলো `3+3` (মাত্র ২টা কয়েন)। তাই কোনো সমস্যায় গ্রিডি প্রয়োগ করার আগে প্রমাণ করা দরকার যে এটা সত্যিই সবসময় সেরা উত্তর দেয়।',
'// coins = [1, 3, 4], amount = 6
// Greedy: pick 4, then 1, then 1 -> 3 coins (4+1+1)
// Optimal: 3 + 3 -> 2 coins
// Greedy is NOT always correct — it depends on the specific problem''s structure.',
NULL, 10, 0, 3, 0),

(@m_greedy, 'greedy-capstone', 'ক্যাপস্টোন: অ্যাক্টিভিটি সিলেকশন', 'Capstone: Activity Selection',
'একটা ক্লাসিক গ্রিডি প্রবলেম — কয়েকটা কাজের (activity) শুরু ও শেষ সময় দেওয়া থাকলে, একটা রুমে সর্বোচ্চ কয়টা কাজ (যাদের সময় ওভারল্যাপ করে না) করা যায়, তা বের করা। গ্রিডি স্ট্র্যাটেজি: সবসময় সবচেয়ে আগে শেষ হওয়া কাজটা বেছে নাও।',
'function maxActivities(activities): // each is (start, end)
    sort activities by end time
    count = 1
    lastEnd = activities[0].end
    for activity in activities[1:]:
        if activity.start >= lastEnd:
            count += 1
            lastEnd = activity.end
    return count

// activities sorted by end time, picking each non-overlapping one greedily',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_greedy AND slug='greedy-intro';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_greedy AND slug='coin-change-greedy';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_greedy AND slug='when-greedy-fails';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_greedy AND slug='greedy-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'গ্রিডি অ্যালগরিদম প্রতিটা ধাপে কী করে?', 'What does a greedy algorithm do at each step?', '// picks the locally best option at each step, never reconsiders',
'গ্রিডি অ্যালগরিদম প্রতিটা ধাপে সেই মুহূর্তে সবচেয়ে ভালো (লোকাল অপ্টিমাল) সিদ্ধান্তটা নেয়, এবং পরে সেই সিদ্ধান্ত আর পুনর্বিবেচনা করে না — এই কারণেই এটা দ্রুত কিন্তু সবসময় গ্লোবাল অপ্টিমাল উত্তর দেয় না।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সব সম্ভাব্য উপায় চেক করে',0),(@q,'B','প্রতি ধাপে সবচেয়ে ভালো মনে হওয়া সিদ্ধান্ত নেয়, আর ফিরে দেখে না',1),(@q,'C','এলোমেলোভাবে সিদ্ধান্ত নেয়',0),(@q,'D','সবসময় সবচেয়ে ছোট সংখ্যা বেছে নেয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'greedyCoinChange([25, 10, 5, 1], 30) কত রিটার্ন করবে?', 'What does greedyCoinChange([25,10,5,1], 30) return?', 'function greedyCoinChange(coins, amount):
    // picks the largest coin that fits, repeatedly',
'প্রথমে `25` বেছে নেওয়া হয় (বাকি থাকে `5`), তারপর `5` বেছে নেওয়া হয় (বাকি থাকে `0`) — মোট ২টা কয়েন লাগে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','3',0),(@q,'B','2',1),(@q,'C','30',0),(@q,'D','1',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'coins=[1,3,4], amount=6 এ গ্রিডি কেন সেরা উত্তর দেয় না?', 'Why does greedy fail for coins=[1,3,4], amount=6?', '// Greedy: 4+1+1 = 3 coins
// Optimal: 3+3 = 2 coins',
'গ্রিডি প্রথমে সবচেয়ে বড় কয়েন (`4`) বেছে নেয়, যা এই নির্দিষ্ট কয়েন সেটে ভুল পথে নিয়ে যায় — `4+1+1` (৩টা কয়েন) লাগে, যেখানে `3+3` (২টা কয়েন) আসলে সেরা। এই কয়েন সেটে গ্রিডি স্ট্র্যাটেজি সবসময় অপ্টিমাল নয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কারণ গ্রিডি সবসময় ভুল করে',0),(@q,'B','কারণ সবচেয়ে বড় কয়েন বেছে নেওয়া এই নির্দিষ্ট সেটে অপ্টিমাল পথে নেয় না',1),(@q,'C','কারণ 6 একটা বিজোড় সংখ্যা',0),(@q,'D','আসলে গ্রিডিই সঠিক, 3+3 ভুল',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'অ্যাক্টিভিটি সিলেকশনে গ্রিডি স্ট্র্যাটেজি কী?', 'What is the greedy strategy for activity selection?', 'function maxActivities(activities):
    sort activities by end time
    // then greedily pick non-overlapping ones',
'গ্রিডি স্ট্র্যাটেজি হলো: কাজগুলোকে শেষ হওয়ার সময় অনুযায়ী সাজিয়ে, সবসময় সবচেয়ে আগে শেষ হওয়া (এখনো নির্বাচিত কাজের সাথে ওভারল্যাপ না করা) কাজটা বেছে নেওয়া — এতে পরের কাজের জন্য সবচেয়ে বেশি সময় বাকি থাকে।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সবচেয়ে দীর্ঘ কাজটা আগে বেছে নেওয়া',0),(@q,'B','সবচেয়ে আগে শেষ হওয়া কাজটা বেছে নেওয়া',1),(@q,'C','এলোমেলোভাবে কাজ বেছে নেওয়া',0),(@q,'D','সবচেয়ে দেরিতে শুরু হওয়া কাজটা বেছে নেওয়া',0);
