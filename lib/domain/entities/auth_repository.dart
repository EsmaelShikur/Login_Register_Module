import '../entities/auth_user.dart';

/// Abstract AuthRepository - backend-agnostic authentication contract.
/// Implement this to plug in any auth backend (Firebase, Supabase, REST API, etc.)
abstract class AuthRepository {
  /// Sign in with email and password
  Future<AuthUser?> signInWithEmail(String email, String password);

  /// Register with email and password
  Future<AuthUser?> registerWithEmail(String email, String password);

  /// Sign in with Google OAuth
  Future<AuthUser?> signInWithGoogle();

  /// Sign in with Apple (iOS only)
  Future<AuthUser?> signInWithApple();

  /// Sign out current user
  Future<void> signOut();

  /// Get the currently authenticated user (if any)
  Future<AuthUser?> getCurrentUser();

  /// Stream of auth state changes
  Stream<AuthUser?> get authStateChanges;
}
