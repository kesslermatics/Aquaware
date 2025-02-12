from fastapi import Depends, HTTPException, Security
from fastapi.security import APIKeyHeader
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.modules.users.models import User

# Define the API key header
api_key_header = APIKeyHeader(name="X-API-KEY", auto_error=False)

def get_current_user(api_key: str = Security(api_key_header), db: Session = Depends(get_db)):
    """
    Validates the API key and returns the associated user.
    Raises an HTTP 401 error if the key is invalid.
    """
    if not api_key:
        raise HTTPException(status_code=401, detail="Missing API key")

    user = db.query(User).filter(User.api_key == api_key).first()

    if not user:
        raise HTTPException(status_code=401, detail="Invalid or inactive API key")

    return user
