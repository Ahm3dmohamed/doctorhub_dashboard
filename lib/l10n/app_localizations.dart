import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'DoctorHub'**
  String get appName;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navPatients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get navPatients;

  /// No description provided for @navAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get navAppointments;

  /// No description provided for @navClinics.
  ///
  /// In en, this message translates to:
  /// **'Clinics'**
  String get navClinics;

  /// No description provided for @navDoctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get navDoctors;

  /// No description provided for @navMedicalRecords.
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get navMedicalRecords;

  /// No description provided for @navPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get navPrescriptions;

  /// No description provided for @navReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get navReviews;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get commonFilter;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commonActions;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get commonTime;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonName;

  /// No description provided for @commonEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get commonEmail;

  /// No description provided for @commonPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get commonPhone;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @commonDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get commonDetails;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get commonNoData;

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get commonWarning;

  /// No description provided for @commonInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get commonInfo;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonEnglish;

  /// No description provided for @commonArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get commonArabic;

  /// No description provided for @commonDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get commonDarkMode;

  /// No description provided for @commonLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get commonLightMode;

  /// No description provided for @commonSwitchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get commonSwitchLanguage;

  /// No description provided for @valRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get valRequired;

  /// No description provided for @valInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get valInvalidEmail;

  /// No description provided for @valInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get valInvalidPhone;

  /// No description provided for @valPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get valPasswordLength;

  /// No description provided for @valPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get valPasswordMismatch;

  /// No description provided for @valInvalidToken.
  ///
  /// In en, this message translates to:
  /// **'Reset code must be 6 characters'**
  String get valInvalidToken;

  /// No description provided for @authSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get authSuperAdmin;

  /// No description provided for @authDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get authDoctor;

  /// No description provided for @authClinicManager.
  ///
  /// In en, this message translates to:
  /// **'Clinic Manager'**
  String get authClinicManager;

  /// No description provided for @authTheModernWayToManage.
  ///
  /// In en, this message translates to:
  /// **'The Modern Way To Manage'**
  String get authTheModernWayToManage;

  /// No description provided for @authHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get authHealthcare;

  /// No description provided for @authHealthcarePlatform.
  ///
  /// In en, this message translates to:
  /// **'Healthcare Platform'**
  String get authHealthcarePlatform;

  /// No description provided for @authDoctorHubCentralizes.
  ///
  /// In en, this message translates to:
  /// **'DoctorHub centralizes patient records, appointments,\nand analytics for doctors, clinics, and administrators.'**
  String get authDoctorHubCentralizes;

  /// No description provided for @authRealTimeAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Real-time analytics & insights'**
  String get authRealTimeAnalytics;

  /// No description provided for @authPatientManagement.
  ///
  /// In en, this message translates to:
  /// **'Patient management simplified'**
  String get authPatientManagement;

  /// No description provided for @authSmartAppointment.
  ///
  /// In en, this message translates to:
  /// **'Smart appointment scheduling'**
  String get authSmartAppointment;

  /// No description provided for @authHippaCompliant.
  ///
  /// In en, this message translates to:
  /// **'HIPAA-compliant & secure'**
  String get authHippaCompliant;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get authWelcomeBack;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access the DoctorHub dashboard.'**
  String get authLoginSubtitle;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get authRememberMe;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOut;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No worries! Enter your email address and we\'ll send you a reset link.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get authBackToLogin;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the reset code sent to your email.'**
  String get authResetPasswordSubtitle;

  /// No description provided for @authResetCode.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get authResetCode;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authResetPasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPasswordBtn;

  /// No description provided for @authResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get authResetSuccess;

  /// No description provided for @authSelectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role to Quick Fill:'**
  String get authSelectRole;

  /// No description provided for @authSecureLogin.
  ///
  /// In en, this message translates to:
  /// **'Secure login'**
  String get authSecureLogin;

  /// No description provided for @authEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get authEmailAddress;

  /// No description provided for @authProtectedByDoctorhub.
  ///
  /// In en, this message translates to:
  /// **'Protected by Doctorhub'**
  String get authProtectedByDoctorhub;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get authPasswordIncorrect;

  /// No description provided for @dashWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String dashWelcome(String name);

  /// No description provided for @dashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening across DoctorHub today.'**
  String get dashSubtitle;

  /// No description provided for @dashTotalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get dashTotalPatients;

  /// No description provided for @dashTodayAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get dashTodayAppointments;

  /// No description provided for @dashPendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get dashPendingReviews;

  /// No description provided for @dashActiveDoctors.
  ///
  /// In en, this message translates to:
  /// **'Active Doctors'**
  String get dashActiveDoctors;

  /// No description provided for @dashQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashQuickActions;

  /// No description provided for @dashRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashRecentActivity;

  /// No description provided for @dashBookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get dashBookAppointment;

  /// No description provided for @dashAddPatient.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient'**
  String get dashAddPatient;

  /// No description provided for @dashNewPrescription.
  ///
  /// In en, this message translates to:
  /// **'New Prescription'**
  String get dashNewPrescription;

  /// No description provided for @dashCreateNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get dashCreateNotification;

  /// No description provided for @dashViewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Executive Reports'**
  String get dashViewAnalytics;

  /// No description provided for @patientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Directory'**
  String get patientsTitle;

  /// No description provided for @patientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage patient medical records, allergies, and emergency contacts'**
  String get patientsSubtitle;

  /// No description provided for @patientsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get patientsAdd;

  /// No description provided for @patientsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Patient'**
  String get patientsEdit;

  /// No description provided for @patientsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search patients by name, email, phone...'**
  String get patientsSearchHint;

  /// No description provided for @patientsMedicalSummary.
  ///
  /// In en, this message translates to:
  /// **'Medical Summary — {name}'**
  String patientsMedicalSummary(String name);

  /// No description provided for @patientsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Patient Record'**
  String get patientsDeleteConfirmTitle;

  /// No description provided for @patientsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String patientsDeleteConfirmMessage(String name);

  /// No description provided for @patientsAgeGender.
  ///
  /// In en, this message translates to:
  /// **'Age / Gender'**
  String get patientsAgeGender;

  /// No description provided for @patientsBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get patientsBloodGroup;

  /// No description provided for @patientsEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get patientsEmergencyContact;

  /// No description provided for @patientsMedicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get patientsMedicalHistory;

  /// No description provided for @patientsKnownAllergies.
  ///
  /// In en, this message translates to:
  /// **'Known Allergies'**
  String get patientsKnownAllergies;

  /// No description provided for @patientsAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get patientsAge;

  /// No description provided for @patientsGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get patientsGender;

  /// No description provided for @apptsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments Management'**
  String get apptsTitle;

  /// No description provided for @apptsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule, reschedule, filter and track patient consultations'**
  String get apptsSubtitle;

  /// No description provided for @apptsBook.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get apptsBook;

  /// No description provided for @apptsReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get apptsReschedule;

  /// No description provided for @apptsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search appointments by patient, doctor, specialty...'**
  String get apptsSearchHint;

  /// No description provided for @apptsAll.
  ///
  /// In en, this message translates to:
  /// **'All Appointments'**
  String get apptsAll;

  /// No description provided for @apptsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get apptsToday;

  /// No description provided for @apptsUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get apptsUpcoming;

  /// No description provided for @apptsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get apptsCompleted;

  /// No description provided for @apptsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get apptsCancelled;

  /// No description provided for @apptsTableTab.
  ///
  /// In en, this message translates to:
  /// **'Table View'**
  String get apptsTableTab;

  /// No description provided for @apptsCalendarTab.
  ///
  /// In en, this message translates to:
  /// **'Calendar View'**
  String get apptsCalendarTab;

  /// No description provided for @apptsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get apptsDoctor;

  /// No description provided for @apptsPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get apptsPatient;

  /// No description provided for @apptsDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get apptsDateTime;

  /// No description provided for @apptsType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get apptsType;

  /// No description provided for @apptsFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get apptsFee;

  /// No description provided for @apptsNewDate.
  ///
  /// In en, this message translates to:
  /// **'New Date'**
  String get apptsNewDate;

  /// No description provided for @apptsNewTime.
  ///
  /// In en, this message translates to:
  /// **'New Time Slot'**
  String get apptsNewTime;

  /// No description provided for @apptsReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for Rescheduling'**
  String get apptsReason;

  /// No description provided for @apptsCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get apptsCancelConfirmTitle;

  /// No description provided for @apptsCancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the appointment for {name}?'**
  String apptsCancelConfirmMessage(String name);

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// No description provided for @statusInConsultation.
  ///
  /// In en, this message translates to:
  /// **'In Consultation'**
  String get statusInConsultation;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'No Show'**
  String get statusNoShow;

  /// No description provided for @clinicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinics Directory'**
  String get clinicsTitle;

  /// No description provided for @clinicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage health centers, operating hours, addresses, and medical teams'**
  String get clinicsSubtitle;

  /// No description provided for @clinicsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Clinic'**
  String get clinicsAdd;

  /// No description provided for @clinicsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Clinic'**
  String get clinicsEdit;

  /// No description provided for @clinicsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search clinics by name, address, phone...'**
  String get clinicsSearchHint;

  /// No description provided for @clinicsName.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name'**
  String get clinicsName;

  /// No description provided for @clinicsAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get clinicsAddress;

  /// No description provided for @clinicsWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get clinicsWorkingHours;

  /// No description provided for @clinicsRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get clinicsRating;

  /// No description provided for @clinicsViewLocation.
  ///
  /// In en, this message translates to:
  /// **'View Location'**
  String get clinicsViewLocation;

  /// No description provided for @clinicsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Clinic'**
  String get clinicsDeleteConfirmTitle;

  /// No description provided for @clinicsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String clinicsDeleteConfirmMessage(String name);

  /// No description provided for @doctorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Doctors Directory'**
  String get doctorsTitle;

  /// No description provided for @doctorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage registered medical specialists, schedules, ratings, and fees'**
  String get doctorsSubtitle;

  /// No description provided for @doctorsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Doctor'**
  String get doctorsAdd;

  /// No description provided for @doctorsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Doctor'**
  String get doctorsEdit;

  /// No description provided for @doctorsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search doctors by name, specialty, clinic...'**
  String get doctorsSearchHint;

  /// No description provided for @doctorsSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get doctorsSpecialty;

  /// No description provided for @doctorsConsultationFee.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fee'**
  String get doctorsConsultationFee;

  /// No description provided for @doctorsAvailability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get doctorsAvailability;

  /// No description provided for @doctorsExperience.
  ///
  /// In en, this message translates to:
  /// **'Years Experience'**
  String get doctorsExperience;

  /// No description provided for @doctorsBio.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get doctorsBio;

  /// No description provided for @doctorsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Doctor'**
  String get doctorsDeleteConfirmTitle;

  /// No description provided for @doctorsDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String doctorsDeleteConfirmMessage(String name);

  /// No description provided for @medTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Records'**
  String get medTitle;

  /// No description provided for @medSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access patient medical histories, clinical notes, lab results, and diagnoses'**
  String get medSubtitle;

  /// No description provided for @medSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search records by patient, diagnosis, doctor...'**
  String get medSearchHint;

  /// No description provided for @medDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get medDiagnosis;

  /// No description provided for @medClinicalNotes.
  ///
  /// In en, this message translates to:
  /// **'Clinical Notes'**
  String get medClinicalNotes;

  /// No description provided for @medLabResults.
  ///
  /// In en, this message translates to:
  /// **'Lab Results / Attachments'**
  String get medLabResults;

  /// No description provided for @medTimelineView.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get medTimelineView;

  /// No description provided for @medMasterDetailView.
  ///
  /// In en, this message translates to:
  /// **'Master Detail'**
  String get medMasterDetailView;

  /// No description provided for @rxTitle.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get rxTitle;

  /// No description provided for @rxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Issue, track, search, and export patient digital prescriptions'**
  String get rxSubtitle;

  /// No description provided for @rxCreate.
  ///
  /// In en, this message translates to:
  /// **'New Prescription'**
  String get rxCreate;

  /// No description provided for @rxSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search prescriptions by patient, doctor, medicine...'**
  String get rxSearchHint;

  /// No description provided for @rxNoFound.
  ///
  /// In en, this message translates to:
  /// **'No prescriptions found.'**
  String get rxNoFound;

  /// No description provided for @rxMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get rxMedicineName;

  /// No description provided for @rxDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get rxDosage;

  /// No description provided for @rxFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get rxFrequency;

  /// No description provided for @rxDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get rxDuration;

  /// No description provided for @rxInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get rxInstructions;

  /// No description provided for @rxAddMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get rxAddMedicine;

  /// No description provided for @rxExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get rxExportPdf;

  /// No description provided for @rxGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF for {id}...'**
  String rxGeneratingPdf(String id);

  /// No description provided for @rxActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get rxActive;

  /// No description provided for @rxCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get rxCompleted;

  /// No description provided for @rxCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get rxCancelled;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications Center'**
  String get notifTitle;

  /// No description provided for @notifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Broadcast announcements, appointment reminders, and system alerts'**
  String get notifSubtitle;

  /// No description provided for @notifCreate.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get notifCreate;

  /// No description provided for @notifMessage.
  ///
  /// In en, this message translates to:
  /// **'Notification Message'**
  String get notifMessage;

  /// No description provided for @notifType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get notifType;

  /// No description provided for @notifTarget.
  ///
  /// In en, this message translates to:
  /// **'Target Audience'**
  String get notifTarget;

  /// No description provided for @notifSent.
  ///
  /// In en, this message translates to:
  /// **'Sent At'**
  String get notifSent;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports & Executive Analytics'**
  String get reportsTitle;

  /// No description provided for @reportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track platform revenue, doctor/clinic performance KPIs and patient growth metrics'**
  String get reportsSubtitle;

  /// No description provided for @reportsExportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get reportsExportExcel;

  /// No description provided for @reportsExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF Report'**
  String get reportsExportPdf;

  /// No description provided for @reportsMonthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get reportsMonthlyRevenue;

  /// No description provided for @reportsTotalAppointments.
  ///
  /// In en, this message translates to:
  /// **'Total Appointments'**
  String get reportsTotalAppointments;

  /// No description provided for @reportsNewPatients.
  ///
  /// In en, this message translates to:
  /// **'New Patients'**
  String get reportsNewPatients;

  /// No description provided for @reportsAvgDoctorRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Doctor Rating'**
  String get reportsAvgDoctorRating;

  /// No description provided for @reportsRevenueOverview.
  ///
  /// In en, this message translates to:
  /// **'Revenue Overview'**
  String get reportsRevenueOverview;

  /// No description provided for @reportsTopDoctors.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Doctors'**
  String get reportsTopDoctors;

  /// No description provided for @reportsTopClinics.
  ///
  /// In en, this message translates to:
  /// **'Top Performing Clinics'**
  String get reportsTopClinics;

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ratings & Reviews Management'**
  String get reviewsTitle;

  /// No description provided for @reviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor patient ratings, reply to clinic and doctor feedback, and manage customer sentiment'**
  String get reviewsSubtitle;

  /// No description provided for @reviewsAvgRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get reviewsAvgRating;

  /// No description provided for @reviewsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get reviewsTotal;

  /// No description provided for @reviewsResponseRate.
  ///
  /// In en, this message translates to:
  /// **'Response Rate'**
  String get reviewsResponseRate;

  /// No description provided for @reviewsAll.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get reviewsAll;

  /// No description provided for @reviewsDoctorTab.
  ///
  /// In en, this message translates to:
  /// **'Doctor Reviews'**
  String get reviewsDoctorTab;

  /// No description provided for @reviewsClinicTab.
  ///
  /// In en, this message translates to:
  /// **'Clinic Reviews'**
  String get reviewsClinicTab;

  /// No description provided for @reviewsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search reviews by doctor name, clinic, author or keyword...'**
  String get reviewsSearchHint;

  /// No description provided for @reviewsReply.
  ///
  /// In en, this message translates to:
  /// **'Reply to Review'**
  String get reviewsReply;

  /// No description provided for @reviewsTypeReply.
  ///
  /// In en, this message translates to:
  /// **'Type your response...'**
  String get reviewsTypeReply;

  /// No description provided for @reviewsSendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get reviewsSendReply;

  /// No description provided for @reviewsNoFound.
  ///
  /// In en, this message translates to:
  /// **'No reviews found.'**
  String get reviewsNoFound;

  /// No description provided for @actNewPatient.
  ///
  /// In en, this message translates to:
  /// **'New patient registered'**
  String get actNewPatient;

  /// No description provided for @actAptCompleted.
  ///
  /// In en, this message translates to:
  /// **'Appointment completed'**
  String get actAptCompleted;

  /// No description provided for @actAptRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment rescheduled'**
  String get actAptRescheduled;

  /// No description provided for @actLabUploaded.
  ///
  /// In en, this message translates to:
  /// **'Lab results uploaded'**
  String get actLabUploaded;

  /// No description provided for @actSystemAlert.
  ///
  /// In en, this message translates to:
  /// **'System alert'**
  String get actSystemAlert;

  /// No description provided for @actTimeMinAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String actTimeMinAgo(int count);

  /// No description provided for @actTimeHrAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String actTimeHrAgo(int count);

  /// No description provided for @actTimeHrsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hrs ago'**
  String actTimeHrsAgo(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
