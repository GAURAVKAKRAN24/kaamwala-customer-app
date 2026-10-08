import json
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import WorkerProfile, Review
from backend.app.schemas.domain import WorkerOut

router = APIRouter(prefix="/workers", tags=["Worker Discovery & Profiles"])

def map_worker_to_schema(w: WorkerProfile) -> WorkerOut:
    skills_list = [s.strip() for s in w.skills.split(",") if s.strip()] if w.skills else []
    try:
        before_after = json.loads(w.before_after_photos) if w.before_after_photos else []
    except Exception:
        before_after = []
        
    return WorkerOut(
        id=w.id,
        name=w.name,
        category=w.category,
        skills=skills_list,
        bio=w.bio or "",
        experience_years=w.experience_years,
        rating=w.rating,
        total_reviews=w.total_reviews,
        jobs_completed=w.jobs_completed,
        on_time_rate=w.on_time_rate,
        completion_rate=w.completion_rate,
        response_time_mins=w.response_time_mins,
        visit_fee=w.visit_fee,
        identity_verified=w.identity_verified,
        skill_verified=w.skill_verified,
        top_rated=w.top_rated,
        fast_responder=w.fast_responder,
        photo_url=w.photo_url,
        service_areas=w.service_areas,
        before_after_photos=before_after
    )

@router.get("", response_model=List[WorkerOut])
def get_workers(
    category: Optional[str] = None,
    min_rating: Optional[float] = Query(None, ge=1.0, le=5.0),
    max_visit_fee: Optional[float] = None,
    verified_only: Optional[bool] = False,
    query: Optional[str] = None,
    db: Session = Depends(get_db)
):
    q = db.query(WorkerProfile)
    
    if category:
        q = q.filter(WorkerProfile.category.ilike(f"%{category}%"))
    if min_rating:
        q = q.filter(WorkerProfile.rating >= min_rating)
    if max_visit_fee:
        q = q.filter(WorkerProfile.visit_fee <= max_visit_fee)
    if verified_only:
        q = q.filter(WorkerProfile.identity_verified == True, WorkerProfile.skill_verified == True)
    if query:
        q = q.filter(
            WorkerProfile.name.ilike(f"%{query}%") |
            WorkerProfile.skills.ilike(f"%{query}%") |
            WorkerProfile.bio.ilike(f"%{query}%")
        )
        
    workers = q.all()
    
    # PRD Requirement: Multi-factor ranking (not purely by star rating)
    # Score = (rating * 20) + (jobs_completed * 0.1) + (completion_rate * 0.3) + (10 if verified else 0) - (response_time_mins * 0.2)
    def compute_rank_score(w: WorkerProfile) -> float:
        score = (w.rating * 20.0) + (min(w.jobs_completed, 500) * 0.08) + (w.completion_rate * 0.25)
        if w.identity_verified and w.skill_verified:
            score += 15.0
        if w.fast_responder:
            score += 8.0
        score -= (w.response_time_mins * 0.15)
        return score
        
    sorted_workers = sorted(workers, key=compute_rank_score, reverse=True)
    return [map_worker_to_schema(w) for w in sorted_workers]

@router.get("/{worker_id}", response_model=WorkerOut)
def get_worker_detail(worker_id: str, db: Session = Depends(get_db)):
    worker = db.query(WorkerProfile).filter(WorkerProfile.id == worker_id).first()
    if not worker:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Worker profile not found")
    return map_worker_to_schema(worker)
