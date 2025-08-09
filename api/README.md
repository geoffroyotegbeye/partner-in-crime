# MotiGoal API - Backend FastAPI avec MongoDB

Ce backend FastAPI fournit les services d'API pour l'application MotiGoal, notamment l'authentification (inscription et connexion) et la gestion des utilisateurs.

## Prérequis

- Python 3.8+
- MongoDB (installé et en cours d'exécution)
- Virtualenv (recommandé)

## Installation

1. Créer un environnement virtuel (recommandé) :
```bash
python -m venv venv
```

2. Activer l'environnement virtuel :
```bash
# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

3. Installer les dépendances :
```bash
pip install -r requirements.txt
```

## Configuration

Les paramètres de configuration se trouvent dans `app/core/config.py`. Vous pouvez les modifier selon vos besoins.

Par défaut, l'API se connecte à MongoDB sur `mongodb://localhost:27017` et utilise la base de données `motigoal`.

## Lancement du serveur

Pour lancer le serveur de développement avec rechargement automatique :

```bash
python run.py
```

Le serveur sera accessible à l'adresse `http://localhost:8000`.

## Documentation API

Une fois le serveur lancé, la documentation interactive de l'API est disponible aux adresses suivantes :
- Swagger UI : `http://localhost:8000/docs`
- ReDoc : `http://localhost:8000/redoc`

## Points d'API disponibles

### Authentification

- `POST /api/auth/register` : Inscription d'un nouvel utilisateur
  - Corps de la requête : `{"email": "user@example.com", "username": "username", "password": "password"}`

- `POST /api/auth/login` : Connexion d'un utilisateur
  - Corps de la requête : `{"username": "user@example.com", "password": "password"}`
  - Retourne un token JWT à utiliser pour les requêtes authentifiées

- `GET /api/auth/me` : Récupération des informations de l'utilisateur connecté
  - Nécessite un token JWT dans l'en-tête `Authorization: Bearer <token>`

### Santé de l'API

- `GET /api/health` : Vérifie que l'API fonctionne correctement

## Intégration avec le frontend Flutter

Pour connecter le frontend Flutter à cette API :

1. Assurez-vous que l'API est accessible depuis le frontend (même réseau ou exposition publique)
2. Utilisez le package `http` ou `dio` dans Flutter pour effectuer des requêtes HTTP
3. Stockez le token JWT reçu lors de la connexion et incluez-le dans les en-têtes des requêtes authentifiées

## Structure du projet

```
api/
├── app/
│   ├── core/            # Configuration et utilitaires
│   ├── db/              # Connexion à la base de données
│   ├── models/          # Modèles Pydantic
│   └── routes/          # Routes API
├── run.py               # Point d'entrée de l'application
└── requirements.txt     # Dépendances Python
```
