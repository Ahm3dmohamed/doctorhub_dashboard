import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../features/appointments/data/datasources/appointment_remote_datasource.dart';
import '../../features/appointments/data/repositories/appointment_repository_impl.dart';
import '../../features/appointments/domain/repositories/appointment_repository.dart';
import '../../features/appointments/presentation/cubit/appointment_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/clinics/data/datasources/clinic_remote_datasource.dart';
import '../../features/clinics/data/repositories/clinic_repository_impl.dart';
import '../../features/clinics/domain/repositories/clinic_repository.dart';
import '../../features/clinics/presentation/cubit/clinic_cubit.dart';
import '../../features/doctors/data/datasources/doctor_remote_datasource.dart';
import '../../features/doctors/data/repositories/doctor_repository_impl.dart';
import '../../features/doctors/domain/repositories/doctor_repository.dart';
import '../../features/doctors/presentation/cubit/doctor_cubit.dart';
import '../../features/patients/data/datasources/patient_remote_datasource.dart';
import '../../features/patients/data/repositories/patient_repository_impl.dart';
import '../../features/patients/domain/repositories/patient_repository.dart';
import '../../features/patients/presentation/cubit/patient_cubit.dart';

import '../../features/medical_records/data/datasources/medical_record_remote_datasource.dart';
import '../../features/medical_records/data/repositories/medical_record_repository_impl.dart';
import '../../features/medical_records/domain/repositories/medical_record_repository.dart';
import '../../features/medical_records/presentation/cubit/medical_record_cubit.dart';
import '../../features/notifications/data/datasources/notification_remote_datasource.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/prescriptions/data/datasources/prescription_remote_datasource.dart';
import '../../features/prescriptions/data/repositories/prescription_repository_impl.dart';
import '../../features/prescriptions/domain/repositories/prescription_repository.dart';
import '../../features/prescriptions/presentation/cubit/prescription_cubit.dart';
import '../../features/reports/data/datasources/report_remote_datasource.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/repositories/report_repository.dart';
import '../../features/reports/presentation/cubit/report_cubit.dart';
import '../../features/reviews/data/datasources/review_remote_datasource.dart';
import '../../features/reviews/data/repositories/review_repository_impl.dart';
import '../../features/reviews/domain/repositories/review_repository.dart';
import '../../features/reviews/presentation/cubit/review_cubit.dart';

/// Service Locator — GetIt dependency injection container
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> configureDependencies() async {
  // ─── External ────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ─── Core ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ─── Data Sources ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<DoctorRemoteDataSource>(() => DoctorRemoteDataSourceImpl());
  sl.registerLazySingleton<ClinicRemoteDataSource>(() => ClinicRemoteDataSourceImpl());
  sl.registerLazySingleton<PatientRemoteDataSource>(() => PatientRemoteDataSourceImpl());
  sl.registerLazySingleton<AppointmentRemoteDataSource>(() => AppointmentRemoteDataSourceImpl());
  sl.registerLazySingleton<MedicalRecordRemoteDataSource>(() => MedicalRecordRemoteDataSourceImpl());
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(() => PrescriptionRemoteDataSourceImpl());
  sl.registerLazySingleton<ReviewRemoteDataSource>(() => ReviewRemoteDataSourceImpl());
  sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl());
  sl.registerLazySingleton<ReportRemoteDataSource>(() => ReportRemoteDataSourceImpl());

  // ─── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<DoctorRepository>(() => DoctorRepositoryImpl(sl()));
  sl.registerLazySingleton<ClinicRepository>(() => ClinicRepositoryImpl(sl()));
  sl.registerLazySingleton<PatientRepository>(() => PatientRepositoryImpl(sl()));
  sl.registerLazySingleton<AppointmentRepository>(() => AppointmentRepositoryImpl(sl()));
  sl.registerLazySingleton<MedicalRecordRepository>(() => MedicalRecordRepositoryImpl(sl()));
  sl.registerLazySingleton<PrescriptionRepository>(() => PrescriptionRepositoryImpl(sl()));
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(sl()));
  sl.registerLazySingleton<ReportRepository>(() => ReportRepositoryImpl(sl()));

  // ─── Use Cases ────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // ─── Cubits ───────────────────────────────────────────────────────────────
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory<DoctorCubit>(() => DoctorCubit(sl()));
  sl.registerFactory<ClinicCubit>(() => ClinicCubit(sl()));
  sl.registerFactory<PatientCubit>(() => PatientCubit(sl()));
  sl.registerFactory<AppointmentCubit>(() => AppointmentCubit(sl()));
  sl.registerFactory<MedicalRecordCubit>(() => MedicalRecordCubit(sl()));
  sl.registerFactory<PrescriptionCubit>(() => PrescriptionCubit(sl()));
  sl.registerFactory<ReviewCubit>(() => ReviewCubit(sl()));
  sl.registerFactory<NotificationCubit>(() => NotificationCubit(sl()));
  sl.registerFactory<ReportCubit>(() => ReportCubit(sl()));
}
