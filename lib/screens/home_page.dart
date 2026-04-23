import 'package:flutter/material.dart';
import 'package:university_event_management_system/screens/filter_screen.dart';
import 'add_event_page.dart';
import 'event_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, String>> favoriteEvents;
  final Function(Map<String, String>) toggleFavorite;

  const HomePage({
    super.key,
    required this.favoriteEvents,
    required this.toggleFavorite,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> allEvents = [
    {
      'title': 'AUST Job Fair',
      'description': 'Explore job opportunities at AUST.',
      'image': 'assets/images/AUST_JOB_FAIR.jpg',
      'date': '2025-04-10',
      'time': '10:00 AM',
      'category': 'Job Fair',
      'location': 'AUST Campus, Tejgaon, Dhaka',
      'latitude': '23.7696',
      'longitude': '90.3888',
      'full_description': 'Join us for a unique opportunity to meet employers and explore job openings. The fair includes companies offering positions across multiple sectors. Come prepared with your resume.',
    },
    {
      'title': 'AUST Undergraduate Research',
      'description': 'Showcasing undergraduate research projects.',
      'image': 'assets/images/AUST_Undergraduate_Research.jpg',
      'date': '2025-04-15',
      'time': '12:00 PM',
      'category': 'Research',
      'location': 'AUST Campus, Tejgaon, Dhaka',
      'latitude': '23.7696',
      'longitude': '90.3888',
      'full_description': 'This event showcases undergraduate research projects. An excellent platform for students to present their work and gain insights from peers and faculty.',
    },
    {
      'title': 'DIU CSE Study Tour',
      'description': 'Join us for an exciting study tour.',
      'image': 'assets/images/DIU_CSE_Study_Tour.jpg',
      'date': '2025-05-05',
      'time': '7:00 AM',
      'category': 'Tour',
      'location': 'DIU Campus, Ashulia, Dhaka',
      'latitude': '23.9438',
      'longitude': '90.3806',
      'full_description': 'An exciting study tour of various technological hubs and research centers. Designed to give students hands-on experience with the latest technology trends.',
    },
    {
      'title': 'DIU Take Off Contest',
      'description': 'Compete in DIU\'s Take Off Contest.',
      'image': 'assets/images/DIU_Take_Off_Contest.jpg',
      'date': '2025-04-20',
      'time': '9:00 AM',
      'category': 'Contest',
      'location': 'DIU Campus, Ashulia, Dhaka',
      'latitude': '23.9438',
      'longitude': '90.3806',
      'full_description': 'Compete against peers in various competitions. Whether you are a coder, designer, or innovator, this contest is for you!',
    },
    {
      'title': 'DIU UTA Program',
      'description': 'Unlock your technical abilities.',
      'image': 'assets/images/DIU_UTA.jpg',
      'date': '2025-04-25',
      'time': '2:00 PM',
      'category': 'Workshop',
      'location': 'DIU Campus, Ashulia, Dhaka',
      'latitude': '23.9438',
      'longitude': '90.3806',
      'full_description': 'The DIU UTA Program offers students a chance to enhance technical skills through interactive workshops with industry experts.',
    },
    {
      'title': 'UIU Programming Career',
      'description': 'Plan your career in programming.',
      'image': 'assets/images/UIU_Programming_carrier.jpg',
      'date': '2025-04-30',
      'time': '1:00 PM',
      'category': 'Career',
      'location': 'UIU Campus, Badda, Dhaka',
      'latitude': '23.7805',
      'longitude': '90.4267',
      'full_description': 'Learn about programming careers, paths, and opportunities in the tech industry from industry experts.',
    },
    {
      'title': 'UIU CCL UI/UX Design',
      'description': 'Learn UI/UX Design essentials.',
      'image': 'assets/images/UIU_CCL_UI_UX_Design.jpg',
      'date': '2025-05-01',
      'time': '11:00 AM',
      'category': 'Design',
      'location': 'UIU Campus, Badda, Dhaka',
      'latitude': '23.7805',
      'longitude': '90.4267',
      'full_description': 'Learn UI/UX design principles and how to create user-friendly interfaces with guidance from design experts.',
    },
  ];

  List<Map<String, String>> displayedEvents = [];
  String _searchQuery = '';

  // Category colors
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
  void initState() {
    super.initState();
    applyFilters();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    applyFilters();
  }

  void updateSearch(String query) {
    setState(() {
      _searchQuery = query;
      applyFilters();
    });
  }

  void applyFilters() {
    setState(() {
      displayedEvents = allEvents.where((event) {
        bool searchMatch = _searchQuery.isEmpty ||
            event['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event['category']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            event['location']!.toLowerCase().contains(_searchQuery.toLowerCase());

        bool universityMatch = selectedUniversity == null ||
            selectedUniversity == 'All Universities' ||
            event['title']!.toUpperCase().contains(selectedUniversity!.toUpperCase());

        bool dateMatch = selectedDate == null ||
            selectedDate == 'All Dates' ||
            event['date'] == selectedDate;

        bool categoryMatch = selectedCategory == null ||
            selectedCategory == 'All Categories' ||
            event['category'] == selectedCategory;

        return searchMatch && universityMatch && dateMatch && categoryMatch;
      }).toList();
    });
  }

  void addEvent(Map<String, String> newEvent) {
    setState(() {
      allEvents.add(newEvent);
      applyFilters();
    });
  }

  bool get hasActiveFilters =>
      (selectedUniversity != null && selectedUniversity != 'All Universities') ||
      (selectedDate != null && selectedDate != 'All Dates') ||
      (selectedCategory != null && selectedCategory != 'All Categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('📅 Upcoming Events'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune),
                tooltip: 'Filter',
                onPressed: () async {
                  await Navigator.pushNamed(context, '/filter');
                  applyFilters();
                },
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF5C35CC),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              onChanged: updateSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '🔍 Search events, categories...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
              ),
            ),
          ),

          // Active filter chip
          if (hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  const Icon(Icons.filter_alt, size: 16, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      [
                        if (selectedUniversity != null && selectedUniversity != 'All Universities') selectedUniversity!,
                        if (selectedDate != null && selectedDate != 'All Dates') selectedDate!,
                        if (selectedCategory != null && selectedCategory != 'All Categories') selectedCategory!,
                      ].join(' • '),
                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      selectedUniversity = null;
                      selectedDate = null;
                      selectedCategory = null;
                      applyFilters();
                    }),
                    child: const Icon(Icons.close, size: 16, color: Colors.orange),
                  ),
                ],
              ),
            ),

          // Event count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text(
                  '${displayedEvents.length} event${displayedEvents.length != 1 ? 's' : ''} found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),

          // Events list
          Expanded(
            child: displayedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'No events found',
                          style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try changing your filter or search',
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: displayedEvents.length,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemBuilder: (context, index) {
                      final event = displayedEvents[index];
                      bool isFavorite = widget.favoriteEvents.contains(event);
                      final catColor = categoryColors[event['category']] ?? Colors.deepPurple;

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailPage(
                              title: event['title']!,
                              image: event['image']!,
                              description: event['description']!,
                              date: event['date']!,
                              time: event['time']!,
                              category: event['category']!,
                              fullDescription: event['full_description']!,
                              location: event['location'] ?? 'Dhaka, Bangladesh',
                              latitude: double.tryParse(event['latitude'] ?? '23.8103') ?? 23.8103,
                              longitude: double.tryParse(event['longitude'] ?? '90.4125') ?? 90.4125,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Left color bar + image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: event['image'] != null && event['image']!.isNotEmpty
                                    ? Image.asset(
                                        event['image']!,
                                        width: 100,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        cacheWidth: 200,
                                      )
                                    : Container(
                                        width: 100,
                                        height: 110,
                                        color: catColor.withOpacity(0.1),
                                        child: Icon(Icons.event, size: 40, color: catColor),
                                      ),
                              ),
                              // Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: catColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          event['category']!,
                                          style: TextStyle(
                                            color: catColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        event['title']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            event['date']!,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            event['time']!,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 12, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              event['location']!,
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Favorite button
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    widget.toggleFavorite(event);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEventPage(onAddEvent: addEvent)),
        ),
        backgroundColor: const Color(0xFF5C35CC),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
