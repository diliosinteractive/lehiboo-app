# Spécifications Backend : Persistance Historique Chat

Pour garantir une expérience continue (cross-device) et une mémoire long terme fiable.

## 1. Sauvegarde Automatique (Endpoint Existant)
**endpoint** : `POST /mobile/chat`
*   **Comportement actuel** : Génère une réponse IA.
*   **Nouveau comportement attendu** :
    *   Doit sauvegarder le message `user` en base de données (table `chat_messages` ?).
    *   Doit sauvegarder la réponse `assistant` générée en base.
    *   Doit lier ces messages à l'utilisateur (`user_id`).

## 2. Récupération de l'Historique (Nouvel Endpoint)
**endpoint** : `GET /mobile/chat/history`
*   **Auth** : Bearer Token requis.
*   **Response** :
    ```json
    {
      "success": true,
      "data": {
        "history": [
          {
            "id": "msg_123",
            "role": "user",
            "content": "Je cherche un resto",
            "timestamp": "2023-10-27T10:00:00Z"
          },
          {
            "id": "msg_124",
            "role": "assistant",
            "content": "Quel type de cuisine ?",
            "events": [ { "id": 1, "title": "Pizza..." } ],
            "timestamp": "2023-10-27T10:00:05Z"
          }
        ]
      }
    }
    ```
*   **Pagination** : Optionnelle pour l'instant (ex: `?limit=50`).

## 3. Gestion du Contexte
Le `user_context` (profil) est toujours stocké côté client et envoyé à chaque requête. Le backend doit continuer à le mettre à jour si nécessaire.
