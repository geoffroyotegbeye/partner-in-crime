import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ScheduleCalendarGrid extends StatelessWidget {
  final List<String> selectedDays;
  final Function(String) onDayToggle;

  const ScheduleCalendarGrid({
    Key? key,
    required this.selectedDays,
    required this.onDayToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> weekDays = [
      {'short': 'Mon', 'full': 'Monday'},
      {'short': 'Tue', 'full': 'Tuesday'},
      {'short': 'Wed', 'full': 'Wednesday'},
      {'short': 'Thu', 'full': 'Thursday'},
      {'short': 'Fri', 'full': 'Friday'},
      {'short': 'Sat', 'full': 'Saturday'},
      {'short': 'Sun', 'full': 'Sunday'},
    ];

    return Column(
      children: [
        Text(
          'Select days for your goal activities',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
          ),
          itemCount: weekDays.length,
          itemBuilder: (context, index) {
            final day = weekDays[index];
            final isSelected = selectedDays.contains(day['full']);

            return GestureDetector(
              onTap: () => onDayToggle(day['full']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day['short']!,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        day['full']!,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
