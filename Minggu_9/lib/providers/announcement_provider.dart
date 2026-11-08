import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement.dart';

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  AnnouncementNotifier() : super([
    // Data dummy awal (pengganti Pengumuman #1 - #3 statis)
    Announcement(id: '1', title: 'Pengumuman #1', body: 'Isi pengumuman pertama...', timestamp: DateTime.now()),
    Announcement(id: '2', title: 'Pengumuman #2', body: 'Isi pengumuman kedua...', timestamp: DateTime.now()),
    Announcement(id: '3', title: 'Pengumuman #3', body: 'Isi pengumuman ketiga...', timestamp: DateTime.now()),
  ]);

  // Fungsi untuk menambahkan pengumuman baru dari FCM
  void addAnnouncement(String title, String body) {
    final newAnnouncement = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    
    // Masukkan ke urutan paling atas list
    state = [newAnnouncement, ...state];
  }
}

// Provider global untuk diakses dari halaman manapun
final announcementProvider = StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
  return AnnouncementNotifier();
});