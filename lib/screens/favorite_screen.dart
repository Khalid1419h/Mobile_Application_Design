import 'package:flutter/material.dart';
import 'event_detail_page.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Map<String, String>> favoriteEvents;
  const FavoriteScreen({super.key, required this.favoriteEvents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('❤️ Favorites (${favoriteEvents.length})'),
      ),
      body: favoriteEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No favorites yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text(
                    'Home-এ event card-এ ❤️ press করুন',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoriteEvents.length,
              itemBuilder: (context, index) {
                final event = favoriteEvents[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailPage(
                        title: event['title']!,
                        image: event['image'] ?? '',
                        description: event['description']!,
                        date: event['date']!,
                        time: event['time']!,
                        category: event['category']!,
                        fullDescription: event['full_description'] ?? event['description']!,
                        location: event['location'] ?? 'Dhaka',
                        latitude: double.tryParse(event['latitude'] ?? '23.8103') ?? 23.8103,
                        longitude: double.tryParse(event['longitude'] ?? '90.4125') ?? 90.4125,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: event['image'] != null && event['image']!.isNotEmpty
                              ? Image.asset(event['image']!, width: 90, height: 100, fit: BoxFit.cover, cacheWidth: 180)
                              : Container(
                                  width: 90, height: 100,
                                  color: Colors.deepPurple.shade50,
                                  child: const Icon(Icons.event, size: 36, color: Colors.deepPurple),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('📅 ${event['date']}  ⏰ ${event['time']}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                Text('📍 ${event['location']}',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.favorite, color: Colors.red, size: 22),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
