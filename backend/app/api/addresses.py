from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User, Address
from backend.app.schemas.domain import AddressCreate, AddressOut
from backend.app.security.dependencies import get_current_user

router = APIRouter(prefix="/addresses", tags=["Customer Addresses"])

@router.get("", response_model=List[AddressOut])
def list_addresses(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    addresses = db.query(Address).filter(Address.customer_id == current_user.id).all()
    return [
        AddressOut(
            id=a.id,
            customer_id=a.customer_id,
            label=a.label,
            address_line=a.address_line,
            landmark=a.landmark,
            city=a.city,
            postal_code=a.postal_code,
            lat=a.lat,
            lng=a.lng,
            is_default=a.is_default
        )
        for a in addresses
    ]

@router.post("", response_model=AddressOut)
def create_address(payload: AddressCreate, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    if payload.is_default:
        # unset other defaults
        db.query(Address).filter(Address.customer_id == current_user.id).update({"is_default": False})
        
    addr = Address(
        customer_id=current_user.id,
        label=payload.label,
        address_line=payload.address_line,
        landmark=payload.landmark,
        city=payload.city,
        postal_code=payload.postal_code,
        lat=payload.lat or 28.6139,
        lng=payload.lng or 77.2090,
        is_default=payload.is_default
    )
    db.add(addr)
    db.commit()
    db.refresh(addr)
    
    return AddressOut(
        id=addr.id,
        customer_id=addr.customer_id,
        label=addr.label,
        address_line=addr.address_line,
        landmark=addr.landmark,
        city=addr.city,
        postal_code=addr.postal_code,
        lat=addr.lat,
        lng=addr.lng,
        is_default=addr.is_default
    )

@router.delete("/{address_id}")
def delete_address(address_id: str, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    addr = db.query(Address).filter(Address.id == address_id, Address.customer_id == current_user.id).first()
    if not addr:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Address not found.")
    db.delete(addr)
    db.commit()
    return {"success": True, "message": "Address deleted"}
