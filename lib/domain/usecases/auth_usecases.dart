import '../entities/auth_user.dart';
import '../entities/auth_repository.dart';

/// Sign In use case
class SignInWithEmailUseCase {
  final AuthRepository _repository;
  SignInWithEmailUseCase(this._repository);

  Future<AuthUser?> call(String email, String password) =>
      _repository.signInWithEmail(email, password);
}

/// Register use case
class RegisterWithEmailUseCase {
  final AuthRepository _repository;
  RegisterWithEmailUseCase(this._repository);

  Future<AuthUser?> call(String email, String password) =>
      _repository.registerWithEmail(email, password);
}

/// Google Sign In use case
class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);

  Future<AuthUser?> call() => _repository.signInWithGoogle();
}

/// Apple Sign In use case
class SignInWithAppleUseCase {
  final AuthRepository _repository;
  SignInWithAppleUseCase(this._repository);

  Future<AuthUser?> call() => _repository.signInWithApple();
}

/// Sign Out use case
class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}

/// Get current user use case
class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<AuthUser?> call() => _repository.getCurrentUser();
}
