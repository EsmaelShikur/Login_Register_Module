/// Sealed class for typed auth failures
sealed class AuthFailure {
  final String message;
  const AuthFailure(this.message);
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('Invalid email address.');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('Incorrect password. Please try again.');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('No account found with this email.');
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super('An account already exists with this email.');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure()
      : super('Password is too weak. Use at least 8 characters.');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure()
      : super('Network error. Please check your connection.');
}

class GoogleSignInFailure extends AuthFailure {
  const GoogleSignInFailure() : super('Google Sign-In failed. Please try again.');
}

class AppleSignInFailure extends AuthFailure {
  const AppleSignInFailure() : super('Apple Sign-In failed. Please try again.');
}

class UnknownFailure extends AuthFailure {
  const UnknownFailure([String message = 'An unexpected error occurred.'])
      : super(message);
}
