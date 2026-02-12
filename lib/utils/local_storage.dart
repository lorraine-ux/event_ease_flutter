import 'package:flutter/foundation.dart';
import '../models/event.dart';
import 'local_storage_web.dart' if (dart.library.io) 'local_storage_web_stub.dart' as web_storage;

/// LocalStorage wrapper that uses platform-specific implementations
class LocalStorage {
  /// Save events to localStorage (web only)
  static Future<void> saveEvents(List<Event> events) async {
    if (kIsWeb) {
      web_storage.LocalStorageWeb.saveEvents(events);
    }
  }

  /// Load events from localStorage (web only)
  static Future<List<Event>> loadEvents() async {
    if (kIsWeb) {
      return web_storage.LocalStorageWeb.loadEvents();
    }
    return [];
  }

  /// Clear all events (web only)
  static Future<void> clearEvents() async {
    if (kIsWeb) {
      web_storage.LocalStorageWeb.clearEvents();
    }
  }
}
