/// Password strength levels
enum PasswordStrength { empty, weak, fair, good, strong }

/// Validation utilities for auth forms
class AuthValidators {
  AuthValidators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static PasswordStrength getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.empty;

    int score = 0;

    // Length
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) score++;

    // Contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) score++;

    // Contains number
    if (password.contains(RegExp(r'[0-9]'))) score++;

    // Contains special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return switch (score) {
      <= 1 => PasswordStrength.weak,
      2 => PasswordStrength.fair,
      3 || 4 => PasswordStrength.good,
      _ => PasswordStrength.strong,
    };
  }

  static String getStrengthLabel(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.empty => '',
      PasswordStrength.weak => 'Weak',
      PasswordStrength.fair => 'Fair',
      PasswordStrength.good => 'Good',
      PasswordStrength.strong => 'Strong',
    };
  }

  static double getStrengthValue(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.empty => 0.0,
      PasswordStrength.weak => 0.25,
      PasswordStrength.fair => 0.5,
      PasswordStrength.good => 0.75,
      PasswordStrength.strong => 1.0,
    };
  }
}
