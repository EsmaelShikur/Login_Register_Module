// ignore: dangling_library_doc_comments
/// ============================================================================
/// EXAMPLE INTEGRATION - main.dart
///
/// This file shows exactly how to integrate the auth_module into any Flutter app.
/// ============================================================================

// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:auth_module_example/presentation/screens/login_screen.dart';
import 'package:auth_module_example/presentation/widgets/auth_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Step 1: Import the auth module
import 'auth_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Step 2: Wrap with ProviderScope (required for Riverpod)
    return ProviderScope(
      /// Step 3: Override the authRepositoryProvider with your implementation.
      /// - MockAuthRepository: for development/testing
      /// - FirebaseAuthRepository: for production with Firebase
      /// - Your custom implementation: for any other backend
      overrides: [
        authRepositoryProvider.overrideWithValue(
          MockAuthRepository(), // or: FirebaseAuthRepository()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: AuthLightTheme.theme, // Use auth module's light theme
        darkTheme: AuthDarkTheme.theme, // Use auth module's dark theme
        themeMode: ThemeMode.dark,
        // Step 4: Set AuthModule as the initial route
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Wrapper that shows auth or home screen based on auth state
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoginScreen(
      onLoginSuccess: (user) {
        // Navigate to your home screen on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: user),
          ),
        );
      },
    );
  }
}

/// ─── ALTERNATIVE: Use the self-contained AuthModule widget ──────────────────
///
/// If you prefer a fully self-contained approach that includes its own
/// MaterialApp, use AuthModule directly:
///
/// void main() {
///   runApp(
///     AuthModule(
///       authRepository: MockAuthRepository(),
///       onLoginSuccess: (user) {
///         // This is called when login/register succeeds
///         // Note: with AuthModule, you need to handle navigation
///         // to your own app's MaterialApp from here
///         runApp(MyMainApp(user: user));
///       },
///     ),
///   );
/// }
/// ─────────────────────────────────────────────────────────────────────────────

/// Your app's home screen (shown after successful auth)
class HomeScreen extends StatelessWidget {
  final AuthUser user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.darkBackground,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Sign out button
          Consumer(
            builder: (context, ref, _) => IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authNotifierProvider.notifier).signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AuthLogo(isDark: true, size: 80),
            const SizedBox(height: 24),
            Text(
              'Welcome, ${user.displayName ?? user.email}!',
              style: const TextStyle(
                color: AuthColors.darkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: const TextStyle(
                color: AuthColors.darkTextSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AuthColors.neonCyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AuthColors.neonCyan.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Provider: ${user.provider.name.toUpperCase()}',
                style: const TextStyle(
                  color: AuthColors.neonCyan,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
