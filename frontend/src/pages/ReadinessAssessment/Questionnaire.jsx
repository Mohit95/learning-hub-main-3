import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight } from 'lucide-react';

const questions = [
  {
    id: 1,
    category: "Product Sense",
    dimension: "product_sense",
    question: "Our Quick-Commerce app saw a 15% drop in checkout completions, but 'Add to Cart' is stable. Walk me through your first three steps to find the root cause.",
    hint: "Think about: user segmentation, technical health checks, and session-level data."
  },
  {
    id: 2,
    category: "Product Sense",
    dimension: "product_sense",
    question: "We want to launch a 'Subscription' model for daily milk/bread. What is the smallest MVP you would launch to test if users actually want this?",
    hint: "Think about: how to validate demand without building full infrastructure."
  },
  {
    id: 3,
    category: "Analytical Thinking",
    dimension: "analytical_thinking",
    question: "For a Dark Store Operations tool, what is the single most important North Star metric? Why is 'Total Order Volume' a dangerous primary metric?",
    hint: "Think about: unit economics, quality vs. quantity of orders."
  },
  {
    id: 4,
    category: "Analytical Thinking",
    dimension: "analytical_thinking",
    question: "A feature improves search accuracy by 10% but adds 300ms of latency. How do you decide whether to ship it?",
    hint: "Think about: how you'd measure the trade-off, what metric decides the call."
  },
  {
    id: 5,
    category: "Technical & Operational Fluency",
    dimension: "technical_fluency",
    question: "A customer reports that their real-time rider tracking is lagging by 2 minutes. Where are the likely technical bottlenecks?",
    hint: "Think about: GPS, data sync, backend write latency."
  },
  {
    id: 6,
    category: "Technical & Operational Fluency",
    dimension: "technical_fluency",
    question: "We want to use AI to predict stock-outs 2 hours in advance. What 3 data points are most critical for this model?",
    hint: "Think about: real-time signals, supply chain data, external factors."
  },
  {
    id: 7,
    category: "Execution & Prioritization",
    dimension: "execution",
    question: "At 9:00 AM, the Payment Gateway is failing for 10% of users. You also have a major feature launch at 10:00 AM. What is your immediate triage plan?",
    hint: "Think about: what you pause, who you tell, and in what order."
  },
  {
    id: 8,
    category: "Execution & Prioritization",
    dimension: "execution",
    question: "A powerful stakeholder insists on a 'Social Feed' feature that you believe adds clutter. How do you use data to say 'No' or 'Not Now'?",
    hint: "Think about: frameworks for deprioritisation, how to make it data-driven not personal."
  },
  {
    id: 9,
    category: "Strategy & Market Fit",
    dimension: "strategy",
    question: "A competitor launches 10-minute delivery in your zone where you take 20 minutes. Do you match their speed or pivot? Why?",
    hint: "Think about: unit economics, sustainable differentiation, your current strengths."
  },
  {
    id: 10,
    category: "Strategy & Market Fit",
    dimension: "strategy",
    question: "If you had to kill one secondary feature to make the core app 2x faster, which would you pick and how would you justify it?",
    hint: "Think about: impact on core user journey, usage data, opportunity cost."
  }
];

const MIN_CHARS = 80;

export default function Questionnaire() {
  const navigate = useNavigate();
  const [currentStep, setCurrentStep] = useState(0);
  const [answers, setAnswers] = useState(
    Array(questions.length).fill(null).map((_, i) => ({ dimension: questions[i].dimension, answer: '' }))
  );

  const q = questions[currentStep];
  const currentAnswer = answers[currentStep].answer;
  const charCount = currentAnswer.length;
  const isValid = charCount >= MIN_CHARS;
  const progress = ((currentStep + 1) / questions.length) * 100;

  const handleChange = (val) => {
    setAnswers(prev => {
      const updated = [...prev];
      updated[currentStep] = { dimension: q.dimension, answer: val };
      return updated;
    });
  };

  const handleNext = () => {
    if (currentStep < questions.length - 1) {
      setCurrentStep(prev => prev + 1);
    } else {
      navigate('/app/readiness/resume-upload', { state: { answers } });
    }
  };

  const handlePrev = () => {
    if (currentStep > 0) setCurrentStep(prev => prev - 1);
    else navigate('/app/readiness');
  };

  return (
    <div className="page animate-fade-in" style={{ maxWidth: '700px', margin: '0 auto', paddingTop: '40px' }}>

      {/* Progress Bar */}
      <div style={{ marginBottom: '40px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '8px' }}>
          <span>Question {currentStep + 1} of {questions.length}</span>
          <span>{Math.round(progress)}%</span>
        </div>
        <div style={{ height: '6px', background: 'rgba(255,255,255,0.05)', borderRadius: '3px', overflow: 'hidden' }}>
          <div style={{ height: '100%', background: 'var(--accent-electric)', width: `${progress}%`, transition: 'width 0.3s ease' }} />
        </div>
      </div>

      <div className="glass-panel animate-fade-in" key={currentStep} style={{ padding: '40px' }}>
        {/* Category label */}
        <div style={{ fontSize: '0.75rem', color: 'var(--accent-violet)', fontWeight: 600, marginBottom: '12px', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
          Category: {q.category}
        </div>

        {/* Question */}
        <h2 style={{ fontSize: '1.3rem', fontWeight: 600, lineHeight: 1.6, marginBottom: '12px' }}>
          {q.question}
        </h2>

        {/* Hint */}
        <p style={{ fontSize: '0.8rem', color: 'var(--text-secondary)', fontStyle: 'italic', marginBottom: '28px' }}>
          💡 Hint: {q.hint}
        </p>

        {/* Textarea */}
        <textarea
          value={currentAnswer}
          onChange={(e) => handleChange(e.target.value)}
          placeholder="Write your answer here..."
          style={{
            width: '100%',
            minHeight: '120px',
            background: 'rgba(255,255,255,0.04)',
            border: '1px solid var(--glass-border)',
            borderRadius: '10px',
            padding: '14px 16px',
            color: 'var(--text-primary)',
            fontSize: '0.95rem',
            lineHeight: 1.6,
            resize: 'vertical',
            outline: 'none',
            fontFamily: 'inherit',
            boxSizing: 'border-box',
            transition: 'border-color 0.2s',
          }}
          onFocus={e => e.target.style.borderColor = 'var(--accent-electric)'}
          onBlur={e => e.target.style.borderColor = 'var(--glass-border)'}
        />

        {/* Character counter */}
        <div style={{ display: 'flex', justifyContent: 'flex-end', marginTop: '8px', fontSize: '0.78rem', color: isValid ? 'var(--accent-violet)' : 'var(--text-secondary)' }}>
          {isValid ? '✓ Good length' : `${charCount} / ${MIN_CHARS} characters minimum`}
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '32px' }}>
        <button className="btn-outline" onClick={handlePrev} style={{ display: 'flex', alignItems: 'center', gap: '8px', padding: '10px 20px' }}>
          <ArrowLeft size={16} /> Back
        </button>
        <button
          className="btn-primary"
          onClick={handleNext}
          disabled={!isValid}
          style={{ display: 'flex', alignItems: 'center', gap: '8px', padding: '10px 24px', opacity: !isValid ? 0.5 : 1, cursor: !isValid ? 'not-allowed' : 'pointer' }}
        >
          {currentStep === questions.length - 1 ? 'Finish & Next' : 'Continue'} <ArrowRight size={16} />
        </button>
      </div>

    </div>
  );
}
