import 'package:equatable/equatable.dart';

class DoctorPerformanceItem extends Equatable {
  final String doctorId;
  final String name;
  final String specialty;
  final double rating;
  final int totalAppointments;
  final double totalRevenue;

  const DoctorPerformanceItem({
    required this.doctorId,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.totalAppointments,
    required this.totalRevenue,
  });

  @override
  List<Object?> get props => [doctorId, name, specialty, rating, totalAppointments, totalRevenue];
}

class ClinicPerformanceItem extends Equatable {
  final String clinicId;
  final String name;
  final int appointmentsCount;
  final double revenue;
  final String growthPercentage;

  const ClinicPerformanceItem({
    required this.clinicId,
    required this.name,
    required this.appointmentsCount,
    required this.revenue,
    required this.growthPercentage,
  });

  @override
  List<Object?> get props => [clinicId, name, appointmentsCount, revenue, growthPercentage];
}

class ReportSummaryEntity extends Equatable {
  final double monthlyRevenue;
  final String revenueGrowth;
  final int totalBookings;
  final String bookingsGrowth;
  final int newPatients;
  final String patientsGrowth;
  final double averageDoctorRating;
  final List<double> monthlyRevenueChart;
  final List<String> monthsLabels;
  final List<DoctorPerformanceItem> topDoctors;
  final List<ClinicPerformanceItem> topClinics;

  const ReportSummaryEntity({
    required this.monthlyRevenue,
    required this.revenueGrowth,
    required this.totalBookings,
    required this.bookingsGrowth,
    required this.newPatients,
    required this.patientsGrowth,
    required this.averageDoctorRating,
    required this.monthlyRevenueChart,
    required this.monthsLabels,
    required this.topDoctors,
    required this.topClinics,
  });

  @override
  List<Object?> get props => [
        monthlyRevenue,
        revenueGrowth,
        totalBookings,
        newPatients,
        averageDoctorRating,
        topDoctors,
        topClinics,
      ];
}
