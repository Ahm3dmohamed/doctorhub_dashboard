import 'package:doctorhub_dashboard/app/theme/app_colors.dart';
import 'package:doctorhub_dashboard/app/theme/app_typography.dart';
import 'package:doctorhub_dashboard/core/constants/app_constants.dart';
import 'package:doctorhub_dashboard/features/reviews/presentation/cubit/review_cubit.dart';
import 'package:doctorhub_dashboard/shared/widgets/app_text_field.dart';
import 'package:doctorhub_dashboard/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/features/reviews/domain/entities/review_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReviewItems extends StatefulWidget {
  const ReviewItems({super.key, required this.rev, required this.isDark});

  final ReviewEntity rev;
  final bool isDark;

  @override
  State<ReviewItems> createState() => _ReviewItemsState();
}

class _ReviewItemsState extends State<ReviewItems> {
  late final TextEditingController _replyController;
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rev = widget.rev;
    final isDark = widget.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.space4),
      padding: const EdgeInsets.all(AppConstants.space5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
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
                    child: Text(
                      rev.authorAvatar,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rev.authorName,
                        style: AppTypography.headingSm(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Target: ${rev.targetName} (${rev.targetType.displayName})',
                        style: AppTypography.bodySm(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rev.rating.toStringAsFixed(1),
                    style: AppTypography.headingSm(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: () {
                      context.read<ReviewCubit>().deleteReview(rev.id);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rev.comment,
            style: AppTypography.bodyMd(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(rev.date),
            style: AppTypography.bodySm(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),

          if (rev.reply != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.neutral900 : AppColors.neutral100,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: const Border(
                  left: BorderSide(color: AppColors.primary, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Official Response:',
                    style: AppTypography.labelMd(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rev.reply!,
                    style: AppTypography.bodyMd(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            if (!_isReplying)
              TextButton.icon(
                icon: const Icon(Icons.reply_rounded, size: 16),
                label: const Text('Reply to review'),
                onPressed: () => setState(() => _isReplying = true),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextField(
                    controller: _replyController,
                    label: 'Official Reply',
                    hint: 'Type your official response...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () =>
                            setState(() => _isReplying = false),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      PrimaryButton.small(
                        label: 'Post Reply',
                        onPressed: () {
                          if (_replyController.text.isNotEmpty) {
                            context.read<ReviewCubit>().replyToReview(
                              rev.id,
                              _replyController.text,
                            );
                            setState(() => _isReplying = false);
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
  }
}
