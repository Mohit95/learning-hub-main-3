import { useEffect, useState } from 'react';
import { CalendarDays, BookOpen, Play, PenLine, ChevronLeft, ChevronRight } from 'lucide-react';

const API = import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000';

const ARCHETYPE_NAME_MAP = {
  'Growth PM':  'Growth PM',
  'AI PM':      'AI / Data PM',
  'Tech PM':    'Technical PM',
  'General PM': 'Consumer PM',
};

const LESSON_TYPE_META = {
  video:   { label: 'Video',   color: '#3b82f6', bg: 'rgba(59,130,246,0.15)',  icon: Play },
  reading: { label: 'Reading', color: '#a855f7', bg: 'rgba(168,85,247,0.15)', icon: BookOpen },
  task:    { label: 'Task',    color: '#f59e0b', bg: 'rgba(245,158,11,0.15)',  icon: PenLine },
};

const PHASE_COLORS = {
  1: '#22c55e',
  2: '#3b82f6',
  3: '#a855f7',
  4: '#f59e0b',
};

function formatDate(iso) {
  const d = new Date(iso + 'T00:00:00');
  return d.toLocaleDateString('en-GB', { weekday: 'short', day: 'numeric', month: 'short' });
}

function isToday(iso) {
  return iso === new Date().toISOString().split('T')[0];
}

function isPast(iso) {
  return iso < new Date().toISOString().split('T')[0];
}

function addDays(dateStr, n) {
  const d = new Date(dateStr + 'T00:00:00');
  d.setDate(d.getDate() + n);
  return d.toISOString().split('T')[0];
}

function toIso(date) {
  return date.toISOString().split('T')[0];
}

export default function Schedule() {
  const [schedule, setSchedule]         = useState([]);
  const [loading, setLoading]           = useState(true);
  const [error, setError]               = useState('');
  const [startDate, setStartDate]       = useState('');
  const [weekOffset, setWeekOffset]     = useState(0);   // which week to view
  const [programId, setProgramId]       = useState(null);

  // Restore or default start date from localStorage
  useEffect(() => {
    const saved = localStorage.getItem('scheduleStartDate') || toIso(new Date());
    setStartDate(saved);
  }, []);

  // Load program for user's archetype
  useEffect(() => {
    const rawSelected  = localStorage.getItem('selectedArchetype');
    const archetypeName = ARCHETYPE_NAME_MAP[rawSelected] || rawSelected;
    if (!archetypeName) { setLoading(false); return; }

    fetch(`${API}/api/programs/archetype/${encodeURIComponent(archetypeName)}`)
      .then(r => r.json())
      .then(data => setProgramId(data.id))
      .catch(() => { setError('Could not load program.'); setLoading(false); });
  }, []);

  // Fetch schedule when programId or startDate changes
  useEffect(() => {
    if (!programId || !startDate) return;
    setLoading(true);
    fetch(`${API}/api/programs/${programId}/schedule?start_date=${startDate}`)
      .then(r => r.json())
      .then(data => { setSchedule(data); setLoading(false); })
      .catch(() => { setError('Could not load schedule.'); setLoading(false); });
  }, [programId, startDate]);

  const handleStartDateChange = (e) => {
    const val = e.target.value;
    setStartDate(val);
    localStorage.setItem('scheduleStartDate', val);
    setWeekOffset(0);
  };

  // Group schedule by week number
  const byWeek = schedule.reduce((acc, lesson) => {
    const w = lesson.week_number || 1;
    (acc[w] = acc[w] || []).push(lesson);
    return acc;
  }, {});

  const weekNums    = Object.keys(byWeek).map(Number).sort((a, b) => a - b);
  const totalWeeks  = weekNums.length;
  const currentWeek = weekNums[weekOffset] || weekNums[0];
  const weekLessons = byWeek[currentWeek] || [];

  // Group week's lessons by day
  const byDay = weekLessons.reduce((acc, lesson) => {
    const d = lesson.day_number || 1;
    (acc[d] = acc[d] || []).push(lesson);
    return acc;
  }, {});

  // Compute week date range label
  const weekStart = weekLessons[0]?.scheduled_date || startDate;
  const weekEnd   = weekLessons[weekLessons.length - 1]?.scheduled_date || startDate;

  // Today's lessons
  const todayIso = toIso(new Date());
  const todayLessons = schedule.filter(l => l.scheduled_date === todayIso);

  if (!localStorage.getItem('selectedArchetype')) {
    return (
      <div className="page animate-fade-in" style={{ maxWidth: '560px', margin: '0 auto', paddingTop: '60px', textAlign: 'center' }}>
        <CalendarDays size={40} color="var(--accent-electric)" style={{ marginBottom: '16px' }} />
        <h2 style={{ fontSize: '1.4rem', fontWeight: 700, marginBottom: '12px' }}>No Archetype Selected</h2>
        <p style={{ color: 'var(--text-secondary)', lineHeight: 1.6 }}>
          Complete the readiness assessment first to unlock your personalised schedule.
        </p>
      </div>
    );
  }

  return (
    <div className="page animate-fade-in">
      <div style={{ marginBottom: '28px', display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', flexWrap: 'wrap', gap: '16px' }}>
        <div>
          <h1 className="page-title" style={{ marginBottom: '6px' }}>Learning Schedule</h1>
          <p style={{ color: 'var(--text-secondary)', fontSize: '0.95rem' }}>
            Your week-by-week curriculum plan. Adjust your start date to shift all sessions.
          </p>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
          <label style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', fontWeight: 500 }}>Start date</label>
          <input
            type="date"
            value={startDate}
            onChange={handleStartDateChange}
            style={{
              padding: '7px 12px', borderRadius: '8px', border: '1px solid var(--glass-border)',
              background: 'var(--bg-secondary)', color: 'var(--text-primary)',
              fontSize: '0.85rem', outline: 'none', fontFamily: 'inherit',
            }}
          />
        </div>
      </div>

      {error && <div style={{ color: '#f87171', marginBottom: '16px', fontSize: '0.85rem' }}>{error}</div>}

      {loading ? (
        <div style={{ color: 'var(--text-secondary)', padding: '40px 0', textAlign: 'center' }}>Loading schedule...</div>
      ) : (
        <>
          {/* ── Today's Sessions ── */}
          {todayLessons.length > 0 && (
            <div className="glass-panel" style={{ padding: '20px 24px', marginBottom: '28px', border: '1px solid rgba(59,130,246,0.4)', background: 'rgba(59,130,246,0.05)' }}>
              <div style={{ fontSize: '0.75rem', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.08em', color: '#3b82f6', marginBottom: '12px' }}>
                Today · {formatDate(todayIso)}
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                {todayLessons.map(l => {
                  const meta = LESSON_TYPE_META[l.lesson_type] || LESSON_TYPE_META.reading;
                  const Icon = meta.icon;
                  return (
                    <div key={l.id} style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                      <div style={{ width: '28px', height: '28px', borderRadius: '8px', background: meta.bg, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                        <Icon size={14} color={meta.color} />
                      </div>
                      <div>
                        <div style={{ fontSize: '0.9rem', fontWeight: 600, color: 'var(--text-primary)' }}>{l.title}</div>
                        <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{l.module_title} · Week {l.week_number} Day {l.day_number}</div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* ── Week Navigator ── */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '20px' }}>
            <button
              onClick={() => setWeekOffset(w => Math.max(0, w - 1))}
              disabled={weekOffset === 0}
              style={{
                width: '36px', height: '36px', borderRadius: '8px', border: '1px solid var(--glass-border)',
                background: 'var(--bg-secondary)', color: weekOffset === 0 ? 'var(--text-secondary)' : 'var(--text-primary)',
                cursor: weekOffset === 0 ? 'default' : 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center',
                opacity: weekOffset === 0 ? 0.4 : 1,
              }}
            >
              <ChevronLeft size={18} />
            </button>

            <div style={{ textAlign: 'center' }}>
              <div style={{ fontWeight: 700, fontSize: '1rem', color: 'var(--text-primary)' }}>
                Week {currentWeek} <span style={{ fontSize: '0.8rem', fontWeight: 400, color: 'var(--text-secondary)' }}>of {totalWeeks}</span>
              </div>
              {weekStart && weekEnd && (
                <div style={{ fontSize: '0.78rem', color: 'var(--text-secondary)' }}>
                  {formatDate(weekStart)} — {formatDate(weekEnd)}
                </div>
              )}
            </div>

            <button
              onClick={() => setWeekOffset(w => Math.min(totalWeeks - 1, w + 1))}
              disabled={weekOffset >= totalWeeks - 1}
              style={{
                width: '36px', height: '36px', borderRadius: '8px', border: '1px solid var(--glass-border)',
                background: 'var(--bg-secondary)', color: weekOffset >= totalWeeks - 1 ? 'var(--text-secondary)' : 'var(--text-primary)',
                cursor: weekOffset >= totalWeeks - 1 ? 'default' : 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center',
                opacity: weekOffset >= totalWeeks - 1 ? 0.4 : 1,
              }}
            >
              <ChevronRight size={18} />
            </button>
          </div>

          {/* ── Days in this week ── */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            {Object.entries(byDay).sort(([a],[b]) => parseInt(a)-parseInt(b)).map(([dayNum, lessons]) => {
              const dayDate  = lessons[0]?.scheduled_date;
              const past     = dayDate ? isPast(dayDate) : false;
              const today    = dayDate ? isToday(dayDate) : false;
              const phaseNum = lessons[0]?.phase_number || 1;
              const phaseColor = PHASE_COLORS[phaseNum] || 'var(--accent-electric)';

              return (
                <div
                  key={dayNum}
                  className="glass-panel"
                  style={{
                    padding: '0', overflow: 'hidden',
                    border: today
                      ? '1px solid rgba(59,130,246,0.5)'
                      : past
                        ? '1px solid rgba(255,255,255,0.04)'
                        : '1px solid var(--glass-border)',
                    opacity: past ? 0.7 : 1,
                  }}
                >
                  {/* Day header */}
                  <div style={{
                    display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                    padding: '12px 20px',
                    background: today ? 'rgba(59,130,246,0.08)' : past ? 'rgba(255,255,255,0.01)' : 'rgba(255,255,255,0.02)',
                    borderBottom: '1px solid var(--glass-border)',
                  }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                      <div style={{
                        width: '32px', height: '32px', borderRadius: '8px', flexShrink: 0,
                        background: today ? 'rgba(59,130,246,0.2)' : `${phaseColor}18`,
                        color: today ? '#3b82f6' : phaseColor,
                        display: 'flex', alignItems: 'center', justifyContent: 'center',
                        fontSize: '0.75rem', fontWeight: 800,
                      }}>
                        D{dayNum}
                      </div>
                      <div>
                        <div style={{ fontWeight: 700, fontSize: '0.9rem', color: today ? '#60a5fa' : 'var(--text-primary)' }}>
                          Day {dayNum} {today && <span style={{ fontSize: '0.7rem', background: 'rgba(59,130,246,0.2)', color: '#60a5fa', padding: '1px 7px', borderRadius: '99px', marginLeft: '4px' }}>Today</span>}
                          {past && !today && <span style={{ fontSize: '0.7rem', color: 'var(--text-secondary)', marginLeft: '4px' }}>Done</span>}
                        </div>
                        {dayDate && <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)' }}>{formatDate(dayDate)}</div>}
                      </div>
                    </div>
                    <div style={{ fontSize: '0.72rem', color: 'var(--text-secondary)' }}>
                      {lessons.length} session{lessons.length > 1 ? 's' : ''}
                    </div>
                  </div>

                  {/* Lessons */}
                  <div style={{ padding: '4px 20px 12px' }}>
                    {lessons.map(lesson => {
                      const meta = LESSON_TYPE_META[lesson.lesson_type] || LESSON_TYPE_META.reading;
                      const Icon = meta.icon;
                      return (
                        <div key={lesson.id} style={{
                          display: 'flex', alignItems: 'center', gap: '12px',
                          padding: '10px 0', borderBottom: '1px solid rgba(255,255,255,0.04)',
                        }}>
                          <div style={{
                            width: '28px', height: '28px', borderRadius: '7px', background: meta.bg,
                            display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
                          }}>
                            <Icon size={13} color={meta.color} />
                          </div>
                          <div style={{ flex: 1 }}>
                            <div style={{ fontSize: '0.88rem', fontWeight: 600, color: 'var(--text-primary)' }}>{lesson.title}</div>
                            <div style={{ fontSize: '0.75rem', color: 'var(--text-secondary)', marginTop: '2px' }}>{lesson.module_title}</div>
                          </div>
                          <span style={{
                            fontSize: '0.68rem', fontWeight: 600, padding: '2px 8px',
                            borderRadius: '99px', background: meta.bg, color: meta.color, flexShrink: 0,
                          }}>
                            {meta.label}
                          </span>
                        </div>
                      );
                    })}
                  </div>
                </div>
              );
            })}
          </div>

          {/* ── Phase label for this week ── */}
          {weekLessons[0] && (
            <div style={{
              marginTop: '20px', textAlign: 'center',
              fontSize: '0.75rem', color: 'var(--text-secondary)',
            }}>
              Phase {weekLessons[0].phase_number} · Week {currentWeek} of {totalWeeks}
            </div>
          )}
        </>
      )}
    </div>
  );
}
