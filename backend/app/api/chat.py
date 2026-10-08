from datetime import datetime, timezone
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status, Request
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, Job, Message
from backend.app.schemas.domain import MessageCreate, MessageOut
from backend.app.security.dependencies import get_current_user, verify_job_access, record_audit
from backend.app.security.rate_limiter import rate_limiter, get_client_ip

router = APIRouter(prefix="/chat", tags=["In-App Chat"])

@router.get("/{job_id}", response_model=List[MessageOut])
def get_messages(job_id: str, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    job = verify_job_access(job_id, current_user, db)
    msgs = db.query(Message).filter(Message.job_id == job.id).order_by(Message.created_at.asc()).all()
    
    return [
        MessageOut(
            id=m.id,
            job_id=m.job_id,
            sender_id=m.sender_id,
            sender_role=m.sender_role,
            sender_name=m.sender_name,
            message_type=m.message_type,
            content=m.content,
            media_url=m.media_url,
            created_at=m.created_at
        )
        for m in msgs
    ]

@router.post("/{job_id}", response_model=MessageOut)
def send_message(
    job_id: str,
    payload: MessageCreate,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    ip = get_client_ip(request)
    # Rate limit chat messages to prevent flooding/spam
    rate_limiter.check_rate_limit(f"chat_msg_{current_user.id}", max_requests=30, window_seconds=60)
    
    job = verify_job_access(job_id, current_user, db)
    
    msg = Message(
        job_id=job.id,
        sender_id=current_user.id,
        sender_role=current_user.role,
        sender_name=current_user.name,
        message_type=payload.message_type,
        content=payload.content.strip(),
        media_url=payload.media_url,
        created_at=datetime.now(timezone.utc)
    )
    db.add(msg)
    db.commit()
    db.refresh(msg)
    
    return MessageOut(
        id=msg.id,
        job_id=msg.job_id,
        sender_id=msg.sender_id,
        sender_role=msg.sender_role,
        sender_name=msg.sender_name,
        message_type=msg.message_type,
        content=msg.content,
        media_url=msg.media_url,
        created_at=msg.created_at
    )
