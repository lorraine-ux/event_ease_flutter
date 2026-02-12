import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/event.dart';
import '../utils/local_storage.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  static List<Event> _memoryEvents = []; // In-memory fallback for web
  static bool _useMemoryStorage = false;
  static bool _initialized = false;

  DatabaseService._init();

  // Method to set memory storage mode before initialization
  static void setUseMemoryStorage(bool value) {
    _useMemoryStorage = value;
  }

  // Override initialization to load from localStorage if using memory storage
  static Future<void> init() async {
    if (_initialized) return;
    if (_useMemoryStorage) {
      print('[🔄 DatabaseService] Loading events from localStorage...');
      _memoryEvents = await LocalStorage.loadEvents();
      print('[✅ DatabaseService] Loaded ${_memoryEvents.length} events into memory');
      print('[📊 DatabaseService] Event count by user:');
      final userCounts = <String, int>{};
      for (var event in _memoryEvents) {
        userCounts[event.userId] = (userCounts[event.userId] ?? 0) + 1;
      }
      userCounts.forEach((userId, count) {
        print('   - User $userId: $count events');
      });
    }
    _initialized = true;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (_useMemoryStorage) {
      // Return a dummy database object when using memory storage
      // The database is never actually used when _useMemoryStorage is true
      return Future.error('Using in-memory storage, database not available');
    }
    try {
      _database = await _initDB('events.db');
    } catch (e) {
      print('Database initialization failed, using in-memory storage: $e');
      _useMemoryStorage = true;
      return Future.error('Database unavailable, using in-memory storage');
    }
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE events ( 
  id $idType, 
  userId $textType,
  title $textType,
  description $textType,
  date $textType,
  isCompleted $boolType,
  category $textType,
  location $textType,
  reminderMinutes INTEGER
  )
''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE events ADD COLUMN category TEXT DEFAULT "Autre"');
      await db.execute('ALTER TABLE events ADD COLUMN location TEXT DEFAULT ""');
      await db.execute('ALTER TABLE events ADD COLUMN reminderMinutes INTEGER');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE events ADD COLUMN userId TEXT DEFAULT ""');
    }
  }

  Future<Event> create(Event event) async {
    if (_useMemoryStorage) {
      // Generate unique ID if not provided
      int newId = (event.id ?? 0);
      if (newId == 0) {
        newId = _memoryEvents.isEmpty ? 1 : (_memoryEvents.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      }
      final newEvent = event.copyWith(id: newId);
      // Check if event with this ID already exists to prevent duplicates
      if (!_memoryEvents.any((e) => e.id == newId)) {
        _memoryEvents.add(newEvent);
        // Save immediately with verification
        await _persistEvents();
        print('[✅ DatabaseService.create] Event created: "${newEvent.title}" (ID=$newId, User=${newEvent.userId})');
        print('[💾 DatabaseService.create] Total events: ${_memoryEvents.length}');
      } else {
        print('[⚠️ DatabaseService.create] Event already exists: ID=$newId');
      }
      return newEvent;
    }
    final db = await instance.database;
    final id = await db.insert('events', event.toMap());
    return event.copyWith(id: id);
  }

  // Helper method to persist events with verification
  Future<void> _persistEvents() async {
    if (_useMemoryStorage) {
      await LocalStorage.saveEvents(_memoryEvents);
      // Verify save by immediately reloading
      final reloadedEvents = await LocalStorage.loadEvents();
      if (reloadedEvents.length != _memoryEvents.length) {
        print('[⚠️ Persist Error] Data mismatch! Saved: ${_memoryEvents.length}, Reloaded: ${reloadedEvents.length}');
      } else {
        print('[✓ Persist verified] ${_memoryEvents.length} events safely persisted');
      }
    }
  }

  // Get persistence status summary
  Future<String> getPersistenceStatus() async {
    if (!_useMemoryStorage) {
      return '[📊 Database Status] Using SQLite database';
    }
    
    final reloadedEvents = await LocalStorage.loadEvents();
    final userCounts = <String, int>{};
    for (var event in _memoryEvents) {
      userCounts[event.userId] = (userCounts[event.userId] ?? 0) + 1;
    }
    
    final status = StringBuffer();
    status.writeln('[📊 Database Status]');
    status.writeln('  Storage: Web LocalStorage (JSON)');
    status.writeln('  Total events in memory: ${_memoryEvents.length}');
    status.writeln('  Total events persisted: ${reloadedEvents.length}');
    status.writeln('  Status: ${reloadedEvents.length == _memoryEvents.length ? '✅ HEALTHY' : '⚠️ MISMATCH'}');
    status.writeln('  Events by user:');
    userCounts.forEach((userId, count) {
      status.writeln('    - $userId: $count events');
    });
    
    return status.toString();
  }

  Future<Event> readEvent(int id) async {
    if (_useMemoryStorage) {
      return _memoryEvents.firstWhere((e) => e.id == id,
          orElse: () => throw Exception('ID $id not found'));
    }
    final db = await instance.database;
    final maps = await db.query(
      'events',
      columns: ['id', 'title', 'description', 'date', 'isCompleted', 'category', 'location', 'reminderMinutes'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Event>> readAllEvents() async {
    if (_useMemoryStorage) {
      // Ensure initialized - will load from localStorage on first call
      if (!_initialized) {
        await init();
      }
      print('[DatabaseService.readAllEvents] ✓ Returning ${_memoryEvents.length} events from memory');
      return List<Event>.from(_memoryEvents);
    }
    final db = await instance.database;
    final orderBy = 'date ASC';
    final result = await db.query('events', orderBy: orderBy);

    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<List<Event>> readAllEventsByUserId(String userId) async {
    if (_useMemoryStorage) {
      // Ensure initialized - will load from localStorage on first call
      if (!_initialized) {
        await init();
      }
      final userEvents = _memoryEvents.where((e) => e.userId == userId).toList();
      print('[DatabaseService.readAllEventsByUserId] ✓ Returning ${userEvents.length} events for user $userId');
      return userEvents;
    }
    final db = await instance.database;
    final orderBy = 'date ASC';
    final result = await db.query(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: orderBy,
    );

    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<int> update(Event event) async {
    if (_useMemoryStorage) {
      final index = _memoryEvents.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _memoryEvents[index] = event;
        await _persistEvents();
        print('[✅ DatabaseService.update] Event updated: "${event.title}" (ID=${event.id}, User=${event.userId})');
        return 1;
      }
      print('[⚠️ DatabaseService.update] Event not found: ID=${event.id}');
      return 0;
    }
    final db = await instance.database;
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    if (_useMemoryStorage) {
      final initialLength = _memoryEvents.length;
      final index = _memoryEvents.indexWhere((e) => e.id == id);
      if (index != -1) {
        final deletedEvent = _memoryEvents[index];
        _memoryEvents.removeAt(index);
        await _persistEvents();
        print('[✅ DatabaseService.delete] Event deleted: "${deletedEvent.title}" (ID=$id)');
        print('[📊 DatabaseService.delete] Remaining events: ${_memoryEvents.length}');
      }
      return initialLength - _memoryEvents.length;
    }
    final db = await instance.database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllEvents() async {
    if (_useMemoryStorage) {
      final initialLength = _memoryEvents.length;
      _memoryEvents.clear();
      if (initialLength > 0) {
        await LocalStorage.clearEvents();
        print('[✅ DatabaseService.deleteAllEvents] Deleted all $initialLength events');
      }
      return initialLength;
    }
    final db = await instance.database;
    return await db.delete('events');
  }

  Future<int> deleteAllEventsByUserId(String userId) async {
    if (_useMemoryStorage) {
      final initialLength = _memoryEvents.length;
      _memoryEvents.removeWhere((e) => e.userId == userId);
      final deletedCount = initialLength - _memoryEvents.length;
      if (deletedCount > 0) {
        await _persistEvents();
        print('[✅ DatabaseService.deleteAllEventsByUserId] Deleted $deletedCount events for user $userId');
        print('[📊 DatabaseService.deleteAllEventsByUserId] Remaining events: ${_memoryEvents.length}');
      }
      return deletedCount;
    }
    final db = await instance.database;
    return await db.delete(
      'events',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
