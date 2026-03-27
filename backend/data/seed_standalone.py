"""
Standalone KB seed script — uses only openai + urllib (no supabase SDK needed).
Run with system Python3:
  python3 backend/data/seed_standalone.py
"""

import json
import urllib.request
import urllib.error
import os
import sys

import os
from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
SUPABASE_URL   = os.getenv("SUPABASE_URL", "")
SUPABASE_KEY   = os.getenv("SUPABASE_SERVICE_KEY", "")

KB_CHUNKS = [
    # ── PRODUCT DESIGN ────────────────────────────────────────────────────────
    {
        "topic": "product_design",
        "source": "PM Interview Handbook",
        "content": "When tackling a product design question, always begin by clarifying the goal and scope. Ask: what does success look like for the company? Then define the user segments — who are the primary, secondary, and edge-case users? A strong answer identifies 2-3 specific personas with concrete pain points. Avoid generic personas like 'busy professionals' — get specific: 'a 28-year-old nurse who commutes 45 minutes each way and needs to stay informed without screen time.' The more specific the persona, the more credible your feature ideas will be.",
    },
    {
        "topic": "product_design",
        "source": "PM Interview Handbook",
        "content": "The CIRCLES method is a popular framework for product design interviews: Comprehend the situation, Identify the customer, Report the customer's needs, Cut through prioritisation, List solutions, Evaluate trade-offs, Summarise. You don't need to use it rigidly — but it ensures you don't skip steps. The most common mistake is jumping straight to features. Always spend the first 2-3 minutes on customer context before proposing any solution.",
    },
    {
        "topic": "product_design",
        "source": "PM Interview Handbook",
        "content": "Prioritisation in product design: after listing 4-5 potential features, use a simple Impact vs. Effort matrix to narrow to 1-2 recommendations. Quantify impact where possible: 'This feature could reduce onboarding drop-off by ~20%, improving D7 retention.' Always explain the trade-off: 'I'm deprioritising X because its engineering complexity is high and it only serves a niche segment.' Strong PMs show they've thought about what NOT to build as much as what to build.",
    },
    {
        "topic": "product_design",
        "source": "Lenny's Newsletter",
        "content": "When evaluating trade-offs in product design, consider four dimensions: user value (does it solve a real pain?), business value (does it move a key metric?), technical feasibility (can we build it in a reasonable timeframe?), and strategic fit (does it align with the company's 3-year vision?). A feature that scores highly on user value but poorly on strategic fit is often a trap — it can distract the team and fragment the product. The best PMs recognise that saying no to a good idea is harder than saying yes.",
    },
    {
        "topic": "product_design",
        "source": "PM Interview Handbook",
        "content": "Success metrics for a product design answer should be tied to user behaviour, not outputs. Bad metric: 'We ship the feature in Q2.' Good metric: 'We increase the percentage of users who complete onboarding within 24 hours from 42% to 60%.' Always define a north star metric (the one metric that best captures user value), plus 1-2 guardrail metrics (metrics you must not harm, e.g. customer support tickets). Be prepared to explain how you'd measure the metric and how quickly you'd expect to see signal.",
    },

    # ── STRATEGY ──────────────────────────────────────────────────────────────
    {
        "topic": "strategy",
        "source": "PM Interview Handbook",
        "content": "Market sizing questions test structured thinking, not just numerical accuracy. Use a top-down approach (start from total market, apply penetration rates) or bottom-up approach (build from unit economics upward). Always state your assumptions clearly and check whether the final number feels directionally right. Example: 'The US has ~130M households. If 30% own a smart TV and 40% would subscribe to a premium streaming tier at $15/month, that's a ~$234M/month TAM — roughly $2.8B/year. That feels plausible given Netflix's US revenue of ~$14B and their ~40% US market share.'",
    },
    {
        "topic": "strategy",
        "source": "PM Interview Handbook",
        "content": "When evaluating a new market entry, use the 3Cs + 3Ps framework: Customers (who are they, what do they need?), Competition (who's already there, what's the moat?), Company (do we have the capabilities?), Product (what exactly are we offering?), Pricing (value-based vs. cost-plus vs. competitive?), and Positioning (how are we different?). A common mistake is focusing only on the opportunity and ignoring existing players. Always address the question: why would customers switch from what they use today?",
    },
    {
        "topic": "strategy",
        "source": "Lenny's Newsletter",
        "content": "Platform strategy vs. product strategy: a platform play creates a two-sided or multi-sided network where each side increases value for the other. The key question is: which side do you seed first? Typically you start with the supply side (creators, sellers, drivers) and then attract demand. The cold-start problem is the biggest risk — what's the minimum viable supply to make demand worth showing up? Strong strategic answers acknowledge this bootstrapping challenge and propose a specific geographic or vertical wedge to solve it.",
    },
    {
        "topic": "strategy",
        "source": "PM Interview Handbook",
        "content": "Go-to-market strategy for a new product should answer: who is the ICP (ideal customer profile), what channel reaches them most efficiently, what's the sales motion (self-serve, inside sales, enterprise?), and what's the activation hook — the moment the customer first experiences value. In interviews, walk through: initial wedge market → land-and-expand → mainstream adoption. The best answers show sequencing: 'We'd start with X segment because they have the highest pain and lowest switching cost, then expand to Y once we have case studies.'",
    },
    {
        "topic": "strategy",
        "source": "PM Interview Handbook",
        "content": "Competitive moats in PM interviews: sustainable advantages come from network effects (value grows with users), switching costs (users lose data/integrations if they leave), economies of scale (marginal cost drops with volume), proprietary data (unique dataset), or brand/trust. Weak moats: 'our UI is better' or 'we have more features.' When asked to assess a company's competitive position, always identify which type of moat they have (or lack) and whether it's strengthening or eroding.",
    },

    # ── ANALYTICAL ────────────────────────────────────────────────────────────
    {
        "topic": "analytical",
        "source": "PM Interview Handbook",
        "content": "When a key metric drops suddenly, follow a structured diagnosis before jumping to conclusions. Step 1: Confirm the data is real (data pipeline issue? tracking bug? timezone shift?). Step 2: Segment the drop — is it global or one platform/country/user segment? Step 3: Check for external factors — app store change, competitor launch, PR event, seasonality. Step 4: Trace the funnel — at which step did users drop off? Step 5: Form hypotheses and prioritise by likelihood. Never propose solutions before completing the diagnosis — that's a red flag in interviews.",
    },
    {
        "topic": "analytical",
        "source": "PM Interview Handbook",
        "content": "The AARRR (Pirate Metrics) funnel: Acquisition, Activation, Retention, Revenue, Referral. Each stage has its own diagnostic questions. Acquisition: are fewer users reaching the product? Activation: are users reaching the 'aha moment'? Retention: are users coming back? (check D1, D7, D30 cohort retention curves). Revenue: are users paying? (check conversion to paid, ARPU, churn). Referral: are users recommending? (check NPS, viral coefficient, share rates).",
    },
    {
        "topic": "analytical",
        "source": "Lenny's Newsletter",
        "content": "A/B testing best practices for PM interviews: always state the null hypothesis, define the primary metric (and why), choose the unit of randomisation (user, session, device), calculate the required sample size before running (based on MDE — minimum detectable effect), and define the test duration upfront to avoid peeking. Common mistakes: running tests too short, using multiple primary metrics, ignoring novelty effects (users behave differently when they see something new), and failing to consider network effects (where the treatment of one user affects others).",
    },
    {
        "topic": "analytical",
        "source": "PM Interview Handbook",
        "content": "Root cause analysis framework: 1. Isolate the problem (what metric, what time period, what magnitude?). 2. Segment by dimensions: platform, geography, user cohort, device type, feature. 3. Check the full funnel around the affected metric. 4. Correlate with known events (deploys, campaigns, external events). 5. Form 2-3 hypotheses ranked by likelihood. 6. Propose the next step to validate each hypothesis cheaply (a SQL query, a support ticket scan, a qualitative call). Never stop at identifying the drop — always propose how you'd validate the cause.",
    },
    {
        "topic": "analytical",
        "source": "PM Interview Handbook",
        "content": "Defining success metrics: every feature should have one north star metric tied directly to user or business value, plus guardrail metrics to ensure you're not creating negative side effects. For a notification feature: North star: 7-day re-engagement rate of dormant users. Guardrail: notification opt-out rate (must not increase above baseline by >2%). Counter-metric: customer support tickets mentioning notifications. The most common mistake is picking an output metric (notifications sent) instead of an outcome metric (users who return because of the notification).",
    },

    # ── BEHAVIOURAL ───────────────────────────────────────────────────────────
    {
        "topic": "behavioural",
        "source": "PM Interview Handbook",
        "content": "The STAR framework for behavioural answers: Situation — brief context (1-2 sentences). Task — what was your specific responsibility? Action — what did YOU specifically do? Use 'I', not 'we'. Be concrete: what did you say, build, decide, prioritise? Result — what was the measurable outcome? Quantify where possible: 'We reduced time-to-close by 30%', 'NPS improved from 22 to 41'. The most common mistake is spending too long on Situation and not enough on Action.",
    },
    {
        "topic": "behavioural",
        "source": "PM Interview Handbook",
        "content": "Conflict and influence questions test whether you can work cross-functionally without authority. Strong answers: 1. Show you sought to understand the other party's perspective before pushing your own. 2. Used data to shift the conversation from opinion to evidence. 3. Found a creative solution that addressed both parties' underlying needs. 4. If you didn't win: show what you learned and how you moved forward constructively. Weak answers: you 'escalated to leadership' immediately, or you 'just compromised' without explaining the reasoning.",
    },
    {
        "topic": "behavioural",
        "source": "Lenny's Newsletter",
        "content": "Leadership questions in PM interviews often boil down to: how do you drive outcomes when you don't have direct authority? Strong PMs: set a clear vision that people want to follow, build trust through consistency and follow-through, create shared accountability by involving team members in the problem definition (not just the solution), and celebrate wins publicly while giving feedback privately. The best stories show a moment of genuine tension where you had to choose between being liked and being right — and you chose being right, then brought the team along.",
    },
    {
        "topic": "behavioural",
        "source": "PM Interview Handbook",
        "content": "Failure questions test self-awareness and learning agility. The ideal answer: 1. Pick a real failure with real stakes (not a humble-brag failure). 2. Own it fully — don't blame external factors or 'the team'. 3. Explain what you would do differently today, with specificity. 4. Show evidence of the lesson applied: 'Since then, I always [X] before launching.' Interviewers are not looking for perfection — they're looking for someone who learns fast and takes responsibility.",
    },
    {
        "topic": "behavioural",
        "source": "PM Interview Handbook",
        "content": "Stakeholder management questions: strong PMs recognise that stakeholders have different motivations and communicate accordingly. Engineering cares about technical quality and sustainable pace. Design cares about user experience integrity. Sales cares about deal velocity and customer commitments. Executives care about strategy alignment and business impact. A great PM translates the same feature decision into four different narratives for four different audiences. In interviews, show you understood the stakeholder's actual motivation — not just their stated request.",
    },
]


def embed(text):
    data = json.dumps({
        "model": "text-embedding-3-small",
        "input": text[:8000],
    }).encode()
    req = urllib.request.Request(
        "https://api.openai.com/v1/embeddings",
        data=data,
        headers={
            "Authorization": f"Bearer {OPENAI_API_KEY}",
            "Content-Type": "application/json",
        },
    )
    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read())
    return result["data"][0]["embedding"]


def insert_row(row):
    data = json.dumps(row).encode()
    req = urllib.request.Request(
        f"{SUPABASE_URL}/rest/v1/interview_kb",
        data=data,
        method="POST",
        headers={
            "apikey": SUPABASE_KEY,
            "Authorization": f"Bearer {SUPABASE_KEY}",
            "Content-Type": "application/json",
            "Prefer": "return=minimal",
        },
    )
    with urllib.request.urlopen(req) as resp:
        return resp.status


def main():
    print(f"Seeding {len(KB_CHUNKS)} knowledge base chunks into Supabase...\n")
    inserted = 0
    failed = 0

    for i, chunk in enumerate(KB_CHUNKS):
        preview = chunk["content"][:70].replace("\n", " ")
        print(f"[{i+1:02d}/{len(KB_CHUNKS)}] {chunk['topic']} — {preview}...")
        try:
            embedding = embed(chunk["content"])
            status = insert_row({
                "topic": chunk["topic"],
                "content": chunk["content"],
                "embedding": embedding,
                "source": chunk.get("source"),
            })
            print(f"         ✓ inserted (HTTP {status})")
            inserted += 1
        except Exception as e:
            print(f"         ✗ FAILED: {e}")
            failed += 1

    print(f"\n{'─'*50}")
    print(f"Done. {inserted} inserted, {failed} failed.")
    if inserted > 0:
        print("interview_kb is ready for semantic search.")


if __name__ == "__main__":
    main()
