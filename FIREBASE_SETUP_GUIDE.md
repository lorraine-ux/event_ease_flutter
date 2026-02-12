# Guide de Configuration Firebase Authentication

Ce guide vous permettra d'intégrer Firebase Authentication à l'application EventEase.

## Prérequis

- Un compte Google
- Accès à [Firebase Console](https://console.firebase.google.com)
- Flutter CLI installé
- Git (optionnel mais recommandé)

## Étapes de Configuration

### 1. Créer un Projet Firebase

1. Allez à [Firebase Console](https://console.firebase.google.com)
2. Cliquez sur **"Créer un projet"**
3. Donnez un nom à votre projet (ex: "EventEase")
4. Acceptez les conditions et cliquez sur **"Créer un projet"**
5. Attendez que le projet soit créé

### 2. Activer l'Authentification par Email/Mot de Passe

1. Dans Firebase Console, allez à **"Authentification"** (dans le menu gauche)
2. Cliquez sur l'onglet **"Méthode de connexion"**
3. Cliquez sur **"Email/Mot de passe"**
4. Activez **"Email/Mot de passe"** et **"Email pour lien de connexion"** (optionnel)
5. Cliquez sur **"Enregistrer"**

### 3. Configurer Android

#### 3.1 Obtenir l'empreinte SHA-1

Ouvrez un terminal dans votre projet Flutter et exécutez :

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Cherchez les lignes commençant par `SHA1:` et copiez la valeur.

#### 3.2 Ajouter l'application Android à Firebase

1. Dans Firebase Console, allez à **"Paramètres du projet"** (roue dentée en haut)
2. Allez à **"Ajouter une application"** et sélectionnez **"Android"**
3. Entrez les valeurs suivantes :
   - **Package name** : Regardez dans `android/app/build.gradle` → `applicationId`
   - **SHA-1 certificate fingerprints** : Collez la valeur SHA-1 copiée précédemment
4. Cliquez sur **"Enregistrer l'application"**
5. **Téléchargez** le fichier **`google-services.json`**
6. Placez ce fichier dans `android/app/`

#### 3.3 Modifier `android/build.gradle`

Ajoutez la dépendance Google Services à la section `dependencies` :

```gradle
classpath 'com.google.gms:google-services:4.4.0'
```

#### 3.4 Modifier `android/app/build.gradle`

À la fin du fichier, ajoutez :

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 4. Configurer iOS

1. Dans Firebase Console, allez à **"Paramètres du projet"** (roue dentée)
2. Allez à **"Ajouter une application"** et sélectionnez **"iOS"**
3. Entrez les valeurs suivantes :
   - **iOS bundle ID** : Regardez dans `ios/Runner/Runner.xcodeproj` → `PRODUCT_BUNDLE_IDENTIFIER` 
     Ou exécutez : `grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner/Runner.xcodeproj/project.pbxproj | head -1`
4. Cliquez sur **"Enregistrer l'application"**
5. **Téléchargez** le fichier **`GoogleService-Info.plist`**
6. Ouvrez Xcode :
   ```bash
   open ios/Runner.xcworkspace
   ```
7. Dans Xcode, glissez-déposez le fichier `GoogleService-Info.plist` dans le dossier `Runner`
8. Vérifiez que le fichier est ajouté à la cible `Runner` (voir les cochages à droite)

### 5. Configuration Web (Optionnel)

1. Dans Firebase Console, allez à **"Paramètres du projet"**
2. Allez à **"Ajouter une application"** et sélectionnez **"Web"**
3. Donnez un nom à l'application
4. Cliquez sur **"Enregistrer l'application"**
5. Copiez la configuration Firebase fournie
6. Mettez à jour le fichier `web/index.html` si nécessaire

### 6. Générer les Fichiers de Configuration Dart (Recommandé)

Utilisez la CLI FlutterFire pour générer automatiquement `firebase_options.dart` :

```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```

Suivez les instructions et sélectionnez les plateformes (Android, iOS, Web).

**OU** Générez manuellement `lib/firebase_options.dart` avec vos clés Firebase.

### 7. Mettre à Jour `pubspec.yaml`

Les packages Firebase ont déjà été ajoutés :

```yaml
firebase_core: ^3.1.0
firebase_auth: ^5.1.0
```

Exécutez :

```bash
flutter pub get
```

## Test de l'Authentification

1. Exécutez l'application en mode débogage :
   ```bash
   flutter run
   ```

2. Vous devriez voir l'écran de connexion LoginScreen

3. Testez la création de compte (Sign Up)

4. Une fois créé, connectez-vous avec les identifiants

5. Explorez l'application et testez la déconnexion dans les paramètres

## Fichiers Modifiés/Créés

### Nouveaux fichiers :
- `lib/providers/auth_provider.dart` - Gestion de l'authentification
- `lib/screens/login_screen.dart` - Écran de connexion
- `lib/screens/signup_screen.dart` - Écran d'inscription
- `lib/firebase_options.dart` - Configuration Firebase

### Fichiers modifiés :
- `lib/main.dart` - Intégration Firebase et flux d'authentification
- `lib/screens/settings_screen.dart` - Ajout de l'option déconnexion

## Fonctionnalités Implémentées

### AuthProvider
- ✅ Sign up avec email et mot de passe
- ✅ Sign in avec email et mot de passe
- ✅ Sign out
- ✅ Réinitialisation de mot de passe
- ✅ Gestion d'erreurs localisée en français
- ✅ État d'authentification en temps réel

### Écrans
- ✅ Écran de connexion avec validation
- ✅ Écran d'inscription avec confirmation de mot de passe
- ✅ Lien "Mot de passe oublié"
- ✅ Déconnexion dans les paramètres

### Flux d'Application
- ✅ Protection des écrans (redirection vers login si non authentifié)
- ✅ Auto-reconnexion après fermeture/réouverture de l'app

## Sécurité

### Règles de Sécurité à Mettre en Place (Optionnel)

Dans Firebase Console → Realtime Database → Règles :

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

## Dépannage

### Erreur : "FirebaseCore not initialized"
- Assurez-vous que `Firebase.initializeApp()` est appelé dans `main()`
- Vérifiez que `GoogleService-Info.plist` (iOS) ou `google-services.json` (Android) sont dans les bons emplacements

### Erreur : "SHA-1 certificate fingerprints not matching"
- Générez une nouvelle empreinte SHA-1
- Vérifiez qu'elle correspond à celle enregistrée dans Firebase Console

### Application ne démarre pas après ajout de `google-services.json`
- Nettoyez le build : `flutter clean`
- Exécutez à nouveau : `flutter run`

### Erreur lors de la création/connexion
- Vérifiez les logs avec `flutter logs`
- Assurez-vous que l'authentification par email est activée dans Firebase Console

## Extension Future : Autres Méthodes d'Authentification

Pour ajouter d'autres méthodes (Google, GitHub, etc.) :

```dart
// Exemple : Connexion Google
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth?.accessToken,
  idToken: googleAuth?.idToken,
);
await FirebaseAuth.instance.signInWithCredential(credential);
```

Ajouter les packages :
```yaml
google_sign_in: ^6.1.0
firebase_ui_auth: ^1.6.0
```

## Ressources

- [Documentation Firebase Flutter](https://firebase.flutter.dev/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
- [Firebase Authentication](https://firebase.google.com/docs/auth)

## Support

Pour aide supplémentaire, consultez :
- [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase+flutter)
- [Flutter Discord Community](https://discord.gg/flutter)
- [Firebase Support](https://firebase.google.com/support)
