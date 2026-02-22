/// User entity - pure domain model, no external dependencies
class AuthUser {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final AuthProvider provider;

  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.provider = AuthProvider.email,
  });

  AuthUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? emailVerified,
    AuthProvider? provider,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      provider: provider ?? this.provider,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'AuthUser(id: $id, email: $email, displayName: $displayName)';
}

enum AuthProvider { email, google, apple, biometric }
