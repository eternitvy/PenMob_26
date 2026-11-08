import 'package:campus_notify/core/network/api_client.dart';
import 'package:campus_notify/features/auth/domain/entities/auth_session.dart';
import 'package:campus_notify/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_push_test.dart' show FakeTokenStore;

class _FailingRefreshRepo implements AuthRepository {
  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<String> refresh(String refreshToken) async =>
      throw Exception('refresh kedaluwarsa');
}

class _SuccessfulRefreshRepo implements AuthRepository {
  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<String> refresh(String refreshToken) async => 'mock-access-renewed-1';
}

/// Adapter palsu: 401 untuk token lama, 200 untuk token hasil refresh.
class _FakeAdapter implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? _,
    Future<void>? _,
  ) async {
    calls++;
    final auth = options.headers['Authorization'] as String?;
    final ok = auth != null && auth.contains('renewed');
    return ResponseBody.fromString(
      ok ? '{"ok":true}' : '{}',
      ok ? 200 : 401,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('401 memicu refresh sekali lalu request diulang', () async {
    final store = FakeTokenStore()
      ..access = 'old'
      ..refresh = 'mock-refresh';
    final dio = buildApiClient(store, _SuccessfulRefreshRepo());
    final adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;

    final res = await dio.get('/announcements');
    expect(res.statusCode, 200);
    expect(adapter.calls, 2); // request awal + 1 retry
    expect(store.access, startsWith('mock-access-renewed-'));
  });

  test('refresh gagal -> token dibersihkan dan sesi berakhir', () async {
    final store = FakeTokenStore()
      ..access = 'old'
      ..refresh = 'mock-refresh';
    var expired = false;
    final dio = buildApiClient(
      store,
      _FailingRefreshRepo(),
      onSessionExpired: () => expired = true,
    );
    dio.httpClientAdapter = _FakeAdapter();

    await expectLater(dio.get('/announcements'), throwsA(isA<DioException>()));
    expect(store.access, isNull);
    expect(store.refresh, isNull);
    expect(expired, isTrue);
  });
}
