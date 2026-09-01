import 'package:video4/video4.dart' as video4;

void main(List<String> arguments) {
  int a = 10;
  double b = 3.14;
  String c = 'Hello, Dart!';
  bool d = true;
  print(a);
  print(b);
  print(c);
  print(d);
  String e = '12';
  int f = a + int.parse(e);
  print(f);
  List<String> names = ['Alice', 'Bob', 'Charlie'];
  List<int> numbers = [1, 2, 3, 4, 5, 10];
  print(names);
  print('nama yang ke-1 adalah: ${names[0]}');
  print(numbers);
  print('jumlah elemen pada list numbers adalah: ${numbers.length}');
}