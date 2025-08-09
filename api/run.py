from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

from app.routes import auth_router
from app.core.config import settings
from app.db.mongodb import connect_to_mongo, close_mongo_connection

app = FastAPI(
    title="MotiGoal API",
    description="API backend pour l'application MotiGoal",
    version="0.1.0"
)

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclusion des routers
app.include_router(auth_router.router, prefix="/api/auth", tags=["Authentication"])

# Route de test pour vérifier que l'API fonctionne
@app.get("/api/health", tags=["Health"])
async def health_check():
    return {"status": "ok", "message": "MotiGoal API is running"}

# Événements de démarrage et d'arrêt
@app.on_event("startup")
async def startup_db_client():
    await connect_to_mongo()

@app.on_event("shutdown")
async def shutdown_db_client():
    await close_mongo_connection()

if __name__ == "__main__":
    uvicorn.run("run:app", host="0.0.0.0", port=8000, reload=True)
