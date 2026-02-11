from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import uvicorn
from dotenv import load_dotenv

from api import auth, citizens, eligibility, schemes, analytics, audit, policies
from database import init_db

load_dotenv()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await init_db()
    yield
    # Shutdown
    pass

app = FastAPI(
    title="JanSaarthi AI API",
    description="Government Digital Infrastructure API",
    version="1.0.0",
    lifespan=lifespan,
    openapi_tags=[
        {"name": "auth", "description": "Authentication endpoints"},
        {"name": "citizens", "description": "Citizen profile management"},
        {"name": "eligibility", "description": "Eligibility assessment"},
        {"name": "schemes", "description": "Scheme recommendations"},
        {"name": "analytics", "description": "Admin analytics (TODO)"},
        {"name": "audit", "description": "Audit logs (TODO)"},
        {"name": "policies", "description": "Policy management (TODO)"},
    ]
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # TODO: Restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/v1", tags=["auth"])
app.include_router(citizens.router, prefix="/api/v1", tags=["citizens"])
app.include_router(eligibility.router, prefix="/api/v1", tags=["eligibility"])
app.include_router(schemes.router, prefix="/api/v1", tags=["schemes"])

# TODO: Implement these endpoints
# app.include_router(analytics.router, prefix="/api/v1", tags=["analytics"])
# app.include_router(audit.router, prefix="/api/v1", tags=["audit"])
# app.include_router(policies.router, prefix="/api/v1", tags=["policies"])

@app.get("/")
async def root():
    return {"message": "JanSaarthi AI API", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)