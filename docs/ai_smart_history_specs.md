# Spécifications Backend : Smart History & Optimisation Coûts

Pour réduire les coûts (tokens) tout en améliorant la personnalisation, le backend doit évoluer d'une "Mémoire Brute" à une "Mémoire Sémantique".

## 1. Gestion du Contexte (Smart Context)

### Entrée (Request)
Le mobile enverra un objet `user_context` contenant le profil accumulé.
```json
{
  "user_context": {
    "preferences": ["théâtre", "gastronomie"],
    "mood": "détendu",
    "location": "Paris",
    "family_status": "en couple"
  },
  "history": [ ... les 10 derniers messages uniquement ... ]
}
```

### Logique Backend (LLM System Prompt)
Le System Prompt du backend doit inclure des instructions pour gérer ce contexte :
1.  **Lecture** : "Utilise les informations dans `user_context` pour personnaliser ta réponse (ex: propose des activités adaptées au mood)."
2.  **Écriture** : "Analyse le dernier message de l'utilisateur. Si tu détectes une nouvelle préférence ou information importante (ex: 'je déteste le sport'), mets à jour le `user_context`."

### Sortie (Response)
Le backend DOIT renvoyer le `user_context` mis à jour s'il a changé.
```json
{
  "message": "Bien sûr, voici une pièce de théâtre...",
  "user_context": {
    "preferences": ["théâtre", "gastronomie", "pas de sport"],
    "mood": "détendu",
    ...
  }
}
```
*Le mobile stockera ce nouveau contexte et le renverra à la prochaine requête.*

## 2. Optimisation des Tokens

- **Historique Tronqué** : Le mobile n'enverra plus TOUT l'historique, mais seulement les **10 derniers messages** (Sliding Window). Le backend doit être robuste à cela (ne pas faire référence à un message d'il y a 1 heure s'il n'est plus dans l'array `history`). C'est le `user_context` qui sert de mémoire long terme.
- **Réponse Concise** : Instruire le LLM pour être direct et structuré, évitant le verbiage inutile qui coûte cher.
