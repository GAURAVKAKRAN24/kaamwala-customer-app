from datetime import datetime, timezone
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, Job, WorkerProfile, Quote, Message, Notification
from backend.app.schemas.domain import QuoteOut, QuoteSelect
from backend.app.security.dependencies import get_current_user, verify_job_access, record_audit

router = APIRouter(prefix="/quotes", tags=["Quotations & Estimates"])

def map_quote(q: Quote, db: Session) -> QuoteOut:
    worker = db.query(WorkerProfile).filter(WorkerProfile.id == q.worker_id).first()
    return QuoteOut(
        id=q.id,
        job_id=q.job_id,
        worker_id=q.worker_id,
        worker_name=worker.name if worker else "Professional",
        worker_rating=worker.rating if worker else 4.8,
        worker_jobs=worker.jobs_completed if worker else 50,
        worker_photo=worker.photo_url if worker else None,
        visit_fee=q.visit_fee,
        estimate_min=q.estimate_min,
        estimate_max=q.estimate_max,
        parts_extra=q.parts_extra,
        message=q.message,
        estimated_arrival=q.estimated_arrival,
        status=q.status,
        created_at=q.created_at
    )

@router.get("/{job_id}", response_model=List[QuoteOut])
def get_quotes_for_job(job_id: str, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    job = verify_job_access(job_id, current_user, db)
    quotes = db.query(Quote).filter(Quote.job_id == job.id).order_by(Quote.created_at.desc()).all()
    return [map_quote(q, db) for q in quotes]

@router.post("/{quote_id}/select")
def select_quote(quote_id: str, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Quote not found.")
        
    job = verify_job_access(quote.job_id, current_user, db)
    worker = db.query(WorkerProfile).filter(WorkerProfile.id == quote.worker_id).first()
    
    # Update selected quote
    quote.status = "ACCEPTED"
    
    # Auto-expire/close all other quotes for this job (PRD requirement Section 9)
    other_quotes = db.query(Quote).filter(Quote.job_id == job.id, Quote.id != quote.id).all()
    for oq in other_quotes:
        oq.status = "EXPIRED"
        
    # Update Job
    job.selected_worker_id = quote.worker_id
    job.visit_fee = quote.visit_fee
    job.estimated_amount = quote.estimate_max
    job.status = "WORKER_SELECTED"
    job.updated_at = datetime.now(timezone.utc)
    
    # System message into chat
    sys_msg = Message(
        job_id=job.id,
        sender_id="system",
        sender_role="SYSTEM",
        sender_name="KaamWala System",
        message_type="system",
        content=f"You selected {worker.name if worker else 'the technician'}. Inspection fee: ₹{quote.visit_fee:.0f}. Estimated repair range: ₹{quote.estimate_min:.0f} - ₹{quote.estimate_max:.0f} (Parts extra as applicable)."
    )
    db.add(sys_msg)
    
    # Notification
    notif = Notification(
        user_id=current_user.id,
        title="Technician Selected!",
        message=f"{worker.name if worker else 'Technician'} has been notified of your selection for Job #{job.id}.",
        notification_type="JOB",
        action_link=f"/jobs/{job.id}"
    )
    db.add(notif)
    
    db.commit()
    record_audit(db, current_user.id, current_user.role, "QUOTE_SELECTED", "QUOTE", quote.id)
    
    return {
        "success": True,
        "message": f"Quote selected. {worker.name if worker else 'Worker'} assigned.",
        "job_status": job.status,
        "selected_worker_id": job.selected_worker_id
    }
