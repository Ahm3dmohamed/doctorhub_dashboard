import '../../domain/entities/report_entity.dart';

class ReportSummaryModel extends ReportSummaryEntity {
  const ReportSummaryModel({
    required super.monthlyRevenue,
    required super.revenueGrowth,
    required super.totalBookings,
    required super.bookingsGrowth,
    required super.newPatients,
    required super.patientsGrowth,
    required super.averageDoctorRating,
    required super.monthlyRevenueChart,
    required super.monthsLabels,
    required super.topDoctors,
    required super.topClinics,
  });

  factory ReportSummaryModel.fromEntity(ReportSummaryEntity entity) {
    return ReportSummaryModel(
      monthlyRevenue: entity.monthlyRevenue,
      revenueGrowth: entity.revenueGrowth,
      totalBookings: entity.totalBookings,
      bookingsGrowth: entity.bookingsGrowth,
      newPatients: entity.newPatients,
      patientsGrowth: entity.patientsGrowth,
      averageDoctorRating: entity.averageDoctorRating,
      monthlyRevenueChart: entity.monthlyRevenueChart,
      monthsLabels: entity.monthsLabels,
      topDoctors: entity.topDoctors,
      topClinics: entity.topClinics,
    );
  }
}
