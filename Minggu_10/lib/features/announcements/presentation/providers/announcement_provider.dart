import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/in_memory_announcement_repository.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/usecases/add_announcement.dart';
import '../../domain/usecases/get_announcements.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => InMemoryAnnouncementRepository(),
);

final getAnnouncementsProvider = Provider<GetAnnouncements>(
  (ref) => GetAnnouncements(ref.watch(announcementRepositoryProvider)),
);

final addAnnouncementProvider = Provider<AddAnnouncement>(
  (ref) => AddAnnouncement(ref.watch(announcementRepositoryProvider)),
);

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  AnnouncementNotifier({
    required GetAnnouncements getAnnouncements,
    required AddAnnouncement addAnnouncement,
  }) : _addAnnouncement = addAnnouncement,
       super(getAnnouncements());

  final AddAnnouncement _addAnnouncement;

  void addAnnouncement(String title, String body) {
    final newAnnouncement = _addAnnouncement(title, body);
    state = [newAnnouncement, ...state];
  }
}

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
      return AnnouncementNotifier(
        getAnnouncements: ref.watch(getAnnouncementsProvider),
        addAnnouncement: ref.watch(addAnnouncementProvider),
      );
    });