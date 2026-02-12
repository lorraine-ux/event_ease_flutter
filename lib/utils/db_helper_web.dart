// Web implementation using in-memory storage as fallback
// since sqflite_sw.js binaries may not be available in dev mode
import '../services/database_service.dart';

Future<void> initializeDatabase() async {
  // On web, we use in-memory storage instead of sqflite
  // This avoids issues with missing worker files in development
  DatabaseService.setUseMemoryStorage(true);
  print('Database initialized for web (in-memory mode)');
}
