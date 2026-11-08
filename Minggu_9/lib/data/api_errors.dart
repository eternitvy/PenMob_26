import 'package:dio/dio.dart';

/// Memetakan exception mentah menjadi pesan ramah pengguna.
/// UI hanya menerima String, bukan DioException.
String friendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi lambat, coba lagi sebentar lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi internet.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401) return 'Sesi berakhir, silakan login ulang.';
        if (code == 403) return 'Anda tidak punya akses ke data ini.';
        if (code != null && code >= 500) {
          return 'Server sedang bermasalah, coba lagi nanti.';
        }
        return 'Permintaan gagal (kode $code).';
      default:
        return 'Terjadi kesalahan jaringan.';
    }
  }
  final text = error.toString();
  return text.startsWith('Exception: ') ? text.substring(11) : text;
}
