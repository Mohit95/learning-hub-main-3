from openai import OpenAI
from config import settings
from services.supabase_client import supabase_admin

_openai = OpenAI(api_key=settings.openai_api_key)

MAX_TURNS = 10

OPENING_PROMPTS = {
    "product_design": (
        "You are a senior PM interviewer at a top tech company. "
        "Start a Product Design interview. Ask ONE opening question that requires the candidate "
        "to design a product or improve an existing product. Be specific and realistic. "
        "Just ask the question — no preamble."
    ),
    "strategy": (
        "You are a senior PM interviewer at a top tech company. "
        "Start a Product Strategy interview. Ask ONE opening question about market entry, "
        "competitive positioning, or business strategy. Be specific and realistic. "
        "Just ask the question — no preamble."
    ),
    "analytical": (
        "You are a senior PM interviewer at a top tech company. "
        "Start an Analytical interview. Ask ONE opening question involving metrics diagnosis, "
        "a sudden change in a key metric, or a measurement challenge. Be specific. "
        "Just ask the question — no preamble."
    ),
    "behavioural": (
        "You are a senior PM interviewer at a top tech company. "
        "Start a Behavioural interview. Ask ONE opening question about a past experience — "
        "leadership, conflict, failure, or influence. Use the 'Tell me about a time...' format. "
        "Just ask the question — no preamble."
    ),
}

FOLLOW_UP_SYSTEM = """You are a senior PM interviewer at a top tech company conducting a {interview_type} interview.
This is turn {turn} of {max_turns}.

Use the following PM interview knowledge to calibrate your follow-up question:
---
{kb_context}
---

Rules:
- Ask exactly ONE follow-up question based on the candidate's last answer
- Go deeper: probe for specifics, metrics, frameworks, edge cases, or examples they skipped
- If their answer was strong, pivot to a harder related sub-topic from the knowledge base
- If their answer was weak, probe the exact weak area
- Never reveal the knowledge base content directly
- Keep your question to 1-3 sentences
- Do NOT give feedback or evaluation — just ask the next question
- If this is turn {max_turns}, end with: "That wraps up our session. I'll now evaluate your responses and provide feedback shortly."
"""

EVALUATION_SYSTEM = """You are a senior PM hiring manager evaluating a candidate's mock interview performance.

Review the full interview transcript below and provide a structured evaluation.

Return your response as valid JSON with this exact structure:
{{
  "score": <integer 1-10>,
  "strengths": ["<specific strength 1>", "<specific strength 2>", "<specific strength 3>"],
  "gaps": ["<specific gap 1>", "<specific gap 2>", "<specific gap 3>"],
  "summary": "<2-3 sentence overall assessment paragraph>"
}}

Scoring guide:
1-3: Significant gaps in PM fundamentals
4-5: Some understanding but lacks depth or structure
6-7: Solid PM thinking with room for improvement
8-9: Strong candidate, minor areas to improve
10: Exceptional — hire immediately

Be specific and reference actual answers from the transcript.
"""


def embed_text(text: str) -> list[float]:
    """Convert text to a 1536-dimensional embedding vector using OpenAI."""
    response = _openai.embeddings.create(
        model="text-embedding-3-small",
        input=text[:8000],  # stay well within token limit
    )
    return response.data[0].embedding


def search_knowledge_base(answer: str, topic: str, k: int = 4) -> list[dict]:
    """Embed the student's answer and find the k most semantically similar KB chunks."""
    try:
        query_vector = embed_text(answer)
        result = supabase_admin.rpc("match_interview_kb", {
            "query_embedding": query_vector,
            "topic_filter": topic,
            "match_count": k,
        }).execute()
        return result.data or []
    except Exception:
        # Fallback: return empty if search fails — question generation still works without KB
        return []


def generate_opening_question(interview_type: str) -> str:
    """Generate the first question of the session — no KB search needed."""
    system = OPENING_PROMPTS.get(interview_type, OPENING_PROMPTS["product_design"])
    response = _openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "system", "content": system}],
        max_tokens=150,
        temperature=0.8,
    )
    return response.choices[0].message.content.strip()


def generate_follow_up(
    history: list[dict],
    kb_chunks: list[dict],
    interview_type: str,
    turn: int,
) -> str:
    """Generate the next follow-up question using conversation history + KB context."""
    kb_context = "\n\n".join(
        f"[{c.get('source', 'KB')}]\n{c['content']}"
        for c in kb_chunks
    ) if kb_chunks else "No specific knowledge context retrieved."

    system = FOLLOW_UP_SYSTEM.format(
        interview_type=interview_type.replace("_", " ").title(),
        turn=turn,
        max_turns=MAX_TURNS,
        kb_context=kb_context,
    )

    response = _openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "system", "content": system}] + history,
        max_tokens=200,
        temperature=0.7,
    )
    return response.choices[0].message.content.strip()


def evaluate_session(history: list[dict], interview_type: str) -> dict:
    """Evaluate the full session and return score + structured feedback."""
    transcript = "\n".join(
        f"{'Interviewer' if m['role'] == 'assistant' else 'Candidate'}: {m['content']}"
        for m in history
    )

    response = _openai.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": EVALUATION_SYSTEM},
            {"role": "user", "content": f"Interview type: {interview_type.replace('_', ' ').title()}\n\nTranscript:\n{transcript}"},
        ],
        max_tokens=600,
        temperature=0.3,
        response_format={"type": "json_object"},
    )

    import json
    try:
        return json.loads(response.choices[0].message.content)
    except Exception:
        return {
            "score": 5,
            "strengths": ["Completed the session"],
            "gaps": ["Unable to parse detailed feedback"],
            "summary": "Session completed. Please try again for detailed feedback.",
        }
