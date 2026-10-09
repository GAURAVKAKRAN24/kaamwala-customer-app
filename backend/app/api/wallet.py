from datetime import datetime, timezone
from typing import List, Optional
from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from backend.app.database.session import get_db
from backend.app.database.models import User
from backend.app.security.dependencies import get_current_user

router = APIRouter(prefix="/wallet", tags=["Wallet & Referral"])

class AddMoneyRequest(BaseModel):
    amount: float
    payment_method: str = "UPI"

class ReferralRedeemRequest(BaseModel):
    code: str

@router.get("/balance")
def get_wallet_balance(current_user: User = Depends(get_current_user)):
    return {
        "user_id": current_user.id,
        "balance": 250.0,
        "currency": "INR",
        "recent_cashback": 50.0,
        "active_promos": ["FIRST100", "KWSAFETY"]
    }

@router.get("/transactions")
def get_wallet_transactions(current_user: User = Depends(get_current_user)):
    return [
        {
            "id": "tx_901",
            "type": "CREDIT",
            "amount": 100.0,
            "title": "Referral Bonus (Friend joined)",
            "date": "08 Oct 2026, 04:30 PM",
            "status": "SUCCESS"
        },
        {
            "id": "tx_902",
            "type": "DEBIT",
            "amount": 49.0,
            "title": "Platform Fee Discount Applied (KW-28491)",
            "date": "09 Oct 2026, 10:15 AM",
            "status": "SUCCESS"
        },
        {
            "id": "tx_903",
            "type": "CREDIT",
            "amount": 199.0,
            "title": "Wallet Topup via UPI",
            "date": "05 Oct 2026, 02:00 PM",
            "status": "SUCCESS"
        }
    ]

@router.post("/add-money")
def add_money(req: AddMoneyRequest, current_user: User = Depends(get_current_user)):
    if req.amount <= 0:
        raise HTTPException(status_code=400, detail="Amount must be greater than zero")
    return {
        "status": "SUCCESS",
        "added_amount": req.amount,
        "new_balance": 250.0 + req.amount,
        "message": f"Successfully credited ₹{req.amount} via {req.payment_method}"
    }

@router.get("/referral")
def get_referral_info(current_user: User = Depends(get_current_user)):
    user_name_prefix = current_user.name.split()[0].upper() if current_user.name else "KAAMWALA"
    referral_code = f"{user_name_prefix}100"
    return {
        "referral_code": referral_code,
        "reward_per_referral": 100.0,
        "friend_discount": 100.0,
        "total_referrals": 3,
        "total_earned": 300.0,
        "share_message": f"Hey! Book verified doorstep home repairs with KaamWala. Use my code {referral_code} to get flat ₹100 off on your first service: https://kaamwala.in/invite/{referral_code}"
    }

@router.post("/referral/redeem")
def redeem_referral(req: ReferralRedeemRequest, current_user: User = Depends(get_current_user)):
    code = req.code.strip().upper()
    if not code:
        raise HTTPException(status_code=400, detail="Invalid referral code")
    return {
        "status": "APPLIED",
        "discount_amount": 100.0,
        "message": f"Referral code {code} successfully applied! ₹100 discount added to your wallet."
    }
