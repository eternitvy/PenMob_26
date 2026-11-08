import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/token_store.dart';
import '../../data/repositories/development_auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/token_repository.dart';
import '../../domain/usecases/login.dart';

final tokenStoreProvider = Provider<TokenRepository>((ref) => TokenStore());

final remoteAuthRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(apiClient: buildUnauthenticatedApiClient()),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => DevelopmentAuthRepository(ref.watch(remoteAuthRepositoryProvider)),
);

final loginUseCaseProvider = Provider<Login>(
  (ref) => Login(
    repository: ref.watch(authRepositoryProvider),
    tokenRepository: ref.watch(tokenStoreProvider),
  ),
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
      await ref.read(loginUseCaseProvider)(
        email: email,
        password: password,
      );
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    ref.invalidateSelf();
  }
}