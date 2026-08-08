// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'دكتور هب';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navPatients => 'المرضى';

  @override
  String get navAppointments => 'المواعيد';

  @override
  String get navClinics => 'العيادات';

  @override
  String get navDoctors => 'الأطباء';

  @override
  String get navMedicalRecords => 'السجلات الطبية';

  @override
  String get navPrescriptions => 'الوصفات الطبية';

  @override
  String get navReviews => 'التقييمات';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get navReports => 'التقارير والتحليلات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonFilter => 'تصفية';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonActions => 'الإجراءات';

  @override
  String get commonStatus => 'الحالة';

  @override
  String get commonDate => 'التاريخ';

  @override
  String get commonTime => 'الوقت';

  @override
  String get commonName => 'الاسم';

  @override
  String get commonEmail => 'البريد الإلكتروني';

  @override
  String get commonPhone => 'رقم الهاتف';

  @override
  String get commonNotes => 'ملاحظات';

  @override
  String get commonDetails => 'التفاصيل';

  @override
  String get commonLoading => 'جارٍ التحميل...';

  @override
  String get commonNoData => 'لا تتوفر بيانات.';

  @override
  String get commonSuccess => 'نجاح';

  @override
  String get commonError => 'خطأ';

  @override
  String get commonWarning => 'تحذير';

  @override
  String get commonInfo => 'معلومات';

  @override
  String get commonViewAll => 'عرض الكل';

  @override
  String get commonLanguage => 'اللغة';

  @override
  String get commonEnglish => 'English';

  @override
  String get commonArabic => 'العربية';

  @override
  String get commonDarkMode => 'الوضع الداكن';

  @override
  String get commonLightMode => 'الوضع الفاتح';

  @override
  String get commonSwitchLanguage => 'تغيير اللغة';

  @override
  String get valRequired => 'هذا الحقل مطلوب';

  @override
  String get valInvalidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get valInvalidPhone => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get valPasswordLength => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get valPasswordMismatch => 'كلمات المرور غير متطابقة';

  @override
  String get valInvalidToken => 'رمز إعادة التعيين يجب أن يتكون من 6 أحرف';

  @override
  String get authWelcomeBack => 'أهلاً بعودتك!';

  @override
  String get authLoginSubtitle =>
      'أدخل بيانات الاعتماد الخاصة بك للوصول إلى لوحة تحكم دكتور هب.';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authRememberMe => 'تذكرني';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authSignOut => 'تسجيل الخروج';

  @override
  String get authForgotPasswordTitle => 'هل نسيت كلمة المرور؟';

  @override
  String get authForgotPasswordSubtitle =>
      'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين.';

  @override
  String get authSendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get authBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get authResetPasswordTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get authResetPasswordSubtitle =>
      'أدخل رمز إعادة التعيين المرسل إلى بريدك الإلكتروني.';

  @override
  String get authResetCode => 'رمز إعادة التعيين';

  @override
  String get authNewPassword => 'كلمة المرور الجديدة';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authResetPasswordBtn => 'إعادة تعيين كلمة المرور';

  @override
  String get authResetSuccess => 'تمت إعادة تعيين كلمة المرور بنجاح!';

  @override
  String get authSelectRole => 'اختر دوراً للتعبئة السريعة:';

  @override
  String dashWelcome(String name) {
    return 'أهلاً بعودتك، $name!';
  }

  @override
  String get dashSubtitle => 'إليك ما يحدث عبر دكتور هب اليوم.';

  @override
  String get dashTotalPatients => 'إجمالي المرضى';

  @override
  String get dashTodayAppointments => 'مواعيد اليوم';

  @override
  String get dashPendingReviews => 'التقييمات المعلقة';

  @override
  String get dashActiveDoctors => 'الأطباء النشطون';

  @override
  String get dashQuickActions => 'إجراءات سريعة';

  @override
  String get dashRecentActivity => 'النشاط الحديث';

  @override
  String get dashBookAppointment => 'حجز موعد';

  @override
  String get dashAddPatient => 'إضافة مريض جديد';

  @override
  String get dashNewPrescription => 'وصفة طبية جديدة';

  @override
  String get dashCreateNotification => 'إرسال إشعار';

  @override
  String get dashViewAnalytics => 'عرض التقارير التنفيذية';

  @override
  String get patientsTitle => 'دليل المرضى';

  @override
  String get patientsSubtitle =>
      'إدارة السجلات الطبية للمرضى والحساسية وجهات اتصال الطوارئ';

  @override
  String get patientsAdd => 'إضافة مريض';

  @override
  String get patientsEdit => 'تعديل مريض';

  @override
  String get patientsSearchHint => 'البحث عن مرضى بالاسم، البريد، الرقم...';

  @override
  String patientsMedicalSummary(String name) {
    return 'الملخص الطبي — $name';
  }

  @override
  String get patientsDeleteConfirmTitle => 'حذف سجل المريض';

  @override
  String patientsDeleteConfirmMessage(String name) {
    return 'هل أنت تأكد من رغبتك في إزالة $name؟';
  }

  @override
  String get patientsAgeGender => 'العمر / الجنس';

  @override
  String get patientsBloodGroup => 'فصيلة الدم';

  @override
  String get patientsEmergencyContact => 'جهة اتصال الطوارئ';

  @override
  String get patientsMedicalHistory => 'التاريخ الطبي';

  @override
  String get patientsKnownAllergies => 'الحساسية المعروفة';

  @override
  String get patientsAge => 'العمر';

  @override
  String get patientsGender => 'الجنس';

  @override
  String get apptsTitle => 'إدارة المواعيد';

  @override
  String get apptsSubtitle => 'جدولة، إعادة جدولة، تصفية وتتبع استشارات المرضى';

  @override
  String get apptsBook => 'حجز موعد';

  @override
  String get apptsReschedule => 'إعادة جدولة';

  @override
  String get apptsSearchHint => 'البحث عن مواعيد بالمرضى، الأطباء، التخصص...';

  @override
  String get apptsAll => 'جميع المواعيد';

  @override
  String get apptsToday => 'اليوم';

  @override
  String get apptsUpcoming => 'القادمة';

  @override
  String get apptsCompleted => 'المكتملة';

  @override
  String get apptsCancelled => 'الملغاة';

  @override
  String get apptsTableTab => 'عرض الجدول';

  @override
  String get apptsCalendarTab => 'عرض التقويم';

  @override
  String get apptsDoctor => 'الطبيب';

  @override
  String get apptsPatient => 'المريض';

  @override
  String get apptsDateTime => 'التاريخ والوقت';

  @override
  String get apptsType => 'النوع';

  @override
  String get apptsFee => 'الرسوم';

  @override
  String get apptsNewDate => 'التاريخ الجديد';

  @override
  String get apptsNewTime => 'الفترة الزمنية الجديدة';

  @override
  String get apptsReason => 'سبب إعادة الجدولة';

  @override
  String get apptsCancelConfirmTitle => 'إلغاء الموعد';

  @override
  String apptsCancelConfirmMessage(String name) {
    return 'هل أنت تأكد من رغبتك في إلغاء الموعد الخاص بـ $name؟';
  }

  @override
  String get statusScheduled => 'مجدول';

  @override
  String get statusInConsultation => 'قيد الاستشارة';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get statusNoShow => 'لم يحضر';

  @override
  String get clinicsTitle => 'دليل العيادات';

  @override
  String get clinicsSubtitle =>
      'إدارة المراكز الصحية، ساعات العمل، العناوين، والفرق الطبية';

  @override
  String get clinicsAdd => 'إضافة عيادة';

  @override
  String get clinicsEdit => 'تعديل عيادة';

  @override
  String get clinicsSearchHint => 'البحث عن عيادات بالاسم، العنوان، الهاتف...';

  @override
  String get clinicsName => 'اسم العيادة';

  @override
  String get clinicsAddress => 'العنوان';

  @override
  String get clinicsWorkingHours => 'ساعات العمل';

  @override
  String get clinicsRating => 'التقييم';

  @override
  String get clinicsViewLocation => 'عرض الموقع';

  @override
  String get clinicsDeleteConfirmTitle => 'حذف العيادة';

  @override
  String clinicsDeleteConfirmMessage(String name) {
    return 'هل أنت تأكد من إزالة $name؟';
  }

  @override
  String get doctorsTitle => 'دليل الأطباء';

  @override
  String get doctorsSubtitle =>
      'إدارة الأطباء المتخصصين، الجداول، التقييمات، والرسوم';

  @override
  String get doctorsAdd => 'إضافة طبيب';

  @override
  String get doctorsEdit => 'تعديل طبيب';

  @override
  String get doctorsSearchHint => 'البحث عن أطباء بالاسم، التخصص، العيادة...';

  @override
  String get doctorsSpecialty => 'التخصص';

  @override
  String get doctorsConsultationFee => 'رسوم الاستشارة';

  @override
  String get doctorsAvailability => 'التوفر';

  @override
  String get doctorsExperience => 'سنوات الخبرة';

  @override
  String get doctorsBio => 'السيرة الذاتية';

  @override
  String get doctorsDeleteConfirmTitle => 'حذف الطبيب';

  @override
  String doctorsDeleteConfirmMessage(String name) {
    return 'هل أنت تأكد من إزالة $name؟';
  }

  @override
  String get medTitle => 'السجلات الطبية';

  @override
  String get medSubtitle =>
      'الوصول إلى السجلات الطبية للمرضى، الملاحظات السريرية، الفحوصات، والتشخيصات';

  @override
  String get medSearchHint => 'البحث في السجلات بالمرضى، التشخيص، الطبيب...';

  @override
  String get medDiagnosis => 'التشخيص';

  @override
  String get medClinicalNotes => 'الملاحظات السريرية';

  @override
  String get medLabResults => 'نتائج الفحوصات / المرفقات';

  @override
  String get medTimelineView => 'الخط الزمني';

  @override
  String get medMasterDetailView => 'العرض المفصل';

  @override
  String get rxTitle => 'الوصفات الطبية';

  @override
  String get rxSubtitle =>
      'إصدار، تتبع، بحث وتصدير الوصفات الطبية الرقمية للمرضى';

  @override
  String get rxCreate => 'وصفة طبية جديدة';

  @override
  String get rxSearchHint => 'البحث في الوصفات بالمرضى، الطبيب، الدواء...';

  @override
  String get rxNoFound => 'لم يتم العثور على وصفات طبية.';

  @override
  String get rxMedicineName => 'اسم الدواء';

  @override
  String get rxDosage => 'الجرعة';

  @override
  String get rxFrequency => 'التكرار';

  @override
  String get rxDuration => 'المدة';

  @override
  String get rxInstructions => 'التعليمات';

  @override
  String get rxAddMedicine => 'إضافة دواء';

  @override
  String get rxExportPdf => 'تصدير PDF';

  @override
  String rxGeneratingPdf(String id) {
    return 'جارٍ إنشاء ملف PDF للوصفة $id...';
  }

  @override
  String get rxActive => 'نشطة';

  @override
  String get rxCompleted => 'مكتملة';

  @override
  String get rxCancelled => 'ملغاة';

  @override
  String get notifTitle => 'مركز الإشعارات';

  @override
  String get notifSubtitle => 'بث الإعلانات، تذكيرات المواعيد، وتنبيهات النظام';

  @override
  String get notifCreate => 'إرسال إشعار';

  @override
  String get notifMessage => 'نص الإشعار';

  @override
  String get notifType => 'النوع';

  @override
  String get notifTarget => 'الجمهور المستهدف';

  @override
  String get notifSent => 'تم الإرسال في';

  @override
  String get reportsTitle => 'التقارير والتحليلات التنفيذية';

  @override
  String get reportsSubtitle =>
      'تتبع إيرادات المنصة، مؤشرات الأداء للأطباء والعيادات ومعدلات نمو المرضى';

  @override
  String get reportsExportExcel => 'تصدير Excel';

  @override
  String get reportsExportPdf => 'تصدير تقرير PDF';

  @override
  String get reportsMonthlyRevenue => 'الإيرادات الشهرية';

  @override
  String get reportsTotalAppointments => 'إجمالي المواعيد';

  @override
  String get reportsNewPatients => 'المرضى الجدد';

  @override
  String get reportsAvgDoctorRating => 'متوسط تقييم الأطباء';

  @override
  String get reportsRevenueOverview => 'نظرة عامة على الإيرادات';

  @override
  String get reportsTopDoctors => 'الأطباء الأعلى أداءً';

  @override
  String get reportsTopClinics => 'العيادات الأعلى أداءً';

  @override
  String get reviewsTitle => 'إدارة التقييمات والمراجعات';

  @override
  String get reviewsSubtitle =>
      'مراقبة تقييمات المرضى، الرد على ملاحظات العيادات والأطباء، وإدارة انطباعات العملاء';

  @override
  String get reviewsAvgRating => 'متوسط التقييم';

  @override
  String get reviewsTotal => 'إجمالي التقييمات';

  @override
  String get reviewsResponseRate => 'نسبة الاستجابة';

  @override
  String get reviewsAll => 'جميع التقييمات';

  @override
  String get reviewsDoctorTab => 'تقييمات الأطباء';

  @override
  String get reviewsClinicTab => 'تقييمات العيادات';

  @override
  String get reviewsSearchHint =>
      'البحث في التقييمات باسم الطبيب، العيادة، الكاتب أو كلمة رئيسية...';

  @override
  String get reviewsReply => 'الرد على التقييم';

  @override
  String get reviewsTypeReply => 'اكتب ردك...';

  @override
  String get reviewsSendReply => 'إرسال الرد';

  @override
  String get reviewsNoFound => 'لم يتم العثور على تقييمات.';
}
