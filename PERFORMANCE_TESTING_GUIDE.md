# 📱 Guide de Test et Optimisation - EventEase

## 1️⃣ Configuration des Appareils de Test

### Appareils Disponibles
```bash
# Lister les appareils
flutter devices

# Actuellement disponibles:
# - Windows Desktop
# - Chrome Browser
# - Edge Browser
```

### Installation d'Émulateurs (Optionnel)

#### Android Emulator
```bash
# Lister les émulateurs disponibles
flutter emulators

# Lancer un émulateur Android
flutter emulators launch <emulator-name>

# Ou créer un nouvel émulateur via Android Studio
```

#### iOS Simulator (macOS uniquement)
```bash
# Ouvrir le simulateur iOS
open -a Simulator

# Ou via command line
xcrun simctl list
```

---

## 2️⃣ Tests sur Appareils

### Test sur Windows Desktop
```bash
flutter run -d windows --profile
```
**Mesures:**
- Performance CPU/GPU
- Consommation mémoire
- FPS et temps de rendu

### Test sur Chrome
```bash
flutter run -d chrome --web-port=5000 --profile
```
**Mesures:**
- Performance web
- Temps de chargement
- Utilisation mémoire du navigateur

### Test sur Android
```bash
# Si émulateur lancé
flutter run -d emulator-5554 --profile

# Ou sur appareil physique connecté
flutter run --profile
```

---

## 3️⃣ Profiling des Performances

### Accéder à DevTools
```bash
# Ouvre automatiquement DevTools
flutter run
# Puis appuie sur 'L' dans le terminal
```

### Onglets importants dans DevTools:

1. **Performance Tab**
   - Timeline des frames
   - FPS (doit être ≥ 60fps pour smooth)
   - GPU/CPU utilization

2. **Memory Tab**
   - Heap snapshots
   - Memory allocation
   - Garbage collection

3. **App Size**
   - Taille de l'app (APK/IPA)
   - Dépendances volumineuses

---

## 4️⃣ Optimisations Implémentées ✅

### EventCard Widget
```dart
// ✅ RepaintBoundary: Évite les repaints inutiles
// ✅ const constructors: Optimise les rebuilds
// ✅ maxLines + ellipsis: Évite les débordements
```

### Home Screen ListView
```dart
// ✅ cacheExtent: 500 (augmente le cache)
// ✅ addAutomaticKeepAlives: true
// ✅ addRepaintBoundaries: true
```

### Performance Service
```dart
// ✅ Measure async/sync operations
// ✅ Color-coded performance warnings
// ✅ Memory profiling support
```

---

## 5️⃣ Checklist de Performance

- [ ] FPS ≥ 60 sur tous les appareils
- [ ] Temps de startup < 2 secondes
- [ ] Mémoire stable (sans augmentation lineaire)
- [ ] Pas de jank ou frame skips
- [ ] Animations fluides
- [ ] Chargement des événements < 500ms
- [ ] Aucun memory leak

---

## 6️⃣ Commandes Utiles pour le Profiling

```bash
# Profile mode (optimisé mais debuggable)
flutter run --profile

# Release mode (performance maximale)
flutter run --release

# AOT compilation (Android/iOS)
flutter build apk --release
flutter build ios --release

# Analyser la taille de l'app
flutter build apk --analyze-size
flutter build web --release --no-web-resources

# Mode verbose (logs détaillés)
flutter run -v
```

---

## 7️⃣ Métriques de Performance à Surveiller

| Métrique | Bon | Acceptable | Mauvais |
|----------|-----|-----------|--------|
| FPS | 60 | 50-59 | < 50 |
| Frame Time | < 16ms | 16-33ms | > 33ms |
| Heap Memory | < 100MB | 100-300MB | > 300MB |
| Startup Time | < 1s | 1-2s | > 2s |
| Build Time | < 5s | 5-10s | > 10s |

---

## 8️⃣ Optimisations Futures

- [ ] Lazy loading des images
- [ ] Réduction de la taille APK/IPA
- [ ] Preload des données critiques
- [ ] Caching des requêtes réseau
- [ ] Code splitting pour web
- [ ] Progressive Web App (PWA)

---

**Notes:**
- Le PerformanceService affiche les logs uniquement en `kDebugMode`
- DevTools est le meilleur outil pour identifier les goulots d'étranglement
- Les tests sur appareils physiques sont cruciaux pour la performance réelle

