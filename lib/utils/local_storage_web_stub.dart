// Stub implementation for non-web platforms
import '../models/event.dart';

class LocalStorageWeb {
  static const String _eventsKey = 'event_ease_events';

  static void saveEvents(List<Event> events) {
    // No-op on mobile/desktop
  }

  static List<Event> loadEvents() {
    // No-op on mobile/desktop
    return [];
  }

  static void clearEvents() {
    // No-op on mobile/desktop
  }
}
