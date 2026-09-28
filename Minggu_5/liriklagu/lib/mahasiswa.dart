class mahasiswa {
  String nama;
  int umur;
  String kelas;

  mahasiswa({required this.nama, required this.umur, required this.kelas});

  void tampilkanInfo() {
    print('Nama: $nama');
    print('Umur: $umur');
    print('Kelas: $kelas');
  }
}