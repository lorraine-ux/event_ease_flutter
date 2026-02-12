# Guide d'Installation et d'Exécution - EventEase

## 📋 Table des Matières

1. [Prérequis](#prérequis)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Exécution](#exécution)
5. [Build Production](#build-production)
6. [Dépannage](#dépannage)

---

## ✅ Prérequis

### Logiciels Requis

| Logiciel | Version | Téléchargement |
|----------|---------|----------------|
| Flutter SDK | 3.0+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.0+ | Inclus avec Flutter |
| Git | Latest | [git-scm.com](https://git-scm.com/) |
| VS Code / Android Studio | Latest | [code.visualstudio.com](https://code.visualstudio.com/) |

### Comptes Requis

- ✅ Compte Firebase (gratuit)
- ✅ Compte Google Cloud (pour Maps API - gratuit)

### Vérification de l'Installation

```bash
# Vérifier Flutter
flutter --version

# Vérifier que tout est OK
flutter doctor

# Résultat attendu :
# [✓] Flutter (Channel stable, 3.x.x)
# [✓] Android toolchain
# [✓] Chrome - develop for the web
# [✓] VS Code
```

---

## 📥 Installation

### Étape 1 : Cloner le Projet

```bash
# Cloner le repository
git clone https://github.com/votre-username/event_ease_clean.git

# Naviguer dans le dossier
cd event_ease_clean
```

### Étape 2 : Installer les Dépendances

```bash
# Nettoyer les builds précédents (si nécessaire)
flutter clean

# Télécharger toutes les dépendances
flutter pub get
```

**Sortie attendue** :
```
Running "flutter pub get" in event_ease_clean...
Resolving dependencies... (2.3s)
Got dependencies!
```

### Étape 3 : Vérifier la Structure

```bash
# Lister les fichiers principaux
ls -la

# Vous devriez voir :
# - lib/
# - android/
# - ios/
# - web/
# - pubspec.yaml
# - README.md
```

---

## ⚙️ Configuration

### 1. Configuration Firebase

#### A. Créer un Projet Firebase

1. Allez sur [console.firebase.google.com](https://console.firebase.google.com)
2. Cliquez sur **"Ajouter un projet"**
3. Nommez-le `EventEase` (ou autre)
4. Désactivez Google Analytics (optionnel)
5. Cliquez sur **"Créer le projet"**

#### B. Activer l'Authentification

1. Dans Firebase Console → **Authentication**
2. Cliquez sur **"Commencer"**
3. Activez **"E-mail/Mot de passe"**
4. Enregistrez

#### C. Configurer pour Web

1. Dans Firebase Console → **Paramètres du projet** (⚙️)
2. Cliquez sur **"Web"** (icône `</>`)
3. Nommez l'app : `EventEase Web`
4. **Copiez la configuration** :

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "eventease-xxx.firebaseapp.com",
  projectId: "eventease-xxx",
  storageBucket: "eventease-xxx.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

5. Créez le fichier `lib/firebase_options.dart` :

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'VOTRE_API_KEY',
    authDomain: 'VOTRE_AUTH_DOMAIN',
    projectId: 'VOTRE_PROJECT_ID',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    appId: 'VOTRE_APP_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'VOTRE_ANDROID_API_KEY',
    appId: 'VOTRE_ANDROID_APP_ID',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    projectId: 'VOTRE_PROJECT_ID',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'VOTRE_IOS_API_KEY',
    appId: 'VOTRE_IOS_APP_ID',
    messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
    projectId: 'VOTRE_PROJECT_ID',
    storageBucket: 'VOTRE_STORAGE_BUCKET',
    iosBundleId: 'com.example.eventEaseClean',
  );
}
```

#### D. Configurer pour Android (optionnel)

1. Dans Firebase Console → **Paramètres du projet**
2. Cliquez sur **Android** (icône Android)
3. Package name : `com.example.event_ease_clean`
4. Téléchargez `google-services.json`
5. Placez-le dans `android/app/`

### 2. Configuration Google Maps (Optionnel)

Si vous utilisez la fonctionnalité carte :

1. Allez sur [console.cloud.google.com](https://console.cloud.google.com)
2. Activez **Maps JavaScript API**
3. Créez une clé API
4. Ajoutez-la dans `web/index.html` :

```html
<script src="https://maps.googleapis.com/maps/api/js?key=VOTRE_CLE_API"></script>
```

---

## 🚀 Exécution

### Lancer sur Web (Recommandé pour débuter)

```bash
# Lancer sur Chrome
flutter run -d chrome --web-port=5000

# Ou sur Edge
flutter run -d edge --web-port=5000
```

**Accès** : Ouvrez [http://localhost:5000](http://localhost:5000)

### Lancer sur Android

#### Avec Émulateur

```bash
# Lister les émulateurs
flutter emulators

# Lancer un émulateur
flutter emulators --launch <emulator_id>

# Lancer l'app
flutter run
```

#### Avec Téléphone Physique

1. Activez **Mode développeur** sur le téléphone
2. Activez **Débogage USB**
3. Connectez via USB
4. Autorisez le débogage

```bash
# Vérifier la connexion
flutter devices

# Lancer l'app
flutter run
```

### Lancer sur iOS (Mac uniquement)

```bash
# Installer les dépendances iOS
cd ios
pod install
cd ..

# Lancer sur simulateur
open -a Simulator
flutter run

# Ou sur iPhone physique
flutter run -d <iphone_id>
```

### Lancer sur Windows

```bash
flutter run -d windows
```

---

## 📦 Build Production

### Web

```bash
# Build optimisé
flutter build web --release

# Les fichiers sont dans build/web/
# Déployez sur Firebase Hosting, Netlify, Vercel, etc.
```

### Android APK

```bash
# Build APK
flutter build apk --release

# Fichier généré : build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)

```bash
# Build App Bundle
flutter build appbundle --release

# Fichier généré : build/app/outputs/bundle/release/app-release.aab
```

### iOS (Mac uniquement)

```bash
# Build iOS
flutter build ios --release

# Ouvrir dans Xcode pour signature
open ios/Runner.xcworkspace
```

---

## 🛠️ Dépannage

### Problème : `flutter doctor` montre des erreurs

**Solution** :
```bash
# Android license
flutter doctor --android-licenses

# Acceptez toutes les licences
```

### Problème : Port 5000 déjà utilisé

**Solution** :
```bash
# Utiliser un autre port
flutter run -d chrome --web-port=5001
```

### Problème : Firebase authentication error

**Vérifications** :
1. ✅ Email/Password activé dans Firebase Console
2. ✅ `firebase_options.dart` avec bonnes clés
3. ✅ Connexion Internet active

### Problème : Packages ne s'installent pas

**Solution** :
```bash
# Nettoyer et réinstaller
flutter clean
flutter pub cache repair
flutter pub get
```

### Problème : Erreur de build Android

**Solution** :
```bash
# Nettoyer le build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Problème : Hot reload ne fonctionne pas

**Solution** :
- Appuyez sur `R` (majuscule) pour hot restart complet
- Ou relancez l'application

---

## 🎯 Commandes Utiles

### Développement

```bash
# Hot reload
# Appuyez 'r' dans le terminal

# Hot restart
# Appuyez 'R' dans le terminal

# Analyser le code
flutter analyze

# Formater le code
flutter format lib

# Voir les logs
flutter logs
```

### Tests

```bash
# Lancer les tests
flutter test

# Tests avec coverage
flutter test --coverage

# Tests d'intégration
flutter drive --target=test_driver/app.dart
```

### Nettoyage

```bash
# Nettoyer les builds
flutter clean

# Réparer le cache
flutter pub cache repair

# Mettre à jour Flutter
flutter upgrade
```

---

## 📱 Tester l'Application

### Créer un Compte Test

1. Lancez l'application
2. Cliquez sur **"S'inscrire"**
3. Email : `test@example.com`
4. Mot de passe : `Test123!`
5. Créez le compte

### Créer un Événement Test

1. Connectez-vous
2. Allez sur **"Créer"**
3. Remplissez :
   - Titre : `Réunion importante`
   - Date : Demain
   - Catégorie : Professionnel
   - Rappel : 1 heure avant
4. Cliquez sur **"Créer l'événement"**

### Vérifier les Fonctionnalités

- ✅ Voir l'événement dans la liste
- ✅ Voir l'événement dans le calendrier
- ✅ Changer le thème (clair/sombre)
- ✅ Marquer comme complété
- ✅ Supprimer l'événement
- ✅ Pull-to-refresh

---

## 🎓 Ressources

### Documentation

- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [Dart Docs](https://dart.dev/guides)

### Tutoriels

- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Firebase Flutter](https://firebase.google.com/docs/flutter/setup)

### Communauté

- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://reddit.com/r/FlutterDev)

---

## ✅ Checklist de Démarrage

- [ ] Flutter installé et `flutter doctor` OK
- [ ] Projet cloné
- [ ] Dépendances installées (`flutter pub get`)
- [ ] Firebase configuré
- [ ] `firebase_options.dart` créé
- [ ] Application lancée sur au moins une plateforme
- [ ] Compte test créé
- [ ] Événement test créé
- [ ] Toutes les fonctionnalités testées

---

**Besoin d'aide ?** Consultez la section [Dépannage](#dépannage) ou ouvrez une issue sur GitHub !

**Bon développement ! 🚀**
