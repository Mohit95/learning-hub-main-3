import { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { Lock } from 'lucide-react';

const API = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000';

const ARCHETYPE_META = {
  'Growth PM':    { color: '#22c55e', bg: 'rgba(34,197,94,0.1)',   emoji: '📈' },
  'Technical PM': { color: '#3b82f6', bg: 'rgba(59,130,246,0.1)', emoji: '⚙️' },
  'Consumer PM':  { color: '#a855f7', bg: 'rgba(168,85,247,0.1)', emoji: '🎯' },
  'AI / Data PM': { color: '#f59e0b', bg: 'rgba(245,158,11,0.1)', emoji: '🤖' },
};

const ARCHETYPE_NAME_MAP = {
  'Growth PM':  'Growth PM',
  'AI PM':      'AI / Data PM',
  'Tech PM':    'Technical PM',
  'General PM': 'Consumer PM',
};

const PHASE_LABELS = {
  1: 'Foundation',
  2: 'Craft',
  3: 'Domain Depth',
  4: 'Case Practice',
};

const LESSON_TYPE_LABEL = {
  video:   '▶ Video',
  reading: '📄 Reading',
  task:    '✏️ Task',
};

const REWARD_CONFIG = {
  phase1: {
    checkColor: '#4ade80',
    heading:    "Phase 1 Complete — You've earned your first resource!",
    body:       "Download your free copy of 'Inspired: How to Create Tech Products Customers Love' — a foundational PM book by Marty Cagan.",
    actionLabel: 'Download Free PDF →',
    actionHref:  'https://www.pdfdrive.com/inspired-how-to-create-products-customers-love-e158848654.html',
    subtext:    'A gift for completing your foundations week.',
    closeLabel: 'Continue Learning →',
    closeNav:   null,
    calendlyUrl: null,
  },
  phase2: {
    checkColor: '#a855f7',
    heading:    "Phase 2 Complete — You've unlocked a 1-on-1 session!",
    body:       "Book your 30-minute session with Dhirendra Mohan, Associate Product Manager. He'll review your Phase 2 work and help you prepare for specialization.",
    actionLabel: null,
    actionHref:  null,
    subtext:    null,
    closeLabel: "I'll book later →",
    closeNav:   null,
    calendlyUrl: 'https://calendly.com/dhirendra-mohan/30min',
  },
  phase3: {
    checkColor: '#3b82f6',
    heading:    'Phase 3 Complete — Validate your learning with an expert!',
    body:       "You've completed your specialization modules. Book a 15-minute session with a senior industry PM to share what you've built and get feedback before Phase 4.",
    actionLabel: 'Book 15-min Validation Call →',
    actionHref:  'https://calendly.com/learninghub-expert/15min',
    subtext:    'This session is about what you learned — come with your Phase 3 task outputs ready.',
    closeLabel: 'Book later →',
    closeNav:   null,
    calendlyUrl: null,
  },
  phase4: {
    checkColor: '#f59e0b',
    heading:    '🏆 Roadmap Complete — Final session with a Senior PM!',
    body:       "You've finished your full learning roadmap. Book your final 15-minute session with a Senior Product Manager to review your case practice outputs and get career guidance.",
    actionLabel: 'Book Senior PM Session →',
    actionHref:  'https://calendly.com/learninghub-senior-pm/15min',
    subtext:    'Bring your Phase 4 case write-ups. This session is your graduation moment.',
    closeLabel: 'Done →',
    closeNav:   '/app/dashboard',
    calendlyUrl: null,
  },
};

const MODAL_STYLES = `
@keyframes drawCheck {
  from { stroke-dashoffset: 50; }
  to   { stroke-dashoffset: 0; }
}
@keyframes rewardModalIn {
  from { transform: scale(0.9); opacity: 0; }
  to   { transform: scale(1);   opacity: 1; }
}
`;

function RewardModal({ phaseKey, onClose }) {
  const navigate = useNavigate();
  const cfg = REWARD_CONFIG[phaseKey];
  if (!cfg) return null;

  const handleClose = () => {
    onClose();
    if (cfg.closeNav) navigate(cfg.closeNav);
  };

  return (
    <>
      <style>{MODAL_STYLES}</style>
      <div style={{
        position: 'fixed', inset: 0, zIndex: 50,
        background: 'rgba(0,0,0,0.65)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: '20px',
      }}>
        <div style={{
          background: '#1a1f36',
          borderRadius: '20px',
          padding: '36px 32px 28px',
          maxWidth: '520px',
          width: '100%',
          boxShadow: '0 30px 60px rgba(0,0,0,0.6)',
          border: '1px solid rgba(255,255,255,0.08)',
          animation: 'rewardModalIn 220ms ease-out forwards',
          maxHeight: '90vh',
          overflowY: 'auto',
        }}>

          {/* Animated checkmark */}
          <div style={{ display: 'flex', justifyContent: 'center', marginBottom: '20px' }}>
            <svg width="72" height="72" viewBox="0 0 72 72">
              <circle cx="36" cy="36" r="32" fill="none" stroke={cfg.checkColor} strokeWidth="3.5" />
              <polyline
                points="22,36 32,46 50,26"
                fill="none"
                stroke={cfg.checkColor}
                strokeWidth="4.5"
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeDasharray="50"
                strokeDashoffset="50"
                style={{ animation: 'drawCheck 0.55s ease forwards 0.2s' }}
              />
            </svg>
          </div>

          {/* Heading */}
          <h2 style={{
            fontSize: '1.2rem', fontWeight: 700, color: '#fff',
            textAlign: 'center', margin: '0 0 12px',
          }}>
            {cfg.heading}
          </h2>

          {/* Body */}
          <p style={{
            fontSize: '0.9rem', color: '#c4c9d4', textAlign: 'center',
            lineHeight: 1.65, margin: '0 0 20px',
          }}>
            {cfg.body}
          </p>

          {/* Calendly iframe (phase 2) */}
          {cfg.calendlyUrl && (
            <div style={{ marginBottom: '16px' }}>
              <div style={{
                borderRadius: '12px', overflow: 'hidden',
                border: '1px solid rgba(255,255,255,0.08)',
                background: 'rgba(255,255,255,0.02)',
              }}>
                <iframe
                  src={cfg.calendlyUrl}
                  width="100%"
                  height="400"
                  frameBorder="0"
                  title="Book your session"
                  style={{ display: 'block' }}
                />
              </div>
              <p style={{
                marginTop: '8px', fontSize: '0.75rem',
                color: '#6b7280', textAlign: 'center',
              }}>
                Booking opens after Phase 2 completion — link will be activated by your cohort admin.
              </p>
            </div>
          )}

          {/* Action button */}
          {cfg.actionLabel && cfg.actionHref && (
            <a
              href={cfg.actionHref}
              target="_blank"
              rel="noopener noreferrer"
              style={{
                display: 'block', textAlign: 'center', textDecoration: 'none',
                padding: '13px 24px', borderRadius: '10px', marginBottom: '10px',
                background: `linear-gradient(135deg, ${cfg.checkColor}cc, ${cfg.checkColor})`,
                color: '#fff', fontSize: '0.9rem', fontWeight: 700,
                transition: 'opacity 0.2s',
              }}
              onMouseEnter={e => (e.currentTarget.style.opacity = '0.85')}
              onMouseLeave={e => (e.currentTarget.style.opacity = '1')}
            >
              {cfg.actionLabel}
            </a>
          )}

          {/* Subtext */}
          {cfg.subtext && (
            <p style={{
              fontSize: '0.78rem', color: '#6b7280',
              textAlign: 'center', margin: '0 0 16px',
            }}>
              {cfg.subtext}
            </p>
          )}

          {/* Close button */}
          <button
            onClick={handleClose}
            style={{
              display: 'block', width: '100%',
              padding: '11px 24px', borderRadius: '10px', marginTop: '8px',
              border: '1.5px solid rgba(255,255,255,0.15)',
              background: 'transparent', color: '#9ca3af',
              fontSize: '0.875rem', fontWeight: 600, cursor: 'pointer',
              fontFamily: 'inherit', transition: 'all 0.2s',
            }}
            onMouseEnter={e => { e.currentTarget.style.borderColor = 'rgba(255,255,255,0.35)'; e.currentTarget.style.color = '#fff'; }}
            onMouseLeave={e => { e.currentTarget.style.borderColor = 'rgba(255,255,255,0.15)'; e.currentTarget.style.color = '#9ca3af'; }}
          >
            {cfg.closeLabel}
          </button>
        </div>
      </div>
    </>
  );
}

export default function Curriculum() {
  const [programs, setPrograms]               = useState([]);
  const [selectedProgram, setSelectedProgram] = useState(null);
  const [modules, setModules]                 = useState([]);
  const [openModuleId, setOpenModuleId]       = useState(null);
  const [loadingPrograms, setLoadingPrograms] = useState(true);
  const [loadingModules, setLoadingModules]   = useState(false);
  const [error, setError]                     = useState('');
  const [tooltipModuleId, setTooltipModuleId] = useState(null);
  const [rewardModal, setRewardModal]         = useState(null); // null | 'phase1' | 'phase2' | 'phase3' | 'phase4'
  const tooltipTimer = useRef(null);

  const rawSelected  = localStorage.getItem('selectedArchetype');
  const unlockedName = ARCHETYPE_NAME_MAP[rawSelected] || rawSelected;

  useEffect(() => {
    fetch(`${API}/api/programs/`)
      .then(r => r.json())
      .then(data => { setPrograms(data); setLoadingPrograms(false); })
      .catch(() => { setError('Could not load programs.'); setLoadingPrograms(false); });
  }, []);

  const handleSelectProgram = async (program) => {
    if (selectedProgram?.id === program.id) {
      setSelectedProgram(null);
      setModules([]);
      return;
    }
    setSelectedProgram(program);
    setModules([]);
    setOpenModuleId(null);
    setTooltipModuleId(null);
    setLoadingModules(true);
    try {
      const res  = await fetch(`${API}/api/programs/${program.id}/modules`);
      const data = await res.json();
      setModules(data);
    } catch {
      setError('Could not load modules.');
    } finally {
      setLoadingModules(false);
    }
  };

  const handleLockedModuleClick = (moduleId) => {
    setTooltipModuleId(moduleId);
    clearTimeout(tooltipTimer.current);
    tooltipTimer.current = setTimeout(() => setTooltipModuleId(null), 2500);
  };

  const toggleModule = (id) => setOpenModuleId(prev => prev === id ? null : id);

  const groupedModules = modules.reduce((acc, m) => {
    const p = m.phase_number || 1;
    (acc[p] = acc[p] || []).push(m);
    return acc;
  }, {});

  return (
    <div className="page animate-fade-in" style={{ opacity: 1 }}>
      {/* Reward modal */}
      {rewardModal && (
        <RewardModal phaseKey={rewardModal} onClose={() => setRewardModal(null)} />
      )}

      <div style={{ marginBottom: '28px' }}>
        <h1 className="page-title" style={{ marginBottom: '6px' }}>Curriculum Roadmap</h1>
        <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem' }}>
          Four complete PM career roadmaps — Phase 1 &amp; 2 are open for all paths. Specialization unlocks after Phase 2.
        </p>
      </div>

      {error && (
        <div style={{ color: '#f87171', marginBottom: '16px', fontSize: '0.85rem' }}>{error}</div>
      )}

      {/* ── Program Cards ── */}
      {loadingPrograms ? (
        <div style={{ color: 'var(--text-secondary)' }}>Loading programs...</div>
      ) : (
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '16px', marginBottom: '32px' }}>
          {programs.map(program => {
            const meta     = ARCHETYPE_META[program.archetype_name] || { color: '#3b82f6', bg: 'rgba(59,130,246,0.1)', emoji: '📚' };
            const active   = selectedProgram?.id === program.id;
            const isMyPath = program.archetype_name === unlockedName;

            return (
              <div key={program.id} style={{ position: 'relative' }}>
                <button
                  onClick={() => handleSelectProgram(program)}
                  style={{
                    width: '100%', textAlign: 'left', cursor: 'pointer', border: 'none',
                    background: active ? meta.bg : 'var(--bg-secondary)',
                    borderRadius: '14px',
                    border: active ? `1px solid ${meta.color}` : '1px solid var(--glass-border)',
                    padding: '20px 22px', transition: 'all 0.2s', outline: 'none',
                    boxShadow: active ? `0 0 0 2px ${meta.color}40, 0 4px 20px ${meta.color}20` : 'none',
                  }}
                  onMouseEnter={e => { if (!active) e.currentTarget.style.boxShadow = `0 0 0 1.5px ${meta.color}80, 0 4px 16px ${meta.color}20`; }}
                  onMouseLeave={e => { if (!active) e.currentTarget.style.boxShadow = 'none'; }}
                >
                  {isMyPath && (
                    <div style={{
                      position: 'absolute', top: '10px', right: '10px',
                      fontSize: '0.65rem', fontWeight: 700, padding: '2px 8px',
                      borderRadius: '9999px', background: 'rgba(34,197,94,0.15)',
                      color: '#4ade80', letterSpacing: '0.03em', zIndex: 2,
                    }}>
                      Your Path
                    </div>
                  )}
                  <div style={{ opacity: isMyPath ? 1 : 0.5 }}>
                    <div style={{ fontSize: '2rem', marginBottom: '10px' }}>{meta.emoji}</div>
                    <div style={{ fontWeight: 700, fontSize: '1rem', color: 'var(--text-primary)', marginBottom: '6px' }}>
                      {program.title}
                    </div>
                    <div style={{ fontSize: '0.82rem', color: 'var(--text-secondary)', lineHeight: 1.5, marginBottom: '14px' }}>
                      {program.description}
                    </div>
                    <div style={{ display: 'flex', gap: '8px' }}>
                      <span style={{ fontSize: '0.75rem', padding: '3px 10px', borderRadius: '99px', background: meta.bg, color: meta.color, fontWeight: 600 }}>
                        {program.total_phases} Phases
                      </span>
                      <span style={{ fontSize: '0.75rem', padding: '3px 10px', borderRadius: '99px', background: 'var(--glass-bg)', color: 'var(--text-secondary)', fontWeight: 500 }}>
                        8 Modules
                      </span>
                    </div>
                  </div>
                </button>

                {!isMyPath && (
                  <div style={{
                    position: 'absolute', inset: 0, borderRadius: '14px',
                    background: 'rgba(0,0,0,0.35)', pointerEvents: 'none',
                  }}>
                    <Lock size={18} style={{ color: '#9ca3af', position: 'absolute', bottom: '14px', right: '14px' }} />
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}

      {/* ── Module List ── */}
      {selectedProgram && (
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '20px' }}>
            <div style={{ fontSize: '1.5rem' }}>{ARCHETYPE_META[selectedProgram.archetype_name]?.emoji}</div>
            <div>
              <h2 style={{ fontSize: '1.1rem', fontWeight: 700, margin: 0 }}>{selectedProgram.title}</h2>
              <p style={{ fontSize: '0.82rem', color: 'var(--text-secondary)', margin: 0 }}>
                {modules.length} modules · {modules.reduce((s, m) => s + (m.lessons?.length || 0), 0)} lessons
              </p>
            </div>
          </div>

          {loadingModules ? (
            <div style={{ color: 'var(--text-secondary)', padding: '24px 0' }}>Loading modules...</div>
          ) : (
            Object.entries(groupedModules).map(([phase, phaseMods]) => {
              const phaseNum      = parseInt(phase);
              const phaseIsLocked = phaseNum >= 3;
              const accentColor   = ARCHETYPE_META[selectedProgram.archetype_name]?.color || 'var(--accent-electric)';

              return (
                <div key={phase} style={{ marginBottom: '32px' }}>
                  {/* Phase header */}
                  <div style={{
                    display: 'flex', alignItems: 'center', gap: '8px',
                    fontSize: '0.7rem', fontWeight: 700, textTransform: 'uppercase',
                    letterSpacing: '0.1em', color: phaseIsLocked ? 'var(--text-secondary)' : accentColor,
                    marginBottom: '10px', paddingLeft: '4px',
                  }}>
                    Phase {phase} — {PHASE_LABELS[phaseNum]}
                    {phaseIsLocked && <span style={{ fontSize: '0.75rem' }}>🔒</span>}
                  </div>

                  <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                    {phaseMods.map((module, idx) => {
                      const moduleIsLocked = phaseIsLocked;
                      const isOpen         = !moduleIsLocked && openModuleId === module.id;
                      const showTooltip    = tooltipModuleId === module.id;
                      const videos         = (module.lessons || []).filter(l => l.lesson_type === 'video');
                      const readings       = (module.lessons || []).filter(l => l.lesson_type === 'reading');
                      const tasks          = (module.lessons || []).filter(l => l.lesson_type === 'task');

                      return (
                        <div key={module.id}>
                          <div
                            className="glass-panel"
                            style={{
                              padding: 0, overflow: 'hidden', position: 'relative',
                              border: isOpen
                                ? `1px solid ${accentColor}`
                                : moduleIsLocked
                                  ? '1px solid rgba(255,255,255,0.05)'
                                  : '1px solid var(--glass-border)',
                            }}
                          >
                            {moduleIsLocked && (
                              <Lock size={14} style={{
                                position: 'absolute', top: '14px', right: '16px',
                                color: '#6b7280', pointerEvents: 'none', zIndex: 2,
                              }} />
                            )}

                            <button
                              onClick={() => moduleIsLocked ? handleLockedModuleClick(module.id) : toggleModule(module.id)}
                              style={{
                                width: '100%', textAlign: 'left', background: 'none', border: 'none',
                                padding: '16px 20px', cursor: moduleIsLocked ? 'not-allowed' : 'pointer',
                                display: 'flex', alignItems: 'flex-start', gap: '14px',
                              }}
                            >
                              <div style={{
                                opacity: moduleIsLocked ? 0.5 : 1,
                                display: 'flex', alignItems: 'flex-start', gap: '14px', flex: 1,
                              }}>
                                <div style={{
                                  width: '28px', height: '28px', borderRadius: '8px', flexShrink: 0, marginTop: '1px',
                                  background: ARCHETYPE_META[selectedProgram.archetype_name]?.bg || 'rgba(59,130,246,0.1)',
                                  color: accentColor,
                                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                                  fontSize: '0.8rem', fontWeight: 700,
                                }}>
                                  {(idx + 1) + ((phaseNum - 1) * 2)}
                                </div>
                                <div style={{ flex: 1 }}>
                                  <div style={{ fontWeight: 600, fontSize: '0.95rem', color: 'var(--text-primary)', marginBottom: '4px' }}>
                                    {module.title}
                                  </div>
                                  {module.learning_objective && (
                                    <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', lineHeight: 1.4 }}>
                                      {module.learning_objective}
                                    </div>
                                  )}
                                  <div style={{ display: 'flex', gap: '8px', marginTop: '8px' }}>
                                    {videos.length > 0   && <span style={{ fontSize: '0.72rem', color: 'var(--text-secondary)' }}>▶ {videos.length} video{videos.length > 1 ? 's' : ''}</span>}
                                    {readings.length > 0 && <span style={{ fontSize: '0.72rem', color: 'var(--text-secondary)' }}>📄 {readings.length} reading{readings.length > 1 ? 's' : ''}</span>}
                                    {tasks.length > 0    && <span style={{ fontSize: '0.72rem', color: 'var(--text-secondary)' }}>✏️ {tasks.length} task{tasks.length > 1 ? 's' : ''}</span>}
                                  </div>
                                </div>
                              </div>
                              {!moduleIsLocked && (
                                <span style={{ color: 'var(--text-secondary)', fontSize: '1rem', flexShrink: 0, marginTop: '2px' }}>
                                  {isOpen ? '▲' : '▼'}
                                </span>
                              )}
                            </button>

                            {isOpen && (
                              <div style={{ borderTop: '1px solid var(--glass-border)', padding: '12px 20px 16px' }}>
                                {(module.lessons || []).map(lesson => (
                                  <div
                                    key={lesson.id}
                                    style={{
                                      display: 'flex', alignItems: 'flex-start', gap: '12px',
                                      padding: '10px 0', borderBottom: '1px solid var(--glass-border)',
                                    }}
                                  >
                                    <span style={{
                                      fontSize: '0.72rem', fontWeight: 600, padding: '2px 8px',
                                      borderRadius: '99px', flexShrink: 0, marginTop: '2px',
                                      background: lesson.lesson_type === 'task'  ? 'rgba(245,158,11,0.15)' :
                                                  lesson.lesson_type === 'video' ? 'rgba(59,130,246,0.15)'  : 'rgba(168,85,247,0.15)',
                                      color: lesson.lesson_type === 'task'  ? '#f59e0b' :
                                             lesson.lesson_type === 'video' ? '#3b82f6'                    : '#a855f7',
                                    }}>
                                      {LESSON_TYPE_LABEL[lesson.lesson_type]}
                                    </span>
                                    <div>
                                      <div style={{ fontSize: '0.88rem', fontWeight: 600, color: 'var(--text-primary)', marginBottom: '2px' }}>
                                        {lesson.title}
                                        {lesson.author && (
                                          <span style={{ fontWeight: 400, color: 'var(--text-secondary)', marginLeft: '6px', fontSize: '0.8rem' }}>
                                            — {lesson.author}{lesson.source ? `, ${lesson.source}` : ''}
                                          </span>
                                        )}
                                        {!lesson.author && lesson.source && (
                                          <span style={{ fontWeight: 400, color: 'var(--text-secondary)', marginLeft: '6px', fontSize: '0.8rem' }}>
                                            — {lesson.source}
                                          </span>
                                        )}
                                      </div>
                                      <div style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', lineHeight: 1.5 }}>
                                        {lesson.description || lesson.content}
                                      </div>
                                    </div>
                                  </div>
                                ))}
                              </div>
                            )}
                          </div>

                          {showTooltip && (
                            <div style={{
                              marginTop: '6px', padding: '8px 14px', borderRadius: '8px',
                              background: 'rgba(251,191,36,0.12)', border: '1px solid rgba(251,191,36,0.25)',
                              fontSize: '0.78rem', color: '#fbbf24', display: 'flex', alignItems: 'center', gap: '6px',
                            }}>
                              🔒 Complete Phase 2 to unlock specialization content.
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>

                  {/* ── Mark Phase Complete button ── */}
                  <button
                    onClick={() => setRewardModal(`phase${phaseNum}`)}
                    style={{
                      marginTop: '14px',
                      width: '100%',
                      padding: '11px 20px',
                      borderRadius: '10px',
                      border: '1.5px solid rgba(139,92,246,0.4)',
                      background: 'rgba(139,92,246,0.05)',
                      color: '#a78bfa',
                      fontSize: '0.82rem',
                      fontWeight: 600,
                      cursor: 'pointer',
                      fontFamily: 'inherit',
                      transition: 'all 0.2s',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      gap: '8px',
                    }}
                    onMouseEnter={e => {
                      e.currentTarget.style.background    = 'rgba(139,92,246,0.12)';
                      e.currentTarget.style.borderColor   = 'rgba(139,92,246,0.7)';
                      e.currentTarget.style.color         = '#c4b5fd';
                    }}
                    onMouseLeave={e => {
                      e.currentTarget.style.background    = 'rgba(139,92,246,0.05)';
                      e.currentTarget.style.borderColor   = 'rgba(139,92,246,0.4)';
                      e.currentTarget.style.color         = '#a78bfa';
                    }}
                  >
                    ✓ Mark Phase {phaseNum} Complete
                  </button>
                </div>
              );
            })
          )}
        </div>
      )}
    </div>
  );
}
