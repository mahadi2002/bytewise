-- Backfills explanation_bn for the 7 remaining pre-existing quiz questions
-- (each track's original free-preview lesson 1, written in content.sql
-- before migration 010 added the column) so every quiz in the app has an
-- explanation, not just the lessons authored in this session.
-- Idempotent, keyed by question id. Run with: mysql --default-character-set=utf8mb4 ...

UPDATE quiz_questions SET explanation_bn =
'২০ ভ্যালু নিয়ে `age`-কে `int` হিসেবে ঘোষণা করা হয়েছে — C++-এও এটা C-এর মতোই কাজ করে, কোনো রূপান্তর হয় না, তাই `age` মানে সরাসরি `20`।'
WHERE id = 5; -- cpp: variables-cout

UPDATE quiz_questions SET explanation_bn =
'২০ ভ্যালু নিয়ে `age`-কে `int` হিসেবে ঘোষণা করা হয়েছে — জাভাতেও অ্যাসাইনমেন্টের পর ভেরিয়েবলে সেই ভ্যালুটাই থাকে, তাই `age` মানে সরাসরি `20`।'
WHERE id = 6; -- java: variables-println

UPDATE quiz_questions SET explanation_bn =
'পাইথনে `age = 20` লিখলে `age`-এ সরাসরি `20` (একটা int) বসে যায় — কোনো টাইপ ঘোষণার দরকার নেই, dynamic typing-এ ভ্যালু থেকেই টাইপ ঠিক হয়।'
WHERE id = 7; -- python3: variables-print

UPDATE quiz_questions SET explanation_bn =
'`let age = 20;` লিখলে `age`-এ সরাসরি `20` (একটা number) বসে যায় — জাভাস্ক্রিপ্টেও dynamic typing, কোনো রূপান্তর হয় না।'
WHERE id = 8; -- javascript: variables-console-log

UPDATE quiz_questions SET explanation_bn =
'`WHERE age = 20` শর্তটা শুধু ২০ বছর বয়সী স্টুডেন্টদের রো বেছে নেয়, আর `SELECT name, age` শুধু সেই দুটো কলামই দেখায় — বাকি কলাম বা বাকি বয়সের স্টুডেন্ট ফলাফলে আসবে না।'
WHERE id = 9; -- sql: select-basics

UPDATE quiz_questions SET explanation_bn =
'C, C++, Java, Python, JavaScript — এই সবগুলো ভাষাতেই অ্যারের ইনডেক্স `0` থেকে শুরু হয় (zero-based indexing), তাই প্রথম এলিমেন্টের ইনডেক্স `0`, `1` নয়।'
WHERE id = 10; -- data-structures: what-is-an-array

UPDATE quiz_questions SET explanation_bn =
'সাজানো-না-থাকা একটা অ্যারেতে লিনিয়ার সার্চে ওয়ার্স্ট কেসে (টার্গেট শেষে বা নেই) প্রতিটা এলিমেন্ট একে একে চেক করতে হতে পারে — `n`টা এলিমেন্টে সর্বোচ্চ `n` বার তুলনা, তাই `O(n)`।'
WHERE id = 11; -- algorithms: what-is-an-algorithm
