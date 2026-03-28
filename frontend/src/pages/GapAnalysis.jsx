import { useEffect, useState } from 'react';
import { ArrowRight, Map } from 'lucide-react';
import { useAuthStore } from '../store/authStore';
import { getGapAnalysis, getRoadmap } from '../services/supabase';
import { MOCK_GAP_ANALYSIS } from '../data/mockGapAnalysis';

import ArchetypeReveal from '../components/gap-analysis/ArchetypeReveal';
import ReadinessScore from '../components/gap-analysis/ReadinessScore';
import GapChart from '../components/gap-analysis/GapChart';
import ResumeAnalysisBadge from '../components/gap-analysis/ResumeAnalysisBadge';
import RoadmapCTA from '../components/gap-analysis/RoadmapCTA';
import EmptyState from '../components/gap-analysis/EmptyState';

const DIMENSION_LABELS = {
  product_sense:       'Product Sense',
  analytical_thinking: 'Analytical Thinking',
  technical_fluency:   'Technical Fluency',
  execution:           'Execution & Prioritization',
  strategy:            'Strategy & Market Fit',
};

const ARCHETYPE_META = {
  'Growth PM': {
    icon: 'trending-up',
    tagline: 'You thrive at the intersection of data and user growth.',
    reason: 'Your strongest signals are in Product Sense and Analytical Thinking. Growth PMs excel at defining user problems and driving metric-based decisions.',
  },
  'Operations PM': {
    icon: 'cpu',
    tagline: 'You bridge execution and technical depth.',
    reason: 'Your strongest signals are in Technical Fluency and Execution. Operations PMs excel at system reliability, stakeholder management, and shipping on time.',
  },
  'General PM': {
    icon: 'compass',
    tagline: 'You are a versatile PM who can adapt across domains.',
    reason: 'You showed balanced competency across all 5 dimensions. General PMs are versatile across product strategy, execution, and analytics.',
  },
};

function buildFromAssessment(ar) {
  const dims = ar.dimensions;

  // gap_profile — scale 1-4 score to 0-10, required = 8, sort by highest gap first
  const gap_profile = Object.entries(dims)
    .map(([dim, d]) => ({
      skill: DIMENSION_LABELS[dim] || dim,
      current: Math.round((d.score / 4) * 10 * 10) / 10,
      required: 8,
    }))
    .sort((a, b) => (b.required - b.current) - (a.required - a.current));

  // readiness — map 5 dims to 3 sub-score buckets
  const readiness = {
    overall: ar.overallScore,
    sub_scores: {
      strategic_thinking: Math.round(((dims.analytical_thinking.score + dims.strategy.score) / 8) * 100),
      technical_proficiency: Math.round((dims.technical_fluency.score / 4) * 100),
      execution_delivery: Math.round((dims.execution.score / 4) * 100),
    },
  };

  // resume_skills — replace chips with single assessment badge
  const resume_skills = {
    match_percentage: ar.overallScore,
    extracted: ['5 dimensions assessed'],
  };

  // archetypes — compute per-archetype scores from dimension pairs
  const growthScore  = Math.round(((dims.product_sense.score + dims.analytical_thinking.score) / 8) * 100);
  const opsScore     = Math.round(((dims.technical_fluency.score + dims.execution.score) / 8) * 100);
  const generalScore = ar.overallScore;

  const archetypes = [
    { name: 'Growth PM',     score: growthScore,  ...ARCHETYPE_META['Growth PM'] },
    { name: 'Operations PM', score: opsScore,      ...ARCHETYPE_META['Operations PM'] },
    { name: 'General PM',    score: generalScore,  ...ARCHETYPE_META['General PM'] },
  ];

  return { readiness, gap_profile, resume_skills, archetypes };
}

export default function GapAnalysis() {
  const { user } = useAuthStore();
  const [result, setResult] = useState(null);
  const [hasRoadmap, setHasRoadmap] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Toggle this to false when backend is connected
  const USE_MOCK = true;

  // Read assessment result from localStorage
  const storedAssessment = (() => {
    try { return JSON.parse(localStorage.getItem('assessmentResult')); } catch { return null; }
  })();

  useEffect(() => {
    if (!user) return;

    const load = async () => {
      setLoading(true);
      try {
        // If assessment data exists in localStorage, use it regardless of USE_MOCK
        if (storedAssessment) {
          setResult(buildFromAssessment(storedAssessment));
          setHasRoadmap(false);
        } else if (USE_MOCK) {
          setResult(MOCK_GAP_ANALYSIS);
          setHasRoadmap(false);
        } else {
          const [analysisRes, roadmapRes] = await Promise.all([
            getGapAnalysis(user.id),
            getRoadmap(user.id),
          ]);

          if (analysisRes.error) throw analysisRes.error;

          let parsed = analysisRes.data?.result_json;
          if (typeof parsed === 'string') {
            try { parsed = JSON.parse(parsed); } catch { parsed = null; }
          }

          setResult(parsed || null);
          setHasRoadmap(!!roadmapRes.data);
        }
      } catch {
        setError('Failed to load gap analysis.');
      } finally {
        setLoading(false);
      }
    };

    load();
  }, [user]);

  if (loading) {
    return (
      <div className="page" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '400px' }}>
        <div className="loading-pulse" style={{ color: 'var(--text-secondary)' }}>Loading gap analysis...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="page">
        <div style={{ color: '#f87171' }}>{error}</div>
      </div>
    );
  }

  if (!result) {
    return (
      <div className="page animate-fade-in" style={{ opacity: 1 }}>
        <h1 className="page-title">Gap Analysis</h1>
        <EmptyState />
      </div>
    );
  }

  return (
    <div className="page animate-fade-in" style={{ opacity: 1 }}>
      {/* Page header */}
      <div style={{ marginBottom: '32px' }}>
        <h1 className="page-title" style={{ marginBottom: '8px' }}>Gap Analysis</h1>
        <p style={{ color: 'var(--text-secondary)' }}>
          AI-powered analysis of your PM skill profile based on your assessment results.
        </p>
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '24px' }}>
        {/* 1. Readiness Score + Build My Roadmap CTA — side by side */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))', gap: '24px' }}>
          <div className="animate-fade-in delay-100">
            <ReadinessScore readiness={result.readiness} />
          </div>

          {/* Build My Roadmap quick-CTA */}
          <div className="animate-fade-in delay-200">
            <div
              className="glass-panel"
              style={{
                padding: '28px',
                height: '100%',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
                background: 'linear-gradient(135deg, rgba(59,130,246,0.07), rgba(139,92,246,0.07))',
                borderColor: 'rgba(139,92,246,0.25)',
              }}
            >
              <div>
                <div style={{
                  width: '44px', height: '44px', borderRadius: '12px', marginBottom: '16px',
                  background: 'linear-gradient(135deg, var(--accent-electric), var(--accent-violet))',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <Map size={22} color="#fff" />
                </div>
                <h3 style={{ fontSize: '1.05rem', fontWeight: 700, marginBottom: '8px' }}>
                  Ready to build your roadmap?
                </h3>
                <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', lineHeight: 1.65, margin: 0 }}>
                  Your archetype match and skill gaps are ready. Choose your learning path and generate your personalised PM roadmap below.
                </p>
              </div>
              <button
                className="btn-primary"
                onClick={() => document.getElementById('roadmap-cta')?.scrollIntoView({ behavior: 'smooth', block: 'start' })}
                style={{
                  marginTop: '24px', width: '100%', borderRadius: '10px',
                  padding: '13px 20px', border: 'none', cursor: 'pointer',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  gap: '8px', fontSize: '0.9rem', fontWeight: 700,
                }}
              >
                Build My Roadmap <ArrowRight size={16} />
              </button>
            </div>
          </div>
        </div>

        {/* 2. Resume Skills Match — moved below */}
        <div className="animate-fade-in delay-100">
          <ResumeAnalysisBadge resumeSkills={result.resume_skills} />
        </div>

        {/* 3. Archetype Reveal */}
        <div className="animate-fade-in">
          <ArchetypeReveal archetypes={result.archetypes} />
        </div>

        {/* 4. Gap Profile Chart */}
        <div className="animate-fade-in delay-100">
          <GapChart gapProfile={result.gap_profile} />
        </div>

        {/* 5. Roadmap CTA */}
        <div id="roadmap-cta" className="animate-fade-in delay-300">
          <RoadmapCTA hasRoadmap={hasRoadmap} archetypes={result.archetypes ?? []} />
        </div>
      </div>
    </div>
  );
}
