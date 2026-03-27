import { supabase } from './supabase';

const API = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000';

async function authHeaders() {
  const { data: session } = await supabase.auth.getSession();
  const token = session?.session?.access_token;
  return {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

/**
 * Create a new interview session.
 * Returns { session_id, question, turn: 1 }
 */
export async function createSession(interviewType, profileId) {
  const res = await fetch(`${API}/api/interview/sessions`, {
    method: 'POST',
    headers: await authHeaders(),
    body: JSON.stringify({ interview_type: interviewType, profile_id: profileId }),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Failed to create session');
  }
  return res.json();
}

/**
 * Send the student's answer and receive a follow-up question.
 * Returns { question, turn, is_final }
 */
export async function sendMessage(sessionId, content) {
  const res = await fetch(`${API}/api/interview/sessions/${sessionId}/message`, {
    method: 'POST',
    headers: await authHeaders(),
    body: JSON.stringify({ content }),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Failed to send message');
  }
  return res.json();
}

/**
 * Mark the session as complete and get the AI evaluation.
 * Returns { score, strengths, gaps, summary }
 */
export async function completeSession(sessionId) {
  const res = await fetch(`${API}/api/interview/sessions/${sessionId}/complete`, {
    method: 'POST',
    headers: await authHeaders(),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Failed to complete session');
  }
  return res.json();
}

/**
 * Get a session's full data including all messages.
 * Returns session object with messages[]
 */
export async function getSession(sessionId) {
  const res = await fetch(`${API}/api/interview/sessions/${sessionId}`, {
    headers: await authHeaders(),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Failed to fetch session');
  }
  return res.json();
}

/**
 * List the current user's past interview sessions.
 * Returns array of session summaries
 */
export async function listSessions() {
  const res = await fetch(`${API}/api/interview/sessions`, {
    headers: await authHeaders(),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Failed to list sessions');
  }
  return res.json();
}
