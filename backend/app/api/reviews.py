import json
from datetime import datetime, timezone
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, Job, WorkerProfile, Review, Notification
from backend.app.schemas.domain import ReviewCreate, ReviewOut
from backend.app.security.dependencies import get_current_user, verify_job_access, record_audit

router = APIRouter(prefix="/reviews", tags=["Ratings & Verified Reviews"])

@router.post("", response_model=ReviewOut)
def submit_review(
    payload: ReviewCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    job = verify_job_access(payload.job_id, current_user, db)
    
    # Check if job is in reviewable state (PAYMENT, REVIEW or CLOSED)
    if job.status not in ["PAYMENT", "REVIEW", "CLOSED"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Reviews can only be submitted for completed jobs."
        )
        
    if not job.selected_worker_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No worker assigned to this job.")
        
    # Check if review already exists for this job (PRD: 1 review per completed Job ID)
    existing_review = db.query(Review).filter(Review.job_id == job.id).first()
    if existing_review:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="A review has already been submitted for this job.")
        
    review = Review(
        job_id=job.id,
        customer_id=current_user.id,
        customer_name=current_user.name,
        worker_id=job.selected_worker_id,
        overall_rating=payload.overall_rating,
        quality_rating=payload.quality_rating,
        behaviour_rating=payload.behaviour_rating,
        on_time_rating=payload.on_time_rating,
        price_rating=payload.price_rating,
        review_text=payload.review_text.strip(),
        media_urls=json.dumps(payload.media_urls),
        is_verified_job=True, # Authoritative server-side badge
        moderation_status="APPROVED",
        created_at=datetime.now(timezone.utc)
    )
    db.add(review)
    
    # Transition job to CLOSED state
    job.status = "CLOSED"
    job.updated_at = datetime.now(timezone.utc)
    
    # Server-side update of worker reputation metrics
    worker = db.query(WorkerProfile).filter(WorkerProfile.id == job.selected_worker_id).first()
    if worker:
        all_reviews = db.query(Review).filter(Review.worker_id == worker.id, Review.moderation_status == "APPROVED").all()
        ratings_sum = sum(r.overall_rating for r in all_reviews) + payload.overall_rating
        total_count = len(all_reviews) + 1
        worker.rating = round(ratings_sum / total_count, 2)
        worker.total_reviews = total_count
        worker.jobs_completed += 1
        
    # Notification
    notif = Notification(
        user_id=current_user.id,
        title="Review Published",
        message=f"Thank you for rating your service. Your verified review helps the community find trusted professionals.",
        notification_type="JOB",
        action_link=f"/jobs/{job.id}"
    )
    db.add(notif)
    
    db.commit()
    db.refresh(review)
    
    record_audit(db, current_user.id, current_user.role, "REVIEW_SUBMITTED", "REVIEW", review.id)
    
    return ReviewOut(
        id=review.id,
        job_id=review.job_id,
        customer_name=review.customer_name,
        worker_id=review.worker_id,
        overall_rating=review.overall_rating,
        quality_rating=review.quality_rating,
        behaviour_rating=review.behaviour_rating,
        on_time_rating=review.on_time_rating,
        price_rating=review.price_rating,
        review_text=review.review_text,
        media_urls=json.loads(review.media_urls) if review.media_urls else [],
        is_verified_job=review.is_verified_job,
        created_at=review.created_at
    )

@router.get("/worker/{worker_id}", response_model=List[ReviewOut])
def get_worker_reviews(worker_id: str, db: Session = Depends(get_db)):
    reviews = db.query(Review).filter(
        Review.worker_id == worker_id,
        Review.moderation_status == "APPROVED"
    ).order_by(Review.created_at.desc()).all()
    
    return [
        ReviewOut(
            id=r.id,
            job_id=r.job_id,
            customer_name=r.customer_name,
            worker_id=r.worker_id,
            overall_rating=r.overall_rating,
            quality_rating=r.quality_rating,
            behaviour_rating=r.behaviour_rating,
            on_time_rating=r.on_time_rating,
            price_rating=r.price_rating,
            review_text=r.review_text,
            media_urls=json.loads(r.media_urls) if r.media_urls else [],
            is_verified_job=r.is_verified_job,
            created_at=r.created_at
        )
        for r in reviews
    ]
