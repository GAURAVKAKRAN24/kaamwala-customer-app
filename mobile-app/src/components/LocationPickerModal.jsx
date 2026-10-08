import React, { useState } from 'react';
import { MapPin, Search, Navigation, CheckCircle, Home, Briefcase, Clock, X, Loader2 } from 'lucide-react';
import { INDIAN_LOCALITIES } from '../data/mockData';

export default function LocationPickerModal({ isOpen, onClose, currentLocation, onSelectLocation, lang }) {
  const [searchQuery, setSearchQuery] = useState('');
  const [isDetecting, setIsDetecting] = useState(false);
  const [detectedSuccess, setDetectedSuccess] = useState(null);

  if (!isOpen) return null;

  const isHi = lang === 'hi';

  // Filter localities based on search query
  const filteredLocalities = searchQuery.trim() === ''
    ? INDIAN_LOCALITIES.slice(0, 8)
    : INDIAN_LOCALITIES.filter(loc => 
        loc.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        loc.area.toLowerCase().includes(searchQuery.toLowerCase()) ||
        loc.city.toLowerCase().includes(searchQuery.toLowerCase()) ||
        loc.state.toLowerCase().includes(searchQuery.toLowerCase())
      );

  // Auto-Detect Current GPS Location
  const handleAutoDetectGPS = () => {
    setIsDetecting(true);
    setDetectedSuccess(null);

    if (!navigator.geolocation) {
      alert("Geolocation is not supported by your browser");
      setIsDetecting(false);
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude, accuracy } = position.coords;
        console.log(`GPS Lat: ${latitude}, Lng: ${longitude}, Acc: ${accuracy}m`);

        // Simulate high-precision reverse geocoding
        setTimeout(() => {
          setIsDetecting(false);
          const detected = {
            id: 'loc-gps',
            name: 'Current Location (GPS)',
            area: `Lat: ${latitude.toFixed(4)}, Lng: ${longitude.toFixed(4)} • Indirapuram`,
            city: 'Ghaziabad / Delhi NCR',
            state: 'NCR',
            fullLabel: `Indirapuram, Ghaziabad (±${Math.round(accuracy)}m GPS)`
          };
          setDetectedSuccess(detected.fullLabel);
          
          setTimeout(() => {
            onSelectLocation(detected.fullLabel);
            onClose();
          }, 800);
        }, 1000);
      },
      (error) => {
        console.warn("GPS error / permission denied fallback:", error.message);
        // Realistic fallback for dev/demo if user blocks browser permission
        setTimeout(() => {
          setIsDetecting(false);
          const fallback = "Shipra Sun City, Indirapuram, Ghaziabad";
          setDetectedSuccess(fallback);
          setTimeout(() => {
            onSelectLocation(fallback);
            onClose();
          }, 800);
        }, 800);
      },
      { timeout: 10000, enableHighAccuracy: true }
    );
  };

  const handleSelectLocality = (loc) => {
    const formatted = `${loc.name}, ${loc.city} (${loc.area})`;
    onSelectLocation(formatted);
    onClose();
  };

  const handleSelectSaved = (name) => {
    onSelectLocation(name);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex flex-col justify-end animate-in fade-in">
      <div 
        className="bg-white rounded-t-[32px] max-h-[88vh] flex flex-col shadow-2xl overflow-hidden animate-in slide-in-from-bottom duration-300"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Grab Handle & Header */}
        <div className="pt-3 pb-2 px-5 flex flex-col items-center border-b border-slate-100">
          <div className="w-12 h-1.5 bg-slate-200 rounded-full mb-3"></div>
          <div className="w-full flex items-center justify-between">
            <div>
              <h3 className="text-base font-extrabold text-slate-900 flex items-center gap-2">
                <MapPin className="w-5 h-5 text-emerald-600" />
                <span>{isHi ? "स्थान चुनें" : "Select Service Location"}</span>
              </h3>
              <p className="text-[11px] text-slate-500">
                {isHi ? "सत्यापित कारीगरों की उपलब्धता देखने के लिए पता चुनें" : "To show available verified technicians in your area"}
              </p>
            </div>
            <button 
              onClick={onClose} 
              className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 flex items-center justify-center text-slate-600"
            >
              <X className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Content Body */}
        <div className="p-4 overflow-y-auto space-y-4 text-xs scrollbar-hide">
          
          {/* 1. AUTO DETECT GPS BUTTON */}
          <button
            onClick={handleAutoDetectGPS}
            disabled={isDetecting}
            className="w-full bg-emerald-50 hover:bg-emerald-100 border border-emerald-200 p-3.5 rounded-2xl flex items-center justify-between text-left transition group active:scale-[0.98]"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-emerald-600 text-white flex items-center justify-center shadow-sm">
                {isDetecting ? (
                  <Loader2 className="w-5 h-5 animate-spin" />
                ) : (
                  <Navigation className="w-5 h-5 text-white" />
                )}
              </div>
              <div>
                <span className="font-extrabold text-slate-900 text-xs block">
                  {isDetecting 
                    ? (isHi ? "जीपीएस से स्थान खोज रहे हैं..." : "Detecting Current GPS Location...") 
                    : (isHi ? "वर्तमान स्थान स्वतः पहचानें (GPS)" : "Auto-Detect My Current Location")}
                </span>
                <span className="text-[10px] text-emerald-700 font-semibold block mt-0.5">
                  {detectedSuccess || (isHi ? "डिवाइस जीपीएस का उपयोग करें" : "Using device GPS & accuracy sensors")}
                </span>
              </div>
            </div>
            {detectedSuccess && <CheckCircle className="w-5 h-5 text-emerald-600" />}
          </button>

          {/* 2. SEARCH INPUT WITH LIVE AUTOCOMPLETE */}
          <div className="relative">
            <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3.5" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder={isHi ? "शहर, क्षेत्र या लैंडमार्क खोजें..." : "Search city, locality or landmark..."}
              className="w-full bg-slate-50 border border-slate-200 rounded-2xl pl-10 pr-10 py-3 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:bg-white focus:outline-none transition shadow-xs"
            />
            {searchQuery && (
              <button 
                onClick={() => setSearchQuery('')}
                className="absolute right-3.5 top-3.5 text-slate-400 hover:text-slate-600"
              >
                <X className="w-4 h-4" />
              </button>
            )}
          </div>

          {/* 3. QUICK SAVED ADDRESSES */}
          <div>
            <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-2">
              {isHi ? "सहेजे गए पते" : "Saved Addresses"}
            </span>
            <div className="grid grid-cols-2 gap-2">
              <div 
                onClick={() => handleSelectSaved("Flat 402, Shipra Sun City, Indirapuram")}
                className="bg-white border border-slate-200 p-2.5 rounded-xl cursor-pointer hover:border-emerald-500 transition flex items-center gap-2.5"
              >
                <Home className="w-4 h-4 text-emerald-600 shrink-0" />
                <div className="truncate">
                  <span className="font-bold text-slate-800 text-[11px] block">Home</span>
                  <span className="text-[10px] text-slate-500 truncate block">Flat 402, Shipra Sun City</span>
                </div>
              </div>

              <div 
                onClick={() => handleSelectSaved("TechZone 4, Sector 62, Noida")}
                className="bg-white border border-slate-200 p-2.5 rounded-xl cursor-pointer hover:border-emerald-500 transition flex items-center gap-2.5"
              >
                <Briefcase className="w-4 h-4 text-blue-600 shrink-0" />
                <div className="truncate">
                  <span className="font-bold text-slate-800 text-[11px] block">Office</span>
                  <span className="text-[10px] text-slate-500 truncate block">Sector 62, Noida</span>
                </div>
              </div>
            </div>
          </div>

          {/* 4. SEARCH SUGGESTIONS LIST */}
          <div>
            <div className="flex items-center justify-between mb-2">
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400">
                {searchQuery ? (isHi ? "खोज परिणाम" : "Matching Localities") : (isHi ? "प्रमुख क्षेत्र" : "Popular Service Hubs")}
              </span>
              <span className="text-[10px] text-slate-400">{filteredLocalities.length} areas found</span>
            </div>

            <div className="space-y-1.5 max-h-56 overflow-y-auto pr-1">
              {filteredLocalities.map(loc => (
                <div
                  key={loc.id}
                  onClick={() => handleSelectLocality(loc)}
                  className="bg-slate-50 hover:bg-emerald-50/60 border border-slate-100 hover:border-emerald-300 p-2.5 rounded-xl cursor-pointer transition flex items-center justify-between"
                >
                  <div className="flex items-start gap-2.5">
                    <MapPin className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
                    <div>
                      <div className="flex items-center gap-1.5">
                        <span className="font-bold text-slate-900 text-xs">{loc.name}</span>
                        {loc.popular && (
                          <span className="text-[8px] bg-emerald-100 text-emerald-800 font-extrabold px-1.5 py-0.2 rounded-full">
                            Active Hub
                          </span>
                        )}
                      </div>
                      <span className="text-[10px] text-slate-500 block">
                        {loc.area}, {loc.city} ({loc.state})
                      </span>
                    </div>
                  </div>
                  <span className="text-[10px] text-emerald-600 font-bold whitespace-nowrap">Select →</span>
                </div>
              ))}
            </div>
          </div>

        </div>
      </div>
    </div>
  );
}
