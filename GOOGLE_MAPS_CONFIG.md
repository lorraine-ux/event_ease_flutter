# Configuration Google Maps

## Obligatoire pour le web

Pour activer Google Maps sur la version web, vous **devez** ajouter une clé API Google Maps à `web/index.html`.

### Étapes :

1. **Créer une clé API Google Maps** :
   - Allez sur [Google Cloud Console](https://console.cloud.google.com/)
   - Créez un nouveau projet ou utilisez `eventease-8fc1c`
   - Activez l'API **Maps JavaScript API**
   - Créez une clé API (restriction Web, domaines locaux autorisés)

2. **Ajouter la clé à `web/index.html`** :

```html
<script>
  window.flutterGoogleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY";
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY"></script>
```

Remplacez `YOUR_GOOGLE_MAPS_API_KEY` par votre clé réelle.

### Exemple complet `web/index.html` :

```html
<!DOCTYPE html>
<html>
  <head>
    <base href="$FLUTTER_BASE_HREF" />
    <meta charset="UTF-8">
    <meta content="IE=Edge" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventEase</title>
    <link rel="manifest" href="manifest.json">
    <link rel="icon" type="image/png" href="favicon.png"/>
    
    <!-- Google Maps API -->
    <script>
      window.flutterGoogleMapsApiKey = "AIzaSyAOPf92yoj2SeNavDoblRQqFo5ppf-nyU8"; 
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAOPf92yoj2SeNavDoblRQqFo5ppf-nyU8"></script>
  </head>
  <body>
    <script src="flutter.js" defer></script>
  </body>
</html>
```

## Utilisation

### Sur votre appareil/web :
1. Cliquez sur l'onglet **Carte** (icône localisation)
2. Vous verrez une carte centrée sur Paris par défaut
3. Les événements avec localisation s'affichent comme marqueurs **rouges**
4. Cliquez sur un marqueur pour voir les détails

### Créer un événement localisé :
1. Onglet **Créer**
2. Remplissez le formulaire
3. Dans le champ **Localisation**, cliquez sur l'icône **📍 (carte)**
4. Tapez sur la carte pour sélectionner la position
5. Confirmez en cliquant **Confirmer**
6. Les coordonnées `lat, lng` s'affichent dans le champ

## Format localisation

Les événements stockent la localisation sous le format : `latitude, longitude`
Exemple : `48.8566, 2.3522` (Paris)

## Permissions

### Android
- [x] Automatiquement géré par geolocator
- Requiert permission `ACCESS_FINE_LOCATION` (_déjà demandée_ au démarrage)

### iOS
- [ ] Ajoutez à `ios/Runner/Info.plist` :
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Nous avons besoin de votre localisation pour afficher les événements sur la carte</string>
```

### Web
- [x] Demande la permission via le navigateur (geolocator)
- Fonctionne même sans localisation (défaut : Paris)

## Notes

- Si la géolocalisation est refusée → la carte affiche Paris par défaut
- Les événements **sans localisation** n'apparaissent pas sur la carte
- Zoom initial : 12 (centré sur votre position ou Paris)
- Marqueurs en rouge avec titre et description
