import 'package:dio/dio.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final data = _responseData(response);

    return AuthSession(
      access: _readToken(data, const ['access_token', 'token'], 'akses'),
      refresh: _readToken(data, const ['refresh_token', 'refresh'], 'refresh'),
    );
  }

  @override
  Future<String> refresh(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw const FormatException('Refresh token tidak tersedia');
    }

    final response = await apiClient.post(
      '/refresh',
      data: {'refresh_token': refreshToken},
    );
    final data = _responseData(response);
    return _readToken(data, const ['access_token', 'token'], 'akses');
  }

  Map<String, dynamic> _responseData(Response<dynamic> response) {
    final body = response.data;
    if (body is Map<String, dynamic>) return body;
    if (body is Map) {
      return body.map((key, value) => MapEntry(key.toString(), value));
    }
    throw const FormatException('Format respons autentikasi tidak valid');
  }

  String _readToken(
    Map<String, dynamic> data,
    List<String> keys,
    String tokenName,
  ) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    throw FormatException('Token $tokenName tidak ditemukan dari server');
  }
}
