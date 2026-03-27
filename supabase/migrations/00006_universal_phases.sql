-- ============================================================================
-- 00006_universal_phases.sql
-- Replaces Phase 1 and Phase 2 module + lesson content across all 4 archetypes
-- with shared universal PM foundation content.
-- Phase 3 and Phase 4 are untouched.
-- Safe to re-run (DELETE + INSERT).
-- ============================================================================

-- ── STEP 1: UPDATE MODULE METADATA ──────────────────────────────────────────

-- PHASE 1, MODULE 1 — all 4 archetypes
UPDATE modules SET
  title              = 'What Does a Product Manager Actually Do?',
  description        = 'Understand the PM role, its scope, and how it varies across company stages and product types.',
  learning_objective = 'Understand the PM role, its scope, and how it varies across company stages and product types.'
WHERE id IN (
  'c1010000-0000-0000-0000-000000000001',
  'c1020000-0000-0000-0000-000000000001',
  'c1030000-0000-0000-0000-000000000001',
  'c1040000-0000-0000-0000-000000000001'
);

-- PHASE 1, MODULE 2 — all 4 archetypes
UPDATE modules SET
  title              = 'User Needs, Problem Framing & the Product Discovery Mindset',
  description        = 'Apply at least one user research technique to reframe a product problem from a user perspective.',
  learning_objective = 'Apply at least one user research technique to reframe a product problem from a user perspective.'
WHERE id IN (
  'c1010000-0000-0000-0000-000000000002',
  'c1020000-0000-0000-0000-000000000002',
  'c1030000-0000-0000-0000-000000000002',
  'c1040000-0000-0000-0000-000000000002'
);

-- PHASE 2, MODULE 3 — all 4 archetypes
UPDATE modules SET
  title              = 'Writing Product Requirements — PRDs That Teams Actually Use',
  description        = 'Write a structured PRD for a simple product feature that a designer and engineer could act on without follow-up questions.',
  learning_objective = 'Write a structured PRD for a simple product feature that a designer and engineer could act on without follow-up questions.'
WHERE id IN (
  'c1010000-0000-0000-0000-000000000003',
  'c1020000-0000-0000-0000-000000000003',
  'c1030000-0000-0000-0000-000000000003',
  'c1040000-0000-0000-0000-000000000003'
);

-- PHASE 2, MODULE 4 — all 4 archetypes
UPDATE modules SET
  title              = 'Prioritisation — How PMs Decide What to Build Next',
  description        = 'Apply the RICE framework to a 5-item backlog and defend your top 2 choices with a written rationale.',
  learning_objective = 'Apply the RICE framework to a 5-item backlog and defend your top 2 choices with a written rationale.'
WHERE id IN (
  'c1010000-0000-0000-0000-000000000004',
  'c1020000-0000-0000-0000-000000000004',
  'c1030000-0000-0000-0000-000000000004',
  'c1040000-0000-0000-0000-000000000004'
);

-- ── STEP 2: DELETE OLD LESSONS FOR PHASE 1 & 2 MODULES ──────────────────────

DELETE FROM lessons WHERE module_id IN (
  'c1010000-0000-0000-0000-000000000001',
  'c1010000-0000-0000-0000-000000000002',
  'c1010000-0000-0000-0000-000000000003',
  'c1010000-0000-0000-0000-000000000004',
  'c1020000-0000-0000-0000-000000000001',
  'c1020000-0000-0000-0000-000000000002',
  'c1020000-0000-0000-0000-000000000003',
  'c1020000-0000-0000-0000-000000000004',
  'c1030000-0000-0000-0000-000000000001',
  'c1030000-0000-0000-0000-000000000002',
  'c1030000-0000-0000-0000-000000000003',
  'c1030000-0000-0000-0000-000000000004',
  'c1040000-0000-0000-0000-000000000001',
  'c1040000-0000-0000-0000-000000000002',
  'c1040000-0000-0000-0000-000000000003',
  'c1040000-0000-0000-0000-000000000004'
);

-- ── STEP 3: INSERT UNIVERSAL LESSONS ────────────────────────────────────────
-- UUID pattern: f1000000-00PP-00MM-00LL-000000000000
-- PP = program (01-04), MM = module in phase 1-2 (01-04), LL = lesson (01-05)

-- ════════════════════════════════════════════════════════════════════════════
-- MODULE 1: "What Does a Product Manager Actually Do?"
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO lessons (id, module_id, title, content, description, lesson_type, source, author, order_index) VALUES

-- GROWTH PM
('f1000000-0001-0001-0001-000000000000', 'c1010000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'A clear, practical breakdown of what PMs do day-to-day and why the role exists. Covers how the PM role varies across B2C, B2B, platform, and growth-stage companies.',
  'Lenny''s definitive intro to the PM role.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0001-0001-0002-000000000000', 'c1010000-0000-0000-0000-000000000001',
  'A Day in the Life of a PM',
  'Walk through a real PM''s workday — from morning stand-ups and customer calls to stakeholder alignment, design reviews, and writing specs. Demystifies what the job actually looks like hour by hour.',
  'A real PM''s day from Product School.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0001-0001-0003-000000000000', 'c1010000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'The definitive written intro to the PM role from Lenny Rachitsky — what it is, what it isn''t, and how it varies by company stage and product type. Required reading for anyone entering the field.',
  'The PM role, explained clearly.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0001-0001-0004-000000000000', 'c1010000-0000-0000-0000-000000000001',
  'Good Product Manager / Bad Product Manager',
  'A classic 1996 essay by Ben Horowitz that still defines the behaviours and mindset separating effective PMs from ineffective ones. Blunt, specific, and still quoted in PM interviews today.',
  'The essay that defined PM excellence.', 'reading', 'a16z', 'Ben Horowitz', 4),

('f1000000-0001-0001-0005-000000000000', 'c1010000-0000-0000-0000-000000000001',
  'PM Role Reflection',
  'Write a 200-word reflection: describe the PM role as you understand it now. What surprised you? What aspect of PM work are you most drawn to?',
  'Reflect on what the PM role means to you.', 'task', NULL, NULL, 5),

-- TECHNICAL PM
('f1000000-0002-0001-0001-000000000000', 'c1020000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'A clear, practical breakdown of what PMs do day-to-day and why the role exists. Covers how the PM role varies across B2C, B2B, platform, and growth-stage companies.',
  'Lenny''s definitive intro to the PM role.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0002-0001-0002-000000000000', 'c1020000-0000-0000-0000-000000000001',
  'A Day in the Life of a PM',
  'Walk through a real PM''s workday — from morning stand-ups and customer calls to stakeholder alignment, design reviews, and writing specs. Demystifies what the job actually looks like hour by hour.',
  'A real PM''s day from Product School.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0002-0001-0003-000000000000', 'c1020000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'The definitive written intro to the PM role from Lenny Rachitsky — what it is, what it isn''t, and how it varies by company stage and product type. Required reading for anyone entering the field.',
  'The PM role, explained clearly.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0002-0001-0004-000000000000', 'c1020000-0000-0000-0000-000000000001',
  'Good Product Manager / Bad Product Manager',
  'A classic 1996 essay by Ben Horowitz that still defines the behaviours and mindset separating effective PMs from ineffective ones. Blunt, specific, and still quoted in PM interviews today.',
  'The essay that defined PM excellence.', 'reading', 'a16z', 'Ben Horowitz', 4),

('f1000000-0002-0001-0005-000000000000', 'c1020000-0000-0000-0000-000000000001',
  'PM Role Reflection',
  'Write a 200-word reflection: describe the PM role as you understand it now. What surprised you? What aspect of PM work are you most drawn to?',
  'Reflect on what the PM role means to you.', 'task', NULL, NULL, 5),

-- CONSUMER PM
('f1000000-0003-0001-0001-000000000000', 'c1030000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'A clear, practical breakdown of what PMs do day-to-day and why the role exists. Covers how the PM role varies across B2C, B2B, platform, and growth-stage companies.',
  'Lenny''s definitive intro to the PM role.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0003-0001-0002-000000000000', 'c1030000-0000-0000-0000-000000000001',
  'A Day in the Life of a PM',
  'Walk through a real PM''s workday — from morning stand-ups and customer calls to stakeholder alignment, design reviews, and writing specs. Demystifies what the job actually looks like hour by hour.',
  'A real PM''s day from Product School.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0003-0001-0003-000000000000', 'c1030000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'The definitive written intro to the PM role from Lenny Rachitsky — what it is, what it isn''t, and how it varies by company stage and product type. Required reading for anyone entering the field.',
  'The PM role, explained clearly.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0003-0001-0004-000000000000', 'c1030000-0000-0000-0000-000000000001',
  'Good Product Manager / Bad Product Manager',
  'A classic 1996 essay by Ben Horowitz that still defines the behaviours and mindset separating effective PMs from ineffective ones. Blunt, specific, and still quoted in PM interviews today.',
  'The essay that defined PM excellence.', 'reading', 'a16z', 'Ben Horowitz', 4),

('f1000000-0003-0001-0005-000000000000', 'c1030000-0000-0000-0000-000000000001',
  'PM Role Reflection',
  'Write a 200-word reflection: describe the PM role as you understand it now. What surprised you? What aspect of PM work are you most drawn to?',
  'Reflect on what the PM role means to you.', 'task', NULL, NULL, 5),

-- AI / DATA PM
('f1000000-0004-0001-0001-000000000000', 'c1040000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'A clear, practical breakdown of what PMs do day-to-day and why the role exists. Covers how the PM role varies across B2C, B2B, platform, and growth-stage companies.',
  'Lenny''s definitive intro to the PM role.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0004-0001-0002-000000000000', 'c1040000-0000-0000-0000-000000000001',
  'A Day in the Life of a PM',
  'Walk through a real PM''s workday — from morning stand-ups and customer calls to stakeholder alignment, design reviews, and writing specs. Demystifies what the job actually looks like hour by hour.',
  'A real PM''s day from Product School.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0004-0001-0003-000000000000', 'c1040000-0000-0000-0000-000000000001',
  'What is Product Management?',
  'The definitive written intro to the PM role from Lenny Rachitsky — what it is, what it isn''t, and how it varies by company stage and product type. Required reading for anyone entering the field.',
  'The PM role, explained clearly.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0004-0001-0004-000000000000', 'c1040000-0000-0000-0000-000000000001',
  'Good Product Manager / Bad Product Manager',
  'A classic 1996 essay by Ben Horowitz that still defines the behaviours and mindset separating effective PMs from ineffective ones. Blunt, specific, and still quoted in PM interviews today.',
  'The essay that defined PM excellence.', 'reading', 'a16z', 'Ben Horowitz', 4),

('f1000000-0004-0001-0005-000000000000', 'c1040000-0000-0000-0000-000000000001',
  'PM Role Reflection',
  'Write a 200-word reflection: describe the PM role as you understand it now. What surprised you? What aspect of PM work are you most drawn to?',
  'Reflect on what the PM role means to you.', 'task', NULL, NULL, 5);

-- ════════════════════════════════════════════════════════════════════════════
-- MODULE 2: "User Needs, Problem Framing & the Product Discovery Mindset"
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO lessons (id, module_id, title, content, description, lesson_type, source, author, order_index) VALUES

-- GROWTH PM
('f1000000-0001-0002-0001-000000000000', 'c1010000-0000-0000-0000-000000000002',
  'How to Run User Interviews',
  'A step-by-step guide to running discovery interviews that surface real behaviour rather than stated preferences. Covers how to recruit, structure the conversation, and avoid leading questions.',
  'Teresa Torres on structured discovery interviews.', 'video', 'YouTube (Product Talk)', 'Teresa Torres', 1),

('f1000000-0001-0002-0002-000000000000', 'c1010000-0000-0000-0000-000000000002',
  'The Mom Test in 10 Minutes',
  'A fast-paced summary of Rob Fitzpatrick''s framework for asking questions that get honest answers — even from people who want to be nice or supportive.',
  'The Mom Test condensed into 10 minutes.', 'video', 'YouTube', NULL, 2),

('f1000000-0001-0002-0003-000000000000', 'c1010000-0000-0000-0000-000000000002',
  'The Mom Test',
  'The definitive guide to customer conversations that actually work. Learn why most customer interview questions are flawed, and how to ask about behaviour, context, and pain instead of opinions.',
  'How to ask questions that give you real signal.', 'reading', 'momtestbook.com', 'Rob Fitzpatrick', 3),

('f1000000-0001-0002-0004-000000000000', 'c1010000-0000-0000-0000-000000000002',
  'Continuous Discovery Habits — Introduction',
  'An intro to the continuous discovery mindset — why product teams need to talk to users every week (not just before big bets), and how to build that habit into your workflow.',
  'Why weekly discovery beats quarterly research.', 'reading', 'producttalk.org', 'Teresa Torres', 4),

('f1000000-0001-0002-0005-000000000000', 'c1010000-0000-0000-0000-000000000002',
  'User Interview Question Design',
  'Pick any app you use daily. Write 5 user interview questions you''d ask a real user — focused on behaviour and pain, not opinions. Include one line per question explaining what assumption you''re testing.',
  'Write 5 discovery questions for a real app.', 'task', NULL, NULL, 5),

-- TECHNICAL PM
('f1000000-0002-0002-0001-000000000000', 'c1020000-0000-0000-0000-000000000002',
  'How to Run User Interviews',
  'A step-by-step guide to running discovery interviews that surface real behaviour rather than stated preferences. Covers how to recruit, structure the conversation, and avoid leading questions.',
  'Teresa Torres on structured discovery interviews.', 'video', 'YouTube (Product Talk)', 'Teresa Torres', 1),

('f1000000-0002-0002-0002-000000000000', 'c1020000-0000-0000-0000-000000000002',
  'The Mom Test in 10 Minutes',
  'A fast-paced summary of Rob Fitzpatrick''s framework for asking questions that get honest answers — even from people who want to be nice or supportive.',
  'The Mom Test condensed into 10 minutes.', 'video', 'YouTube', NULL, 2),

('f1000000-0002-0002-0003-000000000000', 'c1020000-0000-0000-0000-000000000002',
  'The Mom Test',
  'The definitive guide to customer conversations that actually work. Learn why most customer interview questions are flawed, and how to ask about behaviour, context, and pain instead of opinions.',
  'How to ask questions that give you real signal.', 'reading', 'momtestbook.com', 'Rob Fitzpatrick', 3),

('f1000000-0002-0002-0004-000000000000', 'c1020000-0000-0000-0000-000000000002',
  'Continuous Discovery Habits — Introduction',
  'An intro to the continuous discovery mindset — why product teams need to talk to users every week (not just before big bets), and how to build that habit into your workflow.',
  'Why weekly discovery beats quarterly research.', 'reading', 'producttalk.org', 'Teresa Torres', 4),

('f1000000-0002-0002-0005-000000000000', 'c1020000-0000-0000-0000-000000000002',
  'User Interview Question Design',
  'Pick any app you use daily. Write 5 user interview questions you''d ask a real user — focused on behaviour and pain, not opinions. Include one line per question explaining what assumption you''re testing.',
  'Write 5 discovery questions for a real app.', 'task', NULL, NULL, 5),

-- CONSUMER PM
('f1000000-0003-0002-0001-000000000000', 'c1030000-0000-0000-0000-000000000002',
  'How to Run User Interviews',
  'A step-by-step guide to running discovery interviews that surface real behaviour rather than stated preferences. Covers how to recruit, structure the conversation, and avoid leading questions.',
  'Teresa Torres on structured discovery interviews.', 'video', 'YouTube (Product Talk)', 'Teresa Torres', 1),

('f1000000-0003-0002-0002-000000000000', 'c1030000-0000-0000-0000-000000000002',
  'The Mom Test in 10 Minutes',
  'A fast-paced summary of Rob Fitzpatrick''s framework for asking questions that get honest answers — even from people who want to be nice or supportive.',
  'The Mom Test condensed into 10 minutes.', 'video', 'YouTube', NULL, 2),

('f1000000-0003-0002-0003-000000000000', 'c1030000-0000-0000-0000-000000000002',
  'The Mom Test',
  'The definitive guide to customer conversations that actually work. Learn why most customer interview questions are flawed, and how to ask about behaviour, context, and pain instead of opinions.',
  'How to ask questions that give you real signal.', 'reading', 'momtestbook.com', 'Rob Fitzpatrick', 3),

('f1000000-0003-0002-0004-000000000000', 'c1030000-0000-0000-0000-000000000002',
  'Continuous Discovery Habits — Introduction',
  'An intro to the continuous discovery mindset — why product teams need to talk to users every week (not just before big bets), and how to build that habit into your workflow.',
  'Why weekly discovery beats quarterly research.', 'reading', 'producttalk.org', 'Teresa Torres', 4),

('f1000000-0003-0002-0005-000000000000', 'c1030000-0000-0000-0000-000000000002',
  'User Interview Question Design',
  'Pick any app you use daily. Write 5 user interview questions you''d ask a real user — focused on behaviour and pain, not opinions. Include one line per question explaining what assumption you''re testing.',
  'Write 5 discovery questions for a real app.', 'task', NULL, NULL, 5),

-- AI / DATA PM
('f1000000-0004-0002-0001-000000000000', 'c1040000-0000-0000-0000-000000000002',
  'How to Run User Interviews',
  'A step-by-step guide to running discovery interviews that surface real behaviour rather than stated preferences. Covers how to recruit, structure the conversation, and avoid leading questions.',
  'Teresa Torres on structured discovery interviews.', 'video', 'YouTube (Product Talk)', 'Teresa Torres', 1),

('f1000000-0004-0002-0002-000000000000', 'c1040000-0000-0000-0000-000000000002',
  'The Mom Test in 10 Minutes',
  'A fast-paced summary of Rob Fitzpatrick''s framework for asking questions that get honest answers — even from people who want to be nice or supportive.',
  'The Mom Test condensed into 10 minutes.', 'video', 'YouTube', NULL, 2),

('f1000000-0004-0002-0003-000000000000', 'c1040000-0000-0000-0000-000000000002',
  'The Mom Test',
  'The definitive guide to customer conversations that actually work. Learn why most customer interview questions are flawed, and how to ask about behaviour, context, and pain instead of opinions.',
  'How to ask questions that give you real signal.', 'reading', 'momtestbook.com', 'Rob Fitzpatrick', 3),

('f1000000-0004-0002-0004-000000000000', 'c1040000-0000-0000-0000-000000000002',
  'Continuous Discovery Habits — Introduction',
  'An intro to the continuous discovery mindset — why product teams need to talk to users every week (not just before big bets), and how to build that habit into your workflow.',
  'Why weekly discovery beats quarterly research.', 'reading', 'producttalk.org', 'Teresa Torres', 4),

('f1000000-0004-0002-0005-000000000000', 'c1040000-0000-0000-0000-000000000002',
  'User Interview Question Design',
  'Pick any app you use daily. Write 5 user interview questions you''d ask a real user — focused on behaviour and pain, not opinions. Include one line per question explaining what assumption you''re testing.',
  'Write 5 discovery questions for a real app.', 'task', NULL, NULL, 5);

-- ════════════════════════════════════════════════════════════════════════════
-- MODULE 3: "Writing Product Requirements — PRDs That Teams Actually Use"
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO lessons (id, module_id, title, content, description, lesson_type, source, author, order_index) VALUES

-- GROWTH PM
('f1000000-0001-0003-0001-000000000000', 'c1010000-0000-0000-0000-000000000003',
  'How to Write a PRD',
  'A practical walkthrough of how to write product requirements documents that teams actually use and act on. Covers structure, level of detail, what to include vs. exclude, and how to get buy-in from engineering and design.',
  'Lenny''s guide to PRDs that get built.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0001-0003-0002-000000000000', 'c1010000-0000-0000-0000-000000000003',
  'Writing PRDs Engineers Love',
  'How to frame requirements in a way that reduces rework, clarifies scope, and makes engineers'' jobs easier. Covers how to write acceptance criteria and edge cases that eliminate ambiguity.',
  'Frame specs so engineers can build without follow-ups.', 'video', 'YouTube', NULL, 2),

('f1000000-0001-0003-0003-000000000000', 'c1010000-0000-0000-0000-000000000003',
  'My Favourite PRD Template',
  'A battle-tested PRD template from Lenny Rachitsky with explanation of why each section matters, what good looks like, and common mistakes PMs make when writing requirements.',
  'A PRD template you can use immediately.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0001-0003-0004-000000000000', 'c1010000-0000-0000-0000-000000000003',
  'How to Write a Good PRD',
  'A clear guide to writing PRDs that create alignment rather than ambiguity across design, engineering, and data. Covers how to scope, structure, and get feedback on requirements docs.',
  'PRDs that align design, eng, and data teams.', 'reading', 'Medium', 'Carlin Yuen', 4),

('f1000000-0001-0003-0005-000000000000', 'c1010000-0000-0000-0000-000000000003',
  'Write a Feature PRD',
  'Write a PRD for one of: a basic notification settings page, a search filter UI, or an onboarding checklist. Must include: problem statement, user story, acceptance criteria, edge cases, and one success metric. Target 300–400 words.',
  'Write a real PRD from scratch.', 'task', NULL, NULL, 5),

-- TECHNICAL PM
('f1000000-0002-0003-0001-000000000000', 'c1020000-0000-0000-0000-000000000003',
  'How to Write a PRD',
  'A practical walkthrough of how to write product requirements documents that teams actually use and act on. Covers structure, level of detail, what to include vs. exclude, and how to get buy-in from engineering and design.',
  'Lenny''s guide to PRDs that get built.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0002-0003-0002-000000000000', 'c1020000-0000-0000-0000-000000000003',
  'Writing PRDs Engineers Love',
  'How to frame requirements in a way that reduces rework, clarifies scope, and makes engineers'' jobs easier. Covers how to write acceptance criteria and edge cases that eliminate ambiguity.',
  'Frame specs so engineers can build without follow-ups.', 'video', 'YouTube', NULL, 2),

('f1000000-0002-0003-0003-000000000000', 'c1020000-0000-0000-0000-000000000003',
  'My Favourite PRD Template',
  'A battle-tested PRD template from Lenny Rachitsky with explanation of why each section matters, what good looks like, and common mistakes PMs make when writing requirements.',
  'A PRD template you can use immediately.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0002-0003-0004-000000000000', 'c1020000-0000-0000-0000-000000000003',
  'How to Write a Good PRD',
  'A clear guide to writing PRDs that create alignment rather than ambiguity across design, engineering, and data. Covers how to scope, structure, and get feedback on requirements docs.',
  'PRDs that align design, eng, and data teams.', 'reading', 'Medium', 'Carlin Yuen', 4),

('f1000000-0002-0003-0005-000000000000', 'c1020000-0000-0000-0000-000000000003',
  'Write a Feature PRD',
  'Write a PRD for one of: a basic notification settings page, a search filter UI, or an onboarding checklist. Must include: problem statement, user story, acceptance criteria, edge cases, and one success metric. Target 300–400 words.',
  'Write a real PRD from scratch.', 'task', NULL, NULL, 5),

-- CONSUMER PM
('f1000000-0003-0003-0001-000000000000', 'c1030000-0000-0000-0000-000000000003',
  'How to Write a PRD',
  'A practical walkthrough of how to write product requirements documents that teams actually use and act on. Covers structure, level of detail, what to include vs. exclude, and how to get buy-in from engineering and design.',
  'Lenny''s guide to PRDs that get built.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0003-0003-0002-000000000000', 'c1030000-0000-0000-0000-000000000003',
  'Writing PRDs Engineers Love',
  'How to frame requirements in a way that reduces rework, clarifies scope, and makes engineers'' jobs easier. Covers how to write acceptance criteria and edge cases that eliminate ambiguity.',
  'Frame specs so engineers can build without follow-ups.', 'video', 'YouTube', NULL, 2),

('f1000000-0003-0003-0003-000000000000', 'c1030000-0000-0000-0000-000000000003',
  'My Favourite PRD Template',
  'A battle-tested PRD template from Lenny Rachitsky with explanation of why each section matters, what good looks like, and common mistakes PMs make when writing requirements.',
  'A PRD template you can use immediately.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0003-0003-0004-000000000000', 'c1030000-0000-0000-0000-000000000003',
  'How to Write a Good PRD',
  'A clear guide to writing PRDs that create alignment rather than ambiguity across design, engineering, and data. Covers how to scope, structure, and get feedback on requirements docs.',
  'PRDs that align design, eng, and data teams.', 'reading', 'Medium', 'Carlin Yuen', 4),

('f1000000-0003-0003-0005-000000000000', 'c1030000-0000-0000-0000-000000000003',
  'Write a Feature PRD',
  'Write a PRD for one of: a basic notification settings page, a search filter UI, or an onboarding checklist. Must include: problem statement, user story, acceptance criteria, edge cases, and one success metric. Target 300–400 words.',
  'Write a real PRD from scratch.', 'task', NULL, NULL, 5),

-- AI / DATA PM
('f1000000-0004-0003-0001-000000000000', 'c1040000-0000-0000-0000-000000000003',
  'How to Write a PRD',
  'A practical walkthrough of how to write product requirements documents that teams actually use and act on. Covers structure, level of detail, what to include vs. exclude, and how to get buy-in from engineering and design.',
  'Lenny''s guide to PRDs that get built.', 'video', 'YouTube', 'Lenny Rachitsky', 1),

('f1000000-0004-0003-0002-000000000000', 'c1040000-0000-0000-0000-000000000003',
  'Writing PRDs Engineers Love',
  'How to frame requirements in a way that reduces rework, clarifies scope, and makes engineers'' jobs easier. Covers how to write acceptance criteria and edge cases that eliminate ambiguity.',
  'Frame specs so engineers can build without follow-ups.', 'video', 'YouTube', NULL, 2),

('f1000000-0004-0003-0003-000000000000', 'c1040000-0000-0000-0000-000000000003',
  'My Favourite PRD Template',
  'A battle-tested PRD template from Lenny Rachitsky with explanation of why each section matters, what good looks like, and common mistakes PMs make when writing requirements.',
  'A PRD template you can use immediately.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('f1000000-0004-0003-0004-000000000000', 'c1040000-0000-0000-0000-000000000003',
  'How to Write a Good PRD',
  'A clear guide to writing PRDs that create alignment rather than ambiguity across design, engineering, and data. Covers how to scope, structure, and get feedback on requirements docs.',
  'PRDs that align design, eng, and data teams.', 'reading', 'Medium', 'Carlin Yuen', 4),

('f1000000-0004-0003-0005-000000000000', 'c1040000-0000-0000-0000-000000000003',
  'Write a Feature PRD',
  'Write a PRD for one of: a basic notification settings page, a search filter UI, or an onboarding checklist. Must include: problem statement, user story, acceptance criteria, edge cases, and one success metric. Target 300–400 words.',
  'Write a real PRD from scratch.', 'task', NULL, NULL, 5);

-- ════════════════════════════════════════════════════════════════════════════
-- MODULE 4: "Prioritisation — How PMs Decide What to Build Next"
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO lessons (id, module_id, title, content, description, lesson_type, source, author, order_index) VALUES

-- GROWTH PM
('f1000000-0001-0004-0001-000000000000', 'c1010000-0000-0000-0000-000000000004',
  'RICE Prioritisation Framework Explained',
  'A clear explainer of the RICE scoring model (Reach, Impact, Confidence, Effort) and how to apply it consistently across a product backlog to make defensible prioritisation decisions.',
  'The RICE framework, explained by Intercom.', 'video', 'YouTube (Intercom)', NULL, 1),

('f1000000-0001-0004-0002-000000000000', 'c1010000-0000-0000-0000-000000000004',
  'How Product Teams Prioritise',
  'Real examples of how experienced PMs make and defend prioritisation decisions with cross-functional teams — including how to handle pushback from stakeholders and engineers.',
  'How senior PMs defend their roadmap choices.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0001-0004-0003-000000000000', 'c1010000-0000-0000-0000-000000000004',
  'RICE: Simple Prioritisation for Product Managers',
  'The original RICE framework article from Intercom — explains the model, each component, how to score consistently, and how to avoid the most common mistakes teams make when applying it.',
  'The original RICE article from the team that invented it.', 'reading', 'Intercom Blog', NULL, 3),

('f1000000-0001-0004-0004-000000000000', 'c1010000-0000-0000-0000-000000000004',
  'How to Prioritise Your Roadmap',
  'A practical guide to roadmap prioritisation that goes beyond frameworks and addresses the political, strategic, and cross-functional trade-offs that PMs face in real organisations.',
  'Prioritisation in the real world, not just on paper.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('f1000000-0001-0004-0005-000000000000', 'c1010000-0000-0000-0000-000000000004',
  'RICE Scoring Exercise',
  'Build a RICE scoring table for 5 hypothetical product features for an app of your choice. Score each (Reach, Impact, Confidence, Effort), rank them, and write a 150-word rationale for your top 2 — explicitly addressing one trade-off you made.',
  'Score and defend a 5-item backlog using RICE.', 'task', NULL, NULL, 5),

-- TECHNICAL PM
('f1000000-0002-0004-0001-000000000000', 'c1020000-0000-0000-0000-000000000004',
  'RICE Prioritisation Framework Explained',
  'A clear explainer of the RICE scoring model (Reach, Impact, Confidence, Effort) and how to apply it consistently across a product backlog to make defensible prioritisation decisions.',
  'The RICE framework, explained by Intercom.', 'video', 'YouTube (Intercom)', NULL, 1),

('f1000000-0002-0004-0002-000000000000', 'c1020000-0000-0000-0000-000000000004',
  'How Product Teams Prioritise',
  'Real examples of how experienced PMs make and defend prioritisation decisions with cross-functional teams — including how to handle pushback from stakeholders and engineers.',
  'How senior PMs defend their roadmap choices.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0002-0004-0003-000000000000', 'c1020000-0000-0000-0000-000000000004',
  'RICE: Simple Prioritisation for Product Managers',
  'The original RICE framework article from Intercom — explains the model, each component, how to score consistently, and how to avoid the most common mistakes teams make when applying it.',
  'The original RICE article from the team that invented it.', 'reading', 'Intercom Blog', NULL, 3),

('f1000000-0002-0004-0004-000000000000', 'c1020000-0000-0000-0000-000000000004',
  'How to Prioritise Your Roadmap',
  'A practical guide to roadmap prioritisation that goes beyond frameworks and addresses the political, strategic, and cross-functional trade-offs that PMs face in real organisations.',
  'Prioritisation in the real world, not just on paper.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('f1000000-0002-0004-0005-000000000000', 'c1020000-0000-0000-0000-000000000004',
  'RICE Scoring Exercise',
  'Build a RICE scoring table for 5 hypothetical product features for an app of your choice. Score each (Reach, Impact, Confidence, Effort), rank them, and write a 150-word rationale for your top 2 — explicitly addressing one trade-off you made.',
  'Score and defend a 5-item backlog using RICE.', 'task', NULL, NULL, 5),

-- CONSUMER PM
('f1000000-0003-0004-0001-000000000000', 'c1030000-0000-0000-0000-000000000004',
  'RICE Prioritisation Framework Explained',
  'A clear explainer of the RICE scoring model (Reach, Impact, Confidence, Effort) and how to apply it consistently across a product backlog to make defensible prioritisation decisions.',
  'The RICE framework, explained by Intercom.', 'video', 'YouTube (Intercom)', NULL, 1),

('f1000000-0003-0004-0002-000000000000', 'c1030000-0000-0000-0000-000000000004',
  'How Product Teams Prioritise',
  'Real examples of how experienced PMs make and defend prioritisation decisions with cross-functional teams — including how to handle pushback from stakeholders and engineers.',
  'How senior PMs defend their roadmap choices.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0003-0004-0003-000000000000', 'c1030000-0000-0000-0000-000000000004',
  'RICE: Simple Prioritisation for Product Managers',
  'The original RICE framework article from Intercom — explains the model, each component, how to score consistently, and how to avoid the most common mistakes teams make when applying it.',
  'The original RICE article from the team that invented it.', 'reading', 'Intercom Blog', NULL, 3),

('f1000000-0003-0004-0004-000000000000', 'c1030000-0000-0000-0000-000000000004',
  'How to Prioritise Your Roadmap',
  'A practical guide to roadmap prioritisation that goes beyond frameworks and addresses the political, strategic, and cross-functional trade-offs that PMs face in real organisations.',
  'Prioritisation in the real world, not just on paper.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('f1000000-0003-0004-0005-000000000000', 'c1030000-0000-0000-0000-000000000004',
  'RICE Scoring Exercise',
  'Build a RICE scoring table for 5 hypothetical product features for an app of your choice. Score each (Reach, Impact, Confidence, Effort), rank them, and write a 150-word rationale for your top 2 — explicitly addressing one trade-off you made.',
  'Score and defend a 5-item backlog using RICE.', 'task', NULL, NULL, 5),

-- AI / DATA PM
('f1000000-0004-0004-0001-000000000000', 'c1040000-0000-0000-0000-000000000004',
  'RICE Prioritisation Framework Explained',
  'A clear explainer of the RICE scoring model (Reach, Impact, Confidence, Effort) and how to apply it consistently across a product backlog to make defensible prioritisation decisions.',
  'The RICE framework, explained by Intercom.', 'video', 'YouTube (Intercom)', NULL, 1),

('f1000000-0004-0004-0002-000000000000', 'c1040000-0000-0000-0000-000000000004',
  'How Product Teams Prioritise',
  'Real examples of how experienced PMs make and defend prioritisation decisions with cross-functional teams — including how to handle pushback from stakeholders and engineers.',
  'How senior PMs defend their roadmap choices.', 'video', 'YouTube', 'Product School', 2),

('f1000000-0004-0004-0003-000000000000', 'c1040000-0000-0000-0000-000000000004',
  'RICE: Simple Prioritisation for Product Managers',
  'The original RICE framework article from Intercom — explains the model, each component, how to score consistently, and how to avoid the most common mistakes teams make when applying it.',
  'The original RICE article from the team that invented it.', 'reading', 'Intercom Blog', NULL, 3),

('f1000000-0004-0004-0004-000000000000', 'c1040000-0000-0000-0000-000000000004',
  'How to Prioritise Your Roadmap',
  'A practical guide to roadmap prioritisation that goes beyond frameworks and addresses the political, strategic, and cross-functional trade-offs that PMs face in real organisations.',
  'Prioritisation in the real world, not just on paper.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('f1000000-0004-0004-0005-000000000000', 'c1040000-0000-0000-0000-000000000004',
  'RICE Scoring Exercise',
  'Build a RICE scoring table for 5 hypothetical product features for an app of your choice. Score each (Reach, Impact, Confidence, Effort), rank them, and write a 150-word rationale for your top 2 — explicitly addressing one trade-off you made.',
  'Score and defend a 5-item backlog using RICE.', 'task', NULL, NULL, 5);
