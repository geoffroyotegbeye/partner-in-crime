import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCardWidget extends StatefulWidget {
  final Map<String, dynamic> task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onReschedule;

  const TaskCardWidget({
    Key? key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onEdit,
    this.onReschedule,
  }) : super(key: key);

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task['isCompleted'] ?? false;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.task['category'] as String? ?? 'productivity';
    final title = widget.task['title'] as String? ?? 'Untitled Task';
    final coinReward = widget.task['coinReward'] as int? ?? 0;
    final priority = widget.task['priority'] as String? ?? 'medium';
    final dueTime = widget.task['dueTime'] as String?;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onLongPress: () => _showContextMenu(context),
            child: Dismissible(
              key: Key(widget.task['id'].toString()),
              direction: DismissDirection.startToEnd,
              background: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 4.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Complete',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _completeTask();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: _isCompleted
                      ? AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.5)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getPriorityColor(priority).withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: _getCategoryIcon(category),
                          color: _getCategoryColor(category),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                decoration: _isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: _isCompleted
                                    ? AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            if (dueTime != null) ...[
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'schedule',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 14,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    dueTime,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.accentLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'monetization_on',
                                  color: AppTheme.accentLight,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$coinReward',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.accentLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          GestureDetector(
                            onTap: _completeTask,
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: _isCompleted
                                    ? AppTheme.secondaryLight
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: _isCompleted
                                    ? 'check'
                                    : 'check_box_outline_blank',
                                color: _isCompleted
                                    ? Colors.white
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _completeTask() {
    setState(() {
      _isCompleted = !_isCompleted;
    });
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem(
              icon: 'edit',
              title: 'Edit Task',
              onTap: () {
                Navigator.pop(context);
                if (widget.onEdit != null) widget.onEdit!();
              },
            ),
            _buildContextMenuItem(
              icon: 'schedule',
              title: 'Reschedule',
              onTap: () {
                Navigator.pop(context);
                if (widget.onReschedule != null) widget.onReschedule!();
              },
            ),
            _buildContextMenuItem(
              icon: 'check_circle',
              title: _isCompleted ? 'Mark Incomplete' : 'Mark Complete',
              onTap: () {
                Navigator.pop(context);
                _completeTask();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return 'work';
      case 'finance':
        return 'account_balance_wallet';
      case 'health':
        return 'favorite';
      case 'well-being':
        return 'self_improvement';
      default:
        return 'task_alt';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return AppTheme.primaryLight;
      case 'finance':
        return AppTheme.accentLight;
      case 'health':
        return AppTheme.errorLight;
      case 'well-being':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }
}
