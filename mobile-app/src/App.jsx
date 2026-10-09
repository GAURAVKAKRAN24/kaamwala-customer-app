import React, { useState } from 'react';
import { 
  MapPin, Bell, Search, ShieldCheck, Star, ChevronRight, Phone, MessageSquare, 
  Calendar, Clock, CheckCircle, Crown, Plus, Wrench, Home, ClipboardList, 
  User, Sparkles, Filter, AlertCircle, ArrowRight
} from 'lucide-react';
import { INDIAN_LOCALITIES, SERVICE_CATEGORIES, TOP_WORKERS, INITIAL_JOB, CARE_PLANS } from './data/mockData';
import LocationPickerModal from './components/LocationPickerModal';
import ServiceRequestModal from './components/ServiceRequestModal';
import JobDetailModal from './components/JobDetailModal';
import ChatModal from './components/ChatModal';
import PaymentModal from './components/PaymentModal';
import ReviewModal from './components/ReviewModal';
import MaskedCallModal from './components/MaskedCallModal';
import AuthModal from './components/AuthModal';

export default function App() {
  // Navigation & Language
  const [activeTab, setActiveTab] = useState('home');
  const [lang, setLang] = useState('en');

  // User Authentication State
  const [currentUser, setCurrentUser] = useState({
    id: 'usr-101',
    name: 'Aarav Sharma',
    phone: '+91 98765 43210',
    email: 'aarav.sharma@gmail.com',
    avatar: 'AS',
    isAadhaarVerified: true
  });
  const [isAuthModalOpen, setIsAuthModalOpen] = useState(false);

  // Location State (Auto-detected default)
  const [activeLocation, setActiveLocation] = useState('Indirapuram, Ghaziabad (Shipra Sun City)');
  const [isLocationModalOpen, setIsLocationModalOpen] = useState(false);

  // Modals
  const [selectedCategoryForBooking, setSelectedCategoryForBooking] = useState(null);
  const [isJobDetailOpen, setIsJobDetailOpen] = useState(false);
  const [activeJob, setActiveJob] = useState(INITIAL_JOB);
  const [allJobs, setAllJobs] = useState([INITIAL_JOB]);
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [chatWorkerName, setChatWorkerName] = useState('Manoj Kumar Verma');
  const [isCallOpen, setIsCallOpen] = useState(false);
  const [callWorkerName, setCallWorkerName] = useState('');
  const [isPaymentOpen, setIsPaymentOpen] = useState(false);
  const [isReviewOpen, setIsReviewOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [toastMessage, setToastMessage] = useState(null);

  const isHi = lang === 'hi';

  const showToast = (msg) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3000);
  };

  // Handle new service request creation
  const handleCreateJob = (newJob) => {
    setActiveJob(newJob);
    setAllJobs([newJob, ...allJobs]);
    showToast(`Request #${newJob.id} posted! Matching local professionals...`);

    // Simulate incoming quotes after 1.5 seconds
    setTimeout(() => {
      const simulatedQuotes = [
        {
          id: `qt-${Date.now()}-1`,
          worker_id: 'wrk-001',
          worker_name: 'Manoj Kumar Verma',
          worker_rating: 4.9,
          worker_jobs: 310,
          worker_photo: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80',
          visit_fee: newJob.visit_fee || 199,
          estimate_min: 499,
          estimate_max: 799,
          parts_extra: true,
          message: 'Available to inspect immediately. 30-day warranty on workmanship.',
          arrival_time: 'Can reach in 30 mins'
        },
        {
          id: `qt-${Date.now()}-2`,
          worker_id: 'wrk-002',
          worker_name: 'Rajesh Prajapati',
          worker_rating: 4.85,
          worker_jobs: 240,
          worker_photo: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
          visit_fee: 149,
          estimate_min: 450,
          estimate_max: 850,
          parts_extra: true,
          message: 'Electrical and motor diagnostic expert. Clean work guaranteed.',
          arrival_time: 'Available in 45 mins'
        }
      ];

      setActiveJob(prev => ({
        ...prev,
        status: 'QUOTATIONS_RECEIVED',
        quotes: simulatedQuotes
      }));

      setAllJobs(prev => prev.map(j => j.id === newJob.id ? { ...j, status: 'QUOTATIONS_RECEIVED', quotes: simulatedQuotes } : j));
      showToast(`2 Quotes received for #${newJob.id}!`);
    }, 1800);

    setIsJobDetailOpen(true);
  };

  // Status transitions
  const handleUpdateJobStatus = (jobId, newStatus) => {
    setActiveJob(prev => ({ ...prev, status: newStatus }));
    setAllJobs(prev => prev.map(j => j.id === jobId ? { ...j, status: newStatus } : j));
    showToast(`Status updated: ${newStatus.replace(/_/g, ' ')}`);
  };

  // Select quote
  const handleSelectQuote = (jobId, quote) => {
    setActiveJob(prev => ({
      ...prev,
      status: 'WORKER_CONFIRMED',
      selected_worker: quote
    }));
    setAllJobs(prev => prev.map(j => j.id === jobId ? { ...j, status: 'WORKER_CONFIRMED', selected_worker: quote } : j));
    showToast(`${quote.worker_name} selected & confirmed!`);
  };

  // Payment completed
  const handleCompletePayment = (jobId, amount) => {
    setActiveJob(prev => ({ ...prev, status: 'REVIEW', final_amount: amount }));
    setAllJobs(prev => prev.map(j => j.id === jobId ? { ...j, status: 'REVIEW', final_amount: amount } : j));
    showToast(`Payment of ₹${amount} verified! Receipt generated.`);
    setIsReviewOpen(true);
  };

  // Review submitted
  const handleSubmitReview = (jobId, reviewData) => {
    setActiveJob(prev => ({ ...prev, status: 'CLOSED' }));
    setAllJobs(prev => prev.map(j => j.id === jobId ? { ...j, status: 'CLOSED' } : j));
    showToast('Verified Review Published with Badge!');
  };

  // Filter categories by search
  const displayedCategories = searchQuery.trim() === ''
    ? SERVICE_CATEGORIES
    : SERVICE_CATEGORIES.filter(c => 
        c.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        c.desc.toLowerCase().includes(searchQuery.toLowerCase())
      );

  return (
    <div className="w-full flex-1 flex flex-col bg-slate-50 relative min-h-screen text-slate-800 font-sans antialiased pb-20 select-none">
      
      {/* ========================================================================= */}
      {/* 1. STICKY MOBILE TOP BAR (Location Selector + Lang Toggle + Notifications) */}
      {/* ========================================================================= */}
      <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200/80 px-4 py-3 shadow-xs">
        <div className="flex items-center justify-between">
          
          {/* Location Bar Pill (Click opens LocationPickerModal) */}
          <div 
            onClick={() => setIsLocationModalOpen(true)}
            className="flex items-center gap-1.5 cursor-pointer hover:opacity-80 active:scale-95 transition"
          >
            <div className="w-8 h-8 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center shrink-0">
              <MapPin className="w-4 h-4" />
            </div>
            <div className="truncate max-w-[190px]">
              <div className="flex items-center gap-1">
                <span className="font-extrabold text-xs text-slate-900 truncate">
                  {activeLocation.split(',')[0]}
                </span>
                <span className="text-[10px] text-emerald-600 font-bold">▾</span>
              </div>
              <span className="text-[10px] text-slate-500 truncate block">
                {activeLocation}
              </span>
            </div>
          </div>

          {/* Right Header: Language toggle + User Avatar / Login */}
          <div className="flex items-center gap-2">
            <button 
              onClick={() => setLang(lang === 'en' ? 'hi' : 'en')}
              className="bg-slate-100 hover:bg-slate-200 border border-slate-200 px-2 py-1 rounded-xl text-[11px] font-extrabold text-slate-800 transition"
            >
              {lang === 'en' ? 'हिन्दी' : 'EN'}
            </button>
            {currentUser ? (
              <button 
                onClick={() => setActiveTab('profile')}
                className="w-8 h-8 rounded-xl bg-emerald-600 text-white font-black text-xs flex items-center justify-center shadow-xs hover:bg-emerald-700 transition"
                title={currentUser.name}
              >
                {currentUser.avatar}
              </button>
            ) : (
              <button 
                onClick={() => setIsAuthModalOpen(true)}
                className="bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] font-bold px-2.5 py-1 rounded-xl shadow-xs transition"
              >
                Login
              </button>
            )}
          </div>

        </div>

        {/* Search Bar */}
        <div className="mt-2.5 relative">
          <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder={isHi ? "किस सेवा की जरूरत है? (AC, प्लम्बर, बिजली...)" : "What service do you need? (AC, Plumber, RO...)"}
            className="w-full bg-slate-100 border border-slate-200 rounded-2xl pl-10 pr-4 py-2.5 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:bg-white focus:outline-none transition shadow-2xs"
          />
        </div>
      </header>

      {/* ========================================================================= */}
      {/* 2. TAB CONTENT BODY */}
      {/* ========================================================================= */}
      <main className="flex-1 p-4 space-y-4 overflow-y-auto scrollbar-hide">

        {/* -------------------- TAB 1: HOME -------------------- */}
        {activeTab === 'home' && (
          <>
            {/* Active Service Card Banner (If active job in progress) */}
            {activeJob && !['CLOSED', 'CANCELLED'].includes(activeJob.status) && (
              <div 
                onClick={() => setIsJobDetailOpen(true)}
                className="bg-gradient-to-r from-slate-900 to-slate-800 text-white rounded-2xl p-3.5 shadow-md border border-slate-700 cursor-pointer active:scale-[0.99] transition"
              >
                <div className="flex items-center justify-between mb-1.5">
                  <div className="flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                    <span className="text-[10px] font-bold uppercase tracking-wider text-emerald-300">
                      Service In Progress
                    </span>
                  </div>
                  <span className="text-[10px] font-mono bg-slate-700 px-2 py-0.5 rounded text-slate-300 font-bold">
                    {activeJob.id}
                  </span>
                </div>
                <div className="flex items-center justify-between">
                  <div>
                    <h4 className="text-xs font-extrabold text-white">{activeJob.service_name}</h4>
                    <p className="text-[10px] text-slate-300 mt-0.5">
                      Status: <strong className="text-emerald-300">{activeJob.status.replace(/_/g, ' ')}</strong>
                    </p>
                  </div>
                  <div className="bg-emerald-500 hover:bg-emerald-600 text-white text-[11px] font-bold px-3 py-1.5 rounded-xl shadow-xs flex items-center gap-1">
                    <span>Track</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </div>
                </div>
              </div>
            )}

            {/* Quick Hero Banner / Care Plan */}
            <div className="bg-gradient-to-r from-emerald-700 to-teal-800 rounded-3xl p-4 text-white shadow-md relative overflow-hidden">
              <div className="relative z-10 space-y-1">
                <span className="bg-emerald-500/40 text-emerald-100 text-[10px] font-black px-2 py-0.5 rounded-full border border-emerald-400/30">
                  {isHi ? "कामवाला सुरक्षा गारंटी" : "Verified & Police Checked"}
                </span>
                <h3 className="text-sm font-black leading-tight pt-1">
                  {isHi ? "घर की सभी सेवाएं, भरोसेमंद कारीगर" : "Quality Home Services with 30-Day Guarantee"}
                </h3>
                <p className="text-[11px] text-emerald-100 opacity-90">
                  {isHi ? "₹100 की छूट: कूपन FIRST100" : "Get ₹100 OFF with code FIRST100"}
                </p>
              </div>
              <Sparkles className="w-20 h-20 text-white/10 absolute -right-2 -bottom-2" />
            </div>

            {/* Service Categories Grid */}
            <div>
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-xs font-black text-slate-900 flex items-center gap-1.5 uppercase tracking-wide">
                  <Wrench className="w-3.5 h-3.5 text-emerald-600" />
                  <span>{isHi ? "सेवाएं चुनें" : "Explore Services"}</span>
                </h3>
                <span className="text-[10px] text-slate-400 font-semibold">{displayedCategories.length} categories</span>
              </div>

              <div className="grid grid-cols-3 gap-2.5">
                {displayedCategories.map((cat) => (
                  <div
                    key={cat.id}
                    onClick={() => setSelectedCategoryForBooking(cat)}
                    className="bg-white border border-slate-200/90 hover:border-emerald-500 rounded-2xl p-2.5 flex flex-col items-center text-center cursor-pointer transition shadow-xs hover:shadow-md active:scale-95 relative group"
                  >
                    {cat.badge && (
                      <span className="absolute top-1 right-1 text-[8px] font-black px-1 py-0.2 rounded bg-emerald-100 text-emerald-800 leading-none">
                        {cat.badge}
                      </span>
                    )}
                    <span className="text-2xl mt-1 group-hover:scale-110 transition">{cat.icon}</span>
                    <h4 className="text-[11px] font-bold text-slate-900 mt-2 leading-tight">
                      {isHi ? (cat.name_hi || cat.name) : cat.name}
                    </h4>
                    <span className="text-[9px] text-slate-400 mt-0.5 font-medium">₹{cat.starting_price} visit</span>
                  </div>
                ))}
              </div>
            </div>

            {/* KaamWala Trust Promise */}
            <div className="bg-white border border-slate-200 rounded-2xl p-3.5 space-y-2 shadow-xs">
              <span className="font-extrabold text-slate-900 text-xs block">
                {isHi ? "कामवाला का सुरक्षा भरोसा" : "The KaamWala Standard"}
              </span>
              <div className="grid grid-cols-3 gap-2 text-center pt-1">
                <div className="bg-slate-50 p-2 rounded-xl border border-slate-100">
                  <ShieldCheck className="w-4 h-4 text-emerald-600 mx-auto mb-1" />
                  <span className="font-extrabold text-[10px] text-slate-800 block">ID Verified</span>
                  <span className="text-[9px] text-slate-400 block">Aadhaar checked</span>
                </div>
                <div className="bg-slate-50 p-2 rounded-xl border border-slate-100">
                  <Star className="w-4 h-4 text-amber-500 mx-auto mb-1" />
                  <span className="font-extrabold text-[10px] text-slate-800 block">Top Rated</span>
                  <span className="text-[9px] text-slate-400 block">4.8+ Stars avg</span>
                </div>
                <div className="bg-slate-50 p-2 rounded-xl border border-slate-100">
                  <CheckCircle className="w-4 h-4 text-blue-600 mx-auto mb-1" />
                  <span className="font-extrabold text-[10px] text-slate-800 block">30-Day Fix</span>
                  <span className="text-[9px] text-slate-400 block">Rework warranty</span>
                </div>
              </div>
            </div>

            {/* Top Verified Pros List */}
            <div className="space-y-2.5">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-xs font-black text-slate-900 uppercase tracking-wide">
                    {isHi ? "सत्यापित विशेषज्ञ" : "Top Verified Pros Near You"}
                  </h3>
                  <p className="text-[10px] text-slate-500">Ranked by completion rate & response speed</p>
                </div>
              </div>

              <div className="space-y-2.5">
                {TOP_WORKERS.map((w) => (
                  <div
                    key={w.id}
                    className="bg-white border border-slate-200 rounded-2xl p-3 shadow-xs space-y-2"
                  >
                    <div className="flex items-start gap-3">
                      <img src={w.photo_url} alt={w.name} className="w-12 h-12 rounded-xl object-cover border border-slate-200 shrink-0" />
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between">
                          <h4 className="text-xs font-extrabold text-slate-900 flex items-center gap-1 truncate">
                            {w.name}
                            <ShieldCheck className="w-3.5 h-3.5 text-emerald-600 shrink-0" />
                          </h4>
                          <span className="text-xs font-black text-slate-900">₹{w.visit_fee} visit</span>
                        </div>
                        <span className="text-[10px] text-emerald-700 font-semibold block">{w.category} Specialist • {w.experience_years} yrs exp</span>
                        <div className="flex items-center gap-2 text-[10px] text-slate-500 mt-0.5">
                          <span className="flex items-center text-amber-500 font-bold">
                            <Star className="w-3 h-3 fill-amber-400 stroke-none" /> {w.rating}
                          </span>
                          <span>({w.total_reviews} reviews)</span>
                          <span>•</span>
                          <span>{w.jobs_completed} jobs done</span>
                        </div>
                      </div>
                    </div>

                    <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-[10px]">
                      <span className="text-slate-500 font-medium">⚡ Responds in {w.response_time}</span>
                      <div className="flex gap-2">
                        <button 
                          onClick={() => {
                            setCallWorkerName(w.name);
                            setIsCallOpen(true);
                          }}
                          className="bg-slate-100 hover:bg-slate-200 text-slate-700 px-2.5 py-1 rounded-lg font-bold flex items-center gap-1"
                        >
                          <Phone className="w-3 h-3" /> Call
                        </button>
                        <button 
                          onClick={() => {
                            const foundCat = SERVICE_CATEGORIES.find(c => c.id === w.category);
                            if (foundCat) setSelectedCategoryForBooking(foundCat);
                          }}
                          className="bg-emerald-600 hover:bg-emerald-700 text-white px-3 py-1 rounded-lg font-bold flex items-center gap-1 shadow-xs"
                        >
                          Book Now
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* KaamWala Care Plan Annual Banner */}
            <div className="bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200 rounded-2xl p-3.5 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-amber-400 to-orange-500 text-white flex items-center justify-center font-bold">
                  <Crown className="w-5 h-5" />
                </div>
                <div>
                  <div className="flex items-center gap-1.5">
                    <span className="font-extrabold text-slate-900 text-xs">KaamWala Care™</span>
                    <span className="bg-amber-200 text-amber-900 text-[8px] font-black px-1.5 py-0.2 rounded">Save 40%</span>
                  </div>
                  <span className="text-[10px] text-slate-600 block">Unlimited free visits all year long</span>
                </div>
              </div>
              <button 
                onClick={() => showToast("KaamWala Care plan activated!")}
                className="bg-amber-600 hover:bg-amber-700 text-white text-[10px] font-extrabold px-3 py-1.5 rounded-xl shadow-xs"
              >
                View Plans
              </button>
            </div>
          </>
        )}

        {/* -------------------- TAB 2: BOOKINGS / JOBS -------------------- */}
        {activeTab === 'bookings' && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <h2 className="text-sm font-black text-slate-900 uppercase tracking-wide">
                {isHi ? "मेरी सेवा बुकिंग" : "My Service Bookings"}
              </h2>
              <span className="text-[10px] text-slate-400">{allJobs.length} bookings total</span>
            </div>

            <div className="space-y-3">
              {allJobs.map((j) => (
                <div 
                  key={j.id}
                  onClick={() => {
                    setActiveJob(j);
                    setIsJobDetailOpen(true);
                  }}
                  className="bg-white border border-slate-200 hover:border-emerald-500 rounded-2xl p-3.5 shadow-xs space-y-2 cursor-pointer transition"
                >
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="flex items-center gap-1.5">
                        <span className="font-mono text-[10px] bg-slate-100 text-slate-800 px-1.5 py-0.5 rounded font-extrabold">{j.id}</span>
                        <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                          {j.status.replace(/_/g, ' ')}
                        </span>
                      </div>
                      <h4 className="text-xs font-extrabold text-slate-900 mt-1">{j.service_name}</h4>
                      <p className="text-[10px] text-slate-500">{j.date} • {j.time}</p>
                    </div>
                    <span className="text-xs font-black text-emerald-700">₹{j.final_amount || j.estimated_amount}</span>
                  </div>

                  <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-[10px]">
                    <span className="text-slate-500 truncate max-w-[180px]">📍 {j.address}</span>
                    <span className="text-emerald-700 font-bold flex items-center gap-0.5">
                      Track Job <ChevronRight className="w-3 h-3" />
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* -------------------- TAB 3: CHAT -------------------- */}
        {activeTab === 'chat' && (
          <div className="space-y-3">
            <h2 className="text-sm font-black text-slate-900 uppercase tracking-wide">
              {isHi ? "चैट व संदेश" : "Technician Conversations"}
            </h2>

            <div 
              onClick={() => {
                setChatWorkerName(activeJob.selected_worker?.worker_name || 'Manoj Kumar Verma');
                setIsChatOpen(true);
              }}
              className="bg-white border border-slate-200 hover:border-emerald-500 rounded-2xl p-3.5 shadow-xs flex items-center justify-between cursor-pointer transition"
            >
              <div className="flex items-center gap-3">
                <div className="w-11 h-11 rounded-2xl bg-emerald-100 text-emerald-800 flex items-center justify-center font-bold text-sm">
                  M
                </div>
                <div>
                  <div className="flex items-center gap-1.5">
                    <span className="font-extrabold text-xs text-slate-900">Manoj Kumar Verma</span>
                    <ShieldCheck className="w-3.5 h-3.5 text-emerald-600" />
                  </div>
                  <span className="text-[10px] text-slate-500 block truncate max-w-[190px]">
                    "Reaching on time with high-pressure jet pump."
                  </span>
                </div>
              </div>
              <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
            </div>
          </div>
        )}

        {/* -------------------- TAB 4: PROFILE -------------------- */}
        {activeTab === 'profile' && (
          <div className="space-y-4">
            {/* User Profile Card or Login Prompt */}
            {currentUser ? (
              <div className="bg-gradient-to-r from-slate-900 to-slate-800 rounded-2xl p-4 text-white shadow-md flex items-center gap-3.5">
                <div className="w-14 h-14 rounded-2xl bg-emerald-600 text-white font-black text-xl flex items-center justify-center border-2 border-white/20">
                  {currentUser.avatar}
                </div>
                <div className="flex-1">
                  <h3 className="font-extrabold text-sm text-white">{currentUser.name}</h3>
                  <p className="text-xs text-slate-300 font-mono">{currentUser.phone}</p>
                  <p className="text-[10px] text-slate-400">{currentUser.email}</p>
                  <div className="flex items-center gap-1.5 mt-1">
                    <span className="bg-emerald-500/20 text-emerald-300 text-[9px] font-bold px-2 py-0.5 rounded-full border border-emerald-500/30">
                      Aadhaar Verified Customer
                    </span>
                  </div>
                </div>
              </div>
            ) : (
              <div className="bg-white border border-slate-200 rounded-2xl p-5 text-center space-y-3">
                <div className="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-700 flex items-center justify-center mx-auto">
                  <User className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="font-extrabold text-slate-900 text-sm">Welcome to KaamWala</h3>
                  <p className="text-xs text-slate-500 mt-0.5">Sign in for quick bookings, instant quotes & tracking</p>
                </div>
                <button
                  onClick={() => setIsAuthModalOpen(true)}
                  className="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold py-3 rounded-xl text-xs shadow-md shadow-emerald-600/20 transition"
                >
                  Sign In or Register
                </button>
              </div>
            )}

            {/* Settings Options */}
            <div className="bg-white border border-slate-200 rounded-2xl divide-y divide-slate-100 overflow-hidden text-xs">
              <div 
                onClick={() => setIsLocationModalOpen(true)}
                className="p-3.5 flex items-center justify-between hover:bg-slate-50 cursor-pointer"
              >
                <div className="flex items-center gap-3">
                  <MapPin className="w-4 h-4 text-emerald-600" />
                  <div>
                    <span className="font-bold text-slate-900 block">Manage Saved Addresses</span>
                    <span className="text-[10px] text-slate-500">{activeLocation}</span>
                  </div>
                </div>
                <ChevronRight className="w-4 h-4 text-slate-400" />
              </div>

              <div 
                onClick={() => setLang(lang === 'en' ? 'hi' : 'en')}
                className="p-3.5 flex items-center justify-between hover:bg-slate-50 cursor-pointer"
              >
                <div className="flex items-center gap-3">
                  <Sparkles className="w-4 h-4 text-purple-600" />
                  <div>
                    <span className="font-bold text-slate-900 block">App Language / भाषा</span>
                    <span className="text-[10px] text-slate-500">{lang === 'en' ? 'English (Current)' : 'हिन्दी (सक्रिय)'}</span>
                  </div>
                </div>
                <span className="font-bold text-emerald-700 text-xs">Switch</span>
              </div>

              <div 
                onClick={() => showToast("KaamWala Help Desk is active 24/7.")}
                className="p-3.5 flex items-center justify-between hover:bg-slate-50 cursor-pointer"
              >
                <div className="flex items-center gap-3">
                  <AlertCircle className="w-4 h-4 text-blue-600" />
                  <div>
                    <span className="font-bold text-slate-900 block">24x7 Help & Dispute Support</span>
                    <span className="text-[10px] text-slate-500">Raise issues or warranty claims</span>
                  </div>
                </div>
                <ChevronRight className="w-4 h-4 text-slate-400" />
              </div>

              {currentUser && (
                <div 
                  onClick={() => {
                    setCurrentUser(null);
                    showToast("Logged out successfully");
                  }}
                  className="p-3.5 flex items-center justify-between hover:bg-red-50 text-red-600 cursor-pointer"
                >
                  <span className="font-bold">Log Out</span>
                  <ChevronRight className="w-4 h-4 text-red-400" />
                </div>
              )}
            </div>
          </div>
        )}

      </main>

      {/* ========================================================================= */}
      {/* 3. BOTTOM MOBILE NAVIGATION BAR (Safe Area) */}
      {/* ========================================================================= */}
      <nav className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white/95 backdrop-blur-md border-t border-slate-200/90 px-4 py-2 flex items-center justify-around z-40 safe-bottom shadow-lg">
        <button 
          onClick={() => setActiveTab('home')}
          className={`flex flex-col items-center gap-0.5 text-[10px] font-bold transition ${activeTab === 'home' ? 'text-emerald-700' : 'text-slate-400 hover:text-slate-600'}`}
        >
          <Home className="w-5 h-5" />
          <span>Home</span>
        </button>

        <button 
          onClick={() => setActiveTab('bookings')}
          className={`flex flex-col items-center gap-0.5 text-[10px] font-bold transition relative ${activeTab === 'bookings' ? 'text-emerald-700' : 'text-slate-400 hover:text-slate-600'}`}
        >
          <ClipboardList className="w-5 h-5" />
          <span>Bookings</span>
          <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full absolute top-0 right-2"></span>
        </button>

        <button 
          onClick={() => {
            // center FAB opens quick service booking
            setSelectedCategoryForBooking(SERVICE_CATEGORIES[0]);
          }}
          className="w-11 h-11 -mt-5 rounded-full bg-emerald-600 hover:bg-emerald-700 text-white flex items-center justify-center shadow-lg active:scale-95 transition"
        >
          <Plus className="w-6 h-6" />
        </button>

        <button 
          onClick={() => setActiveTab('chat')}
          className={`flex flex-col items-center gap-0.5 text-[10px] font-bold transition ${activeTab === 'chat' ? 'text-emerald-700' : 'text-slate-400 hover:text-slate-600'}`}
        >
          <MessageSquare className="w-5 h-5" />
          <span>Chat</span>
        </button>

        <button 
          onClick={() => setActiveTab('profile')}
          className={`flex flex-col items-center gap-0.5 text-[10px] font-bold transition ${activeTab === 'profile' ? 'text-emerald-700' : 'text-slate-400 hover:text-slate-600'}`}
        >
          <User className="w-5 h-5" />
          <span>Profile</span>
        </button>
      </nav>

      {/* ========================================================================= */}
      {/* 4. MODALS & BOTTOM SHEETS */}
      {/* ========================================================================= */}
      <LocationPickerModal
        isOpen={isLocationModalOpen}
        onClose={() => setIsLocationModalOpen(false)}
        currentLocation={activeLocation}
        onSelectLocation={(loc) => {
          setActiveLocation(loc);
          showToast(`Location set to ${loc.split(',')[0]}`);
        }}
        lang={lang}
      />

      <ServiceRequestModal
        isOpen={!!selectedCategoryForBooking}
        onClose={() => setSelectedCategoryForBooking(null)}
        category={selectedCategoryForBooking}
        activeLocation={activeLocation}
        onSubmitJob={handleCreateJob}
        lang={lang}
      />

      <JobDetailModal
        isOpen={isJobDetailOpen}
        onClose={() => setIsJobDetailOpen(false)}
        job={activeJob}
        onUpdateJobStatus={handleUpdateJobStatus}
        onSelectQuote={handleSelectQuote}
        onOpenChat={(job, name) => {
          setChatWorkerName(name);
          setIsJobDetailOpen(false);
          setIsChatOpen(true);
        }}
        onOpenCall={(name) => {
          setCallWorkerName(name);
          setIsCallOpen(true);
        }}
        onOpenPayment={(job) => {
          setIsJobDetailOpen(false);
          setIsPaymentOpen(true);
        }}
        onOpenReview={(job) => {
          setIsJobDetailOpen(false);
          setIsReviewOpen(true);
        }}
        lang={lang}
      />

      <ChatModal
        isOpen={isChatOpen}
        onClose={() => setIsChatOpen(false)}
        job={activeJob}
        workerName={chatWorkerName}
        onOpenCall={(name) => {
          setCallWorkerName(name);
          setIsCallOpen(true);
        }}
      />

      <PaymentModal
        isOpen={isPaymentOpen}
        onClose={() => setIsPaymentOpen(false)}
        job={activeJob}
        onCompletePayment={handleCompletePayment}
        lang={lang}
      />

      <ReviewModal
        isOpen={isReviewOpen}
        onClose={() => setIsReviewOpen(false)}
        job={activeJob}
        onSubmitReview={handleSubmitReview}
        lang={lang}
      />

      <MaskedCallModal
        isOpen={isCallOpen}
        onClose={() => setIsCallOpen(false)}
        workerName={callWorkerName}
      />

      <AuthModal
        isOpen={isAuthModalOpen}
        onClose={() => setIsAuthModalOpen(false)}
        onLoginSuccess={(user) => {
          setCurrentUser(user);
          showToast(`Welcome back, ${user.name}!`);
        }}
      />

      {/* Toast message pop-in */}
      {toastMessage && (
        <div className="fixed top-4 left-1/2 -translate-x-1/2 z-50 bg-slate-900 text-white px-4 py-2.5 rounded-2xl shadow-2xl text-xs font-bold animate-in fade-in slide-in-from-top-4 flex items-center gap-2">
          <Sparkles className="w-4 h-4 text-emerald-400" />
          <span>{toastMessage}</span>
        </div>
      )}

    </div>
  );
}
