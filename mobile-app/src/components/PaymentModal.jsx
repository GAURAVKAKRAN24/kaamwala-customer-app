import React, { useState } from 'react';
import { X, ShieldCheck, Check, Lock, Tag, ArrowRight } from 'lucide-react';

export default function PaymentModal({ isOpen, onClose, job, onCompletePayment, lang }) {
  if (!isOpen || !job) return null;

  const isHi = lang === 'hi';
  const baseCharge = job.final_amount || job.estimated_amount || 699;
  const platformFee = 19;
  const [coupon, setCoupon] = useState('FIRST100');
  const [discount, setDiscount] = useState(100);
  const [selectedMethod, setSelectedMethod] = useState('UPI');
  const [isProcessing, setIsProcessing] = useState(false);

  const taxable = Math.max(0, (baseCharge + platformFee) - discount);
  const gst = Math.round(taxable * 0.18);
  const total = taxable + gst;

  const applyCoupon = () => {
    if (coupon.trim().toUpperCase() === 'FIRST100') {
      setDiscount(100);
      alert("Coupon 'FIRST100' applied successfully! Saved ₹100.");
    } else {
      alert("Invalid coupon code.");
    }
  };

  const handlePay = () => {
    setIsProcessing(true);
    setTimeout(() => {
      setIsProcessing(false);
      onCompletePayment(job.id, total);
      onClose();
    }, 800);
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
              <h3 className="text-sm font-extrabold text-slate-900 flex items-center gap-1.5">
                <Lock className="w-4 h-4 text-emerald-600" />
                <span>{isHi ? "सुरक्षित भुगतान" : "KaamWala Secure Pay"}</span>
              </h3>
              <p className="text-[10px] text-slate-500 font-mono">Job #{job.id} • Verified Escrow</p>
            </div>
            <button onClick={onClose} className="w-8 h-8 rounded-full bg-slate-200 hover:bg-slate-300 flex items-center justify-center text-slate-600">
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Body */}
        <div className="p-4 overflow-y-auto space-y-4 text-xs scrollbar-hide">
          
          {/* Bill Breakdown */}
          <div className="bg-slate-50 border border-slate-200 rounded-2xl p-3.5 space-y-2">
            <span className="font-extrabold text-slate-900 text-xs block mb-1">Authoritative Bill Breakdown</span>
            <div className="flex justify-between text-slate-600">
              <span>Service & Inspection Fee</span>
              <span>₹{baseCharge}</span>
            </div>
            <div className="flex justify-between text-slate-600">
              <span>Platform Safety Fee</span>
              <span>₹{platformFee}</span>
            </div>
            {discount > 0 && (
              <div className="flex justify-between text-emerald-700 font-bold">
                <span>Coupon Discount ({coupon})</span>
                <span>- ₹{discount}</span>
              </div>
            )}
            <div className="flex justify-between text-slate-600">
              <span>GST (18% as per Govt rules)</span>
              <span>₹{gst}</span>
            </div>
            <div className="border-t border-slate-200 pt-2 flex justify-between font-extrabold text-slate-900 text-sm">
              <span>Total Amount Payable</span>
              <span className="text-emerald-700">₹{total}</span>
            </div>
          </div>

          {/* Coupon Box */}
          <div className="flex gap-2">
            <div className="relative flex-1">
              <Tag className="w-4 h-4 text-slate-400 absolute left-3 top-2.5" />
              <input
                type="text"
                value={coupon}
                onChange={(e) => setCoupon(e.target.value)}
                placeholder="Promo Code"
                className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-3 py-2 text-xs font-mono font-bold uppercase focus:outline-none"
              />
            </div>
            <button 
              onClick={applyCoupon}
              className="bg-slate-900 hover:bg-black text-white px-4 py-2 rounded-xl font-bold text-xs"
            >
              Apply
            </button>
          </div>

          {/* Payment Methods */}
          <div className="space-y-2">
            <span className="font-bold text-slate-800 text-xs block">Choose Payment Method</span>

            {/* UPI */}
            <div 
              onClick={() => setSelectedMethod('UPI')}
              className={`p-3 rounded-2xl border cursor-pointer transition flex items-center justify-between ${
                selectedMethod === 'UPI' ? 'border-emerald-600 bg-emerald-50/50 ring-2 ring-emerald-100' : 'border-slate-200 bg-white'
              }`}
            >
              <div>
                <div className="flex items-center gap-1.5">
                  <span className="font-extrabold text-slate-900 text-xs">UPI (Instant Zero Fee)</span>
                  <span className="bg-emerald-200 text-emerald-900 text-[8px] font-black px-1.5 py-0.2 rounded">Recommended</span>
                </div>
                <span className="text-[10px] text-slate-500">Google Pay, PhonePe, Paytm, BHIM</span>
              </div>
              <div className={`w-4 h-4 rounded-full border flex items-center justify-center ${selectedMethod === 'UPI' ? 'border-emerald-600 bg-emerald-600 text-white' : 'border-slate-300'}`}>
                {selectedMethod === 'UPI' && <Check className="w-3 h-3" />}
              </div>
            </div>

            {/* Cards */}
            <div 
              onClick={() => setSelectedMethod('CARD')}
              className={`p-3 rounded-2xl border cursor-pointer transition flex items-center justify-between ${
                selectedMethod === 'CARD' ? 'border-emerald-600 bg-emerald-50/50 ring-2 ring-emerald-100' : 'border-slate-200 bg-white'
              }`}
            >
              <div>
                <span className="font-extrabold text-slate-900 text-xs block">Credit / Debit Card</span>
                <span className="text-[10px] text-slate-500">Visa, Mastercard, RuPay</span>
              </div>
              <div className={`w-4 h-4 rounded-full border flex items-center justify-center ${selectedMethod === 'CARD' ? 'border-emerald-600 bg-emerald-600 text-white' : 'border-slate-300'}`}>
                {selectedMethod === 'CARD' && <Check className="w-3 h-3" />}
              </div>
            </div>

            {/* Pay After Service */}
            <div 
              onClick={() => setSelectedMethod('CASH')}
              className={`p-3 rounded-2xl border cursor-pointer transition flex items-center justify-between ${
                selectedMethod === 'CASH' ? 'border-emerald-600 bg-emerald-50/50 ring-2 ring-emerald-100' : 'border-slate-200 bg-white'
              }`}
            >
              <div>
                <span className="font-extrabold text-slate-900 text-xs block">Pay Technician Directly</span>
                <span className="text-[10px] text-slate-500">Cash or UPI QR upon satisfaction</span>
              </div>
              <div className={`w-4 h-4 rounded-full border flex items-center justify-center ${selectedMethod === 'CASH' ? 'border-emerald-600 bg-emerald-600 text-white' : 'border-slate-300'}`}>
                {selectedMethod === 'CASH' && <Check className="w-3 h-3" />}
              </div>
            </div>
          </div>

          {/* Pay Button */}
          <div className="pt-2">
            <button
              onClick={handlePay}
              disabled={isProcessing}
              className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3.5 rounded-2xl shadow-lg transition flex items-center justify-center gap-2 active:scale-95"
            >
              {isProcessing ? (
                <span>Verifying Payment...</span>
              ) : (
                <>
                  <span>Pay ₹{total} via {selectedMethod}</span>
                  <Lock className="w-4 h-4" />
                </>
              )}
            </button>
          </div>

        </div>
      </div>
    </div>
  );
}
