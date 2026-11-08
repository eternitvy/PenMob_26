import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  Future<String> refresh(String refreshToken);
}
