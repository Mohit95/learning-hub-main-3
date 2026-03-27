-- ============================================================================
-- 00005_seed_curriculum.sql
-- Seeds: pm_archetypes, programs, modules, lessons
-- Source: LearningHub PM Roadmap doc (4 paths × 4 phases × 8 modules)
-- Safe to re-run — uses ON CONFLICT DO NOTHING
-- ============================================================================

-- ── 1. PM ARCHETYPES ─────────────────────────────────────────────────────────

INSERT INTO pm_archetypes (id, name, description) VALUES
  ('a1000000-0000-0000-0000-000000000001', 'Growth PM',    'Focused on acquisition, retention, experimentation and growth loops.'),
  ('a1000000-0000-0000-0000-000000000002', 'Technical PM', 'Bridges product and engineering — APIs, architecture, reliability, ML.'),
  ('a1000000-0000-0000-0000-000000000003', 'Consumer PM',  'Builds habit-forming, delightful consumer products with strong UX instincts.'),
  ('a1000000-0000-0000-0000-000000000004', 'AI / Data PM', 'Specialises in AI/ML products, data strategy, and probabilistic systems.')
ON CONFLICT (id) DO NOTHING;

-- ── 2. PROGRAMS (one per archetype) ──────────────────────────────────────────

INSERT INTO programs (id, title, description, archetype_name, total_phases) VALUES
  ('b1000000-0000-0000-0000-000000000001', 'Growth PM Roadmap',    'Four-phase learning path for aspiring Growth PMs — from growth fundamentals to full case practice.', 'Growth PM',    4),
  ('b1000000-0000-0000-0000-000000000002', 'Technical PM Roadmap', 'Four-phase learning path for aspiring Technical PMs — from engineering fundamentals to platform cases.', 'Technical PM', 4),
  ('b1000000-0000-0000-0000-000000000003', 'Consumer PM Roadmap',  'Four-phase learning path for aspiring Consumer PMs — from psychology to social mechanics and case practice.', 'Consumer PM',  4),
  ('b1000000-0000-0000-0000-000000000004', 'AI / Data PM Roadmap', 'Four-phase learning path for aspiring AI/Data PMs — from ML literacy to LLM products and ethics.', 'AI / Data PM', 4)
ON CONFLICT (id) DO NOTHING;

-- ── 3. MODULES ────────────────────────────────────────────────────────────────
-- 8 modules per program (2 per phase). order_index = global position within program.

INSERT INTO modules (id, program_id, title, description, phase_number, order_index, learning_objective) VALUES

-- ── GROWTH PM ──────────────────────────────────────────────────────────────
('c1010000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
  'Growth Fundamentals — Loops, Funnels & the Growth PM Role',
  'Understand how growth compounds and what makes a Growth PM distinct from a Core PM.',
  1, 1,
  'Distinguish between growth loops and funnels, and articulate how a Growth PM''s scope differs from a Core PM''s.'),

('c1010000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
  'North Star Metrics & the Metrics Hierarchy',
  'Build the habit of defining success from the top down — NSM first, input metrics second.',
  1, 2,
  'Define a North Star Metric for a given product and build a two-level input metrics tree beneath it.'),

('c1010000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001',
  'Writing Growth Experiment PRDs',
  'Learn to write specs that growth engineers can actually build and measure from.',
  2, 3,
  'Write a PRD for a growth experiment that includes a falsifiable hypothesis, success metrics, guardrail metrics, and rollout plan.'),

('c1010000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
  'Prioritisation for Growth Teams',
  'Apply structured scoring frameworks to rank competing experiments with clear rationale.',
  2, 4,
  'Apply RICE scoring to a backlog of growth experiments and defend the output with a written rationale.'),

('c1010000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
  'Acquisition — Channels, CAC, and Viral Mechanics',
  'Evaluate acquisition channels by unit economics and scalability, not gut feel.',
  3, 5,
  'Evaluate the scalability and unit economics of three acquisition channels for a given product and recommend which to double down on.'),

('c1010000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
  'Activation & Retention — Aha Moments and Habit Loops',
  'Redesign onboarding around time-to-value and understand what makes users stick.',
  3, 6,
  'Redesign one stage of an onboarding flow to accelerate time-to-value, and write a testable hypothesis for the change.'),

('c1010000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001',
  'Diagnosing a Metric Drop',
  'Build a repeatable framework for investigating metric drops under interview pressure.',
  4, 7,
  'Apply a structured investigation framework to a metric drop scenario and arrive at a prioritised set of root cause hypotheses.'),

('c1010000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
  'Designing a Growth Intervention — Full Case',
  'Construct a prioritised experiment roadmap from a stalled growth metric.',
  4, 8,
  'Given a stalled growth metric, construct a prioritised 3-experiment roadmap with expected impact and clear reasoning.'),

-- ── TECHNICAL PM ───────────────────────────────────────────────────────────
('c1020000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
  'How Engineers Think — Systems, Trade-offs & the SDLC',
  'Build the vocabulary and empathy to participate credibly in engineering conversations.',
  1, 1,
  'Explain the software development lifecycle from a technical perspective and identify where a Technical PM adds unique value at each stage.'),

('c1020000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
  'APIs, Architecture & System Design Fundamentals for PMs',
  'Read API specs and map product features to the backend changes they require.',
  1, 2,
  'Read an API specification and explain how a proposed product feature maps to backend architecture changes required.'),

('c1020000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
  'Writing Technical PRDs — Precision Over Completeness',
  'Write specs that reduce rework by making ambiguity explicit rather than hidden.',
  2, 3,
  'Write a technical PRD for an infrastructure or integration feature that engineers can build from without follow-up questions.'),

('c1020000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
  'Technical Debt, Build vs. Buy & Platform Decisions',
  'Frame technical trade-offs in business language and make defensible platform decisions.',
  2, 4,
  'Construct a structured build vs. buy recommendation for a given product capability, incorporating total cost of ownership and strategic fit.'),

('c1020000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
  'Infrastructure, Reliability & Platform Product Management',
  'Define SLOs and understand how reliability requirements translate into sprint priorities.',
  3, 5,
  'Define SLOs and SLAs for a platform product and explain how they translate into prioritisation decisions for the engineering team.'),

('c1020000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
  'Data Pipelines, ML Integration & Technical Feasibility',
  'Scope ML features accurately by understanding data requirements and failure modes.',
  3, 6,
  'Scope the technical feasibility of a machine learning feature and identify the data requirements, latency constraints, and failure modes.'),

('c1020000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000002',
  'Technical Case — Diagnosing a System Failure',
  'Communicate root cause and resolution to both engineering and executive audiences.',
  4, 7,
  'Apply a structured technical investigation framework to a production incident and communicate root cause and resolution to both engineering and executive audiences.'),

('c1020000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000002',
  'Technical Case — Scoping a Platform Feature',
  'Break down vague platform requests into phased, technically feasible specifications.',
  4, 8,
  'Break down a vague platform feature request into a scoped, technically feasible specification with clear phasing.'),

-- ── CONSUMER PM ────────────────────────────────────────────────────────────
('c1030000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
  'Consumer Psychology — How Users Actually Make Decisions',
  'Apply behavioural economics to explain why users adopt, stick with, or abandon products.',
  1, 1,
  'Apply at least two behavioral psychology models to explain why users adopt, stick with, or abandon a consumer product.'),

('c1030000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
  'User Research Foundations for Consumer PMs',
  'Design interviews that surface real behaviour rather than polite validation.',
  1, 2,
  'Design a 5-question user interview guide that uncovers unmet needs rather than confirming existing assumptions.'),

('c1030000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
  'Consumer PRDs — Designing for Delight, Not Just Function',
  'Write specs that inspire designers and engineers by centering user emotion.',
  2, 3,
  'Write a consumer-facing PRD that centres user emotion and end-to-end experience, not just feature requirements.'),

('c1030000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
  'Taste, Design Intuition & Working with Designers',
  'Give design feedback that improves the product without overriding the designer''s craft.',
  2, 4,
  'Critique a consumer product''s design using structured UX principles and communicate feedback that improves the design without overriding the designer''s craft.'),

('c1030000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
  'Personalization, Content & Feed Algorithms',
  'Define product requirements for a personalisation system including ranking logic and user controls.',
  3, 5,
  'Define the product requirements for a basic personalization system, including data inputs, ranking logic, and user control mechanisms.'),

('c1030000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
  'Social Mechanics, Virality & Community Design',
  'Design social features that generate network effects at different user density thresholds.',
  3, 6,
  'Design a social feature from scratch and map how it generates network effects at different user density thresholds.'),

('c1030000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000003',
  'Consumer Case — Improving Engagement for a Struggling Feature',
  'Diagnose a consumer engagement problem and propose a redesign backed by user insight.',
  4, 7,
  'Diagnose a consumer engagement problem and propose a redesign backed by user insight and behavioral theory.'),

('c1030000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000003',
  'Consumer Case — Designing a New Feature from Scratch',
  'Design a new consumer feature end-to-end from user need to success metrics.',
  4, 8,
  'Given a user problem and a product context, design a new consumer feature end-to-end — from user need to success metrics.'),

-- ── AI / DATA PM ───────────────────────────────────────────────────────────
('c1040000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
  'How AI and ML Actually Work — A PM''s Literacy Guide',
  'Build conceptual fluency in ML pipelines so you can have credible conversations with data scientists.',
  1, 1,
  'Explain the end-to-end pipeline of a machine learning model — from training data to user-facing output — and identify where product decisions affect model performance.'),

('c1040000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
  'The AI PM''s Unique Scope — Probabilistic Products and Responsible AI',
  'Understand what makes AI PM work structurally different from traditional product management.',
  1, 2,
  'Articulate the core differences between building deterministic software features and probabilistic AI features, and explain what those differences mean for specs, expectations, and measurement.'),

('c1040000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
  'Writing Specs for AI Features — Data, Models & Evaluation Criteria',
  'Write AI feature specs that include training data requirements and failure mode handling.',
  2, 3,
  'Write a product spec for an AI feature that includes training data requirements, model evaluation criteria, latency constraints, and failure mode handling.'),

('c1040000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
  'Data Strategy & Instrumentation as a Product Decision',
  'Design instrumentation plans that capture signals needed to train and improve AI models.',
  2, 4,
  'Design a data instrumentation plan for a new product feature that captures the signals needed to train, evaluate, and improve an AI model over time.'),

('c1040000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
  'LLM Products — Prompting, RAG, Evaluation & Hallucination',
  'Evaluate LLM-powered features and propose mitigations for hallucination and reliability issues.',
  3, 5,
  'Evaluate the quality of an LLM-powered product feature using a structured evaluation framework and propose specific improvements to reduce hallucination and improve output reliability.'),

('c1040000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
  'AI Product Ethics, Bias & Trust Mechanisms',
  'Identify bias risks in AI products and design product-level mitigations.',
  3, 6,
  'Identify at least two bias or fairness risks in a given AI product and propose product-level mitigations for each.'),

('c1040000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000004',
  'AI Case — Evaluating Whether to Build an AI Feature',
  'Apply a structured decision framework to determine whether a proposed AI feature should be built.',
  4, 7,
  'Apply a structured decision framework to determine whether a proposed AI feature should be built, deferred, or replaced with a simpler solution.'),

('c1040000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000004',
  'AI Case — Improving a Broken AI Feature',
  'Diagnose AI feature underperformance and distinguish model problems from product problems.',
  4, 8,
  'Diagnose why an AI feature is underperforming and construct a structured improvement plan distinguishing model problems from product problems.')

ON CONFLICT (id) DO NOTHING;


-- ── 4. LESSONS ────────────────────────────────────────────────────────────────
-- Each module has: topics (video), readings (reading), and 1 task (task)
-- content = the description shown to the learner
-- source/author = attribution for readings

INSERT INTO lessons (id, module_id, title, content, description, lesson_type, source, author, order_index) VALUES

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 1: Growth Fundamentals
-- ════════════════════════════════════════════════════════════════════════════
('d1010101-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000001',
  'Growth Loops vs. Funnels',
  'Reframes growth as self-reinforcing compounding systems rather than one-time linear pipelines. Teaches you to identify whether a product''s engine truly loops or simply flows — a distinction that changes how you prioritise and invest.',
  'Core concept: why loops compound and funnels don''t.', 'video', 'Reforge', NULL, 1),

('d1010101-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000001',
  'What Does a Growth PM Actually Do?',
  'Clarifies the distinct scope, ownership, and success metrics of a Growth PM role versus a Core PM role across different company stages. Prepares you to articulate your unique value-add in interviews and on teams.',
  'Understand the Growth PM role vs Core PM.', 'video', 'Lenny Rachitsky', NULL, 2),

('d1010101-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000001',
  'Growth Loops are the New Funnels',
  'Foundational vocabulary piece reframing growth as compounding loops — essential for any Growth PM interview.',
  'The foundational Reforge piece every Growth PM must read.', 'reading', 'Reforge Blog', 'Brian Balfour', 3),

('d1010101-0000-0000-0000-000000000004', 'c1010000-0000-0000-0000-000000000001',
  'What is a Growth PM?',
  'Covers how Growth PM roles are scoped across company stages and what hiring managers evaluate.',
  'Survey-based breakdown of the Growth PM role across 40+ companies.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('d1010101-0000-0000-0000-000000000005', 'c1010000-0000-0000-0000-000000000001',
  'Task: Map a Growth Loop',
  'Pick any consumer app you use weekly. Map its growth engine as a loop — draw the input, action, output, and compounding mechanism. Write 150 words explaining whether it is a true self-reinforcing loop or just a funnel relabelled.',
  'Apply the loop framework to a real product you use.', 'task', NULL, NULL, 5),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 2: North Star Metrics
-- ════════════════════════════════════════════════════════════════════════════
('d1010201-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000002',
  'How to Choose Your North Star Metric',
  'Walks through the criteria for a strong North Star Metric — leading vs. lagging, breadth vs. depth, and common pitfalls like using revenue as an NSM. Gives you a repeatable decision framework to apply to any product.',
  'A decision framework for picking the right NSM.', 'video', 'Amplitude', NULL, 1),

('d1010201-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000002',
  'Input Metrics vs. Output Metrics',
  'Explains why Growth PMs obsess over input metrics rather than output metrics, and how to build a structured hierarchy that connects team-level actions to company-level outcomes.',
  'Why input metrics matter more than output metrics.', 'video', 'Reforge', 'Brian Balfour', 2),

('d1010201-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000002',
  'North Star Playbook',
  'The most complete public framework for defining and operationalising NSMs, with worked examples across B2C, B2B, and marketplace products.',
  'Amplitude''s complete guide to North Star Metrics.', 'reading', 'Amplitude', NULL, 3),

('d1010201-0000-0000-0000-000000000004', 'c1010000-0000-0000-0000-000000000002',
  'Choosing Your North Star Metric',
  'Survey-based piece mapping NSM choices across 40+ companies — gives Growth PMs concrete benchmarks.',
  'Real NSM choices from 40+ companies mapped.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('d1010201-0000-0000-0000-000000000005', 'c1010000-0000-0000-0000-000000000002',
  'Task: Build a Metrics Tree',
  'Choose three products from different categories (a marketplace, a SaaS tool, a consumer social app). Define a North Star Metric for each. For one, build a full metrics tree — 3 input metrics per level, 2 levels deep. Deliver as a structured outline.',
  'Build a real metrics tree for 3 different product types.', 'task', NULL, NULL, 5),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 3: Writing Growth Experiment PRDs
-- ════════════════════════════════════════════════════════════════════════════
('d1010301-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000003',
  'How to Write a PRD',
  'Covers the structure and content of a strong product requirements document, with specific guidance on framing around outcomes rather than features. Shows what separates a PRD that enables good engineering decisions from one that creates confusion.',
  'The structure of a strong PRD — outcomes over features.', 'video', 'Lenny Rachitsky', NULL, 1),

('d1010301-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000003',
  'How to Write a Good PRD',
  'Covers what separates strong PRDs from weak ones, with a growth experiment template variant.',
  'What separates strong PRDs from weak ones.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 2),

('d1010301-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000003',
  'Task: Write a Growth Experiment PRD',
  'Write a growth experiment PRD for one of: a referral program, an onboarding flow change, or a paywall placement test. Must include problem statement, hypothesis, success metric, guardrail metric, and rollout plan. Target 400–500 words.',
  'Write a real experiment PRD end-to-end.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 4: Prioritisation for Growth Teams
-- ════════════════════════════════════════════════════════════════════════════
('d1010401-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000004',
  'RICE Prioritisation Framework Explained',
  'Breaks down the RICE framework — Reach, Impact, Confidence, Effort — with worked examples showing how to score and rank competing initiatives.',
  'RICE scoring from scratch with worked examples.', 'video', 'Product School', NULL, 1),

('d1010401-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000004',
  'How Growth Teams Prioritise',
  'Explains the organisational and strategic dynamics that shape growth team prioritisation beyond simple scoring models.',
  'The political and strategic dynamics behind prioritisation.', 'video', NULL, 'Andrew Chen', 2),

('d1010401-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000004',
  'RICE: Simple Prioritisation for Product Managers',
  'The original RICE framework article — mechanics and reasoning behind each variable.',
  'The original RICE article. Essential reading.', 'reading', 'Intercom Blog', NULL, 3),

('d1010401-0000-0000-0000-000000000004', 'c1010000-0000-0000-0000-000000000004',
  'Task: Build a RICE Matrix',
  'Build a RICE prioritisation matrix for a fictional growth team''s backlog of 6 experiments. Score each, rank them, and write a 150-word justification for your top 3 — explicitly addressing the trade-offs and what you deprioritised.',
  'Score a 6-item backlog and defend your ranking.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 5: Acquisition
-- ════════════════════════════════════════════════════════════════════════════
('d1010501-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000005',
  'Growth Channels Masterclass',
  'Provides a structured framework for evaluating acquisition channels by product type, market stage, and unit economics. Teaches you to identify channel-product fit.',
  'How to evaluate acquisition channels by unit economics.', 'video', 'Reforge', NULL, 1),

('d1010501-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000005',
  'The Cold Start Problem',
  'Covers network effects and acquisition mechanics in marketplace and social products — directly relevant to channel-product fit.',
  'Andrew Chen on network effects and acquisition in marketplaces.', 'reading', 'a16z Blog', 'Andrew Chen', 2),

('d1010501-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000005',
  'Task: Audit Three Acquisition Channels',
  'For a product of your choice, audit three acquisition channels. For each: estimate CAC (rough order of magnitude), estimate payback period, and score scalability 1–5 with a one-line rationale. Deliver as a table with a 100-word summary recommendation.',
  'Audit 3 channels with CAC + payback period estimates.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 6: Activation & Retention
-- ════════════════════════════════════════════════════════════════════════════
('d1010601-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000006',
  'Activation & the Aha Moment',
  'Defines the ''Aha moment'' as the specific action most correlated with long-term retention and shows how to find it using cohort analysis. Teaches you to redesign onboarding around accelerating time-to-value.',
  'Find the Aha moment and redesign onboarding around it.', 'video', 'Reforge', NULL, 1),

('d1010601-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000006',
  'How Duolingo Reignited User Growth',
  'Case study on streak mechanics and notification systems — highly specific and applicable tactical examples.',
  'How Duolingo used streaks and notifications to reverse a growth stall.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 2),

('d1010601-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000006',
  'Task: Redesign an Onboarding Flow',
  'Choose a product you recently signed up for. Map the onboarding flow step by step. Identify the moment you personally felt value. Propose 2 changes to reduce time to that moment, write a hypothesis for each, and specify how you''d measure success.',
  'Map and redesign a real onboarding flow you''ve experienced.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 7: Diagnosing a Metric Drop
-- ════════════════════════════════════════════════════════════════════════════
('d1010701-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000007',
  'How to Answer Metrics Questions in PM Interviews',
  'Teaches a repeatable step-by-step framework for investigating metric drops in live interview settings — covering how to segment, hypothesise, and communicate before you have full data.',
  'A repeatable framework for metric drop investigation.', 'video', 'Exponent', NULL, 1),

('d1010701-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000007',
  'How to Answer a Metrics Question',
  'Step-by-step framework for metric investigation cases — maps directly to live interview scenarios.',
  'The Exponent step-by-step guide to metrics questions.', 'reading', 'Exponent Blog', NULL, 2),

('d1010701-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000007',
  'A/B Testing Pitfalls',
  'Covers experiment validity threats that cause false metric signals — builds rigour in how Growth PMs interpret drops.',
  'Why A/B test results can mislead and how to prevent it.', 'reading', 'Microsoft Research', 'Ronny Kohavi', 3),

('d1010701-0000-0000-0000-000000000004', 'c1010000-0000-0000-0000-000000000007',
  'Task: Diagnose a Metric Drop Case',
  'Solve this case in writing: ''Your app''s Day-7 retention dropped 18% week-over-week. Walk me through your investigation.'' Use a branching hypothesis tree structure. Deliver a one-page written response with at least 3 hypothesis branches, each with a supporting signal you''d look for.',
  'Write a full metric drop investigation using the hypothesis tree method.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- GROWTH PM — MODULE 8: Full Growth Case
-- ════════════════════════════════════════════════════════════════════════════
('d1010801-0000-0000-0000-000000000001', 'c1010000-0000-0000-0000-000000000008',
  'The Four Fits Framework',
  'Introduces the interconnected system of product-market fit, product-channel fit, channel-model fit, and model-market fit. Teaches you to diagnose whether a growth stall is a structural or tactical problem.',
  'Diagnose growth stalls using the Four Fits framework.', 'video', 'Reforge', 'Brian Balfour', 1),

('d1010801-0000-0000-0000-000000000002', 'c1010000-0000-0000-0000-000000000008',
  'The Four Fits Framework — Article',
  'Explains product-market, product-channel, channel-model, and model-market fit as interconnected systems — helps diagnose structural vs. tactical stalls.',
  'The definitive written breakdown of the Four Fits.', 'reading', 'Reforge Blog', 'Brian Balfour', 2),

('d1010801-0000-0000-0000-000000000003', 'c1010000-0000-0000-0000-000000000008',
  'Task: Design a Growth Intervention',
  'Solve this case in writing: ''A ride-sharing app''s weekly active riders have been flat for 3 months despite strong new user sign-up growth. What''s going on and what would you do?'' Deliver a 400-word structured response: diagnosis, top 3 hypotheses, and a prioritised experiment roadmap with one success metric per experiment.',
  'Write a full growth intervention for a stalled ride-sharing product.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 1: How Engineers Think
-- ════════════════════════════════════════════════════════════════════════════
('d1020101-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000001',
  'Software Development Lifecycle Explained',
  'Walks through the full SDLC — from requirements to design, development, testing, deployment, and monitoring — with clear explanations of what happens at each stage and who owns what.',
  'Understand every stage of the SDLC and where PMs add value.', 'video', 'TechWorld with Nana', NULL, 1),

('d1020101-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000001',
  'How to Work with Engineers as a PM',
  'Explains what engineers actually want and need from a PM counterpart — clarity on outcomes, respect for technical constraints, and well-scoped problems rather than pre-specified solutions.',
  'What engineers actually want from their PM.', 'video', NULL, 'Shreyas Doshi', 2),

('d1020101-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000001',
  'The Engineer''s Guide to Working with PMs',
  'Written from the engineering side — gives Technical PMs insight into what engineers actually want from their PM counterpart.',
  'Read this from the engineer''s perspective.', 'reading', 'First Round Review', NULL, 3),

('d1020101-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000001',
  'How to Be a Technical Product Manager',
  'Covers what ''technical'' actually means in PM hiring and how much engineering depth is genuinely needed.',
  'What ''technical'' really means in PM hiring.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 4),

('d1020101-0000-0000-0000-000000000005', 'c1020000-0000-0000-0000-000000000001',
  'Task: Shadow an Engineer',
  'Interview or shadow an engineer for 30 minutes. Ask them to walk you through the last technical decision they made and why. Write a 200-word summary of the trade-off they navigated — framed using the vocabulary of constraints, alternatives considered, and the deciding factor.',
  'Get a real engineer''s perspective on a recent technical decision.', 'task', NULL, NULL, 5),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 2: APIs & Architecture
-- ════════════════════════════════════════════════════════════════════════════
('d1020201-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000002',
  'APIs Explained for Non-Developers',
  'Demystifies what APIs are, how requests and responses work, and why APIs are the connective tissue of modern software products.',
  'APIs explained simply — no coding required.', 'video', 'MuleSoft', NULL, 1),

('d1020201-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000002',
  'System Design Basics for Product Managers',
  'Covers the core system design concepts — databases, caching, load balancing, queues, and microservices — at the level a Technical PM needs to have credible conversations with engineers.',
  'Core system design concepts every Technical PM needs.', 'video', 'Exponent', NULL, 2),

('d1020201-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000002',
  'System Design Primer for PMs',
  'Covers core concepts at the level a Technical PM needs to have credible conversations with engineers.',
  'The PM-focused system design reference.', 'reading', NULL, 'Martin Donnen', 3),

('d1020201-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000002',
  'REST vs. GraphQL: What PMs Need to Know',
  'Practical explanation of API paradigms with product implications — directly relevant to Technical PMs scoping integrations.',
  'REST vs GraphQL — what it means for product decisions.', 'reading', 'AWS', NULL, 4),

('d1020201-0000-0000-0000-000000000005', 'c1020000-0000-0000-0000-000000000002',
  'Task: Write a Technical Feature Spec',
  'Pick any product feature you''ve used recently (e.g. Instagram''s story expiry, Uber''s surge pricing display, Notion''s real-time sync). Write a 1-page technical spec describing: what the feature does for the user, what API calls are likely involved, the main backend constraint, and one technical trade-off the engineering team probably debated.',
  'Reverse-engineer a real product feature into a technical spec.', 'task', NULL, NULL, 5),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 3: Writing Technical PRDs
-- ════════════════════════════════════════════════════════════════════════════
('d1020301-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000003',
  'How to Write Technical Specs',
  'Explains the structure and intent of a strong technical PRD — what to specify, what to leave to engineering judgment, and how to make ambiguity explicit rather than hidden.',
  'Writing specs that reduce rework, not create it.', 'video', 'Lenny Rachitsky', NULL, 1),

('d1020301-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000003',
  'Writing PRDs Engineers Actually Love',
  'Shows the specific elements that make a PRD useful to engineers — clear problem statements, testable acceptance criteria, edge case documentation, and dependency callouts.',
  'The specific elements engineers actually need in a PRD.', 'video', 'Pragmatic Institute', NULL, 2),

('d1020301-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000003',
  'A Practical Guide to Writing Technical Specs',
  'Covers the structure of a technical spec — what to include, what to leave to engineering, and how to make ambiguity explicit.',
  'The go-to reference for writing technical specs.', 'reading', NULL, 'Carlin Yuen', 3),

('d1020301-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000003',
  'Task: Write a Technical PRD',
  'Write a technical PRD for one of: a webhook notification system, a third-party OAuth integration, or a rate-limiting feature. Must include: problem statement, user story, API contract (inputs/outputs), edge cases, and success criteria. Target 400–500 words.',
  'Write a full technical PRD for a real infrastructure feature.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 4: Technical Debt & Build vs Buy
-- ════════════════════════════════════════════════════════════════════════════
('d1020401-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000004',
  'Technical Debt Explained for PMs',
  'Explains what technical debt is, how it accumulates, and how Technical PMs should frame, prioritise, and communicate it to non-technical stakeholders.',
  'How to talk about technical debt with business stakeholders.', 'video', 'Product School', NULL, 1),

('d1020401-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000004',
  'Build vs. Partner — Decision Framework',
  'A structured framework for when to build in-house, when to buy a vendor solution, and when to partner. Covers strategic differentiation, maintenance cost, and speed-to-market trade-offs.',
  'A structured framework for the build vs buy vs partner decision.', 'video', 'Product School', NULL, 2),

('d1020401-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000004',
  'Technical Debt in the AI Era',
  'Explains how Technical PMs should frame, prioritise, and communicate technical debt to non-technical stakeholders.',
  'Technical debt framing for the modern AI era.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('d1020401-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000004',
  'Build vs. Buy Framework',
  'Decision framework covering strategic differentiation, maintenance cost, and speed-to-market trade-offs.',
  'A practical build vs buy decision framework.', 'reading', NULL, 'Akash Gupta', 4),

('d1020401-0000-0000-0000-000000000005', 'c1020000-0000-0000-0000-000000000004',
  'Task: Write a Build vs. Buy Brief',
  'Choose a product capability (e.g. search, payments, notifications, identity/auth). Write a 300-word build vs. buy recommendation brief. Cover: what you''d gain and lose by building, the best vendor alternative, TCO considerations, and your final recommendation with reasoning.',
  'Write a real build vs buy recommendation for a product capability.', 'task', NULL, NULL, 5),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 5: Infrastructure & Reliability
-- ════════════════════════════════════════════════════════════════════════════
('d1020501-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000005',
  'SLOs, SLAs, SLIs Explained',
  'Defines the three reliability measurement concepts — Service Level Indicators, Objectives, and Agreements — and explains how they relate to each other in practice.',
  'SLOs, SLAs and SLIs demystified for PMs.', 'video', 'Google Cloud', NULL, 1),

('d1020501-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000005',
  'What is a Platform PM?',
  'Covers the unique challenges of platform PM work — internal customers, reliability requirements, and developer experience as a product metric.',
  'What makes platform PM work different from feature PM work.', 'reading', 'ProductPlan', NULL, 2),

('d1020501-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000005',
  'Site Reliability Engineering — SLOs (Chapter 2)',
  'The definitive reference for SLOs and error budgets — gives Technical PMs the vocabulary to participate in reliability conversations credibly.',
  'Google''s definitive guide to SLOs and error budgets.', 'reading', 'Google SRE Book', 'Google', 3),

('d1020501-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000005',
  'Task: Define SLOs for a Platform Product',
  'Pick a platform or infrastructure product you depend on (e.g. Stripe, Twilio, AWS S3, Firebase). Write a 1-page product brief defining: 3 SLOs you would set if you were the PM, the error budget implication of each, and how a breach would change your team''s sprint priorities.',
  'Set real SLOs for a platform product you know well.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 6: Data Pipelines & ML Feasibility
-- ════════════════════════════════════════════════════════════════════════════
('d1020601-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000006',
  'How ML Models Are Built and Deployed',
  'Explains the end-to-end ML pipeline — data collection, feature engineering, training, evaluation, and deployment — at the level of detail a Technical PM needs to scope feasibility.',
  'The full ML pipeline explained at PM level.', 'video', 'Google Developers', NULL, 1),

('d1020601-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000006',
  'ML for PMs — What You Actually Need to Know',
  'Distils the ML concepts that actually affect product decisions — model latency, training data volume, cold-start problems, and offline vs. online evaluation.',
  'Only the ML concepts that actually matter for product decisions.', 'video', 'Exponent', NULL, 2),

('d1020601-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000006',
  'ML for PMs',
  'Explains training data, model evaluation, and deployment in terms PMs can act on.',
  'ML concepts translated into PM-actionable language.', 'reading', NULL, 'Christine Young', 3),

('d1020601-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000006',
  'Task: Write an ML Feasibility Brief',
  'Choose any ML-powered feature in a product you use (recommendations, fraud detection, smart replies, content moderation). Write a technical feasibility brief covering: input data required, likely model type, key latency constraint, one failure mode the PM should design for, and how you''d measure model performance as a product metric.',
  'Assess the feasibility of a real ML feature you use daily.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 7: System Failure Case
-- ════════════════════════════════════════════════════════════════════════════
('d1020701-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000007',
  'Incident Management for PMs',
  'Explains the PM''s role in a production incident — what to own, what to delegate, and how to communicate status without obstructing the engineers working to resolve it.',
  'What a PM owns vs delegates during a production incident.', 'video', 'PagerDuty', NULL, 1),

('d1020701-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000007',
  'How PMs Should Handle Production Incidents',
  'Covers the PM''s role in incident response — what to own, what to delegate, and how to communicate without obstructing.',
  'The PM incident response playbook.', 'reading', 'Atlassian Incident Management Guide', NULL, 2),

('d1020701-0000-0000-0000-000000000003', 'c1020000-0000-0000-0000-000000000007',
  'Post-Mortems Without Blame',
  'The definitive guide to blameless post-mortems — gives Technical PMs the framework for turning outages into systemic improvements.',
  'How blameless post-mortems turn incidents into learning.', 'reading', 'Google SRE Book, Chapter 15', 'Google', 3),

('d1020701-0000-0000-0000-000000000004', 'c1020000-0000-0000-0000-000000000007',
  'Task: Diagnose a System Failure',
  'Solve this case in writing: ''Your payment API has a 12% error rate for users on mobile in one specific geography. Walk me through how you''d investigate and what you''d communicate to stakeholders at 1 hour, 4 hours, and 24 hours.'' Deliver a structured response covering investigation steps, likely hypotheses, and a stakeholder communication plan at each time horizon.',
  'Write a full incident response for a mobile payment API failure.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- TECHNICAL PM — MODULE 8: Scoping a Platform Feature
-- ════════════════════════════════════════════════════════════════════════════
('d1020801-0000-0000-0000-000000000001', 'c1020000-0000-0000-0000-000000000008',
  'How to Scope Technical Products',
  'Teaches how to move from a broad, ambiguous platform request to a scoped, phased specification — identifying what must be in MVP, what can wait, and what should be refused.',
  'Moving from ambiguous platform requests to scoped specs.', 'video', 'Product School', NULL, 1),

('d1020801-0000-0000-0000-000000000002', 'c1020000-0000-0000-0000-000000000008',
  'Task: Scope a Self-Serve Analytics Platform',
  'Solve this case in writing: ''Your internal data platform team is asked to build a self-serve analytics dashboard for non-technical business teams. Scope the MVP. What do you build first, what do you defer, and what do you refuse?'' Deliver a 400-word response with a phased scope (Phase 1 / Phase 2 / Out of scope) and the reasoning behind each decision.',
  'Write a phased scope for a self-serve analytics platform.', 'task', NULL, NULL, 2),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 1: Consumer Psychology
-- ════════════════════════════════════════════════════════════════════════════
('d1030101-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000001',
  'Consumer Behavior & Behavioral Economics for PMs',
  'Covers the core behavioral economics principles — loss aversion, status quo bias, social proof, and scarcity — and shows how they manifest in consumer product design decisions.',
  'Loss aversion, social proof, scarcity — applied to product.', 'video', 'Product School', NULL, 1),

('d1030101-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000001',
  'The Hook Model',
  'Walks through the four-stage Trigger-Action-Variable Reward-Investment loop that underlies habit-forming consumer products.',
  'The Trigger-Action-Reward-Investment loop that powers engagement.', 'video', NULL, 'Nir Eyal', 2),

('d1030101-0000-0000-0000-000000000003', 'c1030000-0000-0000-0000-000000000001',
  'Hooked: How to Build Habit-Forming Products',
  'Introduces the Hook Model — the foundational behavioral framework for consumer product design.',
  'Nir Eyal''s foundational Hook Model framework.', 'reading', 'NirAndFar', 'Nir Eyal', 3),

('d1030101-0000-0000-0000-000000000004', 'c1030000-0000-0000-0000-000000000001',
  'Task: Map a Product Through the Hook Model',
  'Choose a consumer app with a strong retention habit (Duolingo, BeReal, Spotify, etc.). Map its experience through the Hook Model — identify the external trigger, internal trigger, action, variable reward, and investment. Write 200 words on which element of the loop is most responsible for its retention.',
  'Deconstruct a habit-forming product using the Hook Model.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 2: User Research Foundations
-- ════════════════════════════════════════════════════════════════════════════
('d1030201-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000002',
  'How to Run User Interviews',
  'Teaches the specific techniques that separate useful user interviews from ones that produce confirmation bias — including how to probe past stated preferences to surface actual behavior.',
  'Surface real behavior, not polite validation.', 'video', NULL, 'Teresa Torres', 1),

('d1030201-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000002',
  'The Mom Test',
  'The essential guide to asking questions that surface real user behavior rather than polite validation — required reading for Consumer PMs.',
  'Required reading: stop getting lied to in user interviews.', 'reading', NULL, 'Rob Fitzpatrick', 2),

('d1030201-0000-0000-0000-000000000003', 'c1030000-0000-0000-0000-000000000002',
  'Task: Write and Run a User Interview',
  'Write a 5-question user interview guide for a consumer app of your choice — targeting a specific user segment and a specific pain point. For each question, write one line explaining what assumption you''re trying to invalidate. Then conduct the interview with one real user and write a 150-word synthesis of what you learned vs. what you expected.',
  'Write the guide, run the interview, synthesise what you learned.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 3: Consumer PRDs
-- ════════════════════════════════════════════════════════════════════════════
('d1030301-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000003',
  'Writing PRDs for Consumer Products',
  'Shows how consumer PRDs differ from enterprise PRDs in their emphasis on emotional experience, narrative clarity, and the quality of the end state — not just the mechanics of the feature.',
  'How consumer PRDs differ from enterprise PRDs.', 'video', 'Lenny Rachitsky', NULL, 1),

('d1030301-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000003',
  'Jobs To Be Done Framework',
  'Introduces the JTBD framework — the idea that users ''hire'' products to do a job in their lives — and shows how it changes what you build when you scope around user intent rather than product categories.',
  'Scope around user intent, not product categories.', 'video', NULL, 'Clayton Christensen', 2),

('d1030301-0000-0000-0000-000000000003', 'c1030000-0000-0000-0000-000000000003',
  'Task: Write a Consumer PRD with Emotional Experience',
  'Write a consumer PRD for one of: a social feature, a personalization system, or a content discovery experience. Beyond the standard spec, include a section titled ''Emotional Experience'' — describe what the user should feel at each step and how the design delivers that. Target 400–500 words total.',
  'Write a consumer PRD that centres emotion alongside function.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 4: Design Intuition
-- ════════════════════════════════════════════════════════════════════════════
('d1030401-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000004',
  'Design Thinking for Product Managers',
  'Introduces the design thinking process — empathise, define, ideate, prototype, test — and explains how Consumer PMs apply each stage to product decisions.',
  'The design thinking process applied to PM decisions.', 'video', 'IDEO', NULL, 1),

('d1030401-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000004',
  'How to Give Great Design Feedback',
  'Teaches the specific techniques for giving design feedback that is specific, actionable, and framed around user outcomes rather than personal preference.',
  'Give design feedback that helps, not hurts.', 'video', 'AJ&Smart', NULL, 2),

('d1030401-0000-0000-0000-000000000003', 'c1030000-0000-0000-0000-000000000004',
  'Task: Write a Design Critique',
  'Pick any consumer app screen (onboarding, home feed, checkout). Write a design critique covering: one thing working well (with UX principle), two things that could improve (with specific suggestions), and one question you''d want to test with users. Deliver as a structured 1-page written critique.',
  'Critique a real product screen with structured UX principles.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 5: Personalization & Feed Algorithms
-- ════════════════════════════════════════════════════════════════════════════
('d1030501-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000005',
  'How Recommendation Systems Work',
  'Explains collaborative filtering, content-based filtering, and hybrid recommendation approaches in terms that translate directly into product decisions about data signals and cold-start handling.',
  'Recommendation systems explained at PM decision level.', 'video', 'Kaggle', NULL, 1),

('d1030501-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000005',
  'How Netflix Thinks About Personalization',
  'Direct insight into how a consumer product PM shapes personalisation strategy — covers the trade-off between accuracy, diversity, and serendipity.',
  'How Netflix balances accuracy vs diversity in recommendations.', 'reading', 'Netflix Tech Blog', NULL, 2),

('d1030501-0000-0000-0000-000000000003', 'c1030000-0000-0000-0000-000000000005',
  'Task: Write a Personalization Feature Brief',
  'Write a 1-page product brief for a personalisation feature in a consumer app of your choice. Include: the user problem being solved, 3 data signals you''d use to personalise, the ranking logic (in plain English), one user control you''d give them, and how you''d measure whether personalisation improved or harmed the experience.',
  'Spec a personalisation feature with signals, logic, and user controls.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 6: Social Mechanics & Virality
-- ════════════════════════════════════════════════════════════════════════════
('d1030601-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000006',
  'Network Effects Explained',
  'Explains the different types of network effects — direct, indirect, data, social, marketplace, and platform — and shows which product decisions accelerate or dilute them.',
  'Every type of network effect and how product decisions affect them.', 'video', 'NFX', NULL, 1),

('d1030601-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000006',
  'The NFX Network Effects Bible',
  'The most comprehensive public framework for understanding network effect types — essential for Consumer PMs.',
  'The definitive guide to all network effect types.', 'reading', 'NFX', NULL, 2),

('d1030601-0000-0000-0000-000000000003', 'c1030000-0000-0000-0000-000000000006',
  'Task: Design a Social Feature with Network Effects',
  'Design a social or community feature for a consumer app that currently has none. Map the feature''s network effect: what happens at 10 users, 1,000 users, and 100,000 users? Identify the minimum threshold for the feature to deliver value and how you''d get there. Deliver as a 1-page feature brief with a network effect diagram sketch.',
  'Design a social feature and map its network effect at 3 scale points.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 7: Engagement Case
-- ════════════════════════════════════════════════════════════════════════════
('d1030701-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000007',
  'Product Sense Cases for Consumer PMs',
  'Walks through live consumer product case examples, showing how strong candidates frame user segments, diagnose engagement problems, and generate solution ideas that are specific rather than generic.',
  'How top candidates structure consumer product cases.', 'video', 'Exponent', NULL, 1),

('d1030701-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000007',
  'Task: Fix Instagram Stories Engagement',
  'Solve this case in writing: ''Instagram Stories'' average watch time has declined 20% over the past two quarters among 18–25 year olds. What would you do?'' Deliver a 400-word structured response covering: diagnosis, 3 solution ideas with trade-offs, your recommendation, and how you''d measure success.',
  'Diagnose and fix a real consumer engagement drop.', 'task', NULL, NULL, 2),

-- ════════════════════════════════════════════════════════════════════════════
-- CONSUMER PM — MODULE 8: Design a New Feature Case
-- ════════════════════════════════════════════════════════════════════════════
('d1030801-0000-0000-0000-000000000001', 'c1030000-0000-0000-0000-000000000008',
  'Consumer Product Design Cases',
  'Demonstrates how to structure a from-scratch product design case — defining the user, scoping the problem, generating and prioritising solutions, and specifying success metrics.',
  'How to structure a from-scratch consumer product design case.', 'video', 'Exponent', NULL, 1),

('d1030801-0000-0000-0000-000000000002', 'c1030000-0000-0000-0000-000000000008',
  'Task: Design a Spotify Social Feature',
  'Solve this case in writing: ''Spotify wants to improve its social experience. Design a feature that increases social interaction between users without compromising the core listening experience.'' Deliver a structured response: user segment, problem statement, proposed feature, key design decisions, metrics for success, and the one thing you''d test first.',
  'Design a new social feature for Spotify end-to-end.', 'task', NULL, NULL, 2),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 1: How AI and ML Work
-- ════════════════════════════════════════════════════════════════════════════
('d1040101-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000001',
  'Machine Learning for Everyone',
  'Demystifies machine learning from the ground up — explaining what a model is, how it learns from data, and what training, testing, and inference actually mean in practice.',
  'ML from the ground up — no math required.', 'video', NULL, 'Cassie Kozyrkov, Google', 1),

('d1040101-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000001',
  'How Large Language Models Work',
  'Explains transformer architecture and LLMs through visual intuition — covering tokens, attention mechanisms, and how language models generate outputs.',
  'LLMs and transformers explained through visual intuition.', 'video', '3Blue1Brown', NULL, 2),

('d1040101-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000001',
  'AI Canon',
  'A curated reading list covering the foundational AI papers and concepts — the AI PM''s reference library.',
  'The curated AI reading list every AI PM should bookmark.', 'reading', 'Andreessen Horowitz (a16z)', NULL, 3),

('d1040101-0000-0000-0000-000000000004', 'c1040000-0000-0000-0000-000000000001',
  'Task: Explain an AI Feature You Use Daily',
  'Choose one AI-powered feature you use daily (smart reply, content moderation, recommendations, search ranking). Write a 1-page explanation of how it likely works — training data source, model type (classifier, ranker, generator), how it serves a result, and one way the model could fail the user. No jargon required — clarity over precision.',
  'Explain how a real AI feature works in plain language.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 2: Probabilistic Products
-- ════════════════════════════════════════════════════════════════════════════
('d1040201-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000002',
  'Building AI Products Responsibly',
  'Covers the principles behind responsible AI product development — fairness, transparency, accountability, and privacy — and explains the specific product decisions that either uphold or undermine them.',
  'Fairness, transparency, accountability in AI product decisions.', 'video', 'Google Responsible AI Practices', NULL, 1),

('d1040201-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000002',
  'AI Product Management — What''s Different?',
  'Explains what makes AI PM work structurally different — probabilistic outputs, data dependencies, longer feedback loops, and the challenge of setting user expectations for imperfect systems.',
  'Why AI PM is structurally different from traditional PM.', 'video', 'Lenny Rachitsky', NULL, 2),

('d1040201-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000002',
  'The AI Product Manager',
  'Covers what AI PMs own, how they work with data scientists and ML engineers, and what makes the role distinct.',
  'What an AI PM owns and how they work with data scientists.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('d1040201-0000-0000-0000-000000000004', 'c1040000-0000-0000-0000-000000000002',
  'Task: Deterministic vs Probabilistic Feature Spec',
  'Pick any AI feature in a consumer or enterprise product. Write a 1-page brief comparing how you''d spec it if it were deterministic (rules-based) vs. probabilistic (ML-based). Cover: how the success metric changes, how you''d handle errors differently, and one user trust mechanism you''d build specifically because the output is probabilistic.',
  'Compare how specs change when AI replaces rules-based logic.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 3: Writing AI Feature Specs
-- ════════════════════════════════════════════════════════════════════════════
('d1040301-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000003',
  'How to Write PRDs for AI Products',
  'Shows how AI feature specs differ from standard PRDs — including the additional sections required for training data, model evaluation criteria, confidence thresholds, and fallback logic.',
  'The additional spec sections AI features require.', 'video', 'Product School', NULL, 1),

('d1040301-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000003',
  'How to Spec an ML Feature',
  'Covers what goes into an ML feature spec and how PMs and scientists collaborate most effectively.',
  'The complete ML feature spec guide.', 'reading', 'Towards Data Science', 'Eugene Yan', 2),

('d1040301-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000003',
  'Task: Write a Full AI Feature Spec',
  'Write a full AI feature spec for one of: a smart email reply system, an AI content moderation layer, or a personalised search ranking algorithm. Must include: user problem, training data requirements, evaluation metric (with definition), latency constraint, top 2 failure modes, and how the user experiences each failure. Target 400–500 words.',
  'Write a complete AI feature spec with training data and failure modes.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 4: Data Strategy & Instrumentation
-- ════════════════════════════════════════════════════════════════════════════
('d1040401-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000004',
  'Data Strategy for PMs',
  'Explains how AI/Data PMs think about data as a strategic asset — covering data flywheels, network effects that come from data accumulation, and why instrumentation decisions made early compound into competitive advantages.',
  'Data as a strategic asset — the flywheel effect.', 'video', 'Reforge', NULL, 1),

('d1040401-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000004',
  'The PM''s Guide to Data Instrumentation',
  'Practical guide to event tracking design — what to instrument, how to name events, and how instrumentation decisions constrain future analysis.',
  'Event tracking design for PMs — what to instrument and why.', 'reading', 'Amplitude Blog', NULL, 2),

('d1040401-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000004',
  'Task: Design a Data Instrumentation Plan',
  'Take a product feature you''ve been involved in or care about. Design a data instrumentation plan: 5 events you''d track (with properties), 2 implicit feedback signals you''d collect to train a model, 1 explicit feedback mechanism for users, and the one data gap that would most limit your AI feature roadmap if left unfilled.',
  'Design the full instrumentation plan for an AI feature.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 5: LLM Products
-- ════════════════════════════════════════════════════════════════════════════
('d1040501-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000005',
  'Building with LLMs',
  'Explains the practical considerations for building production LLM products — prompt engineering, context window management, cost vs. quality trade-offs, and the reliability challenges that separate demos from real products.',
  'What separates LLM demos from production-ready products.', 'video', NULL, 'Andrej Karpathy', 1),

('d1040501-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000005',
  'RAG Explained for PMs',
  'Explains Retrieval Augmented Generation — how it works, when it should be used instead of fine-tuning, and what product decisions it enables (fresher knowledge, reduced hallucination, domain specificity).',
  'RAG vs fine-tuning — the product decision framework.', 'video', 'IBM Technology', NULL, 2),

('d1040501-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000005',
  'LLM-Powered Products: What Could Go Wrong',
  'Covers the product failure modes specific to LLM features — hallucination, prompt injection, context window limits, and how PMs design around them.',
  'Every LLM failure mode and how PMs design around them.', 'reading', 'Lenny''s Newsletter', 'Lenny Rachitsky', 3),

('d1040501-0000-0000-0000-000000000004', 'c1040000-0000-0000-0000-000000000005',
  'Task: Stress-Test an LLM Feature',
  'Find any LLM-powered product feature (Notion AI, GitHub Copilot, Perplexity, ChatGPT plugins). Spend 30 minutes stress-testing it — try to make it fail, hallucinate, or produce low-quality output. Write a structured failure analysis: 3 failure modes you observed, the likely cause of each, and one product-level mitigation you''d build for each.',
  'Actively break an LLM product and document what you find.', 'task', NULL, NULL, 4),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 6: AI Ethics & Bias
-- ════════════════════════════════════════════════════════════════════════════
('d1040601-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000006',
  'Algorithmic Bias and Fairness',
  'Introduces the main types of algorithmic bias — representation bias, measurement bias, aggregation bias — and shows through concrete examples how each type produces unfair product outcomes for specific user groups.',
  'The main types of algorithmic bias with concrete product examples.', 'video', 'Crash Course AI', NULL, 1),

('d1040601-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000006',
  'Designing Trustworthy AI',
  'IBM''s framework for AI transparency, explainability, and fairness — practical checklist format for product reviews.',
  'IBM''s practical checklist for trustworthy AI product reviews.', 'reading', 'IBM Trustworthy AI Framework', NULL, 2),

('d1040601-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000006',
  'Task: Identify Bias Risks in an AI Feature',
  'Choose an AI feature that makes consequential decisions for users (loan approval, content moderation, medical triage, hiring screening). Identify 2 potential bias risks — specify which user group is affected and what the product consequence is. For each, propose one product-level mitigation and explain why it''s the PM''s responsibility to own it.',
  'Identify and mitigate real bias risks in a consequential AI system.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 7: Should We Build This AI Feature?
-- ════════════════════════════════════════════════════════════════════════════
('d1040701-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000007',
  'When to Use AI in Your Product',
  'Covers the decision criteria for when AI is genuinely the right tool — and when a simpler rules-based or heuristic solution would be faster, cheaper, and more reliable.',
  'When AI is the right tool and when it isn''t.', 'video', 'Lenny Rachitsky', NULL, 1),

('d1040701-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000007',
  'Do You Really Need AI?',
  'Covers the most common mistake AI PMs make — using ML when a rule-based system would do the job better, faster, and more reliably.',
  'The most common AI PM mistake — and how to avoid it.', 'reading', 'Hackernoon', 'Cassie Kozyrkov', 2),

('d1040701-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000007',
  'Task: Should We Build This AI Feature?',
  'Solve this case in writing: ''Your team is proposing to build an AI feature that automatically categorises customer support tickets and routes them to the right team. Should you build this? If yes, scope the MVP. If no, what would you do instead?'' Deliver a 400-word response covering: whether AI is the right tool, data requirements, MVP scope, success metrics, and the biggest risk to get right.',
  'Make a build vs don''t-build AI decision with full rationale.', 'task', NULL, NULL, 3),

-- ════════════════════════════════════════════════════════════════════════════
-- AI/DATA PM — MODULE 8: Improve a Broken AI Feature
-- ════════════════════════════════════════════════════════════════════════════
('d1040801-0000-0000-0000-000000000001', 'c1040000-0000-0000-0000-000000000008',
  'Debugging AI Products',
  'Explains how to systematically diagnose AI product failures — distinguishing between data quality issues, model quality issues, and product design issues.',
  'How to tell if an AI failure is a model problem or a product problem.', 'video', NULL, 'Andrej Karpathy', 1),

('d1040801-0000-0000-0000-000000000002', 'c1040000-0000-0000-0000-000000000008',
  'When AI Features Fail',
  'Covers how PMs should diagnose AI product underperformance — separating model quality, data quality, and product design issues.',
  'The PM''s diagnostic framework for AI feature underperformance.', 'reading', 'First Round Review', NULL, 2),

('d1040801-0000-0000-0000-000000000003', 'c1040000-0000-0000-0000-000000000008',
  'Task: Fix Spotify''s Broken Discover Weekly',
  'Solve this case in writing: ''Spotify''s Discover Weekly playlist has seen a 25% drop in skip-rate improvement over the past 6 months — users are skipping recommended songs at the same rate as non-recommended ones. The model hasn''t changed. What''s going on and what do you do?'' Deliver a 400-word structured response: diagnostic hypotheses (model vs. data vs. product vs. user behaviour), investigation plan, and interventions — distinguishing what the PM owns vs. what the ML engineer owns.',
  'Diagnose and fix a broken AI recommendation feature.', 'task', NULL, NULL, 3)

ON CONFLICT (id) DO NOTHING;
