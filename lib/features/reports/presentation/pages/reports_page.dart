import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_chart_card.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../cubit/report_cubit.dart';
import '../cubit/report_state.dart';
import '../widgets/report_header.dart';
import '../widgets/report_kpi_grid.dart';
import '../widgets/report_leaderboards_view.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBreadcrumb(
              items: [
                BreadcrumbItem(
                  label: l10n.navDashboard,
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                BreadcrumbItem(label: l10n.navReports),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            const ReportHeader(),
            const SizedBox(height: AppConstants.space6),
            BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return LoadingWidget(
                    message: l10n.commonLoading,
                  );
                }
                if (state is ReportError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<ReportCubit>().loadReport(),
                  );
                }
                if (state is ReportLoaded) {
                  final summary = state.summary;
                  return Column(
                    children: [
                      ReportKpiGrid(
                        monthlyRevenue:
                            '\$${summary.monthlyRevenue.toStringAsFixed(0)}',
                        revenueGrowth: summary.revenueGrowth,
                        totalBookings: summary.totalBookings.toString(),
                        bookingsGrowth: summary.bookingsGrowth,
                        newPatients: summary.newPatients.toString(),
                        patientsGrowth: summary.patientsGrowth,
                        avgRating: summary.averageDoctorRating.toStringAsFixed(2),
                      ),
                      const SizedBox(height: AppConstants.space6),
                      AppChartCard(
                        title: l10n.reportsRevenueOverview,
                        totalValue:
                            '\$${summary.monthlyRevenue.toStringAsFixed(0)}',
                        changePercentage: summary.revenueGrowth,
                        values: summary.monthlyRevenueChart,
                        labels: summary.monthsLabels,
                      ),
                      const SizedBox(height: AppConstants.space6),
                      ReportLeaderboardsView(
                        topDoctors: summary.topDoctors,
                        topClinics: summary.topClinics,
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
}
