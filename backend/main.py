from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import assessments, programs
from routers import interview
from routers import readiness

app = FastAPI(title="LMS Mentorship Platform API")

import os

ALLOWED_ORIGINS = [
    "http://localhost:5178",
    "http://localhost:5179",
    "http://localhost:5180",
    "http://localhost:5181",
    "http://localhost:5173",
    "http://localhost:5198",
    "http://127.0.0.1:5178",
    "http://127.0.0.1:5179",
    "http://127.0.0.1:5180",
    "http://127.0.0.1:5181",
    "http://127.0.0.1:5173",
    "http://127.0.0.1:5198",
]

# Add production frontend URL from env var (set on Railway)
FRONTEND_URL = os.getenv("FRONTEND_URL")
if FRONTEND_URL:
    ALLOWED_ORIGINS.append(FRONTEND_URL)

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_origin_regex=r"https://.*\.vercel\.app",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Generic Health Route
@app.get("/health")
def health_check():
    return {"status": "ok", "message": "FastAPI backend is running modularly"}

# Attach routers
app.include_router(assessments.router)
app.include_router(programs.router)
app.include_router(interview.router)
app.include_router(readiness.router)
