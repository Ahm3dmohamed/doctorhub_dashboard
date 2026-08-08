import 'package:flutter/material.dart';
import 'package:doctorhub_dashboard/l10n/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'empty_widget.dart';
import 'primary_button.dart';

class DataTableColumn<T> {
  final String title;
  final Widget Function(T item) builder;
  final double? width;
  final bool isNumeric;

  const DataTableColumn({
    required this.title,
    required this.builder,
    this.width,
    this.isNumeric = false,
  });
}

class AppDataTable<T> extends StatelessWidget {
  final List<DataTableColumn<T>> columns;
  final List<T> items;
  final bool isLoading;
  final String? emptyTitle;
  final String? emptyMessage;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;
  final Widget? filterWidget;
  final Widget? headerAction;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.items,
    this.isLoading = false,
    this.emptyTitle,
    this.emptyMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.itemsPerPage = 10,
    this.onPageChanged,
    this.onSearchChanged,
    this.searchHint,
    this.filterWidget,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onSearchChanged != null ||
              filterWidget != null ||
              headerAction != null)
            Padding(
              padding: const EdgeInsets.all(AppConstants.space4),
              child: Wrap(
                spacing: AppConstants.space3,
                runSpacing: AppConstants.space3,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onSearchChanged != null)
                        SizedBox(
                          width: 280,
                          height: 38,
                          child: TextField(
                            onChanged: onSearchChanged,
                            style: AppTypography.bodySm(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  searchHint ??
                                  l10n?.commonSearch ??
                                  'Search records...',
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.darkSurfaceVariant
                                  : AppColors.lightSurfaceVariant,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusMd,
                                ),
                                borderSide: BorderSide(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusMd,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (filterWidget != null) ...[
                        const SizedBox(width: AppConstants.space3),
                        filterWidget!,
                      ],
                    ],
                  ),
                  headerAction ?? const SizedBox.shrink(),
                ],
              ),
            ),

          // ─── Table Content ──────────────────────────────────────────────────
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: EmptyWidget(
                title: emptyTitle ?? l10n?.commonNoData ?? 'No Records Found',
                message:
                    emptyMessage ??
                    l10n?.commonNoData ??
                    'There are no items to display.',
                icon: Icons.inbox_rounded,
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.sizeOf(context).width - 100,
                ),
                child: DataTable(
                  columnSpacing: 24,
                  horizontalMargin: 20,
                  headingRowHeight: 46,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 64,
                  headingRowColor: WidgetStateProperty.all(
                    isDark
                        ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                        : AppColors.lightSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  columns: columns
                      .map(
                        (col) => DataColumn(
                          numeric: col.isNumeric,
                          label: Text(
                            col.title,
                            style: AppTypography.labelMd(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  rows: items
                      .map(
                        (item) => DataRow(
                          cells: columns
                              .map((col) => DataCell(col.builder(item)))
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

          // ─── Pagination Footer ─────────────────────────────────────────────
          if (!isLoading && items.isNotEmpty && onPageChanged != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.space4,
                vertical: AppConstants.space3,
              ),
              decoration: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ).toDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${((currentPage - 1) * itemsPerPage) + 1} - ${(currentPage * itemsPerPage).clamp(0, totalItems)} / $totalItems',
                    style: AppTypography.bodySm(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      SecondaryButton(
                        label: l10n?.commonBack ?? 'Previous',
                        width: 90,
                        height: 34,
                        onPressed: currentPage > 1
                            ? () => onPageChanged!(currentPage - 1)
                            : null,
                      ),
                      const SizedBox(width: AppConstants.space2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMd,
                          ),
                        ),
                        child: Text(
                          '$currentPage / $totalPages',
                          style: AppTypography.labelMd(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.space2),
                      SecondaryButton(
                        label: l10n?.commonNext ?? 'Next',
                        width: 80,
                        height: 34,
                        onPressed: currentPage < totalPages
                            ? () => onPageChanged!(currentPage + 1)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

extension on BorderSide {
  BoxDecoration toDecoration() => BoxDecoration(border: Border(top: this));
}
