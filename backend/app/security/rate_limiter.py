import time
from collections import defaultdict
from fastapi import HTTPException, status, Request

class InMemoryRateLimiter:
    def __init__(self):
        # key -> list of timestamps
        self.requests = defaultdict(list)
        # key -> lockout until timestamp
        self.lockouts = defaultdict(float)

    def check_rate_limit(self, key: str, max_requests: int = 10, window_seconds: int = 60, lockout_seconds: int = 120):
        now = time.time()
        
        # Check if in cooldown/lockout
        if self.lockouts[key] > now:
            remaining = int(self.lockouts[key] - now)
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"Too many attempts. Cooldown active. Please retry in {remaining} seconds."
            )
            
        # Clean older requests outside window
        window_start = now - window_seconds
        self.requests[key] = [t for t in self.requests[key] if t > window_start]
        
        if len(self.requests[key]) >= max_requests:
            self.lockouts[key] = now + lockout_seconds
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail=f"Rate limit exceeded. Temporary cooldown applied for {lockout_seconds} seconds."
            )
            
        self.requests[key].append(now)

rate_limiter = InMemoryRateLimiter()

def get_client_ip(request: Request) -> str:
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        return forwarded.split(",")[0].strip()
    return request.client.host if request.client else "127.0.0.1"
