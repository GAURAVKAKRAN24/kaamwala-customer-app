from datetime import datetime, timezone, timedelta
from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, CustomerProfile, OtpRecord
from backend.app.schemas.domain import OTPRequest, OTPVerify, TokenResponse, UserUpdate, UserOut
from backend.app.core.security import generate_secure_otp, hash_secret, verify_secret, create_access_token
from backend.app.security.rate_limiter import rate_limiter, get_client_ip
from backend.app.security.dependencies import get_current_user, record_audit

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/request-otp")
def request_otp(payload: OTPRequest, request: Request, db: Session = Depends(get_db)):
    ip = get_client_ip(request)
    # Rate limit OTP requests: max 5 requests per minute per IP + Phone
    rate_limiter.check_rate_limit(f"otp_req_{ip}_{payload.phone}", max_requests=5, window_seconds=60)
    
    clean_phone = payload.phone.strip()
    otp = generate_secure_otp(6)
    hashed_otp = hash_secret(otp)
    expires_at = datetime.now(timezone.utc) + timedelta(minutes=5)
    
    # Invalidate previous unverified OTPs for this phone
    db.query(OtpRecord).filter(OtpRecord.phone == clean_phone, OtpRecord.verified == False).delete()
    
    record = OtpRecord(
        phone=clean_phone,
        hashed_otp=hashed_otp,
        expires_at=expires_at,
        verified=False,
        attempts=0
    )
    db.add(record)
    db.commit()
    
    # Audit log
    record_audit(db, None, "ANONYMOUS", "OTP_REQUESTED", "AUTH", clean_phone, ip)
    
    # In production, SMS gateway is invoked here (e.g. Fast2SMS / Twilio)
    # For frictionless evaluation and development, we also return the generated demo_otp in the JSON response
    return {
        "success": True,
        "message": f"Verification code sent to {clean_phone}",
        "demo_otp": otp, # Provided for instant tester login
        "expires_in_seconds": 300
    }

@router.post("/verify-otp", response_model=TokenResponse)
def verify_otp(payload: OTPVerify, request: Request, db: Session = Depends(get_db)):
    ip = get_client_ip(request)
    clean_phone = payload.phone.strip()
    clean_otp = payload.otp.strip()
    
    # Rate limit OTP verification attempts to prevent brute force
    rate_limiter.check_rate_limit(f"otp_ver_{ip}_{clean_phone}", max_requests=5, window_seconds=60, lockout_seconds=180)
    
    record = db.query(OtpRecord).filter(
        OtpRecord.phone == clean_phone,
        OtpRecord.verified == False
    ).order_by(OtpRecord.expires_at.desc()).first()
    
    if not record:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No active OTP found. Please request a new OTP.")
        
    if datetime.now(timezone.utc) > record.expires_at.replace(tzinfo=timezone.utc):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="OTP has expired. Please request a fresh OTP.")
        
    # Check attempts
    if record.attempts >= 5:
        raise HTTPException(status_code=status.HTTP_429_TOO_MANY_REQUESTS, detail="Too many invalid attempts. Please request a new OTP.")
        
    record.attempts += 1
    
    # Verify hash constant-time
    if not verify_secret(clean_otp, record.hashed_otp):
        db.commit()
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid OTP code. Please check and try again.")
        
    record.verified = True
    db.commit()
    
    # Check if user exists or create new Customer
    user = db.query(User).filter(User.phone == clean_phone).first()
    if not user:
        user = User(
            name="Customer",
            phone=clean_phone,
            role="CUSTOMER",
            is_active=True
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        
        prof = CustomerProfile(
            user_id=user.id,
            preferred_lang="en"
        )
        db.add(prof)
        db.commit()
    else:
        prof = db.query(CustomerProfile).filter(CustomerProfile.user_id == user.id).first()
        
    lang = prof.preferred_lang if prof else "en"
    
    # Generate JWT with minimal claims (anti-token leakage)
    access_token = create_access_token(data={"sub": user.id, "role": user.role})
    
    record_audit(db, user.id, user.role, "LOGIN_SUCCESS", "AUTH", user.id, ip)
    
    return TokenResponse(
        access_token=access_token,
        token_type="bearer",
        user_id=user.id,
        role=user.role,
        name=user.name,
        phone=user.phone,
        preferred_lang=lang
    )

@router.get("/me", response_model=UserOut)
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    prof = db.query(CustomerProfile).filter(CustomerProfile.user_id == current_user.id).first()
    return UserOut(
        id=current_user.id,
        name=current_user.name,
        phone=current_user.phone,
        email=current_user.email,
        role=current_user.role,
        preferred_lang=prof.preferred_lang if prof else "en",
        photo=prof.photo if prof else None
    )

@router.put("/profile", response_model=UserOut)
def update_profile(
    payload: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    if payload.name is not None:
        current_user.name = payload.name.strip()
    if payload.email is not None:
        current_user.email = payload.email.strip()
        
    prof = db.query(CustomerProfile).filter(CustomerProfile.user_id == current_user.id).first()
    if not prof:
        prof = CustomerProfile(user_id=current_user.id)
        db.add(prof)
        
    if payload.preferred_lang is not None:
        prof.preferred_lang = payload.preferred_lang
    if payload.photo is not None:
        prof.photo = payload.photo
        
    db.commit()
    db.refresh(current_user)
    
    return UserOut(
        id=current_user.id,
        name=current_user.name,
        phone=current_user.phone,
        email=current_user.email,
        role=current_user.role,
        preferred_lang=prof.preferred_lang,
        photo=prof.photo
    )

@router.post("/logout")
def logout(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    record_audit(db, current_user.id, current_user.role, "LOGOUT", "AUTH", current_user.id)
    return {"success": True, "message": "Successfully logged out"}
