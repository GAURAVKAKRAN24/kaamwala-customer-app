import React from 'react';
import { Phone, ShieldCheck, X } from 'lucide-react';

export default function MaskedCallModal({ isOpen, onClose, workerName }) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 animate-in fade-in">
      <div className="bg-white rounded-3xl max-w-xs w-full p-5 text-center shadow-2xl animate-in zoom-in-95 space-y-3">
        <div className="w-16 h-16 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto text-2xl animate-pulse">
          <Phone className="w-7 h-7" />
        </div>
        
        <div>
          <h4 className="text-sm font-extrabold text-slate-900">KaamWala Masked Telephony</h4>
          <p className="text-[11px] text-slate-500 mt-0.5">Calling {workerName || 'Technician'}...</p>
        </div>

        <div className="bg-slate-50 p-3 rounded-2xl border border-slate-100 text-[10px] text-left space-y-1">
          <div className="flex items-center gap-1.5 text-emerald-700 font-bold">
            <ShieldCheck className="w-4 h-4" />
            <span>100% Privacy Protected</span>
          </div>
          <p className="text-slate-500">Your personal mobile number is masked via KaamWala telecom bridge.</p>
          <p className="text-slate-400 font-mono">Virtual Bridge DID: +91 11-4089-9800</p>
        </div>

        <button 
          onClick={onClose}
          className="w-full bg-red-600 hover:bg-red-700 text-white font-extrabold py-2.5 rounded-xl text-xs transition"
        >
          End Call
        </button>
      </div>
    </div>
  );
}
