import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/event_provider.dart';
import '../providers/theme_provider.dart';
import '../models/event.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(48.8566, 2.3522); // Default Paris
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Request location permission
      final permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('[MapsScreen] Location permission denied');
        // Use default location (Paris)
        _buildMarkersFromEvents();
      } else {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
        
        _buildMarkersFromEvents();
      }
    } catch (e) {
      print('[MapsScreen] Error initializing map: $e');
      _buildMarkersFromEvents();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _buildMarkersFromEvents() {
    final events = Provider.of<EventProvider>(context, listen: false).events;
    final markers = <Marker>{};

    for (int i = 0; i < events.length; i++) {
      final event = events[i];
      
      // Only add markers if event has location coordinates
      if (event.location.isNotEmpty && event.location.contains(',')) {
        try {
          final parts = event.location.split(',');
          final lat = double.parse(parts[0].trim());
          final lng = double.parse(parts[1].trim());

          markers.add(
            Marker(
              markerId: MarkerId(event.id.toString()),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: event.title,
                snippet: event.description.length > 50
                    ? '${event.description.substring(0, 50)}...'
                    : event.description,
                onTap: () => _showEventDetails(event),
              ),
              onTap: () => _showEventDetails(event),
            ),
          );
        } catch (e) {
          print('[MapsScreen] Error parsing location for ${event.title}: $e');
        }
      }
    }

    setState(() => _markers = markers);
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(event.category, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(event.location)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des événements'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, _) {
          final eventsWithLocation =
              eventProvider.events.where((e) => e.location.isNotEmpty).toList();

          if (eventsWithLocation.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucun événement localisé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ajoutez une localisation à vos événements pour les voir sur la carte',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 12,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (isDark) {
                    _mapController.setMapStyle('[]'); // Dark mode if needed
                  }
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: true,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '${eventsWithLocation.length} événement(s) localisé(s)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
