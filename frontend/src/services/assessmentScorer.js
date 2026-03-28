const API = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000';

/**
 * Score all 10 readiness answers via the backend (which calls Claude).
 * @param {Array<{dimension: string, answer: string}>} answers
 * @returns {Promise<{dimensions, overallScore, archetype, zone}>}
 */
async function attempt(answers) {
  const res = await fetch(`${API}/api/readiness/score`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ answers }),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.detail || 'Scoring failed');
  }
  return res.json();
}

export async function scoreAssessment(answers) {
  // Retry up to 3 times with increasing delays — handles Railway cold start (can take 15-20s)
  const delays = [6000, 10000];
  let lastErr;
  for (let i = 0; i <= delays.length; i++) {
    try {
      const result = await attempt(answers);
      localStorage.setItem('assessmentResult', JSON.stringify(result));
      return result;
    } catch (err) {
      lastErr = err;
      if (i < delays.length) await new Promise(r => setTimeout(r, delays[i]));
    }
  }
  throw lastErr;
}
