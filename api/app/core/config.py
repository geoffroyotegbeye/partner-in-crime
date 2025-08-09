from pydantic import Field
from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    # Configuration de base
    API_V1_STR: str = Field(default="/api")
    PROJECT_NAME: str = Field(default="MotiGoal API")
    
    # Configuration MongoDB
    MONGO_URI: str = Field(default="mongodb://localhost:27017")
    MONGO_DB: str = Field(default="motigoal")
    
    # Configuration CORS
    CORS_ORIGINS: List[str] = Field(default=["http://localhost:8080", "http://localhost:3000"])
    
    # Configuration JWT
    SECRET_KEY: str = Field(default="votre_clé_secrète_à_changer_en_production")
    ALGORITHM: str = Field(default="HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(default=30)
    
    class Config:
        case_sensitive = True


settings = Settings()
