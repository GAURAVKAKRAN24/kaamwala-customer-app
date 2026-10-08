import time
import os
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.responses import JSONResponse, FileResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from backend.app.core.config import settings
from backend.app.database.session import engine, Base
from backend.app.database.seed_data import seed_database

# Routers
from backend.app.api.auth import router as auth_router
from backend.app.api.services import router as services_router
from backend.app.api.workers import router as workers_router
from backend.app.api.jobs import router as jobs_router
from backend.app.api.quotes import router as quotes_router
from backend.app.api.chat import router as chat_router
from backend.app.api.payments import router as payments_router
from backend.app.api.reviews import router as reviews_router
from backend.app.api.addresses import router as addresses_router
from backend.app.api.support import router as support_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Ensure database tables exist & seed demo data
    Base.metadata.create_all(bind=engine)
    seed_database()
    yield
    # Shutdown

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="KaamWala - Trusted Local-Services Marketplace Backend API (Customer & Worker App)",
    lifespan=lifespan
)

# 1. Security Headers Middleware (OWASP / Spec Section 8)
@app.middleware("http")
async def security_headers_middleware(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    
    # Enforce secure HTTP headers
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    response.headers["X-Process-Time"] = f"{time.time() - start_time:.4f}s"
    
    return response

# 2. CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 3. Mount API Routers under /api/v1
api_v1_prefix = settings.API_V1_STR
app.include_router(auth_router, prefix=api_v1_prefix)
app.include_router(services_router, prefix=api_v1_prefix)
app.include_router(workers_router, prefix=api_v1_prefix)
app.include_router(jobs_router, prefix=api_v1_prefix)
app.include_router(quotes_router, prefix=api_v1_prefix)
app.include_router(chat_router, prefix=api_v1_prefix)
app.include_router(payments_router, prefix=api_v1_prefix)
app.include_router(reviews_router, prefix=api_v1_prefix)
app.include_router(addresses_router, prefix=api_v1_prefix)
app.include_router(support_router, prefix=api_v1_prefix)

# 4. Global Exception Handler (Generic errors, no sensitive stack trace leakage)
@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    # Log securely to server console without exposing sensitive data to client
    print(f"[SECURITY/ERROR] Unhandled Exception at {request.url.path}: {str(exc)}")
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": "An internal processing error occurred. The incident has been recorded."}
    )

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "KaamWala Backend API", "version": settings.VERSION}

# Mount Frontend static files if directory exists
frontend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "frontend"))
if os.path.exists(frontend_dir):
    app.mount("/static", StaticFiles(directory=frontend_dir), name="static")

    @app.get("/")
    def serve_index():
        index_file = os.path.join(frontend_dir, "index.html")
        if os.path.exists(index_file):
            return FileResponse(index_file)
        return {"message": "KaamWala Backend Running. Open /docs for Swagger API Documentation."}
