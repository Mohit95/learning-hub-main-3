import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { TrendingUp, Cpu, Compass, Layers, ArrowRight, Trophy, AlertTriangle } from 'lucide-react';

const ICON_MAP = {
  'trending-up': TrendingUp,
  cpu: Cpu,
  compass: Compass,
  layers: Layers,
};

const STYLES = `
@keyframes ctaPulse {
  0%   { transform: scale(1);    opacity: 0.7; }
  50%  { transform: scale(1.05); opacity: 0.3; }
  100% { transform: scale(1);    opacity: 0.7; }
}
@keyframes shimmer {
  0%   { background-position: -200% center; }
  100% { background-position: 200% center; }
}
@keyframes drawCheck {
  from { stroke-dashoffset: 50; }
  to   { stroke-dashoffset: 0; }
}
@keyframes fillProgress {
  from { width: 0%; }
  to   { width: 100%; }
}
@keyframes modalScaleIn {
  from { transform: scale(0.9); opacity: 0; }
  to   { transform: scale(1);   opacity: 1; }
}
`;

export default function RoadmapCTA({ hasRoadmap = false, archetypes = [] }) {
  const navigate = useNavigate();
  const sorted = [...archetypes].sort((a, b) => b.score - a.score);
  const bestFit = sorted[0];

  const [selectedName, setSelectedName] = useState(bestFit?.name ?? null);
  const [pulseActive, setPulseActive] = useState(true);
  const [shimmer, setShimmer] = useState(false);
  const [showWarningModal, setShowWarningModal] = useState(false);
  const [showCelebrationModal, setShowCelebrationModal] = useState(false);

  // Stop pulse ring after 3 cycles (~6s at 2s each)
  useEffect(() => {
    const t = setTimeout(() => setPulseActive(false), 6000);
    return () => clearTimeout(t);
  }, []);

  // Shimmer plays once after 500ms delay on mount
  useEffect(() => {
    const t = setTimeout(() => setShimmer(true), 500);
    return () => clearTimeout(t);
  }, []);

  // Auto-navigate to curriculum after celebration progress bar completes (1.8s)
  useEffect(() => {
    if (!showCelebrationModal) return;
    const t = setTimeout(() => navigate('/app/curriculum'), 1800);
    return () => clearTimeout(t);
  }, [showCelebrationModal, navigate]);

  const triggerCelebration = (archetypeName) => {
    localStorage.setItem('selectedArchetype', archetypeName);
    setShowCelebrationModal(true);
  };

  const handleBuildRoadmap = () => {
    if (selectedName === bestFit?.name) {
      triggerCelebration(selectedName);
    } else {
      setShowWarningModal(true);
    }
  };

  // Fallback if no archetypes provided
  if (!archetypes.length) {
    return (
      <div
        className="glass-panel"
        style={{
          padding: '32px',
          textAlign: 'center',
          background: 'linear-gradient(135deg, rgba(59,130,246,0.08), rgba(139,92,246,0.08))',
          borderColor: 'rgba(139,92,246,0.2)',
        }}
      >
        <h3 style={{ fontSize: '1.2rem', fontWeight: 700, marginBottom: '8px' }}>
          {hasRoadmap ? 'Your Roadmap is Ready' : 'Build Your Personalized Roadmap'}
        </h3>
        <button
          className="btn-primary"
          onClick={() => navigate('/app/curriculum')}
          style={{ borderRadius: '10px', padding: '14px 32px', display: 'inline-flex', alignItems: 'center', gap: '8px', border: 'none', cursor: 'pointer' }}
        >
          {hasRoadmap ? 'View Your Roadmap' : 'Build My Roadmap'} <ArrowRight size={18} />
        </button>
      </div>
    );
  }

  return (
    <>
      <style>{STYLES}</style>

      {/* ── Celebration Modal (full-screen overlay) ── */}
      {showCelebrationModal && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            zIndex: 50,
            background: 'rgba(0,0,0,0.78)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '18px', padding: '40px' }}>
            {/* Animated checkmark */}
            <svg width="84" height="84" viewBox="0 0 84 84">
              <circle cx="42" cy="42" r="38" fill="none" stroke="#4ade80" strokeWidth="4" />
              <polyline
                points="25,42 37,54 59,30"
                fill="none"
                stroke="#4ade80"
                strokeWidth="5"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeDasharray="50"
                strokeDashoffset="50"
                style={{ animation: 'drawCheck 0.6s ease forwards 0.25s' }}
              />
            </svg>

            <h2 style={{ fontSize: '1.5rem', fontWeight: 700, color: '#fff', margin: 0 }}>
              Congratulations! 🎉
            </h2>
            <p style={{ fontSize: '0.875rem', color: '#d1d5db', margin: 0, textAlign: 'center' }}>
              Your personalized <strong style={{ color: '#fff' }}>{selectedName}</strong> roadmap is ready.
            </p>

            {/* Progress bar */}
            <div
              style={{
                width: '240px',
                height: '4px',
                borderRadius: '9999px',
                background: 'rgba(255,255,255,0.1)',
                overflow: 'hidden',
                marginTop: '6px',
              }}
            >
              <div
                style={{
                  height: '100%',
                  borderRadius: '9999px',
                  background: 'linear-gradient(90deg, var(--accent-electric), var(--accent-violet))',
                  animation: 'fillProgress 1.8s ease forwards',
                }}
              />
            </div>
          </div>
        </div>
      )}

      {/* ── Warning Modal (centered card) ── */}
      {showWarningModal && (
        <div
          style={{
            position: 'fixed',
            inset: 0,
            zIndex: 50,
            background: 'rgba(0,0,0,0.6)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '20px',
          }}
        >
          <div
            style={{
              background: '#1a1f36',
              borderRadius: '16px',
              padding: '32px',
              maxWidth: '420px',
              width: '100%',
              boxShadow: '0 25px 50px rgba(0,0,0,0.5)',
              border: '1px solid rgba(255,255,255,0.08)',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              gap: '16px',
              animation: 'modalScaleIn 200ms ease-out forwards',
            }}
          >
            {/* Amber warning icon */}
            <div
              style={{
                width: '52px',
                height: '52px',
                borderRadius: '50%',
                background: 'rgba(251,191,36,0.15)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <AlertTriangle size={26} style={{ color: '#fbbf24' }} />
            </div>

            <h3 style={{ fontSize: '1.125rem', fontWeight: 600, color: '#fff', margin: 0 }}>
              Heads up!
            </h3>

            <p style={{ fontSize: '0.875rem', color: '#9ca3af', margin: 0, textAlign: 'center', lineHeight: 1.6 }}>
              Your assessment suggests{' '}
              <strong style={{ color: '#fff' }}>{bestFit?.name}</strong> is your strongest match
              (score: {bestFit?.score}). Switching to{' '}
              <strong style={{ color: '#fff' }}>{selectedName}</strong> is totally valid — but you
              may find some modules more challenging early on.
            </p>

            <div style={{ display: 'flex', gap: '12px', width: '100%', marginTop: '4px' }}>
              <button
                onClick={() => {
                  setShowWarningModal(false);
                  triggerCelebration(selectedName);
                }}
                style={{
                  flex: 1,
                  padding: '12px',
                  borderRadius: '10px',
                  border: '1.5px solid rgba(255,255,255,0.3)',
                  background: 'transparent',
                  color: '#fff',
                  fontSize: '0.875rem',
                  fontWeight: 600,
                  cursor: 'pointer',
                  fontFamily: 'inherit',
                  transition: 'border-color 0.2s',
                }}
                onMouseEnter={(e) => (e.currentTarget.style.borderColor = 'rgba(255,255,255,0.6)')}
                onMouseLeave={(e) => (e.currentTarget.style.borderColor = 'rgba(255,255,255,0.3)')}
              >
                Switch Anyway
              </button>

              <button
                onClick={() => {
                  setSelectedName(bestFit?.name);
                  setShowWarningModal(false);
                }}
                style={{
                  flex: 1,
                  padding: '12px',
                  borderRadius: '10px',
                  border: 'none',
                  background: 'linear-gradient(135deg, var(--accent-electric), var(--accent-violet))',
                  color: '#fff',
                  fontSize: '0.875rem',
                  fontWeight: 600,
                  cursor: 'pointer',
                  fontFamily: 'inherit',
                }}
              >
                Take me to my best fit
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── Main card ── */}
      <div
        className="glass-panel"
        style={{
          padding: '28px',
          background: 'linear-gradient(135deg, rgba(59,130,246,0.06), rgba(139,92,246,0.06))',
          borderColor: 'rgba(139,92,246,0.2)',
        }}
      >
        {/* Heading */}
        <div style={{ marginBottom: '20px' }}>
          <h3 style={{ fontSize: '1.1rem', fontWeight: 700, marginBottom: '4px' }}>Choose Your Path</h3>
          <p style={{ fontSize: '0.82rem', color: 'var(--text-secondary)', margin: 0 }}>
            Your best fit is pre-selected. You can override it before building your roadmap.
          </p>
        </div>

        {/* 2×2 archetype pill grid */}
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '10px', marginBottom: '20px' }}>
          {sorted.map((arch) => {
            const Icon = ICON_MAP[arch.icon] || Compass;
            const isSelected = selectedName === arch.name;
            const isBestFit = arch.name === bestFit?.name;

            return (
              <div key={arch.name} style={{ position: 'relative' }}>
                {/* Pulse ring — best fit only while pulseActive */}
                {isBestFit && pulseActive && (
                  <div
                    style={{
                      position: 'absolute',
                      inset: '-3px',
                      borderRadius: '12px',
                      border: '2px solid rgba(139,92,246,0.5)',
                      animation: 'ctaPulse 2s ease-in-out 3',
                      pointerEvents: 'none',
                    }}
                  />
                )}

                <button
                  onClick={() => setSelectedName(arch.name)}
                  style={{
                    width: '100%',
                    textAlign: 'left',
                    cursor: 'pointer',
                    border: 'none',
                    outline: 'none',
                    borderRadius: '10px',
                    padding: '12px 14px',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '10px',
                    background: isSelected
                      ? 'linear-gradient(135deg, rgba(59,130,246,0.15), rgba(139,92,246,0.15))'
                      : 'rgba(255,255,255,0.03)',
                    boxShadow: isSelected
                      ? 'inset 0 0 0 1.5px rgba(139,92,246,0.6)'
                      : 'inset 0 0 0 1px rgba(255,255,255,0.07)',
                    transition: 'all 0.2s ease',
                  }}
                >
                  <div
                    style={{
                      width: '30px',
                      height: '30px',
                      borderRadius: '8px',
                      flexShrink: 0,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      background: isSelected
                        ? 'linear-gradient(135deg, var(--accent-electric), var(--accent-violet))'
                        : 'rgba(255,255,255,0.05)',
                    }}
                  >
                    <Icon size={15} color={isSelected ? '#fff' : 'var(--text-secondary)'} />
                  </div>

                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <span style={{
                        fontSize: '0.85rem',
                        fontWeight: 600,
                        color: isSelected ? 'var(--text-primary)' : 'var(--text-secondary)',
                        whiteSpace: 'nowrap',
                        overflow: 'hidden',
                        textOverflow: 'ellipsis',
                      }}>
                        {arch.name}
                      </span>
                      {isBestFit && (
                        <Trophy size={11} style={{ color: 'var(--accent-violet)', flexShrink: 0 }} />
                      )}
                    </div>
                  </div>

                  <span style={{
                    fontSize: '0.72rem',
                    fontWeight: 700,
                    padding: '2px 7px',
                    borderRadius: '9999px',
                    flexShrink: 0,
                    background: isSelected ? 'rgba(139,92,246,0.2)' : 'rgba(255,255,255,0.06)',
                    color: isSelected ? 'var(--accent-violet)' : 'var(--text-secondary)',
                  }}>
                    {arch.score}
                  </span>
                </button>
              </div>
            );
          })}
        </div>

        {/* CTA button */}
        <button
          className="btn-primary"
          onClick={handleBuildRoadmap}
          style={{
            width: '100%',
            borderRadius: '10px',
            padding: '14px 24px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
            fontSize: '0.95rem',
            fontWeight: 700,
            position: 'relative',
            overflow: 'hidden',
            border: 'none',
            cursor: 'pointer',
          }}
        >
          {shimmer && (
            <span
              style={{
                position: 'absolute',
                inset: 0,
                background: 'linear-gradient(105deg, transparent 40%, rgba(255,255,255,0.18) 50%, transparent 60%)',
                backgroundSize: '200% 100%',
                animation: 'shimmer 1.5s ease forwards',
                pointerEvents: 'none',
              }}
            />
          )}
          {hasRoadmap ? 'View Your Roadmap' : 'Build My Roadmap'}
          <ArrowRight size={18} />
        </button>

        {/* Reactive hint text */}
        <p style={{ textAlign: 'center', fontSize: '0.78rem', color: 'var(--text-secondary)', marginTop: '10px', marginBottom: 0 }}>
          Your roadmap will be tailored to the <strong style={{ color: 'var(--text-primary)' }}>{selectedName}</strong> path
        </p>
      </div>
    </>
  );
}
