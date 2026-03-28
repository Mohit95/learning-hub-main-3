import React from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight } from 'lucide-react';

const DIMENSION_LABELS = {
  product_sense:       'Product Sense',
  analytical_thinking: 'Analytical Thinking',
  technical_fluency:   'Technical Fluency',
  execution:           'Execution & Prioritization',
  strategy:            'Strategy & Market Fit',
};

const DIMENSION_ORDER = ['product_sense', 'analytical_thinking', 'technical_fluency', 'execution', 'strategy'];

function dotColor(score) {
  if (score >= 3) return '#4ade80';
  if (score === 2) return '#f59e0b';
  return '#f87171';
}

function zoneColor(zone) {
  if (zone === 'job_ready')        return '#4ade80';
  if (zone === 'fitment_with_gaps') return '#f59e0b';
  return '#f87171';
}

function zoneBanner(zone) {
  if (zone === 'job_ready')        return "✅ You're Job Ready — share your results with potential employers";
  if (zone === 'fitment_with_gaps') return "⚡ Fitment with Gaps — your roadmap will focus on your weak dimensions";
  return "🔧 Foundational Gap — a structured 4-week path has been prepared for you";
}

export default function ReadinessScorecard() {
  const navigate = useNavigate();

  const raw = localStorage.getItem('assessmentResult');
  const result = raw ? JSON.parse(raw) : null;

  if (!result) {
    return (
      <div className="page animate-fade-in" style={{ maxWidth: '600px', margin: '0 auto', textAlign: 'center', paddingTop: '80px' }}>
        <p style={{ color: 'var(--text-secondary)', fontSize: '1rem', marginBottom: '24px' }}>
          No assessment data found. Please complete the diagnostic first.
        </p>
        <button className="btn-primary" onClick={() => navigate('/app/assessments')} style={{ padding: '10px 24px' }}>
          Go to Assessments
        </button>
      </div>
    );
  }

  const { dimensions, overallScore, zone } = result;
  const scoreColor = zoneColor(zone);

  return (
    <div className="page animate-fade-in" style={{ maxWidth: '900px', margin: '0 auto' }}>
      <button
        onClick={() => navigate('/app/readiness')}
        style={{ display: 'flex', alignItems: 'center', gap: '8px', background: 'none', border: 'none', color: 'var(--text-secondary)', cursor: 'pointer', marginBottom: '24px', fontSize: '0.9rem' }}
      >
        <ArrowLeft size={16} /> Back to Start
      </button>

      <div style={{ textAlign: 'center', marginBottom: '40px' }}>
        <h1 className="page-title" style={{ fontSize: '2rem', marginBottom: '8px' }}>Your Market Readiness Score</h1>
        <p style={{ color: 'var(--text-secondary)', fontSize: '1.05rem' }}>
          Based on your answers across 5 PM competency dimensions
        </p>
      </div>

      <div className="grid-2" style={{ marginBottom: '32px' }}>
        {/* Overall Score Circle */}
        <div className="glass-panel" style={{ padding: '40px 24px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
          <div style={{ position: 'relative', width: '160px', height: '160px', borderRadius: '50%', background: `conic-gradient(${scoreColor} ${overallScore}%, rgba(255,255,255,0.05) 0)`, display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: '24px' }}>
            <div style={{ width: '140px', height: '140px', borderRadius: '50%', background: 'var(--bg-secondary)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
              <span style={{ fontSize: '2.5rem', fontWeight: 800, color: scoreColor }}>{overallScore}%</span>
              <span style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Ready</span>
            </div>
          </div>
          <p style={{ textAlign: 'center', color: 'var(--text-secondary)', fontSize: '0.95rem', lineHeight: 1.6 }}>
            You meet approximately {overallScore}% of the signals expected for a Product Manager role based on your diagnostic answers.
          </p>
        </div>

        {/* Competency Breakdown */}
        <div className="glass-panel" style={{ padding: '32px' }}>
          <h3 style={{ fontSize: '1.1rem', fontWeight: 600, marginBottom: '24px' }}>Competency Breakdown</h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
            {DIMENSION_ORDER.map(dim => {
              const d = dimensions[dim];
              if (!d) return null;
              const fillPct = (d.score / 4) * 100;
              const color = dotColor(d.score);
              return (
                <div key={dim}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px', alignItems: 'center' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '0.9rem', fontWeight: 500 }}>
                      <div style={{ width: '10px', height: '10px', borderRadius: '50%', background: color, flexShrink: 0 }} />
                      {DIMENSION_LABELS[dim]}
                    </div>
                    <span style={{ fontWeight: 600, fontSize: '0.85rem', color }}>{d.score} / 4</span>
                  </div>
                  <div style={{ height: '8px', background: 'rgba(255,255,255,0.05)', borderRadius: '4px', overflow: 'hidden' }}>
                    <div style={{ height: '100%', background: color, width: `${fillPct}%`, borderRadius: '4px', transition: 'width 0.6s ease' }} />
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* Dimension Insights */}
      <h3 style={{ fontSize: '1.25rem', fontWeight: 600, marginBottom: '16px' }}>Dimension Insights</h3>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', marginBottom: '32px' }}>
        {DIMENSION_ORDER.map(dim => {
          const d = dimensions[dim];
          if (!d) return null;
          return (
            <div key={dim} className="glass-panel" style={{ padding: '20px 24px' }}>
              <div style={{ fontWeight: 600, fontSize: '0.9rem', marginBottom: '8px' }}>{DIMENSION_LABELS[dim]}</div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', margin: 0 }}>
                  💪 <strong>Strength:</strong> {d.strength}
                </p>
                <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', margin: 0 }}>
                  🎯 <strong>Gap:</strong> {d.gap}
                </p>
                {d.feedback && (
                  <p style={{ fontSize: '0.78rem', color: 'var(--text-secondary)', fontStyle: 'italic', margin: '4px 0 0 0', opacity: 0.8 }}>
                    {d.feedback}
                  </p>
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* Zone Banner */}
      <div style={{ padding: '16px 24px', borderRadius: '12px', background: `${zoneColor(zone)}18`, border: `1px solid ${zoneColor(zone)}40`, color: zoneColor(zone), fontWeight: 600, fontSize: '0.95rem', marginBottom: '32px', textAlign: 'center' }}>
        {zoneBanner(zone)}
      </div>

      {/* CTA */}
      <div style={{ display: 'flex', justifyContent: 'flex-end' }}>
        <button
          className="btn-primary"
          onClick={() => navigate('/app/gap-analysis')}
          style={{ display: 'flex', alignItems: 'center', gap: '8px', padding: '12px 28px' }}
        >
          Continue to Gap Analysis <ArrowRight size={16} />
        </button>
      </div>
    </div>
  );
}
