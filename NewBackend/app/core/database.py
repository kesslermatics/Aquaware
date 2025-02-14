from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.core.config import settings

# Create a database engine
engine = create_engine(
    settings.DATABASE_URL,  # Database URL from environment or .env file
    connect_args={"check_same_thread": False} if "sqlite" in settings.DATABASE_URL else {},  # Required for SQLite
)

# Create a session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Define the base class for SQLAlchemy models
Base = declarative_base()

def get_db():
    """
    Dependency function for retrieving a database session.
    Ensures that each request gets its own session.
    """
    db = SessionLocal()
    try:
        yield db  # Provide the session to the request
    finally:
        db.close()  # Ensure session is closed after use
