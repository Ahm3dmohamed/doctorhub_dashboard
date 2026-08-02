import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/report_entity.dart';
import '../models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<ReportSummaryModel> getReportSummary({String? period});
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  @override
  Future<ReportSummaryModel> getReportSummary({String? period}) async {
    await Future.delayed(AppConstants.mockApiDelay);

    return const ReportSummaryModel(
      monthlyRevenue: 128450.00,
      revenueGrowth: '+14.2%',
      totalBookings: 1420,
      bookingsGrowth: '+8.6%',
      newPatients: 340,
      patientsGrowth: '+22.5%',
      averageDoctorRating: 4.88,
      monthlyRevenueChart: [45000, 52000, 61000, 78000, 89000, 105000, 128450],
      monthsLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      topDoctors: [
        DoctorPerformanceItem(
          doctorId: 'DOC-001',
          name: 'Dr. Alexander Wright',
          specialty: 'Cardiology',
          rating: 4.9,
          totalAppointments: 320,
          totalRevenue: 48000.0,
        ),
        DoctorPerformanceItem(
          doctorId: 'DOC-002',
          name: 'Dr. Elena Rostova',
          specialty: 'Neurology',
          rating: 4.85,
          totalAppointments: 280,
          totalRevenue: 42000.0,
        ),
        DoctorPerformanceItem(
          doctorId: 'DOC-003',
          name: 'Dr. Marcus Vance',
          specialty: 'Orthopedics',
          rating: 4.92,
          totalAppointments: 240,
          totalRevenue: 38400.0,
        ),
      ],
      topClinics: [
        ClinicPerformanceItem(
          clinicId: 'CLN-001',
          name: 'Central Heart & Vascular Center',
          appointmentsCount: 650,
          revenue: 97500.0,
          growthPercentage: '+18.4%',
        ),
        ClinicPerformanceItem(
          clinicId: 'CLN-002',
          name: 'NeuroCare Institute',
          appointmentsCount: 420,
          revenue: 63000.0,
          growthPercentage: '+11.2%',
        ),
        ClinicPerformanceItem(
          clinicId: 'CLN-003',
          name: 'OrthoMotion Clinic',
          appointmentsCount: 350,
          revenue: 52500.0,
          growthPercentage: '+9.7%',
        ),
      ],
    );
  }
}
