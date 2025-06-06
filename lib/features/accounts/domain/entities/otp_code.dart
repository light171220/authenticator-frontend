import 'package:equatable/equatable.dart';

class OTPCode extends Equatable {
  final String accountId;
  final String code;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final int remainingSeconds;
  final double progress;
  final bool isExpired;

  const OTPCode({
    required this.accountId,
    required this.code,
    required this.generatedAt,
    required this.expiresAt,
    required this.remainingSeconds,
    required this.progress,
    required this.isExpired,
  });

  OTPCode copyWith({
    String? accountId,
    String? code,
    DateTime? generatedAt,
    DateTime? expiresAt,
    int? remainingSeconds,
    double? progress,
    bool? isExpired,
  }) {
    return OTPCode(
      accountId: accountId ?? this.accountId,
      code: code ?? this.code,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      progress: progress ?? this.progress,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  String get formattedCode {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    } else if (code.length == 8) {
      return '${code.substring(0, 4)} ${code.substring(4)}';
    }
    return code;
  }

  bool get isExpiring => remainingSeconds <= 5;

  @override
  List<Object> get props => [
        accountId,
        code,
        generatedAt,
        expiresAt,
        remainingSeconds,
        progress,
        isExpired,
      ];
}

class QRScanResult extends Equatable {
  final String secret;
  final String serviceName;
  final String accountName;
  final String issuer;
  final String algorithm;
  final int digits;
  final int period;
  final int? counter;
  final String type;

  const QRScanResult({
    required this.secret,
    required this.serviceName,
    required this.accountName,
    required this.issuer,
    required this.algorithm,
    required this.digits,
    required this.period,
    this.counter,
    required this.type,
  });

  @override
  List<Object?> get props => [
        secret,
        serviceName,
        accountName,
        issuer,
        algorithm,
        digits,
        period,
        counter,
        type,
      ];
}

class OTPProgress extends Equatable {
  final String accountId;
  final double progress;
  final int remainingSeconds;
  final bool isExpiring;

  const OTPProgress({
    required this.accountId,
    required this.progress,
    required this.remainingSeconds,
    required this.isExpiring,
  });

  @override
  List<Object> get props => [accountId, progress, remainingSeconds, isExpiring];
}