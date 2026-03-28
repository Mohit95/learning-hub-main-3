-- ── Add week/day structure to lessons ─────────────────────────────────────────

ALTER TABLE lessons ADD COLUMN IF NOT EXISTS week_number INTEGER DEFAULT 1;
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS day_number  INTEGER DEFAULT 1;

-- Derive week_number from the parent module's order_index
-- (Module 1 → Week 1, Module 2 → Week 2, etc.)
UPDATE lessons l
SET    week_number = m.order_index
FROM   modules m
WHERE  l.module_id = m.id
AND    m.order_index IS NOT NULL;

-- Derive day_number from lesson's order_index within its module
-- (lesson 1 → Day 1, lesson 2 → Day 2, lesson 3 → Day 3, lesson 4 → Day 1 of next chunk, etc.)
UPDATE lessons
SET day_number = CASE
  WHEN order_index IS NULL THEN 1
  ELSE ((order_index - 1) % 3) + 1
END;

-- ── Add start_date to roadmaps ─────────────────────────────────────────────────
-- When a student starts their program. All lesson dates are derived from this.

ALTER TABLE roadmaps ADD COLUMN IF NOT EXISTS start_date DATE DEFAULT CURRENT_DATE;
