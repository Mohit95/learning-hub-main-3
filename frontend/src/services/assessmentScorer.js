const API = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000';

async function withRetry(fn) {
  const delays = [6000, 10000];
  let lastErr;
  for (let i = 0; i <= delays.length; i++) {
    try {
      const result = await fn();
      localStorage.setItem('assessmentResult', JSON.stringify(result));
      return result;
    } catch (err) {
      lastErr = err;
      if (i < delays.length) await new Promise(r => setTimeout(r, delays[i]));
    }
  }
  throw lastErr;
}

/** Score based on questionnaire answers only (no resume). */
export async function scoreAssessment(answers) {
  return withRetry(async () => {
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
  });
}

/** Score using both questionnaire answers and an uploaded resume file. */
export async function scoreAssessmentWithResume(answers, file) {
  return withRetry(async () => {
    const form = new FormData();
    form.append('answers', JSON.stringify(answers));
    form.append('resume', file);
    const res = await fetch(`${API}/api/readiness/score-with-resume`, {
      method: 'POST',
      body: form,
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({}));
      throw new Error(err.detail || 'Scoring failed');
    }
    return res.json();
  });
}
