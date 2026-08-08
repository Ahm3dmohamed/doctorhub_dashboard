// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DoctorHub';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navPatients => 'Patients';

  @override
  String get navAppointments => 'Appointments';

  @override
  String get navClinics => 'Clinics';

  @override
  String get navDoctors => 'Doctors';

  @override
  String get navMedicalRecords => 'Medical Records';

  @override
  String get navPrescriptions => 'Prescriptions';

  @override
  String get navReviews => 'Reviews';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navReports => 'Reports & Analytics';

  @override
  String get navSettings => 'Settings';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonActions => 'Actions';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonDate => 'Date';

  @override
  String get commonTime => 'Time';

  @override
  String get commonName => 'Name';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonPhone => 'Phone';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonDetails => 'Details';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonNoData => 'No data available.';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonError => 'Error';

  @override
  String get commonWarning => 'Warning';

  @override
  String get commonInfo => 'Information';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonEnglish => 'English';

  @override
  String get commonArabic => 'العربية';

  @override
  String get commonDarkMode => 'Dark Mode';

  @override
  String get commonLightMode => 'Light Mode';

  @override
  String get commonSwitchLanguage => 'Switch Language';

  @override
  String get valRequired => 'This field is required';

  @override
  String get valInvalidEmail => 'Please enter a valid email address';

  @override
  String get valInvalidPhone => 'Please enter a valid phone number';

  @override
  String get valPasswordLength => 'Password must be at least 8 characters';

  @override
  String get valPasswordMismatch => 'Passwords do not match';

  @override
  String get valInvalidToken => 'Reset code must be 6 characters';

  @override
  String get authWelcomeBack => 'Welcome back!';

  @override
  String get authLoginSubtitle =>
      'Enter your credentials to access the DoctorHub dashboard.';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authRememberMe => 'Remember Me';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignOut => 'Sign Out';

  @override
  String get authForgotPasswordTitle => 'Forgot password?';

  @override
  String get authForgotPasswordSubtitle =>
      'No worries! Enter your email address and we\'ll send you a reset link.';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authBackToLogin => 'Back to login';

  @override
  String get authResetPasswordTitle => 'Set new password';

  @override
  String get authResetPasswordSubtitle =>
      'Enter the reset code sent to your email.';

  @override
  String get authResetCode => 'Reset Code';

  @override
  String get authNewPassword => 'New Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authResetPasswordBtn => 'Reset Password';

  @override
  String get authResetSuccess => 'Password reset successfully!';

  @override
  String get authSelectRole => 'Select Role to Quick Fill:';

  @override
  String dashWelcome(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get dashSubtitle =>
      'Here\'s what\'s happening across DoctorHub today.';

  @override
  String get dashTotalPatients => 'Total Patients';

  @override
  String get dashTodayAppointments => 'Today\'s Appointments';

  @override
  String get dashPendingReviews => 'Pending Reviews';

  @override
  String get dashActiveDoctors => 'Active Doctors';

  @override
  String get dashQuickActions => 'Quick Actions';

  @override
  String get dashRecentActivity => 'Recent Activity';

  @override
  String get dashBookAppointment => 'Book Appointment';

  @override
  String get dashAddPatient => 'Add New Patient';

  @override
  String get dashNewPrescription => 'New Prescription';

  @override
  String get dashCreateNotification => 'Send Notification';

  @override
  String get dashViewAnalytics => 'View Executive Reports';

  @override
  String get patientsTitle => 'Patient Directory';

  @override
  String get patientsSubtitle =>
      'Manage patient medical records, allergies, and emergency contacts';

  @override
  String get patientsAdd => 'Add Patient';

  @override
  String get patientsEdit => 'Edit Patient';

  @override
  String get patientsSearchHint => 'Search patients by name, email, phone...';

  @override
  String patientsMedicalSummary(String name) {
    return 'Medical Summary — $name';
  }

  @override
  String get patientsDeleteConfirmTitle => 'Delete Patient Record';

  @override
  String patientsDeleteConfirmMessage(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String get patientsAgeGender => 'Age / Gender';

  @override
  String get patientsBloodGroup => 'Blood Group';

  @override
  String get patientsEmergencyContact => 'Emergency Contact';

  @override
  String get patientsMedicalHistory => 'Medical History';

  @override
  String get patientsKnownAllergies => 'Known Allergies';

  @override
  String get patientsAge => 'Age';

  @override
  String get patientsGender => 'Gender';

  @override
  String get apptsTitle => 'Appointments Management';

  @override
  String get apptsSubtitle =>
      'Schedule, reschedule, filter and track patient consultations';

  @override
  String get apptsBook => 'Book Appointment';

  @override
  String get apptsReschedule => 'Reschedule';

  @override
  String get apptsSearchHint =>
      'Search appointments by patient, doctor, specialty...';

  @override
  String get apptsAll => 'All Appointments';

  @override
  String get apptsToday => 'Today';

  @override
  String get apptsUpcoming => 'Upcoming';

  @override
  String get apptsCompleted => 'Completed';

  @override
  String get apptsCancelled => 'Cancelled';

  @override
  String get apptsTableTab => 'Table View';

  @override
  String get apptsCalendarTab => 'Calendar View';

  @override
  String get apptsDoctor => 'Doctor';

  @override
  String get apptsPatient => 'Patient';

  @override
  String get apptsDateTime => 'Date & Time';

  @override
  String get apptsType => 'Type';

  @override
  String get apptsFee => 'Fee';

  @override
  String get apptsNewDate => 'New Date';

  @override
  String get apptsNewTime => 'New Time Slot';

  @override
  String get apptsReason => 'Reason for Rescheduling';

  @override
  String get apptsCancelConfirmTitle => 'Cancel Appointment';

  @override
  String apptsCancelConfirmMessage(String name) {
    return 'Are you sure you want to cancel the appointment for $name?';
  }

  @override
  String get statusScheduled => 'Scheduled';

  @override
  String get statusInConsultation => 'In Consultation';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusNoShow => 'No Show';

  @override
  String get clinicsTitle => 'Clinics Directory';

  @override
  String get clinicsSubtitle =>
      'Manage health centers, operating hours, addresses, and medical teams';

  @override
  String get clinicsAdd => 'Add Clinic';

  @override
  String get clinicsEdit => 'Edit Clinic';

  @override
  String get clinicsSearchHint => 'Search clinics by name, address, phone...';

  @override
  String get clinicsName => 'Clinic Name';

  @override
  String get clinicsAddress => 'Address';

  @override
  String get clinicsWorkingHours => 'Working Hours';

  @override
  String get clinicsRating => 'Rating';

  @override
  String get clinicsViewLocation => 'View Location';

  @override
  String get clinicsDeleteConfirmTitle => 'Delete Clinic';

  @override
  String clinicsDeleteConfirmMessage(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String get doctorsTitle => 'Doctors Directory';

  @override
  String get doctorsSubtitle =>
      'Manage registered medical specialists, schedules, ratings, and fees';

  @override
  String get doctorsAdd => 'Add Doctor';

  @override
  String get doctorsEdit => 'Edit Doctor';

  @override
  String get doctorsSearchHint =>
      'Search doctors by name, specialty, clinic...';

  @override
  String get doctorsSpecialty => 'Specialty';

  @override
  String get doctorsConsultationFee => 'Consultation Fee';

  @override
  String get doctorsAvailability => 'Availability';

  @override
  String get doctorsExperience => 'Years Experience';

  @override
  String get doctorsBio => 'Biography';

  @override
  String get doctorsDeleteConfirmTitle => 'Delete Doctor';

  @override
  String doctorsDeleteConfirmMessage(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String get medTitle => 'Medical Records';

  @override
  String get medSubtitle =>
      'Access patient medical histories, clinical notes, lab results, and diagnoses';

  @override
  String get medSearchHint => 'Search records by patient, diagnosis, doctor...';

  @override
  String get medDiagnosis => 'Diagnosis';

  @override
  String get medClinicalNotes => 'Clinical Notes';

  @override
  String get medLabResults => 'Lab Results / Attachments';

  @override
  String get medTimelineView => 'Timeline';

  @override
  String get medMasterDetailView => 'Master Detail';

  @override
  String get rxTitle => 'Prescriptions';

  @override
  String get rxSubtitle =>
      'Issue, track, search, and export patient digital prescriptions';

  @override
  String get rxCreate => 'New Prescription';

  @override
  String get rxSearchHint =>
      'Search prescriptions by patient, doctor, medicine...';

  @override
  String get rxNoFound => 'No prescriptions found.';

  @override
  String get rxMedicineName => 'Medicine Name';

  @override
  String get rxDosage => 'Dosage';

  @override
  String get rxFrequency => 'Frequency';

  @override
  String get rxDuration => 'Duration';

  @override
  String get rxInstructions => 'Instructions';

  @override
  String get rxAddMedicine => 'Add Medicine';

  @override
  String get rxExportPdf => 'Export PDF';

  @override
  String rxGeneratingPdf(String id) {
    return 'Generating PDF for $id...';
  }

  @override
  String get rxActive => 'Active';

  @override
  String get rxCompleted => 'Completed';

  @override
  String get rxCancelled => 'Cancelled';

  @override
  String get notifTitle => 'Notifications Center';

  @override
  String get notifSubtitle =>
      'Broadcast announcements, appointment reminders, and system alerts';

  @override
  String get notifCreate => 'Send Notification';

  @override
  String get notifMessage => 'Notification Message';

  @override
  String get notifType => 'Type';

  @override
  String get notifTarget => 'Target Audience';

  @override
  String get notifSent => 'Sent At';

  @override
  String get reportsTitle => 'Reports & Executive Analytics';

  @override
  String get reportsSubtitle =>
      'Track platform revenue, doctor/clinic performance KPIs and patient growth metrics';

  @override
  String get reportsExportExcel => 'Export Excel';

  @override
  String get reportsExportPdf => 'Export PDF Report';

  @override
  String get reportsMonthlyRevenue => 'Monthly Revenue';

  @override
  String get reportsTotalAppointments => 'Total Appointments';

  @override
  String get reportsNewPatients => 'New Patients';

  @override
  String get reportsAvgDoctorRating => 'Avg Doctor Rating';

  @override
  String get reportsRevenueOverview => 'Revenue Overview';

  @override
  String get reportsTopDoctors => 'Top Performing Doctors';

  @override
  String get reportsTopClinics => 'Top Performing Clinics';

  @override
  String get reviewsTitle => 'Ratings & Reviews Management';

  @override
  String get reviewsSubtitle =>
      'Monitor patient ratings, reply to clinic and doctor feedback, and manage customer sentiment';

  @override
  String get reviewsAvgRating => 'Average Rating';

  @override
  String get reviewsTotal => 'Total Reviews';

  @override
  String get reviewsResponseRate => 'Response Rate';

  @override
  String get reviewsAll => 'All Reviews';

  @override
  String get reviewsDoctorTab => 'Doctor Reviews';

  @override
  String get reviewsClinicTab => 'Clinic Reviews';

  @override
  String get reviewsSearchHint =>
      'Search reviews by doctor name, clinic, author or keyword...';

  @override
  String get reviewsReply => 'Reply to Review';

  @override
  String get reviewsTypeReply => 'Type your response...';

  @override
  String get reviewsSendReply => 'Send Reply';

  @override
  String get reviewsNoFound => 'No reviews found.';
}
