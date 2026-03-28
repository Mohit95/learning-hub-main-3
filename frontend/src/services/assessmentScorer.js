const API = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000';

/**
 * Score all 10 readiness answers via the backend (which calls Claude).
 * @param {Array<{dimension: string, answer: string}>} answers
 * @returns {Promise<{dimensions, overallScore, archetype, zone}>}
 */
export async function scoreAssessment(answers) {
  const res = await fetch(`${API}/api/readiness/score`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ answers }),
  });

  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Scoring failed');
  }

  const result = await res.json();

  // Persist to localStorage so gap analysis and scorecard pages can read it
  localStorage.setItem('assessmentResult', JSON.stringify(result));

  return result;
}
