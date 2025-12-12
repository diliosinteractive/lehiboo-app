# Spécifications Backend - Vérification Email OTP

## Objectif
Implémenter une vérification par code OTP (6 chiffres) pour :
1. **Inscription** : Valider l'email avant de finaliser la création du compte
2. **Connexion (2FA)** : Ajouter une couche de sécurité supplémentaire

---

## Flow d'inscription avec OTP

```mermaid
sequenceDiagram
    participant App as App Mobile
    participant API as API Backend
    participant Mail as Service Email
    
    App->>API: POST /auth/register
    API->>API: Créer compte (non vérifié)
    API->>Mail: Envoyer OTP par email
    API-->>App: { pending_verification: true, user_id }
    
    App->>API: POST /auth/verify-otp
    API->>API: Vérifier OTP
    API->>API: Activer compte
    API-->>App: { success: true, tokens, user }
```

---

## Flow de connexion avec OTP (2FA)

```mermaid
sequenceDiagram
    participant App as App Mobile
    participant API as API Backend
    participant Mail as Service Email
    
    App->>API: POST /auth/login
    API->>API: Valider email/password
    API->>Mail: Envoyer OTP par email
    API-->>App: { requires_otp: true, user_id }
    
    App->>API: POST /auth/verify-login-otp
    API->>API: Vérifier OTP
    API-->>App: { success: true, tokens, user }
```

---

## Endpoints - Inscription

### 1. Modifier `POST /auth/register`

**Request (inchangée):**
```json
{
  "email": "user@example.com",
  "password": "MonMotDePasse123",
  "first_name": "Jean",
  "last_name": "Dupont",
  "phone": "0612345678"
}
```

**Response (modifiée):**
```json
{
  "success": true,
  "data": {
    "pending_verification": true,
    "user_id": "123",
    "email": "user@example.com",
    "message": "Un code de vérification a été envoyé à votre adresse email"
  }
}
```

> ⚠️ **Important**: Le compte est créé mais **inactif**. Les tokens ne sont PAS retournés à cette étape.

---

### 2. `POST /auth/verify-otp` (pour inscription)

**Request:**
```json
{
  "user_id": "123",
  "email": "user@example.com",
  "otp": "123456",
  "type": "register"
}
```

**Response (succès):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "123",
      "email": "user@example.com",
      "first_name": "Jean",
      "last_name": "Dupont",
      "display_name": "Jean Dupont",
      "role": "subscriber",
      "is_verified": true
    },
    "tokens": {
      "access_token": "eyJhbGciOiJIUzI1NiIs...",
      "refresh_token": "dGhpcyBpcyBhIHJlZnJlc2...",
      "expires_in": 3600
    }
  }
}
```

---

## Endpoints - Connexion (2FA)

### 3. Modifier `POST /auth/login`

**Request (inchangée):**
```json
{
  "email": "user@example.com",
  "password": "MonMotDePasse123"
}
```

**Response (modifiée - OTP requis):**
```json
{
  "success": true,
  "data": {
    "requires_otp": true,
    "user_id": "123",
    "email": "user@example.com",
    "message": "Un code de vérification a été envoyé à votre adresse email"
  }
}
```

> ⚠️ **Important**: L'email/password est validé, mais les tokens ne sont PAS retournés. L'OTP est envoyé par email.

---

### 4. `POST /auth/verify-login-otp` (pour connexion)

**Request:**
```json
{
  "user_id": "123",
  "email": "user@example.com",
  "otp": "123456"
}
```

**Response (succès):**
```json
{
  "success": true,
  "data": {
    "user": { ... },
    "tokens": {
      "access_token": "...",
      "refresh_token": "...",
      "expires_in": 3600
    }
  }
}
```

---

### 5. `POST /auth/resend-otp`

Pour renvoyer un nouveau code (inscription ou connexion).

**Request:**
```json
{
  "user_id": "123",
  "email": "user@example.com",
  "type": "login"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Un nouveau code a été envoyé"
  }
}
```

---

## Spécifications Techniques

| Paramètre | Valeur |
|-----------|--------|
| Longueur OTP | 6 chiffres |
| Durée de validité | 10 minutes |
| Tentatives max | 5 (puis bloquer 15 min) |
| Stockage | Table `user_otp` ou meta WordPress |

### Structure Table `user_otp`
```sql
CREATE TABLE user_otp (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  otp_code VARCHAR(6) NOT NULL,
  otp_type ENUM('register', 'login') DEFAULT 'register',
  expires_at DATETIME NOT NULL,
  attempts INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_expires (expires_at)
);
```

---

## Email Templates

### Inscription
**Sujet:** `Votre code de vérification LeHiboo`

### Connexion (2FA)
**Sujet:** `Code de connexion sécurisée LeHiboo`

**Corps:**
```
Bonjour {first_name},

Votre code de connexion est :

    {OTP_CODE}

Ce code expire dans 10 minutes.

Si vous n'avez pas tenté de vous connecter, changez immédiatement votre mot de passe.

L'équipe LeHiboo
```

---

## Codes d'erreur

| Code | Message | HTTP Status |
|------|---------|-------------|
| `invalid_otp` | Code de vérification invalide | 400 |
| `otp_expired` | Le code a expiré | 400 |
| `too_many_attempts` | Trop de tentatives, réessayez dans 15 min | 429 |
| `user_already_verified` | Ce compte est déjà vérifié | 400 |
| `user_not_found` | Utilisateur non trouvé | 404 |
| `invalid_credentials` | Email ou mot de passe incorrect | 401 |

---

## Checklist Backend

### Inscription OTP
- [ ] Modifier `/auth/register` pour créer un compte non vérifié
- [ ] Générer et stocker le code OTP
- [ ] Envoyer l'email avec le code
- [ ] Créer endpoint `/auth/verify-otp`

### Connexion OTP (2FA)
- [ ] Modifier `/auth/login` pour retourner `requires_otp`
- [ ] Générer et envoyer OTP après validation email/password
- [ ] Créer endpoint `/auth/verify-login-otp`

### Commun
- [ ] Créer endpoint `/auth/resend-otp` avec support `type`
- [ ] Implémenter la logique anti-brute-force
- [ ] Nettoyer les OTP expirés (cron job)

