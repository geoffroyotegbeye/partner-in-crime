import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickTaskModalWidget extends StatefulWidget {
  final VoidCallback? onTaskCreated;

  const QuickTaskModalWidget({
    Key? key,
    this.onTaskCreated,
  }) : super(key: key);

  @override
  State<QuickTaskModalWidget> createState() => _QuickTaskModalWidgetState();
}

class _QuickTaskModalWidgetState extends State<QuickTaskModalWidget> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedCategory = 'productivity';
  String _selectedPriority = 'medium';
  int _coinReward = 10;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'productivity', 'icon': 'work', 'color': AppTheme.primaryLight},
    {
      'name': 'finance',
      'icon': 'account_balance_wallet',
      'color': AppTheme.accentLight
    },
    {'name': 'health', 'icon': 'favorite', 'color': AppTheme.errorLight},
    {
      'name': 'well-being',
      'icon': 'self_improvement',
      'color': AppTheme.secondaryLight
    },
  ];

  final List<Map<String, dynamic>> _priorities = [
    {'name': 'low', 'color': AppTheme.secondaryLight, 'coins': 5},
    {'name': 'medium', 'color': AppTheme.warningLight, 'coins': 10},
    {'name': 'high', 'color': AppTheme.errorLight, 'coins': 20},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 2.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 2.h,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Add Task',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Task Title',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter task title...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'task_alt',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: 3.h),
          Text(
            'Category',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 8.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 3.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category['color'].withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? category['color']
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: category['icon'],
                          color: isSelected
                              ? category['color']
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          category['name'].toString().toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? category['color']
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Priority',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: _priorities.map((priority) {
              final isSelected = _selectedPriority == priority['name'];

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority['name'];
                      _coinReward = priority['coins'];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 2.w),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? priority['color'].withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? priority['color']
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          priority['name'].toString().toUpperCase(),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? priority['color']
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'monetization_on',
                              color: AppTheme.accentLight,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${priority['coins']}',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.accentLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _titleController.text.trim().isEmpty ? null : _createTask,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add_task',
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Create Task',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _createTask() {
    if (_titleController.text.trim().isEmpty) return;

    // Create task logic here
    final newTask = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': _titleController.text.trim(),
      'category': _selectedCategory,
      'priority': _selectedPriority,
      'coinReward': _coinReward,
      'isCompleted': false,
      'createdAt': DateTime.now(),
    };

    Navigator.pop(context);

    if (widget.onTaskCreated != null) {
      widget.onTaskCreated!();
    }

    // Show success message
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
              child: Text(
                  'Task "${_titleController.text.trim()}" created successfully!'),
            ),
          ],
        ),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
