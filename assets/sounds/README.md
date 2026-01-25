# Sons VoiceFab

Ce dossier contient les fichiers audio pour le Voice FAB.

## Fichiers requis

| Fichier | Description | Recommandation |
|---------|-------------|----------------|
| `voice_start.mp3` | Son au début de l'écoute vocale | Court (~0.3s), ton montant |
| `voice_end.mp3` | Son à la fin de l'écoute vocale | Court (~0.3s), ton descendant |

## Spécifications

- **Format** : MP3, WAV ou AAC
- **Durée** : < 1 seconde recommandé
- **Qualité** : 44.1kHz, 128kbps minimum
- **Volume** : Normalisé pour éviter les pics

## Notes

- Si les fichiers sont absents, l'app fonctionne silencieusement
- Les sons sont joués via le package `audioplayers`
- Rebuild l'app après ajout des fichiers (`flutter clean && flutter run`)
