import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/api_errors.dart';
import '../messaging/push_service.dart';
import '../providers/auth_provider.dart';
import '../providers/push_provider.dart';
import '../routes.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _subscribed = true;
  String? _apiMessage;

  Future<void> _toggleTopic(bool value) async {
    try {
      value ? await subscribeTopic() : await unsubscribeTopic();
      setState(() => _subscribed = value);
    } catch (e) {
      _snack('Gagal ubah langganan: ${friendlyErrorMessage(e)}');
    }
  }

  Future<void> _callApi() async {
    setState(() => _apiMessage = 'Memanggil API...');
    try {
      await ref.read(apiClientProvider).get('/announcements');
      setState(() => _apiMessage = 'Berhasil');
    } catch (e) {
      // UI hanya menerima pesan ramah, bukan exception mentah.
      setState(() => _apiMessage = friendlyErrorMessage(e));
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final push = ref.watch(pushSetupProvider);
    final ready = push.value == PushStatus.ready;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman Kampus'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final id in ['1', '2', '3'])
            Card(
              child: ListTile(
                leading: const Icon(Icons.campaign_outlined),
                title: Text('Pengumuman #$id'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(Routes.announcementOf(id)),
              ),
            ),
          const SizedBox(height: 16),
          Text('Debug', style: Theme.of(context).textTheme.titleMedium),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status FCM: ${push.when(
                    data: (s) => switch (s) {
                      PushStatus.ready => 'siap',
                      PushStatus.permissionDenied => 'izin notifikasi ditolak',
                      PushStatus.firebaseNotConfigured =>
                        'Firebase belum dikonfigurasi',
                    },
                    loading: () => 'menyiapkan...',
                    error: (e, _) => 'gagal: ${friendlyErrorMessage(e)}',
                  )}'),
                  const SizedBox(height: 4),
                  // Token ditampilkan terpotong: jangan pernah tampil penuh.
                  ValueListenableBuilder<String?>(
                    valueListenable: latestFcmToken,
                    builder: (_, token, _) =>
                        Text('FCM token: ${maskToken(token)}'),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Topik $topicPengumuman'),
                    value: _subscribed,
                    onChanged: ready ? _toggleTopic : null,
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => ref.invalidate(pushSetupProvider),
                        child: const Text('Ulangi setup FCM'),
                      ),
                      OutlinedButton(
                        onPressed: _callApi,
                        child: const Text('Tes API (401/offline)'),
                      ),
                    ],
                  ),
                  if (_apiMessage != null) ...[
                    const SizedBox(height: 4),
                    Text('API: $_apiMessage'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
