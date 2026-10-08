from datetime import datetime, timezone
from typing import Optional
from fastapi import Depends, HTTPException, status, Header, Request
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, Job, AuditLog
from backend.app.core.security import decode_access_token
from backend.app.security.rate_limiter import get_client_ip

def record_audit(
    db: Session,
    actor_id: Optional[str],
    actor_role: str,
    action: str,
    resource_type: str,
    resource_id: Optional[str] = None,
    ip_address: Optional[str] = None,
    details: Optional[str] = None
):
    """Centralized immutable audit log for security compliance"""
    try:
        log_entry = AuditLog(
            actor_id=actor_id,
            actor_role=actor_role,
            action=action,
            resource_type=resource_type,
            resource_id=resource_id,
            ip_address=ip_address,
            timestamp=datetime.now(timezone.utc),
            details=details
        )
        db.add(log_entry)
        db.commit()
    except Exception:
        db.rollback()

def get_token_from_header(authorization: Optional[str] = Header(None)) -> Optional[str]:
    if not authorization:
        return None
    parts = authorization.split()
    if len(parts) == 2 and parts[0].lower() == "bearer":
        return parts[1]
    return authorization

def get_current_user(
    request: Request,
    authorization: Optional[str] = Header(None),
    db: Session = Depends(get_db)
) -> User:
    token = get_token_from_header(authorization)
    
    # Check cookie fallback if present
    if not token and "access_token" in request.cookies:
        token = request.cookies.get("access_token")
        
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication token is missing. Please log in.",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token is invalid or expired. Please re-authenticate.",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Malformed token claims.",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User account does not exist or was removed.",
        )
        
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Account is suspended or deactivated. Contact support.",
        )
        
    return user

def get_optional_user(
    request: Request,
    authorization: Optional[str] = Header(None),
    db: Session = Depends(get_db)
) -> Optional[User]:
    try:
        return get_current_user(request, authorization, db)
    except HTTPException:
        return None

def verify_job_access(job_id: str, current_user: User, db: Session) -> Job:
    """Enforce strict Object-Level Authorization (Anti-BOLA/Anti-IDOR)"""
    job = db.query(Job).filter(Job.id == job_id).first()
    if not job:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Job request not found.")
        
    # Super admins or operations admins have platform clearance
    if current_user.role in ["ADMIN", "SUPER_ADMIN", "OPERATIONS_ADMIN"]:
        return job
        
    # Customer ownership check
    if job.customer_id == current_user.id:
        return job
        
    # Worker assignment check
    if job.selected_worker_id:
        worker_user = db.query(User).filter(User.id == current_user.id, User.role == "WORKER").first()
        if worker_user and job.selected_worker_id == worker_user.id:
            return job
            
    # Denied: unauthorized user attempting to access someone else's job
    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail="Access Denied: You do not have permission to view or modify this service request."
    )
