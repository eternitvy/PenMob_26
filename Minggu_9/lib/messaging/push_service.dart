import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'route_parser.dart';

const topicPengumuman = 'pengumuman-kampus';

const _channel = AndroidNotificationChannel(
  'pengumuman', // harus sama dengan default_notification_channel_id di Manifest
  'Pengumuman Kampus',
  description: 'Notifikasi pengumuman dari kampus',
  importance:
      Importance.max, // Diubah ke max agar prioritas suara dan pop-up tertinggi
  playSound: true, // Pastikan suara aktif
);

final _local = FlutterLocalNotificationsPlugin();

/// Token FCM terakhir, untuk ditampilkan (terpotong) di halaman Debug.
final latestFcmToken = ValueNotifier<String?>(null);

/// Deep link yang menunggu router siap (mis. klik banner sebelum router ada).
String? pendingDeepLink;
void Function(String route)? _navigate;

/// Token tidak boleh tampil/log penuh: 12 karakter pertama + ...
String maskToken(String? token) {
  if (token == null || token.isEmpty) return '-';
  return token.length <= 12 ? '$token...' : '${token.substring(0, 12)}...';
}

// ---------------------------------------------------------------------------
// Background handler: WAJIB fungsi top-level, berjalan di isolate terpisah.
// ---------------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] background message id=${message.messageId}');
}

void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

// ---------------------------------------------------------------------------
// Permission + local notifications
// ---------------------------------------------------------------------------
Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
  );
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  await _local.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
    onDidReceiveNotificationResponse: (response) {
      final route = response.payload;
      if (route != null) _goOrQueue(route);
    },
  );

  // Android 8+: channel high/max-importance agar banner heads-up & suara muncul.
  await _local
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(_channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: true,
    sound: false,
  );

  final launch = await _local.getNotificationAppLaunchDetails();
  if (launch?.didNotificationLaunchApp ?? false) {
    pendingDeepLink = launch!.notificationResponse?.payload;
  }
}

// ---------------------------------------------------------------------------
// Token lifecycle
// ---------------------------------------------------------------------------
StreamSubscription<String>? _tokenRefreshSub;

Future<void> initFcmToken({
  required Future<void> Function(String token) onToken,
}) async {
  Future<void> handle(String token) async {
    latestFcmToken.value = token;
    debugPrint('[FCM] token=${maskToken(token)}');
    try {
      await onToken(token);
    } catch (e) {
      debugPrint('[FCM] gagal kirim token ke backend: $e');
    }
  }

  // ignore: deprecated_member_use
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) await handle(token);

  await _tokenRefreshSub?.cancel();
  // ignore: deprecated_member_use
  _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(handle);

  await subscribeTopic();
}

Future<void> subscribeTopic() =>
    FirebaseMessaging.instance.subscribeToTopic(topicPengumuman);

Future<void> unsubscribeTopic() =>
    FirebaseMessaging.instance.unsubscribeFromTopic(topicPengumuman);

// ---------------------------------------------------------------------------
// Tiga app state: foreground, background (klik), terminated (klik)
// ---------------------------------------------------------------------------
void listenForeground(
  void Function(String route) go, {
  void Function(String title, String body)? onNewMessage,
}) {
  _navigate = go;

  FirebaseMessaging.onMessage.listen((message) async {
    final route = routeFromMessage(message.data);
    final title = message.notification?.title ?? 'Pengumuman Kampus';
    final body = message.notification?.body ?? '';

    // Panggil callback untuk memasukkan pesan baru ke state list aplikasi
    if (onNewMessage != null) {
      onNewMessage(title, body);
    }

    // Konfigurasi Detail Notifikasi Lokal dengan Suara & Prioritas Tertinggi
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _local.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: details,
      payload: route,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    go(routeFromMessage(message.data));
  });
}

Future<void> handleTerminated(void Function(String route) go) async {
  _navigate = go;
  final initial = await FirebaseMessaging.instance.getInitialMessage();
  if (initial != null) go(routeFromMessage(initial.data));
  final pending = pendingDeepLink;
  if (pending != null) {
    pendingDeepLink = null;
    go(pending);
  }
}

void _goOrQueue(String route) {
  final go = _navigate;
  if (go != null) {
    go(route);
  } else {
    pendingDeepLink = route;
  }
}