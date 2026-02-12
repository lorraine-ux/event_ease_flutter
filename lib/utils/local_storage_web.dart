// Web-specific implementation of local storage
// This file is only used on web platforms
import 'dart:html';
import 'dart:convert';
import '../models/event.dart';

class LocalStorageWeb {
  static const String _eventsKey = 'event_ease_events';
  static const int _maxAttempts = 3;

  static void saveEvents(List<Event> events) {
    int attempts = 0;
    while (attempts < _maxAttempts) {
      try {
        final jsonData = jsonEncode(events.map((e) => e.toMap()).toList());
        window.localStorage[_eventsKey] = jsonData;
        
        // Verify immediately
        final verifyData = window.localStorage[_eventsKey];
        if (verifyData == jsonData) {
          print('[✅ LocalStorageWeb] Saved ${events.length} events safely');
          print('[📦 LocalStorageWeb] Data size: ${jsonData.length} bytes');
          print('[💾 LocalStorageWeb] Storage quota: ${window.localStorage.length} items');
          return;
        } else {
          print('[⚠️ LocalStorageWeb] Verification failed on attempt ${attempts + 1}');
        }
      } catch (e) {
        print('[❌ LocalStorageWeb] Save error (attempt ${attempts + 1}): $e');
      }
      attempts++;
    }
    print('[❌ LocalStorageWeb] Failed to save after $_maxAttempts attempts!');
  }

  static List<Event> loadEvents() {
    try {
      final jsonData = window.localStorage[_eventsKey];
      if (jsonData != null && jsonData.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonData);
        final events = decoded.map((e) => Event.fromMap(e as Map<String, dynamic>)).toList();
        print('[✅ LocalStorageWeb] Loaded ${events.length} events from persistence');
        return events;
      } else {
        print('[📭 LocalStorageWeb] No saved events found (first run or cleared)');
      }
    } catch (e) {
      print('[❌ LocalStorageWeb] Load error: $e');
    }
    return [];
  }

  static void clearEvents() {
    try {
      window.localStorage.remove(_eventsKey);
      print('[✅ LocalStorageWeb] Deletion confirmed');
    } catch (e) {
      print('[❌ LocalStorageWeb] Clear error: $e');
    }
  }

  // Check storage health
  static String getStorageInfo() {
    try {
      final jsonData = window.localStorage[_eventsKey];
      final size = jsonData?.length ?? 0;
      final itemCount = window.localStorage.length;
      return 'Storage: $size bytes in $_eventsKey, ${itemCount} total items in storage';
    } catch (e) {
      return 'Storage error: $e';
    }
  }
}
