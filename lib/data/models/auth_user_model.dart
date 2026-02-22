import '../../domain/entities/auth_user.dart';

/// Data model for AuthUser - adds serialization capabilities
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.emailVerified,
    super.provider,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      provider: AuthProvider.values.firstWhere(
        (e) => e.name == (json['provider'] as String? ?? 'email'),
        orElse: () => AuthProvider.email,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'emailVerified': emailVerified,
        'provider': provider.name,
      };

  factory AuthUserModel.fromDomain(AuthUser user) => AuthUserModel(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        emailVerified: user.emailVerified,
        provider: user.provider,
      );
}
