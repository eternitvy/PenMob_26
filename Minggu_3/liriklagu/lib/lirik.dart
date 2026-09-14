import 'package:flutter/material.dart';

class lirik {
  String judul;
  String penyanyi;
  String isiLirik;

  lirik({
    required this.judul,
    required this.penyanyi,
    required this.isiLirik,
  });

  void tampilkanInfo() {
    print('Judul: $judul');
    print('Penyanyi: $penyanyi');
    print('Isi Lirik: $isiLirik');
  }
}
