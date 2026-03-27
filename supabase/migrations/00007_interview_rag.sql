-- Enable pgvector extension (available on Supabase free tier)
CREATE EXTENSION IF NOT EXISTS vector;

-- ── 1. Knowledge Base ─────────────────────────────────────────────────────────
-- Stores chunked PM interview knowledge with vector embeddings for semantic search

CREATE TABLE IF NOT EXISTS interview_kb (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic      TEXT NOT NULL,       -- 'product_design' | 'strategy' | 'analytical' | 'behavioural'
  content    TEXT NOT NULL,       -- the knowledge chunk (~300-400 words)
  embedding  vector(1536),        -- OpenAI text-embedding-3-small output
  source     TEXT,                -- 'PM Interview Handbook', 'Lenny's Newsletter', etc.
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Index for fast cosine similarity search
CREATE INDEX IF NOT EXISTS interview_kb_embedding_idx
  ON interview_kb USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 50);

-- Full-text search index as fallback when embedding is null
CREATE INDEX IF NOT EXISTS interview_kb_fts_idx
  ON interview_kb USING gin(to_tsvector('english', content));


-- ── 2. Interview Sessions ──────────────────────────────────────────────────────
-- One row per interview session

CREATE TABLE IF NOT EXISTS interview_sessions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  interview_type TEXT NOT NULL,          -- 'product_design' | 'strategy' | 'analytical' | 'behavioural'
  status         TEXT DEFAULT 'active',  -- 'active' | 'completed'
  score          INTEGER,                -- 1-10, set on completion
  strengths      JSONB,                  -- ["strength 1", "strength 2", ...]
  gaps           JSONB,                  -- ["gap 1", "gap 2", ...]
  feedback       TEXT,                   -- written summary paragraph
  turn_count     INTEGER DEFAULT 0,
  created_at     TIMESTAMPTZ DEFAULT now(),
  completed_at   TIMESTAMPTZ
);

-- ── 3. Interview Messages ──────────────────────────────────────────────────────
-- Every Q&A turn stored here

CREATE TABLE IF NOT EXISTS interview_messages (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES interview_sessions(id) ON DELETE CASCADE,
  role       TEXT NOT NULL,   -- 'assistant' | 'user'
  content    TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS interview_messages_session_idx
  ON interview_messages(session_id, created_at);


-- ── 4. Vector similarity search function ──────────────────────────────────────
-- Called by the backend to find relevant KB chunks for a student's answer

CREATE OR REPLACE FUNCTION match_interview_kb(
  query_embedding vector(1536),
  topic_filter    TEXT,
  match_count     INT DEFAULT 4
)
RETURNS TABLE (
  id         UUID,
  content    TEXT,
  source     TEXT,
  similarity FLOAT
)
LANGUAGE sql STABLE AS $$
  SELECT
    id,
    content,
    source,
    1 - (embedding <=> query_embedding) AS similarity
  FROM interview_kb
  WHERE
    embedding IS NOT NULL
    AND (topic_filter IS NULL OR topic = topic_filter)
  ORDER BY embedding <=> query_embedding
  LIMIT match_count;
$$;


-- ── 5. RLS Policies ───────────────────────────────────────────────────────────

ALTER TABLE interview_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interview_messages ENABLE ROW LEVEL SECURITY;

-- Users can only see and modify their own sessions
CREATE POLICY "Users manage own sessions"
  ON interview_sessions FOR ALL
  USING (auth.uid() = user_id);

-- Users can only see messages belonging to their own sessions
CREATE POLICY "Users read own messages"
  ON interview_messages FOR ALL
  USING (
    session_id IN (
      SELECT id FROM interview_sessions WHERE user_id = auth.uid()
    )
  );

-- KB is public read (no sensitive data)
ALTER TABLE interview_kb ENABLE ROW LEVEL SECURITY;
CREATE POLICY "KB is public read"
  ON interview_kb FOR SELECT
  USING (true);
