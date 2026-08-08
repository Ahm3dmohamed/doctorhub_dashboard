import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_breadcrumb.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/review_entity.dart';
import '../cubit/review_cubit.dart';
import '../cubit/review_state.dart';
import '../pages/widgets/review_items.dart';
import 'widgets/review_filter_bar.dart';
import 'widgets/review_header.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with SingleTickerProviderStateMixin {
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
                  label: 'Dashboard',
                  onTap: () => context.go(AppRoutes.dashboard),
                ),
                const BreadcrumbItem(label: 'Reviews & Feedback'),
              ],
            ),
            const SizedBox(height: AppConstants.space4),
            const ReviewHeader(),
            const SizedBox(height: AppConstants.space6),
            ReviewFilterBar(
              tabController: _tabController,
              searchController: _searchController,
              onChanged: (query, type) => context
                  .read<ReviewCubit>()
                  .loadReviews(query: query, targetType: type),
            ),
            const SizedBox(height: AppConstants.space6),
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
                        child: Text(
                          'No reviews found.',
                          style: AppTypography.headingMd(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: state.reviews
                        .map((rev) => ReviewItems(rev: rev, isDark: isDark))
                        .toList(),
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
