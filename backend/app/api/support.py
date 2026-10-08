from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, SupportTicket, Notification
from backend.app.schemas.domain import SupportTicketCreate, SupportTicketOut, NotificationOut
from backend.app.security.dependencies import get_current_user, record_audit

router = APIRouter(tags=["Support & Notifications"])

# NOTIFICATIONS
@router.get("/notifications", response_model=List[NotificationOut])
def get_notifications(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    notifs = db.query(Notification).filter(Notification.user_id == current_user.id).order_by(Notification.created_at.desc()).all()
    return [
        NotificationOut(
            id=n.id,
            user_id=n.user_id,
            title=n.title,
            message=n.message,
            notification_type=n.notification_type,
            action_link=n.action_link,
            is_read=n.is_read,
            created_at=n.created_at
        )
        for n in notifs
    ]

@router.post("/notifications/{notif_id}/read")
def mark_notification_read(notif_id: str, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    n = db.query(Notification).filter(Notification.id == notif_id, Notification.user_id == current_user.id).first()
    if n:
        n.is_read = True
        db.commit()
    return {"success": True}

# SUPPORT TICKETS
@router.post("/support/tickets", response_model=SupportTicketOut)
def create_support_ticket(
    payload: SupportTicketCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    ticket = SupportTicket(
        user_id=current_user.id,
        job_id=payload.job_id,
        category=payload.category,
        subject=payload.subject,
        description=payload.description,
        priority=payload.priority,
        status="OPEN"
    )
    db.add(ticket)
    db.commit()
    db.refresh(ticket)
    
    record_audit(db, current_user.id, current_user.role, "TICKET_CREATED", "SUPPORT", ticket.id)
    
    return SupportTicketOut(
        id=ticket.id,
        user_id=ticket.user_id,
        job_id=ticket.job_id,
        category=ticket.category,
        subject=ticket.subject,
        description=ticket.description,
        priority=ticket.priority,
        status=ticket.status,
        created_at=ticket.created_at
    )

@router.get("/support/tickets", response_model=List[SupportTicketOut])
def list_support_tickets(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    tickets = db.query(SupportTicket).filter(SupportTicket.user_id == current_user.id).order_by(SupportTicket.created_at.desc()).all()
    return [
        SupportTicketOut(
            id=t.id,
            user_id=t.user_id,
            job_id=t.job_id,
            category=t.category,
            subject=t.subject,
            description=t.description,
            priority=t.priority,
            status=t.status,
            created_at=t.created_at
        )
        for t in tickets
    ]
