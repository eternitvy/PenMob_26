import 'package:campus_notify/data/api_errors.dart';
import 'package:campus_notify/data/auth_repository.dart';
import 'package:campus_notify/messaging/push_service.dart';
import 'package:campus_notify/messaging/route_parser.dart';
import 'package:campus_notify/providers/auth_provider.dart';
import 'package:campus_notify/data/token_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// TokenStore palsu di memori: tidak menyentuh Keychain/Keystore.
class FakeTokenStore extends TokenStore {
  String? access;
  String? refresh;

  @override
  Future<void> save({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<String?> readAccess() async => access;
  @override
  Future<String?> readRefresh() async => refresh;
  @override
  Future<void> clear() async => access = refresh = null;
}

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository() : super(apiClient: Dio());

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    if (email == 'salah') {
      throw Exception('Email atau kata sandi tidak valid');
    }
    return const AuthSession(access: 'access-token', refresh: 'refresh-token');
  }
}

void main() {
  group('routeFromMessage', () {
    test('menangani route kosong dan tanpa slash', () {
      expect(routeFromMessage({}), '/');
      expect(routeFromMessage({'route': 'pengumuman/3'}), '/pengumuman/3');
      expect(routeFromMessage({'route': '/pengumuman/3'}), '/pengumuman/3');
    });

    test('data payload membawa id pengumuman', () {
      const data = {'route': '/pengumuman/3', 'id': '3'};
      expect(data['id'], '3');
      expect(routeFromMessage(data), '/pengumuman/3');
      expect(routeFromMessage({'id': '7'}), '/pengumuman/7');
    });
  });

  test('maskToken tidak pernah mengembalikan token penuh', () {
    const token = 'abcdefghijklmnopqrstuvwxyz0123456789';
    expect(maskToken(token), 'abcdefghijkl...');
    expect(maskToken(null), '-');
  });

  group('sesi auth', () {
    late FakeTokenStore store;
    late ProviderContainer container;

    setUp(() {
      store = FakeTokenStore();
      container = ProviderContainer(
        overrides: [
          tokenStoreProvider.overrideWithValue(store),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
      );
    });
    tearDown(() => container.dispose());

    test('provider auth membaca status login dari token', () async {
      expect(await container.read(authStateProvider.future), isFalse);

      await container
          .read(authStateProvider.notifier)
          .login('mhs@polinema.ac.id', 'rahasia123');
      expect(container.read(authStateProvider).value, isTrue);
      expect(store.access, isNotNull);
      expect(store.refresh, isNotNull);

      await container.read(authStateProvider.notifier).logout();
      expect(await container.read(authStateProvider.future), isFalse);
      expect(store.access, isNull);
    });

    test('kredensial salah -> state error, token tidak tersimpan', () async {
      await container.read(authStateProvider.notifier).login('salah', '123');
      final state = container.read(authStateProvider);
      expect(state.hasError, isTrue);
      expect(
        friendlyErrorMessage(state.error!),
        'Email atau kata sandi tidak valid',
      );
      expect(store.access, isNull);
    });
  });

  test(
    'refresh gagal -> repository melempar error (paksa login ulang)',
    () async {
      final store = FakeTokenStore()..refresh = '';
      final needsLogin = (store.refresh ?? '').isEmpty;
      expect(needsLogin, isTrue);
      expect(
        () => AuthRepository(apiClient: Dio()).refresh(''),
        throwsFormatException,
      );
    },
  );

  test('friendlyErrorMessage memetakan 401 dan timeout', () {
    final opts = RequestOptions(path: '/x');
    expect(
      friendlyErrorMessage(
        DioException(
          requestOptions: opts,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: opts, statusCode: 401),
        ),
      ),
      'Sesi berakhir, silakan login ulang.',
    );
    expect(
      friendlyErrorMessage(
        DioException(
          requestOptions: opts,
          type: DioExceptionType.receiveTimeout,
        ),
      ),
      'Koneksi lambat, coba lagi sebentar lagi.',
    );
  });
}
