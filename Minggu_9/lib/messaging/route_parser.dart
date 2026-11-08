import '../routes.dart';

/// Fungsi murni: data payload FCM -> rute GoRouter.
/// Bisa diunit-test tanpa Firebase.
String routeFromMessage(Map<String, dynamic> data) {
  final raw = data['route'];
  if (raw is String && raw.trim().isNotEmpty) {
    final route = raw.trim();
    return route.startsWith('/') ? route : '/$route';
  }
  final id = data['id'];
  if (id is String && id.isNotEmpty) return Routes.announcementOf(id);
  return Routes.home;
}
