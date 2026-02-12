import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import '../models/event.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  bool _notificationsEnabled = false;

  NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  static NotificationService get instance => _instance;

  Future<void> initialize() async {
    // Initialiser timezone
    tzdata.initializeTimeZones();

    // Initialiser les notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print('[Notification iOS] Reçue: $title - $body');
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // Demander les permissions sur iOS et Android 13+
    await _requestPermissions();

    print('[NotificationService] ✓ Notifications initialisées');
  }

  Future<void> _requestPermissions() async {
    // Permissions iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _handleNotificationTap(
    NotificationResponse notificationResponse,
  ) async {
    print('[Notification] Tapée: ${notificationResponse.payload}');
  }

  Future<void> enableNotifications(bool enable) async {
    _notificationsEnabled = enable;
    print('[NotificationService] Notifications ${enable ? 'activées' : 'désactivées'}');
  }

  bool get isEnabled => _notificationsEnabled;

  /// Programme une notification pour un événement
  Future<void> scheduleEventReminder(Event event, {Duration reminderBefore = const Duration(hours: 1)}) async {
    if (!_notificationsEnabled) {
      print('[NotificationService] Notifications désactivées, rappel non programmé');
      return;
    }

    try {
      final scheduledTime = event.date.subtract(reminderBefore);
      
      // Ne pas programmer une notification dans le passé
      if (scheduledTime.isBefore(DateTime.now())) {
        print('[NotificationService] Heure de rappel dans le passé, non programmée');
        return;
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        event.id!.hashCode,
        'Rappel: ${event.title}',
        'Votre événement commence dans ${reminderBefore.inMinutes} minutes',
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          android: const AndroidNotificationDetails(
            'event_reminder_channel',
            'Rappels d\'événements',
            channelDescription: 'Notifications de rappels pour les événements',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'event_${event.id}',
      );

      print('[NotificationService] ✓ Rappel programmé pour: ${event.title} à $scheduledTime');
    } catch (e) {
      print('[NotificationService] ✗ Erreur lors de la programmation: $e');
    }
  }

  /// Annule un rappel programmé
  Future<void> cancelEventReminder(int eventId) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(eventId.hashCode);
      print('[NotificationService] ✓ Rappel annulé pour l\'événement: $eventId');
    } catch (e) {
      print('[NotificationService] ✗ Erreur lors de l\'annulation: $e');
    }
  }

  /// Affiche une notification immédiate
  Future<void> showInstantNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        NotificationDetails(
          android: const AndroidNotificationDetails(
            'instant_notification_channel',
            'Notifications instantanées',
            channelDescription: 'Notifications immédiates',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload,
      );
      print('[NotificationService] ✓ Notification instantanée affichée: $title');
    } catch (e) {
      print('[NotificationService] ✗ Erreur lors de l\'affichage: $e');
    }
  }

  /// Annule toutes les notifications
  Future<void> cancelAll() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print('[NotificationService] ✓ Toutes les notifications annulées');
    } catch (e) {
      print('[NotificationService] ✗ Erreur lors de l\'annulation de tout: $e');
    }
  }
}
