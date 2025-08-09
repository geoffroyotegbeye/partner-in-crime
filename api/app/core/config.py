from pydantic import BaseSettings
from typing import List


class Settings(BaseSettings):
    # Configuration de base
    API_V1_STR: str = "/api"
    PROJECT_NAME: str = "MotiGoal API"
    
    # Configuration MongoDB
    MONGO_URI: str = "mongodb://localhost:27017"
    MONGO_DB: str = "motigoal"
    
    # Configuration CORS
    CORS_ORIGINS: List[str] = ["http://localhost:8080", "http://localhost:3000"]
    
    # Configuration JWT
    SECRET_KEY: str = "votre_clé_secrète_à_changer_en_production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    class Config:
        case_sensitive = True


settings = Settings()
