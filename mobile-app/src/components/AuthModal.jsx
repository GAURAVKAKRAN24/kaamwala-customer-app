import React, { useState } from 'react';
import { X, ShieldCheck, Mail, Lock, Phone, ArrowRight, CheckCircle2, User } from 'lucide-react';

export default function AuthModal({ isOpen, onClose, onLoginSuccess }) {
  const [tab, setTab] = useState('otp'); // 'otp' | 'email'
  const [isSignUp, setIsSignUp] = useState(false);
  const [phone, setPhone] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [loading, setLoading] = useState(false);

  if (!isOpen) return null;

  const handleGoogleLogin = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      onLoginSuccess({
        id: 'usr_g_102',
        name: 'Aarav Sharma',
        email: 'aarav.sharma@gmail.com',
        phone: '+91 98765 43210',
        avatar: 'AS',
        provider: 'Google',
      });
      onClose();
    }, 600);
  };

  const handleSendOtp = () => {
    if (phone.length < 10) {
      alert('Please enter a valid 10-digit mobile number');
      return;
    }
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      setOtpSent(true);
      setOtp('4829'); // instant autofill demo for easy login
    }, 500);
  };

  const handleVerifyOtp = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      onLoginSuccess({
        id: 'usr_p_' + Date.now().toString().slice(-4),
        name: 'Verified Customer',
        email: 'customer@kaamwala.in',
        phone: '+91 ' + phone,
        avatar: 'VC',
        provider: 'Mobile OTP',
      });
      onClose();
    }, 600);
  };

  const handleEmailAuth = (e) => {
    e.preventDefault();
    if (!email || !email.includes('@')) {
      alert('Please enter a valid email');
      return;
    }
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      const userN = isSignUp && name ? name : email.split('@')[0];
      onLoginSuccess({
        id: 'usr_e_' + Date.now().toString().slice(-4),
        name: userN.charAt(0).toUpperCase() + userN.slice(1),
        email: email,
        phone: '+91 98765 43210',
        avatar: userN.slice(0, 2).toUpperCase(),
        provider: 'Email',
      });
      onClose();
    }, 600);
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-end sm:items-center justify-center p-0 sm:p-4 animate-in fade-in duration-200">
      <div className="bg-white w-full sm:max-w-md rounded-t-3xl sm:rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[92vh] animate-in slide-in-from-bottom-6 duration-300">
        
        {/* Header */}
        <div className="p-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-emerald-600 flex items-center justify-center text-white font-black text-sm">
              KW
            </div>
            <div>
              <h3 className="font-extrabold text-slate-900 text-sm">KaamWala Customer Login</h3>
              <p className="text-[10px] text-slate-500 font-medium">Safe • Instant • Transparent Pricing</p>
            </div>
          </div>
          <button onClick={onClose} className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-500 transition">
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Body */}
        <div className="p-5 overflow-y-auto space-y-4 text-xs">
          
          {/* 1-Tap Google Button */}
          <button
            onClick={handleGoogleLogin}
            disabled={loading}
            className="w-full border border-slate-300 hover:bg-slate-50 active:scale-[0.99] font-bold text-slate-800 py-3 rounded-2xl flex items-center justify-center gap-2.5 transition shadow-sm"
          >
            <img
              src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png"
              alt="Google"
              className="w-4 h-4"
            />
            <span className="text-xs">Continue with Google</span>
          </button>

          {/* OR Divider */}
          <div className="flex items-center gap-3">
            <div className="h-px bg-slate-200 flex-1"></div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">or sign in with</span>
            <div className="h-px bg-slate-200 flex-1"></div>
          </div>

          {/* Segmented Switcher */}
          <div className="bg-slate-100 p-1 rounded-xl flex">
            <button
              onClick={() => setTab('otp')}
              className={`flex-1 py-2 rounded-lg font-bold text-xs flex items-center justify-center gap-1.5 transition ${
                tab === 'otp' ? 'bg-white text-emerald-700 shadow-sm' : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Phone className="w-3.5 h-3.5" />
              <span>Mobile OTP</span>
            </button>
            <button
              onClick={() => setTab('email')}
              className={`flex-1 py-2 rounded-lg font-bold text-xs flex items-center justify-center gap-1.5 transition ${
                tab === 'email' ? 'bg-white text-emerald-700 shadow-sm' : 'text-slate-600 hover:text-slate-900'
              }`}
            >
              <Mail className="w-3.5 h-3.5" />
              <span>Email & Password</span>
            </button>
          </div>

          {/* Mobile OTP Form */}
          {tab === 'otp' && (
            <div className="space-y-3">
              {!otpSent ? (
                <>
                  <div>
                    <label className="block text-[11px] font-bold text-slate-700 mb-1">Mobile Number</label>
                    <div className="flex border border-slate-300 rounded-xl overflow-hidden focus-within:border-emerald-600">
                      <span className="bg-slate-100 px-3 py-2.5 text-slate-700 font-bold border-r border-slate-300 flex items-center text-xs">
                        +91
                      </span>
                      <input
                        type="tel"
                        maxLength="10"
                        placeholder="98765 43210"
                        value={phone}
                        onChange={(e) => setPhone(e.target.value)}
                        className="flex-1 px-3 py-2.5 text-xs text-slate-900 focus:outline-none"
                      />
                    </div>
                  </div>
                  <button
                    onClick={handleSendOtp}
                    disabled={loading || phone.length < 10}
                    className="w-full bg-emerald-600 hover:bg-emerald-700 disabled:opacity-50 text-white font-extrabold py-3 rounded-xl transition text-xs shadow-md shadow-emerald-600/20"
                  >
                    {loading ? 'Sending OTP...' : 'Get OTP via SMS'}
                  </button>
                </>
              ) : (
                <>
                  <div className="flex items-center justify-between">
                    <span className="text-[11px] font-bold text-slate-700">Enter 4-Digit OTP for +91 {phone}</span>
                    <button onClick={() => setOtpSent(false)} className="text-[10px] text-emerald-600 font-bold hover:underline">
                      Edit
                    </button>
                  </div>
                  <input
                    type="text"
                    maxLength="4"
                    placeholder="• • • •"
                    value={otp}
                    onChange={(e) => setOtp(e.target.value)}
                    className="w-full text-center text-xl tracking-[12px] font-black border border-slate-300 rounded-xl py-2.5 focus:outline-none focus:border-emerald-600"
                  />
                  <button
                    onClick={handleVerifyOtp}
                    disabled={loading}
                    className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3 rounded-xl transition text-xs shadow-md shadow-emerald-600/20"
                  >
                    {loading ? 'Verifying...' : 'Verify OTP & Continue'}
                  </button>
                </>
              )}
            </div>
          )}

          {/* Email / Password Form */}
          {tab === 'email' && (
            <form onSubmit={handleEmailAuth} className="space-y-3">
              {isSignUp && (
                <div>
                  <label className="block text-[11px] font-bold text-slate-700 mb-1">Full Name</label>
                  <input
                    type="text"
                    placeholder="Aarav Sharma"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="w-full border border-slate-300 rounded-xl px-3 py-2.5 text-xs focus:outline-none focus:border-emerald-600"
                  />
                </div>
              )}
              <div>
                <label className="block text-[11px] font-bold text-slate-700 mb-1">Email Address</label>
                <input
                  type="email"
                  placeholder="name@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full border border-slate-300 rounded-xl px-3 py-2.5 text-xs focus:outline-none focus:border-emerald-600"
                  required
                />
              </div>
              <div>
                <label className="block text-[11px] font-bold text-slate-700 mb-1">Password</label>
                <input
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full border border-slate-300 rounded-xl px-3 py-2.5 text-xs focus:outline-none focus:border-emerald-600"
                  required
                />
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3 rounded-xl transition text-xs shadow-md shadow-emerald-600/20"
              >
                {loading ? 'Processing...' : (isSignUp ? 'Create KaamWala Account' : 'Sign In')}
              </button>

              <div className="text-center pt-1">
                <button
                  type="button"
                  onClick={() => setIsSignUp(!isSignUp)}
                  className="text-[11px] text-slate-500 hover:text-emerald-700 font-bold"
                >
                  {isSignUp ? 'Already have an account? Sign In' : "Don't have an account? Create one"}
                </button>
              </div>
            </form>
          )}

          {/* Privacy footer */}
          <div className="pt-2 border-t border-slate-100 flex items-center justify-center gap-1.5 text-[10px] text-slate-400">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-600" />
            <span>256-Bit SSL Encrypted • Aadhaar Verified Network</span>
          </div>

        </div>
      </div>
    </div>
  );
}
