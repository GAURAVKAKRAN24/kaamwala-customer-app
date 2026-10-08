import React, { useState } from 'react';
import { X, Phone, Send, Paperclip, ShieldCheck, CheckCheck } from 'lucide-react';

export default function ChatModal({ isOpen, onClose, job, workerName, onOpenCall }) {
  if (!isOpen) return null;

  const [messages, setMessages] = useState([
    { id: 1, role: 'SYSTEM', text: `Service request #${job?.id || 'KW-904128'} created. Matching verified technicians.` },
    { id: 2, role: 'WORKER', name: workerName || 'Manoj Kumar', text: 'Namaste ji! I am nearby in Sector 62. Does the outdoor AC unit have safe balcony access?', time: '10:15 AM' },
    { id: 3, role: 'CUSTOMER', name: 'Rahul Sharma', text: 'Yes, it is mounted directly on the balcony railing, easily accessible.', time: '10:18 AM' }
  ]);
  const [inputText, setInputText] = useState('');

  const handleSend = (e) => {
    e.preventDefault();
    if (!inputText.trim()) return;

    const newMsg = {
      id: Date.now(),
      role: 'CUSTOMER',
      name: 'Rahul Sharma',
      text: inputText.trim(),
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };

    setMessages([...messages, newMsg]);
    setInputText('');

    // Quick auto response simulation
    setTimeout(() => {
      setMessages(prev => [
        ...prev,
        {
          id: Date.now() + 1,
          role: 'WORKER',
          name: workerName || 'Manoj Kumar',
          text: 'Understood. Carrying high-pressure jet wash pump and digital manifold gauge. Reaching on time!',
          time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
        }
      ]);
    }, 1200);
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex flex-col justify-end animate-in fade-in">
      <div 
        className="bg-white rounded-t-[32px] h-[85vh] flex flex-col shadow-2xl overflow-hidden animate-in slide-in-from-bottom duration-300"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="px-4 py-3 bg-slate-900 text-white flex items-center justify-between shadow-sm">
          <div className="flex items-center gap-2.5">
            <button onClick={onClose} className="text-slate-300 hover:text-white mr-1">
              <X className="w-5 h-5" />
            </button>
            <div className="w-9 h-9 rounded-full bg-emerald-500 text-white font-bold flex items-center justify-center text-xs">
              {workerName ? workerName.charAt(0) : 'M'}
            </div>
            <div>
              <div className="flex items-center gap-1">
                <span className="font-extrabold text-xs text-white">{workerName || 'Manoj Kumar'}</span>
                <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
              </div>
              <span className="text-[10px] text-slate-400 block font-mono">Job #{job?.id || 'KW-904128'} • Online</span>
            </div>
          </div>
          <button 
            onClick={() => onOpenCall(workerName)}
            className="w-8 h-8 rounded-full bg-slate-800 text-emerald-400 flex items-center justify-center hover:bg-slate-700"
          >
            <Phone className="w-4 h-4" />
          </button>
        </div>

        {/* Message Stream */}
        <div className="flex-1 overflow-y-auto p-4 space-y-3 bg-slate-100 text-xs scrollbar-hide">
          {messages.map((m) => {
            if (m.role === 'SYSTEM') {
              return (
                <div key={m.id} className="text-center my-2">
                  <span className="bg-slate-200 text-slate-600 text-[10px] font-semibold px-3 py-1 rounded-full shadow-xs">
                    {m.text}
                  </span>
                </div>
              );
            }

            const isMe = m.role === 'CUSTOMER';
            return (
              <div key={m.id} className={`flex flex-col ${isMe ? 'items-end' : 'items-start'}`}>
                <div className={`max-w-[78%] rounded-2xl p-2.5 shadow-xs ${
                  isMe ? 'bg-emerald-600 text-white rounded-tr-none' : 'bg-white text-slate-800 border border-slate-200 rounded-tl-none'
                }`}>
                  <span className={`text-[9px] font-bold block mb-0.5 ${isMe ? 'text-emerald-200' : 'text-slate-400'}`}>
                    {m.name}
                  </span>
                  <p className="leading-relaxed">{m.text}</p>
                </div>
                <div className="flex items-center gap-1 text-[9px] text-slate-400 mt-0.5 px-1">
                  <span>{m.time}</span>
                  {isMe && <CheckCheck className="w-3 h-3 text-emerald-600" />}
                </div>
              </div>
            );
          })}
        </div>

        {/* Input Bar */}
        <form onSubmit={handleSend} className="p-3 bg-white border-t border-slate-200 flex items-center gap-2 safe-bottom">
          <button type="button" className="text-slate-400 hover:text-emerald-600 p-2">
            <Paperclip className="w-4 h-4" />
          </button>
          <input
            type="text"
            value={inputText}
            onChange={(e) => setInputText(e.target.value)}
            placeholder="Type message to technician..."
            className="flex-1 bg-slate-100 border border-slate-200 rounded-full px-4 py-2.5 text-xs focus:outline-none focus:ring-2 focus:ring-emerald-500 font-medium"
          />
          <button type="submit" className="w-9 h-9 rounded-full bg-emerald-600 text-white flex items-center justify-center shadow-md active:scale-95">
            <Send className="w-4 h-4" />
          </button>
        </form>
      </div>
    </div>
  );
}
