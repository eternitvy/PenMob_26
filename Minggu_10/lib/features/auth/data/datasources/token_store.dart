import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/token_repository.dart';

/// Seluruh token hanya keluar-masuk lewat kelas ini (Keychain/Keystore).
/// Jangan pernah memindahkan token ke SharedPreferences.
class TokenStore implements TokenRepository {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  @override
  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  @override
  Future<String?> readAccess() => _storage.read(key: _accessKey);
  @override
  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  @override
  Future<void> clear() => _storage.deleteAll();
}
