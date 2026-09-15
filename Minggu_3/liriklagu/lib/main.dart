import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import package audio
import 'mahasiswa.dart';
import 'lirik.dart';

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
        scaffoldBackgroundColor: const Color(0xFFE0F7FA), // Baby Blue
      ),
      home: const LirikDetailPage(),
    );
  }
}

class LirikDetailPage extends StatefulWidget {
  const LirikDetailPage({super.key});

  @override
  State createState() => _LirikDetailPageState();
}

class _LirikDetailPageState extends State {
  final mahasiswa1 = mahasiswa(nama: 'Regita', umur: 20, kelas: 'TI3C');
  final liriklagu1 = lirik(
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

  // Inisialisasi Audio Player
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  double _sliderValue = 0.3;
  bool _isSwitched = true;
  bool _isChecked = false;
  int _radioSelected = 1;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Mendengarkan status perubahan audio (apakah sedang play atau pause)
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Bersihkan memori saat halaman ditutup
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk Play / Pause Lagu
  Future _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Panggil file lagu dari folder assets (pastikan file lagu ada di assets/audio/lagu.mp3)
        // Atau jika ditaruh di assets/image/ atau folder khusus:
        await _audioPlayer.play(AssetSource('audio/summer_eyes.mp3'));
      }
    } catch (e) {
      print("Error pemutaran audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0288D1),
          title: Text(
            liriklagu1.judul,
            style: const TextStyle(color: Colors.white),
          ),
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: UserAccountsDrawerHeader(
                  accountName: Text(mahasiswa1.nama),
                  accountEmail: Text('Kelas: \({mahasiswa1.kelas} (\){mahasiswa1.umur} th)'),
                  currentAccountPicture: CircleAvatar(
                    child: Text(mahasiswa1.nama[0]),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text('Daftar Lirik'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download),
                        label: const Text('Unduh Lirik'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==================== KOLOM KIRI: FOTO ====================
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: 'albumCover',
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
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          radius: 18,
                          child: ImageIcon(
                            const AssetImage('assets/image/langit.jpg'),
                            size: 20,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      // Header Kolom Kanan
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF01579B),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    liriklagu1.judul,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: 'Penyanyi: ',
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: liriklagu1.penyanyi,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              children: const [
                                Chip(label: Text('#Pop', style: TextStyle(fontSize: 10))),
                                Chip(label: Text('#Acoustic', style: TextStyle(fontSize: 10))),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Body PageView (Lirik & Pengaturan)
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          children: [
                            Scrollbar(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: SelectableText(
                                  liriklagu1.isiLirik,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 15, height: 1.5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Cari Lirik:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    const TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Ketik judul lagu...',
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Catatan Lagu',
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text('Fav:'),
                                        Checkbox(
                                          value: _isChecked,
                                          onChanged: (val) => setState(() => _isChecked = val ?? false),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Auto Scroll:'),
                                        Switch(
                                          value: _isSwitched,
                                          onChanged: (val) => setState(() => _isSwitched = val),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Mode:'),
                                        Radio(
                                          value: 1,
                                          groupValue: _radioSelected,
                                          onChanged: (val) => setState(() => _radioSelected = val!),
                                        ),
                                        const Text('Loop'),
                                        Radio(
                                          value: 2,
                                          groupValue: _radioSelected,
                                          onChanged: (val) => setState(() => _radioSelected = val!),
                                        ),
                                        const Text('Shuffle'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Slider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Slider(
                          value: _sliderValue,
                          onChanged: (val) => setState(() => _sliderValue = val),
                        ),
                      ),

                      // Watermark
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
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

                      // Tombol Kontrol Musik (Fungsional Play/Pause)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: () => _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              ),
                            ),
                            // Tombol Play/Pause Dinamis
                            IconButton(
                              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed: _togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              onPressed: () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              ),
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
                height: 220,
                child: Column(
                  children: [
                    Text('Diputar oleh: ${mahasiswa1.nama}'),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Masukkan komentar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ButtonBar(
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Kirim'),
                        ),
                      ],
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