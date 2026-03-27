# Learning Hub — Student User Journey
**Last updated:** March 2026
**Audience:** Product / Design / Engineering
**Purpose:** End-to-end map of what a learner sees, does, and experiences across every screen.

---

## Overview

A student goes through 5 macro stages:

```
1. DISCOVER → 2. ASSESS → 3. LEARN → 4. PRACTICE → 5. CONNECT
```

Each stage has a clear entry point, a set of screens, and an exit that leads to the next. The diagram below shows the full flow before we go screen-by-screen.

```
Landing Page
    │
    ▼
Sign Up / Sign In
    │
    ▼
Dashboard (home base — student returns here every session)
    │
    ├── ASSESS ──────────────────────────────────────────────────────────────┐
    │     │                                                                  │
    │     ▼                                                                  │
    │   Assessments List                                                     │
    │     │                                                                  │
    │     ▼                                                                  │
    │   Readiness Questionnaire (10 questions)                               │
    │     │                                                                  │
    │     ▼                                                                  │
    │   Resume Upload (optional)                                             │
    │     │                                                                  │
    │     ▼                                                                  │
    │   Readiness Scorecard (72–78% score, competency breakdown)            │
    │     │                                                                  │
    │     ▼                                                                  │
    │   Gap Analysis (archetype match, radar chart, fitment scores)         │
    │     │                                                                  │
    │     ▼                                                                  │
    │   Roadmap generated ◄──────────────────────────────────────────────────┘
    │
    ├── LEARN ──────────────────────────────────────────────────────────────
    │     │
    │     ├── Roadmap (mark steps complete, submit work, earn points)
    │     └── Curriculum (browse all 4 archetype paths and every module)
    │
    ├── PRACTICE ─────────────────────────────────────────────────────────
    │     │
    │     ├── Interview Prep → Mock Session → Scorecard → Past Sessions
    │
    └── CONNECT ─────────────────────────────────────────────────────────
          │
          ├── Mentors (browse + book 1-on-1 sessions)
          ├── Events (register for webinars and workshops)
          └── Blog (read PM articles)
```

---

## Stage 1 — Discover (Public, No Login)

### 1.1 Landing Page `/`

**What the student sees:**
- Hero headline: "Accelerate Your PM Career"
- 3 value props: Deep Skills Assessment, Personalized Roadmaps, 1-on-1 Mentorship
- Social proof: "500+ PMs placed globally"
- Two CTAs: Sign In and Get Started

**What they can do:**
- Click Get Started → goes to Sign Up
- Click Sign In → goes to Sign In

**Status:** Static — no API calls. Content is hardcoded.

---

### 1.2 Sign Up `/signup`

**What the student sees:**
- Form: Full Name, Email, Password (min 6 chars)
- "Create Account" button
- Link to Sign In

**What happens:**
1. Student submits form
2. Supabase creates auth user + profile row
3. Confirmation email is sent
4. Screen shows "Check your email" success state
5. Student verifies email → can now sign in

**Status:** Real — connected to Supabase Auth.

---

### 1.3 Sign In `/signin`

**What the student sees:**
- Email + password form
- Error banner if credentials are wrong

**What happens:**
1. Supabase authenticates
2. Profile is fetched and stored in app state (authStore)
3. Redirects to `/app/dashboard`

**Status:** Real — connected to Supabase Auth.

---

## Stage 2 — Assess

This is the most important stage. It determines the student's archetype and generates their personalised roadmap. Every screen from here is behind a login gate.

### 2.1 Dashboard (First Visit) `/app/dashboard`

**What the student sees on first visit:**
- "Welcome back, [Name]"
- Empty roadmap section: "No roadmap yet. Take an assessment →"
- Empty sessions section: "No upcoming sessions. Book a mentor →"
- Stats show 0 completed lessons, 0 upcoming sessions

**What they do:** Click "Take an assessment" → Assessments page.

**Status:** Real data — calls Supabase for progress, roadmap, sessions.

---

### 2.2 Assessments List `/app/assessments`

**What the student sees:**
- One featured card: "Career Readiness Diagnostic"
- Badges: Featured · ~5 min · 5 questions
- Description: AI-driven resume review + self-assessment

**What they do:** Click "Start Diagnostic" → Readiness flow begins.

**Status:** Static card — no API call. Only one assessment is surfaced here.

---

### 2.3 Readiness Questionnaire `/app/readiness/questionnaire`

**What the student sees:**
- Progress bar: "Question X of 5"
- One question at a time with 5 confidence options:
  - Not at all confident → Somewhat → Confident → Very → Expert
- Back / Next navigation. Submit on question 5.

**The 5 questions cover:**
1. Product Sense
2. Strategic Thinking
3. Execution
4. Data Acumen
5. Leadership

**What happens on submit:**
- Answers stored in local state
- Navigates to Resume Upload

**Status:** Mock — questions hardcoded, answers stored locally (not persisted to DB yet).

---

### 2.4 Resume Upload `/app/readiness/resume-upload`

**What the student sees:**
- Green badge: "Adding a resume increases accuracy by up to 40%"
- Drag-and-drop zone for PDF/DOCX (max 5MB)
- "Analyze Resume" button after file selected
- "Skip for now" option at the bottom

**What happens:**
- If resume uploaded: 2s processing overlay → Scorecard (with resume insights)
- If skipped: Scorecard (without resume insights)

**Status:** Mock — file is selected locally but not uploaded to any server. Processing is simulated.

---

### 2.5 Readiness Scorecard `/app/readiness/scorecard`

**What the student sees:**
- Large score circle showing their readiness % (72% without resume / 78% with resume)
- "Ready" label
- Competency breakdown (5 bars):

| Competency | Score |
|---|---|
| Product Sense | 4.5 / 5.0 |
| Strategic Thinking | 3.2 / 5.0 |
| Execution | 3.5 or 4.5 / 5.0 |
| Data Acumen | 4.0 / 5.0 |
| Leadership | 3.8 / 5.0 |

- If resume uploaded: shows "Discrepancy" and "Verified Strength" insight cards
- If not: shows "Priority Development" card

**What they do:** Review results. Implied next step: go to Gap Analysis.

**Status:** Mock — scores are hardcoded. Change based on resume flag only.

---

### 2.6 Gap Analysis `/app/gap-analysis`

**What the student sees:**
- **Archetype Reveal:** 4 PM archetypes shown. Their top match is highlighted.
  - Growth PM, Technical PM, Consumer PM, AI/Data PM
- **Readiness Score:** Overall % + breakdown
- **Resume Analysis Badge:** Skills extracted from resume (if uploaded)
- **Gap Profile Chart:** Radar/bar chart — current vs. required skill levels
- **Fitment Score Cards:** How well they fit APM vs Senior PM vs etc.
- **"Generate Your Roadmap" CTA** (if no roadmap exists yet)

**What they do:**
- Read the analysis
- Click "Generate Your Roadmap" → calls backend → roadmap created → goes to Roadmap page

**Status:** Mock — `USE_MOCK = true`. Real gap analysis pipeline exists in backend but is not connected to the frontend yet.

---

## Stage 3 — Learn

### 3.1 Roadmap `/app/roadmap`

This is the student's personal learning plan. It is generated by AI based on their gap analysis.

**What the student sees:**
- Their archetype (e.g., "Growth PM") + readiness score
- "Regenerate" button
- Skill progress cards (filterable — e.g., "Product Sense: 60% → 85%")
- Phase timeline with 4 phases:
  - Phase 1: Foundation
  - Phase 2: Craft
  - Phase 3: Domain Depth
  - Phase 4: Case Practice
- Each phase has 2 steps. Each step shows:
  - Title
  - Status: Pending / In Progress / Complete
  - Points value (e.g., 10 pts)
  - Optional: mentor attached, submission required

**What they can do:**

| Action | What happens |
|---|---|
| Click step status | Cycles: Pending → In Progress → Complete |
| Complete a step | Awards points, toast "+10 pts" appears, readiness score updates |
| Submit work on a step | Opens file upload panel. Shows mock AI feedback after 3s |
| Claim phase reward | Marks phase as claimed, celebration moment |
| Filter by skill | Roadmap shows only steps for that skill area |
| Click Regenerate | Calls backend, re-generates roadmap from latest gap data |

**Status:** Mock — `USE_MOCK = true`. The 11-step mock roadmap is shown for everyone. Real generation exists in backend but is not wired to frontend.

---

### 3.2 Curriculum `/app/curriculum`

The curriculum is the full structured content from the docx — all 4 archetype paths available to browse at any time, independent of the personalised roadmap.

**What the student sees:**
- 4 archetype path cards:
  - 📈 Growth PM — 4 Phases · 8 Modules
  - ⚙️ Technical PM — 4 Phases · 8 Modules
  - 🎯 Consumer PM — 4 Phases · 8 Modules
  - 🤖 AI/Data PM — 4 Phases · 8 Modules
- Clicking a card loads all 32 modules for that path, grouped by phase:
  - Phase 1: Foundation
  - Phase 2: Craft
  - Phase 3: Domain Depth
  - Phase 4: Case Practice
- Clicking a module expands it to show every lesson:
  - ▶ Video lessons
  - 📄 Reading articles
  - ✏️ Task assignments

**What they can do:**
- Browse any path (not gated to their archetype)
- Expand/collapse any module
- Read lesson descriptions, reading attributions, and full task briefs

**Status:** Real — fully connected to live database. 113 lessons across 32 modules.

---

## Stage 4 — Practice

### 4.1 Interview Prep Home `/app/interview-prep`

**What the student sees:**
- 4 interview type cards to choose from:
  - Product Design
  - Product Strategy
  - Analytical
  - Behavioural
- "Start Session" button (disabled until type selected)
- Recent sessions list (2 sample sessions shown)
- Quick resources: STAR Framework, Top 15 PM Questions, Resume phrasing

**What they do:**
- Select a type
- Click "Start Session" → Mock session begins

**Status:** Mock — session history is hardcoded. Resources are static links.

---

### 4.2 Mock Interview Session `/app/interview-prep/session`

**What the student sees:**
- Selected type in header (e.g., "Product Design Mock Interview")
- "Question X of 5" counter
- Chat interface:
  - Bot asks a question (left side, gray)
  - Student types answer (right side, blue)
  - AI feedback card appears after each answer:
    - Strengths (green)
    - Gaps (red)
    - Suggestion
    - Dimension scores: Structure, Clarity, Depth, PM Thinking
- Text input at bottom + "Send" button

**Rules:**
- Answer must be 10+ words (or type "skip") — shorter triggers a warning dialog
- 5 questions total → auto-navigates to scorecard after Q5

**Status:** Mock — 5 hardcoded questions. Feedback is simulated (2s delay).

---

### 4.3 Interview Scorecard `/app/interview-prep/scorecard`

**What the student sees:**
- Overall score circle: 3.8 / 5
- Dimension breakdown with bars:
  - Structure: 4.2 / 5
  - Clarity: 3.5 / 5
  - Depth: 3.2 / 5
  - PM Thinking: 4.5 / 5
- Top Strength + Priority to Improve
- "Reveal Hiring Manager View" button → 1.5s load → reveals:
  - Green Flags (what would impress a HM)
  - Red Flags (what would concern a HM)
  - Opportunities (what to address before real interviews)

**Status:** Mock — all scores and feedback hardcoded.

---

### 4.4 Past Sessions `/app/interview-prep/history`

**What the student sees:**
- List of past sessions:
  - Session type, date, score, duration
- Click any → goes to scorecard (same mock scorecard for all)

**Status:** Mock — 3 hardcoded sessions.

---

## Stage 5 — Connect

### 5.1 Mentors `/app/mentors`

**What the student sees:**
- Grid of mentor cards showing:
  - Name + role (e.g., "Sarah Chen, APM at Google")
  - Next available time
  - Skill tags: Product Design, Growth, Mobile
  - Rating, session count, hourly rate
  - Bio quote
  - "Book session" button

**What they do:**
- Click "Book session" → Booking modal opens
  - Date/time picker
  - "Confirm Booking" → success message → modal closes after 1.5s

**Status:** Mock — mentor list is hardcoded. Booking is simulated (no calendar, no email, no backend record).

---

### 5.2 Events `/app/events`

**What the student sees:**
- Grid of event cards:
  - Date + time badge
  - Type badge (Beginner / Workshop / Live)
  - Title + host + duration
  - Description
  - "Register now" button (future events)
  - "Watch recording" button (past events, disabled)

**What they do:**
- Click "Register now" → button changes to "✓ Registered" (local state only)

**Status:** Mock — events hardcoded. Registration not persisted.

---

### 5.3 Blog `/app/blog`

**What the student sees:**
- Grid of blog post cards:
  - Category badge, title, preview text, author, read time

**What they do:**
- Click any card → opens full blog post at `/app/blog/{id}`

**Status:** Partially real — tries Supabase first, falls back to mock.

---

## Dashboard (Returning Student) `/app/dashboard`

Once the student has completed the assessment and has a roadmap, the dashboard becomes their home base.

**What they see:**
- Completed lessons count (real data)
- Upcoming sessions count (real data)
- First 3 roadmap steps (with status — currently mock)
- Next mentor session (currently mock)

**What they do:**
- "View all" → Roadmap
- "Book a mentor" → Mentors

---

## Navigation (Always Visible)

The sidebar is present on every protected page.

```
Dashboard
Assessments
Gap Analysis
Roadmap
Curriculum        ← New (added from docx implementation)
Interview Prep
Mentors
Events
Blog
──────────
[User Name]
[Role Badge]
Sign Out
```

Admin users also see:
```
Admin Users
```

---

## What's Real vs. Mock Today

| Feature | Status | Notes |
|---|---|---|
| Sign Up / Sign In | ✅ Real | Supabase Auth |
| Assessments (PM Readiness) | ✅ Real | Questions + submission live |
| Curriculum browse | ✅ Real | 113 lessons in DB |
| Backend programs API | ✅ Real | 3 endpoints live |
| Readiness questionnaire scoring | ⚠️ Mock | Hardcoded scores |
| Gap Analysis | ⚠️ Mock | `USE_MOCK = true` |
| Roadmap | ⚠️ Mock | `USE_MOCK = true` |
| Resume upload | ⚠️ Mock | No actual file upload |
| Interview questions + feedback | ⚠️ Mock | Hardcoded Q&A + scores |
| Mentor profiles | ⚠️ Mock | Hardcoded list, no booking backend |
| Events | ⚠️ Mock | Hardcoded, no registration backend |
| Blog | ⚠️ Partial | Falls back to mock if Supabase empty |

---

## Key Gaps to Fix Next

These are the top changes that would make the student journey fully real:

1. **Wire Gap Analysis to real data** — flip `USE_MOCK = false` in `GapAnalysis.jsx`, connect to archetype_results + gap_analysis tables
2. **Wire Roadmap to real data** — flip `USE_MOCK = false` in `Roadmap.jsx`, connect roadmap_steps to curriculum lessons
3. **Persist readiness questionnaire** — save answers to `assessment_results`, compute real score
4. **Resume upload** — connect to Supabase Storage, run actual AI extraction
5. **Mentors + Mentor sessions** — seed real mentor profiles, connect booking to `mentor_sessions` table
6. **Events** — seed real events, connect registration to `event_registrations` table
7. **Interview prep** — connect to backend for AI-generated questions and real feedback via Claude API
