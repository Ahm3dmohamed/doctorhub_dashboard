import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Auth Repository Implementation
/// Bridges the data layer (datasource) and domain layer (repository contract)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SharedPreferences _prefs;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._prefs,
  );

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache user if rememberMe is enabled
      if (rememberMe) {
        await _cacheUser(user);
      } else {
        // Always cache for session duration
        await _cacheUser(user);
      }

      await _prefs.setBool(AppConstants.keyRememberMe, rememberMe);

      return Right(user);
    } on InvalidCredentialsException catch (e) {
      return Left(InvalidCredentialsFailure(message: e.message));
    } on AccountLockedException catch (e) {
      return Left(AccountLockedFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({required String email}) async {
    try {
      final message = await _remoteDataSource.forgotPassword(email: email);
      return Right(message);
    } on EmailNotFoundException catch (e) {
      return Left(EmailNotFoundFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final result = await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return Right(result);
    } on TokenExpiredException catch (e) {
      return Left(TokenExpiredFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final token = _prefs.getString(AppConstants.keyAuthToken);
      if (token != null) {
        await _remoteDataSource.logout(token: token);
      }
      await _clearCache();
      return const Right(true);
    } catch (e) {
      // Always clear local cache even if remote logout fails
      await _clearCache();
      return const Right(true);
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final userJson = _prefs.getString(AppConstants.keyUser);
      if (userJson == null) return const Right(null);

      final user = UserModel.fromJsonString(userJson);
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = _prefs.getString(AppConstants.keyAuthToken);
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return const Right(false);
    }
  }

  // ─── Private Cache Helpers ────────────────────────────────────────────────

  Future<void> _cacheUser(UserModel user) async {
    await _prefs.setString(AppConstants.keyAuthToken, user.token);
    await _prefs.setString(AppConstants.keyUser, user.toJsonString());
    await _prefs.setString(AppConstants.keyUserRole, user.role.name);
  }

  Future<void> _clearCache() async {
    await _prefs.remove(AppConstants.keyAuthToken);
    await _prefs.remove(AppConstants.keyUser);
    await _prefs.remove(AppConstants.keyUserRole);
  }
}
