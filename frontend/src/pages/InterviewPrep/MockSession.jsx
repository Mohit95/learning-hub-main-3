import React, { useState, useEffect, useRef } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Send, User, Bot } from 'lucide-react';
import { createSession, sendMessage, completeSession } from '../../services/interview';
import { useAuthStore } from '../../store/authStore';

const MAX_TURNS = 10;

export default function MockSession() {
  const [searchParams] = useSearchParams();
  const type = searchParams.get('type') || 'product_design';
  const navigate = useNavigate();
  const { user } = useAuthStore();

  const [sessionId, setSessionId] = useState(null);
  const [turnNumber, setTurnNumber] = useState(0);
  const [answer, setAnswer] = useState('');
  const [chatLog, setChatLog] = useState([]);
  const [isProcessing, setIsProcessing] = useState(true);
  const [isComplete, setIsComplete] = useState(false);
  const [initError, setInitError] = useState('');

  const messagesEndRef = useRef(null);

  // Initialise session on mount — gets the first question from the AI
  useEffect(() => {
    let cancelled = false;
    const init = async () => {
      try {
        const data = await createSession(type, user?.id);
        if (cancelled) return;
        setSessionId(data.session_id);
        setTurnNumber(1);
        setChatLog([{ role: 'bot', text: data.question }]);
      } catch (err) {
        if (!cancelled) setInitError(err.message || 'Failed to start session. Please try again.');
      } finally {
        if (!cancelled) setIsProcessing(false);
      }
    };
    init();
    return () => { cancelled = true; };
  }, [type]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [chatLog, isProcessing]);

  const handleSubmit = async (e) => {
    if (e) e.preventDefault();
    if (!answer.trim() || isProcessing || isComplete) return;

    if (answer.split(' ').length < 10 && !answer.includes('skip')) {
      if (!window.confirm("Your answer seems short — would you like to submit anyway?")) return;
    }

    const userText = answer;
    setChatLog(prev => [...prev, { role: 'user', text: userText }]);
    setAnswer('');
    setIsProcessing(true);

    try {
      const data = await sendMessage(sessionId, userText);
      setChatLog(prev => [...prev, { role: 'bot', text: data.question }]);
      setTurnNumber(data.turn);

      if (data.is_final) {
        setIsComplete(true);
        // Complete session and navigate to scorecard
        const result = await completeSession(sessionId);
        navigate('/app/interview-prep/scorecard', {
          state: {
            sessionId,
            score: result.score,
            strengths: result.strengths,
            gaps: result.gaps,
            summary: result.summary,
            interviewType: type,
          },
        });
      }
    } catch (err) {
      setChatLog(prev => [...prev, {
        role: 'system',
        text: `Something went wrong: ${err.message}. Please try again.`,
      }]);
    } finally {
      setIsProcessing(false);
    }
  };

  const formatType = (t) => t.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());

  if (initError) {
    return (
      <div className="page" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '400px' }}>
        <div style={{ textAlign: 'center' }}>
          <p style={{ color: '#f87171', marginBottom: '16px' }}>{initError}</p>
          <button className="btn-primary" onClick={() => navigate('/app/interview-prep')} style={{ padding: '10px 24px', border: 'none', borderRadius: '8px', cursor: 'pointer' }}>
            Go Back
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="page" style={{ height: 'calc(100vh - 60px)', display: 'flex', flexDirection: 'column', padding: '24px' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
        <div>
          <h1 style={{ fontSize: '1.25rem', fontWeight: 700 }}>{formatType(type)} Mock Interview</h1>
          <p style={{ color: 'var(--text-secondary)', fontSize: '0.85rem' }}>
            {isComplete ? 'Session complete' : `Turn ${Math.min(turnNumber, MAX_TURNS)} of ${MAX_TURNS}`}
          </p>
        </div>
        <button
          className="btn-outline"
          onClick={() => { if (window.confirm('Abandon session?')) navigate('/app/interview-prep'); }}
        >
          Exit Session
        </button>
      </div>

      <div className="glass-panel" style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>

        {/* Chat Area */}
        <div style={{ flex: 1, overflowY: 'auto', padding: '24px', display: 'flex', flexDirection: 'column', gap: '24px' }}>

          {chatLog.map((msg, i) => {
            if (msg.role === 'bot') {
              return (
                <div key={i} style={{ display: 'flex', gap: '12px', maxWidth: '85%' }}>
                  <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: 'linear-gradient(135deg, var(--accent-electric), var(--accent-violet))', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                    <Bot size={16} color="white" />
                  </div>
                  <div style={{ background: 'rgba(255,255,255,0.05)', padding: '14px 18px', borderRadius: '0 12px 12px 12px', border: '1px solid var(--glass-border)', lineHeight: 1.5, fontSize: '0.95rem' }}>
                    {msg.text}
                  </div>
                </div>
              );
            }

            if (msg.role === 'user') {
              return (
                <div key={i} style={{ display: 'flex', gap: '12px', maxWidth: '85%', alignSelf: 'flex-end', flexDirection: 'row-reverse' }}>
                  <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: 'rgba(255,255,255,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                    <User size={16} />
                  </div>
                  <div style={{ background: 'rgba(59,130,246,0.15)', padding: '14px 18px', borderRadius: '12px 0 12px 12px', border: '1px solid rgba(59,130,246,0.3)', lineHeight: 1.5, fontSize: '0.95rem' }}>
                    {msg.text}
                  </div>
                </div>
              );
            }

            if (msg.role === 'system') {
              return (
                <div key={i} style={{ textAlign: 'center', padding: '20px', color: 'var(--text-secondary)', fontSize: '0.9rem', fontStyle: 'italic' }}>
                  {msg.text}
                </div>
              );
            }

            return null;
          })}

          {isProcessing && (
            <div style={{ display: 'flex', gap: '12px', maxWidth: '85%' }}>
              <div style={{ width: '32px', height: '32px', borderRadius: '50%', background: 'linear-gradient(135deg, var(--accent-electric), var(--accent-violet))', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <Bot size={16} color="white" />
              </div>
              <div style={{ padding: '14px 18px', color: 'var(--text-secondary)', fontSize: '0.9rem', display: 'flex', alignItems: 'center', gap: '8px' }}>
                Thinking...
              </div>
            </div>
          )}

          <div ref={messagesEndRef} />
        </div>

        {/* Input Area */}
        <div style={{ borderTop: '1px solid var(--glass-border)', padding: '20px', background: 'rgba(0,0,0,0.2)' }}>
          <form onSubmit={handleSubmit} style={{ position: 'relative' }}>
            <textarea
              value={answer}
              onChange={e => setAnswer(e.target.value)}
              placeholder={isComplete ? 'Session complete. Navigating to scorecard...' : 'Type your answer here...'}
              disabled={isProcessing || isComplete}
              style={{
                width: '100%', minHeight: '100px', resize: 'vertical',
                padding: '16px', paddingRight: '60px', borderRadius: '12px',
                background: 'var(--bg-secondary)', border: '1px solid var(--glass-border)',
                color: 'var(--text-primary)', fontSize: '0.95rem',
                fontFamily: 'inherit', outline: 'none', transition: 'border-color 0.2s',
                opacity: (isProcessing || isComplete) ? 0.6 : 1,
              }}
              onKeyDown={e => {
                if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) handleSubmit(e);
              }}
            />
            <button
              type="submit"
              disabled={!answer.trim() || isProcessing || isComplete}
              style={{
                position: 'absolute', right: '16px', bottom: '16px',
                width: '36px', height: '36px', borderRadius: '8px',
                background: 'var(--accent-electric)', color: 'white',
                border: 'none', cursor: (!answer.trim() || isProcessing || isComplete) ? 'default' : 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                opacity: (!answer.trim() || isProcessing || isComplete) ? 0.5 : 1, transition: 'all 0.2s',
              }}
            >
              <Send size={16} />
            </button>
            <div style={{ position: 'absolute', bottom: '-22px', right: 0, fontSize: '0.7rem', color: 'var(--text-secondary)' }}>
              Cmd/Ctrl + Enter to send
            </div>
          </form>
        </div>

      </div>
    </div>
  );
}
