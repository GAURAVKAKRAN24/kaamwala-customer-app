import React from 'react';
import { X, ShieldCheck, Star, Phone, MessageSquare, Check, ArrowRight, Clock, AlertCircle, Wrench, IndianRupee } from 'lucide-react';

const LIFECYCLE_STAGES = [
  { key: 'REQUESTED', label: '1. Request Posted', desc: 'Request broadcasted to verified local specialists.' },
  { key: 'QUOTATIONS_RECEIVED', label: '2. Quotes Received', desc: 'Technicians sent transparent quotes with inspection fees.' },
  { key: 'WORKER_SELECTED', label: '3. Worker Selected', desc: 'You selected a technician; other quotes expired.' },
  { key: 'WORKER_CONFIRMED', label: '4. Worker Confirmed', desc: 'Technician confirmed arrival slot.' },
  { key: 'ON_THE_WAY', label: '5. On The Way', desc: 'Technician en route with tools and diagnostic kit.' },
  { key: 'ARRIVED', label: '6. Arrived At Site', desc: 'Technician reached customer location.' },
  { key: 'INSPECTION', label: '7. Inspection', desc: 'Checking issue, pressure tests & transparent estimate.' },
  { key: 'WORK_STARTED', label: '8. Work In Progress', desc: 'Work underway with genuine parts and safety protocols.' },
  { key: 'WORK_COMPLETED', label: '9. Work Completed', desc: 'Service completed. Work tested and verified.' },
  { key: 'PAYMENT', label: '10. Payment', desc: 'Authoritative server-calculated bill breakdown.' },
  { key: 'REVIEW', label: '11. Verified Review', desc: 'Submit rating and close service record.' }
];

export default function JobDetailModal({ 
  isOpen, 
  onClose, 
  job, 
  onUpdateJobStatus, 
  onSelectQuote, 
  onOpenChat, 
  onOpenCall, 
  onOpenPayment, 
  onOpenReview,
  lang 
}) {
  if (!isOpen || !job) return null;

  const isHi = lang === 'hi';
  const currentStageIdx = LIFECYCLE_STAGES.findIndex(s => s.key === job.status);

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex flex-col justify-end animate-in fade-in">
      <div 
        className="bg-white rounded-t-[32px] max-h-[92vh] flex flex-col shadow-2xl overflow-hidden animate-in slide-in-from-bottom duration-300"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="pt-3 pb-2 px-5 flex flex-col items-center border-b border-slate-100 bg-slate-50">
          <div className="w-12 h-1.5 bg-slate-200 rounded-full mb-2"></div>
          <div className="w-full flex items-center justify-between">
            <div>
              <div className="flex items-center gap-1.5">
                <span className="font-mono text-[10px] bg-slate-200 text-slate-800 px-1.5 py-0.5 rounded font-extrabold">{job.id}</span>
                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                  {job.status.replace(/_/g, ' ')}
                </span>
              </div>
              <h3 className="text-sm font-extrabold text-slate-900 mt-1">{job.service_name}</h3>
            </div>
            <button onClick={onClose} className="w-8 h-8 rounded-full bg-slate-200 hover:bg-slate-300 flex items-center justify-center text-slate-600">
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Scrollable Body */}
        <div className="p-4 overflow-y-auto space-y-4 text-xs scrollbar-hide">
          
          {/* REAL DOORSTEP STATUS BANNER */}
          <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-3.5 flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-xl bg-emerald-600 flex items-center justify-center text-white font-bold text-xs">
                <ShieldCheck className="w-4 h-4" />
              </div>
              <div>
                <h4 className="font-extrabold text-emerald-950 text-xs">KaamWala Doorstep Protection</h4>
                <p className="text-[10px] text-emerald-700">Verified Pro with standard equipment & 30-day warranty</p>
              </div>
            </div>
            <span className="text-[9px] bg-emerald-200 text-emerald-900 font-extrabold px-2 py-0.5 rounded-full">
              SECURE
            </span>
          </div>

          {/* QUOTATIONS SECTION (If waiting for quotes or quotes received) */}
          {['REQUESTED', 'QUOTATIONS_RECEIVED'].includes(job.status) && (
            <div className="space-y-2.5">
              <div className="flex items-center justify-between">
                <span className="font-extrabold text-slate-900 text-xs">Available Technician Quotes</span>
                <span className="text-[10px] text-slate-500 font-medium">({job.quotes?.length || 0} quotes)</span>
              </div>

              {(!job.quotes || job.quotes.length === 0) ? (
                <div className="bg-slate-50 border border-slate-200 rounded-2xl p-4 text-center space-y-1">
                  <Clock className="w-5 h-5 text-emerald-600 mx-auto animate-spin" />
                  <p className="font-bold text-slate-800 text-xs">Matching Verified Technicians...</p>
                  <p className="text-[10px] text-slate-400">Pros near your locality are reviewing your request.</p>
                </div>
              ) : (
                <div className="space-y-2.5">
                  {job.quotes.map((q) => (
                    <div key={q.id} className="bg-white border-2 border-slate-200 hover:border-emerald-500 rounded-2xl p-3 shadow-xs space-y-2 transition">
                      <div className="flex items-start justify-between">
                        <div className="flex items-center gap-2.5">
                          <img src={q.worker_photo} alt={q.worker_name} className="w-10 h-10 rounded-xl object-cover border border-slate-200" />
                          <div>
                            <span className="font-extrabold text-slate-900 text-xs block">{q.worker_name}</span>
                            <div className="flex items-center gap-1.5 text-[10px] text-slate-500">
                              <span className="flex items-center text-amber-500 font-bold">
                                <Star className="w-3 h-3 fill-amber-400 stroke-none" /> {q.worker_rating}
                              </span>
                              <span>•</span>
                              <span>{q.worker_jobs} jobs</span>
                            </div>
                          </div>
                        </div>
                        <div className="text-right">
                          <span className="text-xs font-black text-slate-900">₹{q.visit_fee}</span>
                          <span className="text-[9px] text-slate-400 block">Inspection Fee</span>
                        </div>
                      </div>

                      <div className="bg-slate-50 p-2 rounded-xl text-[10px] text-slate-600 space-y-1">
                        <div className="flex justify-between">
                          <span>Repair Estimate Range:</span>
                          <strong className="text-slate-800">₹{q.estimate_min} - ₹{q.estimate_max}</strong>
                        </div>
                        <div className="flex justify-between text-emerald-700 font-semibold">
                          <span>Parts Cost:</span>
                          <span>Extra as per MRP</span>
                        </div>
                        <div className="flex justify-between">
                          <span>Arrival Window:</span>
                          <span className="font-bold text-slate-700">{q.arrival_time}</span>
                        </div>
                      </div>

                      <p className="text-[10px] text-slate-600 italic">"{q.message}"</p>

                      <div className="flex items-center gap-2 pt-1">
                        <button 
                          onClick={() => onOpenCall(q.worker_name)}
                          className="bg-slate-100 hover:bg-slate-200 text-slate-700 px-3 py-1.5 rounded-xl font-bold flex items-center gap-1"
                        >
                          <Phone className="w-3 h-3" /> Call
                        </button>
                        <button 
                          onClick={() => onOpenChat(job, q.worker_name)}
                          className="bg-slate-100 hover:bg-slate-200 text-slate-700 px-3 py-1.5 rounded-xl font-bold flex items-center gap-1"
                        >
                          <MessageSquare className="w-3 h-3" /> Chat
                        </button>
                        <button 
                          onClick={() => onSelectQuote(job.id, q)}
                          className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white py-1.5 rounded-xl font-extrabold flex items-center justify-center gap-1 shadow-sm"
                        >
                          <span>Select Pro</span>
                          <Check className="w-3 h-3" />
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* ASSIGNED WORKER CARD (Once worker is selected) */}
          {job.selected_worker && (
            <div className="bg-white border border-slate-200 rounded-2xl p-3.5 space-y-2.5 shadow-xs">
              <div className="flex items-center justify-between">
                <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">Assigned Professional</span>
                <span className="bg-emerald-100 text-emerald-800 text-[9px] font-bold px-2 py-0.5 rounded-full flex items-center gap-1">
                  <ShieldCheck className="w-3 h-3" /> Identity & Skill Verified
                </span>
              </div>
              <div className="flex items-center gap-3">
                <img src={job.selected_worker.worker_photo || 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80'} className="w-12 h-12 rounded-2xl object-cover border border-slate-200" alt="Worker" />
                <div className="flex-1 min-w-0">
                  <h4 className="font-extrabold text-slate-900 text-xs">{job.selected_worker.worker_name}</h4>
                  <div className="flex items-center gap-1.5 text-[10px] text-slate-500 mt-0.5">
                    <span className="flex items-center text-amber-500 font-bold">
                      <Star className="w-3 h-3 fill-amber-400 stroke-none" /> {job.selected_worker.worker_rating || 4.9}
                    </span>
                    <span>•</span>
                    <span>{job.selected_worker.worker_jobs || 310} jobs done</span>
                  </div>
                </div>
                <div className="flex items-center gap-1.5">
                  <button 
                    onClick={() => onOpenCall(job.selected_worker.worker_name)}
                    className="w-8 h-8 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center hover:bg-emerald-100"
                  >
                    <Phone className="w-4 h-4" />
                  </button>
                  <button 
                    onClick={() => onOpenChat(job, job.selected_worker.worker_name)}
                    className="w-8 h-8 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center hover:bg-blue-100"
                  >
                    <MessageSquare className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* 11-STAGE VISUAL LIFECYCLE STEPPER */}
          <div className="bg-slate-50 border border-slate-200 rounded-2xl p-3.5 space-y-2.5">
            <h4 className="font-extrabold text-slate-900 text-xs mb-3">11-Stage KaamWala Service Timeline</h4>
            <div className="space-y-3">
              {LIFECYCLE_STAGES.map((s, idx) => {
                const isPassed = idx < currentStageIdx || job.status === 'CLOSED';
                const isCurrent = idx === currentStageIdx && job.status !== 'CLOSED';

                return (
                  <div key={s.key} className="flex items-start gap-3 relative">
                    {idx < LIFECYCLE_STAGES.length - 1 && (
                      <div className={`absolute left-3 top-6 bottom-0 w-0.5 ${idx < currentStageIdx ? 'bg-emerald-500' : 'bg-slate-200'}`}></div>
                    )}
                    <div className={`w-6 h-6 rounded-full flex items-center justify-center text-[10px] font-bold shrink-0 z-10 ${
                      isPassed ? 'bg-emerald-500 text-white' : 
                      isCurrent ? 'bg-emerald-600 text-white ring-4 ring-emerald-100 animate-pulse' : 
                      'bg-slate-200 text-slate-500'
                    }`}>
                      {isPassed ? <Check className="w-3.5 h-3.5" /> : (idx + 1)}
                    </div>
                    <div className="flex-1 pb-1">
                      <div className="flex items-center justify-between">
                        <span className={`font-bold text-xs ${isCurrent ? 'text-emerald-700 font-extrabold' : isPassed ? 'text-slate-900' : 'text-slate-400'}`}>
                          {s.label}
                        </span>
                        {isCurrent && (
                          <span className="text-[9px] bg-emerald-100 text-emerald-800 font-black px-1.5 py-0.2 rounded">Current</span>
                        )}
                      </div>
                      <p className={`text-[10px] mt-0.5 ${isCurrent ? 'text-slate-600' : 'text-slate-400'}`}>
                        {s.desc}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* ACTION FOOTER */}
          <div className="pt-2">
            {['WORK_COMPLETED', 'PAYMENT'].includes(job.status) && (
              <button 
                onClick={() => onOpenPayment(job)}
                className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3.5 rounded-2xl shadow-lg transition flex items-center justify-center gap-2"
              >
                <span>Authorize & Pay Bill (₹{job.final_amount})</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            )}

            {job.status === 'REVIEW' && (
              <button 
                onClick={() => onOpenReview(job)}
                className="w-full bg-amber-500 hover:bg-amber-600 text-white font-extrabold py-3.5 rounded-2xl shadow-lg transition flex items-center justify-center gap-2"
              >
                <Star className="w-4 h-4 fill-white" />
                <span>Rate & Review Technician</span>
              </button>
            )}

            {job.status === 'CLOSED' && (
              <div className="bg-emerald-50 border border-emerald-200 p-3 rounded-2xl text-center">
                <Check className="w-5 h-5 text-emerald-600 mx-auto mb-1" />
                <span className="font-extrabold text-emerald-900 block">Job Successfully Completed & Closed</span>
                <span className="text-[10px] text-emerald-700">30-day rework warranty active.</span>
              </div>
            )}
          </div>

        </div>
      </div>
    </div>
  );
}
