import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, String, Integer, Float, Boolean, DateTime, ForeignKey, Text
from backend.app.database.session import Base

def generate_uuid() -> str:
    return str(uuid.uuid4())

class User(Base):
    __tablename__ = "kw_users"
    
    id = Column(String(64), primary_key=True, default=generate_uuid, index=True)
    role = Column(String(32), default="CUSTOMER", nullable=False) # CUSTOMER, WORKER, ADMIN
    name = Column(String(128), nullable=False)
    phone = Column(String(32), unique=True, index=True, nullable=False)
    email = Column(String(128), nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class CustomerProfile(Base):
    __tablename__ = "kw_customer_profiles"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    user_id = Column(String(64), ForeignKey("kw_users.id"), unique=True, nullable=False)
    photo = Column(Text, nullable=True)
    preferred_lang = Column(String(8), default="en") # "en" or "hi"
    default_address_id = Column(String(64), nullable=True)

class WorkerProfile(Base):
    __tablename__ = "kw_worker_profiles"
    
    id = Column(String(64), primary_key=True, default=generate_uuid, index=True)
    user_id = Column(String(64), ForeignKey("kw_users.id"), unique=True, nullable=True)
    name = Column(String(128), nullable=False)
    phone = Column(String(32), nullable=False)
    category = Column(String(64), nullable=False) # AC, Plumber, Electrician, RO, etc.
    skills = Column(Text, default="")
    bio = Column(Text, default="")
    experience_years = Column(Integer, default=5)
    rating = Column(Float, default=4.8)
    total_reviews = Column(Integer, default=42)
    jobs_completed = Column(Integer, default=85)
    on_time_rate = Column(Float, default=98.0) # percentage
    completion_rate = Column(Float, default=99.0) # percentage
    response_time_mins = Column(Integer, default=15)
    visit_fee = Column(Float, default=199.0)
    identity_verified = Column(Boolean, default=True)
    skill_verified = Column(Boolean, default=True)
    top_rated = Column(Boolean, default=True)
    fast_responder = Column(Boolean, default=True)
    photo_url = Column(Text, nullable=True)
    service_areas = Column(String(256), default="Indirapuram, Noida, Ghaziabad, East Delhi")
    before_after_photos = Column(Text, default="") # JSON list of URLs/photos

class Address(Base):
    __tablename__ = "kw_addresses"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    customer_id = Column(String(64), ForeignKey("kw_users.id"), nullable=False, index=True)
    label = Column(String(32), default="Home") # Home, Office, Other
    address_line = Column(String(256), nullable=False)
    landmark = Column(String(128), nullable=True)
    city = Column(String(64), default="New Delhi")
    postal_code = Column(String(16), default="110001")
    lat = Column(Float, default=28.6139)
    lng = Column(Float, default=77.2090)
    is_default = Column(Boolean, default=False)

class Job(Base):
    __tablename__ = "kw_jobs"
    
    id = Column(String(64), primary_key=True, index=True) # e.g. KW-839210
    customer_id = Column(String(64), ForeignKey("kw_users.id"), nullable=False, index=True)
    category = Column(String(64), nullable=False)
    service_name = Column(String(128), nullable=False)
    description = Column(Text, nullable=False)
    address_id = Column(String(64), ForeignKey("kw_addresses.id"), nullable=True)
    address_snapshot = Column(Text, nullable=True)
    preferred_date = Column(String(64), nullable=False)
    preferred_time = Column(String(64), nullable=False)
    budget_range = Column(String(64), nullable=True)
    special_instructions = Column(Text, nullable=True)
    media_urls = Column(Text, default="[]")
    status = Column(String(32), default="REQUESTED", index=True)
    selected_worker_id = Column(String(64), ForeignKey("kw_worker_profiles.id"), nullable=True)
    visit_fee = Column(Float, default=199.0)
    estimated_amount = Column(Float, default=450.0)
    final_amount = Column(Float, default=450.0)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

class Quote(Base):
    __tablename__ = "kw_quotes"
    
    id = Column(String(64), primary_key=True, default=generate_uuid, index=True)
    job_id = Column(String(64), ForeignKey("kw_jobs.id"), nullable=False, index=True)
    worker_id = Column(String(64), ForeignKey("kw_worker_profiles.id"), nullable=False)
    visit_fee = Column(Float, nullable=False)
    estimate_min = Column(Float, nullable=False)
    estimate_max = Column(Float, nullable=False)
    parts_extra = Column(Boolean, default=True)
    message = Column(Text, nullable=False)
    estimated_arrival = Column(String(64), default="30-45 mins")
    status = Column(String(32), default="PENDING")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class Message(Base):
    __tablename__ = "kw_messages"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    job_id = Column(String(64), ForeignKey("kw_jobs.id"), nullable=False, index=True)
    sender_id = Column(String(64), nullable=False)
    sender_role = Column(String(32), default="CUSTOMER")
    sender_name = Column(String(128), nullable=False)
    message_type = Column(String(32), default="text")
    content = Column(Text, nullable=False)
    media_url = Column(Text, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    read_at = Column(DateTime, nullable=True)

class Payment(Base):
    __tablename__ = "kw_payments"
    
    id = Column(String(64), primary_key=True, default=generate_uuid, index=True)
    job_id = Column(String(64), ForeignKey("kw_jobs.id"), nullable=False, index=True)
    customer_id = Column(String(64), ForeignKey("kw_users.id"), nullable=False)
    amount = Column(Float, nullable=False)
    platform_fee = Column(Float, default=19.0)
    gst_amount = Column(Float, default=0.0)
    discount_amount = Column(Float, default=0.0)
    total_paid = Column(Float, nullable=False)
    payment_method = Column(String(32), default="UPI")
    provider_ref = Column(String(64), nullable=False)
    status = Column(String(32), default="INITIATED")
    invoice_number = Column(String(64), nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class Review(Base):
    __tablename__ = "kw_reviews"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    job_id = Column(String(64), ForeignKey("kw_jobs.id"), nullable=False, unique=True, index=True)
    customer_id = Column(String(64), ForeignKey("kw_users.id"), nullable=False)
    customer_name = Column(String(128), nullable=False)
    worker_id = Column(String(64), ForeignKey("kw_worker_profiles.id"), nullable=False, index=True)
    overall_rating = Column(Integer, nullable=False)
    quality_rating = Column(Integer, default=5)
    behaviour_rating = Column(Integer, default=5)
    on_time_rating = Column(Integer, default=5)
    price_rating = Column(Integer, default=5)
    review_text = Column(Text, nullable=False)
    media_urls = Column(Text, default="[]")
    is_verified_job = Column(Boolean, default=True)
    moderation_status = Column(String(32), default="APPROVED")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class Notification(Base):
    __tablename__ = "kw_notifications"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    user_id = Column(String(64), ForeignKey("kw_users.id"), nullable=False, index=True)
    title = Column(String(128), nullable=False)
    message = Column(Text, nullable=False)
    notification_type = Column(String(32), default="JOB")
    action_link = Column(String(128), nullable=True)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class SupportTicket(Base):
    __tablename__ = "kw_support_tickets"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    user_id = Column(String(64), ForeignKey("kw_users.id"), nullable=False, index=True)
    job_id = Column(String(64), nullable=True)
    category = Column(String(64), default="General")
    subject = Column(String(128), nullable=False)
    description = Column(Text, nullable=False)
    priority = Column(String(32), default="MEDIUM")
    status = Column(String(32), default="OPEN")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

class AuditLog(Base):
    __tablename__ = "kw_audit_logs"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    actor_id = Column(String(64), nullable=True)
    actor_role = Column(String(32), default="ANONYMOUS")
    action = Column(String(64), nullable=False)
    resource_type = Column(String(64), nullable=False)
    resource_id = Column(String(64), nullable=True)
    ip_address = Column(String(64), nullable=True)
    timestamp = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    details = Column(Text, nullable=True)

class OtpRecord(Base):
    __tablename__ = "kw_otp_records"
    
    id = Column(String(64), primary_key=True, default=generate_uuid)
    phone = Column(String(32), index=True, nullable=False)
    hashed_otp = Column(String(128), nullable=False)
    expires_at = Column(DateTime, nullable=False)
    verified = Column(Boolean, default=False)
    attempts = Column(Integer, default=0)
