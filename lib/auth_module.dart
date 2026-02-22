import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/auth_theme.dart';
import 'domain/entities/auth_user.dart';
import 'domain/entities/auth_repository.dart';
import 'presentation/providers/auth_providers.dart';
import 'presentation/screens/login_screen.dart';

export 'domain/entities/auth_user.dart';
export 'domain/entities/auth_repository.dart';
export 'domain/entities/auth_failure.dart';
export 'data/repositories/mock_auth_repository.dart';
export 'core/theme/auth_theme.dart';
export 'core/constants/auth_constants.dart';
export 'presentation/providers/auth_providers.dart';
export 'presentation/widgets/auth_logo.dart' show AuthThemeToggle;

/// The main entry point for the Auth Module.
///
/// Usage:
/// ```dart
/// AuthModule(
///   authRepository: YourAuthRepository(),
///   onLoginSuccess: (user) => Navigator.pushReplacement(
///     context,
///     MaterialPageRoute(builder: (_) => HomeScreen()),
///   ),
/// );
/// ```
///
/// The module is completely self-contained and manages its own navigation,
/// state, and theming. Simply provide an [AuthRepository] implementation
/// and a success callback.
class AuthModule extends StatelessWidget {
  final AuthRepository authRepository;
  final void Function(AuthUser user) onLoginSuccess;
  final ThemeMode? initialTheme;

  const AuthModule({
    super.key,
    required this.authRepository,
    required this.onLoginSuccess,
    this.initialTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // Inject the provided repository implementation
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
      child: _AuthModuleApp(
        onLoginSuccess: onLoginSuccess,
        initialTheme: initialTheme,
      ),
    );
  }
}

/// Internal app wrapper with theme support
class _AuthModuleApp extends ConsumerWidget {
  final void Function(AuthUser user) onLoginSuccess;
  final ThemeMode? initialTheme;

  const _AuthModuleApp({
    required this.onLoginSuccess,
    this.initialTheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AuthLightTheme.theme,
      darkTheme: AuthDarkTheme.theme,
      themeMode: initialTheme ?? themeMode,
      home: LoginScreen(onLoginSuccess: onLoginSuccess),
    );
  }
}

/// Alternative: Embed just the login screen into an existing app's navigator.
///
/// Use this when your app already has MaterialApp and you just need the screens.
///
/// ```dart
/// // In your existing app, override the provider in a parent ProviderScope:
/// ProviderScope(
///   overrides: [
///     authRepositoryProvider.overrideWithValue(myRepository),
///   ],
///   child: LoginScreen(onLoginSuccess: (user) { ... }),
/// )
/// ```
class AuthModuleScreen extends ConsumerWidget {
  final void Function(AuthUser user) onLoginSuccess;

  const AuthModuleScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoginScreen(onLoginSuccess: onLoginSuccess);
  }
}
