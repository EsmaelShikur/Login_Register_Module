import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/auth_repository.dart';
import '../../domain/entities/auth_failure.dart';
import '../../domain/usecases/auth_usecases.dart';

// ─── Auth State ──────────────────────────────────────────────────────────────

sealed class AuthState {
  const AuthState();
}

class AuthIdle extends AuthState {
  const AuthIdle();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthUser user;
  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  final AuthFailure? failure;
  const AuthError(this.message, {this.failure});
}

// ─── Auth Repository Provider ─────────────────────────────────────────────────

/// Override this provider in your app to inject your real repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden. '
    'See AuthModule widget for setup instructions.',
  );
});

// ─── Use Case Providers ───────────────────────────────────────────────────────

final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>((ref) {
  return SignInWithEmailUseCase(ref.read(authRepositoryProvider));
});

final registerWithEmailUseCaseProvider =
    Provider<RegisterWithEmailUseCase>((ref) {
  return RegisterWithEmailUseCase(ref.read(authRepositoryProvider));
});

final signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>((ref) {
  return SignInWithGoogleUseCase(ref.read(authRepositoryProvider));
});

final signInWithAppleUseCaseProvider = Provider<SignInWithAppleUseCase>((ref) {
  return SignInWithAppleUseCase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

// ─── Auth Notifier ────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithEmailUseCase _signInWithEmail;
  final RegisterWithEmailUseCase _registerWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignInWithAppleUseCase _signInWithApple;
  final SignOutUseCase _signOut;

  AuthNotifier({
    required SignInWithEmailUseCase signInWithEmail,
    required RegisterWithEmailUseCase registerWithEmail,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignInWithAppleUseCase signInWithApple,
    required SignOutUseCase signOut,
  })  : _signInWithEmail = signInWithEmail,
        _registerWithEmail = registerWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _signOut = signOut,
        super(const AuthIdle());

  Future<void> signInWithEmail(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    state = const AuthLoading();
    try {
      final user = await _signInWithEmail(email, password);
      if (user != null) {
        if (rememberMe) await _saveSession(email);
        state = AuthSuccess(user);
      } else {
        state = const AuthError('Sign in failed. Please try again.');
      }
    } on AuthFailure catch (failure) {
      state = AuthError(failure.message, failure: failure);
    } catch (e) {
      state = AuthError('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await _registerWithEmail(email, password);
      if (user != null) {
        state = AuthSuccess(user);
      } else {
        state = const AuthError('Registration failed. Please try again.');
      }
    } on AuthFailure catch (failure) {
      state = AuthError(failure.message, failure: failure);
    } catch (e) {
      state = AuthError('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthLoading();
    try {
      final user = await _signInWithGoogle();
      if (user != null) {
        state = AuthSuccess(user);
      } else {
        state = const AuthError('Google sign in was cancelled.');
      }
    } on AuthFailure catch (failure) {
      state = AuthError(failure.message, failure: failure);
    } catch (e) {
      state = AuthError('Google sign in failed: ${e.toString()}');
    }
  }

  Future<void> signInWithApple() async {
    state = const AuthLoading();
    try {
      final user = await _signInWithApple();
      if (user != null) {
        state = AuthSuccess(user);
      } else {
        state = const AuthError('Apple sign in was cancelled.');
      }
    } on AuthFailure catch (failure) {
      state = AuthError(failure.message, failure: failure);
    } catch (e) {
      state = AuthError('Apple sign in failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _signOut();
    await _clearSession();
    state = const AuthIdle();
  }

  void resetState() {
    state = const AuthIdle();
  }

  Future<void> _saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_remembered_email', email);
    await prefs.setBool('auth_remember_me', true);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_remembered_email');
    await prefs.remove('auth_remember_me');
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('auth_remember_me') ?? false;
    if (rememberMe) {
      return prefs.getString('auth_remembered_email');
    }
    return null;
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    signInWithEmail: ref.read(signInWithEmailUseCaseProvider),
    registerWithEmail: ref.read(registerWithEmailUseCaseProvider),
    signInWithGoogle: ref.read(signInWithGoogleUseCaseProvider),
    signInWithApple: ref.read(signInWithAppleUseCaseProvider),
    signOut: ref.read(signOutUseCaseProvider),
  );
});

// ─── Theme Notifier ───────────────────────────────────────────────────────────

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('auth_dark_mode') ?? true;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auth_dark_mode', state == ThemeMode.dark);
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeNotifierProvider);
  return themeMode == ThemeMode.dark;
});
