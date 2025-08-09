from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import timedelta
from jose import JWTError, jwt
from typing import Any

from ..core.config import settings
from ..core.security import create_access_token, get_password_hash, verify_password
from ..db.mongodb import mongodb
from ..models.user import UserCreate, User, Token, TokenData

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.API_V1_STR}/auth/login")


async def get_user_by_email(email: str) -> dict:
    """
    Récupère un utilisateur par son email
    """
    if mongodb.db is None:
        raise HTTPException(status_code=500, detail="Base de données non connectée")
    
    user = await mongodb.db.users.find_one({"email": email})
    return user


async def authenticate_user(email: str, password: str) -> dict:
    """
    Authentifie un utilisateur
    """
    user = await get_user_by_email(email)
    if not user:
        return False
    if not verify_password(password, user["hashed_password"]):
        return False
    return user


async def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    """
    Récupère l'utilisateur actuel à partir du token JWT
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Identifiants invalides",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except JWTError:
        raise credentials_exception
    
    user = await get_user_by_email(email=token_data.email)
    if user is None:
        raise credentials_exception
    return user


@router.post("/register", response_model=User, status_code=status.HTTP_201_CREATED)
async def register(user_in: UserCreate) -> Any:
    """
    Inscription d'un nouvel utilisateur
    """
    # Vérifier si l'email existe déjà
    user = await get_user_by_email(user_in.email)
    if user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cet email est déjà utilisé",
        )
    
    # Créer l'utilisateur
    hashed_password = get_password_hash(user_in.password)
    user_data = {
        "email": user_in.email,
        "username": user_in.username,
        "hashed_password": hashed_password,
        "is_active": True,
        "is_admin": False,
        "moti_coins": 100,  # Donner des coins de départ
        "profile_completed": False
    }
    
    # Insérer dans la base de données
    result = await mongodb.db.users.insert_one(user_data)
    
    # Récupérer l'utilisateur créé
    created_user = await mongodb.db.users.find_one({"_id": result.inserted_id})
    
    # Convertir l'ObjectId en string pour la réponse
    created_user["_id"] = str(created_user["_id"])
    
    return created_user


@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()) -> Any:
    """
    Connexion d'un utilisateur et génération du token JWT
    """
    user = await authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Mettre à jour la date de dernière connexion
    await mongodb.db.users.update_one(
        {"_id": user["_id"]},
        {"$set": {"last_login": timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)}}
    )
    
    # Créer le token d'accès
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        subject=user["email"], expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}


@router.get("/me", response_model=User)
async def read_users_me(current_user: dict = Depends(get_current_user)) -> Any:
    """
    Récupère les informations de l'utilisateur connecté
    """
    # Convertir l'ObjectId en string pour la réponse
    current_user["_id"] = str(current_user["_id"])
    return current_user
