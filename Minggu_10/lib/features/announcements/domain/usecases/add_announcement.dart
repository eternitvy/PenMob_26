import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class AddAnnouncement {
  const AddAnnouncement(this._repository);

  final AnnouncementRepository _repository;

  Announcement call(String title, String body) =>
      _repository.add(title, body);
}
