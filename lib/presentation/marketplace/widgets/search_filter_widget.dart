import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final bool showFilters;
  final VoidCallback onToggleFilters;

  const SearchFilterWidget({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.showFilters,
    required this.onToggleFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Search field
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                  ),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search marketplace...',
                    hintStyle: GoogleFonts.inter(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withAlpha(153),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withAlpha(153),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Filter button
            GestureDetector(
              onTap: onToggleFilters,
              child: Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  color: showFilters
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: showFilters
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'tune',
                  color: showFilters
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
          ],
        ),

        // Filters panel (animated)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: showFilters ? 12.h : 0,
          child: showFilters
              ? Container(
                  margin: EdgeInsets.only(top: 2.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Filter options
                      Row(
                        children: [
                          _buildFilterChip('Price: Low to High'),
                          SizedBox(width: 3.w),
                          _buildFilterChip('In Stock'),
                          SizedBox(width: 3.w),
                          _buildFilterChip('New Arrivals'),
                        ],
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(204),
        ),
      ),
    );
  }
}
