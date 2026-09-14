import 'package:flutter/material.dart';
import 'mahasiswa.dart';
import 'lirik.dart';

void main() {
  runApp(const Regita());
}

// 1. MaterialApp
class Regita extends StatelessWidget {
  const Regita({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Custom: Baby Blue & Beige
    const babyBlue = Color(0xFFAEC6CF);
    const beige = Color(0xFFF5F5DC);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Lirik Lagu',
      theme: ThemeData(
        scaffoldBackgroundColor: beige,
        primaryColor: babyBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: babyBlue,
          foregroundColor: Colors.black87,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: babyBlue,
          primary: babyBlue,
          surface: beige,
        ),
        useMaterial3: true,
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
  // Instansiasi dari file mahasiswa.dart & lirik.dart
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

  // State untuk widget interaktif
  double _fontSize = 15.0;
  bool _isFavorite = false;
  bool _darkTheme = false;
  int _audioQuality = 1;
  final TextEditingController _commentController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // 2. SafeArea
    return SafeArea(
      // 3. Scaffold
      child: Scaffold(
        // 4. AppBar
        appBar: AppBar(
          title: Text(liriklagu1.judul),
          actions: [
            // 5. IconButton
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),

        // 6. Drawer
        drawer: Drawer(
          backgroundColor: const Color(0xFFFAF0E6), // Linen/Beige terang
          // 7. ListView
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFAEC6CF)),
                accountName: Text(
                  mahasiswa1.nama,
                  style: const TextStyle(color: Colors.black87),
                ),
                accountEmail: Text(
                  'Kelas: \({mahasiswa1.kelas} (\){mahasiswa1.umur} th)',
                  style: const TextStyle(color: Colors.black87),
                ),
                // 8. CircleAvatar
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color(0xFFF5F5DC),
                  child: Text(
                    mahasiswa1.nama[0],
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.music_note, color: Colors.black87),
                title: Text('Daftar Lirik'),
              ),
            ],
          ),
        ),

        // 9. CustomScrollView
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              // 10. Scrollbar & 11. SingleChildScrollView
              child: Scrollbar(
                child: SingleChildScrollView(
                  // 12. Padding
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // 13. Row (Membuat 2 Kolom: Kiri untuk Gambar, Kanan untuk Lirik)
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================= KOLOM KIRI (GAMBAR & INFO) =================
                        // 14. Expanded (Kolom Kiri)
                        Expanded(
                          flex: 1,
                          // 15. Column
                          child: Column(
                            children: [
                              // 16. Card
                              Card(
                                color: const Color(0xFFE8F1F5), // Light Baby Blue Tint
                                elevation: 3,
                                // 17. Container
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      // 18. Stack
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // 19. Image
                                          Image.network(
                                            'https://picsum.photos/300/300',
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              height: 180,
                                              color: const Color(0xFFAEC6CF),
                                              // 20. Center
                                              child: const Center(
                                                // 21. Icon
                                                child: Icon(
                                                  Icons.album,
                                                  size: 70,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Positioned(
                                            bottom: 8,
                                            right: 8,
                                            // 22. ImageIcon
                                            child: ImageIcon(
                                              AssetImage('assets/icon.png'),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // 23. Hero
                                      Hero(
                                        tag: 'title',
                                        child: Material(
                                          color: Colors.transparent,
                                          // 24. Text & 25. TextStyle
                                          child: Text(
                                            liriklagu1.judul,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Color(0xFFAEC6CF),
                                            child: Text(
                                              'K',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          // 26. SizedBox
                                          const SizedBox(width: 8),
                                          // 27. Flexible
                                          Flexible(
                                            child: Text(
                                              liriklagu1.penyanyi,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Form Interaksi Komentar di Kolom Kiri
                              // 28. Form
                              Form(
                                child: Column(
                                  children: [
                                    // 29. TextField
                                    const TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Cari Judul Lain',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // 30. TextFormField
                                    TextFormField(
                                      controller: _commentController,
                                      decoration: const InputDecoration(
                                        labelText: 'Tulis Komentar',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 31. ButtonBar
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: [
                                  // 32. OutlinedButton
                                  OutlinedButton(
                                    onPressed: () => _commentController.clear(),
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),

                              // 33. Wrap
                              Wrap(
                                spacing: 6.0,
                                children: const [
                                  Chip(
                                    label: Text('#Pop'),
                                    backgroundColor: Color(0xFFAEC6CF),
                                  ),
                                  Chip(
                                    label: Text('#Acoustic'),
                                    backgroundColor: Color(0xFFAEC6CF),
                                  ),
                                  Chip(
                                    label: Text('#Indie'),
                                    backgroundColor: Color(0xFFAEC6CF),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16), // Jarak Antar Kolom

                        // ================= KOLOM KANAN (LIRIK & KONTROL) =================
                        // 34. Expanded (Kolom Kanan)
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pengaturan Teks & Fitur
                              Row(
                                children: [
                                  const Text('Font: '),
                                  Expanded(
                                    // 35. Slider
                                    child: Slider(
                                      value: _fontSize,
                                      min: 12.0,
                                      max: 22.0,
                                      activeColor: const Color(0xFFAEC6CF),
                                      onChanged: (val) => setState(() => _fontSize = val),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Gelap:'),
                                  // 36. Switch
                                  Switch(
                                    value: _darkTheme,
                                    activeColor: const Color(0xFFAEC6CF),
                                    onChanged: (val) => setState(() => _darkTheme = val),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('Favorit:'),
                                  // 37. Checkbox
                                  Checkbox(
                                    value: _isFavorite,
                                    activeColor: const Color(0xFFAEC6CF),
                                    onChanged: (val) =>
                                        setState(() => _isFavorite = val ?? false),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Kualitas: '),
                                  // 38. Radio
                                  Radio(
                                    value: 1,
                                    groupValue: _audioQuality,
                                    activeColor: const Color(0xFFAEC6CF),
                                    onChanged: (val) => setState(() => _audioQuality = val!),
                                  ),
                                  const Text('SD'),
                                  Radio(
                                    value: 2,
                                    groupValue: _audioQuality,
                                    activeColor: const Color(0xFFAEC6CF),
                                    onChanged: (val) => setState(() => _audioQuality = val!),
                                  ),
                                  const Text('HD'),
                                ],
                              ),

                              // 39. Align
                              Align(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Lirik Lagu:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 40. RichText (Tampilan Lirik)
                              Card(
                                color: const Color(0xFFFAF0E6),
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: _fontSize,
                                        height: 1.5,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: liriklagu1.isiLirik,
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 41. GridView
                              SizedBox(
                                height: 80,
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  children: List.generate(
                                    3,
                                    (index) => Card(
                                      color: const Color(0xFFE8F1F5),
                                      child: Center(
                                        child: Text(
                                          'Album ${index + 1}',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // 42. PageView
                              SizedBox(
                                height: 50,
                                child: PageView(
                                  controller: _pageController,
                                  children: [
                                    Container(
                                      color: const Color(0xFFAEC6CF),
                                      child: const Center(
                                        child: Text(
                                          'Info 1: Geser ke samping',
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: const Color(0xFFD3D3D3),
                                      child: const Center(
                                        child: Text(
                                          'Info 2: Rekomendasi Lirik',
                                          style: TextStyle(color: Colors.black87, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // 43. FloatingActionButton
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFAEC6CF),
          onPressed: () {
            // 44. BottomSheet
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFFF5F5DC),
              builder: (context) => Container(
                padding: const EdgeInsets.all(16.0),
                height: 150,
                child: Column(
                  children: [
                    Text('Diputar oleh: ${mahasiswa1.nama}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAEC6CF),
                        foregroundColor: Colors.white,
                      ),
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