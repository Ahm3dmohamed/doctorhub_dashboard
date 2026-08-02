import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_data_table.dart';
import '../../../../shared/widgets/app_modal_dialog.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/appointment_entity.dart';
import '../cubit/appointment_cubit.dart';
import '../cubit/appointment_state.dart';

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
                const BreadcrumbItem(label: 'Appointments'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointments & Scheduling',
                      style: AppTypography.headingXl(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage upcoming patient consultations, reschedule or approve bookings',
                      style: AppTypography.bodyMd(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    BlocBuilder<AppointmentCubit, AppointmentState>(
                      builder: (context, state) {
                        final isCalendar = state is AppointmentLoaded && state.isCalendarView;
                        return SecondaryButton(
                          label: isCalendar ? 'Table View' : 'Calendar View',
                          leadingIcon: isCalendar ? Icons.table_chart_rounded : Icons.calendar_month_rounded,
                          onPressed: () => context.read<AppointmentCubit>().toggleViewMode(),
                        );
                      },
                    ),
                    const SizedBox(width: AppConstants.space3),
                    PrimaryButton(
                      label: 'Book Appointment',
                      leadingIcon: Icons.add_rounded,
                      onPressed: () => _showBookingModal(context),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppConstants.space6),

            // Status Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterTab(
                    label: 'All',
                    isSelected: _selectedStatus == null,
                    onTap: () {
                      setState(() => _selectedStatus = null);
                      context.read<AppointmentCubit>().loadAppointments();
                    },
                  ),
                  ...AppointmentStatus.values.map(
                    (s) => _FilterTab(
                      label: s.displayName,
                      isSelected: _selectedStatus == s,
                      onTap: () {
                        setState(() => _selectedStatus = s);
                        context.read<AppointmentCubit>().loadAppointments(status: s);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.space6),

            BlocBuilder<AppointmentCubit, AppointmentState>(
              builder: (context, state) {
                final isLoading = state is AppointmentLoading;
                final appointments =
                    state is AppointmentLoaded ? state.appointments : <AppointmentEntity>[];
                final isCalendarView =
                    state is AppointmentLoaded ? state.isCalendarView : false;

                if (isCalendarView) {
                  return _buildCalendarView(context, appointments, isDark);
                }

                return AppDataTable<AppointmentEntity>(
                  isLoading: isLoading,
                  items: appointments,
                  searchHint: 'Search appointments by patient, doctor...',
                  onSearchChanged: (q) =>
                      context.read<AppointmentCubit>().loadAppointments(query: q, status: _selectedStatus),
                  columns: [
                    DataTableColumn<AppointmentEntity>(
                      title: 'Patient',
                      builder: (a) => Text(
                        a.patientName,
                        style: AppTypography.bodyMd(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    DataTableColumn<AppointmentEntity>(
                      title: 'Doctor & Specialty',
                      builder: (a) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            a.doctorName,
                            style: AppTypography.bodySm(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            a.specialty,
                            style: AppTypography.labelSm(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataTableColumn<AppointmentEntity>(
                      title: 'Date & Time',
                      builder: (a) => Text(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(a.dateTime),
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    DataTableColumn<AppointmentEntity>(
                      title: 'Status',
                      builder: (a) => _StatusBadge(status: a.status),
                    ),
                    DataTableColumn<AppointmentEntity>(
                      title: 'Actions',
                      builder: (a) => Row(
                        children: [
                          if (a.status == AppointmentStatus.pending) ...[
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                              onPressed: () => context.read<AppointmentCubit>().acceptAppointment(a.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.highlight_off_rounded, color: AppColors.error, size: 20),
                              onPressed: () => context.read<AppointmentCubit>().rejectAppointment(a.id),
                            ),
                          ],
                          IconButton(
                            icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                            onPressed: () => _showRescheduleModal(context, a),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarView(
    BuildContext context,
    List<AppointmentEntity> appointments,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: AppTypography.headingMd(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${appointments.length} Total Bookings',
                style: AppTypography.labelMd(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.space6),

          // Agenda list
          ...appointments.map((a) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Center(
                        child: Text(
                          DateFormat('dd\nMMM').format(a.dateTime),
                          textAlign: TextAlign.center,
                          style: AppTypography.labelSm(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${a.patientName} — ${a.doctorName}',
                            style: AppTypography.bodyMd(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              weight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${a.reason} • ${DateFormat('hh:mm a').format(a.dateTime)}',
                            style: AppTypography.bodySm(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: a.status),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showBookingModal(BuildContext context) {
    final patientCtrl = TextEditingController();
    final doctorCtrl = TextEditingController();
    final specialtyCtrl = TextEditingController();
    final clinicCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AppModalDialog(
        title: 'Book Appointment',
        subtitle: 'Schedule a new consultation for a patient.',
        onConfirm: () {
          final newApt = AppointmentEntity(
            id: '',
            patientName: patientCtrl.text.isEmpty ? 'John Smith' : patientCtrl.text,
            doctorName: doctorCtrl.text.isEmpty ? 'Dr. Sarah Jenkins' : doctorCtrl.text,
            specialty: specialtyCtrl.text.isEmpty ? 'Cardiology' : specialtyCtrl.text,
            clinicName: clinicCtrl.text.isEmpty ? 'Central Heart Institute' : clinicCtrl.text,
            dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
            status: AppointmentStatus.upcoming,
            reason: reasonCtrl.text.isEmpty ? 'General Health Checkup' : reasonCtrl.text,
          );

          context.read<AppointmentCubit>().addAppointment(newApt);
          Navigator.of(ctx).pop();
        },
        content: Column(
          children: [
            AppTextField(controller: patientCtrl, label: 'Patient Name', hint: 'John Smith'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: doctorCtrl, label: 'Doctor Name', hint: 'Dr. Sarah Jenkins'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: specialtyCtrl, label: 'Specialty', hint: 'Cardiology'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: clinicCtrl, label: 'Clinic Name', hint: 'Central Heart Institute'),
            const SizedBox(height: AppConstants.space3),
            AppTextField(controller: reasonCtrl, label: 'Reason for Visit', hint: 'Checkup...'),
          ],
        ),
      ),
    );
  }

  void _showRescheduleModal(BuildContext context, AppointmentEntity a) {
    DateTime selectedDate = a.dateTime;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AppModalDialog(
          title: 'Reschedule Appointment',
          subtitle: 'Change consultation date for ${a.patientName}',
          onConfirm: () {
            context.read<AppointmentCubit>().rescheduleAppointment(a.id, selectedDate);
            Navigator.of(ctx).pop();
          },
          content: Column(
            children: [
              Text('Current Schedule: ${DateFormat('MMM dd, yyyy • hh:mm a').format(a.dateTime)}'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked.add(const Duration(hours: 10)));
                  }
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(DateFormat('MMM dd, yyyy').format(selectedDate)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(AppConstants.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMd(
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      AppointmentStatus.upcoming => (AppColors.primary.withValues(alpha: 0.1), AppColors.primary),
      AppointmentStatus.completed => (AppColors.successLight, AppColors.successDark),
      AppointmentStatus.cancelled => (AppColors.errorLight, AppColors.errorDark),
      AppointmentStatus.pending => (AppColors.warning.withValues(alpha: 0.1), AppColors.warning),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status.displayName,
        style: AppTypography.labelSm(color: fg),
      ),
    );
  }
}
