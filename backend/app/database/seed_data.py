import json
from datetime import datetime, timezone, timedelta
from sqlalchemy.orm import Session
from backend.app.database.session import SessionLocal, Base, engine
from backend.app.database.models import (
    User, CustomerProfile, WorkerProfile, Address, Job, Quote, Message, Payment, Review, Notification
)
from backend.app.core.security import hash_secret

def seed_database():
    Base.metadata.create_all(bind=engine)
    db: Session = SessionLocal()
    
    try:
        # Check if already seeded
        if db.query(User).first():
            return
            
        print("[INFO] Seeding database with initial KaamWala data...")
        
        # 1. Customer User
        customer_user = User(
            id="usr-cust-001",
            name="Rahul Sharma",
            phone="9876543210",
            email="rahul.sharma@example.in",
            role="CUSTOMER",
            is_active=True
        )
        db.add(customer_user)
        db.commit()
        
        customer_profile = CustomerProfile(
            id="prof-cust-001",
            user_id="usr-cust-001",
            photo="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=256&q=80",
            preferred_lang="en",
            default_address_id="addr-001"
        )
        db.add(customer_profile)
        db.commit()
        
        # 2. Addresses
        addr1 = Address(
            id="addr-001",
            customer_id="usr-cust-001",
            label="Home",
            address_line="Flat 402, Tower B, Shipra Sun City, Indirapuram",
            landmark="Near Shipra Mall",
            city="Ghaziabad / NCR",
            postal_code="201014",
            lat=28.6369,
            lng=77.3712,
            is_default=True
        )
        addr2 = Address(
            id="addr-002",
            customer_id="usr-cust-001",
            label="Office",
            address_line="Floor 3, TechZone 4, Sector 62",
            landmark="Opposite Stellar IT Park",
            city="Noida",
            postal_code="201309",
            lat=28.6270,
            lng=77.3725,
            is_default=False
        )
        db.add_all([addr1, addr2])
        db.commit()
        
        # 3. Verified Workers
        workers_data = [
            {
                "id": "wrk-001",
                "name": "Manoj Kumar Verma",
                "phone": "9811223344",
                "category": "AC",
                "skills": "AC Gas Refill, Deep Foam Jet Cleaning, PCB Repair, Installation, Inverter AC Specialist",
                "bio": "Certified HVAC technician with 8+ years experience with Daikin, Voltas, and LG systems. Guaranteed neat work and genuine spare parts.",
                "experience_years": 8,
                "rating": 4.9,
                "total_reviews": 142,
                "jobs_completed": 310,
                "on_time_rate": 99.2,
                "completion_rate": 99.8,
                "response_time_mins": 10,
                "visit_fee": 199.0,
                "identity_verified": True,
                "skill_verified": True,
                "top_rated": True,
                "fast_responder": True,
                "photo_url": "https://images.unsplash.com/photo-1540569014015-19a7be504e3a?auto=format&fit=crop&w=300&q=80",
                "service_areas": "Indirapuram, Vaishali, Vasundhara, Noida Sec 62",
                "before_after_photos": json.dumps([
                    "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=600&q=80",
                    "https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=600&q=80"
                ])
            },
            {
                "id": "wrk-002",
                "name": "Rajesh Prajapati",
                "phone": "9822334455",
                "category": "Electrician",
                "skills": "MCB Tripping fix, Smart Home Switches, Concealed Wiring, Fan/Chandelier Installation, Inverter Wiring",
                "bio": "Government-certified electrician. Safety-first approach, uses digital insulation testers, 100% copper wiring guarantee.",
                "experience_years": 10,
                "rating": 4.85,
                "total_reviews": 98,
                "jobs_completed": 240,
                "on_time_rate": 97.5,
                "completion_rate": 99.0,
                "response_time_mins": 12,
                "visit_fee": 149.0,
                "identity_verified": True,
                "skill_verified": True,
                "top_rated": True,
                "fast_responder": True,
                "photo_url": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80",
                "service_areas": "Noida, East Delhi, Ghaziabad",
                "before_after_photos": json.dumps([
                    "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=600&q=80"
                ])
            },
            {
                "id": "wrk-003",
                "name": "Suresh Chandra",
                "phone": "9833445566",
                "category": "Plumber",
                "skills": "Concealed Pipe Leakage, Kohler/Jaquar Fitting, Drain Unclogging, Pressure Pump, Tap replacement",
                "bio": "Expert plumber with specialized acoustic leak detection tools. Clean finishing and zero damage to tiles.",
                "experience_years": 7,
                "rating": 4.8,
                "total_reviews": 76,
                "jobs_completed": 185,
                "on_time_rate": 96.0,
                "completion_rate": 98.5,
                "response_time_mins": 15,
                "visit_fee": 149.0,
                "identity_verified": True,
                "skill_verified": True,
                "top_rated": False,
                "fast_responder": True,
                "photo_url": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80",
                "service_areas": "Indirapuram, Crossing Republik, Greater Noida",
                "before_after_photos": json.dumps([])
            },
            {
                "id": "wrk-004",
                "name": "Dinesh Kumar Yadav",
                "phone": "9844556677",
                "category": "RO",
                "skills": "RO Membrane replacement, TDS Adjustment, Kent & Aquaguard Specialist, UV lamp, Sediment filter",
                "bio": "Water purifier service specialist. Carries digital TDS meter and authentic manufacturer filters.",
                "experience_years": 6,
                "rating": 4.92,
                "total_reviews": 115,
                "jobs_completed": 290,
                "on_time_rate": 98.8,
                "completion_rate": 100.0,
                "response_time_mins": 8,
                "visit_fee": 149.0,
                "identity_verified": True,
                "skill_verified": True,
                "top_rated": True,
                "fast_responder": True,
                "photo_url": "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=300&q=80",
                "service_areas": "All Delhi NCR",
                "before_after_photos": json.dumps([])
            },
            {
                "id": "wrk-005",
                "name": "Pooja & Team (ShineClean)",
                "phone": "9855667788",
                "category": "Cleaner",
                "skills": "Deep Home Cleaning, Mechanized Bathroom Scrubbing, Kitchen Degreasing, Sofa Shampooing",
                "bio": "Professional 3-member team with commercial vacuum, steam cleaners and Taski eco-friendly chemicals.",
                "experience_years": 5,
                "rating": 4.88,
                "total_reviews": 64,
                "jobs_completed": 140,
                "on_time_rate": 98.0,
                "completion_rate": 99.5,
                "response_time_mins": 20,
                "visit_fee": 299.0,
                "identity_verified": True,
                "skill_verified": True,
                "top_rated": True,
                "fast_responder": False,
                "photo_url": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80",
                "service_areas": "Noida, Ghaziabad, South Delhi",
                "before_after_photos": json.dumps([])
            },
            {
                "id": "wrk-006",
                "name": "Ramvilas Sharma",
                "phone": "9866778899",
                "category": "Carpenter",
                "skills": "Modular Kitchen Hinges, Door Lock repair, Godrej smart lock, Wardrobe slider, Furniture repair",
                "bio": "Skilled artisan carpenter. Accurate alignment, dustless cutting setup, 12 years craftsmanship.",
                "experience_years": 12,
                "rating": 4.79,
                "total_reviews": 53,
                "jobs_completed": 120,
                "on_time_rate": 95.0,
                "completion_rate": 98.0,
                "response_time_mins": 25,
                "visit_fee": 199.0,
                "identity_verified": True,
                "skill_verified": True,
                "top_rated": False,
                "fast_responder": False,
                "photo_url": "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=300&q=80",
                "service_areas": "Indirapuram, Noida Sec 50-78",
                "before_after_photos": json.dumps([])
            }
        ]
        
        for w in workers_data:
            # create user for worker
            u = User(
                id=f"usr-{w['id']}",
                name=w["name"],
                phone=w["phone"],
                role="WORKER",
                is_active=True
            )
            db.add(u)
            db.commit()
            
            wp = WorkerProfile(
                id=w["id"],
                user_id=f"usr-{w['id']}",
                name=w["name"],
                phone=w["phone"],
                category=w["category"],
                skills=w["skills"],
                bio=w["bio"],
                experience_years=w["experience_years"],
                rating=w["rating"],
                total_reviews=w["total_reviews"],
                jobs_completed=w["jobs_completed"],
                on_time_rate=w["on_time_rate"],
                completion_rate=w["completion_rate"],
                response_time_mins=w["response_time_mins"],
                visit_fee=w["visit_fee"],
                identity_verified=w["identity_verified"],
                skill_verified=w["skill_verified"],
                top_rated=w["top_rated"],
                fast_responder=w["fast_responder"],
                photo_url=w["photo_url"],
                service_areas=w["service_areas"],
                before_after_photos=w["before_after_photos"]
            )
            db.add(wp)
            db.commit()
            
        # 4. Create Active Sample Job: KW-2026-901 (In status QUOTATIONS_RECEIVED)
        job1 = Job(
            id="KW-904128",
            customer_id="usr-cust-001",
            category="AC",
            service_name="Split AC Deep Cleaning & Cooling Check",
            description="AC indoor unit is blowing warm air and making a vibrating rattling sound when fan speed is increased. Need thorough inspection and jet cleaning.",
            address_id="addr-001",
            address_snapshot="Flat 402, Tower B, Shipra Sun City, Indirapuram, Ghaziabad",
            preferred_date="Tomorrow (Fri)",
            preferred_time="10:00 AM - 12:00 PM",
            budget_range="₹500 - ₹1,200",
            special_instructions="Please call before reaching main gate security.",
            media_urls=json.dumps([
                "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=600&q=80"
            ]),
            status="QUOTATIONS_RECEIVED",
            visit_fee=199.0,
            estimated_amount=699.0,
            final_amount=699.0,
            created_at=datetime.now(timezone.utc) - timedelta(hours=2)
        )
        db.add(job1)
        db.commit()
        
        # 5. Create 2 Quotes for Job 1 so customer can compare side-by-side
        q1 = Quote(
            id="qt-001",
            job_id="KW-904128",
            worker_id="wrk-001",
            visit_fee=199.0,
            estimate_min=499.0,
            estimate_max=799.0,
            parts_extra=True,
            message="Namaste Rahul ji. I will perform high pressure foam jet cleaning and test the capacitor/compressor amp draw. 30 days cooling warranty included.",
            estimated_arrival="Can reach in 35 mins",
            status="PENDING",
            created_at=datetime.now(timezone.utc) - timedelta(minutes=90)
        )
        
        q2 = Quote(
            id="qt-002",
            job_id="KW-904128",
            worker_id="wrk-002", # using an electrical specialist
            visit_fee=149.0,
            estimate_min=450.0,
            estimate_max=850.0,
            parts_extra=True,
            message="Hello, I specialize in AC electrical vibration and PCB motor diagnostics. Inspection fee ₹149 adjusted if work is performed.",
            estimated_arrival="Available at 11:00 AM",
            status="PENDING",
            created_at=datetime.now(timezone.utc) - timedelta(minutes=45)
        )
        db.add_all([q1, q2])
        db.commit()
        
        # 6. Sample Completed Job with Review and Invoice: KW-882103
        job2 = Job(
            id="KW-882103",
            customer_id="usr-cust-001",
            category="RO",
            service_name="Water Purifier Membrane & Filter Replacement",
            description="TDS level rose to 380 ppm. Need filter replacement and complete servicing.",
            address_id="addr-001",
            address_snapshot="Flat 402, Tower B, Shipra Sun City, Indirapuram, Ghaziabad",
            preferred_date="Yesterday",
            preferred_time="2:00 PM",
            budget_range="₹800 - ₹1,500",
            special_instructions="Kent Grand Plus model.",
            media_urls=json.dumps([]),
            status="CLOSED",
            selected_worker_id="wrk-004",
            visit_fee=149.0,
            estimated_amount=1200.0,
            final_amount=1150.0,
            created_at=datetime.now(timezone.utc) - timedelta(days=3)
        )
        db.add(job2)
        db.commit()
        
        # Review for Job 2
        rev1 = Review(
            id="rev-001",
            job_id="KW-882103",
            customer_id="usr-cust-001",
            customer_name="Rahul Sharma",
            worker_id="wrk-004",
            overall_rating=5,
            quality_rating=5,
            behaviour_rating=5,
            on_time_rating=5,
            price_rating=5,
            review_text="Excellent service by Dinesh ji! Replaced sediment filter and tuned TDS to 95 ppm. Verified authentic Kent filters with QR code. Very polite behavior.",
            media_urls=json.dumps([]),
            is_verified_job=True,
            moderation_status="APPROVED",
            created_at=datetime.now(timezone.utc) - timedelta(days=2)
        )
        db.add(rev1)
        
        # Payment for Job 2
        pay1 = Payment(
            id="pay-001",
            job_id="KW-882103",
            customer_id="usr-cust-001",
            amount=1150.0,
            platform_fee=19.0,
            gst_amount=210.42,
            discount_amount=100.0, # FIRST100 coupon
            total_paid=1069.0,
            payment_method="UPI",
            provider_ref="UPI-RR-9428519280",
            status="SUCCESS",
            invoice_number="INV-KW-2026-0841",
            created_at=datetime.now(timezone.utc) - timedelta(days=3)
        )
        db.add(pay1)
        
        # 7. Notifications
        notif1 = Notification(
            id="notif-001",
            user_id="usr-cust-001",
            title="Quotes Received for AC Repair",
            message="2 top verified technicians have submitted quotation for Job #KW-904128. Tap to compare.",
            notification_type="QUOTE",
            action_link="/jobs/KW-904128",
            is_read=False,
            created_at=datetime.now(timezone.utc) - timedelta(minutes=40)
        )
        notif2 = Notification(
            id="notif-002",
            user_id="usr-cust-001",
            title="Payment Receipt Generated",
            message="Invoice #INV-KW-2026-0841 for RO servicing is ready for download.",
            notification_type="PAYMENT",
            action_link="/invoices/INV-KW-2026-0841",
            is_read=True,
            created_at=datetime.now(timezone.utc) - timedelta(days=3)
        )
        db.add_all([notif1, notif2])
        
        # 8. Sample Chat for Job 1
        msg1 = Message(
            id="msg-001",
            job_id="KW-904128",
            sender_id="system",
            sender_role="SYSTEM",
            sender_name="KaamWala System",
            message_type="system",
            content="Service request KW-904128 created. Matching verified technicians nearby.",
            created_at=datetime.now(timezone.utc) - timedelta(hours=2)
        )
        msg2 = Message(
            id="msg-002",
            job_id="KW-904128",
            sender_id="wrk-001",
            sender_role="WORKER",
            sender_name="Manoj Kumar Verma",
            message_type="text",
            content="Namaste Rahul ji. I am nearby in Sector 62. Does the outdoor unit also have accessibility for inspection?",
            created_at=datetime.now(timezone.utc) - timedelta(minutes=80)
        )
        msg3 = Message(
            id="msg-003",
            job_id="KW-904128",
            sender_id="usr-cust-001",
            sender_role="CUSTOMER",
            sender_name="Rahul Sharma",
            message_type="text",
            content="Yes, the outdoor unit is mounted right on the balcony railing, easily accessible.",
            created_at=datetime.now(timezone.utc) - timedelta(minutes=75)
        )
        db.add_all([msg1, msg2, msg3])
        
        db.commit()
        print("[SUCCESS] Database seeding complete!")
        
    except Exception as e:
        db.rollback()
        print(f"Error seeding database: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_database()
