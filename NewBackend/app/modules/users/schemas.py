from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict
from typing import Optional

class SubscriptionTierBase(BaseModel):
    name: str
    price: float
    description: Optional[str] = None
    upload_frequency_minutes: int
    environment_limit: int

class SubscriptionTierCreate(SubscriptionTierBase):
    pass

class SubscriptionTierResponse(SubscriptionTierBase):
    id: int

    model_config = ConfigDict(from_attributes=True) 

class UserBase(BaseModel):
    email: EmailStr
    first_name: Optional[str] = None
    last_name: Optional[str] = None

class UserCreate(UserBase):
    email: EmailStr 
    first_name: str 
    last_name: str  
    password: str  

class UserResponse(UserBase):
    id: int
    date_joined: datetime
    api_key: str

    model_config = ConfigDict(from_attributes=True)  

class UserUpdate(BaseModel):
    """
    Schema for updating user profile fields.
    Partial updates are allowed.
    """
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
