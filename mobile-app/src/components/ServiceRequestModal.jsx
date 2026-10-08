import React, { useState } from 'react';
import { X, Camera, Calendar, Clock, MapPin, CheckCircle, ArrowRight, ShieldCheck, Sparkles } from 'lucide-react';

export default function ServiceRequestModal({ isOpen, onClose, category, activeLocation, onSubmitJob, lang }) {
  if (!isOpen || !category) return null;

  const isHi = lang === 'hi';
  const subServices = category.sub_services || [];

  const [selectedSub, setSelectedSub] = useState(subServices[0]?.title || 'General Inspection');
  const [description, setDescription] = useState('');
  const [photoAttached, setPhotoAttached] = useState(false);
  const [date, setDate] = useState('Tomorrow (Fri)');
  const [time, setTime] = useState('10:00 AM - 12:00 PM');
  const [instructions, setInstructions] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    setIsSubmitting(true);

    const randomId = `KW-${Math.floor(100000 + Math.random() * 900000)}`;
    const newJob = {
      id: randomId,
      category: category.id,
      service_name: `${selectedSub} (${category.name})`,
      description: description || 'Complete diagnostics and service requested.',
      address: activeLocation || 'Flat 402, Shipra Sun City, Indirapuram, Ghaziabad',
      date: date,
      time: time,
      status: 'REQUESTED',
      visit_fee: category.starting_price || 199,
      estimated_amount: 599,
      final_amount: 599,
      selected_worker: null,
      quotes: []
    };

    setTimeout(() => {
      setIsSubmitting(false);
      onSubmitJob(newJob);
      onClose();
    }, 600);
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex flex-col justify-end animate-in fade-in">
      <div 
        className="bg-white rounded-t-[32px] max-h-[90vh] flex flex-col shadow-2xl overflow-hidden animate-in slide-in-from-bottom duration-300"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="pt-3 pb-2 px-5 flex flex-col items-center border-b border-slate-100 bg-slate-50">
          <div className="w-12 h-1.5 bg-slate-200 rounded-full mb-3"></div>
          <div className="w-full flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="text-2xl">{category.icon}</span>
              <div>
                <h3 className="text-sm font-extrabold text-slate-900">
                  {isHi ? (category.name_hi || category.name) : category.name}
                </h3>
                <p className="text-[10px] text-slate-500">
                  {isHi ? "सत्यापित पेशेवरों से पारदर्शी कोटेशन प्राप्त करें" : "Verified local experts with transparent quotes"}
                </p>
              </div>
            </div>
            <button onClick={onClose} className="w-8 h-8 rounded-full bg-slate-200 hover:bg-slate-300 flex items-center justify-center text-slate-600">
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-4 overflow-y-auto space-y-4 text-xs scrollbar-hide">
          
          {/* Sub Service Picker */}
          <div>
            <label className="font-bold text-slate-800 text-[11px] block mb-1.5">
              {isHi ? "विशिष्ट सेवा चुनें" : "Select Required Service"}
            </label>
            <div className="space-y-1.5">
              {subServices.map((sub) => (
                <div
                  key={sub.id}
                  onClick={() => setSelectedSub(sub.title)}
                  className={`p-3 rounded-2xl border cursor-pointer transition flex items-center justify-between ${
                    selectedSub === sub.title 
                      ? 'border-emerald-500 bg-emerald-50/60 ring-2 ring-emerald-100 shadow-xs' 
                      : 'border-slate-200 bg-white hover:bg-slate-50'
                  }`}
                >
                  <div>
                    <span className="font-bold text-slate-900 text-xs block">
                      {isHi ? (sub.title_hi || sub.title) : sub.title}
                    </span>
                    <span className="text-[10px] text-slate-500">{sub.duration}</span>
                  </div>
                  <span className="text-xs font-black text-emerald-700">₹{sub.price}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Problem Description */}
          <div>
            <label className="font-bold text-slate-800 text-[11px] block mb-1">
              {isHi ? "समस्या का विवरण (वैकल्पिक)" : "Describe the Issue (Optional)"}
            </label>
            <textarea
              rows={2}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder={isHi ? "जैसे: एसी ठंडा नहीं कर रहा है और आवाज आ रही है..." : "E.g. Unit is blowing warm air with slight vibration noise..."}
              className="w-full bg-slate-50 border border-slate-200 rounded-2xl p-3 text-xs focus:ring-2 focus:ring-emerald-500 focus:bg-white focus:outline-none"
            />
          </div>

          {/* Photo upload simulation */}
          <div>
            <label className="font-bold text-slate-800 text-[11px] block mb-1">
              {isHi ? "फोटो या छोटा वीडियो जोड़ें" : "Attach Photo / Proof"}
            </label>
            <div 
              onClick={() => setPhotoAttached(!photoAttached)}
              className="border-2 border-dashed border-slate-200 rounded-2xl p-3 text-center cursor-pointer hover:bg-slate-50 transition"
            >
              {photoAttached ? (
                <div className="flex items-center justify-center gap-2 text-emerald-600 font-bold">
                  <CheckCircle className="w-4 h-4" />
                  <span>1 Photo Attached (Tap to remove)</span>
                </div>
              ) : (
                <div className="flex flex-col items-center">
                  <Camera className="w-5 h-5 text-emerald-600 mb-1" />
                  <span className="text-[11px] font-semibold text-slate-700">
                    {isHi ? "फोटो लें या गैलरी से चुनें" : "Tap to take picture or upload"}
                  </span>
                  <span className="text-[9px] text-slate-400">Encrypted & shared only with assigned technician</span>
                </div>
              )}
            </div>
          </div>

          {/* Date & Time Slot */}
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="font-bold text-slate-800 text-[10px] block mb-1">
                {isHi ? "तारीख" : "Preferred Date"}
              </label>
              <select 
                value={date} 
                onChange={(e) => setDate(e.target.value)}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-2.5 py-2 font-medium"
              >
                <option value="Today (Urgent)">Today (Urgent 30m)</option>
                <option value="Tomorrow (Fri)">Tomorrow</option>
                <option value="This Weekend">This Weekend</option>
              </select>
            </div>

            <div>
              <label className="font-bold text-slate-800 text-[10px] block mb-1">
                {isHi ? "समय स्लॉट" : "Time Slot"}
              </label>
              <select 
                value={time} 
                onChange={(e) => setTime(e.target.value)}
                className="w-full bg-slate-50 border border-slate-200 rounded-xl px-2.5 py-2 font-medium"
              >
                <option value="Immediate (within 45m)">Immediate (45m)</option>
                <option value="10:00 AM - 12:00 PM">10 AM - 12 PM</option>
                <option value="02:00 PM - 04:00 PM">02 PM - 04 PM</option>
                <option value="06:00 PM - 08:00 PM">06 PM - 08 PM</option>
              </select>
            </div>
          </div>

          {/* Confirmed Address */}
          <div className="bg-slate-50 p-3 rounded-2xl border border-slate-200 flex items-start gap-2.5">
            <MapPin className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
            <div className="text-[11px] leading-snug">
              <span className="font-bold text-slate-900 block">Service Address:</span>
              <span className="text-slate-600 block">{activeLocation}</span>
            </div>
          </div>

          {/* Submit Button */}
          <div className="pt-2">
            <button
              type="submit"
              disabled={isSubmitting}
              className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3.5 rounded-2xl shadow-lg transition flex items-center justify-center gap-2 active:scale-95"
            >
              {isSubmitting ? (
                <span>Posting Request...</span>
              ) : (
                <>
                  <span>{isHi ? "अनुरोध भेजें और कारीगर खोजें" : "Post Request & Match Pros"}</span>
                  <ArrowRight className="w-4 h-4" />
                </>
              )}
            </button>
          </div>

        </form>
      </div>
    </div>
  );
}
