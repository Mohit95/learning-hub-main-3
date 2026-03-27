-- ============================================================================
-- 00004_curriculum_schema.sql
-- Applies migrations 00002 + 00003 (not yet on live DB)
-- + adds curriculum columns to programs, modules, lessons
-- Run this once in Supabase SQL Editor
-- ============================================================================

-- ── From 00002: extend roadmap_steps ─────────────────────────────────────────
ALTER TABLE roadmap_steps
  ADD COLUMN IF NOT EXISTS description text,
  ADD COLUMN IF NOT EXISTS skill_area text,
  ADD COLUMN IF NOT EXISTS order_index integer DEFAULT 0;

CREATE INDEX IF NOT EXISTS idx_roadmap_steps_order ON roadmap_steps (roadmap_id, order_index);
CREATE INDEX IF NOT EXISTS idx_roadmap_steps_skill  ON roadmap_steps (roadmap_id, skill_area);

-- ── From 00003: enums ─────────────────────────────────────────────────────────
DO $$ BEGIN
  CREATE TYPE step_type AS ENUM ('video', 'reading', 'practice', 'project');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE reward_status AS ENUM ('locked', 'unclaimed', 'claimed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE submission_status AS ENUM ('pending_review', 'reviewed');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ── From 00003: extend roadmaps ───────────────────────────────────────────────
ALTER TABLE roadmaps
  ADD COLUMN IF NOT EXISTS readiness_score integer DEFAULT 0;

-- ── From 00003: extend roadmap_steps ─────────────────────────────────────────
ALTER TABLE roadmap_steps
  ADD COLUMN IF NOT EXISTS phase_number    integer   NOT NULL DEFAULT 1,
  ADD COLUMN IF NOT EXISTS step_type       step_type DEFAULT 'reading',
  ADD COLUMN IF NOT EXISTS time_estimate_minutes integer,
  ADD COLUMN IF NOT EXISTS resource_url    text,
  ADD COLUMN IF NOT EXISTS points          integer   DEFAULT 10,
  ADD COLUMN IF NOT EXISTS is_submission_required boolean DEFAULT false,
  ADD COLUMN IF NOT EXISTS mentor_id       uuid REFERENCES mentors(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_roadmap_steps_phase ON roadmap_steps (roadmap_id, phase_number, order_index);

-- ── From 00003: roadmap_phases table ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS roadmap_phases (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  roadmap_id      uuid REFERENCES roadmaps(id) ON DELETE CASCADE NOT NULL,
  phase_number    integer NOT NULL,
  title           text NOT NULL,
  subtitle        text,
  reward_title    text,
  reward_description text,
  reward_status   reward_status DEFAULT 'locked',
  claimed_at      timestamptz,
  created_at      timestamptz DEFAULT now(),
  UNIQUE (roadmap_id, phase_number)
);
ALTER TABLE roadmap_phases ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own roadmap phases"  ON roadmap_phases;
DROP POLICY IF EXISTS "Users can update own roadmap phases" ON roadmap_phases;
CREATE POLICY "Users can read own roadmap phases"
  ON roadmap_phases FOR SELECT TO authenticated
  USING (roadmap_id IN (SELECT id FROM roadmaps WHERE profile_id = auth.uid()));
CREATE POLICY "Users can update own roadmap phases"
  ON roadmap_phases FOR UPDATE TO authenticated
  USING (roadmap_id IN (SELECT id FROM roadmaps WHERE profile_id = auth.uid()));

-- ── From 00003: roadmap_submissions table ────────────────────────────────────
CREATE TABLE IF NOT EXISTS roadmap_submissions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  step_id     uuid REFERENCES roadmap_steps(id) ON DELETE CASCADE NOT NULL,
  profile_id  uuid REFERENCES profiles(id)      ON DELETE CASCADE NOT NULL,
  file_url    text NOT NULL,
  file_name   text,
  status      submission_status DEFAULT 'pending_review',
  ai_feedback jsonb,
  created_at  timestamptz DEFAULT now()
);
ALTER TABLE roadmap_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can read own submissions"   ON roadmap_submissions;
DROP POLICY IF EXISTS "Users can insert own submissions" ON roadmap_submissions;
CREATE POLICY "Users can read own submissions"
  ON roadmap_submissions FOR SELECT TO authenticated
  USING (profile_id = auth.uid());
CREATE POLICY "Users can insert own submissions"
  ON roadmap_submissions FOR INSERT TO authenticated
  WITH CHECK (profile_id = auth.uid());

-- ── From 00003: RLS policies on existing tables ───────────────────────────────
DROP POLICY IF EXISTS "Users can update own roadmap steps" ON roadmap_steps;
CREATE POLICY "Users can update own roadmap steps"
  ON roadmap_steps FOR UPDATE TO authenticated
  USING (roadmap_id IN (SELECT id FROM roadmaps WHERE profile_id = auth.uid()));

DROP POLICY IF EXISTS "Users can update own roadmaps" ON roadmaps;
CREATE POLICY "Users can update own roadmaps"
  ON roadmaps FOR UPDATE TO authenticated
  USING (profile_id = auth.uid());

-- ── NEW (00004): curriculum columns ──────────────────────────────────────────

-- programs: tag which archetype this program belongs to
ALTER TABLE programs
  ADD COLUMN IF NOT EXISTS archetype_name text,
  ADD COLUMN IF NOT EXISTS total_phases   integer DEFAULT 4;

-- modules: phase grouping + learning objective
ALTER TABLE modules
  ADD COLUMN IF NOT EXISTS phase_number       integer DEFAULT 1,
  ADD COLUMN IF NOT EXISTS description        text,
  ADD COLUMN IF NOT EXISTS learning_objective text;

-- lessons: type + metadata
DO $$ BEGIN
  CREATE TYPE lesson_type AS ENUM ('video', 'reading', 'task');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER TABLE lessons
  ADD COLUMN IF NOT EXISTS lesson_type  lesson_type DEFAULT 'reading',
  ADD COLUMN IF NOT EXISTS source       text,
  ADD COLUMN IF NOT EXISTS author       text,
  ADD COLUMN IF NOT EXISTS order_index  integer DEFAULT 0,
  ADD COLUMN IF NOT EXISTS video_url    text,
  ADD COLUMN IF NOT EXISTS description  text;

-- RLS: allow authenticated users to read programs, modules, lessons
DROP POLICY IF EXISTS "Anyone can read programs" ON programs;
CREATE POLICY "Anyone can read programs"
  ON programs FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Anyone can read modules" ON modules;
CREATE POLICY "Anyone can read modules"
  ON modules FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Anyone can read lessons" ON lessons;
CREATE POLICY "Anyone can read lessons"
  ON lessons FOR SELECT TO authenticated USING (true);

-- RLS: allow authenticated users to read pm_archetypes
DROP POLICY IF EXISTS "Anyone can read archetypes" ON pm_archetypes;
CREATE POLICY "Anyone can read archetypes"
  ON pm_archetypes FOR SELECT TO authenticated USING (true);
