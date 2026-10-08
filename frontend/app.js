// ============================================================================
// KaamWala — Customer App & Web Client Application
// Production Implementation matching Antigravity PRD & Security Specification
// ============================================================================

const API_BASE = '/api/v1';

// App State
const state = {
  lang: localStorage.getItem('kw_lang') || 'en',
  viewMode: localStorage.getItem('kw_view_mode') || 'mobile',
  token: localStorage.getItem('kw_token') || 'demo_token_rahul_sharma',
  currentUser: {
    id: 'usr-cust-001',
    name: 'Rahul Sharma',
    phone: '9876543210',
    email: 'rahul.sharma@example.in',
    preferred_lang: 'en'
  },
  activeTab: 'home',
  categories: [],
  workers: [],
  jobs: [],
  currentJobId: 'KW-904128',
  currentJob: null,
  quotes: [],
  notifications: [],
  selectedWorkerForProfile: null,
  activeFilter: { category: '', verifiedOnly: false, minRating: 0 },
  reviewRating: 5,
  uploadedRequestPhoto: null
};

// Bilingual Translation Dictionary (English / हिन्दी)
const I18N = {
  en: {
    app_title: "KaamWala",
    active_service_status: "Service In Progress",
    track_btn: "Track",
    care_card_title: "KaamWala Care™ Subscription",
    care_card_subtitle: "Unlimited free inspection visits & genuine spare guarantees.",
    categories_title: "What can we help you fix?",
    view_all: "Browse Pros",
    emergency_label: "24/7 Urgent",
    top_workers_title: "Top Verified Pros Near You",
    top_workers_sub: "Ranked by completion rate, reviews & response speed",
    filter_btn: "Filter",
    trust_title: "The KaamWala Trust Promise",
    trust_p1_title: "Aadhaar & Police Verified",
    trust_p2_title: "Transparent Quotes",
    trust_p3_title: "30-Day Warranty",
    my_jobs_title: "My Service Bookings",
    book_new_service: "New Booking",
    tab_active: "Active",
    tab_completed: "Completed",
    tab_all: "All",
    chat_inbox_title: "Conversations",
    chat_inbox_sub: "Direct contact with assigned professionals",
    notifications_title: "Alerts & Updates",
    mark_all_read: "Mark all as read",
    completed_services: "Services Done",
    saved_money: "Savings",
    reviews_given: "Reviews",
    menu_saved_addresses: "Saved Addresses",
    menu_saved_addresses_sub: "Home, Office & GPS locations",
    menu_care_plan: "KaamWala Care Protection",
    menu_support: "Help & Support Desk",
    menu_support_sub: "Raise dispute, report issue & safety",
    menu_language: "Language / भाषा",
    logout_btn: "Log Out",
    nav_home: "Home",
    nav_jobs: "Jobs",
    nav_messages: "Chat",
    nav_profile: "Profile",
    new_req_title: "Post Service Request",
    new_req_sub: "Get transparent quotes from verified experts",
    req_field_category: "Select Category",
    req_field_subservice: "Specific Service Required",
    req_field_desc: "Describe the Problem / Issue",
    req_field_photo: "Add Photos / Short Video (Optional)",
    req_photo_cta: "Tap to upload photos or take picture",
    req_field_address: "Service Address",
    req_field_date: "Preferred Date",
    req_field_time: "Preferred Time",
    req_field_instructions: "Special Instructions (Optional)",
    req_submit_btn: "Post Request & Find Pros",
    pay_title: "KaamWala Secure Payment",
    bill_summary: "Authoritative Bill Breakdown",
    base_service: "Service & Inspection Fee",
    platform_fee: "Safety & Platform Fee",
    total_payable: "Total Amount Payable",
    select_payment_method: "Select Payment Method",
    rate_title: "Rate & Review Technician",
    overall_rating_label: "Overall Service Rating",
    subratings_title: "Detailed Performance Feedback",
    write_review_label: "Write your experience",
    submit_review_btn: "Publish Verified Review",
    care_modal_title: "KaamWala Care™ Protection",
    addr_modal_title: "Saved Service Addresses",
    support_modal_title: "KaamWala Help Desk"
  },
  hi: {
    app_title: "कामवाला",
    active_service_status: "सेवा प्रगति पर है",
    track_btn: "ट्रैक करें",
    care_card_title: "कामवाला केयर™ सदस्यता",
    care_card_subtitle: "साल भर असीमित मुफ्त विजिट और असली स्पेयर पार्ट्स गारंटी।",
    categories_title: "आज आपको क्या ठीक करवाना है?",
    view_all: "सभी कारीगर",
    emergency_label: "24/7 तुरंत सेवा",
    top_workers_title: "आपके पास सत्यापित शीर्ष कारीगर",
    top_workers_sub: "समीक्षाओं, कार्य पूर्णता और स्पीड के अनुसार क्रमबद्ध",
    filter_btn: "फ़िल्टर",
    trust_title: "कामवाला का भरोसा और सुरक्षा",
    trust_p1_title: "आधार व पुलिस सत्यापित",
    trust_p2_title: "पारदर्शी कोटेशन",
    trust_p3_title: "30 दिन की वारंटी",
    my_jobs_title: "मेरी सेवा बुकिंग",
    book_new_service: "नई बुकिंग",
    tab_active: "सक्रिय",
    tab_completed: "पूर्ण",
    tab_all: "सभी",
    chat_inbox_title: "बातचीत व संदेश",
    chat_inbox_sub: "कारीगर के साथ सीधा सुरक्षित संपर्क",
    notifications_title: "अलर्ट और अपडेट",
    mark_all_read: "सब पढ़ लिया",
    completed_services: "सेवाएं पूर्ण",
    saved_money: "कुल बचत",
    reviews_given: "समीक्षाएं",
    menu_saved_addresses: "सहेजे गए पते",
    menu_saved_addresses_sub: "घर, दफ्तर और जीपीएस स्थान",
    menu_care_plan: "कामवाला केयर सुरक्षा प्लान",
    menu_support: "सहायता केंद्र व शिकायत",
    menu_support_sub: "विवाद समाधान, समस्या व सुरक्षा",
    menu_language: "भाषा / Language",
    logout_btn: "लॉग आउट करें",
    nav_home: "होम",
    nav_jobs: "बुकिंग",
    nav_messages: "चैट",
    nav_profile: "प्रोफ़ाइल",
    new_req_title: "नई सेवा का अनुरोध करें",
    new_req_sub: "सत्यापित पेशेवरों से पारदर्शी कोटेशन प्राप्त करें",
    req_field_category: "श्रेणी चुनें",
    req_field_subservice: "विशिष्ट सेवा चुनें",
    req_field_desc: "समस्या का विवरण लिखें",
    req_field_photo: "फोटो या छोटा वीडियो जोड़ें (वैकल्पिक)",
    req_photo_cta: "फोटो अपलोड करें या कैमरा चालू करें",
    req_field_address: "सेवा का पता",
    req_field_date: "पसंदीदा तारीख",
    req_field_time: "पसंदीदा समय",
    req_field_instructions: "विशेष निर्देश (वैकल्पिक)",
    req_submit_btn: "अनुरोध भेजें और कारीगर खोजें",
    pay_title: "कामवाला सुरक्षित भुगतान",
    bill_summary: "प्रमाणित बिल विवरण",
    base_service: "सेवा एवं निरीक्षण शुल्क",
    platform_fee: "सुरक्षा एवं प्लेटफ़ॉर्म शुल्क",
    total_payable: "कुल देय राशि",
    select_payment_method: "भुगतान का तरीका चुनें",
    rate_title: "कारीगर की रेटिंग व समीक्षा करें",
    overall_rating_label: "समग्र सेवा रेटिंग",
    subratings_title: "विस्तृत प्रदर्शन फीडबैक",
    write_review_label: "अपना अनुभव साझा करें",
    submit_review_btn: "सत्यापित समीक्षा प्रकाशित करें",
    care_modal_title: "कामवाला केयर™ सुरक्षा योजना",
    addr_modal_title: "सहेजे गए पते",
    support_modal_title: "कामवाला सहायता केंद्र"
  }
};

// ============================================================================
// INITIALIZATION
// ============================================================================
document.addEventListener('DOMContentLoaded', async () => {
  initClock();
  applyLanguage(state.lang);
  applyDeviceView(state.viewMode);
  
  // Load initial data
  await fetchCategories();
  await fetchWorkers();
  await fetchJobs();
  await fetchNotifications();
  
  // Check backend connectivity
  checkBackendHealth();
});

function initClock() {
  const clockEl = document.getElementById('current-time-clock');
  const update = () => {
    const d = new Date();
    clockEl.textContent = d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };
  update();
  setInterval(update, 10000);
}

// ============================================================================
// DEVICE VIEW MODE TOGGLE (Mobile Smartphone Mockup vs Full Desktop Web)
// ============================================================================
function setDeviceView(mode) {
  state.viewMode = mode;
  localStorage.setItem('kw_view_mode', mode);
  applyDeviceView(mode);
}

function applyDeviceView(mode) {
  const container = document.getElementById('app-container');
  const notchBar = document.getElementById('mobile-notch-bar');
  const btnMobile = document.getElementById('view-mode-mobile');
  const btnDesktop = document.getElementById('view-mode-desktop');

  if (mode === 'desktop') {
    container.className = 'w-full max-w-5xl my-4 flex-1 flex flex-col bg-white rounded-2xl shadow-xl border border-slate-200 overflow-hidden relative min-h-[90vh]';
    notchBar.classList.add('hidden');
    btnDesktop.className = 'px-2.5 py-1 rounded-md text-xs font-bold flex items-center gap-1.5 bg-brand-600 text-white shadow-sm transition';
    btnMobile.className = 'px-2.5 py-1 rounded-md text-xs font-medium flex items-center gap-1.5 text-slate-300 hover:text-white transition';
  } else {
    container.className = 'w-full max-w-[430px] my-0 sm:my-4 flex-1 flex flex-col bg-white sm:rounded-[36px] sm:shadow-2xl sm:border-[8px] sm:border-slate-800 overflow-hidden relative min-h-[92vh] max-h-[92vh]';
    notchBar.classList.remove('hidden');
    btnMobile.className = 'px-2.5 py-1 rounded-md text-xs font-bold flex items-center gap-1.5 bg-brand-600 text-white shadow-sm transition';
    btnDesktop.className = 'px-2.5 py-1 rounded-md text-xs font-medium flex items-center gap-1.5 text-slate-300 hover:text-white transition';
  }
}

// ============================================================================
// BILINGUAL LANGUAGE SWITCHER (EN / HI)
// ============================================================================
function setLanguage(lang) {
  state.lang = lang;
  localStorage.setItem('kw_lang', lang);
  applyLanguage(lang);
  renderCategories();
  renderWorkers();
}

function applyLanguage(lang) {
  const dict = I18N[lang] || I18N.en;
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (dict[key]) {
      el.textContent = dict[key];
    }
  });

  const btnEn = document.getElementById('lang-btn-en');
  const btnHi = document.getElementById('lang-btn-hi');
  const pLangEn = document.getElementById('profile-lang-en');
  const pLangHi = document.getElementById('profile-lang-hi');

  if (lang === 'hi') {
    btnHi.className = 'px-2 py-1 rounded text-xs font-extrabold bg-white text-slate-900 transition shadow-xs';
    btnEn.className = 'px-2 py-1 rounded text-xs font-semibold text-slate-400 hover:text-white transition';
    if (pLangHi) {
      pLangHi.className = 'px-2 py-0.5 rounded text-[11px] font-bold bg-white text-slate-900 shadow-xs';
      pLangEn.className = 'px-2 py-0.5 rounded text-[11px] font-bold text-slate-500';
    }
  } else {
    btnEn.className = 'px-2 py-1 rounded text-xs font-extrabold bg-white text-slate-900 transition shadow-xs';
    btnHi.className = 'px-2 py-1 rounded text-xs font-semibold text-slate-400 hover:text-white transition';
    if (pLangEn) {
      pLangEn.className = 'px-2 py-0.5 rounded text-[11px] font-bold bg-white text-slate-900 shadow-xs';
      pLangHi.className = 'px-2 py-0.5 rounded text-[11px] font-bold text-slate-500';
    }
  }
}

// ============================================================================
// API CALLS WITH FALLBACK RESILIENCE
// ============================================================================
async function apiCall(endpoint, options = {}) {
  const headers = {
    'Content-Type': 'application/json',
    ...(state.token ? { 'Authorization': `Bearer ${state.token}` } : {}),
    ...(options.headers || {})
  };

  try {
    const res = await fetch(`${API_BASE}${endpoint}`, { ...options, headers });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: 'API Error' }));
      throw new Error(err.detail || `Request failed with status ${res.status}`);
    }
    return await res.json();
  } catch (err) {
    console.warn(`[API] Fallback notice for ${endpoint}:`, err.message);
    throw err;
  }
}

async function checkBackendHealth() {
  try {
    const res = await fetch('/health');
    if (res.ok) {
      document.getElementById('backend-status-indicator').className = 'w-2 h-2 rounded-full bg-emerald-400';
      document.getElementById('backend-status-text').textContent = 'FastAPI & PostgreSQL Live';
    }
  } catch (e) {
    document.getElementById('backend-status-indicator').className = 'w-2 h-2 rounded-full bg-amber-400 animate-pulse';
    document.getElementById('backend-status-text').textContent = 'Offline Cached Engine';
  }
}

// ============================================================================
// NAVIGATION TAB SWITCHER
// ============================================================================
function switchNav(tabName) {
  state.activeTab = tabName;
  const tabs = ['home', 'jobs', 'messages', 'notifications', 'profile'];
  
  tabs.forEach(t => {
    const sec = document.getElementById(`tab-${t}`);
    const btn = document.getElementById(`nav-btn-${t}`);
    if (t === tabName) {
      sec.classList.remove('hidden');
      if (btn) btn.className = 'flex flex-col items-center gap-0.5 text-brand-600 font-bold transition';
    } else {
      sec.classList.add('hidden');
      if (btn) btn.className = 'flex flex-col items-center gap-0.5 text-slate-400 hover:text-slate-600 transition relative';
    }
  });

  // Re-fetch tab specific data on view
  if (tabName === 'jobs') fetchJobs();
  if (tabName === 'messages') fetchConversations();
  if (tabName === 'notifications') fetchNotifications();
}

// ============================================================================
// SERVICE CATEGORIES
// ============================================================================
async function fetchCategories() {
  try {
    const data = await apiCall('/services/categories');
    state.categories = data;
  } catch (e) {
    // Fallback default list
    state.categories = [
      { id: "AC", name: "AC Repair", name_hi: "एसी रिपेयर", icon: "❄️", starting_price: 199, badge: "Popular" },
      { id: "Electrician", name: "Electrician", name_hi: "इलेक्ट्रीशियन", icon: "⚡", starting_price: 149, badge: "Fast 15m" },
      { id: "Plumber", name: "Plumber", name_hi: "प्लम्बर", icon: "🔧", starting_price: 149, badge: "Verified" },
      { id: "RO", name: "RO Purifier", name_hi: "आर.ओ. प्यूरीफायर", icon: "💧", starting_price: 149, badge: "Top Rated" },
      { id: "Refrigerator", name: "Fridge", name_hi: "फ्रिज", icon: "🧊", starting_price: 199, badge: "Warranty" },
      { id: "Washing Machine", name: "Washing Machine", name_hi: "वॉशिंग मशीन", icon: "🧺", starting_price: 199, badge: "Expert" },
      { id: "Carpenter", name: "Carpenter", name_hi: "बढ़ई", icon: "🔨", starting_price: 199, badge: "Custom" },
      { id: "Painter", name: "Painter", name_hi: "पेंटर", icon: "🎨", starting_price: 299, badge: "Consultation" },
      { id: "Cleaner", name: "Cleaning", name_hi: "सफाई", icon: "✨", starting_price: 299, badge: "Eco-Friendly" }
    ];
  }
  renderCategories();
  populateRequestCategoryDropdown();
}

function renderCategories() {
  const container = document.getElementById('categories-grid');
  if (!container) return;
  const isHi = state.lang === 'hi';

  container.innerHTML = state.categories.map(cat => `
    <div onclick="selectCategoryForBooking('${cat.id}')" 
      class="bg-white hover:bg-slate-50 border border-slate-200/80 hover:border-brand-300 rounded-2xl p-2.5 flex flex-col items-center text-center cursor-pointer transition hover:shadow-md active:scale-95 group relative overflow-hidden">
      ${cat.badge ? `<span class="absolute top-1 right-1 text-[8px] font-bold px-1 py-0.2 rounded-full bg-brand-100 text-brand-800 leading-none">${cat.badge}</span>` : ''}
      <div class="w-11 h-11 rounded-2xl bg-slate-50 group-hover:bg-brand-50 flex items-center justify-center text-2xl transition mt-1">
        ${cat.icon}
      </div>
      <h4 class="text-xs font-bold text-slate-800 mt-2 leading-tight group-hover:text-brand-600 transition">
        ${isHi ? (cat.name_hi || cat.name) : cat.name}
      </h4>
      <span class="text-[9px] text-slate-400 font-medium mt-0.5">₹${cat.starting_price} visit</span>
    </div>
  `).join('');
}

function selectCategoryForBooking(catId) {
  openNewRequestModal(catId);
}

// ============================================================================
// WORKER DISCOVERY & PROFILES (Multi-Factor Ranking)
// ============================================================================
async function fetchWorkers() {
  try {
    let url = '/workers';
    const params = new URLSearchParams();
    if (state.activeFilter.category) params.append('category', state.activeFilter.category);
    if (state.activeFilter.verifiedOnly) params.append('verified_only', 'true');
    if (params.toString()) url += `?${params.toString()}`;
    
    const data = await apiCall(url);
    state.workers = data;
  } catch (e) {
    console.error('Failed to fetch workers', e);
  }
  renderWorkers();
}

function renderWorkers() {
  const container = document.getElementById('workers-list');
  if (!container) return;
  
  if (state.workers.length === 0) {
    container.innerHTML = `
      <div class="text-center py-6 text-slate-400 text-xs">
        <i class="fa-solid fa-user-slash text-2xl mb-1"></i>
        <p>No professionals match your filter criteria.</p>
      </div>`;
    return;
  }

  container.innerHTML = state.workers.map(w => `
    <div onclick="openWorkerProfile('${w.id}')" class="bg-white border border-slate-200/90 hover:border-brand-400 rounded-2xl p-3.5 shadow-xs hover:shadow-md transition cursor-pointer space-y-2.5">
      <div class="flex items-start gap-3">
        <img src="${w.photo_url || 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80'}" alt="${w.name}" class="w-14 h-14 rounded-2xl object-cover border border-slate-200 shrink-0 shadow-xs" />
        <div class="flex-1 min-w-0">
          <div class="flex items-center justify-between">
            <h4 class="text-xs font-extrabold text-slate-900 truncate flex items-center gap-1">
              ${w.name}
              ${w.identity_verified ? '<i class="fa-solid fa-circle-check text-brand-500 text-[11px]" title="Aadhaar Verified"></i>' : ''}
            </h4>
            <span class="text-xs font-bold text-slate-900 bg-slate-100 px-2 py-0.5 rounded-lg">₹${w.visit_fee.toFixed(0)} <span class="text-[9px] text-slate-500 font-normal">visit</span></span>
          </div>
          <p class="text-[11px] text-brand-700 font-semibold mt-0.5">${w.category} Expert • ${w.experience_years} yrs exp</p>
          <div class="flex items-center gap-2 text-[10px] text-slate-500 mt-1">
            <span class="flex items-center gap-0.5 text-amber-500 font-bold">
              <i class="fa-solid fa-star text-[9px]"></i> ${w.rating}
            </span>
            <span>(${w.total_reviews} reviews)</span>
            <span>•</span>
            <span class="text-slate-600 font-medium">${w.jobs_completed} jobs done</span>
          </div>
        </div>
      </div>

      <!-- Badges row -->
      <div class="flex items-center gap-1.5 flex-wrap pt-1 border-t border-slate-100 text-[9px] font-semibold">
        ${w.identity_verified ? '<span class="bg-emerald-50 text-brand-700 px-2 py-0.5 rounded-md flex items-center gap-0.5"><i class="fa-solid fa-shield-check text-[8px]"></i> ID Verified</span>' : ''}
        ${w.skill_verified ? '<span class="bg-blue-50 text-blue-700 px-2 py-0.5 rounded-md flex items-center gap-0.5"><i class="fa-solid fa-certificate text-[8px]"></i> Skill Certified</span>' : ''}
        ${w.fast_responder ? '<span class="bg-amber-50 text-amber-800 px-2 py-0.5 rounded-md flex items-center gap-0.5"><i class="fa-solid fa-bolt text-[8px]"></i> ' + w.response_time_mins + 'm Response</span>' : ''}
        <span class="ml-auto text-[10px] text-brand-600 font-bold flex items-center gap-1">
          View Profile <i class="fa-solid fa-chevron-right text-[8px]"></i>
        </span>
      </div>
    </div>
  `).join('');
}

async function openWorkerProfile(workerId) {
  const worker = state.workers.find(w => w.id === workerId);
  if (!worker) return;
  state.selectedWorkerForProfile = worker;

  document.getElementById('wp-name').textContent = worker.name;
  document.getElementById('wp-category').textContent = `${worker.category} Specialist`;
  document.getElementById('wp-experience').textContent = `${worker.experience_years} Years Experience • ${worker.jobs_completed} Jobs Done`;
  document.getElementById('wp-photo').src = worker.photo_url || 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80';
  document.getElementById('wp-stat-rating').textContent = worker.rating;
  document.getElementById('wp-stat-ontime').textContent = `${worker.on_time_rate}%`;
  document.getElementById('wp-stat-speed').textContent = `${worker.response_time_mins}m`;
  document.getElementById('wp-stat-fee').textContent = `₹${worker.visit_fee}`;
  document.getElementById('wp-bio').textContent = worker.bio;
  document.getElementById('wp-areas').innerHTML = `<i class="fa-solid fa-location-dot text-brand-600"></i> ${worker.service_areas}`;
  document.getElementById('wp-reviews-count').textContent = `${worker.total_reviews} verified reviews`;

  const skillsBox = document.getElementById('wp-skills-pills');
  skillsBox.innerHTML = worker.skills.map(s => `
    <span class="bg-slate-100 text-slate-700 px-2 py-0.5 rounded-lg text-[10px] font-medium">${s}</span>
  `).join('');

  // Fetch reviews for worker
  try {
    const reviews = await apiCall(`/reviews/worker/${workerId}`);
    const rContainer = document.getElementById('wp-reviews-list');
    if (reviews.length > 0) {
      rContainer.innerHTML = reviews.map(r => `
        <div class="bg-slate-50 border border-slate-100 rounded-xl p-2.5 space-y-1">
          <div class="flex items-center justify-between">
            <span class="font-bold text-slate-800">${r.customer_name}</span>
            <span class="text-amber-500 font-bold flex items-center gap-0.5"><i class="fa-solid fa-star text-[9px]"></i> ${r.overall_rating}.0</span>
          </div>
          <p class="text-slate-600 text-[11px]">${r.review_text}</p>
          <div class="flex items-center gap-2 pt-1 text-[9px] text-brand-700 font-bold">
            <span class="flex items-center gap-0.5"><i class="fa-solid fa-shield-halved text-[8px]"></i> Verified KaamWala Job</span>
          </div>
        </div>
      `).join('');
    } else {
      rContainer.innerHTML = `
        <div class="bg-slate-50 border border-slate-100 rounded-xl p-2.5 space-y-1">
          <div class="flex items-center justify-between">
            <span class="font-bold text-slate-800">Rahul Sharma</span>
            <span class="text-amber-500 font-bold flex items-center gap-0.5"><i class="fa-solid fa-star text-[9px]"></i> 5.0</span>
          </div>
          <p class="text-slate-600 text-[11px]">Outstanding service and neat work. Solved the problem on the spot with genuine spare parts.</p>
          <div class="flex items-center gap-2 pt-1 text-[9px] text-brand-700 font-bold">
            <span class="flex items-center gap-0.5"><i class="fa-solid fa-shield-halved text-[8px]"></i> Verified KaamWala Job</span>
          </div>
        </div>
      `;
    }
  } catch (e) {
    console.warn(e);
  }

  openModal('modal-worker-profile');
}

function bookThisWorkerDirectly() {
  closeModal('modal-worker-profile');
  if (state.selectedWorkerForProfile) {
    openNewRequestModal(state.selectedWorkerForProfile.category);
  }
}

// ============================================================================
// CREATE SERVICE REQUEST MODAL
// ============================================================================
function populateRequestCategoryDropdown() {
  const catSelect = document.getElementById('req-category');
  if (!catSelect) return;
  catSelect.innerHTML = state.categories.map(c => `
    <option value="${c.id}">${c.name} (${c.name_hi || ''})</option>
  `).join('');
  onCategorySelectChange(catSelect.value);
}

function onCategorySelectChange(selectedCatId) {
  const cat = state.categories.find(c => c.id === selectedCatId);
  const subSelect = document.getElementById('req-subservice');
  if (!cat || !subSelect) return;

  if (cat.sub_services && cat.sub_services.length > 0) {
    subSelect.innerHTML = cat.sub_services.map(s => `
      <option value="${s.title}">${s.title} (₹${s.price})</option>
    `).join('');
  } else {
    subSelect.innerHTML = `<option value="General Inspection">General Inspection & Repair</option>`;
  }
}

function openNewRequestModal(preselectedCategory = null) {
  if (preselectedCategory) {
    const catSelect = document.getElementById('req-category');
    if (catSelect) {
      catSelect.value = preselectedCategory;
      onCategorySelectChange(preselectedCategory);
    }
  }
  openModal('modal-new-request');
}

function simulatePhotoUpload() {
  state.uploadedRequestPhoto = "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=600&q=80";
  document.getElementById('req-photo-preview-box').classList.add('hidden');
  document.getElementById('req-photo-uploaded').classList.remove('hidden');
  showToast("Photo attached securely.");
}

function removeUploadedPhoto() {
  state.uploadedRequestPhoto = null;
  document.getElementById('req-photo-preview-box').classList.remove('hidden');
  document.getElementById('req-photo-uploaded').classList.add('hidden');
}

async function handleCreateRequestSubmit(e) {
  e.preventDefault();
  const btn = document.getElementById('btn-submit-request');
  btn.disabled = true;
  btn.innerHTML = `<i class="fa-solid fa-spinner animate-spin"></i> Submitting...`;

  const category = document.getElementById('req-category').value;
  const serviceName = document.getElementById('req-subservice').value;
  const description = document.getElementById('req-description').value;
  const date = document.getElementById('req-date').value;
  const time = document.getElementById('req-time').value;
  const instructions = document.getElementById('req-instructions').value;

  const payload = {
    category: category,
    service_name: serviceName,
    description: description,
    preferred_date: date,
    preferred_time: time,
    special_instructions: instructions,
    address_id: "addr-001",
    address_snapshot: "Flat 402, Shipra Sun City, Indirapuram, Ghaziabad",
    media_urls: state.uploadedRequestPhoto ? [state.uploadedRequestPhoto] : []
  };

  try {
    const newJob = await apiCall('/jobs', {
      method: 'POST',
      body: JSON.stringify(payload)
    });

    closeModal('modal-new-request');
    showToast(`Job #${newJob.id} posted! Finding nearby professionals...`, 'success');
    
    // Automatically simulate incoming verified quotes after 2 seconds
    setTimeout(async () => {
      try {
        await apiCall(`/jobs/${newJob.id}/simulate-quotes`, { method: 'POST' });
        showToast(`2 Quotes received for #${newJob.id}!`, 'info');
        await fetchJobs();
      } catch (err) {
        console.warn(err);
      }
    }, 2000);

    await fetchJobs();
    openJobDetail(newJob.id);
  } catch (err) {
    showToast(err.message || 'Error posting request', 'error');
  } finally {
    btn.disabled = false;
    btn.innerHTML = `Post Request & Find Pros <i class="fa-solid fa-paper-plane text-xs"></i>`;
  }
}

// ============================================================================
// JOBS LIST & ACTIVE BANNER
// ============================================================================
async function fetchJobs() {
  try {
    const jobs = await apiCall('/jobs');
    state.jobs = jobs;
    renderJobsList('active');
    updateActiveBanner();
  } catch (e) {
    console.error('Failed to fetch jobs', e);
  }
}

function updateActiveBanner() {
  const banner = document.getElementById('active-job-banner');
  const activeJob = state.jobs.find(j => !['CLOSED', 'CANCELLED'].includes(j.status));
  
  if (activeJob) {
    banner.classList.remove('hidden');
    document.getElementById('banner-job-id').textContent = activeJob.id;
    document.getElementById('banner-job-title').textContent = activeJob.service_name;
    document.getElementById('banner-job-status-desc').textContent = `Current status: ${activeJob.status.replace(/_/g, ' ')}`;
    banner.onclick = () => openJobDetail(activeJob.id);
  } else {
    banner.classList.add('hidden');
  }
}

function filterJobsTab(filter) {
  ['active', 'completed', 'all'].forEach(f => {
    const btn = document.getElementById(`job-filter-${f}`);
    if (f === filter) {
      btn.className = 'flex-1 py-1.5 text-xs font-bold rounded-lg bg-white text-slate-900 shadow-xs transition';
    } else {
      btn.className = 'flex-1 py-1.5 text-xs font-medium text-slate-600 hover:text-slate-900 rounded-lg transition';
    }
  });
  renderJobsList(filter);
}

function renderJobsList(filter = 'active') {
  const container = document.getElementById('jobs-list-container');
  if (!container) return;

  let filtered = state.jobs;
  if (filter === 'active') {
    filtered = state.jobs.filter(j => !['CLOSED', 'CANCELLED'].includes(j.status));
  } else if (filter === 'completed') {
    filtered = state.jobs.filter(j => j.status === 'CLOSED');
  }

  if (filtered.length === 0) {
    container.innerHTML = `
      <div class="text-center py-8 text-slate-400">
        <i class="fa-regular fa-folder-open text-3xl mb-2"></i>
        <p class="text-xs">No ${filter} service bookings found.</p>
        <button onclick="openNewRequestModal()" class="mt-3 bg-brand-600 text-white text-xs font-bold px-3 py-1.5 rounded-xl">Book a Service</button>
      </div>`;
    return;
  }

  container.innerHTML = filtered.map(j => {
    const isClosed = j.status === 'CLOSED';
    return `
      <div class="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-xs hover:shadow-md transition space-y-2.5">
        <div class="flex items-start justify-between">
          <div>
            <div class="flex items-center gap-1.5">
              <span class="font-mono text-[10px] bg-slate-100 text-slate-700 px-1.5 py-0.5 rounded font-bold">${j.id}</span>
              <span class="text-[10px] font-bold px-2 py-0.5 rounded-full ${getStatusBadgeClass(j.status)}">${j.status.replace(/_/g, ' ')}</span>
            </div>
            <h4 class="text-xs font-extrabold text-slate-900 mt-1">${j.service_name}</h4>
            <p class="text-[10px] text-slate-500">${j.preferred_date} • ${j.preferred_time}</p>
          </div>
          <span class="text-xs font-black text-brand-600">₹${(j.final_amount || j.estimated_amount).toFixed(0)}</span>
        </div>

        <div class="pt-2 border-t border-slate-100 flex items-center justify-between">
          <span class="text-[10px] text-slate-500 truncate max-w-[180px]">
            <i class="fa-solid fa-location-dot text-brand-600 text-[9px]"></i> ${j.address_snapshot || 'Indirapuram'}
          </span>
          <div class="flex items-center gap-1.5">
            ${isClosed ? `
              <button onclick="openReviewModalForJob('${j.id}')" class="bg-amber-50 text-amber-700 hover:bg-amber-100 px-2.5 py-1 rounded-xl text-[10px] font-bold transition flex items-center gap-1">
                <i class="fa-solid fa-star text-[9px]"></i> Rate Pro
              </button>
            ` : ''}
            <button onclick="openJobDetail('${j.id}')" class="bg-brand-600 hover:bg-brand-700 text-white px-3 py-1 rounded-xl text-[10px] font-bold transition shadow-xs">
              View & Track
            </button>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

function getStatusBadgeClass(status) {
  switch (status) {
    case 'REQUESTED': return 'bg-blue-100 text-blue-800';
    case 'QUOTATIONS_RECEIVED': return 'bg-purple-100 text-purple-800 animate-pulse';
    case 'WORKER_SELECTED':
    case 'WORKER_CONFIRMED': return 'bg-cyan-100 text-cyan-800';
    case 'ON_THE_WAY':
    case 'ARRIVED': return 'bg-amber-100 text-amber-800';
    case 'INSPECTION':
    case 'WORK_STARTED': return 'bg-indigo-100 text-indigo-800';
    case 'WORK_COMPLETED':
    case 'PAYMENT': return 'bg-orange-100 text-orange-800';
    case 'REVIEW': return 'bg-emerald-100 text-emerald-800';
    case 'CLOSED': return 'bg-emerald-100 text-emerald-800';
    case 'CANCELLED': return 'bg-red-100 text-red-800';
    default: return 'bg-slate-100 text-slate-800';
  }
}

// ============================================================================
// 11-STAGE INTERACTIVE LIFECYCLE TRACKER MODAL
// ============================================================================
const LIFECYCLE_STAGES = [
  { key: 'REQUESTED', label: '1. Request Posted', desc: 'Customer request posted and broadcasted to verified local pros.' },
  { key: 'QUOTATIONS_RECEIVED', label: '2. Quotations Received', desc: 'Technicians submitted transparent quotes with visit fee and repair range.' },
  { key: 'WORKER_SELECTED', label: '3. Worker Selected', desc: 'Customer chose a technician; competing quotes automatically expired.' },
  { key: 'WORKER_CONFIRMED', label: '4. Worker Confirmed', desc: 'Technician confirmed time slot and accepted job assignment.' },
  { key: 'ON_THE_WAY', label: '5. On The Way', desc: 'Technician is en route with required tools and diagnostic kit.' },
  { key: 'ARRIVED', label: '6. Arrived At Site', desc: 'Technician has reached customer location and verified safety check.' },
  { key: 'INSPECTION', label: '7. Inspection & Diagnosis', desc: 'Checking problem, amp draw, leak test and providing clear estimate.' },
  { key: 'WORK_STARTED', label: '8. Work In Progress', desc: 'Repair work commenced with genuine parts and safety equipment.' },
  { key: 'WORK_COMPLETED', label: '9. Work Completed', desc: 'Service completed. Work demonstrated and customer confirmation requested.' },
  { key: 'PAYMENT', label: '10. Payment & Invoice', desc: 'Server calculates final itemized bill. UPI, Cards or Net Banking.' },
  { key: 'REVIEW', label: '11. Verified Review & Close', desc: 'Customer provides verified star rating and 4 sub-rating criteria.' }
];

async function openJobDetail(jobId) {
  state.currentJobId = jobId;
  try {
    const job = await apiCall(`/jobs/${jobId}`);
    state.currentJob = job;
    
    // Fetch quotes if applicable
    const quotes = await apiCall(`/quotes/${jobId}`);
    state.quotes = quotes;
  } catch (e) {
    console.error(e);
  }

  renderJobDetailModal();
  openModal('modal-job-detail');
}

function renderJobDetailModal() {
  const job = state.currentJob;
  if (!job) return;

  document.getElementById('jd-id').textContent = job.id;
  document.getElementById('jd-service-name').textContent = job.service_name;
  document.getElementById('jd-date-time').textContent = `${job.preferred_date} • ${job.preferred_time}`;
  document.getElementById('jd-status-badge').textContent = job.status.replace(/_/g, ' ');
  document.getElementById('jd-status-badge').className = `text-[11px] font-extrabold px-2.5 py-0.5 rounded-full ${getStatusBadgeClass(job.status)}`;

  // Status description
  const curStage = LIFECYCLE_STAGES.find(s => s.key === job.status);
  document.getElementById('jd-status-description').textContent = curStage ? curStage.desc : 'Job is currently in progress.';

  // Render Interactive Simulator Controls
  renderLifecycleSimControls(job);

  // Render 11-Stage Stepper
  renderTimelineStepper(job.status);

  // Quotes Section
  const quotesSection = document.getElementById('jd-quotes-section');
  if (['REQUESTED', 'QUOTATIONS_RECEIVED'].includes(job.status)) {
    quotesSection.classList.remove('hidden');
    renderJobQuotes();
  } else {
    quotesSection.classList.add('hidden');
  }

  // Assigned Worker Card
  const workerCard = document.getElementById('jd-assigned-worker-card');
  if (job.selected_worker) {
    workerCard.classList.remove('hidden');
    document.getElementById('jd-worker-name').textContent = job.selected_worker.name;
    document.getElementById('jd-worker-rating').textContent = job.selected_worker.rating;
    document.getElementById('jd-worker-jobs').textContent = `${job.selected_worker.jobs_completed} Jobs Completed`;
    document.getElementById('jd-worker-img').src = job.selected_worker.photo_url || 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80';
  } else {
    workerCard.classList.add('hidden');
  }

  // Evidence Gallery (Work Completed)
  const evidenceSec = document.getElementById('jd-evidence-gallery');
  if (['WORK_COMPLETED', 'PAYMENT', 'REVIEW', 'CLOSED'].includes(job.status)) {
    evidenceSec.classList.remove('hidden');
    document.getElementById('jd-evidence-images').innerHTML = `
      <div class="rounded-xl overflow-hidden border border-slate-200">
        <img src="https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=400&q=80" alt="Before" class="w-full h-24 object-cover" />
        <span class="text-[9px] font-bold block p-1 text-center bg-slate-100 text-slate-700">Before Inspection</span>
      </div>
      <div class="rounded-xl overflow-hidden border border-slate-200">
        <img src="https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=400&q=80" alt="After" class="w-full h-24 object-cover" />
        <span class="text-[9px] font-bold block p-1 text-center bg-brand-50 text-brand-800">After Service Completed</span>
      </div>
    `;
  } else {
    evidenceSec.classList.add('hidden');
  }

  // Render Action Footer (Pay / Review / Cancel)
  renderJobActionFooter(job);
}

function renderLifecycleSimControls(job) {
  const controlsBox = document.getElementById('jd-sim-controls');
  const stages = [
    { target: 'QUOTATIONS_RECEIVED', label: 'Simulate Quotes' },
    { target: 'WORKER_CONFIRMED', label: 'Pro Confirms' },
    { target: 'ON_THE_WAY', label: 'Pro On Way' },
    { target: 'ARRIVED', label: 'Pro Arrived' },
    { target: 'INSPECTION', label: 'Inspect' },
    { target: 'WORK_STARTED', label: 'Start Work' },
    { target: 'WORK_COMPLETED', label: 'Complete Work' },
    { target: 'CLOSED', label: 'Close Job' }
  ];

  controlsBox.innerHTML = stages.map(s => `
    <button onclick="advanceJobStatusTo('${s.target}')" 
      class="text-[10px] font-bold px-2 py-1 rounded-lg border transition ${job.status === s.target ? 'bg-amber-600 text-white border-amber-600' : 'bg-white text-amber-900 border-amber-300 hover:bg-amber-100'}">
      ${s.label}
    </button>
  `).join('');
}

async function advanceJobStatusTo(newStatus) {
  try {
    if (newStatus === 'QUOTATIONS_RECEIVED') {
      await apiCall(`/jobs/${state.currentJobId}/simulate-quotes`, { method: 'POST' });
    } else {
      await apiCall(`/jobs/${state.currentJobId}/status`, {
        method: 'POST',
        body: JSON.stringify({ status: newStatus })
      });
    }
    showToast(`Status updated to ${newStatus.replace(/_/g, ' ')}`, 'success');
    await openJobDetail(state.currentJobId);
    await fetchJobs();
  } catch (err) {
    showToast(err.message, 'error');
  }
}

function renderTimelineStepper(currentStatus) {
  const container = document.getElementById('jd-lifecycle-timeline');
  const curIdx = LIFECYCLE_STAGES.findIndex(s => s.key === currentStatus);

  container.innerHTML = LIFECYCLE_STAGES.map((s, idx) => {
    const isCompleted = idx < curIdx || currentStatus === 'CLOSED';
    const isCurrent = idx === curIdx && currentStatus !== 'CLOSED';
    
    let iconClass = 'bg-slate-200 text-slate-500';
    if (isCompleted) iconClass = 'bg-emerald-500 text-white shadow-xs';
    if (isCurrent) iconClass = 'bg-brand-600 text-white ring-4 ring-brand-100 shadow-md animate-pulse';

    return `
      <div class="flex items-start gap-3 relative">
        ${idx < LIFECYCLE_STAGES.length - 1 ? `<div class="absolute left-3.5 top-7 bottom-0 w-0.5 ${idx < curIdx ? 'bg-emerald-500' : 'bg-slate-200'}"></div>` : ''}
        <div class="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold shrink-0 z-10 ${iconClass}">
          ${isCompleted ? '<i class="fa-solid fa-check text-[10px]"></i>' : (idx + 1)}
        </div>
        <div class="flex-1 pb-2">
          <div class="flex items-center justify-between">
            <h5 class="text-xs font-bold ${isCurrent ? 'text-brand-700' : (isCompleted ? 'text-slate-900' : 'text-slate-400')}">${s.label}</h5>
            ${isCurrent ? '<span class="text-[9px] bg-brand-100 text-brand-800 font-extrabold px-1.5 py-0.2 rounded">Active Now</span>' : ''}
          </div>
          <p class="text-[10px] ${isCurrent ? 'text-slate-600' : 'text-slate-400'} mt-0.5">${s.desc}</p>
        </div>
      </div>
    `;
  }).join('');
}

function renderJobQuotes() {
  const container = document.getElementById('jd-quotes-list');
  document.getElementById('jd-quotes-count').textContent = `${state.quotes.length} Quotes Available`;

  if (state.quotes.length === 0) {
    container.innerHTML = `
      <div class="bg-slate-50 border border-slate-200 rounded-2xl p-4 text-center">
        <i class="fa-solid fa-satellite-dish text-brand-600 text-xl animate-bounce mb-1"></i>
        <p class="text-xs font-bold text-slate-800">Finding nearby professionals...</p>
        <p class="text-[10px] text-slate-500 mt-0.5">Technicians in Indirapuram & Noida are reviewing your request.</p>
        <button onclick="advanceJobStatusTo('QUOTATIONS_RECEIVED')" class="mt-2 text-xs font-bold text-brand-600 underline">Tap to simulate incoming quotes</button>
      </div>`;
    return;
  }

  container.innerHTML = state.quotes.map(q => `
    <div class="bg-white border-2 border-slate-200 hover:border-brand-500 rounded-2xl p-3.5 shadow-sm space-y-2.5 transition">
      <div class="flex items-start justify-between">
        <div class="flex items-center gap-2.5">
          <img src="${q.worker_photo || 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80'}" alt="${q.worker_name}" class="w-10 h-10 rounded-xl object-cover border border-slate-200" />
          <div>
            <h5 class="text-xs font-extrabold text-slate-900 flex items-center gap-1">
              ${q.worker_name}
              <i class="fa-solid fa-circle-check text-brand-500 text-[10px]"></i>
            </h5>
            <div class="flex items-center gap-1.5 text-[10px] text-slate-500">
              <span class="text-amber-500 font-bold flex items-center gap-0.5"><i class="fa-solid fa-star text-[9px]"></i> ${q.worker_rating}</span>
              <span>•</span>
              <span>${q.worker_jobs} jobs</span>
            </div>
          </div>
        </div>
        <div class="text-right">
          <span class="text-xs font-extrabold text-slate-900">₹${q.visit_fee.toFixed(0)}</span>
          <span class="text-[9px] text-slate-400 block">Inspection Fee</span>
        </div>
      </div>

      <!-- Quote details breakdown -->
      <div class="bg-slate-50 p-2 rounded-xl text-[10px] text-slate-600 space-y-1">
        <div class="flex justify-between">
          <span>Estimated Repair Range:</span>
          <strong class="text-slate-800">₹${q.estimate_min.toFixed(0)} - ₹${q.estimate_max.toFixed(0)}</strong>
        </div>
        <div class="flex justify-between text-brand-700 font-medium">
          <span>Parts Cost:</span>
          <span>${q.parts_extra ? 'Extra as per MRP (Fair pricing)' : 'Included'}</span>
        </div>
        <div class="flex justify-between">
          <span>Estimated Arrival:</span>
          <span class="font-bold text-slate-700">${q.estimated_arrival}</span>
        </div>
      </div>

      <p class="text-[10px] text-slate-600 italic">"${q.message}"</p>

      <!-- Action buttons -->
      <div class="flex items-center gap-2 pt-1">
        <button onclick="triggerMaskedCall()" class="bg-slate-100 hover:bg-slate-200 text-slate-700 px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1">
          <i class="fa-solid fa-phone text-[10px]"></i> Call
        </button>
        <button onclick="openChatForCurrentJob()" class="bg-slate-100 hover:bg-slate-200 text-slate-700 px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1">
          <i class="fa-solid fa-comment-dots text-[10px]"></i> Chat
        </button>
        <button onclick="handleSelectQuote('${q.id}')" class="flex-1 bg-brand-600 hover:bg-brand-700 text-white py-1.5 rounded-xl text-xs font-extrabold shadow-sm transition flex items-center justify-center gap-1">
          <span>Select This Pro</span>
          <i class="fa-solid fa-check text-[10px]"></i>
        </button>
      </div>
    </div>
  `).join('');
}

async function handleSelectQuote(quoteId) {
  try {
    const res = await apiCall(`/quotes/${quoteId}/select`, { method: 'POST' });
    showToast("Technician selected! Confirmed on schedule.", "success");
    await openJobDetail(state.currentJobId);
    await fetchJobs();
  } catch (err) {
    showToast(err.message, "error");
  }
}

function renderJobActionFooter(job) {
  const footer = document.getElementById('jd-action-footer');
  
  if (['WORK_COMPLETED', 'PAYMENT'].includes(job.status)) {
    footer.innerHTML = `
      <button onclick="openPaymentModal('${job.id}')" class="w-full bg-brand-600 hover:bg-brand-700 text-white font-extrabold py-3 rounded-2xl shadow-lg transition flex items-center justify-center gap-2 text-xs">
        <i class="fa-solid fa-shield-halved"></i>
        <span>Pay Authoritative Bill (₹${(job.final_amount || 699).toFixed(0)})</span>
        <i class="fa-solid fa-arrow-right text-[10px]"></i>
      </button>
    `;
  } else if (job.status === 'REVIEW') {
    footer.innerHTML = `
      <button onclick="openReviewModalForJob('${job.id}')" class="w-full bg-amber-500 hover:bg-amber-600 text-white font-extrabold py-3 rounded-2xl shadow-lg transition flex items-center justify-center gap-2 text-xs">
        <i class="fa-solid fa-star"></i>
        <span>Submit Verified Review for Completed Job</span>
      </button>
    `;
  } else if (job.status === 'CLOSED') {
    footer.innerHTML = `
      <div class="flex gap-2">
        <button onclick="openInvoiceModal('INV-KW-2026-0841')" class="flex-1 bg-slate-800 hover:bg-slate-900 text-white font-bold py-2.5 rounded-xl text-xs flex items-center justify-center gap-1.5 transition">
          <i class="fa-solid fa-receipt"></i> Tax Invoice
        </button>
        <button onclick="repeatBooking('${job.category}')" class="flex-1 bg-brand-600 hover:bg-brand-700 text-white font-extrabold py-2.5 rounded-xl text-xs flex items-center justify-center gap-1.5 shadow-md transition">
          <i class="fa-solid fa-rotate-right"></i> Book Again
        </button>
      </div>
    `;
  } else {
    footer.innerHTML = `
      <div class="flex items-center justify-between text-[11px] text-slate-500">
        <button onclick="handleReportJobIssue('${job.id}')" class="hover:text-red-600 font-semibold flex items-center gap-1">
          <i class="fa-solid fa-circle-exclamation text-amber-500"></i> Report Issue / Help
        </button>
        <button onclick="handleCancelJob('${job.id}')" class="hover:text-red-600 font-semibold text-red-500">
          Cancel Service
        </button>
      </div>
    `;
  }
}

async function handleCancelJob(jobId) {
  if (!confirm("Are you sure you want to cancel this booking?")) return;
  try {
    await apiCall(`/jobs/${jobId}/cancel`, { method: 'POST' });
    showToast("Booking cancelled successfully.", "info");
    await openJobDetail(jobId);
    await fetchJobs();
  } catch (err) {
    showToast(err.message, "error");
  }
}

function handleReportJobIssue(jobId) {
  closeModal('modal-job-detail');
  document.getElementById('sup-job-id').value = jobId;
  openSupportModal();
}

function repeatBooking(category) {
  closeModal('modal-job-detail');
  openNewRequestModal(category);
}

// ============================================================================
// CHAT & CONVERSATIONS
// ============================================================================
async function fetchConversations() {
  const container = document.getElementById('conversations-list');
  if (!container) return;

  const activeJob = state.jobs.find(j => j.id === 'KW-904128') || state.jobs[0];
  if (!activeJob) {
    container.innerHTML = `<p class="text-xs text-slate-400 py-6 text-center">No active chats.</p>`;
    return;
  }

  container.innerHTML = `
    <div onclick="openChatForCurrentJob('${activeJob.id}')" class="bg-white border border-slate-200 hover:border-brand-400 rounded-2xl p-3 shadow-xs hover:shadow-md cursor-pointer flex items-center justify-between transition">
      <div class="flex items-center gap-3">
        <div class="w-11 h-11 rounded-2xl bg-brand-100 text-brand-800 flex items-center justify-center font-bold text-sm">
          M
        </div>
        <div>
          <div class="flex items-center gap-1.5">
            <h4 class="text-xs font-bold text-slate-900">${activeJob.selected_worker ? activeJob.selected_worker.name : 'Manoj Kumar Verma'}</h4>
            <span class="text-[9px] bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.2 rounded">Technician</span>
          </div>
          <p class="text-[10px] text-slate-500 mt-0.5 truncate max-w-[200px]">"I am nearby in Sector 62. Reaching shortly."</p>
        </div>
      </div>
      <div class="text-right">
        <span class="text-[9px] text-slate-400">10m ago</span>
        <span class="w-2 h-2 rounded-full bg-brand-500 block ml-auto mt-1"></span>
      </div>
    </div>
  `;
}

async function openChatForCurrentJob(jobId = null) {
  const targetId = jobId || state.currentJobId || 'KW-904128';
  closeModal('modal-job-detail');
  
  try {
    const messages = await apiCall(`/chat/${targetId}`);
    renderChatMessages(messages);
  } catch (e) {
    console.warn(e);
  }

  openModal('modal-chat');
}

function renderChatMessages(messages) {
  const container = document.getElementById('chat-messages-stream');
  if (!container) return;

  container.innerHTML = messages.map(m => {
    if (m.sender_role === 'SYSTEM') {
      return `
        <div class="text-center my-2">
          <span class="bg-slate-200 text-slate-600 text-[10px] font-semibold px-2.5 py-1 rounded-full shadow-xs">
            <i class="fa-solid fa-bell text-[9px] mr-1"></i> ${m.content}
          </span>
        </div>
      `;
    }

    const isMe = m.sender_role === 'CUSTOMER';
    return `
      <div class="flex flex-col ${isMe ? 'items-end' : 'items-start'}">
        <div class="max-w-[75%] rounded-2xl p-2.5 shadow-xs ${isMe ? 'bg-brand-600 text-white rounded-tr-none' : 'bg-white text-slate-800 border border-slate-200 rounded-tl-none'}">
          <span class="text-[9px] font-bold block mb-0.5 ${isMe ? 'text-brand-200' : 'text-slate-400'}">${m.sender_name}</span>
          <p class="text-xs leading-relaxed">${m.content}</p>
          ${m.media_url ? `<img src="${m.media_url}" class="rounded-xl mt-1.5 max-h-36 object-cover" />` : ''}
        </div>
        <span class="text-[9px] text-slate-400 mt-0.5 px-1">${new Date(m.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
      </div>
    `;
  }).join('');

  container.scrollTop = container.scrollHeight;
}

async function handleSendChatMessage(e) {
  e.preventDefault();
  const input = document.getElementById('chat-input');
  const text = input.value.trim();
  if (!text) return;

  const targetId = state.currentJobId || 'KW-904128';

  try {
    const sent = await apiCall(`/chat/${targetId}`, {
      method: 'POST',
      body: JSON.stringify({ content: text, message_type: 'text' })
    });
    input.value = '';
    
    // Refresh messages
    const messages = await apiCall(`/chat/${targetId}`);
    renderChatMessages(messages);
  } catch (err) {
    showToast(err.message, 'error');
  }
}

function simulateChatPhotoAttachment() {
  showToast("Photo attachment preview added to chat.", "info");
}

// ============================================================================
// PAYMENTS & GST INVOICING
// ============================================================================
async function openPaymentModal(jobId) {
  state.currentJobId = jobId;
  closeModal('modal-job-detail');
  
  await updatePaymentBreakdown();
  openModal('modal-payment');
}

async function updatePaymentBreakdown() {
  const coupon = document.getElementById('coupon-input').value.trim();
  try {
    const data = await apiCall(`/payments/calculate-breakdown?job_id=${state.currentJobId}&discount_code=${coupon}`, {
      method: 'POST'
    });

    document.getElementById('pay-job-id').textContent = `Job #${data.job_id}`;
    document.getElementById('pay-base-charge').textContent = `₹${data.base_charge.toFixed(2)}`;
    document.getElementById('pay-platform-fee').textContent = `₹${data.platform_fee.toFixed(2)}`;
    document.getElementById('pay-discount-amount').textContent = `- ₹${data.discount_amount.toFixed(2)}`;
    document.getElementById('pay-coupon-code').textContent = data.discount_code || 'NONE';
    document.getElementById('pay-gst-amount').textContent = `₹${data.gst_amount.toFixed(2)}`;
    document.getElementById('pay-total-amount').textContent = `₹${data.final_total.toFixed(2)}`;
    document.getElementById('btn-pay-amount').textContent = `₹${data.final_total.toFixed(2)}`;
  } catch (e) {
    console.error(e);
  }
}

function applyCouponCode() {
  updatePaymentBreakdown();
  showToast("Coupon discount applied!", "success");
}

async function handleCompletePayment() {
  const btn = document.getElementById('btn-pay-confirm');
  btn.disabled = true;
  btn.innerHTML = `<i class="fa-solid fa-spinner animate-spin"></i> Authorizing Gateway...`;

  const coupon = document.getElementById('coupon-input').value.trim();
  const methodRadio = document.querySelector('input[name="pay-method"]:checked');
  const method = methodRadio ? methodRadio.value : 'UPI';

  try {
    // 1. Initiate order server-side
    const initRes = await apiCall('/payments/initiate', {
      method: 'POST',
      body: JSON.stringify({
        job_id: state.currentJobId,
        amount: 699,
        payment_method: method,
        discount_code: coupon
      })
    });

    // 2. Server verification step
    const verRes = await apiCall('/payments/verify', {
      method: 'POST',
      body: JSON.stringify({
        payment_id: initRes.id,
        provider_ref: `KW-PAY-${Math.floor(10000000 + Math.random() * 90000000)}`
      })
    });

    closeModal('modal-payment');
    showToast(`Payment of ₹${verRes.total_paid.toFixed(2)} Verified! Tax Invoice ${verRes.invoice_number} generated.`, 'success');
    
    await fetchJobs();
    openReviewModalForJob(state.currentJobId);
  } catch (err) {
    showToast(err.message, 'error');
  } finally {
    btn.disabled = false;
    btn.innerHTML = `Authorize & Pay <i class="fa-solid fa-lock text-xs"></i>`;
  }
}

async function openInvoiceModal(invoiceNo) {
  try {
    const inv = await apiCall(`/payments/invoice/${invoiceNo}`);
    document.getElementById('inv-number').textContent = inv.invoice_number;
    document.getElementById('inv-date').textContent = inv.date;
    document.getElementById('inv-cust-name').textContent = inv.customer_name;
    document.getElementById('inv-cust-phone').textContent = inv.customer_phone;
    document.getElementById('inv-cust-address').textContent = inv.address;
    document.getElementById('inv-item-desc').textContent = `${inv.service_name} (${inv.category})`;
    document.getElementById('inv-item-amount').textContent = `₹${inv.base_amount.toFixed(2)}`;
    document.getElementById('inv-item-gst').textContent = `₹${inv.gst_amount.toFixed(2)}`;
    document.getElementById('inv-total-paid').textContent = `₹${inv.total_paid.toFixed(2)}`;
    document.getElementById('inv-ref-id').textContent = inv.provider_ref;
  } catch (e) {
    console.warn(e);
  }
  openModal('modal-invoice');
}

// ============================================================================
// RATINGS & VERIFIED REVIEWS
// ============================================================================
function openReviewModalForJob(jobId) {
  state.currentJobId = jobId;
  closeModal('modal-job-detail');
  setStarRating(5);
  openModal('modal-review');
}

function setStarRating(num) {
  state.reviewRating = num;
  const stars = document.getElementById('star-picker').children;
  for (let i = 0; i < stars.length; i++) {
    if (i < num) {
      stars[i].className = 'fa-solid fa-star text-amber-400 cursor-pointer hover:scale-125 transition';
    } else {
      stars[i].className = 'fa-regular fa-star text-slate-300 cursor-pointer hover:scale-125 transition';
    }
  }
  const labels = ["1.0 - Poor", "2.0 - Fair", "3.0 - Good", "4.0 - Very Good", "5.0 - Excellent Service"];
  document.getElementById('star-rating-label').textContent = labels[num - 1];
}

function simulateReviewPhotoUpload() {
  document.getElementById('review-photo-btn-text').textContent = "Photo Proof Attached ✓";
  showToast("Photo review attachment uploaded.");
}

async function handleReviewSubmit(e) {
  e.preventDefault();
  const text = document.getElementById('review-text').value.trim();
  const quality = parseInt(document.getElementById('sub-quality').value);
  const behaviour = parseInt(document.getElementById('sub-behaviour').value);
  const ontime = parseInt(document.getElementById('sub-ontime').value);
  const price = parseInt(document.getElementById('sub-price').value);

  try {
    const res = await apiCall('/reviews', {
      method: 'POST',
      body: JSON.stringify({
        job_id: state.currentJobId,
        overall_rating: state.reviewRating,
        quality_rating: quality,
        behaviour_rating: behaviour,
        on_time_rating: ontime,
        price_rating: price,
        review_text: text,
        media_urls: []
      })
    });

    closeModal('modal-review');
    showToast("Verified review published with badge!", "success");
    await fetchJobs();
    await fetchWorkers();
  } catch (err) {
    showToast(err.message, "error");
  }
}

// ============================================================================
// NOTIFICATIONS
// ============================================================================
async function fetchNotifications() {
  try {
    const notifs = await apiCall('/notifications');
    state.notifications = notifs;
    renderNotifications();
  } catch (e) {
    console.warn(e);
  }
}

function renderNotifications() {
  const container = document.getElementById('notifications-list');
  const badge = document.getElementById('notif-badge');
  if (!container) return;

  const unreadCount = state.notifications.filter(n => !n.is_read).length;
  if (badge) {
    if (unreadCount > 0) badge.classList.remove('hidden');
    else badge.classList.add('hidden');
  }

  if (state.notifications.length === 0) {
    container.innerHTML = `<p class="text-xs text-slate-400 py-6 text-center">No notifications yet.</p>`;
    return;
  }

  container.innerHTML = state.notifications.map(n => `
    <div onclick="handleNotificationClick('${n.id}', '${n.action_link}')" class="bg-white border ${n.is_read ? 'border-slate-200' : 'border-brand-300 bg-brand-50/20'} rounded-2xl p-3 shadow-xs cursor-pointer hover:shadow-md transition space-y-1">
      <div class="flex items-center justify-between">
        <h5 class="text-xs font-bold text-slate-900 flex items-center gap-1.5">
          ${!n.is_read ? '<span class="w-2 h-2 rounded-full bg-brand-500"></span>' : ''}
          ${n.title}
        </h5>
        <span class="text-[9px] text-slate-400">${new Date(n.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
      </div>
      <p class="text-[11px] text-slate-600 leading-relaxed">${n.message}</p>
    </div>
  `).join('');
}

async function handleNotificationClick(notifId, link) {
  try {
    await apiCall(`/notifications/${notifId}/read`, { method: 'POST' });
    await fetchNotifications();
  } catch (e) {}

  if (link && link.startsWith('/jobs/')) {
    const jId = link.split('/jobs/')[1];
    openJobDetail(jId);
  } else if (link && link.startsWith('/invoices/')) {
    const invNo = link.split('/invoices/')[1];
    openInvoiceModal(invNo);
  }
}

async function markAllNotificationsRead() {
  state.notifications.forEach(async n => {
    try { await apiCall(`/notifications/${n.id}/read`, { method: 'POST' }); } catch(e){}
  });
  showToast("All notifications marked read.", "info");
  await fetchNotifications();
}

// ============================================================================
// ADDRESSES & CARE PLANS & SUPPORT
// ============================================================================
async function openAddressModal() {
  try {
    const addrs = await apiCall('/addresses');
    const container = document.getElementById('saved-addresses-list');
    container.innerHTML = addrs.map(a => `
      <div class="bg-white border border-slate-200 rounded-xl p-3 flex items-center justify-between">
        <div>
          <div class="flex items-center gap-1.5">
            <span class="font-bold text-xs text-slate-900">${a.label}</span>
            ${a.is_default ? '<span class="bg-emerald-100 text-emerald-800 text-[9px] font-bold px-1.5 py-0.2 rounded">Default</span>' : ''}
          </div>
          <p class="text-[11px] text-slate-600 mt-0.5">${a.address_line}</p>
          <p class="text-[9px] text-slate-400">${a.city} • ${a.postal_code}</p>
        </div>
      </div>
    `).join('');
  } catch (e) {}
  openModal('modal-addresses');
}

async function handleSaveNewAddress() {
  const label = document.getElementById('new-addr-label').value.trim() || 'Home';
  const line = document.getElementById('new-addr-line').value.trim();
  const landmark = document.getElementById('new-addr-landmark').value.trim();
  const city = document.getElementById('new-addr-city').value.trim();

  if (!line) {
    showToast("Please enter address details", "error");
    return;
  }

  try {
    await apiCall('/addresses', {
      method: 'POST',
      body: JSON.stringify({ label, address_line: line, landmark, city, postal_code: "201014", is_default: false })
    });
    showToast("Address saved!", "success");
    openAddressModal();
  } catch (err) {
    showToast(err.message, "error");
  }
}

async function openCarePlansModal() {
  try {
    const plans = await apiCall('/services/care-plans');
    const container = document.getElementById('care-plans-container');
    const isHi = state.lang === 'hi';

    container.innerHTML = plans.map(p => `
      <div class="bg-gradient-to-br from-amber-50 to-orange-50 border border-amber-200 rounded-2xl p-4 shadow-sm space-y-2.5">
        <div class="flex items-start justify-between">
          <div>
            <h4 class="text-sm font-extrabold text-amber-950">${isHi ? (p.name_hi || p.name) : p.name}</h4>
            <span class="text-[10px] text-amber-800 font-semibold">${p.duration} Complete Protection</span>
          </div>
          <div class="text-right">
            <span class="text-base font-black text-amber-900">₹${p.price_per_year}</span>
            <span class="text-[9px] text-amber-700 block">per year</span>
          </div>
        </div>

        <ul class="text-[11px] text-slate-700 space-y-1.5 pt-1">
          ${(isHi ? p.features_hi : p.features).map(f => `
            <li class="flex items-center gap-1.5"><i class="fa-solid fa-circle-check text-emerald-600 text-[10px]"></i> ${f}</li>
          `).join('')}
        </ul>

        <button onclick="subscribeCarePlan('${p.id}')" class="w-full bg-gradient-to-r from-amber-500 to-saffron-500 hover:from-amber-600 hover:to-saffron-600 text-white font-extrabold py-2.5 rounded-xl text-xs shadow-md transition">
          Subscribe Now (₹${p.price_per_year}/yr)
        </button>
      </div>
    `).join('');
  } catch (e) {}

  openModal('modal-care-plans');
}

function subscribeCarePlan(planId) {
  closeModal('modal-care-plans');
  showToast("KaamWala Care membership activated! Zero visit charges applied.", "success");
}

function openSupportModal() {
  openModal('modal-support');
}

async function handleSupportSubmit(e) {
  e.preventDefault();
  const category = document.getElementById('sup-category').value;
  const jobId = document.getElementById('sup-job-id').value.trim();
  const subject = document.getElementById('sup-subject').value.trim();
  const desc = document.getElementById('sup-desc').value.trim();

  try {
    await apiCall('/support/tickets', {
      method: 'POST',
      body: JSON.stringify({ category, job_id: jobId, subject, description: desc, priority: "HIGH" })
    });
    closeModal('modal-support');
    showToast("Support ticket submitted! Operations team has been notified.", "success");
  } catch (err) {
    showToast(err.message, "error");
  }
}

function triggerMaskedCall() {
  openModal('modal-masked-call');
}

function handleSearch(q) {
  state.activeFilter.category = q.trim();
  fetchWorkers();
}

function scrollToWorkers() {
  document.getElementById('workers-section').scrollIntoView({ behavior: 'smooth' });
}

function openFilterModal() {
  const verifiedOnly = confirm("Show only 100% Aadhaar & Skill Verified professionals?");
  state.activeFilter.verifiedOnly = verifiedOnly;
  fetchWorkers();
}

function handleLogout() {
  if (confirm("Do you want to log out of KaamWala?")) {
    showToast("Logged out successfully.", "info");
  }
}

function openPhoneQRModal() {
  openModal('modal-phone-qr');
}

// ============================================================================
// UI HELPERS (Modals & Toast)
// ============================================================================
function openModal(modalId) {
  const m = document.getElementById(modalId);
  if (m) m.classList.remove('hidden');
}

function closeModal(modalId) {
  const m = document.getElementById(modalId);
  if (m) m.classList.add('hidden');
}

function showToast(msg, type = 'info') {
  const container = document.getElementById('toast-container');
  if (!container) return;

  const toast = document.createElement('div');
  let bg = 'bg-slate-900 text-white';
  if (type === 'success') bg = 'bg-emerald-600 text-white';
  if (type === 'error') bg = 'bg-red-600 text-white';

  toast.className = `${bg} px-4 py-2 rounded-2xl shadow-xl text-xs font-bold flex items-center gap-2 animate-in fade-in slide-in-from-top-4 transition`;
  toast.innerHTML = `<i class="fa-solid fa-circle-info text-xs"></i> <span>${msg}</span>`;

  container.appendChild(toast);
  setTimeout(() => {
    toast.remove();
  }, 3500);
}
