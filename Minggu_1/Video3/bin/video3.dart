import 'package:video3/video3.dart' as video3;

void main(List<String> arguments) {
  print('Hello world: ${video3.calculate()}!');
  var nama = "Regita";
  var umur = 20;
  var alamat = "Jl. Ulil Abshar Jl. Margo Basuki";
  var tinggi = "170";
  var iseng = umur + int.parse(tinggi);
  print("Nama: $nama");
  print("Umur: $umur");
  print("Alamat: $alamat");
  print("Hasil Iseng: $iseng");
}
