import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'mahasiswa.dart';
import 'lirik.dart';

void main() {
  runApp(const RegitaApp());
}

class RegitaApp extends StatelessWidget {
  const RegitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Katalog Lirik Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE0F7FA), 
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
  // Data Model
  final mahasiswa1 = mahasiswa(nama: 'Regita', umur: 20, kelas: 'TI3C');
  final liriklagu1 = lirik(
    judul: 'Everytime',
    penyanyi: 'Ariana Grande',
    isiLirik: 
    'Back to you, back to you, back to you\n'
    'Back to you, back to you, back to you\n'
    'I go back to you, back to you, back to you every time\n\n'

    'I get tired of your no-shows\n'
    'You get tired of my control\n'
    'They keep telling me to let go\n'
    'But I don\'t really let go when I say so\n'
    'I keep giving people blank stares\n'
    'I\'m so different when you\'re not there\n'
    'It\'s like something out of Shakespeare\n'
    'Because I\'m really not here when you\'re not there\n\n'

    'I\'ve tried to fight our energy\n'
    'But every time I think I\'m free\n\n'

    'You get high and call on the regular\n'
    'I get weak and fall like a teenager\n'
    'Why, oh, why does God keep bringing me back to you?\n'
    'I get drunk, pretend that I\'m over it\n'
    'Self-destruct, show up like an idiot\n'
    'Why, oh, why does God keep bringing me back to you?\n\n'

    'I go back to you, back to you, back to you\n'
    'Back to you, back to you, back to you\n'
    'I go back to you, back to you, back to you every time\n\n'

    'Just when I get on a new wave \n'
    'Boy, you look at me and I slip outta my lace\n'
    'They keep calling me a head-case\n'
    'Cause I can\'t make a good case why we can\'t change\n\n'

    'I\'ve tried to fight our energy\n'
    'But every time I think I\'m free\n\n'

    'You get high and call on the regular\n'
    'I get weak and fall like a teenager\n'
    'Why, oh, why does God keep bringing me back to you?\n'
    'I get drunk, pretend that I\'m over it\n'
    'Self-destruct, show up like an idiot\n'
    'Why, oh, why does God keep bringing me back to you?\n\n'

    'I go back to you, back to you, back to you\n'
    'Back to you, back to you, back to you\n'
    'I go back to you, back to you, back to you every time\n'
    'I go back to you, back to you, back to you\n'
    'Back to you, back to you, back to you\n'
    'I go back to you, back to you, back to you every time\n',
  );

  // State Audio Player & Progress
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // State Form & Controls
  bool _isFavorite = false; 
  final TextEditingController _commentController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => _position = newPosition);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(AssetSource('audio/everytime.mp3'));
      }
    } catch (e) {
      debugPrint("Error play audio: $e");
    }
  }

  Future _getAudioInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Format: MP3";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea( 
      child: Scaffold( 
        appBar: AppBar( 
          backgroundColor: const Color(0xFF0288D1),
          title: Text(
            liriklagu1.judul, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton( 
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link lirik berhasil disalin!')),
                );
              },
            ),
          ],
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF0288D1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF0288D1)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mahasiswa1.nama,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Kelas: ${mahasiswa1.kelas}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.music_note, color: Color(0xFF0288D1)),
                title: const Text('Katalog Lirik'),
                onTap: () {
                  Navigator.pop(context); // Tutup drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text('Favorit'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menu Favorit dipilih')),
                  );
                },
              ),
            ],
          ),
        ),

        body: Padding( 
          padding: const EdgeInsets.all(12.0),
          child: Column( 
            children: [
              // HEADER & FOTO COVER
              Card( 
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row( 
                    children: [   
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset( 
                          'assets/image/everytime.jpeg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.blueGrey,
                            child: const Icon(Icons.music_note, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12), 
                      Expanded( 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              liriklagu1.judul,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Penyanyi: ${liriklagu1.penyanyi}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            FutureBuilder(
                              future: _getAudioInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // TAB BAR LIRIK & CATATAN
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Color(0xFF0288D1),
                        tabs: [
                          Tab(icon: Icon(Icons.article), text: "Lirik"),
                          Tab(icon: Icon(Icons.edit_note), text: "Catatan"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView( 
                          children: [
                            SingleChildScrollView( 
                              padding: const EdgeInsets.all(12.0),
                              child: SelectableText( 
                                liriklagu1.isiLirik,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15, height: 1.5),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  TextField( 
                                    controller: _commentController,
                                    decoration: const InputDecoration(
                                      labelText: 'Tambahkan Catatan Pribadi',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.note),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Text('Suka Lagu ini: '),
                                      Switch( 
                                        value: _isFavorite,
                                        onChanged: (val) {
                                          setState(() => _isFavorite = val);
                                        },
                                      ),
                                    ],
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

              Slider(
                activeColor: const Color(0xFF0288D1),
                min: 0.0,
                max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                value: _position.inSeconds.toDouble().clamp(
                      0.0,
                      _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                    ),
                onChanged: (val) async {
                  final pos = Duration(seconds: val.toInt());
                  await _audioPlayer.seek(pos);
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 36),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: IconButton(
                      key: ValueKey(_isPlaying),
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        size: 52,
                        color: const Color(0xFF0288D1),
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 36),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                'created by ${mahasiswa1.nama} (${mahasiswa1.kelas})',
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton( 
          backgroundColor: const Color(0xFF0288D1),
          child: const Icon(Icons.info, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Informasi Pemutar'),
                content: Text('Diputar oleh: ${mahasiswa1.nama}'),
                actions: [
                  ElevatedButton( 
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}