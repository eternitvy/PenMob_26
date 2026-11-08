import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({
    super.key,
    required this.id,
    this.title,
    this.body,
  });

  final String id;
  // Tambahkan parameter opsional untuk menerima data dinamis (jika dikirim via router/extras)
  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    // Gunakan data dari parameter, atau fallback ke teks default jika dibuka manual/deep link langsung
    final displayTitle = title ?? 'Pengumuman #$id';
    final displayBody = body ?? 
        'Halaman ini dibuka lewat deep link (data.route) dari '
        'notifikasi FCM atau dari daftar di beranda.';

    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(Routes.home),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              displayBody,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'ID Pengumuman: $id',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}