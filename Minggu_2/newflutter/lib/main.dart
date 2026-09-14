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
          title: Text(liriklagu1.judul),
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
        body: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 150,
                            color: Colors.indigo.shade100,
                            child: const Center(
                              child: Icon(Icons.album, size: 80, color: Colors.indigo),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Hero(
                          tag: 'title',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              liriklagu1.judul,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              child: Text('K', style: TextStyle(fontSize: 10)),
                            ),
                            const SizedBox(width: 8),
                            Text(liriklagu1.penyanyi),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Lirik Lagu:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                SelectableText(
                  liriklagu1.isiLirik,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
          child: const Icon(Icons.info),
        ),
      ),
    );
  }
}