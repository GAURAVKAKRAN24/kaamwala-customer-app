import React, { useState } from 'react';
import { X, Star, ShieldCheck, Check } from 'lucide-react';

export default function ReviewModal({ isOpen, onClose, job, onSubmitReview, lang }) {
  if (!isOpen || !job) return null;

  const [rating, setRating] = useState(5);
  const [quality, setQuality] = useState(5);
  const [behaviour, setBehaviour] = useState(5);
  const [ontime, setOntime] = useState(5);
  const [price, setPrice] = useState(5);
  const [text, setText] = useState('');

  const labels = ["Poor", "Fair", "Good", "Very Good", "Excellent"];

  const handleSubmit = (e) => {
    e.preventDefault();
    onSubmitReview(job.id, {
      rating,
      quality,
      behaviour,
      ontime,
      price,
      text: text.trim() || 'Work executed cleanly and on time.'
    });
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex flex-col justify-end animate-in fade-in">
      <div 
        className="bg-white rounded-t-[32px] max-h-[90vh] flex flex-col shadow-2xl overflow-hidden animate-in slide-in-from-bottom duration-300"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="pt-3 pb-2 px-5 flex flex-col items-center border-b border-slate-100 bg-slate-50">
          <div className="w-12 h-1.5 bg-slate-200 rounded-full mb-2"></div>
          <div className="w-full flex items-center justify-between">
            <div>
              <h3 className="text-sm font-extrabold text-slate-900">Rate & Review Technician</h3>
              <p className="text-[10px] text-slate-500 font-mono">Job #{job.id} • Verified Review</p>
            </div>
            <button onClick={onClose} className="w-8 h-8 rounded-full bg-slate-200 hover:bg-slate-300 flex items-center justify-center text-slate-600">
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Body */}
        <form onSubmit={handleSubmit} className="p-4 overflow-y-auto space-y-4 text-xs scrollbar-hide">
          
          {/* Star Picker */}
          <div className="bg-slate-50 border border-slate-200 rounded-2xl p-4 text-center">
            <span className="font-extrabold text-slate-800 text-xs block mb-2">Overall Service Rating</span>
            <div className="flex items-center justify-center gap-2">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  type="button"
                  key={star}
                  onClick={() => setRating(star)}
                  className="p-1 hover:scale-125 transition"
                >
                  <Star 
                    className={`w-7 h-7 ${star <= rating ? 'fill-amber-400 text-amber-400' : 'text-slate-300'}`} 
                  />
                </button>
              ))}
            </div>
            <span className="text-[11px] font-bold text-emerald-700 block mt-1.5">
              {rating}.0 — {labels[rating - 1]}
            </span>
          </div>

          {/* 4 Sub-Ratings required by PRD Section 13 */}
          <div className="bg-slate-50 border border-slate-200 rounded-2xl p-3 space-y-2">
            <span className="font-bold text-slate-800 text-[11px] block">Detailed Quality Feedback</span>
            
            <div className="flex items-center justify-between">
              <span className="text-slate-600">Work Quality & Tools</span>
              <select value={quality} onChange={(e) => setQuality(Number(e.target.value))} className="bg-white border rounded-lg px-2 py-1 font-bold">
                <option value={5}>5 ★ High Quality</option>
                <option value={4}>4 ★ Good</option>
              </select>
            </div>

            <div className="flex items-center justify-between">
              <span className="text-slate-600">Politeness & Behaviour</span>
              <select value={behaviour} onChange={(e) => setBehaviour(Number(e.target.value))} className="bg-white border rounded-lg px-2 py-1 font-bold">
                <option value={5}>5 ★ Very Polite</option>
                <option value={4}>4 ★ Courteous</option>
              </select>
            </div>

            <div className="flex items-center justify-between">
              <span className="text-slate-600">Punctuality (On-Time)</span>
              <select value={ontime} onChange={(e) => setOntime(Number(e.target.value))} className="bg-white border rounded-lg px-2 py-1 font-bold">
                <option value={5}>5 ★ Reached On Time</option>
                <option value={4}>4 ★ Slight Delay</option>
              </select>
            </div>

            <div className="flex items-center justify-between">
              <span className="text-slate-600">Price Fairness</span>
              <select value={price} onChange={(e) => setPrice(Number(e.target.value))} className="bg-white border rounded-lg px-2 py-1 font-bold">
                <option value={5}>5 ★ Fair & Transparent</option>
                <option value={4}>4 ★ Reasonable</option>
              </select>
            </div>
          </div>

          {/* Text feedback */}
          <div>
            <label className="font-bold text-slate-800 text-[11px] block mb-1">Your Feedback</label>
            <textarea
              rows={3}
              value={text}
              onChange={(e) => setText(e.target.value)}
              placeholder="Describe your service experience with the professional..."
              className="w-full bg-slate-50 border border-slate-200 rounded-2xl p-3 text-xs focus:ring-2 focus:ring-emerald-500 focus:bg-white focus:outline-none"
            />
          </div>

          <button
            type="submit"
            className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3.5 rounded-2xl shadow-lg transition flex items-center justify-center gap-2 active:scale-95"
          >
            <span>Publish Verified Review</span>
            <Check className="w-4 h-4" />
          </button>
        </form>
      </div>
    </div>
  );
}
