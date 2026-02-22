import 'dart:async';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/auth_repository.dart';
import '../../domain/entities/auth_failure.dart';

/// Mock implementation of AuthRepository for development and testing.
/// Replace with FirebaseAuthRepository or your own implementation in production.
class MockAuthRepository implements AuthRepository {
  AuthUser? _currentUser;
  final _authStateController = StreamController<AuthUser?>.broadcast();

  // Simulated user store
  final Map<String, String> _users = {
    'demo@example.com': 'Demo@1234',
  };

  @override
  Stream<AuthUser?> get authStateChanges => _authStateController.stream;

  @override
  Future<AuthUser?> getCurrentUser() async => _currentUser;

  @override
  Future<AuthUser?> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Simulate network

    if (!_isValidEmail(email)) throw const InvalidEmailFailure();

    if (!_users.containsKey(email)) throw const UserNotFoundFailure();

    if (_users[email] != password) throw const WrongPasswordFailure();

    _currentUser = AuthUser(
      id: 'mock-${email.hashCode}',
      email: email,
      displayName: email.split('@').first,
      emailVerified: true,
      provider: AuthProvider.email,
    );

    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<AuthUser?> registerWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!_isValidEmail(email)) throw const InvalidEmailFailure();

    if (_users.containsKey(email)) throw const EmailAlreadyInUseFailure();

    if (password.length < 8) throw const WeakPasswordFailure();

    _users[email] = password;

    _currentUser = AuthUser(
      id: 'mock-${email.hashCode}',
      email: email,
      displayName: email.split('@').first,
      emailVerified: false,
      provider: AuthProvider.email,
    );

    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _currentUser = const AuthUser(
      id: 'google-mock-123',
      email: 'user@gmail.com',
      displayName: 'Google User',
      emailVerified: true,
      provider: AuthProvider.google,
    );

    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<AuthUser?> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _currentUser = const AuthUser(
      id: 'apple-mock-456',
      email: 'user@privaterelay.appleid.com',
      displayName: 'Apple User',
      emailVerified: true,
      provider: AuthProvider.apple,
    );

    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStateController.add(null);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  void dispose() {
    _authStateController.close();
  }
}
