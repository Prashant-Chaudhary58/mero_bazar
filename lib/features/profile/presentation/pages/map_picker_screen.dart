import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mero_bazar/core/services/location_service.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(
    28.3949,
    84.1240,
  ); // Default Center (Nepal)
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    // Don't fetch immediately. Wait for map to be ready.
  }

  void _onPositionChanged(MapCamera position, bool hasGesture) {
    _currentCenter = position.center;
  }

  void _confirmSelection() {
    Navigator.of(context).pop(_currentCenter);
  }

  @override
  Widget build(BuildContext context) {
    // No loading spinner, just map
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Farm Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmSelection,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15.0,
              onPositionChanged: _onPositionChanged,
              onMapReady: () {
                print("MapPicker: Map Ready");
                _mapReady = true;
                // _fetchUserLocation(); // DISABLE AUTO-FETCH to prevent freeze
              },
            ),
            children: [
              // TileLayer(
              //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              //   userAgentPackageName: 'com.prashantchaudhary.com.mero_bazar',
              // ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          // Center Marker (Fixed)
          const Center(
            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
          // Helper Text
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Drag the map to place the pin under your farm location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () async {
                print("MapPicker: FAB Clicked - getting location...");
                try {
                  final position = await LocationService.getCurrentPosition()
                      .timeout(const Duration(seconds: 10));
                  print("MapPicker: Location found: $position");
                  _mapController.move(
                    LatLng(position.latitude, position.longitude),
                    15.0,
                  );
                } catch (e) {
                  print("MapPicker: FAB Error $e");
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Location Error: $e")));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmSelection,
        label: const Text("Set This Location"),
        icon: const Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }
}
