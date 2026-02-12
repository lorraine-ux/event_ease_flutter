import 'package:flutter/foundation.dart';

/// Service pour mesurer et logger les performances de l'application
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  
  PerformanceService._internal();

  factory PerformanceService() {
    return _instance;
  }

  static PerformanceService get instance => _instance;

  final Map<String, Stopwatch> _stopwatches = {};

  /// Commence à mesurer le temps pour une opération
  void startMeasure(String operationName) {
    if (!kDebugMode) return;
    
    _stopwatches[operationName] = Stopwatch()..start();
    print('[Perf] ⏱️  Starting: $operationName');
  }

  /// Arrête la mesure et affiche le temps écoulé
  void endMeasure(String operationName) {
    if (!kDebugMode) return;
    
    final stopwatch = _stopwatches[operationName];
    if (stopwatch == null) {
      print('[Perf] ⚠️  No stopwatch found for: $operationName');
      return;
    }

    stopwatch.stop();
    final elapsedMs = stopwatch.elapsedMilliseconds;
    final elapsedUs = stopwatch.elapsedMicroseconds;

    // Colorer selon le temps d'exécution
    String indicator = '✅';
    if (elapsedMs > 1000) {
      indicator = '🟡'; // Lent
    } else if (elapsedMs > 100) {
      indicator = '🟠'; // Très lent
    } else if (elapsedMs > 16) {
      indicator = '🔴'; // Peut bloquer 60fps (1000ms / 60fps ≈ 16ms)
    }

    print('[Perf] $indicator $operationName: ${elapsedMs}ms (${elapsedUs}μs)');
    _stopwatches.remove(operationName);
  }

  /// Mesure le temps d'exécution d'une fonction
  Future<T> measureAsync<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    startMeasure(operationName);
    try {
      final result = await operation();
      endMeasure(operationName);
      return result;
    } catch (e) {
      print('[Perf] ❌ Error in $operationName: $e');
      endMeasure(operationName);
      rethrow;
    }
  }

  /// Mesure le temps d'exécution d'une fonction synchrone
  T measureSync<T>(
    String operationName,
    T Function() operation,
  ) {
    startMeasure(operationName);
    try {
      final result = operation();
      endMeasure(operationName);
      return result;
    } catch (e) {
      print('[Perf] ❌ Error in $operationName: $e');
      endMeasure(operationName);
      rethrow;
    }
  }

  /// Affiche les statistiques de mémoire
  void logMemoryStats() {
    if (!kDebugMode) return;
    print('[Perf] 💾 Memory check requested - see DevTools Memory profiler');
  }
}
