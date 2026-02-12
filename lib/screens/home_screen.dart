import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/animated_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    // Load events once when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      
      // Définir l'UID utilisateur actuel dans EventProvider UNIQUEMENT s'il a changé
      if (authProvider.user != null && authProvider.user!.uid != _lastUserId) {
        _lastUserId = authProvider.user!.uid;
        eventProvider.setCurrentUserId(authProvider.user!.uid);
        eventProvider.loadEvents();
      } else if (authProvider.user != null && eventProvider.events.isEmpty) {
        // Si même user mais pas d'events, charger juste une fois
        eventProvider.loadEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Note: Scaffold is provided by MainWrapper, but we can have nested scaffolds or just the body.
    // However, MainWrapper uses IndexedStack with Scaffold. 
    // If we use Scaffold here, we get an AppBar. The design shows "EventEase" at the top.
    
    return Scaffold(
      backgroundColor: Colors.transparent, // Inherit from theme
      appBar: AppBar(
        title: Consumer<EventProvider>(
          builder: (context, eventProvider, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 32,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.event_note, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text('EventEase (${eventProvider.events.length})'),
              ],
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
         actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return AnimatedIconButton(
                icon: themeProvider.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                onPressed: () {
                  themeProvider.toggleTheme(
                      themeProvider.themeMode != ThemeMode.dark);
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final eventProvider = Provider.of<EventProvider>(context, listen: false);
          eventProvider.resetLoadedFlag();
          await eventProvider.loadEvents();
        },
        child: Consumer<EventProvider>(
          builder: (context, eventProvider, child) {
            print('[HomeScreen] 🔍 Rendering with ${eventProvider.events.length} events');
          if (eventProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (eventProvider.events.isEmpty) {
             // Empty State Implementation
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final emptyTextColor = isDark ? Colors.white : Colors.grey;
            final subtextColor = isDark ? Colors.grey : Colors.grey.shade700;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ensure the file exists in pubspec.yaml and assets folder
                    Image.asset(
                      'assets/images/empty_state.png', 
                      height: 200,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun événement prévu',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: emptyTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Créez votre premier événement en appuyant sur l\'onglet Créer',
                      style: TextStyle(
                        fontSize: 16,
                        color: subtextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // CustomScrollView pour que toute la page défile ensemble
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = eventProvider.events[index];
                    return AnimatedListItem(
                      index: index,
                      delay: const Duration(milliseconds: 80),
                      child: EventCard(
                        event: event,
                        onTap: () {
                          // TODO: Navigate to details or edit
                        },
                        onToggleStatus: () =>
                            eventProvider.toggleEventStatus(event),
                        onDelete: () => eventProvider.deleteEvent(event.id!),
                      ),
                    );
                  },
                  childCount: eventProvider.events.length,
                ),
              ),
              // Image décorative en bas de la liste
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/journee_libre.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.event_available, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
          },
        ),
      ),
    );
  }
}
