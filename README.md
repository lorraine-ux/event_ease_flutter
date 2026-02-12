# event_ease_clean

A new Flutter project.

## Getting Started

# 📅 EventEase - Gestionnaire d'Événements Multi-Plateforme

[![Flutter](https://img.shields.io/badge/Flutter-v3.10.3-blue.svg?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Authentication-orange.svg?logo=firebase)](https://firebase.google.com)
[![Google Maps](https://img.shields.io/badge/Google%20Maps-Interactive-red.svg?logo=googlemaps)](https://developers.google.com/maps)
[![License](https://img.shields.io/badge/License-Proprietary-green.svg)](LICENSE)

EventEase est une application moderne de gestion d'événements construite avec **Flutter**. Créez, organisez et visualisez vos événements sur une carte interactive avec des notifications de rappel intelligentes.

## ✨ Fonctionnalités Principales

### 🔐 Authentification & Sécurité
- ✅ Inscription/Connexion sécurisée avec Firebase Auth
- ✅ Isolation complète des données par utilisateur
- ✅ Session persistante
- ✅ Déconnexion sécurisée

### 📋 Gestion d'Événements
- ✅ Créer, modifier, supprimer événements
- ✅ Catégorisation (Personnel, Professionnel, Autre)
- ✅ Localisation GPS intégrée
- ✅ Statut de complétion

### 📅 Visualisation
- ✅ **Vue Liste** : Affichage chronologique
- ✅ **Vue Calendrier** : Navigation mensuelle
- ✅ **Vue Carte** : Google Maps interactive avec marqueurs
- ✅ Mode Dark/Light en temps réel

### 🔔 Notifications Intelligentes
- ✅ Rappels configurables (5 min - 1 jour avant)
- ✅ Son + vibration (mobile)
- ✅ Activation/désactivation dans Paramètres

### 🗺️ Carte Interactive (NEW)
- ✅ Google Maps avec géolocalisation
- ✅ Sélection de localisation interactive
- ✅ Marqueurs d'événements en temps réel
- ✅ Compteur d'événements localisés

## 🏗️ Architecture Technique

```
┌─────────────────────┐
│   Frontend (Flutter)│ ← Web + Android + iOS
└──────────┬──────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
Firebase Auth  Local DB
    │        (SQLite/LS)
    └──────────┬─────────┘
               │
        Google Maps API
```

### Stack Technologique
- **Frontend** : Flutter 3.10.3 (Dart)
- **Authentication** : Firebase Auth
- **Database** : SQLite (mobile) + LocalStorage (web)
- **State Management** : Provider
- **Maps** : Google Maps Flutter + Geolocator
- **Notifications** : flutter_local_notifications
- **UI** : Material Design + Google Fonts

## 🚀 Démarrage Rapide

### Prérequis
- Flutter SDK v3.10.3+
- Compte Firebase
- Clé Google Maps API
- Chrome/Firefox (pour web)

### Installation

```bash
# 1. Cloner le projet
git clone https://github.com/[repo]/event_ease_clean.git
cd event_ease_clean

# 2. Installer dépendances
flutter clean
flutter pub get

# 3. Configurer Firebase
# → Placer google-services.json dans android/app/

# 4. Exécuter sur web
flutter run -d chrome --web-port=5000
```

### Accéder à l'application
Ouvrez votre navigateur : **http://localhost:5000**

## 📱 Plateforme Supportées

| Plateforme | Status | Notes |
|-----------|--------|-------|
| 🌐 Web | ✅ Complet | Chrome, Firefox, Safari |
| 🤖 Android | ✅ Complet | APK pour Play Store |
| 🍎 iOS | ✅ Complet | IPA pour App Store |

## 📸 Screenshots

### Authentification
- [x] Login Screen
- [x] Signup Screen

### Événements
- [x] Liste d'événements
- [x] Formulaire création
- [x] Détails événement

### Visualisation
- [x] Calendrier interactif
- [x] **Carte Google Maps avec marqueurs**
- [x] Sélecteur de localisation

### Paramètres
- [x] Mode Dark/Light
- [x] Notifications toggle
- [x] Déconnexion

## 🔒 Sécurité des Données

### Isolation par Utilisateur
Chaque événement est lié à l'UID Firebase de l'utilisateur. Les requêtes BD incluent toujours :
```dart
WHERE userId = currentUser.uid
```

**Garanties** :
✓ Utilisateur A ne voit jamais les événements de l'utilisateur B
✓ Suppression d'un compte = suppression de tous ses événements
✓ Données encryptées en transit (Firebase)

## 📋 Commandes Utiles

```bash
# Analyser le code
flutter analyze

# Formater le code
flutter format lib

# Exécuter tests
flutter test

# Build production
flutter build web --release
flutter build apk --release
flutter build ipa --release

# Hot reload (en dev)
# Appuyer 'r' dans le terminal
```

## 🛠️ Configuration

### Firebase Setup
1. Create project on [firebase.google.com](https://firebase.google.com)
2. Enable Email/Password authentication
3. Download `google-services.json` pour Android
4. Copy config Web to `lib/firebase_options.dart`

### Google Maps
1. Enable Maps JavaScript API
2. Create API key on [Google Cloud Console](https://console.cloud.google.com)
3. Add key to `web/index.html`

### Permissions
**Android** : `android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**iOS** : `ios/Runner/Info.plist`
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>EventEase needs your location for the map</string>
```

## 📊 Statistiques

- **Lignes de code** : ~4500 (Dart)
- **Écrans** : 8 principaux
- **Packages** : 15+
- **Taille APK** : ~45 MB
- **Taille Web** : ~15 MB
- **Performance** : ~800ms (page login)

## 📚 Documentation

- 📖 [Documentation Complète](DOCUMENTATION_COMPLETE.md) - Guide détaillé techniques
- 🎬 [Notes Présentation](PRESENTATION_NOTES.md) - Slides & notes orateur
- 📍 [Google Maps Config](GOOGLE_MAPS_CONFIG.md) - Setup maps
- 🔄 [Maps Integration](MAPS_INTEGRATION_SUMMARY.md) - Résumé intégration maps

## 🤝 Contribution

Contributions bienvenues ! Pour contribuer :

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Commit vos changements (`git commit -m 'Add amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 🐛 Troubleshooting

### Port 5000 déjà utilisé
```bash
flutter run -d chrome --web-port=5001
```

### Google Maps affiche blanc
- Vérifier clé API dans `web/index.html`
- Vérifier permissions Android/iOS
- Vérifier connexion Internet

### Firebase authentication error
- Vérifier Email/Password activé Firebase Console
- Vérifier `google-services.json` present
- Vérifier `firebase_options.dart` avec bonnes clés

## 📞 Support

Pour toute question ou problème :
- 📧 Email : [support@eventease.com]
- 🐛 GitHub Issues : [repository/issues]
- 💬 Discord : [serveur invite]

## 📄 Licence

Ce projet est propriétaire. 
© 2026 EventEase. Tous droits réservés.

---

## 🎯 Roadmap

### v1.0 (✅ Actuel)
- ✅ Firebase Auth
- ✅ Gestion événements CRUD
- ✅ Calendrier interactif
- ✅ Google Maps
- ✅ Notifications

### v1.1 (Mars 2026)
- 🔄 Export CSV/PDF
- 🔄 Partage événements
- 🔄 Recherche améliorée
- 🔄 Filtres

### v2.0 (Avril 2026)
- 🚀 Événements récurrents
- 🚀 Itinéraire entre événements
- 🚀 Invitations amis
- 🚀 Synchronisation cloud

## 🙏 Remerciements

Merci à :
- [Flutter Team](https://flutter.dev)
- [Firebase](https://firebase.google.com)
- [Google Maps](https://developers.google.com/maps)
- Notre équipe de développement

---

**EventEase v1.0** | Février 2026 ✨

