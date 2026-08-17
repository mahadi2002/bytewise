-- Algorithms track: finish Big-O (3 more) + all 5 remaining modules.
-- Pseudocode throughout (code_sample_language = NULL), matching lesson 1.
-- Run with: mysql --default-character-set=utf8mb4 ...

SELECT id INTO @lang FROM languages WHERE slug = 'algorithms';
SELECT id INTO @m_bigo FROM modules WHERE language_id=@lang AND slug='big-o';
SELECT id INTO @m_sea  FROM modules WHERE language_id=@lang AND slug='searching';
SELECT id INTO @m_sort FROM modules WHERE language_id=@lang AND slug='sorting';
SELECT id INTO @m_rec  FROM modules WHERE language_id=@lang AND slug='recursion';
SELECT id INTO @m_dc   FROM modules WHERE language_id=@lang AND slug='divide-conquer';
SELECT id INTO @m_dp   FROM modules WHERE language_id=@lang AND slug='dp-basics';

-- ── Time Complexity & Big-O (lessons 2-4) ────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_bigo, 'common-complexities', 'কমন Big-O কমপ্লেক্সিটি', 'Common Big-O Complexities',
'ছোট থেকে বড়: `O(1)` (কনস্ট্যান্ট, ইনপুট সাইজ যাই হোক একই সময়), `O(log n)` (বাইনারি সার্চের মতো, প্রতি ধাপে অর্ধেক বাদ), `O(n)` (লিনিয়ার, প্রতিটা এলিমেন্ট একবার), `O(n log n)` (ভালো সর্টিং অ্যালগরিদম), `O(n^2)` (নেস্টেড লুপ, প্রতিটা এলিমেন্টের সাথে প্রতিটা এলিমেন্ট)।',
'// O(1):      arr[0]
// O(log n):   binary search
// O(n):       for x in arr: print(x)
// O(n^2):     for x in arr: for y in arr: print(x, y)',
NULL, 10, 0, 2, 0),

(@m_bigo, 'best-worst-average-case', 'বেস্ট, ওয়ার্স্ট ও এভারেজ কেস', 'Best, Worst & Average Case',
'একই অ্যালগরিদমের ইনপুট অনুযায়ী পারফরম্যান্স বদলাতে পারে। **ওয়ার্স্ট কেস** হলো সবচেয়ে খারাপ পরিস্থিতিতে কত সময় লাগবে (যেমন লিনিয়ার সার্চে টার্গেট একদম শেষে বা নেই)। Big-O সাধারণত ওয়ার্স্ট কেস বোঝাতেই ব্যবহার হয়, কারণ এটাই একটা গ্যারান্টি দেয়।',
'// Linear search for target in arr:
// Best case:    target is arr[0]        -> O(1)
// Worst case:   target is last, or missing -> O(n)
// Big-O notation almost always refers to the worst case.',
NULL, 10, 0, 3, 0),

(@m_bigo, 'big-o-capstone', 'ক্যাপস্টোন: কোডের কমপ্লেক্সিটি বিশ্লেষণ', 'Capstone: Analyzing Code Complexity',
'একটা কোড স্নিপেট দেখে তার Big-O কমপ্লেক্সিটি বের করার অনুশীলন — নেস্টেড লুপ চিনতে পারা এই স্কিলের ভিত্তি।',
'function hasDuplicate(arr):
    for i from 0 to length(arr) - 1:        // outer loop: n times
        for j from i+1 to length(arr) - 1:  // inner loop: up to n times
            if arr[i] == arr[j]:
                return true
    return false
// Nested loops over the same input -> O(n^2)',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_bigo AND slug='common-complexities';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_bigo AND slug='best-worst-average-case';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_bigo AND slug='big-o-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'এই কোডটার কমপ্লেক্সিটি কত?', 'What is the complexity of this code?', 'for x in arr:
    for y in arr:
        print(x, y)',
'দুটো নেস্টেড লুপ, দুটোই পুরো `arr` ঘোরে — বাইরের প্রতিটা এলিমেন্টের জন্য ভেতরেরটা পুরো একবার চলে, তাই মোট `n * n = n^2` অপারেশন, অর্থাৎ `O(n^2)`।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(n)',0),(@q,'B','O(n^2)',1),(@q,'C','O(log n)',0),(@q,'D','O(1)',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'Big-O নোটেশন সাধারণত কোন কেস বোঝায়?', 'Which case does Big-O usually refer to?', '// Big-O notation almost always refers to the worst case.',
'Big-O প্রায় সবসময় **ওয়ার্স্ট কেস** বোঝায় — কারণ এটাই একটা গ্যারান্টি দেয় যে অ্যালগরিদম কখনোই তার চেয়ে খারাপ পারফর্ম করবে না, যাই ইনপুট হোক না কেন।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','বেস্ট কেস',0),(@q,'B','ওয়ার্স্ট কেস',1),(@q,'C','এভারেজ কেস',0),(@q,'D','এটা কোনো নির্দিষ্ট কেস বোঝায় না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'hasDuplicate() ফাংশনটার কমপ্লেক্সিটি কত?', 'What is hasDuplicate()''s complexity?', 'function hasDuplicate(arr):
    for i ...:        // n times
        for j ...:     // up to n times
            if arr[i] == arr[j]: return true',
'দুটো নেস্টেড লুপ একই ইনপুট (`arr`) নিয়ে ঘোরে — ওয়ার্স্ট কেসে (কোনো ডুপ্লিকেট না থাকলে) প্রায় `n * n` বার তুলনা হয়, তাই এটা `O(n^2)`।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','O(n)',0),(@q,'B','O(n^2)',1),(@q,'C','O(1)',0),(@q,'D','O(n log n)',0);

-- ── Searching ────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_sea, 'linear-search-detail', 'লিনিয়ার সার্চ বিস্তারিত', 'Linear Search in Detail',
'**লিনিয়ার সার্চ** সবচেয়ে সহজ উপায় — শুরু থেকে একটা একটা করে প্রতিটা এলিমেন্ট চেক করা, টার্গেট পাওয়া না যাওয়া পর্যন্ত। কোনো প্রি-কন্ডিশন লাগে না (অ্যারে সর্টেড না হলেও চলে), কিন্তু ওয়ার্স্ট কেসে `O(n)`।',
'function linearSearch(arr, target):
    for i from 0 to length(arr) - 1:
        if arr[i] == target:
            return i
    return -1  // not found',
NULL, 10, 0, 1, 0),

(@m_sea, 'binary-search', 'বাইনারি সার্চ', 'Binary Search',
'**বাইনারি সার্চ** অনেক দ্রুত (`O(log n)`), কিন্তু একটা শর্ত আছে: অ্যারেটা অবশ্যই **সর্টেড** থাকতে হবে। প্রতি ধাপে মাঝখানের এলিমেন্টের সাথে তুলনা করে অর্ধেক অংশ বাদ দেওয়া হয় — এই কারণেই `n` উপাদানে মাত্র `log n` ধাপে খুঁজে পাওয়া যায়।',
'// Array MUST be sorted for binary search to work correctly.
sorted = [1, 3, 5, 7, 9, 11, 13]
// searching for 9: check middle (7) -> 9>7, search right half only
// [9, 11, 13] -> check middle (11) -> 9<11, search left half only
// [9] -> found!  Only 3 comparisons for 7 elements.',
NULL, 10, 0, 2, 0),

(@m_sea, 'binary-search-implementation', 'বাইনারি সার্চ ইমপ্লিমেন্টেশন', 'Binary Search Implementation',
'বাইনারি সার্চ ইমপ্লিমেন্ট করতে দুটো পয়েন্টার লাগে — `low` আর `high`, যা সার্চ-রেঞ্জের সীমা বোঝায়। প্রতি ধাপে মাঝখানের ইনডেক্স বের করে টার্গেটের সাথে তুলনা করে রেঞ্জটা অর্ধেক করে ফেলা হয়।',
'function binarySearch(arr, target):
    low = 0
    high = length(arr) - 1
    while low <= high:
        mid = (low + high) / 2
        if arr[mid] == target:
            return mid
        else if arr[mid] < target:
            low = mid + 1   // search right half
        else:
            high = mid - 1  // search left half
    return -1',
NULL, 10, 0, 3, 0),

(@m_sea, 'searching-capstone', 'ক্যাপস্টোন: লিনিয়ার বনাম বাইনারি — তুলনা', 'Capstone: Linear vs Binary — a Comparison',
'১০০০টা সর্টেড এলিমেন্টে টার্গেট খুঁজতে লিনিয়ার সার্চ ওয়ার্স্ট কেসে ১০০০ বার তুলনা করতে পারে, কিন্তু বাইনারি সার্চ মাত্র প্রায় ১০ বারেই (`log2(1000) ≈ 10`) খুঁজে পায় — এটাই `O(n)` বনাম `O(log n)`-এর বাস্তব পার্থক্য।',
'// 1000 sorted elements:
// linear search worst case:  up to 1000 comparisons
// binary search worst case:  up to ~10 comparisons (log2(1000) ≈ 10)

// The tradeoff: binary search requires the array to be sorted first.',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_sea AND slug='linear-search-detail';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_sea AND slug='binary-search';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_sea AND slug='binary-search-implementation';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_sea AND slug='searching-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'টার্গেট অ্যারেতে না থাকলে linearSearch() কী রিটার্ন করে?', 'What does linearSearch() return if target is missing?', 'function linearSearch(arr, target):
    for i ...: if arr[i] == target: return i
    return -1',
'পুরো লুপ শেষ হয়ে গেলেও টার্গেট না পাওয়া গেলে (কোনো `return i` না চলায়), ফাংশনটা `-1` রিটার্ন করে — এটাই "পাওয়া যায়নি" বোঝানোর কনভেনশন।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',0),(@q,'B','-1',1),(@q,'C','null',0),(@q,'D','একটা এরর',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'বাইনারি সার্চ কাজ করার জন্য অ্যারের কী শর্ত থাকতে হবে?', 'What condition must the array meet for binary search?', '// Array MUST be sorted for binary search to work correctly.',
'বাইনারি সার্চ প্রতি ধাপে অর্ধেক অংশ বাদ দেয় এই অনুমানে যে মাঝখানের চেয়ে ছোট/বড় সবকিছু একদিকে গোছানো আছে — অ্যারে সর্টেড না থাকলে এই অনুমান ভুল হয়ে যায় এবং ভুল ফলাফল আসতে পারে।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','অ্যারেটা অবশ্যই সর্টেড থাকতে হবে',1),(@q,'B','অ্যারেতে ডুপ্লিকেট থাকা যাবে না',0),(@q,'C','অ্যারের সাইজ জোড় সংখ্যা হতে হবে',0),(@q,'D','কোনো শর্ত নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'arr[mid] < target হলে পরের ধাপে কী হবে?', 'What happens next if arr[mid] < target?', 'else if arr[mid] < target:
    low = mid + 1   // search right half',
'অ্যারে সর্টেড থাকায়, `arr[mid]` টার্গেটের চেয়ে ছোট হওয়া মানে টার্গেট (যদি থাকে) অবশ্যই `mid`-এর ডানদিকে আছে — তাই `low`-কে `mid + 1`-এ নিয়ে গিয়ে বামের অর্ধেক বাদ দেওয়া হয়, শুধু ডান অর্ধেকে সার্চ চালিয়ে যাওয়া হয়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','high = mid - 1, বাম দিকে সার্চ',0),(@q,'B','low = mid + 1, ডান দিকে সার্চ',1),(@q,'C','সার্চ থেমে যায়',0),(@q,'D','পুরো অ্যারে আবার সার্চ হয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, '১০০০টা সর্টেড এলিমেন্টে বাইনারি সার্চের ওয়ার্স্ট কেসে প্রায় কতবার তুলনা লাগবে?', 'About how many comparisons for binary search on 1000 elements?', '// binary search worst case: up to ~10 comparisons (log2(1000) ≈ 10)',
'বাইনারি সার্চ প্রতি ধাপে অর্ধেক বাদ দেয়, তাই মোট ধাপের সংখ্যা `log2(n)`-এর কাছাকাছি — `log2(1000) ≈ 10`, তাই মাত্র প্রায় ১০ বার তুলনাতেই খুঁজে পাওয়া বা "নেই" নিশ্চিত হওয়া যায়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','প্রায় ১০০০',0),(@q,'B','প্রায় ১০',1),(@q,'C','ঠিক ১',0),(@q,'D','প্রায় ৫০০',0);

-- ── Sorting ──────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_sort, 'bubble-sort', 'বাবল সর্ট', 'Bubble Sort',
'**বাবল সর্ট** পাশাপাশি দুটো এলিমেন্ট তুলনা করে, ভুল ক্রমে থাকলে অদল-বদল করে — বড় ভ্যালুগুলো ধীরে ধীরে "বুদবুদের মতো" শেষের দিকে উঠে যায়। বোঝা সহজ কিন্তু ধীর — `O(n^2)`।',
'function bubbleSort(arr):
    for i from 0 to length(arr) - 1:
        for j from 0 to length(arr) - 2 - i:
            if arr[j] > arr[j+1]:
                swap(arr[j], arr[j+1])
    return arr',
NULL, 10, 0, 1, 0),

(@m_sort, 'selection-sort', 'সিলেকশন সর্ট', 'Selection Sort',
'**সিলেকশন সর্ট** প্রতি ধাপে বাকি (এখনো সর্ট না হওয়া) অংশ থেকে সবচেয়ে ছোট ভ্যালুটা খুঁজে বের করে সামনে নিয়ে আসে। বাবল সর্টের মতোই `O(n^2)`, কিন্তু সাধারণত কম সোয়াপ লাগে।',
'function selectionSort(arr):
    for i from 0 to length(arr) - 1:
        minIndex = i
        for j from i+1 to length(arr) - 1:
            if arr[j] < arr[minIndex]:
                minIndex = j
        swap(arr[i], arr[minIndex])
    return arr',
NULL, 10, 0, 2, 0),

(@m_sort, 'insertion-sort', 'ইনসারশন সর্ট', 'Insertion Sort',
'**ইনসারশন সর্ট** তাসের পাতা হাতে সাজানোর মতো — একটা একটা করে এলিমেন্ট নিয়ে, এখন পর্যন্ত সর্ট করা অংশে তার সঠিক জায়গায় বসিয়ে দেয়। ছোট বা প্রায়-সর্টেড অ্যারেতে এটা ব্যবহারিকভাবে বেশ দ্রুত, যদিও ওয়ার্স্ট কেসে এখনও `O(n^2)`।',
'function insertionSort(arr):
    for i from 1 to length(arr) - 1:
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j+1] = arr[j]
            j = j - 1
        arr[j+1] = key
    return arr',
NULL, 10, 0, 3, 0),

(@m_sort, 'sorting-capstone', 'ক্যাপস্টোন: কেন O(n log n) সর্ট এত গুরুত্বপূর্ণ', 'Capstone: Why O(n log n) Sorts Matter',
'বাবল, সিলেকশন, ইনসারশন — তিনটাই `O(n^2)`, যা বড় ডেটাসেটে অনেক ধীর হয়ে যায়। পরের মডিউলে দেখা মার্জ সর্ট আর কুইক সর্টের মতো `O(n log n)` অ্যালগরিদম ১০ লক্ষ এলিমেন্টেও ব্যবহারযোগ্য গতিতে চলে — এই পার্থক্যটাই বড় স্কেলে সবচেয়ে গুরুত্বপূর্ণ।',
'// For n = 1,000,000 elements (rough comparison count):
// O(n^2):       ~1,000,000,000,000 operations  -- far too slow
// O(n log n):   ~20,000,000 operations          -- practical',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_sort AND slug='bubble-sort';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_sort AND slug='selection-sort';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_sort AND slug='insertion-sort';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_sort AND slug='sorting-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'বাবল সর্টে বড় ভ্যালুগুলো কোন দিকে সরে যায়?', 'In bubble sort, which way do large values move?', 'if arr[j] > arr[j+1]:
    swap(arr[j], arr[j+1])',
'পাশাপাশি দুটো এলিমেন্টের মধ্যে বড়টা পেছনে গেলে, প্রতিটা পাসে সবচেয়ে বড় ভ্যালুটা ধীরে ধীরে ডানদিকে (শেষের দিকে) "ভেসে" যায় — এই কারণেই এর নাম বাবল (বুদবুদ) সর্ট।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','শুরুর দিকে',0),(@q,'B','শেষের দিকে',1),(@q,'C','মাঝখানে',0),(@q,'D','কোথাও সরে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'সিলেকশন সর্টের প্রতিটা ধাপে কী খোঁজা হয়?', 'What does each pass of selection sort look for?', 'for j from i+1 to length(arr)-1:
    if arr[j] < arr[minIndex]: minIndex = j',
'প্রতিটা ধাপে বাকি (এখনো সর্ট না হওয়া) অংশের মধ্যে সবচেয়ে ছোট ভ্যালুটা খোঁজা হয়, তারপর সেটাকে সামনের দিকে সোয়াপ করে আনা হয় — নাম থেকেই বোঝা যায়, প্রতি ধাপে একটা "সিলেকশন" (বাছাই)।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সবচেয়ে বড় ভ্যালু',0),(@q,'B','সবচেয়ে ছোট ভ্যালু',1),(@q,'C','মাঝের ভ্যালু',0),(@q,'D','ডুপ্লিকেট ভ্যালু',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'ইনসারশন সর্ট কোন ধরনের অ্যারেতে ব্যবহারিকভাবে দ্রুত?', 'Insertion sort is practically fast on which kind of array?', '// insertion sort: fast on small or nearly-sorted arrays',
'যদি অ্যারে প্রায় আগে থেকেই সর্টেড থাকে, প্রতিটা এলিমেন্টকে তার সঠিক জায়গায় বসাতে খুব বেশি সরাতে হয় না — তাই ইনসারশন সর্ট এই ধরনের ইনপুটে ব্যবহারিকভাবে অনেক দ্রুত, যদিও ওয়ার্স্ট-কেস `O(n^2)` অপরিবর্তিত থাকে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','সম্পূর্ণ এলোমেলো, বড় অ্যারে',0),(@q,'B','ছোট বা প্রায়-সর্টেড অ্যারে',1),(@q,'C','শুধু নেগেটিভ সংখ্যার অ্যারে',0),(@q,'D','কোনো পার্থক্য হয় না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, '১০ লক্ষ এলিমেন্টে O(n^2) সর্ট কেন ব্যবহারযোগ্য নয়?', 'Why is an O(n^2) sort impractical for 1 million elements?', '// O(n^2) for n=1,000,000: ~1,000,000,000,000 operations',
'`O(n^2)`-এ `n = 10^6` হলে প্রায় `10^12` (১ ট্রিলিয়ন) অপারেশন লাগে — এটা বাস্তবে চালাতে গেলে অনেক সময় নেবে। `O(n log n)` সর্টে একই ইনপুটে মাত্র প্রায় `2×10^7` অপারেশন লাগে, যা ব্যবহারযোগ্য।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','কারণ এটা ভুল ফলাফল দেয়',0),(@q,'B','কারণ অপারেশনের সংখ্যা এত বেশি হয়ে যায় যে বাস্তবে অনেক সময় লাগে',1),(@q,'C','এটা আসলে সমস্যা না, একই গতি',0),(@q,'D','কারণ এটা মেমোরিতে ফিট হয় না',0);

-- ── Recursion ────────────────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_rec, 'recursion-basics-algo', 'রিকার্শন: base case ও recursive case', 'Recursion: Base Case & Recursive Case',
'একটা রিকার্সিভ ফাংশনের দুটো অংশ থাকে: **base case** (যেখানে সরাসরি উত্তর দিয়ে থেমে যায়) আর **recursive case** (যেখানে ছোট একটা ভার্সনের সমস্যায় নিজেকেই কল করে)। base case ছাড়া ফাংশন অসীমবার কল হতে থাকবে।',
'function countdown(n):
    if n <= 0:               // base case
        print("Done!")
        return
    print(n)
    countdown(n - 1)          // recursive case: smaller problem',
NULL, 10, 0, 1, 0),

(@m_rec, 'recursion-examples-algo', 'উদাহরণ: factorial ও fibonacci', 'Examples: Factorial & Fibonacci',
'`factorial(n) = n * factorial(n-1)`, আর `fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)` — দুটোই ক্লাসিক রিকার্সিভ সংজ্ঞা, যেখানে সমস্যাটা নিজের ছোট ভার্সনের মাধ্যমে সংজ্ঞায়িত।',
'function fibonacci(n):
    if n <= 1:
        return n              // base case: fib(0)=0, fib(1)=1
    return fibonacci(n-1) + fibonacci(n-2)

// fibonacci(5) -> 5  (sequence: 0,1,1,2,3,5)',
NULL, 10, 0, 2, 0),

(@m_rec, 'recursion-vs-iteration', 'রিকার্শন বনাম ইটারেশন', 'Recursion vs Iteration',
'যেকোনো রিকার্সিভ সমাধান লুপ দিয়েও লেখা যায় (এবং উল্টোটাও)। রিকার্শন প্রায়ই পড়তে বেশি স্বাভাবিক লাগে (ট্রি/গ্রাফের মতো সমস্যায়), কিন্তু প্রতিটা কল **কল স্ট্যাকে** জায়গা নেয় — অনেক বেশি (বা অসীম) রিকার্শন হলে **স্ট্যাক ওভারফ্লো** হতে পারে, যেখানে একটা লুপ তা করবে না।',
'// Same result, two approaches:

function factorialRecursive(n):
    if n <= 1: return 1
    return n * factorialRecursive(n - 1)

function factorialIterative(n):
    result = 1
    for i from 2 to n:
        result = result * i
    return result',
NULL, 10, 0, 3, 0),

(@m_rec, 'recursion-capstone', 'ক্যাপস্টোন: রিকার্সিভ সাম', 'Capstone: Recursive Sum',
'একটা অ্যারের সব এলিমেন্টের যোগফল রিকার্সিভভাবে বের করা হচ্ছে — base case (খালি অ্যারে) আর recursive case (প্রথম এলিমেন্ট + বাকি অংশের যোগফল)।',
'function sum(arr):
    if length(arr) == 0:
        return 0              // base case
    return arr[0] + sum(arr[1:])  // first element + sum of the rest

// sum([1, 2, 3, 4]) -> 1 + sum([2,3,4]) -> ... -> 10',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_rec AND slug='recursion-basics-algo';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_rec AND slug='recursion-examples-algo';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_rec AND slug='recursion-vs-iteration';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_rec AND slug='recursion-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'base case না থাকলে কী হবে?', 'What happens without a base case?', 'function countdown(n):
    print(n)
    countdown(n - 1)  // no base case!',
'base case ছাড়া ফাংশনটা কখনো থামার শর্ত পাবে না, তাই অসীমবার নিজেকে কল করতে থাকবে — শেষমেশ কল স্ট্যাক পূর্ণ হয়ে গিয়ে একটা স্ট্যাক ওভারফ্লো এরর হবে।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','ফাংশনটা একবার চলেই থেমে যাবে',0),(@q,'B','অসীমবার কল হয়ে স্ট্যাক ওভারফ্লো হবে',1),(@q,'C','কিছুই হবে না',0),(@q,'D','প্রোগ্রাম দ্রুত চলবে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'fibonacci(4) কত রিটার্ন করবে?', 'What does fibonacci(4) return?', 'function fibonacci(n):
    if n <= 1: return n
    return fibonacci(n-1) + fibonacci(n-2)',
'ফিবোনাচি সিকোয়েন্স: fib(0)=0, fib(1)=1, fib(2)=1, fib(3)=2, fib(4)=3 — প্রতিটা আগের দুটোর যোগফল (`fib(4) = fib(3) + fib(2) = 2 + 1 = 3`)।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','2',0),(@q,'B','3',1),(@q,'C','4',0),(@q,'D','5',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'অতিরিক্ত রিকার্শন কোন সমস্যার ঝুঁকি তৈরি করে, যা লুপ করে না?', 'What risk does deep recursion carry that a loop doesn''t?', '// each recursive call takes space on the call stack',
'প্রতিটা রিকার্সিভ কল কল স্ট্যাকে একটা নতুন এন্ট্রি যোগ করে — অনেক বেশি (বা অসীম) রিকার্শন হলে স্ট্যাক পূর্ণ হয়ে **স্ট্যাক ওভারফ্লো** এরর দিতে পারে। একটা লুপ নতুন স্ট্যাক ফ্রেম তৈরি করে না, তাই এই ঝুঁকি নেই।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','স্ট্যাক ওভারফ্লো',1),(@q,'B','ভুল ফলাফল',0),(@q,'C','সিনট্যাক্স এরর',0),(@q,'D','কোনো ঝুঁকি নেই',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'sum([]) (খালি অ্যারে) কী রিটার্ন করবে?', 'What does sum([]) return?', 'function sum(arr):
    if length(arr) == 0:
        return 0
    return arr[0] + sum(arr[1:])',
'খালি অ্যারের ক্ষেত্রে `length(arr) == 0` সত্যি, তাই base case-এ পৌঁছে সরাসরি `0` রিটার্ন হয় — এটাই এই রিকার্শনটাকে থামিয়ে দেয়।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','0',1),(@q,'B','Error',0),(@q,'C','null',0),(@q,'D','অসীম লুপ',0);

-- ── Divide and Conquer ───────────────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_dc, 'divide-conquer-intro', 'Divide and Conquer: ভাগ করে জয় করা', 'Divide and Conquer: The Core Idea',
'**Divide and Conquer** একটা প্যাটার্ন: সমস্যাটাকে ছোট ছোট (সাধারণত সমান) অংশে **ভাগ (divide)** করা, প্রতিটা অংশ রিকার্সিভভাবে **সমাধান (conquer)** করা, তারপর সেগুলোকে **একত্র (combine)** করে চূড়ান্ত উত্তর বানানো। বাইনারি সার্চ এর একটা সহজ উদাহরণ — যদিও সেখানে "কম্বাইন" ধাপ লাগে না, কারণ উত্তর একটা অর্ধেই থাকে।',
'// The three steps of divide and conquer:
// 1. Divide:  split the problem into smaller subproblems
// 2. Conquer: solve each subproblem recursively
// 3. Combine: merge the subproblem results into the final answer',
NULL, 10, 0, 1, 0),

(@m_dc, 'merge-sort', 'মার্জ সর্ট', 'Merge Sort',
'**মার্জ সর্ট** অ্যারেটাকে বারবার অর্ধেক করে ভাগ করতে থাকে, যতক্ষণ না প্রতিটা অংশে মাত্র ১টা এলিমেন্ট থাকে (যা এমনিতেই সর্টেড), তারপর জোড়ায় জোড়ায় **মার্জ** (সর্টেড অবস্থা বজায় রেখে একত্র) করে আবার পুরো অ্যারে বানায়। এটা `O(n log n)` — বাবল/সিলেকশন/ইনসারশন সর্টের চেয়ে অনেক দ্রুত।',
'function mergeSort(arr):
    if length(arr) <= 1:
        return arr                    // base case
    mid = length(arr) / 2
    left = mergeSort(arr[0:mid])      // divide + conquer (left half)
    right = mergeSort(arr[mid:])      // divide + conquer (right half)
    return merge(left, right)          // combine',
NULL, 10, 0, 2, 0),

(@m_dc, 'quick-sort', 'কুইক সর্ট', 'Quick Sort',
'**কুইক সর্ট** একটা **pivot** এলিমেন্ট বেছে নেয়, তারপর অ্যারেটাকে দুই ভাগে ভাগ করে — pivot-এর চেয়ে ছোট সব একদিকে, বড় সব আরেকদিকে (**partition**)। প্রতিটা ভাগ রিকার্সিভভাবে একইভাবে সর্ট হয়। গড়ে `O(n log n)`, কিন্তু খারাপ pivot বেছে নিলে ওয়ার্স্ট কেসে `O(n^2)` হতে পারে।',
'function quickSort(arr):
    if length(arr) <= 1:
        return arr
    pivot = arr[length(arr) / 2]
    left = [x for x in arr if x < pivot]
    equal = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quickSort(left) + equal + quickSort(right)',
NULL, 10, 0, 3, 0),

(@m_dc, 'divide-conquer-capstone', 'ক্যাপস্টোন: মার্জ সর্ট হাতে-কলমে', 'Capstone: Tracing Merge Sort by Hand',
'`[5, 2, 8, 1]` অ্যারেটা মার্জ সর্টে কীভাবে ভাগ আর মার্জ হয়, তা ধাপে ধাপে দেখা হচ্ছে — divide-conquer-combine প্যাটার্নটা বাস্তবে কেমন দেখতে লাগে।',
'// [5, 2, 8, 1]
// divide: [5, 2]        [8, 1]
// divide: [5] [2]       [8] [1]
// merge:  [2, 5]        [1, 8]
// merge:  [1, 2, 5, 8]   <- final sorted result',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_dc AND slug='divide-conquer-intro';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_dc AND slug='merge-sort';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_dc AND slug='quick-sort';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_dc AND slug='divide-conquer-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'Divide and Conquer-এর তিনটা ধাপ কী কী?', 'What are the three steps of divide and conquer?', '// 1. Divide  2. Conquer  3. Combine',
'তিনটা ধাপ: **Divide** (সমস্যা ছোট অংশে ভাগ করা), **Conquer** (প্রতিটা অংশ রিকার্সিভভাবে সমাধান করা), আর **Combine** (অংশগুলোর ফলাফল একত্র করে চূড়ান্ত উত্তর বানানো)।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','Divide, Conquer, Combine',1),(@q,'B','Sort, Search, Return',0),(@q,'C','Loop, Check, Print',0),(@q,'D','শুধু Divide',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'mergeSort()-এ base case কখন পৌঁছায়?', 'When does mergeSort() hit its base case?', 'if length(arr) <= 1:
    return arr  // base case',
'যখন অ্যারেতে ০ বা ১টা এলিমেন্ট থাকে, সেটা এমনিতেই সর্টেড ধরা হয় (আর কিছু করার নেই) — তাই আর ভাগ না করে সরাসরি রিটার্ন করা হয়, এটাই base case।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','যখন অ্যারেতে ০ বা ১টা এলিমেন্ট থাকে',1),(@q,'B','যখন অ্যারে সম্পূর্ণ খালি নয়',0),(@q,'C','কখনোই পৌঁছায় না',0),(@q,'D','যখন সব এলিমেন্ট সমান',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'কুইক সর্টের ওয়ার্স্ট কেস কখন ঘটতে পারে?', 'When can quick sort hit its worst case?', '// bad pivot choice -> worst case O(n^2)',
'যদি বারবার এমন pivot বেছে নেওয়া হয় যা অ্যারেকে খুবই অসমান দুই ভাগে ভাগ করে (যেমন সবসময় সবচেয়ে ছোট বা বড় এলিমেন্ট), তাহলে কুইক সর্ট কার্যত `O(n)` গভীরতার রিকার্শনে পড়ে যায় এবং ওয়ার্স্ট কেসে `O(n^2)` হয়ে যায়।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','যখন pivot বারবার খারাপভাবে বেছে নেওয়া হয় (অসমান ভাগ)',1),(@q,'B','যখন অ্যারে আগে থেকেই সর্টেড থাকে না',0),(@q,'C','কখনোই হয় না',0),(@q,'D','যখন অ্যারেতে ডুপ্লিকেট থাকে',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, '[5, 2] আর [8, 1] মার্জ করার পর কী পাওয়া যাবে?', 'What do you get after merging [5, 2] and [8, 1]?', '// [5, 2] -> [2, 5]
// [8, 1] -> [1, 8]
// merge([2,5], [1,8]) -> ?',
'প্রথমে প্রতিটা জোড়া নিজে নিজেই সর্ট হয় ([5,2]→[2,5], [8,1]→[1,8]), তারপর সেই দুটো সর্টেড অংশ মার্জ করে একটা সম্পূর্ণ সর্টেড অ্যারে বানানো হয়: [1, 2, 5, 8]।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','[5, 2, 8, 1] (অপরিবর্তিত)',0),(@q,'B','[1, 2, 5, 8]',1),(@q,'C','[8, 5, 2, 1]',0),(@q,'D','[2, 5, 1, 8]',0);

-- ── Dynamic Programming Basics ───────────────────────────────────────────
INSERT INTO lessons (module_id, slug, title_bn, title_en, body_md, code_sample, code_sample_language, xp_reward, is_free_preview, sort_order, content_verified) VALUES
(@m_dp, 'dp-intro', 'DP পরিচিতি: overlapping subproblems', 'Introduction to DP: Overlapping Subproblems',
'সাধারণ রিকার্শনে (যেমন ফিবোনাচি) একই সাব-প্রবলেম বারবার সমাধান হয় — `fib(5)` বের করতে `fib(3)` দুইবার, `fib(2)` তিনবার হিসাব হয়। **Dynamic Programming (DP)** এই পুনরাবৃত্ত হিসাব এড়ায় — একবার সমাধান করা সাব-প্রবলেমের উত্তর মনে রেখে (মেমোরাইজ করে) পরে আবার লাগলে সরাসরি ব্যবহার করে।',
'// Plain recursive fibonacci recomputes the same values many times:
// fib(5) -> fib(4) + fib(3)
//   fib(4) -> fib(3) + fib(2)   <- fib(3) computed AGAIN here
//     ...
// DP avoids this by remembering already-computed results.',
NULL, 10, 0, 1, 0),

(@m_dp, 'fibonacci-memoization', 'মেমোইজেশন: fibonacci-কে দ্রুত করা', 'Memoization: Speeding Up Fibonacci',
'**মেমোইজেশন** মানে একটা ক্যাশ (সাধারণত হ্যাশ টেবিল) রেখে দেওয়া, যেখানে প্রতিটা ইনপুটের জন্য গণনা করা ফলাফল জমা থাকে — একই ইনপুটে দ্বিতীয়বার কল হলে আবার গণনা না করে সরাসরি ক্যাশ থেকে রিটার্ন করা হয়। এতে fibonacci `O(2^n)` থেকে `O(n)`-এ নেমে আসে।',
'function fibMemo(n, cache = {}):
    if n in cache:
        return cache[n]           // already computed — reuse it
    if n <= 1:
        return n
    result = fibMemo(n-1, cache) + fibMemo(n-2, cache)
    cache[n] = result              // remember it for next time
    return result',
NULL, 10, 0, 2, 0),

(@m_dp, 'tabulation-vs-memoization', 'টেবুলেশন বনাম মেমোইজেশন', 'Tabulation vs Memoization',
'**মেমোইজেশন** হলো "টপ-ডাউন" — রিকার্শন দিয়ে, প্রয়োজনমতো গণনা করে ক্যাশ করা। **টেবুলেশন** হলো "বটম-আপ" — ছোট থেকে বড় দিকে লুপ দিয়ে একটা অ্যারেতে সব উত্তর আগে থেকেই ভরে ফেলা, কোনো রিকার্শন ছাড়াই। ফলাফল একই, কিন্তু টেবুলেশনে রিকার্শনের কল-স্ট্যাক খরচ থাকে না।',
'function fibTabulation(n):
    table = [0, 1]
    for i from 2 to n:
        table[i] = table[i-1] + table[i-2]
    return table[n]
// bottom-up: builds the answer iteratively, no recursion at all',
NULL, 10, 0, 3, 0),

(@m_dp, 'dp-capstone', 'ক্যাপস্টোন: সিঁড়ি বেয়ে ওঠা (Climbing Stairs)', 'Capstone: Climbing Stairs',
'একটা ক্লাসিক DP প্রবলেম — একবারে ১ বা ২ ধাপ উঠে `n`-ধাপ সিঁড়ি ওঠার কতভাবে সম্ভব? সমাধানটা আসলে ফিবোনাচির মতোই: `ways(n) = ways(n-1) + ways(n-2)`, কারণ শেষ ধাপে ১ বা ২ ধাপ দিয়ে পৌঁছানো যায়।',
'function climbStairs(n):
    if n <= 2:
        return n                    // 1 way for n=1, 2 ways for n=2
    dp = [0] * (n + 1)
    dp[1] = 1
    dp[2] = 2
    for i from 3 to n:
        dp[i] = dp[i-1] + dp[i-2]    // same recurrence as Fibonacci
    return dp[n]',
NULL, 15, 0, 4, 0);

SELECT id INTO @l1 FROM lessons WHERE module_id=@m_dp AND slug='dp-intro';
SELECT id INTO @l2 FROM lessons WHERE module_id=@m_dp AND slug='fibonacci-memoization';
SELECT id INTO @l3 FROM lessons WHERE module_id=@m_dp AND slug='tabulation-vs-memoization';
SELECT id INTO @l4 FROM lessons WHERE module_id=@m_dp AND slug='dp-capstone';

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l1, 'সাধারণ রিকার্সিভ fibonacci-তে সমস্যা কী?', 'What''s the problem with plain recursive fibonacci?', '// fib(3) gets computed multiple times in fib(5)''s call tree',
'সাধারণ রিকার্শনে একই সাব-প্রবলেম (যেমন `fib(3)`) বারবার নতুন করে গণনা করা হয় — এই পুনরাবৃত্ত কাজই DP-এর মাধ্যমে এড়ানো হয়, যা fibonacci-কে অনেক দ্রুত করে দেয়।', 1);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l1 AND sort_order=1;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','একই সাব-প্রবলেম বারবার গণনা হয়',1),(@q,'B','ভুল ফলাফল দেয়',0),(@q,'C','কোনো সমস্যা নেই',0),(@q,'D','মেমোরি ব্যবহার করে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l2, 'n cache-এ আগে থেকেই থাকলে fibMemo() কী করে?', 'What does fibMemo() do if n is already in cache?', 'if n in cache:
    return cache[n]',
'আগে থেকেই গণনা করা থাকলে, ফাংশনটা আবার রিকার্সিভভাবে গণনা না করে সরাসরি ক্যাশ থেকে সেভ করা ফলাফল রিটার্ন করে — এটাই মেমোইজেশনের মূল সুবিধা, পুনরাবৃত্ত কাজ এড়ানো।', 2);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l2 AND sort_order=2;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','আবার নতুন করে গণনা করে',0),(@q,'B','সরাসরি ক্যাশ থেকে সেভ করা মান রিটার্ন করে',1),(@q,'C','এরর দেয়',0),(@q,'D','cache খালি করে দেয়',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l3, 'টেবুলেশন (বটম-আপ) মেমোইজেশনের (টপ-ডাউন) চেয়ে কোন দিক থেকে আলাদা?', 'How is tabulation different from memoization?', 'function fibTabulation(n):
    table = [0, 1]
    for i from 2 to n: table[i] = table[i-1] + table[i-2]',
'টেবুলেশন লুপ দিয়ে ছোট থেকে বড় দিকে সব উত্তর আগে থেকে হিসাব করে, কোনো রিকার্শন ব্যবহার করে না — তাই কল স্ট্যাকের খরচ (স্ট্যাক ওভারফ্লোর ঝুঁকি) নেই, যা মেমোইজেশনে (রিকার্সিভ হওয়ায়) থাকতে পারে।', 3);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l3 AND sort_order=3;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','টেবুলেশন লুপ দিয়ে বটম-আপ কাজ করে, কোনো রিকার্শন নেই',1),(@q,'B','টেবুলেশন সবসময় ভুল ফলাফল দেয়',0),(@q,'C','দুটো আসলে একই জিনিস, কোনো পার্থক্য নেই',0),(@q,'D','টেবুলেশন cache ব্যবহার করতে পারে না',0);

INSERT INTO quiz_questions (lesson_id, question_bn, question_en, code_snippet, explanation_bn, sort_order) VALUES
(@l4, 'climbStairs()-এর রিকারেন্স রিলেশন fibonacci-র সাথে কেন মিলে যায়?', 'Why does climbStairs()''s recurrence match Fibonacci?', 'dp[i] = dp[i-1] + dp[i-2]',
'`n` নম্বর ধাপে পৌঁছানোর দুটো উপায় আছে: `n-1` ধাপ থেকে ১ ধাপ উঠে, অথবা `n-2` ধাপ থেকে ২ ধাপ উঠে — তাই মোট উপায় হলো `ways(n-1) + ways(n-2)`, যা ঠিক fibonacci-র রিকারেন্সের মতোই।', 4);
SELECT id INTO @q FROM quiz_questions WHERE lesson_id=@l4 AND sort_order=4;
INSERT INTO quiz_options (question_id, option_label, option_text_bn, is_correct) VALUES
(@q,'A','এটা নেহাতই কাকতালীয়',0),(@q,'B','শেষ ধাপে ১ বা ২ ধাপ দিয়ে পৌঁছানো যায়, তাই একই যোগফল-রিলেশন প্রযোজ্য',1),(@q,'C','আসলে এটা fibonacci-র মতো না',0),(@q,'D','কারণ দুটোই DP প্রবলেম',0);
