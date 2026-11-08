import '../repositories/auth_repository.dart';
import '../repositories/token_repository.dart';

class Login {
  const Login({
    required AuthRepository repository,
    required TokenRepository tokenRepository,
  }) : _repository = repository,
       _tokenRepository = tokenRepository;

  final AuthRepository _repository;
  final TokenRepository _tokenRepository;

  Future<void> call({required String email, required String password}) async {
    final session = await _repository.login(email: email, password: password);
    await _tokenRepository.save(
      access: session.access,
      refresh: session.refresh,
    );
  }
}
