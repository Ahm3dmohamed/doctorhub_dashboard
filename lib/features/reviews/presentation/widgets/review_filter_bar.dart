import 'package:doctorhub_dashboard/features/reviews/domain/entities/review_entity.dart';
import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.neutral400,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: l10n.reviewsAll),
            Tab(text: l10n.reviewsDoctorTab),
            Tab(text: l10n.reviewsClinicTab),
          ],
        ),
        const SizedBox(height: AppConstants.space4),
        AppTextField(
          controller: searchController,
          label: l10n.commonSearch,
          hint: l10n.reviewsSearchHint,
          prefixIcon: Icons.search_rounded,
          onChanged: (val) =>
              onChanged(val, _typeForIndex(tabController.index)),
        ),
      ],
    );
  }
}
