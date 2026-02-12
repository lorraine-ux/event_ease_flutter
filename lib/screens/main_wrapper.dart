import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_event_screen.dart';
import 'calendar_screen.dart';
import 'maps_screen.dart';
import 'settings_screen.dart';
import '../utils/theme.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    print('[MainWrapper] 🔄 Initializing MainWrapper');
    
    try {
      _screens = [
        const HomeScreen(),
        const AddEventScreen(),
        const CalendarScreen(),
        const MapsScreen(),
        const SettingsScreen(),
      ];
      print('[MainWrapper] ✅ All screens initialized successfully');
    } catch (e) {
      print('[MainWrapper] ❌ Error initializing screens: $e');
      _screens = [
        Center(
          child: Text('Erreur lors du chargement: $e'),
        ),
      ];
    }
  }

  void _onTap(int index) {
      setState(() {
        _currentIndex = index;
      });
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white, // Ensure bar is white as per design (or dark if preferred)
          // The requested design shows a white bar with pink accent.
          // But I set the theme to dark. Let's check the user request.
          // "Interface comme celle ci". The screenshot background is dark (black), 
          // but the bottom bar is white with pink icons.
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'É\u0301v\u00e9nements',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              label: 'Cr\u00e9er',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendrier',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Carte',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Paramètres',
            ),
          ],
        ),
      ),
    );
  }
}
