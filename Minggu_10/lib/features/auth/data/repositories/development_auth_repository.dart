import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class DevelopmentAuthRepository implements AuthRepository {
  const DevelopmentAuthRepository(this._remoteRepository);

  final AuthRepository _remoteRepository;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const AuthSession(
      access: 'dummy_access_token_bypass',
      refresh: 'dummy_refresh_token_bypass',
    );
  }

  @override
  Future<String> refresh(String refreshToken) =>
      _remoteRepository.refresh(refreshToken);
}
