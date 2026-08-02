import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/review_entity.dart';
import '../cubit/review_cubit.dart';
import '../cubit/review_state.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ReviewTargetType? type;
        if (_tabController.index == 1) type = ReviewTargetType.doctor;
        if (_tabController.index == 2) type = ReviewTargetType.clinic;
        context.read<ReviewCubit>().loadReviews(
              query: _searchController.text,
              targetType: type,
            );
      }
    });
    context.read<ReviewCubit>().loadReviews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
                const BreadcrumbItem(label: 'Reviews & Feedback'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            // Header Section
            Text(
              'Ratings & Reviews Management',
              style: AppTypography.headingXl(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Monitor patient ratings, reply to clinic and doctor feedback, and manage customer sentiment',
              style: AppTypography.bodyMd(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.space6),

            // Stat Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Average Rating', '4.85 / 5.0', Icons.star_rounded, AppColors.warning, isDark),
                ),
                const SizedBox(width: AppConstants.space4),
                Expanded(
                  child: _buildStatCard('Total Reviews', '1,248', Icons.rate_review_rounded, AppColors.primary, isDark),
                ),
                const SizedBox(width: AppConstants.space4),
                Expanded(
                  child: _buildStatCard('Response Rate', '94.2%', Icons.reply_all_rounded, AppColors.success, isDark),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.space6),

            // Tabs & Search
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.neutral400,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'All Reviews'),
                Tab(text: 'Doctor Reviews'),
                Tab(text: 'Clinic Reviews'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),

            AppTextField(
              controller: _searchController,
              label: 'Search Reviews',
              hint: 'Search reviews by doctor name, clinic, author or keyword...',
              prefixIcon: Icons.search_rounded,
              onChanged: (val) {
                ReviewTargetType? type;
                if (_tabController.index == 1) type = ReviewTargetType.doctor;
                if (_tabController.index == 2) type = ReviewTargetType.clinic;
                context.read<ReviewCubit>().loadReviews(query: val, targetType: type);
              },
            ),
            const SizedBox(height: AppConstants.space6),

            // Content
            BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoading) {
                  return const LoadingWidget(message: 'Loading Reviews...');
                }
                if (state is ReviewError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<ReviewCubit>().loadReviews(),
                  );
                }
                if (state is ReviewLoaded) {
                  if (state.reviews.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.space10),
                        child: Text('No reviews found.', style: AppTypography.headingMd()),
                      ),
                    );
                  }

                  return Column(
                    children: state.reviews.map((rev) {
                      return _buildReviewItem(context, rev, isDark);
                    }).toList(),
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

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppConstants.space3),
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

  Widget _buildReviewItem(BuildContext context, ReviewEntity rev, bool isDark) {
    final replyController = TextEditingController();
    bool isReplying = false;

    return StatefulBuilder(
      builder: (context, setReviewState) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.space4),
          padding: const EdgeInsets.all(AppConstants.space5),
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
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(rev.authorAvatar, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rev.authorName, style: AppTypography.headingSm()),
                          Text('Target: ${rev.targetName} (${rev.targetType.displayName})',
                              style: AppTypography.bodySm(color: AppColors.primaryLight)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 20),
                      const SizedBox(width: 4),
                      Text(rev.rating.toStringAsFixed(1), style: AppTypography.headingSm()),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                        onPressed: () {
                          context.read<ReviewCubit>().deleteReview(rev.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(rev.comment, style: AppTypography.bodyMd()),
              const SizedBox(height: 8),
              Text(DateFormat('MMM dd, yyyy • hh:mm a').format(rev.date), style: AppTypography.bodySm(color: AppColors.neutral400)),

              if (rev.reply != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.neutral900 : AppColors.neutral100,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    border: const Border(left: BorderSide(color: AppColors.primary, width: 3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Official Response:', style: AppTypography.labelMd(color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text(rev.reply!, style: AppTypography.bodyMd()),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                if (!isReplying)
                  TextButton.icon(
                    icon: const Icon(Icons.reply_rounded, size: 16),
                    label: const Text('Reply to review'),
                    onPressed: () => setReviewState(() => isReplying = true),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppTextField(
                        controller: replyController,
                        label: 'Official Reply',
                        hint: 'Type your official response...',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => setReviewState(() => isReplying = false),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          PrimaryButton.small(
                            label: 'Post Reply',
                            onPressed: () {
                              if (replyController.text.isNotEmpty) {
                                context.read<ReviewCubit>().replyToReview(rev.id, replyController.text);
                                setReviewState(() => isReplying = false);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
