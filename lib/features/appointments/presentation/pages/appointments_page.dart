import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../domain/entities/appointment_entity.dart';
import '../cubit/appointment_cubit.dart';
import '../cubit/appointment_state.dart';
import '../widgets/appointment_calendar_view.dart';
import '../widgets/appointment_filter_tabs.dart';
import '../widgets/appointment_header.dart';
import '../widgets/appointment_table_view.dart';
import '../widgets/book_appointment_dialog.dart';
import '../widgets/reschedule_appointment_dialog.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  AppointmentStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<AppointmentCubit>().loadAppointments();
  }

  void _showBookingModal() {
    showDialog(
      context: context,
      builder: (_) => BookAppointmentDialog(
        onBook: (newApt) {
          context.read<AppointmentCubit>().addAppointment(newApt);
        },
      ),
    );
  }

  void _showRescheduleModal(AppointmentEntity appointment) {
    showDialog(
      context: context,
      builder: (_) => RescheduleAppointmentDialog(
        appointment: appointment,
        onReschedule: (newDate) {
          context.read<AppointmentCubit>().rescheduleAppointment(
                appointment.id,
                newDate,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
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
                BreadcrumbItem(label: l10n.navAppointments),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                final isCalendar =
                    state is AppointmentLoaded && state.isCalendarView;
                return AppointmentHeader(
                  isCalendarView: isCalendar,
                  onToggleView: () =>
                      context.read<AppointmentCubit>().toggleViewMode(),
                  onBookAppointment: _showBookingModal,
                );
              },
            ),
            const SizedBox(height: AppConstants.space6),
            AppointmentFilterTabs(
              selectedStatus: _selectedStatus,
              onStatusSelected: (status) {
                setState(() => _selectedStatus = status);
                context.read<AppointmentCubit>().loadAppointments(
                      status: status,
                    );
              },
            ),
            const SizedBox(height: AppConstants.space6),
            BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                final isLoading = state is AppointmentLoading;
                final appointments = state is AppointmentLoaded
                    ? state.appointments
                    : <AppointmentEntity>[];
                final isCalendarView = state is AppointmentLoaded
                    ? state.isCalendarView
                    : false;

                if (isCalendarView) {
                  return AppointmentCalendarView(appointments: appointments);
                }

                return AppointmentTableView(
                  isLoading: isLoading,
                  appointments: appointments,
                  onSearchChanged: (q) {
                    context.read<AppointmentCubit>().loadAppointments(
                          query: q,
                          status: _selectedStatus,
                        );
                  },
                  onAccept: (a) =>
                      context.read<AppointmentCubit>().acceptAppointment(a.id),
                  onReject: (a) =>
                      context.read<AppointmentCubit>().rejectAppointment(a.id),
                  onReschedule: _showRescheduleModal,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
