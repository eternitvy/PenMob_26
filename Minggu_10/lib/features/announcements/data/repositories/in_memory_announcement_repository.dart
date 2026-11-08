import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';

class InMemoryAnnouncementRepository implements AnnouncementRepository {
  InMemoryAnnouncementRepository()
    : _announcements = [
        Announcement(
          id: '1',
          title: 'Pengumuman #1',
          body: 'Isi pengumuman pertama...',
          timestamp: DateTime.now(),
        ),
        Announcement(
          id: '2',
          title: 'Pengumuman #2',
          body: 'Isi pengumuman kedua...',
          timestamp: DateTime.now(),
        ),
        Announcement(
          id: '3',
          title: 'Pengumuman #3',
          body: 'Isi pengumuman ketiga...',
          timestamp: DateTime.now(),
        ),
      ];

  final List<Announcement> _announcements;

  @override
  List<Announcement> getAll() => List.unmodifiable(_announcements);

  @override
  Announcement add(String title, String body) {
    final announcement = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    _announcements.insert(0, announcement);
    return announcement;
  }
}
