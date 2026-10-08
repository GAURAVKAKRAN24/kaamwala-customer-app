from fastapi import APIRouter
from typing import List, Dict, Any

router = APIRouter(prefix="/services", tags=["Services & Categories"])

CATEGORIES = [
    {
        "id": "AC",
        "name": "AC Repair & Service",
        "name_hi": "एसी रिपेयर एवं सर्विस",
        "icon": "❄️",
        "badge": "Popular",
        "description": "Jet foam wash, gas leak fix, cooling troubleshooting & PCB repair",
        "description_hi": "जेट फोम वॉश, गैस लीकेज, कूलिंग एवं पीसीबी रिपेयर",
        "starting_price": 199,
        "sub_services": [
            {"id": "ac-deep-clean", "title": "Deep Power Jet Cleaning", "title_hi": "पावर जेट डीप क्लीनिंग", "price": 499},
            {"id": "ac-gas-charge", "title": "Gas Leak Repair & Refill", "title_hi": "गैस लीक रिपेयर व रिफिल", "price": 1499},
            {"id": "ac-install", "title": "Installation / Uninstallation", "title_hi": "इंस्टॉलेशन / अनइंस्टॉलेशन", "price": 799},
            {"id": "ac-not-cooling", "title": "Cooling Problem Check", "title_hi": "कूलिंग न करने की जांच", "price": 199}
        ]
    },
    {
        "id": "Electrician",
        "name": "Electrician",
        "name_hi": "इलेक्ट्रीशियन",
        "icon": "⚡",
        "badge": "Fast 15m",
        "description": "Wiring, MCB tripping, fan installation, switchboard replacement",
        "description_hi": "वायरिंग, एमसीबी ट्रिप, पंखा एवं स्विचबोर्ड रिपेयर",
        "starting_price": 149,
        "sub_services": [
            {"id": "elec-switchboard", "title": "Switchboard Repair / Replacement", "title_hi": "स्विचबोर्ड रिपेयर / बदलना", "price": 149},
            {"id": "elec-mcb", "title": "MCB / Fuse Tripping Fix", "title_hi": "एमसीबी व फ्यूज समस्या", "price": 249},
            {"id": "elec-fan", "title": "Ceiling Fan / Exhaust Installation", "title_hi": "फैन / एग्जॉस्ट लगाना", "price": 199},
            {"id": "elec-inverter", "title": "Inverter Wiring & Battery Check", "title_hi": "इन्वर्टर वायरिंग व बैटरी जांच", "price": 349}
        ]
    },
    {
        "id": "Plumber",
        "name": "Plumber",
        "name_hi": "प्लम्बर",
        "icon": "🔧",
        "badge": "Verified",
        "description": "Tap leakages, pipe blockages, sanitary fittings, motor pump",
        "description_hi": "नल रिपेयर, पाइप लीकेज, ब्लॉक ड्रेन एवं फिटिंग्स",
        "starting_price": 149,
        "sub_services": [
            {"id": "plumb-tap", "title": "Tap / Mixer Leakage Repair", "title_hi": "नल / मिक्सर लीकेज रिपेयर", "price": 149},
            {"id": "plumb-block", "title": "Drain / Washbasin Unclogging", "title_hi": "ड्रेन / बेसिन जाम खोलना", "price": 299},
            {"id": "plumb-pipe", "title": "Concealed Pipe Leakage Detection", "title_hi": "दीवार के अंदर पाइप लीकेज", "price": 499},
            {"id": "plumb-toilet", "title": "Toilet Seat / Flush Tank Fix", "title_hi": "टॉयलेट सीट व फ्लश रिपेयर", "price": 349}
        ]
    },
    {
        "id": "RO",
        "name": "RO & Water Purifier",
        "name_hi": "आर.ओ. वाटर प्यूरीफायर",
        "icon": "💧",
        "badge": "Top Rated",
        "description": "Filter replacement, membrane service, TDS tuning, motor fix",
        "description_hi": "फिल्टर रिप्लेसमेंट, मेम्ब्रेन सर्विस, टीडीएस सेटिंग",
        "starting_price": 149,
        "sub_services": [
            {"id": "ro-general-service", "title": "RO General Service & TDS Test", "title_hi": "आर.ओ. सर्विस व टीडीएस जांच", "price": 249},
            {"id": "ro-filter-change", "title": "Filter & Sediment Kit Change", "title_hi": "फिल्टर किट बदलना", "price": 799},
            {"id": "ro-membrane-change", "title": "RO Membrane Replacement", "title_hi": "आर.ओ. मेम्ब्रेन रिप्लेसमेंट", "price": 1299},
            {"id": "ro-water-leak", "title": "Water Leakage / Low Flow Repair", "title_hi": "पानी का कम बहाव / लीकेज", "price": 199}
        ]
    },
    {
        "id": "Refrigerator",
        "name": "Refrigerator",
        "name_hi": "रेफ्रिजरेटर / फ्रिज",
        "icon": "🧊",
        "badge": "Warranty",
        "description": "Single/Double door cooling issue, compressor, gas charge",
        "description_hi": "कूलिंग की समस्या, गैस चार्ज, कंप्रेसर रिपेयर",
        "starting_price": 199,
        "sub_services": [
            {"id": "fridge-cooling", "title": "Not Cooling / Over Cooling Check", "title_hi": "कूलिंग न होने की जांच", "price": 199},
            {"id": "fridge-gas", "title": "Fridge Gas Refill", "title_hi": "रेफ्रिजरेटर गैस रिफिल", "price": 1399},
            {"id": "fridge-noise", "title": "Compressor & Noise Issue", "title_hi": "कंप्रेसर आवाज समस्या", "price": 399}
        ]
    },
    {
        "id": "Washing Machine",
        "name": "Washing Machine",
        "name_hi": "वॉशिंग मशीन",
        "icon": "🧺",
        "badge": "Expert",
        "description": "Front/Top load drum spin issues, water drainage, vibration",
        "description_hi": "ड्रम घूमने की समस्या, पानी ड्रेन न होना, मोटर",
        "starting_price": 199,
        "sub_services": [
            {"id": "wm-drain", "title": "Water Not Draining", "title_hi": "पानी ड्रेन न होना", "price": 299},
            {"id": "wm-spin", "title": "Drum Not Spinning", "title_hi": "ड्रम न घूमना", "price": 349},
            {"id": "wm-vibe", "title": "Heavy Vibration / Noise Check", "title_hi": "ज्यादा कंपन व आवाज", "price": 199}
        ]
    },
    {
        "id": "Carpenter",
        "name": "Carpenter",
        "name_hi": "बढ़ई / कारपेंटर",
        "icon": "🔨",
        "badge": "Custom",
        "description": "Door locks, modular kitchen hinges, wardrobe sliders, furniture",
        "description_hi": "दरवाजे के ताले, अलमारी, मॉड्यूलर किचन, फर्नीचर",
        "starting_price": 199,
        "sub_services": [
            {"id": "carp-lock", "title": "Door Lock / Smart Lock Fitting", "title_hi": "डोर लॉक / स्मार्ट लॉक लगाना", "price": 249},
            {"id": "carp-hinge", "title": "Cabinet / Wardrobe Hinge Fix", "title_hi": "कब्जे व चैनल रिपेयर", "price": 199},
            {"id": "carp-furniture", "title": "Furniture Assembly / Repair", "title_hi": "फर्नीचर असेंबली व रिपेयर", "price": 399}
        ]
    },
    {
        "id": "Painter",
        "name": "Painter",
        "name_hi": "पेंटर / रंगाई",
        "icon": "🎨",
        "badge": "Consultation",
        "description": "Wall touchup, full home repaint, waterproof coating, textures",
        "description_hi": "दीवार टचअप, पूरा घर पेंट, वाटरप्रूफिंग",
        "starting_price": 299,
        "sub_services": [
            {"id": "paint-touchup", "title": "Single Room / Touchup Paint", "title_hi": "एक कमरा / टचअप पेंट", "price": 999},
            {"id": "paint-full", "title": "Full Home Paint Consultation", "title_hi": "पूरे घर की पेंटिंग जांच", "price": 299},
            {"id": "paint-waterproof", "title": "Dampness & Waterproof Coating", "title_hi": "सीलन व वाटरप्रूफिंग", "price": 499}
        ]
    },
    {
        "id": "Cleaner",
        "name": "Home Cleaning",
        "name_hi": "डीप क्लीनिंग",
        "icon": "✨",
        "badge": "Eco-Friendly",
        "description": "Deep home cleaning, motorized bathroom scrubbing, sofa shampoo",
        "description_hi": "घर की गहरी सफाई, बाथरूम स्क्रबिंग, सोफा सफाई",
        "starting_price": 299,
        "sub_services": [
            {"id": "clean-bath", "title": "Intense Bathroom Deep Clean", "title_hi": "बाथरूम डीप क्लीनिंग", "price": 399},
            {"id": "clean-kitchen", "title": "Kitchen Degreasing & Chimney", "title_hi": "किचन व चिमनी सफाई", "price": 699},
            {"id": "clean-full", "title": "Complete 2BHK/3BHK Deep Clean", "title_hi": "पूरा फ्लैट डीप क्लीनिंग", "price": 2499}
        ]
    }
]

CARE_PLANS = [
    {
        "id": "plan-appliance",
        "name": "KaamWala Appliance Shield",
        "name_hi": "कामवाला अप्लायंस शील्ड",
        "price_per_year": 1499,
        "duration": "1 Year",
        "features": [
            "Unlimited free inspection visits for AC, RO, Fridge & Washing Machine",
            "100% genuine spare parts guarantee at wholesale rates",
            "Priority technician within 30 minutes in Delhi-NCR",
            "₹500 complimentary service credit"
        ],
        "features_hi": [
            "एसी, आरओ, फ्रिज और वॉशिंग मशीन के लिए साल भर फ्री विजिट",
            "100% असली स्पेयर पार्ट्स गारंटी होलसेल रेट पर",
            "30 मिनट में प्राथमिकता सेवा",
            "₹500 का मुफ्त सर्विस क्रेडिट"
        ]
    },
    {
        "id": "plan-home",
        "name": "KaamWala Complete HomeCare",
        "name_hi": "कामवाला संपूर्ण होमकेयर",
        "price_per_year": 2999,
        "duration": "1 Year",
        "features": [
            "Covers Electrician, Plumber, AC, RO and Carpenter",
            "2 Free Full-Home Safety & Plumbing Audits per year",
            "Zero visit charges throughout 365 days",
            "VIP Dedicated Relationship Manager & instant support"
        ],
        "features_hi": [
            "इलेक्ट्रीशियन, प्लम्बर, एसी, आरओ और बढ़ई सभी शामिल",
            "साल में 2 फ्री संपूर्ण घर सुरक्षा एवं प्लंबिंग ऑडिट",
            "365 दिन कोई विजिट चार्ज नहीं",
            "समर्पित रिलेशनशिप मैनेजर और तुरंत सहायता"
        ]
    }
]

@router.get("/categories")
def get_categories():
    return CATEGORIES

@router.get("/care-plans")
def get_care_plans():
    return CARE_PLANS
