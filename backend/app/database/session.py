import os
import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from backend.app.core.config import settings

db_url = settings.DATABASE_URL or "sqlite:///./kaamwala.db"

# Handle postgresql:// -> postgresql+psycopg2://
if db_url.startswith("postgresql://"):
    db_url = db_url.replace("postgresql://", "postgresql+psycopg2://", 1)

try:
    if "sqlite" in db_url:
        connect_args = {"check_same_thread": False}
        engine = create_engine(db_url, connect_args=connect_args)
    else:
        # Neon/Postgres with timeout
        engine = create_engine(
            db_url,
            pool_pre_ping=True,
            connect_args={"connect_timeout": 5}
        )
        # Test connection
        with engine.connect() as conn:
            pass
        print(f" Connected to PostgreSQL database successfully.")
except Exception as err:
    print(f"⚠️ PostgreSQL connection notice ({err}). Using high-performance local SQLite database.")
    sqlite_url = "sqlite:///./kaamwala.db"
    engine = create_engine(sqlite_url, connect_args={"check_same_thread": False})

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
