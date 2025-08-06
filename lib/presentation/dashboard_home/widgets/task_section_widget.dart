import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './task_card_widget.dart';

class TaskSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> tasks;
  final String? emptyMessage;
  final Color? accentColor;
  final VoidCallback? onViewAll;

  const TaskSectionWidget({
    Key? key,
    required this.title,
    required this.tasks,
    this.emptyMessage,
    this.accentColor,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (accentColor != null) ...[
                    Container(
                      width: 1.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 2.w),
                  ],
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: accentColor ??
                          AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (tasks.isNotEmpty) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: (accentColor ?? AppTheme.lightTheme.primaryColor)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${tasks.length}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              accentColor ?? AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (onViewAll != null && tasks.length > 3)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        tasks.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: tasks.length > 3 ? 3 : tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCardWidget(
                    task: task,
                    onTap: () => _onTaskTap(context, task),
                    onComplete: () => _onTaskComplete(context, task),
                    onEdit: () => _onTaskEdit(context, task),
                    onReschedule: () => _onTaskReschedule(context, task),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: (accentColor ?? AppTheme.lightTheme.primaryColor)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CustomIconWidget(
              iconName: _getEmptyStateIcon(),
              color: accentColor ?? AppTheme.lightTheme.primaryColor,
              size: 32,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            emptyMessage ?? 'No tasks available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            _getEmptyStateSubtitle(),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getEmptyStateIcon() {
    switch (title.toLowerCase()) {
      case 'due today':
        return 'today';
      case 'this week':
        return 'date_range';
      case 'suggested':
        return 'lightbulb';
      default:
        return 'task_alt';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (title.toLowerCase()) {
      case 'due today':
        return 'Great job! You\'re all caught up for today.';
      case 'this week':
        return 'Plan your week ahead to stay productive.';
      case 'suggested':
        return 'Complete more tasks to unlock new suggestions.';
      default:
        return 'Add some tasks to get started on your journey.';
    }
  }

  void _onTaskTap(BuildContext context, Map<String, dynamic> task) {
    // Navigate to task details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening task: ${task['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onTaskComplete(BuildContext context, Map<String, dynamic> task) {
    final coinReward = task['coinReward'] as int? ?? 0;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text('Task completed! +$coinReward coins earned'),
            ),
          ],
        ),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onTaskEdit(BuildContext context, Map<String, dynamic> task) {
    // Navigate to task edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit task: ${task['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onTaskReschedule(BuildContext context, Map<String, dynamic> task) {
    // Show reschedule dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reschedule task: ${task['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
