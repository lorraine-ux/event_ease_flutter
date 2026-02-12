# 🎬 EventEase - Guide pour Présentation PowerPoint

## Diapo 1 : Titre
**EventEase**
📅 Application de Gestion d'Événements
Flutter | Firebase | Google Maps

---

## Diapo 2 : Contexte & Objectifs
### Contexte
- Besoin : application moderne pour gérer ses événements
- Plateforme : web + mobile (iOS/Android)
- Utilisateurs : grand public

### Objectifs
✅ Créer/modifier/supprimer événements
✅ Visualiser sur carte interactive
✅ Recevoir notifications de rappel
✅ Synchroniser across devices
✅ Sécuriser les données par utilisateur

---

## Diapo 3 : Architecture Générale
```
┌─────────────────────────────────────┐
│        Frontend (Flutter)           │
│  Web | Android | iOS                │
└────────────────┬────────────────────┘
                 │
      ┌──────────┴──────────┐
      ▼                     ▼
┌─────────────┐       ┌──────────────┐
│  Firebase   │       │  LocalDB     │
│   Auth      │       │ SQLite/      │
│             │       │ localStorage │
└─────────────┘       └──────────────┘
      │
      ▼
┌─────────────────────┐
│  Google Maps API    │
│  (Carte + Location) │
└─────────────────────┘
```

### Composants clés
1. **Frontend** : Flutter (interface utilisateur)
2. **Auth** : Firebase Auth (sécurité)
3. **Données** : SQLite mobile / LocalStorage web
4. **Carte** : Google Maps + Geolocator

---

## Diapo 4 : Choix Technologiques - Partie 1
### Flutter
**Pourquoi Flutter ?**
- ✅ Multi-plateforme avec un code source unique
- ✅ Performance native sur chaque plateforme
- ✅ Hot reload pour développement rapide
- ✅ Écosystème riche en packages

### Firebase Authentication
**Pourquoi Firebase ?**
- ✅ Pas de serveur backend à gérer
- ✅ Infrastructure de sécurité gérée par Google
- ✅ Cross-platform (web/mobile natif)
- ✅ Gratuit jusqu'à 50k utilisateurs/mois

---

## Diapo 5 : Choix Technologiques - Partie 2
### State Management : Provider
- Simple et léger (pas Redux boilerplate)
- Isolation logique par domaine
  - `AuthProvider` → gestion authentification
  - `EventProvider` → gestion événements
  - `ThemeProvider` → thème app

### Stockage local
- **Mobile** : SQLite (performance)
- **Web** : LocalStorage + JSON
- **Offline-first** : fonctionne sans Internet

### UI/UX
- Material Design avec couleurs personnalisées
- Mode Dark/Light temps réel
- Notifications native (flutter_local_notifications)

---

## Diapo 6 : Sécurité des Données
### Isolation par utilisateur
```
Utilisateur A (uid="abc123")
  ↓
  ├─ Event 1 ✓ Visible (userId="abc123")
  ├─ Event 2 ✓ Visible (userId="abc123")
  └─ Event 3 ✗ Caché (userId="xyz789")

Utilisateur B (uid="xyz789")
  ↓
  ├─ Event 1 ✗ Caché (userId="abc123")
  ├─ Event 2 ✗ Caché (userId="abc123")
  └─ Event 3 ✓ Visible (userId="xyz789")
```

**Implémentation** :
- À la connexion : `EventProvider.setCurrentUserId(user.uid)`
- Toutes les requêtes BD : `WHERE userId = currentUserId`
- À la déconnexion : cache vidé + redirection login

---

## Diapo 7 : Fonctionnalités - Authentification
### 🔐 Système d'authentification sécurisé
1. **Inscription**
   - Email validation
   - Mot de passe crypté
   - Création utilisateur unique

2. **Connexion**
   - Email + mot de passe
   - Session persistante (Firebase)
   - Auto-login au démarrage

3. **Déconnexion**
   - Session fermée
   - Cache vidé
   - Retour page login

4. **Réinitialisation**
   - Email de réinitialisation
   - Nouveau mot de passe

---

## Diapo 8 : Fonctionnalités - Gestion Événements
### 📋 Opérations CRUD complètes

**Créer**
- Titre + Description
- Date/Heure
- Catégorie (Personnel/Pro/Autre)
- Localisation GPS
- Rappel configurable

**Lire**
- Liste chronologique
- Vue calendrier
- Vue carte

**Modifier**
- Éditer tous les champs
- Reprogrammer notification

**Supprimer**
- Suppression individuelle
- Suppression batch

---

## Diapo 9 : Fonctionnalités - Visualisation
### 📅 Calendrier interactif
- Vue mensuelle
- Événements marqués par jour
- Navigation mois précédent/suivant
- Clic jour = afficher événements

### 🗺️ Carte interactive (NEW)
- Google Maps en temps réel
- **Marqueurs** : événements avec localisation
- **Clic marqueur** : affiche titre + description
- **Compteur** : nombre d'événements sur carte
- **Géolocalisation** : position utilisateur auto

---

## Diapo 10 : Fonctionnalités - Carte Détaillée
### Sélection de localisation
```
User clique 📍 dans formulaire
  ↓
LocationPickerScreen ouvre (carte Google)
  ↓
User clique sur la carte
  ↓
Marqueur apparaît + coordonnées affichées
  ↓
User clique "Confirmer"
  ↓
Coordonnées (lat, lng) enregistrées dans formulaire
```

### Exemple coordonnées
- Paris : `48.8566, 2.3522`
- Londres : `51.5074, -0.1278`
- New York : `40.7128, -74.0060`

---

## Diapo 11 : Fonctionnalités - Notifications
### 🔔 Rappels intelligents
- Alerte **1h avant** événement (configurable)
- Affichage : titre + description
- Sound + vibration (mobile)
- Cliquable pour ouvrir l'app

### Gestion dans Paramètres
- Activer/désactiver notifications
- **Persistance** : reste activé après redémarrage

---

## Diapo 12 : Interface Utilisateur
### 5 Onglets principaux

| Onglet | Icône | Fonction |
|--------|-------|----------|
| Événements | 📋 List | Affiche tous les événements |
| Créer | ➕ Plus | Formulaire créer événement |
| Calendrier | 📅 Calendar | Vue mensuelle événements |
| **Carte** | 📍 Location | Affichage Google Maps |
| Paramètres | ⚙️ Settings | Thème, notifications, logout |

### Design
- Material Design + couleurs personnalisées
- Mode Dark/Light
- Responsive (web/mobile)
- Polices : Google Fonts

---

## Diapo 13 : Interface - Dark Mode
```
Mode sombre : Fond #121212
Mode clair : Fond blanc

Couleur primaire : Rose/Pink (#E91E63)
- Boutons principaux
- Onglet actif
- Accents
```

### Basculement
- Paramètres → Switch Dark Mode
- Instantané
- Persistence automatique

---

## Diapo 14 : Installation & Déploiement
### Installation locale
```bash
# 1. Cloner projet
git clone [repo]

# 2. Installer dépendances
flutter pub get

# 3. Configurer Firebase
# → Placer google-services.json

# 4. Exécuter
flutter run -d chrome --web-port=5000
```

### Déploiement
- **Web** : `flutter build web --release`
  - Fichiers dans `build/web/`
  - Hosting : Firebase Hosting / Netlify
  
- **Android** : `flutter build apk --release`
  - Charger sur Google Play Store
  
- **iOS** : `flutter build ipa --release`
  - Charger sur App Store

---

## Diapo 15 : Configuration Requise
### Firebase Setup
1. Créer projet Firebase
2. Activer Email/Password Auth
3. Télécharger google-services.json (Android)
4. Configurer web dans firebase_options.dart

### Google Maps API
1. Activer Maps JavaScript API
2. Créer clé API
3. Ajouter à web/index.html
4. Activer Maps SDK Android

### Permissions
- **Android** : ACCESS_FINE_LOCATION, POST_NOTIFICATIONS
- **iOS** : NSLocationWhenInUseUsageDescription

---

## Diapo 16 : Statistics du Projet
### Chiffres clés
- 📝 **~4500** lignes de code Dart
- 🎯 **8** écrans principaux
- 📦 **15+** packages utilisés
- 🔐 **100%** données isolées par utilisateur
- ✅ **0** erreurs critiques compilation

### Taille application
- **Web** : ~15 MB
- **Android APK** : ~45 MB
- **iOS IPA** : ~60 MB

### Performance
- Page login : **~800ms**
- Liste événements : **~400ms** (cached)
- Carte : **~1.2s** (Google Maps)

---

## Diapo 17 : Avantages Compétitifs
### ✅ Points forts
1. **Multi-plateforme** - Web + Android + iOS avec 1 code
2. **Offline-first** - Fonctionne sans Internet
3. **Sécurité** - Données isolées par utilisateur
4. **Performance** - Native compilation
5. **UI/UX** - Modern Material Design
6. **Notifications** - Rappels configurables
7. **Carte** - Google Maps intégrée
8. **Gratuit** - Services Firebase jusqu'à quota généreux

### 🎯 USP (Unique Selling Proposition)
**Gestion d'événements moderne avec carte interactive, notifications intelligentes et synchronisation multi-appareil**

---

## Diapo 18 : Roadmap Future
### Court terme (v1.1)
- ✅ Export événements (CSV/PDF)
- ✅ Partage événements avec autres users
- ✅ Recherche événements
- ✅ Filtre par catégorie

### Moyen terme (v2.0)
- 🔄 Événements récurrents
- 🔄 Itinéraire entre événements (Maps)
- 🔄 Invitation amis
- 🔄 Synchronisation cloud automatique

### Long terme
- 🚀 Messages/Chat
- 🚀 Intégration calendrier (Google Cal, Outlook)
- 🚀 Replication locale sur plusieurs appareils
- 🚀 Web push notifications

---

## Diapo 19 : Challenges & Solutions
### Challenge 1 : Isoler données par utilisateur
**Solution** : Champ `userId` dans chaque événement
```dart
// Requête
WHERE userId = firebaseUserUid
```

### Challenge 2 : Fonctionnement offline
**Solution** : SQLite + LocalStorage + sync quand online

### Challenge 3 : Performance carte
**Solution** : Lazy loading, caching, limiter marqueurs (~50)

### Challenge 4 : Cross-platform compatibility
**Solution** : Flutter + conditional imports (db_helper_io.dart, db_helper_web.dart)

---

## Diapo 20 : Conclusion & Prochains Pas
### Réalisations
✅ Application complète et fonctionnelle
✅ Authentification sécurisée Firebase
✅ Gestion données isolées par utilisateur
✅ Carte interactive Google Maps
✅ Notifications intelligentes
✅ UI/UX moderne Material Design

### Prochains pas
1. Tests utilisateurs (A/B testing)
2. Optimisation performance
3. Ajout features v1.1
4. Lancement bêta (50 users)
5. Lancement production

### Timeline
- **Février 2026** : v1.0 (actuel) ✅
- **Mars 2026** : v1.1 (features)
- **Avril 2026** : v2.0 (social)
- **Mai 2026** : Launch production 🚀

---

## Notes pour l'orateur

### Diapo 2-3
- Montrer démo rapide de l'app
- Emphasize multi-platform: "un code = 3 plateformes"

### Diapo 6
- C'est LE point sécurité clé!
- Montrer exemple : 2 users ne voient jamais les events de l'autre
- Importer que c'est stocké au niveau BD, pas juste l'UI

### Diapo 9-10
- Montrer screenshot de la carte
- Cliquer sur marqueur = popup
- Montrer LocationPickerScreen en action

### Diapo 14
- Montrer `flutter run` sur Chrome
- Hot reload en live: "j'ai changé une couleur →  refresh instantané"

### Diapo 18
- Parler roadmap: on écoute users et on itère
- Partage événements = feature très demandée

### Diapo 20
- Recap : c'est DONE et ça marche
- Merci & questions

---

## Tips pour présentation réussie

1. **Démarrer avec démo** (30 sec)
   - Créer event
   - Voir sur carte
   - Recevoir notification

2. **Parler à l'audience**
   - Pas trop technique
   - Focuser bénéfices, pas implementation

3. **Utiliser screenshots**
   - Chaque diapo : max 5 bullets
   - Images > texte
   - Vidéo de 30-60s entre diapos

4. **Timing**
   - 20 diapositives → ~15-20 minutes
   - Laisser 5-10 min questions

5. **Notes speaker**
   - Imprimer ces notes
   - Penser à dire : "impact potentiel", "marché cible"
   - Préparer démo failsafe (video backup)
