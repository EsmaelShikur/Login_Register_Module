# 🔐 Auth Module — Premium Flutter Authentication

A production-ready, reusable Flutter authentication module with a dark futuristic neon UI. Drop it into any project in minutes.

---

## 📦 Module Structure

```
auth_module/
├── auth_module.dart          ← Main entry point / public API
│
├── core/
│   ├── animations/
│   │   ├── auth_animations.dart      # Shake, neon glow, fade transitions
│   │   └── particle_background.dart  # 60fps particle canvas animation
│   ├── constants/
│   │   ├── auth_constants.dart       # Colors, spacing, radius, durations
│   │   └── auth_validators.dart      # Email/password validation + strength
│   └── theme/
│       └── auth_theme.dart           # Dark neon + Light modern themes
│
├── data/
│   ├── models/
│   │   └── auth_user_model.dart      # Serializable user model
│   └── repositories/
│       ├── mock_auth_repository.dart      # Dev/test mock (no backend needed)
│       └── firebase_auth_repository.dart  # Firebase stub (uncomment to use)
│
├── domain/
│   ├── entities/
│   │   ├── auth_user.dart       # Pure domain user entity
│   │   ├── auth_failure.dart    # Typed failure hierarchy
│   │   └── auth_repository.dart # Abstract contract
│   └── usecases/
│       └── auth_usecases.dart   # All use cases
│
├── presentation/
│   ├── providers/
│   │   └── auth_providers.dart  # Riverpod: AuthNotifier, ThemeNotifier
│   ├── screens/
│   │   ├── login_screen.dart    # Full login UI
│   │   └── register_screen.dart # Full register UI
│   └── widgets/
│       ├── auth_buttons.dart              # NeonButton, SocialAuthButton
│       ├── auth_logo.dart                 # Animated logo + ThemeToggle
│       ├── auth_text_field.dart           # Glassy neon text field
│       └── password_strength_indicator.dart # Animated strength meter
│
└── test/
    └── auth_module_test.dart   # Unit tests
```

---

## 🚀 Quick Start

### 1. Copy the Module

Copy the entire `auth_module/` folder into your project's `lib/` directory.

### 2. Add Dependencies to pubspec.yaml

```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  shared_preferences: ^2.2.2
  lottie: ^2.7.0
  shimmer: ^3.0.0
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.0
```

Run: `flutter pub get`

### 3. Basic Integration

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_module/auth_module.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        // Inject your repository
        authRepositoryProvider.overrideWithValue(
          MockAuthRepository(), // or FirebaseAuthRepository()
        ),
      ],
      child: MaterialApp(
        theme: AuthLightTheme.theme,
        darkTheme: AuthDarkTheme.theme,
        themeMode: ThemeMode.dark,
        home: LoginScreen(
          onLoginSuccess: (user) {
            // Navigate to your home screen
            Navigator.pushReplacement(context, ...);
          },
        ),
      ),
    ),
  );
}
```

### 4. Or use the self-contained widget

```dart
void main() {
  runApp(
    AuthModule(
      authRepository: MockAuthRepository(),
      onLoginSuccess: (user) {
        // Called when auth succeeds
      },
    ),
  );
}
```

---

## 🔌 Implementing Your Own Backend

Implement the `AuthRepository` interface:

```dart
class MyCustomAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> signInWithEmail(String email, String password) async {
    // Your REST API / Supabase / custom backend call
    final response = await http.post(...);
    return AuthUser(id: response.id, email: email);
  }

  // ... implement all methods
}
```

---

## 🔥 Firebase Setup

1. Follow Firebase setup: `flutterfire configure`
2. Open `data/repositories/firebase_auth_repository.dart`
3. Uncomment the Firebase implementation
4. Use `FirebaseAuthRepository()` instead of `MockAuthRepository()`

---

## 🎨 Themes

```dart
// Dark neon (default)
AuthDarkTheme.theme

// Light modern
AuthLightTheme.theme

// Toggle from anywhere
ref.read(themeNotifierProvider.notifier).toggle();

// Check current
final isDark = ref.watch(isDarkModeProvider);
```

---

## 🧠 State Management (Riverpod)

```dart
// Auth state
final state = ref.watch(authNotifierProvider);

state is AuthIdle    // Not signed in
state is AuthLoading // Request in progress
state is AuthSuccess // state.user contains the user
state is AuthError   // state.message contains the error

// Actions
ref.read(authNotifierProvider.notifier).signInWithEmail(email, password);
ref.read(authNotifierProvider.notifier).signOut();
```

---

## 🧪 Running Tests

```bash
flutter test test/auth_module_test.dart
```

---

## 📱 Platform Notes

- **Apple Sign-In**: Only shown on iOS automatically
- **Google Sign-In**: Shown on all platforms
- **Haptics**: Uses `HapticFeedback` — works on real devices

---

## ✨ Features

| Feature | Status |
|---------|--------|
| Email/Password Login | ✅ |
| Email/Password Register | ✅ |
| Google Sign-In | ✅ |
| Apple Sign-In (iOS) | ✅ |
| Remember Me | ✅ |
| Dark Neon Theme | ✅ |
| Light Theme | ✅ |
| Theme Toggle | ✅ |
| Particle Background | ✅ |
| Animated Logo | ✅ |
| Neon Glow Buttons | ✅ |
| Glassy Text Fields | ✅ |
| Focus Glow Effect | ✅ |
| Shake on Error | ✅ |
| Password Strength Meter | ✅ |
| Loading Overlay | ✅ |
| Form Validation | ✅ |
| Clean Architecture | ✅ |
| Backend Agnostic | ✅ |
| Firebase Ready | ✅ |
| Unit Tests | ✅ |
