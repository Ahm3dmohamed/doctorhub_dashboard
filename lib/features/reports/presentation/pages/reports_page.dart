import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_chart_card.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/report_entity.dart';
import '../cubit/report_cubit.dart';
import '../cubit/report_state.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().loadReport();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBreadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                const BreadcrumbItem(label: 'Reports & Analytics'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reports & Executive Analytics',
                      style: AppTypography.headingXl(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track platform revenue, doctor/clinic performance KPIs and patient growth metrics',
                      style: AppTypography.bodyMd(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SecondaryButton(
                      label: 'Export Excel',
                      leadingIcon: Icons.table_view_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exporting report as Excel spreadsheet...')),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    PrimaryButton(
                      label: 'Export PDF Report',
                      leadingIcon: Icons.picture_as_pdf_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generating executive PDF report...')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space6),

            // Content
            BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return const LoadingWidget(message: 'Generating Executive Analytics...');
                }
                if (state is ReportError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<ReportCubit>().loadReport(),
                  );
                }
                if (state is ReportLoaded) {
                  final summary = state.summary;
                  return Column(
                    children: [
                      // KPI Stat Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth > 900;
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: isDesktop ? 4 : 2,
                            crossAxisSpacing: AppConstants.space4,
                            mainAxisSpacing: AppConstants.space4,
                            childAspectRatio: isDesktop ? 1.6 : 1.4,
                            children: [
                              _buildKpiCard(
                                'Monthly Revenue',
                                '\$${summary.monthlyRevenue.toStringAsFixed(0)}',
                                summary.revenueGrowth,
                                Icons.payments_rounded,
                                AppColors.primary,
                                isDark,
                              ),
                              _buildKpiCard(
                                'Total Appointments',
                                summary.totalBookings.toString(),
                                summary.bookingsGrowth,
                                Icons.calendar_month_rounded,
                                AppColors.accent,
                                isDark,
                              ),
                              _buildKpiCard(
                                'New Patients',
                                summary.newPatients.toString(),
                                summary.patientsGrowth,
                                Icons.person_add_alt_1_rounded,
                                AppColors.success,
                                isDark,
                              ),
                              _buildKpiCard(
                                'Avg Doctor Rating',
                                summary.averageDoctorRating.toStringAsFixed(2),
                                '+0.2',
                                Icons.star_rounded,
                                AppColors.warning,
                                isDark,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppConstants.space6),

                      // Revenue Canvas Chart Card
                      AppChartCard(
                        title: 'Revenue Overview',
                        totalValue: '\$${summary.monthlyRevenue.toStringAsFixed(0)}',
                        changePercentage: summary.revenueGrowth,
                        values: summary.monthlyRevenueChart,
                        labels: summary.monthsLabels,
                      ),
                      const SizedBox(height: AppConstants.space6),

                      // Top Doctors & Top Clinics Tables
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 900;
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildTopDoctorsTable(summary.topDoctors, isDark)),
                                const SizedBox(width: AppConstants.space6),
                                Expanded(child: _buildTopClinicsTable(summary.topClinics, isDark)),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              _buildTopDoctorsTable(summary.topDoctors, isDark),
                              const SizedBox(height: AppConstants.space6),
                              _buildTopClinicsTable(summary.topClinics, isDark),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, String growth, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                ),
                child: Text(growth, style: AppTypography.labelSm(color: AppColors.successDark)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTypography.headingLg()),
              Text(label, style: AppTypography.bodySm(color: AppColors.neutral400)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopDoctorsTable(List<DoctorPerformanceItem> doctors, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Performing Doctors', style: AppTypography.headingMd()),
          const SizedBox(height: AppConstants.space4),
          AppDataTable<DoctorPerformanceItem>(
            columns: [
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Doctor',
                builder: (doc) => Text(doc.name, style: AppTypography.headingSm()),
              ),
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Specialty',
                builder: (doc) => Text(doc.specialty, style: AppTypography.bodySm()),
              ),
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Rating',
                builder: (doc) => Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(doc.rating.toStringAsFixed(1), style: AppTypography.labelMd()),
                  ],
                ),
              ),
              DataTableColumn<DoctorPerformanceItem>(
                title: 'Revenue',
                builder: (doc) => Text('\$${doc.totalRevenue.toStringAsFixed(0)}', style: AppTypography.headingSm(color: AppColors.success)),
              ),
            ],
            items: doctors,
          ),
        ],
      ),
    );
  }

  Widget _buildTopClinicsTable(List<ClinicPerformanceItem> clinics, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Performing Clinics', style: AppTypography.headingMd()),
          const SizedBox(height: AppConstants.space4),
          AppDataTable<ClinicPerformanceItem>(
            columns: [
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Clinic Name',
                builder: (clinic) => Text(clinic.name, style: AppTypography.headingSm()),
              ),
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Appointments',
                builder: (clinic) => Text('${clinic.appointmentsCount} visits', style: AppTypography.bodySm()),
              ),
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Revenue',
                builder: (clinic) => Text('\$${clinic.revenue.toStringAsFixed(0)}', style: AppTypography.headingSm(color: AppColors.primary)),
              ),
              DataTableColumn<ClinicPerformanceItem>(
                title: 'Growth',
                builder: (clinic) => Text(clinic.growthPercentage, style: AppTypography.labelMd(color: AppColors.success)),
              ),
            ],
            items: clinics,
          ),
        ],
      ),
    );
  }
}
