import React, { useState } from 'react';
import { useAuthStore } from '../store/authStore';
import { mentorsData } from '../data/placeholders';
import { Users, X, Calendar, Lock } from 'lucide-react';
import './EnhancedStyles.css';

function BookingModal({ mentor, userName, onClose }) {
  const [startTime, setStartTime] = useState('');
  const [loading, setLoading] = useState(false);
  const [booked, setBooked] = useState(false);

  const handleBook = (e) => {
    e.preventDefault();
    if (!startTime) return;
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setBooked(true);
      setTimeout(onClose, 1500);
    }, 1000);
  };

  return (
    <div style={{
      position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.7)', display: 'flex',
      alignItems: 'center', justifyContent: 'center', zIndex: 50, padding: '24px',
    }}>
      <div className="glass-panel" style={{ width: '100%', maxWidth: '440px', padding: '32px', position: 'relative' }}>
        <button
          onClick={onClose}
          style={{ position: 'absolute', top: '16px', right: '16px', background: 'transparent', border: 'none', cursor: 'pointer', color: 'var(--text-secondary)' }}
        >
          <X size={20} />
        </button>

        <h2 style={{ fontSize: '1.25rem', fontWeight: 700, marginBottom: '6px' }}>Book a Session</h2>
        <p style={{ color: 'var(--text-secondary)', fontSize: '0.875rem', marginBottom: '24px' }}>
          with <strong style={{ color: 'var(--text-primary)' }}>{mentor.name}</strong> — 1 hour session
        </p>

        {booked ? (
          <div style={{ background: 'rgba(34,197,94,0.1)', border: '1px solid rgba(34,197,94,0.2)', borderRadius: '8px', padding: '16px', color: '#4ade80', textAlign: 'center' }}>
            Session booked successfully!
          </div>
        ) : (
          <form onSubmit={handleBook} style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 500, color: 'var(--text-secondary)' }}>Select Date & Time</label>
              <input
                type="datetime-local"
                value={startTime}
                onChange={e => setStartTime(e.target.value)}
                min={new Date().toISOString().slice(0, 16)}
                required
                style={{
                  background: '#1e2235',
                  color: '#ffffff',
                  border: '1px solid rgba(255,255,255,0.15)',
                  borderRadius: '10px',
                  padding: '10px 14px',
                  fontSize: '0.95rem',
                  colorScheme: 'dark',
                  width: '100%',
                  boxSizing: 'border-box',
                }}
              />
            </div>
            <button
              type="submit"
              className="btn-primary"
              disabled={loading}
              style={{ borderRadius: '10px', padding: '12px', fontSize: '0.9rem', opacity: loading ? 0.7 : 1 }}
            >
              {loading ? 'Booking...' : 'Confirm Booking'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
}

export default function MentorsEnhanced() {
  const { profile } = useAuthStore();
  const [bookingMentor, setBookingMentor] = useState(null);

  return (
    <div style={{ position: 'relative' }}>
      {/* Coming Soon overlay */}
      <div style={{
        position: 'fixed', inset: 0, zIndex: 40,
        backdropFilter: 'blur(6px)', WebkitBackdropFilter: 'blur(6px)',
        background: 'rgba(10, 10, 20, 0.75)',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      }}>
        <Lock size={48} style={{ color: '#c084fc', marginBottom: '16px' }} />
        <h2 style={{ fontSize: '1.875rem', fontWeight: 700, color: '#fff', marginBottom: '12px' }}>
          Coming Soon
        </h2>
        <p style={{
          fontSize: '0.875rem', color: '#9ca3af', textAlign: 'center',
          maxWidth: '360px', lineHeight: 1.6, marginBottom: '20px',
        }}>
          1-on-1 mentor sessions are being set up. You'll be notified when booking goes live.
        </p>
        <span style={{
          background: 'rgba(88, 28, 135, 0.5)', color: '#d8b4fe',
          fontSize: '0.75rem', padding: '4px 12px', borderRadius: '9999px',
          border: '1px solid #7e22ce',
        }}>
          Launching April 2026
        </span>
      </div>

      <div className="page animate-fade-in">
      <h1 className="page-title">Mentors</h1>
      <p style={{ color: 'var(--text-secondary)', marginBottom: '32px' }}>
        Book 1-on-1 sessions with experienced Product Managers.
      </p>

      <div className="grid2">
        {mentorsData.map((mentor) => (
          <div key={mentor.id} className="card-placeholder" style={{ display: 'flex', flexDirection: 'column' }}>
            <div style={{ display: 'flex', alignItems: 'flex-start', gap: '10px' }}>
              <div className={`avatar ${mentor.avatarColorClass}`}>{mentor.initials}</div>
              <div style={{ flex: 1 }}>
                <div className="name">{mentor.name}</div>
                <div className="role">{mentor.role}</div>
                <div className="avail">
                  <span className={`avail-dot ${mentor.availabilityStatus === 'busy' ? 'busy' : ''}`}></span>
                  <span style={{ fontSize: '12px', color: 'var(--text-secondary)' }}>{mentor.nextAvailable}</span>
                </div>
              </div>
            </div>
            
            <div className="tags">
              {mentor.tags.map((tag, i) => (
                <span key={i} className={`tag ${tag.class}`}>{tag.label}</span>
              ))}
            </div>
            
            <div className="rating">
              <span>★ {mentor.rating}</span> · {mentor.sessions} sessions
            </div>
            
            <div className="divider"></div>
            
            <div style={{ fontSize: '12px', color: 'var(--text-secondary)', lineHeight: 1.5, flex: 1 }}>
              {mentor.quote}
            </div>
            
            <button 
              className="btn-sm" 
              onClick={() => setBookingMentor(mentor)}
            >
              Book session ↗
            </button>
          </div>
        ))}
      </div>

      {bookingMentor && (
        <BookingModal
          mentor={bookingMentor}
          userName={profile?.full_name || 'User'}
          onClose={() => setBookingMentor(null)}
        />
      )}
      </div>
    </div>
  );
}
