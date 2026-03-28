from fastapi import APIRouter, Depends, HTTPException, Header
from pydantic import BaseModel
from typing import Optional
from dependencies import get_current_user
from services.supabase_client import supabase_admin
from services.interview_rag import (
    generate_opening_question,
    generate_follow_up,
    search_knowledge_base,
    evaluate_session,
    MAX_TURNS,
)

router = APIRouter(prefix="/api/interview", tags=["Interview"])

VALID_TYPES = {"product_design", "strategy", "analytical", "behavioural"}
MOCK_USER_ID = "00000000-0000-0000-0000-000000000001"


# ── Pydantic models ────────────────────────────────────────────────────────────

class CreateSessionRequest(BaseModel):
    interview_type: str
    profile_id: Optional[str] = None   # used in auth-bypass / dev mode

class MessageRequest(BaseModel):
    content: str


# ── Helper ─────────────────────────────────────────────────────────────────────

def _resolve_user_id(authorization: Optional[str], fallback_id: Optional[str]) -> Optional[str]:
    """Return real user ID from JWT if present. Returns None for demo/anonymous users."""
    if authorization and authorization.startswith("Bearer "):
        try:
            token = authorization.split(" ")[1]
            from supabase import create_client
            from config import settings
            client = create_client(settings.supabase_url, settings.supabase_anon_key)
            user_response = client.auth.get_user(token)
            if user_response.user and str(user_response.user.id) != MOCK_USER_ID:
                return str(user_response.user.id)
        except Exception:
            pass
    # Return None for demo user or missing auth — stored as NULL in DB
    if fallback_id and fallback_id != MOCK_USER_ID:
        return fallback_id
    return None

def _get_session_or_404(session_id: str, user_id: Optional[str]) -> dict:
    query = supabase_admin.table("interview_sessions").select("*").eq("id", session_id)
    # For authenticated users, scope to their user_id; demo sessions (NULL) are found by session_id only
    if user_id:
        query = query.eq("user_id", user_id)
    res = query.single().execute()
    if not res.data:
        raise HTTPException(status_code=404, detail="Session not found.")
    return res.data

def _get_messages(session_id: str) -> list[dict]:
    res = supabase_admin.table("interview_messages") \
        .select("role, content") \
        .eq("session_id", session_id) \
        .order("created_at") \
        .execute()
    return res.data or []


# ── 1. Create session ──────────────────────────────────────────────────────────

@router.post("/sessions")
def create_session(
    body: CreateSessionRequest,
    authorization: Optional[str] = Header(None),
):
    if body.interview_type not in VALID_TYPES:
        raise HTTPException(status_code=400, detail=f"Invalid interview_type. Must be one of: {VALID_TYPES}")

    user_id = _resolve_user_id(authorization, body.profile_id)

    try:
        # Create session row
        session_res = supabase_admin.table("interview_sessions").insert({
            "user_id": user_id,
            "interview_type": body.interview_type,
            "status": "active",
            "turn_count": 0,
        }).execute()
        session = session_res.data[0]
        session_id = session["id"]

        # Generate opening question
        question = generate_opening_question(body.interview_type)

        # Save to messages
        supabase_admin.table("interview_messages").insert({
            "session_id": session_id,
            "role": "assistant",
            "content": question,
        }).execute()

        return {"session_id": session_id, "question": question, "turn": 1}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to create session: {str(e)}")


# ── 2. Send a message and get follow-up ───────────────────────────────────────

@router.post("/sessions/{session_id}/message")
def send_message(
    session_id: str,
    body: MessageRequest,
    authorization: Optional[str] = Header(None),
):
    if not body.content.strip():
        raise HTTPException(status_code=400, detail="Message content cannot be empty.")

    user_id = _resolve_user_id(authorization, None)

    try:
        session = _get_session_or_404(session_id, user_id)

        if session["status"] == "completed":
            raise HTTPException(status_code=400, detail="Session is already completed.")

        current_turn = session["turn_count"] + 1

        # Save student's answer
        supabase_admin.table("interview_messages").insert({
            "session_id": session_id,
            "role": "user",
            "content": body.content,
        }).execute()

        # Update turn count
        supabase_admin.table("interview_sessions") \
            .update({"turn_count": current_turn}) \
            .eq("id", session_id) \
            .execute()

        # Get full history for context
        history = _get_messages(session_id)
        openai_history = [{"role": m["role"], "content": m["content"]} for m in history]

        # Search KB for relevant context
        kb_chunks = search_knowledge_base(body.content, session["interview_type"])

        # Generate follow-up question
        follow_up = generate_follow_up(
            history=openai_history,
            kb_chunks=kb_chunks,
            interview_type=session["interview_type"],
            turn=current_turn,
        )

        # Save AI follow-up
        supabase_admin.table("interview_messages").insert({
            "session_id": session_id,
            "role": "assistant",
            "content": follow_up,
        }).execute()

        is_final = current_turn >= MAX_TURNS

        return {
            "question": follow_up,
            "turn": current_turn,
            "is_final": is_final,
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to process message: {str(e)}")


# ── 3. Complete session and get score ─────────────────────────────────────────

@router.post("/sessions/{session_id}/complete")
def complete_session(
    session_id: str,
    authorization: Optional[str] = Header(None),
):
    user_id = _resolve_user_id(authorization, None)
    try:
        session = _get_session_or_404(session_id, user_id)

        if session["status"] == "completed":
            # Already done — return existing result
            return {
                "score": session["score"],
                "strengths": session["strengths"],
                "gaps": session["gaps"],
                "summary": session["feedback"],
            }

        history = _get_messages(session_id)
        openai_history = [{"role": m["role"], "content": m["content"]} for m in history]

        # Generate evaluation
        evaluation = evaluate_session(openai_history, session["interview_type"])

        # Persist result
        from datetime import datetime, timezone
        supabase_admin.table("interview_sessions").update({
            "status": "completed",
            "score": evaluation.get("score"),
            "strengths": evaluation.get("strengths", []),
            "gaps": evaluation.get("gaps", []),
            "feedback": evaluation.get("summary", ""),
            "completed_at": datetime.now(timezone.utc).isoformat(),
        }).eq("id", session_id).execute()

        return {
            "score": evaluation.get("score"),
            "strengths": evaluation.get("strengths", []),
            "gaps": evaluation.get("gaps", []),
            "summary": evaluation.get("summary", ""),
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to complete session: {str(e)}")


# ── 4. Get session history ────────────────────────────────────────────────────

@router.get("/sessions/{session_id}")
def get_session(
    session_id: str,
    authorization: Optional[str] = Header(None),
):
    user_id = _resolve_user_id(authorization, None)
    try:
        session = _get_session_or_404(session_id, user_id)
        messages = _get_messages(session_id)
        return {**session, "messages": messages}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch session: {str(e)}")


# ── 5. List user's past sessions ──────────────────────────────────────────────

@router.get("/sessions")
def list_sessions(authorization: Optional[str] = Header(None)):
    user_id = _resolve_user_id(authorization, None)
    try:
        res = supabase_admin.table("interview_sessions") \
            .select("id, interview_type, status, score, turn_count, created_at, completed_at") \
            .eq("user_id", user_id) \
            .order("created_at", desc=True) \
            .execute()
        return res.data or []
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to list sessions: {str(e)}")
