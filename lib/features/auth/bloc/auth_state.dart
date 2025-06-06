import 'package:equatable/equatable.dart';
import '../domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String deviceId;
  final String deviceName;

  const LoginRequested({
    required this.email,
    required this.password,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  List<Object> get props => [email, password, deviceId, deviceName];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? name;
  final String deviceId;
  final String deviceName;

  const RegisterRequested({
    required this.email,
    required this.password,
    this.name,
    required this.deviceId,
    required this.deviceName,
  });

  @override
  List<Object?> get props => [email, password, name, deviceId, deviceName];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class BiometricLoginRequested extends AuthEvent {
  const BiometricLoginRequested();
}

class TokenRefreshRequested extends AuthEvent {
  const TokenRefreshRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class TwoFactorVerificationRequested extends AuthEvent {
  final String code;
  final String twoFactorToken;

  const TwoFactorVerificationRequested({
    required this.code,
    required this.twoFactorToken,
  });

  @override
  List<Object> get props => [code, twoFactorToken];
}

class EmailVerificationRequested extends AuthEvent {
  final String verificationCode;

  const EmailVerificationRequested({
    required this.verificationCode,
  });

  @override
  List<Object> get props => [verificationCode];
}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class PasswordResetConfirmed extends AuthEvent {
  final String resetToken;
  final String newPassword;

  const PasswordResetConfirmed({
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object> get props => [resetToken, newPassword];
}

class UpdateSecuritySettings extends AuthEvent {
  final SecuritySettings settings;

  const UpdateSecuritySettings({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class EnableBiometricAuth extends AuthEvent {
  const EnableBiometricAuth();
}

class DisableBiometricAuth extends AuthEvent {
  const DisableBiometricAuth();
}

class ChangePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class UpdateProfile extends AuthEvent {
  final String? name;
  final String? avatarUrl;

  const UpdateProfile({
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, avatarUrl];
}

class DeleteAccount extends AuthEvent {
  final String password;

  const DeleteAccount({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}