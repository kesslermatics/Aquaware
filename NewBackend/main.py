from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.modules.users.routes import router as users_router

app = FastAPI()

# Cors Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if settings.CORS_ALLOW_ALL_ORIGINS else settings.ALLOWED_HOSTS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=settings.CORS_ALLOW_HEADERS,
)

app.include_router(users_router, tags=["users"])

@app.get("/")
async def root():
    return {"message": "Welcome to Aquaware API!"}