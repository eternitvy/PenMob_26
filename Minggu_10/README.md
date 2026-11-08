# 06 — Authentication, Security & FCM (Campus Notification App)

Implementasi codelab [#06 Authentication, Security & FCM](https://jti-polinema.github.io/flutter-codelab/06-minggu-6-authentication-security-fcm/index.html).

## Fitur utama

- **Guard route** GoRouter: belum login selalu ke `/login`.
- Access & refresh token hanya di **flutter_secure_storage** (Keychain/Keystore), tidak pernah di SharedPreferences.
- **Dio interceptor**: 401 -> refresh token sekali -> ulangi request; refresh gagal -> token dihapus, kembali ke `/login`.
- **FCM**: izin notifikasi, `getToken` + `onTokenRefresh` dikirim ke `POST /devices`, langganan topik `pengumuman-kampus`.
- Payload gabungan `notification` + `data`; klik membuka `/pengumuman/:id` pada state foreground, background, dan terminated.
- Halaman Debug di beranda: status FCM, token **terpotong** (12 karakter + `...`), toggle topik, tes API.

## Stack

Flutter 3.41 · Riverpod · GoRouter · Dio · flutter_secure_storage · firebase_core · firebase_messaging · flutter_local_notifications

## Struktur

```
lib/
├── core/
│   ├── errors/api_errors.dart
│   ├── network/api_client.dart
│   └── routing/routes.dart
├── features/
│   ├── auth/
│   │   ├── data/              # API repository, development repository, secure storage
│   │   ├── domain/            # session, repository contracts, login use case
│   │   └── presentation/      # login page dan auth provider
│   ├── announcements/
│   │   ├── data/              # repository pengumuman in-memory
│   │   ├── domain/            # entity, kontrak repository, use cases
│   │   └── presentation/      # halaman dan provider pengumuman
│   └── notifications/
│       ├── data/              # FCM dan local notification
│       ├── domain/            # parser payload FCM
│       └── presentation/      # provider setup notifikasi
└── main.dart                  # composition root, init Firebase, router + guard
test/
├── auth_push_test.dart
├── api_client_test.dart
└── announcements_test.dart
docs/
├── ai-challenge.md
└── fcm-payload.json
```

Lapisan domain berisi aturan dan kontrak; implementasi API, FCM, serta secure
storage berada di data; UI dan state Riverpod berada di presentation. Login
tetap memakai repository development dengan token dummy untuk mempertahankan
perilaku saat ini. `AuthRepositoryImpl` menyediakan implementasi API untuk
login/refresh.

## Cara menjalankan

1. Buat project di Firebase Console, tambahkan aplikasi Android dengan package
   `id.ac.polinema.campus_notify`, unduh `google-services.json` ke `android/app/`.
   (Plugin `google-services` otomatis aktif bila file itu ada.)
   Untuk iOS: tambahkan `GoogleService-Info.plist`, APNs key, dan capability Push.
2. `flutter pub get`
3. `flutter run` di perangkat fisik / emulator dengan Google Play.
4. Untuk API dan refresh token, atur URL backend yang menyediakan `POST /login`
   dan `POST /refresh`:
   `flutter run --dart-define=API_BASE_URL=https://alamat-api-kampus`.
   Respons login harus memuat `access_token` (atau `token`) dan
   `refresh_token` (atau `refresh`); respons refresh harus memuat token akses.

Nilai `API_BASE_URL` bawaan adalah placeholder dan harus diganti agar API
berfungsi. Login default saat ini tetap memakai repository development dan
token dummy; aktifkan `AuthRepositoryImpl` di provider untuk menggunakan login
backend. Tanpa konfigurasi Firebase, fitur FCM dinonaktifkan.

Kirim uji dari Firebase Console -> Messaging, atau via FCM HTTP v1 memakai
[docs/fcm-payload.json](docs/fcm-payload.json).

## Testing

```
flutter analyze
flutter test
```

Test mencakup parsing route, masking token, login/logout via provider, pemetaan error,
serta interceptor Dio (401 -> refresh sekali -> retry; refresh gagal -> sesi dibersihkan).

## Matriks pengujian tiga app state

Payload: `docs/fcm-payload.json` (notification + `data.route=/pengumuman/3`).

| State | Yang diharapkan | Cara uji | Hasil | Bukti |
|---|---|---|---|---|
| Foreground | Banner lokal muncul, klik masuk ke `/pengumuman/3` | Aplikasi terbuka, kirim dari console/backend | _belum diuji_ | `screenshots/foreground.png` |
| Background | Banner sistem muncul, klik masuk ke rute yang benar | Tekan Home, kirim, klik banner | _belum diuji_ | `screenshots/background.png` |
| Terminated | Aplikasi terbuka ke rute yang benar via `getInitialMessage` | Swipe-close aplikasi, kirim, klik banner | _belum diuji_ | `screenshots/terminated.png` |

## Prinsip keamanan yang diterapkan

- Token tidak di-hardcode, tidak di-log penuh (`maskToken`), tidak tampil penuh di UI.
- Refresh token hanya dikirim lewat body POST HTTPS, tidak lewat query URL.
- Topik untuk broadcast; pesan personal (nilai, tagihan) memakai token perangkat.

## Refleksi

1. Mengapa refresh token tidak boleh disimpan di SharedPreferences? _…_
2. Apa yang rusak bila `onTokenRefresh` diabaikan selama satu semester? _…_
3. Kapan memakai topik vs token perangkat? _…_
4. Bagian draf AI yang ditolak/diperbaiki: lihat [docs/ai-challenge.md](docs/ai-challenge.md).
