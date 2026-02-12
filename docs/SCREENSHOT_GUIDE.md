# Guide de Captures d'Écran - EventEase

## 📸 Captures à Réaliser

Pour une documentation complète, voici les captures d'écran à prendre et où les placer.

### Structure des Dossiers

```
event_ease_clean/
└── screenshots/
    ├── login.png
    ├── signup.png
    ├── home_light.png
    ├── home_dark.png
    ├── calendar.png
    ├── add_event.png
    ├── event_details.png
    ├── settings.png
    ├── animations.gif
    └── demo.gif
```

---

## 📋 Liste des Captures

### 1. Authentification

#### `login.png`
- **Écran** : Page de connexion
- **Contenu** :
  - Logo EventEase
  - Champs email/mot de passe
  - Bouton "Se connecter"
  - Lien "S'inscrire"
  - Thème clair

#### `signup.png`
- **Écran** : Page d'inscription
- **Contenu** :
  - Formulaire complet
  - Champs nom, email, mot de passe
  - Bouton "Créer un compte"

### 2. Page d'Accueil

#### `home_light.png`
- **Écran** : Liste des événements (thème clair)
- **Contenu** :
  - 3-4 événements visibles
  - Différentes catégories (Professionnel en bleu, Personnel en rose)
  - Image décorative en bas
  - Compteur d'événements dans le titre

#### `home_dark.png`
- **Écran** : Liste des événements (thème sombre)
- **Contenu** : Même que ci-dessus mais en mode sombre

### 3. Calendrier

#### `calendar.png`
- **Écran** : Vue calendrier
- **Contenu** :
  - Calendrier du mois
  - Quelques jours avec événements (points colorés)
  - Liste d'événements du jour sélectionné
  - Thème au choix

### 4. Création d'Événement

#### `add_event.png`
- **Écran** : Formulaire de création
- **Contenu** :
  - Tous les champs visibles
  - Titre, description, date, heure
  - Sélecteur de catégorie
  - Options de rappel
  - Bouton "Créer l'événement"

### 5. Paramètres

#### `settings.png`
- **Écran** : Page paramètres
- **Contenu** :
  - Toggle thème clair/sombre
  - Toggle notifications
  - Bouton déconnexion
  - Informations utilisateur

### 6. Animations (Optionnel)

#### `animations.gif`
- **Type** : GIF animé
- **Contenu** :
  - Transition entre pages
  - Animation de liste (fade-in progressif)
  - Micro-animation sur bouton

#### `demo.gif`
- **Type** : GIF animé
- **Contenu** :
  - Flux complet : Login → Créer événement → Voir dans calendrier
  - Durée : 10-15 secondes

---

## 🛠️ Comment Prendre les Captures

### Sur Web (Chrome)

1. **Lancer l'application**
   ```bash
   flutter run -d chrome --web-port=5000
   ```

2. **Ouvrir DevTools**
   - Appuyez sur `F12`
   - Cliquez sur l'icône de téléphone (mode responsive)
   - Sélectionnez "iPhone 12 Pro" ou "Pixel 5"

3. **Prendre la capture**
   - Windows : `Win + Shift + S`
   - Mac : `Cmd + Shift + 4`
   - Ou utilisez l'extension Chrome "Full Page Screen Capture"

4. **Enregistrer**
   - Nommez selon la liste ci-dessus
   - Format : PNG
   - Résolution : 1080x2340 (mobile) ou 1920x1080 (desktop)

### Sur Android/iOS

1. **Lancer sur émulateur/téléphone**
   ```bash
   flutter run
   ```

2. **Prendre la capture**
   - Android : `Volume bas + Power`
   - iOS : `Side button + Volume up`

3. **Transférer vers PC**
   - Via câble USB
   - Ou via AirDrop (iOS)

### Créer des GIFs

#### Avec LICEcap (Windows/Mac)

1. Téléchargez [LICEcap](https://www.cockos.com/licecap/)
2. Lancez LICEcap
3. Positionnez la fenêtre sur l'app
4. Cliquez "Record"
5. Effectuez les actions
6. Cliquez "Stop"
7. Sauvegardez en `.gif`

#### Avec ScreenToGif (Windows)

1. Téléchargez [ScreenToGif](https://www.screentogif.com/)
2. Lancez et sélectionnez "Recorder"
3. Enregistrez les actions
4. Éditez si nécessaire
5. Exportez en GIF

---

## ✨ Conseils pour de Belles Captures

### Préparation

1. **Données de test réalistes**
   - Utilisez des titres d'événements réels
   - Dates variées (passé, aujourd'hui, futur)
   - Différentes catégories

2. **Exemples d'événements**
   ```
   Professionnel (Bleu):
   - Réunion d'équipe - 14/02/2026 14:00
   - Présentation client - 15/02/2026 10:30
   
   Personnel (Rose):
   - Anniversaire Marie - 16/02/2026 18:00
   - Rendez-vous médecin - 17/02/2026 09:00
   
   Autre (Ambre):
   - Cours de yoga - 18/02/2026 19:30
   ```

3. **Nettoyage**
   - Pas d'erreurs visibles
   - Pas de console ouverte
   - Pas de notifications système

### Qualité

- ✅ **Résolution** : Minimum 1080p
- ✅ **Format** : PNG pour images, GIF pour animations
- ✅ **Taille** : < 2 MB par image
- ✅ **Clarté** : Texte lisible
- ✅ **Cadrage** : Centré, pas de bords coupés

### Cohérence

- 🎨 Même thème pour captures similaires
- 📱 Même appareil/résolution
- 🕐 Même heure affichée (ou cohérente)
- 👤 Même utilisateur test

---

## 📝 Légendes Suggérées

Pour chaque capture, ajoutez une légende dans le README :

```markdown
### Écran de Connexion
![Login Screen](screenshots/login.png)
*Interface de connexion avec authentification Firebase*

### Page d'Accueil - Thème Clair
![Home Light](screenshots/home_light.png)
*Liste des événements avec couleurs par catégorie*

### Page d'Accueil - Thème Sombre
![Home Dark](screenshots/home_dark.png)
*Mode sombre pour une utilisation confortable la nuit*

### Calendrier Interactif
![Calendar](screenshots/calendar.png)
*Vue mensuelle avec événements du jour sélectionné*

### Création d'Événement
![Add Event](screenshots/add_event.png)
*Formulaire complet avec catégories et rappels*

### Animations Fluides
![Animations](screenshots/animations.gif)
*Transitions de page et micro-animations*
```

---

## 🎬 Scénario de Démonstration (GIF)

### Flux Complet (15 secondes)

1. **0-3s** : Page de connexion → Connexion
2. **3-6s** : Page d'accueil → Clic sur "Créer"
3. **6-10s** : Remplir formulaire rapide
4. **10-12s** : Créer événement
5. **12-15s** : Voir l'événement dans calendrier

### Paramètres d'Enregistrement

- **FPS** : 15-20 (suffisant pour UI)
- **Résolution** : 720p (pour taille fichier raisonnable)
- **Durée** : 10-20 secondes max
- **Taille** : < 5 MB

---

## 📦 Checklist Finale

Avant de publier, vérifiez :

- [ ] Toutes les captures sont prises
- [ ] Nommées correctement
- [ ] Placées dans `screenshots/`
- [ ] Taille < 2 MB chacune
- [ ] Résolution suffisante
- [ ] Pas d'informations sensibles visibles
- [ ] README mis à jour avec les liens
- [ ] GIFs optimisés (< 5 MB)

---

## 🔧 Outils Recommandés

### Capture d'Écran
- **Windows** : Snipping Tool, ShareX
- **Mac** : Cmd+Shift+4, CleanShot X
- **Linux** : Flameshot, GNOME Screenshot

### Enregistrement GIF
- **Windows** : ScreenToGif, LICEcap
- **Mac** : LICEcap, Kap
- **Linux** : Peek

### Optimisation
- **Images** : TinyPNG, ImageOptim
- **GIFs** : ezgif.com, gifsicle

---

## 📊 Exemple de README avec Captures

```markdown
## 📸 Captures d'Écran

<table>
  <tr>
    <td><img src="screenshots/login.png" width="250"/></td>
    <td><img src="screenshots/home_light.png" width="250"/></td>
    <td><img src="screenshots/calendar.png" width="250"/></td>
  </tr>
  <tr>
    <td align="center">Connexion</td>
    <td align="center">Accueil</td>
    <td align="center">Calendrier</td>
  </tr>
</table>

### Démonstration Vidéo

![Demo](screenshots/demo.gif)
```

---

**Bon courage pour les captures ! 📸**
