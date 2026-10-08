import hmac
import hashlib
import secrets
from datetime import datetime, timedelta, timezone
from typing import Optional, Dict, Any
import jwt
from backend.app.core.config import settings

def generate_secure_otp(length: int = 6) -> str:
    """Generate cryptographically secure numeric OTP"""
    return "".join(secrets.choice("0123456789") for _ in range(length))

def hash_secret(secret_str: str) -> str:
    """Hash secret/OTP using SHA-256 with salt"""
    salt = settings.SECRET_KEY[:16]
    return hashlib.sha256(f"{salt}:{secret_str}".encode()).hexdigest()

def verify_secret(secret_str: str, hashed_str: str) -> bool:
    """Constant-time comparison of hashed secret to prevent timing attacks"""
    calculated = hash_secret(secret_str)
    return hmac.compare_digest(calculated, hashed_str)

def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire, "iat": datetime.now(timezone.utc)})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def decode_access_token(token: str) -> Optional[Dict[str, Any]]:
    try:
        decoded_payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return decoded_payload
    except jwt.PyJWTError:
        return None
