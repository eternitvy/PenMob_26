import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../messaging/push_service.dart';
import 'auth_provider.dart';

/// false bila google-services.json / GoogleService-Info.plist belum dipasang.
/// Login + secure storage tetap berjalan; fitur FCM dinonaktifkan.
/// Nilai sebenarnya di-override di main().
final firebaseReadyProvider = Provider<bool>((ref) => false);

/// Status inisialisasi FCM setelah login: izin + token + topik.
enum PushStatus { firebaseNotConfigured, permissionDenied, ready }

final pushSetupProvider = FutureProvider<PushStatus>((ref) async {
  if (!ref.watch(firebaseReadyProvider)) return PushStatus.firebaseNotConfigured;

  final granted = await requestNotificationPermission();
  if (!granted) return PushStatus.permissionDenied;

  final dio = ref.read(apiClientProvider);
  await initFcmToken(onToken: (token) async {
    // Token dikirim lewat body POST HTTPS, tidak pernah lewat query URL.
    await dio.post('/devices', data: {
      'fcm_token': token,
      'platform': Platform.isIOS ? 'ios' : 'android',
    });
  });
  return PushStatus.ready;
});
