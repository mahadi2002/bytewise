# CONTENT-PLAN.md — lesson/course structure, grounded against live reference sites

This documents the research behind restructuring Bytewise's lesson flow and
content authoring pattern, and the concrete plan for finishing the curriculum.
Written after live review of geeksforgeeks.org, w3schools.com, and (from
general knowledge only — programiz.com timed out/was unreachable through the
browser tool used for this research, consistently, across multiple attempts;
its structure below is not freshly verified) programiz.com's C tracks.

No text, code examples, or exercises were copied from these sites — only
their **structural** patterns (how they group topics, how granular a
"lesson" is, where quizzes sit, how completion is tracked) were studied.
All Bytewise lesson content is original, written in Bengali, in the house
voice already established by `database/seeds/content.sql`.

## What the reference sites actually do

**W3Schools (C tutorial, live-checked)**
- One flat chapter list per language, grouped under headers (BASICS,
  FUNCTIONS, FILES, STRUCTURES, ENUMS, MEMORY, ERRORS, MORE, PROJECTS,
  REFERENCE, EXAMPLES) — roughly 50 chapters total for C, but many are thin
  (e.g. "C Comments" is its own chapter).
- A chapter is **not** one atomic concept — e.g. "C If...Else" is a single
  page covering `if`, `else`, `else if`, short-hand if, nested if, and
  logical operators together, each with its own small example, and ends
  with exactly **one** multiple-choice exercise question near the bottom.
- Every runnable example has an inline "Try it Yourself" editor.
- Progress is account-gated: XP, streaks, leagues, avatar/skins, "X/50
  lessons, X/100 challenges" — i.e. the same gamification shape Bytewise
  already committed to (skill tree + XP + streak), not something to copy
  from here so much as validation that the shape is right.

**GeeksforGeeks (C tutorial, live-checked)**
- Sections: Basics, Functions, Arrays and Strings, Pointers, User Defined
  Data Types, Memory Management, File Handling, Error Handling,
  Miscellaneous Concepts, Advanced Concepts (multithreading, sockets —
  clearly beyond a beginner mobile course's scope).
- Within "Basics" alone: Introduction, Setup, Compilation Process,
  Identifiers, Keywords, Input/Output, Variables, Data Types, **Quiz**,
  Operators, **Quiz**, Conditional Statements, Loops, **Quiz** — i.e. GfG's
  quiz checkpoints sit after a *cluster* of 2-4 related articles, not after
  every single one. Its content is closer to a reference manual than a
  guided course; it does not track a learner's per-lesson completion.
- Its section groupings (Basics → Functions → Arrays/Strings → Pointers →
  Structs/Unions/Enums) match Bytewise's existing 6-module split for C
  almost exactly.

**Programiz (from general knowledge, not live-verified this session)** —
one-topic-per-page tutorials with an inline "Run" compiler, organized in a
similar Basics → Control Flow → Functions → Arrays/Pointers → Structures
progression, plus a separate paid "Certification Course" track with
structured checkpoints. Consistent with the other two; not relied on for
any specific granularity decision below since it couldn't be re-checked.

## What this validates about Bytewise's existing structure

Querying the live DB before writing anything: **all 8 tracks already have a
6-module skeleton that matches the reference-site consensus** (e.g. C:
Basics → Control Flow → Functions → Arrays & Strings → Pointers → Structs).
No module list needed to change. The actual gap is authored *content* inside
those modules (44 of 48 module slots across 8 tracks are empty — see
TODO.md BLOCKER-5) and — until this session — the lesson-completion flow
itself was broken (see below). Advanced reference-site sections (Memory
Management, File Handling, Error Handling, multithreading) are deliberately
left out of Bytewise's scope: this is a beginner mobile course, not a
reference manual, and Data Structures/Algorithms already exist as separate
meta-tracks for the more advanced material.

## The completion/progression flow

This went through two iterations in one session — worth recording both,
since the second reverses the first and the reasoning matters.

**Iteration 1:** before any of this, submitting a lesson's quiz marked it
`completed` regardless of score, gave no per-question feedback, and there
was no link anywhere from one lesson to the next. Fixed by gating
`completed` on a fully-correct quiz submission, with per-question
right/wrong feedback and a Bengali explanation per question
(`quiz_questions.explanation_bn`, migration 010).

**Iteration 2 (current):** the product call came back the other way — the
course should teach *gently*, not gate progress behind a test. The quiz is
now purely optional bonus practice:
- `LessonController::complete()` (`POST /lessons/{id}/complete`) is the
  **only** place `user_lesson_progress.status` becomes `completed`. It
  requires nothing but the click — no quiz, no correct answer. It resolves
  the next lesson in the module (`LessonRepository::nextInModule()`) and
  redirects there, or — on the module's last lesson — back to the track
  page with a module-complete notice, where the next module is now visibly
  unlocked (no stored `is_unlocked` column; `SkillTreeService` recomputes it
  from progress every render).
- `LessonController::submitQuiz()` only grades and awards XP on a
  fully-correct submission — once per lesson, tracked via
  `QuizAttemptRepository::hasBeenRewarded()`, independent of completion
  status. It never marks anything completed and never blocks anything; a
  wrong answer just shows the breakdown + explanation and an offer to
  retry, with the same unconditional "next lesson" control still available.
- Every lesson page shows both controls side by side, clearly labeled: the
  quiz form says "ঐচ্ছিক ... সঠিক উত্তরে বাড়তি XP পাবেন" (optional — a
  correct answer earns bonus XP), and a separate, always-present
  "পরবর্তী লেসনে যান →" button advances regardless of quiz state.

## The lesson-authoring pattern (established, applied to C's Control Flow module)

Matches the tone `content.sql` already set for C's Basics module — this is
a refinement of the existing house style, not a new one:

1. **One concept cluster per lesson**, not one atomic fact — e.g. "if,
   else, else if" together as one lesson, matching how W3Schools bundles
   its chapters rather than GfG's more atomized article list.
2. **1-2 short Bengali paragraphs** of explanation per lesson, code-first,
   ending on the one gotcha/mistake beginners actually hit (matches
   `content.sql`'s existing voice, e.g. the `&` in `scanf()`).
3. **One runnable code sample** per lesson (`code_sample` + `code_sample_language`).
4. **Exactly one quiz question per lesson**, output-prediction style ("what
   does this code print?") rather than trivia recall. (Earlier in this
   project the quiz gated lesson completion, which is why this started
   stricter than GfG's every-few-lessons checkpoint — that gate was later
   removed, see "completion/progression flow" above; the one-question-per-
   lesson shape stayed because it's a good rhythm regardless of gating.)
5. **Every quiz question now has `explanation_bn`** — a 1-2 sentence
   explanation of *why* the correct answer is correct, shown on the result
   page regardless of pass/fail.
6. **A module's last lesson is an applied "capstone"** combining everything
   in that module into one small program — a pattern none of the three
   reference sites does explicitly at the per-module level, kept as a
   Bytewise signature (it already existed in the Basics module's
   "first-calculation-program" lesson feeding directly into the BMI
   Calculator problem; Control Flow's capstone similarly sets up the
   module's FizzBuzz-style problem).

**Environment note:** seed files with Bengali text must be loaded via
`mysql --default-character-set=utf8mb4 ...`, or the raw `mysql.exe` CLI
double-encodes the UTF-8 bytes (mojibake, not a display-only issue — it's
stored corrupted). `php database/migrate.php --seed` (the app's own PDO
connection) does not have this problem; it's specific to the raw CLI
client's default charset on this Windows/XAMPP setup. Hit once early in
this session (`004_c_control_flow.sql`'s first run), fixed by deleting the
corrupted rows and re-running with the flag; every subsequent seed file
(`006`–`014`) used the flag from the start and was verified clean.

## Full curriculum authored, round 1 (closed the original BLOCKER-5)

Every module in all 8 tracks got 4 real lessons, applying the pattern
above — `database/seeds/004_c_control_flow.sql` (C's Control Flow) plus one
file per remaining track (`006_c_remaining.sql` through `013_algorithms.sql`),
plus two explanation-backfill files (`005`, `014`) for the pre-existing
lessons that predated the `explanation_bn` column. This got every track to
a uniform 6 modules × 4 lessons = 24 lessons (192 total). That uniformity
was never a real requirement — it was just how round 1 happened to land —
and round 2 below removed it.

## Curriculum expansion, round 2 — removing the artificial 4-lessons/module cap

The round-1 shape (every module exactly 4 lessons, every track exactly 6
modules) was flagged as an arbitrary self-imposed limit, not a reflection
of what each language actually needs. Re-checked GfG and W3Schools per
language this time (not just C) to find the real gaps:

- **W3Schools Python** groups its core tutorial into ~35 chapters plus a
  dedicated **Python Classes** section (10 chapters: OOP, `__init__`,
  `self`, inheritance, polymorphism, encapsulation...) and a separate
  **File Handling** section (4 chapters) — Bytewise had neither error
  handling nor file handling as a Python module at all.
- **W3Schools Java** has a large **Java Classes** section going well beyond
  Bytewise's 2-module OOP/Inheritance treatment (abstract classes,
  interfaces are there, but polymorphism/abstraction weren't explicit
  lessons), a dedicated **Java Errors** section (exceptions, checked vs.
  unchecked, try-with-resources), and a **Java Data Structures** section
  covering `ArrayList`/`HashMap`/`HashSet` — Java's own Collections
  Framework, a distinct practical skill from the language-agnostic DS
  track Bytewise already has.
- **W3Schools C++** confirmed the same shape: a large Classes section
  (inheritance, polymorphism, templates, friend functions), a dedicated
  Errors section, and an STL section listing `stack`/`queue`/`set`
  alongside the `vector` Bytewise already covered.
- **W3Schools JavaScript** listed `Sets`, `Maps`, `Errors`, and `Classes`
  as first-class core chapters — none of which existed as Bytewise
  JavaScript modules (JS OOP via ES6 `class` was missing entirely).
- **W3Schools SQL** has a full **SQL Database** section (`CREATE TABLE`,
  constraints, keys, indexes, views) — Bytewise's SQL track had only ever
  taught querying an already-existing schema, never how to build one.
- C's own gap (Files, Errors, "More" containing preprocessor macros) was
  already known from the round-1 research but deliberately deferred; round
  2 added it since the "beginner mobile course" scope justification no
  longer applied once other tracks were getting this material.

**What was added** (`database/seeds/015_new_modules.sql` for the module
rows, `016`–`022` for the lesson content — one file per track/pair):

| Track | New modules | Expanded existing module |
|---|---|---|
| C | File Handling, Error Handling & Preprocessor | — |
| C++ | Exception Handling, Templates & More STL | OOP: +Inheritance, +Polymorphism (4→6) |
| Java | Exception Handling, Collections Framework | Inheritance: +Abstract Classes (4→5) |
| Python | Error Handling, File Handling, Modules & Packages | Collections: +Sets (4→5) |
| JavaScript | Error Handling, ES6 Classes | Arrays: +Sets & Maps (4→5) |
| SQL | Database Design & Constraints, Views & Set Operations | — |
| Data Structures | Heaps & Priority Queues | — |
| Algorithms | Greedy Algorithms | — |

Each new module still follows the same per-lesson pattern (concept
cluster → code sample → one quiz question with explanation → capstone
last), just without forcing a fixed count anywhere — Python ended up with
9 modules because it had three genuine gaps (errors, files, modules),
while C only needed two.

## Curriculum expansion, round 3 — deepening further

Requested explicitly as "no skipping, no narrowing down," matching
GfG/W3Schools/Programiz as closely as a *teaching* curriculum reasonably
can. Two things stayed true from round 2 and matter more here: (1) no text,
code, or exercises are copied from those sites — only topic coverage and
structure are studied, all lesson content stays original; (2) reference-
manual pages (keyword lists, method indexes, environment setup) and
adjacent-subject material those sites bundle in (NumPy/Pandas/Matplotlib/ML
under "Python," jQuery/AJAX under "JavaScript," Threads/Sockets/I/O Streams
under "Java") aren't lesson-shaped content or even the same subject as the
language itself, so they're deliberately not chased.

What round 3 added, one more module per track built from the next tier of
real per-language gaps identified by re-reading each site's full chapter
list (W3Schools nav trees for C/C++/Java/Python/JavaScript/SQL, GfG's
"User Defined Data Types"/"Memory Management" sections for C, W3Schools'
Python DSA page for AVL trees):

| Track | New module(s) | Expanded existing module |
|---|---|---|
| C | Enums & Unions, Dynamic Memory Management | — |
| C++ | Enums & Namespaces | — |
| Java | Enum & Generics | — |
| Python | Iterators, Lambda & Comprehensions | OOP: +Polymorphism & Encapsulation (4→5) |
| JavaScript | DOM Basics, ES6+ Features (destructuring/spread/modules) | — |
| SQL | CASE, NULL Functions & Stored Procedures | — |
| Data Structures | AVL Trees & Balancing | — |
| Algorithms | Backtracking | — |

**Final shape — no track forced to match another:**

| Track | Modules | Lessons | Quizzes |
|---|---|---|---|
| C | 10 | 40 | 40 |
| C++ | 9 | 38 | 38 |
| Java | 9 | 37 | 37 |
| Python | 10 | 42 | 42 |
| JavaScript | 10 | 41 | 41 |
| SQL | 9 | 36 | 36 |
| Data Structures | 8 | 32 | 32 |
| Algorithms | 8 | 32 | 32 |
| **Total** | **73** | **298** | **298** |

Verified the same way as rounds 1-2: DB integrity (every module ≥1 lesson,
every lesson exactly 1 quiz with exactly 4 options and 1 correct answer,
zero missing explanations, zero UTF-8 corruption) plus a full live run —
logged in as a fresh subscriber, completed all 40 of C's lessons (now 10
modules) via the real `/lessons/{id}/complete` endpoint, watched C reach
100% and C++ auto-unlock showing its own new module on the skill tree.

C++/Java/Python/JavaScript/SQL each got 3 new lessons finishing their
Basics module plus 4 lessons in each of the other 5 modules (round 1). Data
Structures and Algorithms follow the same shape but in language-agnostic
pseudocode (`code_sample_language = NULL`), matching their existing lesson
1's style. SQL's lessons share one consistent fictional schema across every
example (`students(id, name, age, marks, class_id)`, `classes(id, class_name)`)
so JOIN/subquery examples build on earlier lessons rather than introducing
a new schema each time — round 2's schema-design module retroactively
"explains" where that schema came from (`CREATE TABLE` for exactly those
two tables).

**Verified, not just written:**
- DB integrity: every one of the 63 modules has at least 1 lesson (0
  zero-lesson modules); every lesson has exactly 1 quiz question; every
  question has exactly 4 options with exactly 1 marked correct; zero
  questions missing `explanation_bn`; zero UTF-8 corruption across every
  `title_bn`/`question_bn`/`explanation_bn` in the database (checked for
  the `Ã`/`â€`/`Â` mojibake signature); sort_order sequences in the 4
  expanded modules confirmed gap-free with new lessons landing before the
  pushed-back capstone.
- Live, not just DB: authenticated as a real subscriber and completed all
  32 of C's lessons (now 8 modules, including the 2 brand-new ones) via
  the actual `/lessons/{id}/complete` endpoint — C reached 100% and C++
  auto-unlocked on the skill tree showing its own 2 new modules, all with
  no stored unlock flag (`SkillTreeService` recomputes from progress).
  Also spot-checked a locked new module (`/courses/c/file-handling`)
  correctly shows the lock notice before it was reachable.

**Still open** (tracked as BLOCKER-5b in TODO.md, distinct from the lesson
work above): the judge-graded coding **problems** (`problems` table,
`/problems/{id}` + submissions — separate from lesson quizzes) are still
just 1 per track, 8 total. More problems per track, and more hybrid
projects beyond the single existing one, remain future authoring work.
