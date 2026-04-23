import 'package:flutter/material.dart';
import 'map_screen.dart';

class EventDetailPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String date;
  final String time;
  final String category;
  final String fullDescription;
  final String location;
  final double latitude;
  final double longitude;

  const EventDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.fullDescription,
    this.location = 'Dhaka, Bangladesh',
    this.latitude = 23.8103,
    this.longitude = 90.4125,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool isInterested = false;
  bool isGoing = false;

  static const Map<String, Color> categoryColors = {
    'Job Fair': Color(0xFF4CAF50),
    'Research': Color(0xFF2196F3),
    'Tour': Color(0xFFFF9800),
    'Contest': Color(0xFFE91E63),
    'Workshop': Color(0xFF9C27B0),
    'Career': Color(0xFF00BCD4),
    'Design': Color(0xFFFF5722),
  };

  @override
  Widget build(BuildContext context) {
    final catColor = categoryColors[widget.category] ?? const Color(0xFF5C35CC);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: const Color(0xFF5C35CC),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: widget.image.isNotEmpty
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                          cacheWidth: 600,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(color: catColor),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Action buttons
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: catColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          widget.category,
                          style: TextStyle(
                            color: catColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // RSVP buttons
                      _buildRsvpButton(
                        label: 'Interested',
                        icon: Icons.star,
                        isActive: isInterested,
                        activeColor: Colors.amber,
                        onTap: () => setState(() => isInterested = !isInterested),
                      ),
                      const SizedBox(width: 8),
                      _buildRsvpButton(
                        label: 'Going',
                        icon: Icons.check_circle,
                        isActive: isGoing,
                        activeColor: Colors.green,
                        onTap: () => setState(() => isGoing = !isGoing),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.calendar_today, 'Date', widget.date, Colors.blue),
                          const Divider(height: 20),
                          _buildInfoRow(Icons.access_time, 'Time', widget.time, Colors.orange),
                          const Divider(height: 20),
                          _buildInfoRow(Icons.location_on, 'Location', widget.location, Colors.red),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About This Event',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.fullDescription,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // View on Map Button
                  // ✅ API EXPLANATION: flutter_map + OpenStreetMap Tile API
                  // OpenStreetMap: https://tile.openstreetmap.org/{z}/{x}/{y}.png
                  // এটা একটা free map tile API - কোনো API key লাগে না!
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C35CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.map),
                      label: const Text(
                        '🗺️ View on Map',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MapScreen(
                            eventTitle: widget.title,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // API info banner for Sir
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.purple.shade50],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.api, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Map uses OpenStreetMap Tile API (Free, No Key Needed)',
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRsvpButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? Colors.white : Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
