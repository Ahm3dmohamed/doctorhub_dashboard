import 'package:doctorhub_dashboard/features/reviews/domain/entities/review_entity.dart';
import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../shared/widgets/app_text_field.dart';

/// Tab bar + search field for filtering reviews by type and keyword.
class ReviewFilterBar extends StatelessWidget {
  final TabController tabController;
  final TextEditingController searchController;
  final Function(String query, ReviewTargetType? type) onChanged;

  const ReviewFilterBar({
    super.key,
    required this.tabController,
    required this.searchController,
    required this.onChanged,
  });

  ReviewTargetType? _typeForIndex(int index) {
    if (index == 1) return ReviewTargetType.doctor;
    if (index == 2) return ReviewTargetType.clinic;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: tabController,
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
          controller: searchController,
          label: 'Search Reviews',
          hint: 'Search reviews by doctor name, clinic, author or keyword...',
          prefixIcon: Icons.search_rounded,
          onChanged: (val) =>
              onChanged(val, _typeForIndex(tabController.index)),
        ),
      ],
    );
  }
}
