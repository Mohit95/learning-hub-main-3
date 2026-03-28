import io
import json
import asyncio
import anthropic
from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from config import settings

router = APIRouter(prefix="/api/readiness", tags=["readiness"])

client = anthropic.Anthropic(api_key=settings.anthropic_api_key)

QUESTIONS = [
    {"id": 1, "dimension": "product_sense",       "text": "Our Quick-Commerce app saw a 15% drop in checkout completions, but 'Add to Cart' is stable. Walk me through your first three steps to find the root cause."},
    {"id": 2, "dimension": "product_sense",       "text": "We want to launch a 'Subscription' model for daily milk/bread. What is the smallest MVP you would launch to test if users actually want this?"},
    {"id": 3, "dimension": "analytical_thinking", "text": "For a Dark Store Operations tool, what is the single most important North Star metric? Why is 'Total Order Volume' a dangerous primary metric?"},
    {"id": 4, "dimension": "analytical_thinking", "text": "A feature improves search accuracy by 10% but adds 300ms of latency. How do you decide whether to ship it?"},
    {"id": 5, "dimension": "technical_fluency",   "text": "A customer reports that their real-time rider tracking is lagging by 2 minutes. Where are the likely technical bottlenecks?"},
    {"id": 6, "dimension": "technical_fluency",   "text": "We want to use AI to predict stock-outs 2 hours in advance. What 3 data points are most critical for this model?"},
    {"id": 7, "dimension": "execution",            "text": "At 9:00 AM, the Payment Gateway is failing for 10% of users. You also have a major feature launch at 10:00 AM. What is your immediate triage plan?"},
    {"id": 8, "dimension": "execution",            "text": "A powerful stakeholder insists on a 'Social Feed' feature that you believe adds clutter. How do you use data to say 'No' or 'Not Now'?"},
    {"id": 9, "dimension": "strategy",             "text": "A competitor launches 10-minute delivery in your zone where you take 20 minutes. Do you match their speed or pivot? Why?"},
    {"id": 10, "dimension": "strategy",            "text": "If you had to kill one secondary feature to make the core app 2x faster, which would you pick and how would you justify it?"},
]

CALIBRATIONS = {
    "product_sense": "Q1 calibration: Suggests data segmentation (New vs Repeat users), technical health checks (payment gateway success rates), user session replays. Q2 calibration: Proposes Painted Door test or manual WhatsApp pilot to test commitment before building automated billing.",
    "analytical_thinking": "Q3 calibration: Identifies Perfect Order Rate (On-time + In-full) as NSM. Explains high volume with high returns destroys unit economics. Q4 calibration: Recommends A/B test on Search-to-Cart Conversion, calculates if accuracy lift outweighs bounce rate from lag.",
    "technical_fluency": "Q5 calibration: Mentions GPS polling frequency, WebSocket latency, database write delays. Q6 calibration: Real-time sales velocity, incoming supply transit status, external factors like weather or traffic spikes.",
    "execution": "Q7 calibration: Immediate pause on launch. Clear stakeholder and user communication. 100% focus on payment fix before growth. Q8 calibration: Uses Cost of Delay or Value vs Complexity framework. Suggests small experiment to prove/disprove stakeholder hypothesis.",
    "strategy": "Q9 calibration: Analyzes unit economics. If 10-min is unsustainable, pivots to Assortment Breadth or Price Leadership. Q10 calibration: Targets high-weight/low-value features like video banners or legacy loyalty animations to optimize path to purchase.",
}

WEIGHTS = {
    "product_sense": 0.25,
    "analytical_thinking": 0.25,
    "technical_fluency": 0.20,
    "execution": 0.20,
    "strategy": 0.10,
}

SYSTEM_PROMPT = """You are a senior PM hiring manager scoring a PM candidate's answers on a 1-4 scale. Score only on reasoning quality, not on perfect answers.
Score 4: Shows structured thinking, correct framework, anticipates trade-offs.
Score 3: Shows correct instinct, partial framework, misses one key consideration.
Score 2: Answer is vague or generic, no clear reasoning structure.
Score 1: Irrelevant or off-topic answer.
Return ONLY a JSON object: { "score": number, "feedback": "string (max 30 words)", "strength": "string (10 words)", "gap": "string (10 words)" }"""

SYSTEM_PROMPT_WITH_RESUME = """You are a senior PM hiring manager scoring a PM candidate on a 1-4 scale.
You have their self-assessment answers AND their resume. Use both to score.
Score 4: Strong reasoning AND resume shows real PM experience validating the answer.
Score 3: Good reasoning but resume shows limited PM exposure, or strong resume with partial reasoning.
Score 2: Vague reasoning or resume shows minimal relevant PM experience.
Score 1: Irrelevant answer or no relevant experience in either.
Return ONLY a JSON object: { "score": number, "feedback": "string (max 30 words)", "strength": "string (10 words)", "gap": "string (10 words)" }"""


async def extract_resume_text(file: UploadFile) -> str:
    """Extract plain text from an uploaded PDF or DOCX resume."""
    content = await file.read()
    name = (file.filename or "").lower()
    text = ""
    if name.endswith(".pdf"):
        try:
            from pypdf import PdfReader
            reader = PdfReader(io.BytesIO(content))
            for page in reader.pages:
                page_text = page.extract_text()
                if page_text:
                    text += page_text + "\n"
        except Exception:
            text = ""
    elif name.endswith(".docx"):
        try:
            import zipfile, re
            with zipfile.ZipFile(io.BytesIO(content)) as z:
                with z.open("word/document.xml") as f:
                    xml = f.read().decode("utf-8")
                    text = re.sub(r"<[^>]+>", " ", xml)
                    text = re.sub(r"\s+", " ", text).strip()
        except Exception:
            text = ""
    return text[:3000]  # cap to avoid blowing token budget


class AnswerItem(BaseModel):
    dimension: str
    answer: str


class ScoreRequest(BaseModel):
    answers: List[AnswerItem]


def _safe_parse(text: str) -> dict:
    """Extract JSON from Claude's response even if it adds surrounding text."""
    text = text.strip()
    start = text.find("{")
    end = text.rfind("}") + 1
    if start != -1 and end > start:
        try:
            return json.loads(text[start:end])
        except json.JSONDecodeError:
            pass
    return {"score": 2, "feedback": "Could not parse response.", "strength": "N/A", "gap": "N/A"}


def _score_dimension(dimension: str, answer1: str, answer2: str) -> dict:
    q_texts = [q["text"] for q in QUESTIONS if q["dimension"] == dimension]
    user_message = (
        f"Dimension: {dimension}\n"
        f"Question 1: {q_texts[0]}\n"
        f"Answer 1: {answer1}\n\n"
        f"Question 2: {q_texts[1]}\n"
        f"Answer 2: {answer2}\n\n"
        f"Calibration context: {CALIBRATIONS[dimension]}"
    )
    response = client.messages.create(
        model="claude-3-5-haiku-20241022",
        max_tokens=256,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": user_message}],
    )
    return _safe_parse(response.content[0].text)


def _score_dimension_with_resume(dimension: str, answer1: str, answer2: str, resume_text: str) -> dict:
    q_texts = [q["text"] for q in QUESTIONS if q["dimension"] == dimension]
    user_message = (
        f"RESUME:\n{resume_text}\n\n"
        f"Dimension: {dimension}\n"
        f"Question 1: {q_texts[0]}\n"
        f"Answer 1: {answer1}\n\n"
        f"Question 2: {q_texts[1]}\n"
        f"Answer 2: {answer2}\n\n"
        f"Calibration context: {CALIBRATIONS[dimension]}"
    )
    response = client.messages.create(
        model="claude-3-5-haiku-20241022",
        max_tokens=256,
        system=SYSTEM_PROMPT_WITH_RESUME,
        messages=[{"role": "user", "content": user_message}],
    )
    return _safe_parse(response.content[0].text)


def _build_result(dimensions: dict) -> dict:
    """Compute overall score, archetype, and zone from dimension scores."""
    raw = sum(dimensions[d]["score"] * WEIGHTS[d] for d in WEIGHTS)
    overall_score = round(((raw - 1) / 3) * 100)

    ps = dimensions["product_sense"]["score"]
    at = dimensions["analytical_thinking"]["score"]
    tf = dimensions["technical_fluency"]["score"]
    ex = dimensions["execution"]["score"]
    if ps + at >= tf + ex:
        archetype = "Growth PM"
    elif tf + ex > ps + at:
        archetype = "Operations PM"
    else:
        archetype = "General PM"

    if overall_score >= 80:
        zone = "job_ready"
    elif overall_score >= 60:
        zone = "fitment_with_gaps"
    else:
        zone = "foundational_gap"

    return {"dimensions": dimensions, "overallScore": overall_score, "archetype": archetype, "zone": zone}


@router.post("/score")
async def score_readiness(body: ScoreRequest):
    try:
        dim_answers: dict[str, list[str]] = {}
        for item in body.answers:
            dim_answers.setdefault(item.dimension, []).append(item.answer)

        loop = asyncio.get_running_loop()

        async def score_dim(dim):
            answers_for_dim = dim_answers.get(dim, ["", ""])
            a1 = answers_for_dim[0] if len(answers_for_dim) > 0 else ""
            a2 = answers_for_dim[1] if len(answers_for_dim) > 1 else ""
            result = await loop.run_in_executor(None, _score_dimension, dim, a1, a2)
            return dim, result

        results = await asyncio.gather(*[score_dim(dim) for dim in WEIGHTS])
        dimensions = {dim: result for dim, result in results}
        return _build_result(dimensions)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/score-with-resume")
async def score_readiness_with_resume(
    answers: str = Form(...),
    resume: UploadFile = File(...),
):
    try:
        answer_items = [AnswerItem(**a) for a in json.loads(answers)]
        resume_text = await extract_resume_text(resume)

        dim_answers: dict[str, list[str]] = {}
        for item in answer_items:
            dim_answers.setdefault(item.dimension, []).append(item.answer)

        loop = asyncio.get_running_loop()

        async def score_dim(dim):
            answers_for_dim = dim_answers.get(dim, ["", ""])
            a1 = answers_for_dim[0] if len(answers_for_dim) > 0 else ""
            a2 = answers_for_dim[1] if len(answers_for_dim) > 1 else ""
            if resume_text:
                result = await loop.run_in_executor(
                    None, _score_dimension_with_resume, dim, a1, a2, resume_text
                )
            else:
                result = await loop.run_in_executor(None, _score_dimension, dim, a1, a2)
            return dim, result

        results = await asyncio.gather(*[score_dim(dim) for dim in WEIGHTS])
        dimensions = {dim: result for dim, result in results}
        result = _build_result(dimensions)
        result["resumeUsed"] = bool(resume_text)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
