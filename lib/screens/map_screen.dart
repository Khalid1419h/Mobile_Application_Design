import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ✅ API EXPLANATION FOR SIR:
// এই screen-এ দুটো technology use হচ্ছে:
//
// 1. flutter_map package (pub.dev)
//    - Flutter-এর জন্য OpenStreetMap library
//    - Google Maps-এর alternative
//
// 2. OpenStreetMap Tile API (free, no key needed)
//    URL: https://tile.openstreetmap.org/{z}/{x}/{y}.png
//    - z = zoom level
//    - x, y = tile coordinates
//    - এটা একটা REST API যা map-এর tiles (images) দেয়
//    - কোনো API key বা payment লাগে না!
//
// Google Maps API vs OpenStreetMap:
// Google Maps = Paid ($200/month free then charged)
// OpenStreetMap = 100% Free & Open Source

class MapScreen extends StatelessWidget {
  final String eventTitle;
  final double latitude;
  final double longitude;

  const MapScreen({
    super.key,
    required this.eventTitle,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng eventLocation = LatLng(latitude, longitude);

    if (kIsWeb) {
      return _buildWebFallback(context, eventLocation);
    }
    return _buildMobileMap(context, eventLocation);
  }

  Widget _buildMobileMap(BuildContext context, LatLng eventLocation) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eventTitle, style: const TextStyle(fontSize: 16)),
            const Text(
              'OpenStreetMap • Free API • No Key Required',
              style: TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF5C35CC),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: eventLocation,
              initialZoom: 15.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              // ✅ OpenStreetMap Tile API - FREE!
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.university_event_management_system',
                maxZoom: 19,
              ),
              // Marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: eventLocation,
                    width: 160,
                    height: 90,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5C35CC),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                            ],
                          ),
                          child: Text(
                            eventTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(Icons.location_on, color: Color(0xFF5C35CC), size: 36),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // API info overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white.withOpacity(0.95),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF5C35CC), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: const Text(
                        'FREE API\nNo Key',
                        style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebFallback(BuildContext context, LatLng eventLocation) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventTitle),
        backgroundColor: const Color(0xFF5C35CC),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Map visual representation
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5C35CC), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.map, size: 80, color: Colors.white24),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 48, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          eventTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // API info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.api, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('API Information', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _apiInfoRow('Package', 'flutter_map (pub.dev)'),
                    _apiInfoRow('Map Provider', 'OpenStreetMap'),
                    _apiInfoRow('API URL', 'tile.openstreetmap.org'),
                    _apiInfoRow('API Key', '❌ None Needed (FREE)'),
                    _apiInfoRow('Lat', latitude.toStringAsFixed(4)),
                    _apiInfoRow('Lng', longitude.toStringAsFixed(4)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '📱 Android Emulator-এ full interactive map দেখা যাবে',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _apiInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('$label:', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
