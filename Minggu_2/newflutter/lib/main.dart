import 'package:flutter/material.dart';
import 'package:newflutter/lirikLagu.dart';
import 'mahasiswa.dart';
import 'lirikLagu.dart';

void main() {
  runApp(const Regita());
}

class Regita extends StatelessWidget {
  const Regita({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE0F7FA), // Warna Baby Blue
      ),
      home: LirikDetailPage(),
    );
  }
}

class LirikDetailPage extends StatelessWidget {
  LirikDetailPage({super.key});

  final mahasiswa1 = mahasiswa(nama: 'Regita', umur: 20, kelas: 'TI3C');
  final liriklagu1 = lirikLagu(
    judul: 'Summer Eyes',
    penyanyi: 'Kwoh Ohyul - Lngshot',
    isiLirik: 'So many nights I was in the cold\n'
        'Sleeping alone here without you\n'
        'And every time I tried to make it home\n'
        'I would be lost in the moonlight\n\n'
        'I heard you calling\n'
        'Just like the leaves up in autumn\n'
        'My heart was hopelessly falling\n'
        'For you\n'
        'Every time\n\n'
        'That I see your summer eyes\n'
        'I\'m in love\n'
        'I swear I\'m in heaven\n'
        'Deeper into your ocean\n'
        'I could stay forever with\n'
        'You\n',
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0288D1), // Biru lebih tua
          title: Text(liriklagu1.judul, style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: '1', child: Text('Pengaturan')),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(mahasiswa1.nama),
                accountEmail: Text('Kelas: \({mahasiswa1.kelas} (\){mahasiswa1.umur} th)'),
                currentAccountPicture: CircleAvatar(
                  child: Text(mahasiswa1.nama[0]),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Daftar Lirik'),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==================== KOLOM KIRI: FULL FOTO ====================
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/image/langit.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.indigo.shade200,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 80, color: Colors.white),
                              SizedBox(height: 8),
                              Text(
                                'Gambar tidak ditemukan',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // ==================== KOLOM KANAN: LIRIK & KONTROL ====================
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header di Kolom Kanan (Warna Biru Tua)
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF01579B), // Biru lebih tua dari background
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              liriklagu1.judul,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              liriklagu1.penyanyi,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Isi Lirik (Rata Kiri / Left Align)
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: SelectableText(
                              liriklagu1.isiLirik,
                              textAlign: TextAlign.left, // Text rata kiri
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ),
                        ),
                      ),

                      // Watermark (Align Right)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'create by regita',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Tombol Kontrol: Previous, Pause, Next di Paling Bawah
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.pause),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0288D1),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(16.0),
                height: 150,
                child: Column(
                  children: [
                    Text('Diputar oleh: ${mahasiswa1.nama}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.info, color: Colors.white),
        ),
      ),
    );
  }
}