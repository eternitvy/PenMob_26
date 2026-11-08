import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_client.dart';
import '../data/auth_repository.dart';
import '../data/token_store.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(apiClient: buildUnauthenticatedApiClient()),
);

final apiClientProvider = Provider<Dio>((ref) {
  return buildApiClient(
    ref.watch(tokenStoreProvider),
    ref.watch(authRepositoryProvider),
    onSessionExpired: () => ref.invalidate(authStateProvider),
  );
});

final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.watch(tokenStoreProvider).readAccess();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // --- BYPASS LOGIN KE BACKEND ---
      // Simulasi jeda singkat (opsional, agar terasa seperti proses login)
      await Future.delayed(const Duration(milliseconds: 500));

      // Simpan token dummy/palsu ke TokenStore agar state aplikasi menganggap user sudah login
      await ref.read(tokenStoreProvider).save(
            access: 'dummy_access_token_bypass',
            refresh: 'dummy_refresh_token_bypass',
          );
          
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    ref.invalidateSelf();
  }
}