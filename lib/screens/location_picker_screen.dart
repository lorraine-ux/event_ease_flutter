import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  final String? initialLocation;
  
  const LocationPickerScreen({
    super.key,
    this.initialLocation,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng _selectedPosition = const LatLng(48.8566, 2.3522); // Default Paris
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // If initial location provided, parse it
    if (widget.initialLocation != null &&
        widget.initialLocation!.contains(',')) {
      try {
        final parts = widget.initialLocation!.split(',');
        final lat = double.parse(parts[0].trim());
        final lng = double.parse(parts[1].trim());
        _selectedPosition = LatLng(lat, lng);
      } catch (e) {
        print('[LocationPicker] Error parsing initial location: $e');
      }
    }
    _isLoading = false;
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  void _confirmLocation() {
    final locationString =
        '${_selectedPosition.latitude}, ${_selectedPosition.longitude}';
    Navigator.of(context).pop(locationString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (!_isLoading)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedPosition,
                zoom: 13,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: _onMapTapped,
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedPosition,
                  infoWindow: const InfoWindow(title: 'Position sélectionnée'),
                ),
              },
            )
          else
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_selectedPosition.latitude.toStringAsFixed(6)}, ${_selectedPosition.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    child: const Text('Confirmer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
