-- =============================================================================
-- Bytewise — 002_placement.sql (supplementary seed, NOT part of the
-- app-owner-provided 02-SCHEMA-SEED.sql)
--
-- 02-SCHEMA-SEED.sql seeds no placement_questions/placement_options rows at
-- all, but BUILD-SPEC §5/04-AI-BUILD-PLAYBOOK.md Phase 8 requires the
-- placement test to actually complete and recommend a module for at least
-- one track. This file adds a minimal, assistant-authored question set for
-- the C track only (5 questions, one per module up to pointers) so the
-- feature is genuinely testable — same content-integrity flag as the rest
-- of the seed data (rulebook §8): unverified, not sourced from a reviewed
-- curriculum, safe as a structural placeholder, not a launch-ready
-- diagnostic. The other 7 tracks have zero placement questions; the
-- controller must degrade gracefully (a "coming soon" state), never error.
-- Track this gap in TODO.md alongside BLOCKER-5.
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
