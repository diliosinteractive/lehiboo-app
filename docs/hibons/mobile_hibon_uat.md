# UAT Hibons — Liste des fonctionnalités à tester

Checklist de recette utilisateur pour le système Hibons côté mobile (Plan 05). À cocher au fur et à mesure des tests.

**Pré-requis avant de tester** :
- App fraîchement installée ou hot-restartée (`flutter run`, pas un simple hot-reload).
- Compte de test connecté avec un état initial connu (balance, rang, favoris, etc.).
- Réseau stable (les tests réseau-down sont à part).

---

## 1. Header / Badge compteur Hibons

| # | Test | Étapes | Résultat attendu | OK |
|---|------|--------|------------------|----|
| 1.1 | Affichage au cold start | Tuer l'app puis la relancer | Le badge en haut à droite affiche la balance dès le premier rendu (via `/balance`, plus rapide que `/wallet`) | ☐ |
| 1.2 | Mise à jour temps réel | Effectuer une action gratifiante (ex: ajouter un favori) | La valeur du badge s'incrémente immédiatement, sans rechargement | ☐ |
| 1.3 | Pull-to-refresh dashboard | Sur l'écran "Dashboard Hibons", tirer vers le bas | Le badge et le solde affiché se rafraîchissent | ☐ |
| 1.4 | État anonyme | Se déconnecter | Le badge n'apparaît plus | ☐ |

---

## 2. SnackBar `+X Hibons gagnés !` (Plan 05)

Le snackbar dark avec icône dorée doit apparaître après chaque action récompensée.

| # | Action | Récompense attendue | Steps | Résultat attendu | OK |
|---|--------|---------------------|-------|------------------|----|
| 2.1 | Ajouter un favori (event) | +5 H | Sur un event jamais favorisé, taper le cœur | SnackBar "+5 Hibons 🪙 gagnés !" + badge incrémente | ☐ |
| 2.2 | Suivre un organisateur | +5 H | Sur la page d'un organisateur jamais suivi, taper "Suivre" | SnackBar "+5 Hibons 🪙 gagnés !" | ☐ |
| 2.3 | Activer un rappel | +5 H | Sur un slot d'event, activer la cloche/rappel | SnackBar "+5 Hibons 🪙 gagnés !" | ☐ |
| 2.4 | Laisser un avis | +40 H | Poster un avis sur un event (1× par event) | SnackBar "+40 Hibons 🪙 gagnés !" | ☐ |
| 2.5 | Poser une question | +40 H | Poser une question sur un event (1× par event) | SnackBar "+40 Hibons 🪙 gagnés !" | ☐ |
| 2.6 | Contacter un organisateur | +10 H | Utiliser l'action "Contacter" sur un event | SnackBar "+10 Hibons 🪙 gagnés !" | ☐ |
| 2.7 | Partager un event | +10 H | Partager un event via le sheet de partage (cap 2/sem) | SnackBar "+10 Hibons 🪙 gagnés !" | ☐ |
| 2.8 | Explorer une catégorie | +20 H | Ouvrir une catégorie jamais consultée | SnackBar "+20 Hibons 🪙 gagnés !" | ☐ |
| 2.9 | Activer notifications push | +30 H | Dans Réglages, activer les notifications (1× lifetime) | SnackBar "+30 Hibons 🪙 gagnés !" | ☐ |
| 2.10 | Compléter le profil (5/5) | +50 H | Remplir tous les champs requis du profil | SnackBar "+50 Hibons 🪙 gagnés !" | ☐ |
| 2.11 | Heartbeat 3 min en foreground | +10 H | Ouvrir l'app et la laisser en foreground 3 min | SnackBar "+10 Hibons 🪙 gagnés !" (1×/jour) | ☐ |

**Style attendu pour chaque snackbar** :
- Background sombre (`#2D3748`)
- Icône monétaire dorée à gauche
- Coins arrondis, marge de 16 px, position flottante en bas
- Auto-dismiss après 3 s

---

## 3. Cap atteint — pas de double crédit

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 3.1 | Re-favoriser un event déjà récompensé | Retirer puis ré-ajouter en favori un event qui a déjà donné des Hibons | **Aucun snackbar** Hibons (pas de double crédit). Le badge ne change pas | ☐ |
| 3.2 | 2e partage du même event | Partager un event déjà partagé | Pas de snackbar Hibons (cap event) | ☐ |
| 3.3 | 3e partage de la semaine | Partager 3 events différents puis un 4e | Pas de snackbar sur le 4e (cap 2/sem) | ☐ |
| 3.4 | Heartbeat 2x dans la journée | Effectuer 2 sessions ≥ 3 min le même jour | 1er heartbeat → snackbar. 2e → rien | ☐ |
| 3.5 | Re-toggle notifications push | Désactiver puis réactiver les notifs | Le 2e toggle ne crédite pas (1× lifetime) | ☐ |

---

## 4. Roue de la Fortune

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 4.1 | Lancer la roue (jour disponible) | Aller sur `/lucky-wheel` et taper "Lancer" | Animation de 5 s. **Aucun snackbar** ne s'affiche pendant l'animation | ☐ |
| 4.2 | Cohérence segment / résultat API | Lancer la roue plusieurs fois | Le segment qui s'arrête sous le pointeur correspond au prix annoncé dans le dialog "Félicitations !" | ☐ |
| 4.3 | Mise à jour du badge après spin | Observer le badge avant/après le spin | Le badge s'incrémente du prix gagné, après l'animation | ☐ |
| 4.4 | Roue déjà utilisée | Spinner deux fois la même journée | 2e essai : bouton grisé "Reviens demain !", impossible de relancer | ☐ |
| 4.5 | Prix = 0 ("Pas de chance") | Si l'API renvoie 0 H | Dialog "Pas de chance..." sans badge incrémenté | ☐ |

---

## 5. Daily Reward

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 5.1 | Claim daily | Sur le dashboard, taper le bouton "Réclamer" du jour courant | Animation custom du daily reward, badge incrémenté | ☐ |
| 5.2 | Pas de snackbar Hibons | Pendant le claim daily | **Aucune snackbar `+X Hibons`** ne s'affiche en parallèle (silent) | ☐ |
| 5.3 | Streak | Claim 2 jours consécutifs | Le compteur de streak s'incrémente | ☐ |
| 5.4 | Déjà claim today | Tap sur Réclamer après l'avoir déjà fait | Bouton désactivé ou message "Déjà réclamé" | ☐ |

---

## 6. Overlay Rank-Up (franchissement de palier)

⚠️ Difficile à tester sans avoir un compte juste sous un palier (ex: 990 H pour Aventurier à 1000 H).

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 6.1 | Franchissement palier | Avec ~990 H, ajouter 2 favoris (+10 H) | Après le snackbar "+5 H", overlay plein écran "Bravo, tu es maintenant Aventurier !" | ☐ |
| 6.2 | Auto-dismiss | Laisser l'overlay sans toucher | Disparaît après 6 s | ☐ |
| 6.3 | Tap "Continuer" | Taper le bouton sur l'overlay | Disparaît immédiatement | ☐ |
| 6.4 | Mise à jour du rang dans le wallet | Rouvrir le dashboard | Le nouveau rang est affiché en header | ☐ |

---

## 7. Écran "Comment gagner des Hibons" (catalogue dynamique)

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 7.1 | Ouverture | Naviguer sur l'écran | Liste de **15 actions** groupées par pilier (Onboarding, Engagement, Découverte, Participation, Communauté) | ☐ |
| 7.2 | Montants live | Comparer les montants aux récompenses réellement créditées | Cohérent (ex: "Ajouter favori" → +5 H) | ☐ |
| 7.3 | Compteurs progress | Pour les actions weekly (favori, follow, share, partage…) | Affiche "X/Y cette semaine" | ☐ |
| 7.4 | Compteurs daily | Pour "Connexion 3 min" | Affiche "X/Y aujourd'hui" | ☐ |
| 7.5 | Action atteinte | Compléter "Créer son compte" (1× lifetime) | Action grisée + badge "Atteint" | ☐ |
| 7.6 | Pull-to-refresh | Tirer vers le bas | Compteurs rafraîchis | ☐ |
| 7.7 | État erreur | Couper le réseau et relancer l'écran | État erreur + bouton "Réessayer" | ☐ |

---



## 9. Donut "Répartition par pilier"

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 9.1 | Affichage | Naviguer sur le dashboard Hibons | Section "Répartition par pilier" visible avec un donut + légende | ☐ |
| 9.2 | Cohérence montants | Comparer aux transactions historique | Les pourcentages reflètent la somme des Earned/Bonus par pilier | ☐ |
| 9.3 | Pilier `system` exclu | Vérifier la légende | Le pilier `system` n'apparaît pas (même s'il a des transactions) | ☐ |
| 9.4 | Total | Lecture du chiffre central | = lifetime earned (somme de tous les piliers visibles) | ☐ |
| 9.5 | Gains nuls | Si un pilier est à 0 | Pas affiché dans la légende | ☐ |

---

## 10. Régressions — pas de double affichage

Vérifier que les anciens toasts n'apparaissent plus en doublon avec les nouveaux snackbars.

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 10.1 | Favori | Ajouter un favori | **1 seule** snackbar Hibons. (Le toast "Ajouté aux favoris" du `favorite_button` peut rester — c'est un toast d'action, pas un toast Hibons) | ☐ |
| 10.2 | Partage event | Partager un event | 1 seule snackbar Hibons | ☐ |
| 10.3 | Catégorie | Ouvrir une catégorie | 1 seule snackbar Hibons | ☐ |
| 10.4 | Update profil | Modifier les notifications push | 1 seule snackbar Hibons | ☐ |

---

## 11. Cas réseau / erreurs

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 11.1 | Réseau down → tap favori | Mode avion, taper le cœur | Pas de crédit, message d'erreur, badge inchangé | ☐ |
| 11.2 | Reprise réseau | Remettre le réseau, retap | Crédit normal, snackbar | ☐ |
| 11.3 | Backend lent (>3 s) | Simuler latence (proxy) | Le snackbar arrive après la réponse, pas avant | ☐ |
| 11.4 | Token expiré | Forcer un 401 | Force-logout, pas de crash Hibons | ☐ |

---

## 12. Booking & Stripe (différé)

⚠️ La récompense de réservation (50 H) est délibérément différée de 10 minutes côté serveur. Aucun snackbar n'est attendu à la confirmation.

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 12.1 | Réservation gratuite | Confirmer un booking gratuit | **Aucun snackbar Hibons immédiat**. Crédit visible ~10 min plus tard via push notification | ☐ |
| 12.2 | Réservation payante | Payer un event via Stripe | Idem — pas de toast immédiat | ☐ |
| 12.3 | Push notification ~10 min | Attendre 10 min | Push reçue annonçant les Hibons gagnés | ☐ |

---

## 13. Cohérence générale

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 13.1 | Lifetime cohérent | Comparer la somme du donut au lifetime affiché | Égalité | ☐ |
| 13.2 | Balance après plusieurs actions | Effectuer 5 actions gratifiantes | Balance finale = balance initiale + somme des récompenses | ☐ |
| 13.3 | Rang stable après reload | Hot-restart après un rank-up | Le nouveau rang est conservé | ☐ |
| 13.4 | Multi-device | Effectuer une action sur device A, ouvrir device B | Le wallet est cohérent (à condition de pull-to-refresh) | ☐ |

---

## 14. Performance

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 14.1 | Mass-favoriting | Taper 5 fois le cœur sur 5 events différents en moins de 5 s | Les snackbars se succèdent sans empilement, ~1 par seconde, aucune perdue | ☐ |
| 14.2 | Cold-start | Mesurer le temps avant que le badge affiche une valeur | < 1 s (grâce à `/balance`) | ☐ |
| 14.3 | Aucun appel `/wallet` après mutation | Logs Dio post-favori | **Pas** de `GET /wallet` (l'enveloppe suffit) | ☐ |

---

## 15. Localisation

| # | Test | Steps | Résultat attendu | OK |
|---|------|-------|------------------|----|
| 15.1 | Locale FR | App en français | Labels rang/pilier en français ("Curieux", "Découverte"…) | ☐ |
| 15.2 | Locale EN | App en anglais (changer locale device) | Labels traduits ("Curious", "Discovery"…) | ☐ |

---

## Notes pour le testeur

- **Les snackbars Hibons** apparaissent **après** le retour de l'API (200 OK avec enveloppe `hibons_update`). Si rien ne s'affiche, vérifier que le backend renvoie bien l'enveloppe (sinon c'est un problème serveur, pas mobile).
- **Le badge** se met à jour de deux manières :
  - Optimiste via l'enveloppe (snackbar + balance)
  - Au cold start via `/balance` (avant que `/wallet` complet n'arrive)
- **La roue** et le **daily** ont leur propre UI de célébration et **ne déclenchent pas** de snackbar Hibons (volontaire).
- **Booking** : le crédit est différé +10 min — c'est normal qu'il n'y ait pas de toast immédiat.

---

## Synthèse

| Catégorie | Total | OK | KO | Bloquant ? |
|-----------|-------|----|----|-----------|
| Header / Badge | 4 | | | |
| SnackBar gain | 11 | | | |
| Cap atteint | 5 | | | |
| Roue | 5 | | | |
| Daily | 4 | | | |
| Rank-up | 4 | | | |
| Catalogue | 7 | | | |
| Historique | 5 | | | |
| Donut | 5 | | | |
| Régressions | 4 | | | |
| Réseau | 4 | | | |
| Booking | 3 | | | |
| Cohérence | 4 | | | |
| Performance | 3 | | | |
| Localisation | 2 | | | |
| **Total** | **70** | | | |
