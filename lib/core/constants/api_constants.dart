/// DoctorHub — API & Endpoint Constants
abstract class ApiConstants {
  // ─── Base URLs ────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://api.doctorhub.io/v1';
  static const String mockBaseUrl = 'https://mock.doctorhub.io/v1';

  // ─── Timeouts ─────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ─── Headers ──────────────────────────────────────────────────────────────
  static const String headerAuthorization = 'Authorization';
  static const String headerContentType = 'Content-Type';
  static const String headerAccept = 'Accept';
  static const String headerApiVersion = 'X-Api-Version';
  static const String contentTypeJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';
  static const String apiVersion = '1';

  // ─── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String me = '/auth/me';

  // ─── User Endpoints ───────────────────────────────────────────────────────
  static const String users = '/users';
  static const String userById = '/users/{id}';
  static const String updateProfile = '/users/{id}/profile';

  // ─── Doctor Endpoints ─────────────────────────────────────────────────────
  static const String doctors = '/doctors';
  static const String doctorById = '/doctors/{id}';

  // ─── Patient Endpoints ────────────────────────────────────────────────────
  static const String patients = '/patients';
  static const String patientById = '/patients/{id}';

  // ─── Appointment Endpoints ────────────────────────────────────────────────
  static const String appointments = '/appointments';
  static const String appointmentById = '/appointments/{id}';

  // ─── Clinic Endpoints ─────────────────────────────────────────────────────
  static const String clinics = '/clinics';
  static const String clinicById = '/clinics/{id}';

  // ─── Analytics ────────────────────────────────────────────────────────────
  static const String dashboardStats = '/analytics/dashboard';
  static const String revenueStats = '/analytics/revenue';
}
