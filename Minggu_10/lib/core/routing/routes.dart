/// Satu sumber kebenaran untuk string rute. Dipakai GoRouter dan deep link FCM.
abstract final class Routes {
  static const home = '/';
  static const login = '/login';
  static const announcement = '/pengumuman/:id';

  static String announcementOf(String id) => '/pengumuman/$id';
}
