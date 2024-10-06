import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// MapPage widget represents a page displaying a map with location points.
class MapPage extends StatefulWidget {
  // List of LatLng points representing locations on the map.
  final List<LatLng> locationPoints;

  // Constructor for MapPage widget, requiring a list of location points.
  const MapPage({Key? key, required this.locationPoints}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

// State class for MapPage widget.
class MapPageState extends State<MapPage> {
  // Controller for managing the state of the map.
  late MapController _mapController;

  // Initializes the state, called when the widget is first created.
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Increases the zoom level of the map when called.
  void _zoomIn() {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1.0);
  }

  // Decreases the zoom level of the map when called.
  void _zoomOut() {
    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1.0);
  }

  // Builds the FlutterMap widget with specified options and layers.
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.locationPoints.isNotEmpty
            ? widget.locationPoints.first
            : const LatLng(43.9452, -78.8969),
        initialZoom: 17.0,
        minZoom: 5.0,
        maxZoom: 18.0,
      ),
      children: [
        // OpenStreetMap tile layer.
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        // Marker layer with location points displayed as markers on the map.
        MarkerLayer(
          markers: widget.locationPoints.map((point) {
            return Marker(
              width: 40.0,
              height: 40.0,
              point: point,
              child: const Icon(Icons.location_on, color: Colors.red),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Builds the overall UI for the MapPage.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7AA095),
        title: const Text('Location Map'),
        actions: [
          // Zoom in button in the app bar.
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          // Zoom out button in the app bar.
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
        ],
      ),
      body: _buildMap(), // Displays the map in the body of the scaffold.
    );
  }
}
