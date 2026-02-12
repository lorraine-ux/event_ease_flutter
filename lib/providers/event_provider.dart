import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/performance_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  bool _hasLoadedInitial = false;
  String _currentUserId = '';

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  // Setter pour mettre à jour l'utilisateur actif
  void setCurrentUserId(String userId) {
    if (_currentUserId != userId) {
      print('[EventProvider] User switched from $_currentUserId to $userId');
      _currentUserId = userId;
      // ⚠️ Ne pas reset _hasLoadedInitial ici, laissez loadEvents() gérer
      _events.clear(); // Vider les events du user précédent
      notifyListeners();
    }
  }

  // Force reset of loaded flag for testing
  void resetLoadedFlag() {
    _hasLoadedInitial = false;
    print('[EventProvider] Reset hasLoadedInitial flag');
  }

  Future<void> loadEvents() async {
    // Si utilisateur vide, ne pas charger
    if (_currentUserId.isEmpty) {
      print('[EventProvider] No user ID set, skipping load');
      return;
    }
    
    // Prevent reloading if already loaded for THIS user
    if (_hasLoadedInitial && _events.isNotEmpty) {
      print('[EventProvider] Events already loaded for user $_currentUserId, skipping reload');
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    await PerformanceService.instance.measureAsync(
      'EventProvider.loadEvents',
      () async {
        try {
          _events = await DatabaseService.instance.readAllEventsByUserId(_currentUserId);
          _hasLoadedInitial = true;
          print('✓ EventProvider loaded ${_events.length} events for user $_currentUserId');
        } catch (e) {
          print('✗ Error loading events: $e');
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      },
    );
  }

  Future<void> addEvent(Event event) async {
    await PerformanceService.instance.measureAsync(
      'EventProvider.addEvent',
      () async {
        try {
          // Ajouter l'UID utilisateur à l'événement
          final eventWithUserId = event.copyWith(userId: _currentUserId);
          final newEvent = await DatabaseService.instance.create(eventWithUserId);
          _events.add(newEvent);
          
          // Programmer une notification pour l'événement
          await NotificationService.instance.scheduleEventReminder(
            newEvent,
            reminderBefore: const Duration(hours: 1),
          );
          
          notifyListeners();
        } catch (e) {
          print('Error adding event: $e');
        }
      },
    );
  }

  Future<void> updateEvent(Event event) async {
    try {
      await DatabaseService.instance.update(event);
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
        
        // Reprogrammer la notification pour la nouvelle date/heure
        await NotificationService.instance.cancelEventReminder(event.id!);
        await NotificationService.instance.scheduleEventReminder(
          event,
          reminderBefore: const Duration(hours: 1),
        );
        
        notifyListeners();
      }
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      // Annuler la notification
      await NotificationService.instance.cancelEventReminder(id);
      
      await DatabaseService.instance.delete(id);
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> deleteAllEvents() async {
    try {
      // Annuler toutes les notifications
      await NotificationService.instance.cancelAll();
      
      await DatabaseService.instance.deleteAllEventsByUserId(_currentUserId);
      _events.clear();
      notifyListeners();
    } catch (e) {
      print('Error deleting all events: $e');
    }
  }

  Future<void> toggleEventStatus(Event event) async {
    final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
    await updateEvent(updatedEvent);
  }
}
