import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Authentication Cubit
/// Manages the entire authentication lifecycle for the DoctorHub dashboard
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final AuthRepository _authRepository;

  AuthCubit(
    this._loginUseCase,
    this._forgotPasswordUseCase,
    this._resetPasswordUseCase,
    this._authRepository,
  ) : super(const AuthInitial());

  // ─── Check Existing Session ───────────────────────────────────────────────

  /// Called on app startup — restores session from cache
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final isAuthResult = await _authRepository.isAuthenticated();

    await isAuthResult.fold(
      (_) async => emit(const AuthUnauthenticated()),
      (isAuthenticated) async {
        if (!isAuthenticated) {
          emit(const AuthUnauthenticated());
          return;
        }

        final userResult = await _authRepository.getCachedUser();
        userResult.fold(
          (_) => emit(const AuthUnauthenticated()),
          (user) {
            if (user != null) {
              emit(AuthAuthenticated(user));
            } else {
              emit(const AuthUnauthenticated());
            }
          },
        );
      },
    );
  }

  // ─── Login ────────────────────────────────────────────────────────────────

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: email, password: password, rememberMe: rememberMe),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message, code: failure.code)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // ─── Forgot Password ──────────────────────────────────────────────────────

  Future<void> forgotPassword({required String email}) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: email),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message, code: failure.code)),
      (message) => emit(AuthForgotPasswordSent(email: email, message: message)),
    );
  }

  // ─── Reset Password ───────────────────────────────────────────────────────

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (state is AuthLoading) return;

    emit(const AuthLoading());

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(token: token, newPassword: newPassword),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message, code: failure.code)),
      (_) => emit(const AuthPasswordResetSuccess()),
    );
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    emit(const AuthLoading());
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  // ─── Clear Error ──────────────────────────────────────────────────────────

  void clearError() {
    if (state is AuthError) {
      emit(const AuthUnauthenticated());
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  bool get isAuthenticated => state is AuthAuthenticated;

  AuthAuthenticated? get authenticatedState =>
      state is AuthAuthenticated ? state as AuthAuthenticated : null;
}
