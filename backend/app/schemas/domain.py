from datetime import datetime
from typing import List, Optional, Any
from pydantic import BaseModel, Field

# AUTH
class OTPRequest(BaseModel):
    phone: str = Field(..., description="10-digit Indian phone number or email")

class OTPVerify(BaseModel):
    phone: str
    otp: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_id: str
    role: str
    name: str
    phone: str
    preferred_lang: str = "en"

class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    photo: Optional[str] = None
    preferred_lang: Optional[str] = None

class UserOut(BaseModel):
    id: str
    name: str
    phone: str
    email: Optional[str] = None
    role: str
    preferred_lang: str = "en"
    photo: Optional[str] = None

# ADDRESS
class AddressCreate(BaseModel):
    label: str = "Home"
    address_line: str
    landmark: Optional[str] = None
    city: str = "New Delhi"
    postal_code: str = "110001"
    lat: Optional[float] = 28.6139
    lng: Optional[float] = 77.2090
    is_default: bool = False

class AddressOut(BaseModel):
    id: str
    customer_id: str
    label: str
    address_line: str
    landmark: Optional[str] = None
    city: str
    postal_code: str
    lat: float
    lng: float
    is_default: bool

# WORKER
class WorkerOut(BaseModel):
    id: str
    name: str
    category: str
    skills: List[str]
    bio: str
    experience_years: int
    rating: float
    total_reviews: int
    jobs_completed: int
    on_time_rate: float
    completion_rate: float
    response_time_mins: int
    visit_fee: float
    identity_verified: bool
    skill_verified: bool
    top_rated: bool
    fast_responder: bool
    photo_url: Optional[str] = None
    service_areas: str
    before_after_photos: List[str] = []

# JOB
class JobCreate(BaseModel):
    category: str
    service_name: str
    description: str
    address_id: Optional[str] = None
    address_snapshot: Optional[str] = None
    preferred_date: str
    preferred_time: str
    budget_range: Optional[str] = None
    special_instructions: Optional[str] = None
    media_urls: List[str] = []

class JobStatusUpdate(BaseModel):
    status: str
    note: Optional[str] = None

class JobOut(BaseModel):
    id: str
    customer_id: str
    category: str
    service_name: str
    description: str
    address_id: Optional[str] = None
    address_snapshot: Optional[str] = None
    preferred_date: str
    preferred_time: str
    budget_range: Optional[str] = None
    special_instructions: Optional[str] = None
    media_urls: List[str] = []
    status: str
    selected_worker_id: Optional[str] = None
    selected_worker: Optional[WorkerOut] = None
    visit_fee: float
    estimated_amount: float
    final_amount: float
    created_at: datetime
    updated_at: datetime

# QUOTES
class QuoteOut(BaseModel):
    id: str
    job_id: str
    worker_id: str
    worker_name: str
    worker_rating: float
    worker_jobs: int
    worker_photo: Optional[str] = None
    visit_fee: float
    estimate_min: float
    estimate_max: float
    parts_extra: bool
    message: str
    estimated_arrival: str
    status: str
    created_at: datetime

class QuoteSelect(BaseModel):
    quote_id: str

# CHAT
class MessageCreate(BaseModel):
    content: str
    message_type: str = "text" # text, image
    media_url: Optional[str] = None

class MessageOut(BaseModel):
    id: str
    job_id: str
    sender_id: str
    sender_role: str
    sender_name: str
    message_type: str
    content: str
    media_url: Optional[str] = None
    created_at: datetime

# PAYMENTS
class PaymentInitiate(BaseModel):
    job_id: str
    amount: float
    payment_method: str = "UPI"
    discount_code: Optional[str] = None

class PaymentVerify(BaseModel):
    payment_id: str
    provider_ref: str
    signature: Optional[str] = None

class PaymentOut(BaseModel):
    id: str
    job_id: str
    customer_id: str
    amount: float
    platform_fee: float
    gst_amount: float
    discount_amount: float
    total_paid: float
    payment_method: str
    provider_ref: str
    status: str
    invoice_number: Optional[str] = None
    created_at: datetime

# REVIEWS
class ReviewCreate(BaseModel):
    job_id: str
    overall_rating: int = Field(..., ge=1, le=5)
    quality_rating: int = Field(5, ge=1, le=5)
    behaviour_rating: int = Field(5, ge=1, le=5)
    on_time_rating: int = Field(5, ge=1, le=5)
    price_rating: int = Field(5, ge=1, le=5)
    review_text: str
    media_urls: List[str] = []

class ReviewOut(BaseModel):
    id: str
    job_id: str
    customer_name: str
    worker_id: str
    overall_rating: int
    quality_rating: int
    behaviour_rating: int
    on_time_rating: int
    price_rating: int
    review_text: str
    media_urls: List[str] = []
    is_verified_job: bool
    created_at: datetime

# NOTIFICATIONS
class NotificationOut(BaseModel):
    id: str
    user_id: str
    title: str
    message: str
    notification_type: str
    action_link: Optional[str] = None
    is_read: bool
    created_at: datetime

# SUPPORT
class SupportTicketCreate(BaseModel):
    job_id: Optional[str] = None
    category: str
    subject: str
    description: str
    priority: str = "MEDIUM"

class SupportTicketOut(BaseModel):
    id: str
    user_id: str
    job_id: Optional[str] = None
    category: str
    subject: str
    description: str
    priority: str
    status: str
    created_at: datetime
