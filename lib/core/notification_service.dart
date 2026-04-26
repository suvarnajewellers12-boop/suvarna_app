import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../features/schemes/data/enrolled_scheme_service.dart';
import 'session_manager.dart';

// Background message handler — must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await NotificationService.showLocalNotification(
    title: message.notification?.title ?? "Suvarna Jewellers",
    body: message.notification?.body ?? "",
  );
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const String _baseUrl =
      "https://suvarna-jewellers-customer-backend.vercel.app";

  // Channel config
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'suvarna_reminders',
    'Suvarna Reminders',
    description: 'Scheme payment reminders and updates',
    importance: Importance.high,
  );

  // ── Initialize everything ──
  static Future<void> initialize() async {
    // 1. Local notifications setup
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);

    // 2. Create notification channel
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);
    // 3. Request FCM permission
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Handle foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(
        title: message.notification?.title ?? "Suvarna Jewellers",
        body: message.notification?.body ?? "",
      );
    });

    // 5. Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // 6. Get and save FCM token
    await _registerFcmToken();
  }

  // ── Get FCM token and send to backend ──
  static Future<void> _registerFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      final authToken = await SessionManager.getToken();
      if (authToken == null) return;

      await http.post(
        Uri.parse("$_baseUrl/api/notifications/register-token"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"fcmToken": token}),
      );

      print("FCM Token registered: $token");
    } catch (e) {
      print("FCM token registration failed: $e");
    }
  }

  // ── Show a local notification ──
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  // ── Check schemes and fire due-date notifications ──
  static Future<void> checkAndNotifyDueDates() async {
    try {
      final schemes = await EnrolledSchemeService.getUserSchemes();
      final today = DateTime.now();

      int notifId = 100; // start from 100 to avoid conflicts

      for (final scheme in schemes) {
        if (scheme.nextDueDate == "Completed") continue;

        final parts = scheme.nextDueDate.split("-");
        if (parts.length != 3) continue;

        final dueDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );

        final diff = dueDate
            .difference(DateTime(today.year, today.month, today.day))
            .inDays;

        // Only notify if within 5 days or overdue
        // Only notify on specific days
        const List<int> notifyDays = [10, 7, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6, -7];
        if (!notifyDays.contains(diff)) continue;

        String title;
        String body;

        if (diff == 10) {
          title = "Scheme Reminder 🔔";
          body = "${scheme.name}: 10 days to your next installment due";
        } else if (diff == 7) {
          title = "Scheme Reminder 🔔";
          body = "${scheme.name}: 7 days to your next installment due";
        } else if (diff == 5) {
          title = "Scheme Reminder 🔔";
          body = "${scheme.name}: 5 days to your next installment due";
        } else if (diff == 4) {
          title = "Scheme Reminder 🔔";
          body = "${scheme.name}: 4 days to your next installment due";
        } else if (diff == 3) {
          title = "Scheme Reminder 🔔";
          body = "${scheme.name}: 3 days to your next installment due";
        } else if (diff == 2) {
          title = "Scheme Reminder 🔔";
          body = "${scheme.name}: 2 days to your next installment due";
        } else if (diff == 1) {
          title = "Payment Due Tomorrow ⚠️";
          body = "${scheme.name}: 1 day to your next installment due";
        } else if (diff == 0) {
          title = "Pay Today! ⚠️";
          body = "${scheme.name}: Today is the last day to pay your installment";
        } else {
          title = "Due Crossed ❌";
          body = "${scheme.name}: Due date crossed. Please visit the store";
        }

        await showLocalNotification(
          title: title,
          body: body,
          id: notifId++,
        );
      }
    } catch (e) {
      print("Due date notification error: $e");
    }
  }
}