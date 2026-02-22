// ignore_for_file: depend_on_referenced_packages

/// Firebase Auth Repository
///
/// To use this implementation:
/// 1. Add these to pubspec.yaml:
///    firebase_core: ^2.24.2
///    firebase_auth: ^4.16.0
///    google_sign_in: ^6.2.1
///    sign_in_with_apple: ^6.1.0
///
/// 2. Run: flutterfire configure
/// 3. Uncomment the code below and remove the mock import

/*
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/auth_repository.dart';
import '../../domain/entities/auth_failure.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository({
    fb.FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<AuthUser?> get authStateChanges =>
      _auth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<AuthUser?> getCurrentUser() async =>
      _mapFirebaseUser(_auth.currentUser);

  AuthUser? _mapFirebaseUser(fb.User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      provider: _mapProvider(user),
    );
  }

  AuthProvider _mapProvider(fb.User user) {
    if (user.providerData.isEmpty) return AuthProvider.email;
    final providerId = user.providerData.first.providerId;
    return switch (providerId) {
      'google.com' => AuthProvider.google,
      'apple.com' => AuthProvider.apple,
      _ => AuthProvider.email,
    };
  }

  @override
  Future<AuthUser?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(result.user);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<AuthUser?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(result.user);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  @override
  Future<AuthUser?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const GoogleSignInFailure();

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return _mapFirebaseUser(result.user);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (_) {
      throw const GoogleSignInFailure();
    }
  }

  @override
  Future<AuthUser?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final result = await _auth.signInWithCredential(oauthCredential);
      return _mapFirebaseUser(result.user);
    } on fb.FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    } catch (_) {
      throw const AppleSignInFailure();
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  AuthFailure _mapFirebaseException(fb.FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => const InvalidEmailFailure(),
      'wrong-password' || 'invalid-credential' => const WrongPasswordFailure(),
      'user-not-found' => const UserNotFoundFailure(),
      'email-already-in-use' => const EmailAlreadyInUseFailure(),
      'weak-password' => const WeakPasswordFailure(),
      'network-request-failed' => const NetworkFailure(),
      _ => UnknownFailure(e.message ?? 'Unknown error'),
    };
  }
}
*/

/// Placeholder export for when Firebase is not configured
export 'mock_auth_repository.dart';
