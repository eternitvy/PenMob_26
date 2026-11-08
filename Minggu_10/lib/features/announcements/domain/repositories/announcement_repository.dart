import '../entities/announcement.dart';

abstract interface class AnnouncementRepository {
  List<Announcement> getAll();

  Announcement add(String title, String body);
}
