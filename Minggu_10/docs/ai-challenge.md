# AI Challenge — Minggu 6

## 1. Prompt

```
Aplikasi Flutter Campus Notification App.
Stack: firebase_messaging, flutter_local_notifications,
flutter_secure_storage, go_router, Riverpod.
Buatkan PushService dengan:
- requestPermission + getToken + onTokenRefresh (kirim ke POST /devices)
- onMessage (tampilkan local notification manual)
- onMessageOpenedApp + getInitialMessage (navigasi ke data.route)
- subscribe/unsubscribe topic pengumuman-kampus
- background handler top-level dengan @pragma('vm:entry-point')
Tandai bagian yang BERBEDA untuk Android 13+ vs iOS,
dan bagian yang tidak boleh mengakses BuildContext.
```

## 2. Output awal AI

Implementasi awal dibuat dengan AI coding assistant (Claude Code), hasilnya ada di
`lib/messaging/push_service.dart`, `lib/providers/push_provider.dart`, dan `lib/main.dart`.

## 3. Verification checklist

| Pertanyaan | Hasil | Bukti di kode |
|---|---|---|
| Background handler fungsi top-level + `@pragma('vm:entry-point')`? | Ya | `firebaseMessagingBackgroundHandler` di `push_service.dart` |
| `onTokenRefresh` mengirim token baru ke backend (bukan hanya log)? | Ya, lewat callback `onToken` -> `POST /devices` | `initFcmToken` + `pushSetupProvider` |
| Foreground memakai local notification manual? | Ya | `listenForeground` -> `_local.show(...)` |
| Klik dari 3 state masuk ke rute yang benar? | Isi dari hasil uji perangkat (lihat README) | `onMessageOpenedApp`, `getInitialMessage`, `onDidReceiveNotificationResponse` |
| Token/secret tidak di-hardcode dan tidak di-log penuh? | Ya, log memakai `maskToken` (12 karakter + ...) | `maskToken` |

## 4. Perbaikan manual terhadap kode codelab / draf AI

- `routeFromMessage` dipindah ke fungsi murni (`lib/messaging/route_parser.dart`) dan dipakai
  oleh ketiga handler, supaya rute tanpa slash atau kosong tetap valid.
- Interceptor Dio diberi penanda `extra['retried']` supaya retry hanya terjadi **sekali**
  (tanpa itu, 401 setelah refresh bisa memicu loop), plus callback `onSessionExpired` agar
  router langsung pindah ke `/login` saat refresh gagal.
- Klik banner lokal (foreground) langsung menavigasi bila router sudah siap; kalau belum,
  disimpan di `pendingDeepLink`. Kasus aplikasi dibuka dari banner lokal saat terminated
  ditangani lewat `getNotificationAppLaunchDetails()`.
- Channel Android `pengumuman` (importance high) dibuat eksplisit dan didaftarkan sebagai
  `default_notification_channel_id` di Manifest agar banner background/terminated memakai
  channel yang sama.
- iOS: `setForegroundNotificationPresentationOptions(alert: false)` supaya tidak muncul
  **banner ganda** (banner sistem + banner lokal) saat foreground.
- Firebase di-init dalam `try/catch`: tanpa `google-services.json`, login dan secure storage
  tetap berjalan dan status FCM tampil "Firebase belum dikonfigurasi".

## 5. Perbedaan Android 13+ vs iOS

| Aspek | Android 13+ | iOS |
|---|---|---|
| Izin | `POST_NOTIFICATIONS` runtime (Manifest + `requestPermission`) | `requestPermission` (alert/badge/sound) |
| Banner foreground | Tidak otomatis -> local notification | Diatur oleh `setForegroundNotificationPresentationOptions` |
| Prasyarat | `google-services.json` | `GoogleService-Info.plist`, APNs key, capability Push Notifications + Background Modes |

Bagian yang **tidak boleh** mengakses `BuildContext`/Riverpod: `firebaseMessagingBackgroundHandler`
(berjalan di isolate terpisah).

## 6. Keputusan final dan alasan teknis

_(Tulis keputusan Anda sendiri di sini.)_
