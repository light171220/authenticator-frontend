import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final List<String> scopes;
  final Map<String, dynamic>? metadata;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.issuedAt,
    required this.expiresAt,
    required this.scopes,
    this.metadata,
  });

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    DateTime? issuedAt,
    DateTime? expiresAt,
    List<String>? scopes,
    Map<String, dynamic>? metadata,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      scopes: scopes ?? this.scopes,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  bool get isExpiringSoon {
    final now = DateTime.now();
    final fiveMinutesFromNow = now.add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  Duration get timeUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  bool hasScope(String scope) => scopes.contains(scope);

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        issuedAt,
        expiresAt,
        scopes,
        metadata,
      ];
}

class BiometricToken extends Equatable {
  final String token;
  final String keyAlias;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String biometricType;

  const BiometricToken({
    required this.token,
    required this.keyAlias,
    required this.createdAt,
    required this.expiresAt,
    required this.biometricType,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object> get props => [token, keyAlias, createdAt, expiresAt, biometricType];
}