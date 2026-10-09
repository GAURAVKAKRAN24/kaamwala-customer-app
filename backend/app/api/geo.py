from typing import List, Optional
from pydantic import BaseModel
from fastapi import APIRouter, Query

router = APIRouter(prefix="/geo", tags=["Geolocation & Suggestions"])

INDIAN_SERVICE_HUBS = [
    {"id": "loc_1", "name": "Sector 18", "area": "Atta Market, Wave Mall", "city": "Noida", "state": "Delhi NCR", "pincode": "201301", "lat": 28.5708, "lng": 77.3260, "is_popular": True},
    {"id": "loc_2", "name": "Sector 62", "area": "TechZone, Stellar IT Park", "city": "Noida", "state": "Delhi NCR", "pincode": "201309", "lat": 28.6280, "lng": 77.3649, "is_popular": True},
    {"id": "loc_3", "name": "Indirapuram", "area": "Shipra Sun City, Ahinsa Khand", "city": "Ghaziabad", "state": "Delhi NCR", "pincode": "201014", "lat": 28.6415, "lng": 77.3714, "is_popular": True},
    {"id": "loc_4", "name": "Connaught Place", "area": "Inner Circle, Barakhamba", "city": "New Delhi", "state": "Delhi NCR", "pincode": "110001", "lat": 28.6304, "lng": 77.2177, "is_popular": True},
    {"id": "loc_5", "name": "DLF Phase 5", "area": "Golf Course Road", "city": "Gurugram", "state": "Delhi NCR", "pincode": "122009", "lat": 28.4595, "lng": 77.0266, "is_popular": True},
    {"id": "loc_6", "name": "Cyber City", "area": "DLF Phase 2, Belvedere", "city": "Gurugram", "state": "Delhi NCR", "pincode": "122002", "lat": 28.4906, "lng": 77.0899, "is_popular": True},
    {"id": "loc_7", "name": "Koramangala", "area": "4th Block, 80 Feet Road", "city": "Bengaluru", "state": "Karnataka", "pincode": "560034", "lat": 12.9352, "lng": 77.6245, "is_popular": True},
    {"id": "loc_8", "name": "HSR Layout", "area": "Sector 1 & 2, 27th Main", "city": "Bengaluru", "state": "Karnataka", "pincode": "560102", "lat": 12.9121, "lng": 77.6446, "is_popular": True},
    {"id": "loc_9", "name": "Indiranagar", "area": "100ft Road, 12th Main", "city": "Bengaluru", "state": "Karnataka", "pincode": "560038", "lat": 12.9784, "lng": 77.6408, "is_popular": True},
    {"id": "loc_10", "name": "Whitefield", "area": "ITPB, Hope Farm", "city": "Bengaluru", "state": "Karnataka", "pincode": "560066", "lat": 12.9698, "lng": 77.7500, "is_popular": True},
    {"id": "loc_11", "name": "Andheri West", "area": "Lokhandwala Complex", "city": "Mumbai", "state": "Maharashtra", "pincode": "400053", "lat": 19.1363, "lng": 72.8277, "is_popular": True},
    {"id": "loc_12", "name": "Bandra West", "area": "Hill Road, Pali Hill", "city": "Mumbai", "state": "Maharashtra", "pincode": "400050", "lat": 19.0596, "lng": 72.8295, "is_popular": True},
    {"id": "loc_13", "name": "Powai", "area": "Hiranandani Gardens", "city": "Mumbai", "state": "Maharashtra", "pincode": "400076", "lat": 19.1176, "lng": 72.9060, "is_popular": True},
    {"id": "loc_14", "name": "Banjara Hills", "area": "Road No. 12", "city": "Hyderabad", "state": "Telangana", "pincode": "500034", "lat": 17.4156, "lng": 78.4354, "is_popular": True},
    {"id": "loc_15", "name": "Viman Nagar", "area": "Phoenix Marketcity", "city": "Pune", "state": "Maharashtra", "pincode": "411014", "lat": 18.5679, "lng": 73.9143, "is_popular": True},
]

@router.get("/suggest")
def suggest_localities(q: Optional[str] = Query(None, description="Search term for city, area or pincode")):
    if not q or not q.strip():
        return {"results": INDIAN_SERVICE_HUBS[:8]}
    
    query = q.strip().lower()
    matched = [
        hub for hub in INDIAN_SERVICE_HUBS
        if query in hub["name"].lower()
        or query in hub["area"].lower()
        or query in hub["city"].lower()
        or query in hub["state"].lower()
        or query in hub["pincode"]
    ]
    return {"results": matched if matched else INDIAN_SERVICE_HUBS[:3]}

@router.get("/reverse")
def reverse_geocode(lat: float = Query(..., description="Latitude"), lng: float = Query(..., description="Longitude")):
    # Find nearest locality from Indian hubs or default to Sector 18, Noida
    nearest = INDIAN_SERVICE_HUBS[0]
    min_dist = float("inf")
    for hub in INDIAN_SERVICE_HUBS:
        d = (hub["lat"] - lat) ** 2 + (hub["lng"] - lng) ** 2
        if d < min_dist:
            min_dist = d
            nearest = hub
            
    return {
        "formatted_address": f"{nearest['name']}, {nearest['area']}, {nearest['city']}, {nearest['state']} • {nearest['pincode']}",
        "locality": nearest["name"],
        "area": nearest["area"],
        "city": nearest["city"],
        "state": nearest["state"],
        "pincode": nearest["pincode"],
        "lat": lat,
        "lng": lng,
        "accuracy_meters": 15.0
    }
