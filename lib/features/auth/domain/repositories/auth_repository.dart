import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_token.dart';
import '../usecases/login_usecase.dart';
import '../usecases/register_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
    required String deviceId,
    required String deviceName,
  });

  Future<Either<Failure, RegisterResult>> register({
    required String email,
    required String password,
    String? name,
    required String deviceId,
    required String deviceName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);

  Future<Either<Failure, UserWithToken>> getCurrentUser();

  Future<Either<Failure, LoginResult>> biometricLogin();

  Future<Either<Failure, void>> enableBiometricAuth();

  Future<Either<Failure, void>> disableBiometricAuth();

  Future<Either<Failure, LoginResult>> verifyTwoFactor({
    required String code,
    required String twoFactorToken,
  });

  Future<Either<Failure, void>> requestPasswordReset(String email);

  Future<Either<Failure, void>> confirmPasswordReset({
    required String resetToken,
    required String newPassword,
  });

  Future<Either<Failure, void>> verifyEmail(String verificationCode);

  Future<Either<Failure, void>> resendEmailVerification();

  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? avatarUrl,
  });

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, User>> updateSecuritySettings(SecuritySettings settings);

  Future<Either<Failure, void>> deleteAccount(String password);

  Future<Either<Failure, bool>> checkEmailExists(String email);

  Future<Either<Failure, void>> enableTwoFactor();

  Future<Either<Failure, void>> disableTwoFactor(String password);

  Future<Either<Failure, String>> generateBackupCodes();

  Future<Either<Failure, void>> addDevice({
    required String deviceId,
    required String deviceName,
    required String deviceType,
  });

  Future<Either<Failure, void>> removeDevice(String deviceId);

  Future<Either<Failure, List<UserDevice>>> getDevices();

  Future<Either<Failure, void>> revokeAllSessions();

  Future<Either<Failure, List<LoginSession>>> getActiveSessions();

  Future<Either<Failure, void>> revokeSession(String sessionId);
}

class UserWithToken {
  final User user;
  final AuthToken token;

  const UserWithToken({
    required this.user,
    required this.token,
  });
}

class UserDevice {
  final String id;
  final String name;
  final String type;
  final DateTime lastActive;
  final bool isCurrentDevice;

  const UserDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.lastActive,
    required this.isCurrentDevice,
  });
}

class LoginSession {
  final String id;
  final String deviceId;
  final String deviceName;
  final String ipAddress;
  final String location;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool isCurrentSession;

  const LoginSession({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.ipAddress,
    required this.location,
    required this.createdAt,
    required this.lastActive,
    required this.isCurrentSession,
  });
}