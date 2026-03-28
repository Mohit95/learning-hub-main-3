import React, { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { UploadCloud, FileText, CheckCircle, ArrowRight, AlertCircle } from 'lucide-react';
import { scoreAssessment, scoreAssessmentWithResume } from '../../services/assessmentScorer';

export default function ResumeUpload() {
  const navigate = useNavigate();
  const location = useLocation();
  const answers = location.state?.answers || [];

  const [file, setFile] = useState(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [error, setError] = useState('');

  // Guard: answers missing means user navigated here directly / refreshed
  if (answers.length === 0) {
    return (
      <div className="page animate-fade-in" style={{ maxWidth: '560px', margin: '0 auto', paddingTop: '80px', textAlign: 'center' }}>
        <div style={{ width: '56px', height: '56px', borderRadius: '14px', background: 'rgba(251,146,60,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 20px' }}>
          <AlertCircle size={28} color="#fb923c" />
        </div>
        <h2 style={{ fontSize: '1.4rem', fontWeight: 700, marginBottom: '12px' }}>Assessment answers not found</h2>
        <p style={{ color: 'var(--text-secondary)', marginBottom: '28px', lineHeight: 1.6 }}>
          Please complete the 10-question diagnostic first. Your answers are needed before uploading a resume.
        </p>
        <button className="btn-primary" onClick={() => navigate('/app/readiness/questionnaire')} style={{ padding: '12px 28px' }}>
          Start Questionnaire
        </button>
      </div>
    );
  }

  const handleFileChange = (e) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
    }
  };

  const handleSkip = async () => {
    setIsProcessing(true);
    setError('');
    try {
      await scoreAssessment(answers);
      navigate('/app/readiness/scorecard');
    } catch (err) {
      setIsProcessing(false);
      setError(err.message || 'Scoring failed. Please try again.');
    }
  };

  const handleAnalyzeResume = async () => {
    if (!file) return;
    setIsProcessing(true);
    setError('');
    try {
      await scoreAssessmentWithResume(answers, file);
      navigate('/app/readiness/scorecard');
    } catch (err) {
      setIsProcessing(false);
      setError(err.message || 'Scoring failed. Please try again.');
    }
  };

  return (
    <div className="page animate-fade-in" style={{ maxWidth: '700px', margin: '0 auto', paddingTop: '40px' }}>

      <div style={{ textAlign: 'center', marginBottom: '40px' }}>
        <h1 className="page-title" style={{ fontSize: '2rem', marginBottom: '16px' }}>Calibrate with your Resume</h1>
        <p style={{ color: 'var(--text-secondary)', fontSize: '1.05rem', lineHeight: 1.6 }}>
          Your self-assessment is complete. Optionally upload your current resume so the AI can cross-reference your answers with your documented experience.
        </p>
        <div style={{ marginTop: '16px', display: 'inline-block', padding: '6px 16px', borderRadius: '20px', background: 'rgba(34,197,94,0.1)', color: '#4ade80', fontSize: '0.85rem', fontWeight: 600 }}>
          <CheckCircle size={14} style={{ display: 'inline', marginRight: '6px', verticalAlign: 'middle' }} />
          Adding a resume increases accuracy by up to 40%
        </div>
      </div>

      {!isProcessing ? (
        <div className="glass-panel" style={{ padding: '40px', textAlign: 'center' }}>

          {!file ? (
            <div style={{ padding: '60px 20px', border: '2px dashed var(--glass-border)', borderRadius: '16px', cursor: 'pointer', background: 'rgba(0,0,0,0.2)', transition: 'border 0.2s' }} onMouseEnter={e => e.currentTarget.style.borderColor = 'var(--accent-electric)'} onMouseLeave={e => e.currentTarget.style.borderColor = 'var(--glass-border)'}>
              <UploadCloud size={48} color="var(--accent-electric)" style={{ marginBottom: '16px' }} />
              <h3 style={{ fontSize: '1.2rem', fontWeight: 600, marginBottom: '8px' }}>Drag and drop your resume</h3>
              <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', marginBottom: '24px' }}>PDF, DOCX up to 5MB</p>
              <label className="btn-primary" style={{ cursor: 'pointer', padding: '10px 24px', fontSize: '0.95rem' }}>
                Browse Files
                <input type="file" accept=".pdf,.doc,.docx" onChange={handleFileChange} style={{ display: 'none' }} />
              </label>
            </div>
          ) : (
            <div style={{ padding: '40px 20px', border: '1px solid var(--accent-electric)', borderRadius: '16px', background: 'rgba(59,130,246,0.05)', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
              <FileText size={48} color="var(--accent-electric)" style={{ marginBottom: '16px' }} />
              <h3 style={{ fontSize: '1.2rem', fontWeight: 600, marginBottom: '8px' }}>{file.name}</h3>
              <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', marginBottom: '32px' }}>{(file.size / 1024 / 1024).toFixed(2)} MB</p>
              <div style={{ display: 'flex', gap: '16px' }}>
                <button className="btn-outline" onClick={() => setFile(null)}>Remove</button>
                <button className="btn-primary" onClick={handleAnalyzeResume} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  Analyze Resume <ArrowRight size={16} />
                </button>
              </div>
            </div>
          )}

          {error && (
            <p style={{ color: '#f87171', fontSize: '0.875rem', marginTop: '16px' }}>{error}</p>
          )}

          <div style={{ marginTop: '32px' }}>
            <span style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', marginRight: '16px' }}>Not ready to upload?</span>
            <button className="btn-outline" onClick={handleSkip} style={{ padding: '8px 20px', fontSize: '0.9rem' }}>
              Skip for now
            </button>
          </div>
        </div>
      ) : (
        <div className="glass-panel" style={{ padding: '60px', textAlign: 'center', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
          <div style={{ width: '64px', height: '64px', border: '4px solid rgba(255,255,255,0.1)', borderTopColor: 'var(--accent-electric)', borderRadius: '50%', animation: 'spin 1s linear infinite', marginBottom: '24px' }} />
          <style>{`@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }`}</style>
          <h2 style={{ fontSize: '1.4rem', fontWeight: 600, marginBottom: '8px' }}>Calculating Readiness...</h2>
          <p style={{ color: 'var(--text-secondary)' }}>
            {file ? 'Cross-referencing your resume with your answers across 5 PM dimensions.' : 'Scoring your answers across 5 PM competency dimensions.'}
          </p>
        </div>
      )}
    </div>
  );
}
