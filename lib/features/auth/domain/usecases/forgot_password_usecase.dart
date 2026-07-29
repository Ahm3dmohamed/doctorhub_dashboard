import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// ForgotPassword UseCase — Sends reset email
class ForgotPasswordUseCase implements UseCase<String, ForgotPasswordParams> {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(email: params.email);
  }
}

/// ForgotPasswordParams
class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object> get props => [email];
}

/// ResetPassword UseCase
class ResetPasswordUseCase implements UseCase<bool, ResetPasswordParams> {
  final AuthRepository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams params) {
    return _repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}

/// ResetPasswordParams
class ResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordParams({required this.token, required this.newPassword});

  @override
  List<Object> get props => [token, newPassword];
}
