import os
import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from backend.app.core.config import settings

# Force SQLite for instant, zero-latency local/mobile performance, or PostgreSQL if configured explicitly
use_sqlite = os.getenv("USE_SQLITE", "true").lower() == "true"
sqlite_url = "sqlite:///./kaamwala.db"

if use_sqlite:
    engine = create_engine(sqlite_url, connect_args={"check_same_thread": False})
else:
    db_url = settings.DATABASE_URL
    if db_url and db_url.startswith("postgresql://"):
        db_url = db_url.replace("postgresql://", "postgresql+psycopg2://", 1)
    try:
        engine = create_engine(db_url, pool_pre_ping=True, connect_args={"connect_timeout": 3})
        with engine.connect() as conn:
            pass
        print("[INFO] Connected to PostgreSQL database successfully.")
    except Exception as err:
        print("[NOTICE] Using high-performance local SQLite database.")
        engine = create_engine(sqlite_url, connect_args={"check_same_thread": False})

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
