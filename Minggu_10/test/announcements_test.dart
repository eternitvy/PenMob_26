import 'package:campus_notify/features/announcements/presentation/providers/announcement_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('announcement provider loads initial data and prepends new items', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final initial = container.read(announcementProvider);
    expect(initial, hasLength(3));
    expect(initial.first.title, 'Pengumuman #1');

    container
        .read(announcementProvider.notifier)
        .addAnnouncement('Pembaruan', 'Isi terbaru');

    final updated = container.read(announcementProvider);
    expect(updated, hasLength(4));
    expect(updated.first.title, 'Pembaruan');
    expect(updated.first.body, 'Isi terbaru');
  });
}
