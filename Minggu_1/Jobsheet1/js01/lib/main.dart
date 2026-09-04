import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Profil Mahasiswa')),
        body: const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.account_circle, size: 72),
            SizedBox(height: 16),
            Text('Regita Abelia Putri Satriyo', style: TextStyle(fontSize: 24)),
            Text('244107020173', style: TextStyle(fontSize: 20)),
            Text('Pemrograman Mobile — Minggu 1'),
            Text('Politeknik Negeri Malang', style: TextStyle(fontSize: 26)),
          ]),
        ),
      ),
    );
  }
}