from motor.motor_asyncio import AsyncIOMotorClient
from ..core.config import settings

class MongoDB:
    client: AsyncIOMotorClient = None
    db = None

# Création d'une instance de MongoDB
mongodb = MongoDB()

async def connect_to_mongo():
    """Connexion à la base de données MongoDB."""
    mongodb.client = AsyncIOMotorClient(settings.MONGO_URI)
    mongodb.db = mongodb.client[settings.MONGO_DB]
    print(f"Connecté à MongoDB: {settings.MONGO_DB}")

async def close_mongo_connection():
    """Fermeture de la connexion à MongoDB."""
    if mongodb.client:
        mongodb.client.close()
        print("Connexion à MongoDB fermée")
