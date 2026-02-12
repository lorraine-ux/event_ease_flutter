# Configuration Rapide Firebase 🔥

## Étape 1 : Créer un Projet Firebase

1. Allez à : https://console.firebase.google.com
2. Cliquez sur **"Créer un projet"**
3. Entrez le nom "EventEase"
4. Acceptez et créez le projet
5. Attendez que le projet se charge

---

## Étape 2 : Obtenir vos Credentials

### Pour ANDROID :

1. Dans Firebase Console, cliquez sur **"⚙️ Paramètres du projet"**
2. Allez à l'onglet **"Vos applications"**
3. Cliquez sur **"Ajouter une application"** → **"Android"**
4. Entrez `com.example.event_ease_clean` comme **Package name**
5. Téléchargez le fichier `google-services.json`
6. Copiez-le dans : `android/app/`
7. Vous verrez les valeurs dans ce fichier JSON :
   ```json
   {
     "project_info": {
       "project_id": "YOUR_PROJECT_ID"
     },
     "client": [
       {
         "client_info": {
           "mobilesdk_app_id": "1:NUMBER:android:HASH"
         },
         "api_key": [
           {
             "current_key": "YOUR_ANDROID_API_KEY"
           }
         ]
       }
     ]
   }
   ```

### Pour iOS :

1. Dans Firebase Console, cliquez sur **"Ajouter une application"** → **"iOS"**
2. Entrez votre **Bundle ID** (ex: `com.example.eventEaseClean`)
3. Téléchargez `GoogleService-Info.plist`
4. Ouvrez `ios/Runner.xcworkspace` avec Xcode
5. Glissez-déposez le fichier dans Xcode (cochez la case `Runner`)
6. Copiez les valeurs pour le fichier `firebase_options.dart`

### Pour WEB :

1. Cliquez sur **"Ajouter une application"** → **"Web"**
2. Entrez un nom
3. Copiez la configuration Firebase fournie

---

## Étape 3 : Mettre à Jour `firebase_options.dart`

Ouvrez `lib/firebase_options.dart` et remplacez les valeurs placeholders :

### Trouvez vos credentials :
1. Allez sur https://console.firebase.google.com
2. **"Paramètres du projet"** → **"Service accounts"**
3. Onglet **"Database Secrets"** ou regardez votre `google-services.json`

### Remplissez les valeurs pour Android :

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyA_YOUR_ANDROID_API_KEY_HERE',        // Trouvez dans google-services.json → api_key → current_key
  appId: '1:000000000000:android:0000000000000000',   // Trouvez dans google-services.json → mobilesdk_app_id
  messagingSenderId: '000000000000',                  // Trouvez dans google-services.json → client_id (le premier)
  projectId: 'your-firebase-project-id',             // Trouvez dans google-services.json → project_id
  databaseURL: 'https://your-firebase-project-id.firebaseio.com',
  storageBucket: 'your-firebase-project-id.appspot.com',
);
```

---

## Étape 4 : Activer l'Authentification par Email

1. Dans Firebase Console
2. Menu gauche → **"Authentification"**
3. Onglet **"Méthode de connexion"**
4. Cliquez sur **"Email/Mot de passe"**
5. Activez-le
6. Cliquez **"Enregistrer"**

---

## Étape 5 : Tester l'Application

```bash
# Nettoyer et reconstruire
flutter clean
flutter pub get

# Lancer l'app
flutter run

# Ou sur Chrome (Web)
flutter run -d chrome
```

---

## 🔍 Où Trouver vos Credentials Exactes

| Credential | Où le trouver |
|-----------|--------------|
| `apiKey` | `google-services.json` → `api_key[0].current_key` |
| `appId` | `google-services.json` → `client[0].mobilesdk_app_id` |
| `messagingSenderId` | `google-services.json` → `client[0].client_info.client_id` (numérique) |
| `projectId` | `google-services.json` → `project_info.project_id` |
| `databaseURL` | https://**PROJECT_ID**.firebaseio.com |
| `storageBucket` | **PROJECT_ID**.appspot.com |

---

## ❌ Si vous voyez des erreurs :

### "FirebaseCore not initialized"
- Vérifiez que les credentials ne sont pas des placeholders
- Vérifiez `google-services.json` dans `android/app/`

### "Cannot reach Firebase"
- Vérifiez votre connexion internet
- Vérifiez que le projectId est correct

### Application plante au démarrage
- Exécutez `flutter clean`
- Supprimez le dossier `build/`
- Exécutez `flutter pub get`

---

## 📝 Checklist Finale

- ✅ Projet Firebase créé
- ✅ Authentification par Email activée
- ✅ `google-services.json` dans `android/app/`
- ✅ `GoogleService-Info.plist` dans Xcode (iOS)
- ✅ `firebase_options.dart` complété avec vos credentials
- ✅ `flutter clean` et `flutter pub get` exécutés
- ✅ Application lancée sans erreur

---

## 🚀 Ensuite

Une fois configuré, vous pouvez :
1. **S'inscrire** avec un email/mot de passe
2. **Se connecter** avec vos identifiants
3. **Accéder à l'application**
4. **Gérer les événements**

Bonne chance ! 🎉
