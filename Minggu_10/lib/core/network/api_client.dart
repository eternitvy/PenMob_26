import 'package:dio/dio.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/token_repository.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://example-campus-api.test',
);

Dio buildUnauthenticatedApiClient() => Dio(_baseOptions());

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: apiBaseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

/// Dio dengan refresh otomatis: saat 401, coba refresh SATU kali lalu ulangi
/// request. Bila refresh gagal, sesi dibersihkan dan [onSessionExpired]
/// dipanggil agar UI kembali ke /login.
Dio buildApiClient(
  TokenRepository store,
  AuthRepository auth, {
  void Function()? onSessionExpired,
}) {
  final dio = Dio(_baseOptions());
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await store.readAccess();
        if (access != null && access.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        final alreadyRetried = e.requestOptions.extra['retried'] == true;
        if (e.response?.statusCode == 401 && !alreadyRetried) {
          final refresh = await store.readRefresh();
          if (refresh == null || refresh.isEmpty) {
            await store.clear();
            onSessionExpired?.call();
            return handler.next(e);
          }
          try {
            final renewed = await auth.refresh(refresh);
            await store.save(access: renewed, refresh: refresh);
            final retry = await dio.fetch(
              e.requestOptions
                ..headers['Authorization'] = 'Bearer $renewed'
                ..extra['retried'] = true,
            );
            return handler.resolve(retry);
          } catch (_) {
            await store.clear();
            onSessionExpired?.call();
          }
        }
        handler.next(e);
      },
    ),
  );
  return dio;
}
