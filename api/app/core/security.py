from datetime import datetime, timedelta
from typing import Any, Union, Optional

from jose import jwt
from passlib.context import CryptContext
from ..core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def create_access_token(subject: Union[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    """
    Crée un token JWT pour l'authentification
    
    Args:
        subject: Sujet du token (généralement l'email ou l'ID utilisateur)
        expires_delta: Durée de validité du token
        
    Returns:
        str: Token JWT encodé
    """
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode = {"exp": expire, "sub": str(subject)}
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Vérifie si le mot de passe en clair correspond au hash
    
    Args:
        plain_password: Mot de passe en clair
        hashed_password: Hash du mot de passe stocké
        
    Returns:
        bool: True si le mot de passe correspond, False sinon
    """
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """
    Génère un hash pour un mot de passe
    
    Args:
        password: Mot de passe en clair
        
    Returns:
        str: Hash du mot de passe
    """
    return pwd_context.hash(password)
