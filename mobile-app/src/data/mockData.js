// Comprehensive Mock Data & Indian Locality Database for KaamWala Mobile App

export const INDIAN_LOCALITIES = [
  { id: 'loc-1', name: 'Indirapuram', area: 'Shipra Sun City, Ahinsa Khand', city: 'Ghaziabad', state: 'Delhi NCR', popular: true },
  { id: 'loc-2', name: 'Sector 62', area: 'TechZone, Stellar IT Park', city: 'Noida', state: 'Delhi NCR', popular: true },
  { id: 'loc-3', name: 'Sector 18', area: 'Atta Market, Wave Silver Tower', city: 'Noida', state: 'Delhi NCR', popular: true },
  { id: 'loc-4', name: 'Connaught Place', area: 'Inner Circle, Barakhamba', city: 'New Delhi', state: 'Delhi NCR', popular: true },
  { id: 'loc-5', name: 'Saket', area: 'Select Citywalk, Press Enclave', city: 'South Delhi', state: 'Delhi NCR', popular: true },
  { id: 'loc-6', name: 'DLF Phase 5', area: 'Golf Course Road', city: 'Gurugram', state: 'Delhi NCR', popular: true },
  { id: 'loc-7', name: 'Cyber City', area: 'DLF Phase 2, Belvedere', city: 'Gurugram', state: 'Delhi NCR', popular: true },
  { id: 'loc-8', name: 'Koramangala', area: '4th Block, 80 Feet Road', city: 'Bengaluru', state: 'Karnataka', popular: true },
  { id: 'loc-9', name: 'HSR Layout', area: 'Sector 1 & 2, 27th Main', city: 'Bengaluru', state: 'Karnataka', popular: true },
  { id: 'loc-10', name: 'Indiranagar', area: '100ft Road, 12th Main', city: 'Bengaluru', state: 'Karnataka', popular: true },
  { id: 'loc-11', name: 'Whitefield', area: 'ITPB, Hope Farm', city: 'Bengaluru', state: 'Karnataka', popular: true },
  { id: 'loc-12', name: 'Andheri West', area: 'Lokhandwala Complex', city: 'Mumbai', state: 'Maharashtra', popular: true },
  { id: 'loc-13', name: 'Bandra West', area: 'Hill Road, Pali Hill', city: 'Mumbai', state: 'Maharashtra', popular: true },
  { id: 'loc-14', name: 'Powai', area: 'Hiranandani Gardens', city: 'Mumbai', state: 'Maharashtra', popular: true },
  { id: 'loc-15', name: 'Juhu', area: 'JVPD Scheme, Tara Road', city: 'Mumbai', state: 'Maharashtra', popular: false },
  { id: 'loc-16', name: 'Banjara Hills', area: 'Road No. 12 & 3', city: 'Hyderabad', state: 'Telangana', popular: true },
  { id: 'loc-17', name: 'Hitec City', area: 'Madhapur, Cyber Towers', city: 'Hyderabad', state: 'Telangana', popular: true },
  { id: 'loc-18', name: 'Gachibowli', area: 'Financial District', city: 'Hyderabad', state: 'Telangana', popular: false },
  { id: 'loc-19', name: 'Viman Nagar', area: 'Phoenix Marketcity', city: 'Pune', state: 'Maharashtra', popular: true },
  { id: 'loc-20', name: 'Kothrud', area: 'Paud Road, Karve Nagar', city: 'Pune', state: 'Maharashtra', popular: false },
  { id: 'loc-21', name: 'Salt Lake', area: 'Sector V & Sector 1', city: 'Kolkata', state: 'West Bengal', popular: true },
  { id: 'loc-22', name: 'T. Nagar', area: 'Pondy Bazaar, Usman Road', city: 'Chennai', state: 'Tamil Nadu', popular: true },
  { id: 'loc-23', name: 'Gomti Nagar', area: 'Vibhuti Khand, Patrakarpuram', city: 'Lucknow', state: 'Uttar Pradesh', popular: true },
  { id: 'loc-24', name: 'Civil Lines', area: 'MI Road, C-Scheme', city: 'Jaipur', state: 'Rajasthan', popular: true },
  { id: 'loc-25', name: 'Satellite', area: 'Prahlad Nagar, SG Highway', city: 'Ahmedabad', state: 'Gujarat', popular: true }
];

export const SERVICE_CATEGORIES = [
  {
    id: 'AC',
    name: 'AC Repair & Service',
    name_hi: 'एसी रिपेयर एवं सर्विस',
    icon: '❄️',
    badge: 'Popular',
    desc: 'Foam jet clean, gas leak fix & PCB repair',
    desc_hi: 'फोम जेट क्लीन, गैस लीकेज व पीसीबी रिपेयर',
    starting_price: 199,
    sub_services: [
      { id: 'ac-1', title: 'Deep Power Jet Cleaning', title_hi: 'पावर जेट डीप क्लीनिंग', price: 499, duration: '45 mins' },
      { id: 'ac-2', title: 'Gas Leak Check & Refill', title_hi: 'गैस लीक जांच व रिफिल', price: 1499, duration: '60 mins' },
      { id: 'ac-3', title: 'Complete Installation / Unmount', title_hi: 'इंस्टॉलेशन / अनइंस्टॉलेशन', price: 799, duration: '90 mins' },
      { id: 'ac-4', title: 'Cooling Troubleshooting & Inspection', title_hi: 'कूलिंग न करने की जांच', price: 199, duration: '30 mins' }
    ]
  },
  {
    id: 'Electrician',
    name: 'Electrician',
    name_hi: 'इलेक्ट्रीशियन',
    icon: '⚡',
    badge: '15m Fast',
    desc: 'Wiring, MCB tripping, fans, switchboards',
    desc_hi: 'वायरिंग, एमसीबी ट्रिप, पंखा व स्विचबोर्ड',
    starting_price: 149,
    sub_services: [
      { id: 'el-1', title: 'Switchboard / Socket Repair', title_hi: 'स्विचबोर्ड रिपेयर', price: 149, duration: '20 mins' },
      { id: 'el-2', title: 'MCB / Fuse Tripping Fix', title_hi: 'एमसीबी ट्रिपिंग समस्या', price: 249, duration: '30 mins' },
      { id: 'el-3', title: 'Ceiling Fan / Exhaust Install', title_hi: 'पंखा / एग्जॉस्ट लगाना', price: 199, duration: '35 mins' },
      { id: 'el-4', title: 'Inverter Wiring & Battery Check', title_hi: 'इन्वर्टर वायरिंग व बैटरी', price: 349, duration: '45 mins' }
    ]
  },
  {
    id: 'Plumber',
    name: 'Plumber',
    name_hi: 'प्लम्बर',
    icon: '🔧',
    badge: 'Verified',
    desc: 'Tap leakages, pipe blockages & fittings',
    desc_hi: 'नल रिपेयर, पाइप लीकेज व फिटिंग्स',
    starting_price: 149,
    sub_services: [
      { id: 'pl-1', title: 'Tap & Mixer Leakage Repair', title_hi: 'नल / मिक्सर लीकेज', price: 149, duration: '25 mins' },
      { id: 'pl-2', title: 'Drain & Washbasin Unclogging', title_hi: 'ड्रेन व बेसिन जाम खोलना', price: 299, duration: '40 mins' },
      { id: 'pl-3', title: 'Concealed Pipe Acoustic Detection', title_hi: 'अंदरूनी पाइप लीकेज जांच', price: 499, duration: '60 mins' },
      { id: 'pl-4', title: 'Toilet Flush / Seat Fitting', title_hi: 'टॉयलेट फ्लश व सीट रिपेयर', price: 349, duration: '45 mins' }
    ]
  },
  {
    id: 'RO',
    name: 'RO Purifier',
    name_hi: 'आर.ओ. प्यूरीफायर',
    icon: '💧',
    badge: 'Top Rated',
    desc: 'Filter replacement, membrane & TDS tune',
    desc_hi: 'फिल्टर रिप्लेसमेंट, मेम्ब्रेन व टीडीएस',
    starting_price: 149,
    sub_services: [
      { id: 'ro-1', title: 'RO General Service & TDS Test', title_hi: 'आर.ओ. सर्विस व टीडीएस जांच', price: 249, duration: '30 mins' },
      { id: 'ro-2', title: 'Full Sediment & Carbon Filter Kit', title_hi: 'फिल्टर किट रिप्लेसमेंट', price: 799, duration: '45 mins' },
      { id: 'ro-3', title: 'Original RO Membrane Change', title_hi: 'ओरिजिनल मेम्ब्रेन बदलना', price: 1299, duration: '45 mins' }
    ]
  },
  {
    id: 'Refrigerator',
    name: 'Refrigerator',
    name_hi: 'रेफ्रिजरेटर / फ्रिज',
    icon: '🧊',
    badge: 'Warranty',
    desc: 'Cooling issue, compressor & gas charge',
    desc_hi: 'कूलिंग समस्या, कंप्रेसर व गैस',
    starting_price: 199,
    sub_services: [
      { id: 'fr-1', title: 'Not Cooling / Frost Check', title_hi: 'कूलिंग न होने की जांच', price: 199, duration: '30 mins' },
      { id: 'fr-2', title: 'Fridge Gas Refill & Leak Fix', title_hi: 'गैस रिफिल व लीकेज', price: 1399, duration: '60 mins' },
      { id: 'fr-3', title: 'Compressor Relay & Motor Fix', title_hi: 'कंप्रेसर व मोटर रिपेयर', price: 399, duration: '45 mins' }
    ]
  },
  {
    id: 'Washing Machine',
    name: 'Washing Machine',
    name_hi: 'वॉशिंग मशीन',
    icon: '🧺',
    badge: 'Expert',
    desc: 'Drum spin issue, water drainage & noise',
    desc_hi: 'ड्रम स्पिन, पानी ड्रेन व आवाज',
    starting_price: 199,
    sub_services: [
      { id: 'wm-1', title: 'Water Drainage Blockage', title_hi: 'पानी ड्रेन न होना', price: 299, duration: '30 mins' },
      { id: 'wm-2', title: 'Drum Spin & Motor Vibration', title_hi: 'ड्रम न घूमना व वाइब्रेशन', price: 349, duration: '45 mins' }
    ]
  },
  {
    id: 'Carpenter',
    name: 'Carpenter',
    name_hi: 'बढ़ई / कारपेंटर',
    icon: '🔨',
    badge: 'Artisan',
    desc: 'Door locks, modular hinges & furniture',
    desc_hi: 'डोर लॉक, कब्जे व फर्नीचर रिपेयर',
    starting_price: 199,
    sub_services: [
      { id: 'cr-1', title: 'Smart Lock / Door Lock Fix', title_hi: 'डोर लॉक लगाना व ठीक करना', price: 249, duration: '35 mins' },
      { id: 'cr-2', title: 'Modular Kitchen Hinge Alignment', title_hi: 'किचन कैबिनेट व कब्जे ठीक करना', price: 199, duration: '30 mins' }
    ]
  },
  {
    id: 'Painter',
    name: 'Painter',
    name_hi: 'पेंटर / रंगाई',
    icon: '🎨',
    badge: 'Guaranteed',
    desc: 'Touchup paint, full room & waterproofing',
    desc_hi: 'दीवार टचअप, कमरा पेंट व सीलन',
    starting_price: 299,
    sub_services: [
      { id: 'pt-1', title: 'Single Room / Touchup Painting', title_hi: 'एक कमरा / टचअप पेंट', price: 999, duration: '3 hours' },
      { id: 'pt-2', title: 'Dampness & Waterproof Coating', title_hi: 'सीलन व वाटरप्रूफ कोटिंग', price: 499, duration: '2 hours' }
    ]
  },
  {
    id: 'Cleaner',
    name: 'Deep Cleaning',
    name_hi: 'डीप क्लीनिंग',
    icon: '✨',
    badge: 'Eco-Clean',
    desc: 'Bathroom scrubbing, kitchen & full home',
    desc_hi: 'बाथरूम, किचन व पूरा घर सफाई',
    starting_price: 299,
    sub_services: [
      { id: 'cl-1', title: 'Mechanized Bathroom Deep Clean', title_hi: 'बाथरूम डीप क्लीनिंग', price: 399, duration: '60 mins' },
      { id: 'cl-2', title: 'Kitchen Degreasing & Chimney', title_hi: 'किचन व चिमनी सफाई', price: 699, duration: '90 mins' }
    ]
  }
];

export const TOP_WORKERS = [
  {
    id: 'wrk-001',
    name: 'Manoj Kumar Verma',
    category: 'AC',
    skills: ['Split AC Jet Wash', 'Gas Refill', 'Capacitor', 'PCB Repair'],
    bio: 'Certified HVAC technician with 8+ years experience. Verified genuine spares and clean work guaranteed.',
    experience_years: 8,
    rating: 4.9,
    total_reviews: 142,
    jobs_completed: 310,
    on_time_rate: 99,
    response_time: '10 mins',
    visit_fee: 199,
    identity_verified: true,
    skill_verified: true,
    top_rated: true,
    fast_responder: true,
    photo_url: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80',
    service_areas: 'Indirapuram, Sector 62 Noida, Vaishali',
    before_after: [
      'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=400&q=80'
    ]
  },
  {
    id: 'wrk-002',
    name: 'Rajesh Prajapati',
    category: 'Electrician',
    skills: ['MCB Tripping', 'Concealed Wiring', 'Smart Switches', 'Inverter'],
    bio: 'Govt. licensed electrician. 10 years on-field expertise with digital insulation testers and safety standard wiring.',
    experience_years: 10,
    rating: 4.85,
    total_reviews: 98,
    jobs_completed: 240,
    on_time_rate: 98,
    response_time: '12 mins',
    visit_fee: 149,
    identity_verified: true,
    skill_verified: true,
    top_rated: true,
    fast_responder: true,
    photo_url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
    service_areas: 'Noida, East Delhi, Indirapuram',
    before_after: []
  },
  {
    id: 'wrk-003',
    name: 'Suresh Chandra',
    category: 'Plumber',
    skills: ['Jaquar/Kohler Fittings', 'Acoustic Leak Detection', 'Drain Unclogging'],
    bio: 'Master plumber with 7 years experience in high-rise societies. Zero tile damage guarantee.',
    experience_years: 7,
    rating: 4.8,
    total_reviews: 76,
    jobs_completed: 185,
    on_time_rate: 96,
    response_time: '15 mins',
    visit_fee: 149,
    identity_verified: true,
    skill_verified: true,
    top_rated: false,
    fast_responder: true,
    photo_url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
    service_areas: 'Ghaziabad, Indirapuram, Crossing Republik',
    before_after: []
  },
  {
    id: 'wrk-004',
    name: 'Dinesh Kumar Yadav',
    category: 'RO',
    skills: ['Kent & Aquaguard Specialist', 'Membrane Replace', 'Digital TDS Tune'],
    bio: 'Water purifier service specialist carrying genuine factory sealed filters with QR verification.',
    experience_years: 6,
    rating: 4.92,
    total_reviews: 115,
    jobs_completed: 290,
    on_time_rate: 99,
    response_time: '8 mins',
    visit_fee: 149,
    identity_verified: true,
    skill_verified: true,
    top_rated: true,
    fast_responder: true,
    photo_url: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80',
    service_areas: 'Delhi NCR, Indirapuram, Noida',
    before_after: []
  }
];

export const INITIAL_JOB = {
  id: 'KW-904128',
  category: 'AC',
  service_name: 'Split AC Deep Cleaning & Cooling Check',
  description: 'Indoor unit blowing lukewarm air with vibrating rattling sound at higher fan speed.',
  address: 'Flat 402, Shipra Sun City, Indirapuram, Ghaziabad',
  date: 'Tomorrow (Fri)',
  time: '10:00 AM - 12:00 PM',
  status: 'QUOTATIONS_RECEIVED',
  visit_fee: 199,
  estimated_amount: 699,
  final_amount: 699,
  selected_worker: null,
  quotes: [
    {
      id: 'qt-1',
      worker_id: 'wrk-001',
      worker_name: 'Manoj Kumar Verma',
      worker_rating: 4.9,
      worker_jobs: 310,
      worker_photo: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80',
      visit_fee: 199,
      estimate_min: 499,
      estimate_max: 799,
      parts_extra: true,
      message: 'Namaste! Available to visit with high-pressure foam jet machine. 30-day cooling warranty included.',
      arrival_time: 'Can reach in 30 mins'
    },
    {
      id: 'qt-2',
      worker_id: 'wrk-002',
      worker_name: 'Rajesh Prajapati',
      worker_rating: 4.85,
      worker_jobs: 240,
      worker_photo: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
      visit_fee: 149,
      estimate_min: 450,
      estimate_max: 850,
      parts_extra: true,
      message: 'Electrical and motor vibration specialist. Inspection fee ₹149 adjusted if work is performed.',
      arrival_time: 'Available at 11:00 AM'
    }
  ]
};

export const CARE_PLANS = [
  {
    id: 'care-appliance',
    title: 'KaamWala Appliance Shield',
    title_hi: 'कामवाला अप्लायंस शील्ड',
    price: 1499,
    duration: '1 Year',
    badge: 'Most Popular',
    perks: [
      'Unlimited free inspection visits (AC, RO, Fridge, Washing Machine)',
      '100% genuine manufacturer spare parts at wholesale rate',
      'Priority technician arrival within 30 minutes in Delhi-NCR',
      '₹500 complimentary service credit'
    ],
    perks_hi: [
      'साल भर सभी अप्लायंस के लिए असीमित मुफ्त विजिट',
      '100% असली स्पेयर पार्ट्स होलसेल रेट पर',
      '30 मिनट में प्राथमिकता सेवा',
      '₹500 का मुफ्त सर्विस क्रेडिट'
    ]
  },
  {
    id: 'care-home',
    title: 'KaamWala Complete HomeCare',
    title_hi: 'कामवाला संपूर्ण होमकेयर',
    price: 2999,
    duration: '1 Year',
    badge: 'VIP Care',
    perks: [
      'Covers Electrician, Plumber, AC, RO and Carpenter',
      '2 Free Full-Home Safety & Plumbing Audits per year',
      'Zero visit charges throughout 365 days',
      'Dedicated VIP Support Manager'
    ],
    perks_hi: [
      'इलेक्ट्रीशियन, प्लम्बर, एसी, आरओ व बढ़ई सभी शामिल',
      'साल में 2 फ्री संपूर्ण घर सुरक्षा ऑडिट',
      '365 दिन शून्य विजिट चार्ज',
      'समर्पित वीआईपी सपोर्ट मैनेजर'
    ]
  }
];
