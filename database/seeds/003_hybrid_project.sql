-- =============================================================================
-- 003_hybrid_project.sql (supplementary seed, assistant-authored — same
-- unverified-content flag as the rest of the seed set, per rulebook §8)
--
-- Demonstrates the project_languages junction table (migration 009) with a
-- genuinely non-redundant hybrid: Python + Data Structures. Unlike pairing
-- two of the six chain languages (where completing the later one already
-- implies the earlier one, per the enforced C->...->SQL chain), Data
-- Structures only requires "any one language complete" — so this project's
-- two requirements are independent, not one subsuming the other.
-- =============================================================================

SET NAMES utf8mb4;

SELECT id INTO @lang_py FROM languages WHERE slug = 'python3';
SELECT id INTO @lang_ds FROM languages WHERE slug = 'data-structures';

INSERT INTO projects (slug, title_bn, title_en, brief_md, rubric_md, starter_repo_notes, xp_reward, content_verified) VALUES
('contact-book-cli', 'কন্টাক্ট বুক (Hybrid)', 'Contact Book (Hybrid: Python + Data Structures)',
'Python দিয়ে একটি কমান্ড-লাইন কন্টাক্ট বুক বানান, যেখানে কন্টাক্ট যোগ, খোঁজা, মুছে ফেলা যাবে। এটি একটি **hybrid প্রজেক্ট** — শুধু Python সিনট্যাক্স জানলেই হবে না, Data Structures ট্র্যাকে শেখা ধারণাও প্রয়োগ করতে হবে:

- দ্রুত নাম দিয়ে খোঁজার জন্য একটি হ্যাশ টেবিল-ভিত্তিক গঠন ব্যবহার করুন (Python-এর dict আসলে একটি হ্যাশ টেবিলের বাস্তবায়ন — কেন এটি O(1) গড় লুকআপ দেয় তা রিপোর্টে ব্যাখ্যা করুন)।
- সাম্প্রতিক যোগ করা কন্টাক্টের একটি "undo" ফিচার যোগ করুন একটি স্ট্যাক (LIFO) ব্যবহার করে।

লক্ষ্য: একটি ভাষার সিনট্যাক্স আর একটি ডেটা স্ট্রাকচার ধারণা — দুটো আলাদা ট্র্যাকে শেখা জিনিস একসাথে প্রয়োগ করা, ঠিক যেমন বাস্তব প্রজেক্টে হয়।',
'- Add/search/delete কন্টাক্ট সঠিকভাবে কাজ করে কিনা\n- হ্যাশ টেবিল-ভিত্তিক লুকআপ ব্যবহার করা হয়েছে কিনা, এবং কেন তা দ্রুত তা সংক্ষেপে ব্যাখ্যা করা আছে কিনা\n- Undo ফিচারে স্ট্যাক (LIFO) সঠিকভাবে ব্যবহৃত হয়েছে কিনা\n- কোড রিডেবল ও ফাংশনে যৌক্তিকভাবে ভাগ করা কিনা',
'সাজেস্টেড ফাইল: contact_book.py — কোনো এক্সটার্নাল লাইব্রেরি লাগবে না, Python-এর বিল্ট-ইন dict/list-ই যথেষ্ট।',
150, 0);

SELECT id INTO @p_contactbook FROM projects WHERE slug = 'contact-book-cli';

INSERT INTO project_languages (project_id, language_id, is_primary) VALUES
(@p_contactbook, @lang_py, 1),
(@p_contactbook, @lang_ds, 0);
