import 'package:flutter/material.dart';
import 'package:university_event_management_system/screens/home_page.dart';
import 'package:university_event_management_system/screens/filter_screen.dart';
import 'package:university_event_management_system/screens/favorite_screen.dart';
import 'package:university_event_management_system/screens/notification_screen.dart';
import 'package:university_event_management_system/screens/profile_screen.dart';
import 'package:university_event_management_system/services/notification_service.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  List<Map<String, String>> favoriteEvents = [];

  void _toggleFavorite(Map<String, String> event) {
    setState(() {
      if (favoriteEvents.contains(event)) {
        favoriteEvents.remove(event);
      } else {
        favoriteEvents.add(event);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(favoriteEvents: favoriteEvents, toggleFavorite: _toggleFavorite),
          const FilterScreen(),
          FavoriteScreen(favoriteEvents: favoriteEvents),
          const NotificationScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF5C35CC),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: _onItemTapped,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Filter'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.favorite_border),
                  if (favoriteEvents.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined),
                  if (NotificationService().count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          '${NotificationService().count}',
                          style: const TextStyle(color: Colors.white, fontSize: 8),
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.notifications),
              label: 'Alerts',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
