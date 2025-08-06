import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './task_card_widget.dart';

class TaskListWidget extends StatelessWidget {
  final String filter;
  final String searchQuery;
  final String selectedFilter;
  final bool isRefreshing;

  const TaskListWidget({
    Key? key,
    required this.filter,
    required this.searchQuery,
    required this.selectedFilter,
    required this.isRefreshing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    final mockTasks = _getMockTasks();
    final filteredTasks = _filterTasks(mockTasks);

    if (filteredTasks.isEmpty) {
      return _EmptyState(filter: filter);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCardWidget(
          key: ValueKey(task['id']),
          title: task['title'] as String,
          description: task['description'] as String,
          coinReward: task['coinReward'] as int,
          priority: task['priority'] as String,
          category: task['category'] as String,
          dueDate: task['dueDate'] as String,
          isCompleted: task['isCompleted'] as bool,
          onToggleComplete: () => _toggleTaskComplete(task['id'] as String),
          onEdit: () => _editTask(context, task['id'] as String),
          onDelete: () => _deleteTask(context, task['id'] as String),
          onDuplicate: () => _duplicateTask(task['id'] as String),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getMockTasks() {
    return [
      {
        'id': '1',
        'title': 'Morning Workout',
        'description': 'Complete 30-minute cardio session',
        'coinReward': 50,
        'priority': 'high',
        'category': 'Health',
        'dueDate': '2025-08-06',
        'isCompleted': false,
      },
      {
        'id': '2',
        'title': 'Read Chapter 5',
        'description': 'Productivity book - Deep Work',
        'coinReward': 30,
        'priority': 'medium',
        'category': 'Learning',
        'dueDate': '2025-08-07',
        'isCompleted': true,
      },
      {
        'id': '3',
        'title': 'Team Meeting Prep',
        'description': 'Prepare slides for quarterly review',
        'coinReward': 75,
        'priority': 'high',
        'category': 'Work',
        'dueDate': '2025-08-06',
        'isCompleted': false,
      },
      {
        'id': '4',
        'title': 'Grocery Shopping',
        'description': 'Weekly essentials and meal prep ingredients',
        'coinReward': 25,
        'priority': 'low',
        'category': 'Personal',
        'dueDate': '2025-08-08',
        'isCompleted': false,
      },
    ];
  }

  List<Map<String, dynamic>> _filterTasks(List<Map<String, dynamic>> tasks) {
    var filtered = tasks.where((task) {
      // Search filter
      if (searchQuery.isNotEmpty) {
        final title = (task['title'] as String).toLowerCase();
        final description = (task['description'] as String).toLowerCase();
        if (!title.contains(searchQuery.toLowerCase()) &&
            !description.contains(searchQuery.toLowerCase())) {
          return false;
        }
      }

      // Priority filter
      if (selectedFilter != 'all' && task['priority'] != selectedFilter) {
        return false;
      }

      // Time-based filter
      final dueDate = DateTime.parse(task['dueDate'] as String);
      final now = DateTime.now();

      switch (filter) {
        case 'today':
          return dueDate.year == now.year &&
              dueDate.month == now.month &&
              dueDate.day == now.day;
        case 'week':
          final weekEnd = now.add(const Duration(days: 7));
          return dueDate.isBefore(weekEnd) &&
              dueDate.isAfter(now.subtract(const Duration(days: 1)));
        default:
          return true;
      }
    }).toList();

    // Sort by priority and due date
    filtered.sort((a, b) {
      final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
      final aPriority = priorityOrder[a['priority']] ?? 0;
      final bPriority = priorityOrder[b['priority']] ?? 0;

      if (aPriority != bPriority) {
        return bPriority.compareTo(aPriority);
      }

      return DateTime.parse(a['dueDate'] as String)
          .compareTo(DateTime.parse(b['dueDate'] as String));
    });

    return filtered;
  }

  void _toggleTaskComplete(String taskId) {
    // TODO: Implement task completion toggle
    print('Toggle complete: $taskId');
  }

  void _editTask(BuildContext context, String taskId) {
    // TODO: Navigate to task edit screen
    print('Edit task: $taskId');
  }

  void _deleteTask(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement task deletion
              print('Delete task: $taskId');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _duplicateTask(String taskId) {
    // TODO: Implement task duplication
    print('Duplicate task: $taskId');
  }
}

class _EmptyState extends StatelessWidget {
  final String filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;

    switch (filter) {
      case 'today':
        message = 'No tasks for today!\nTake a well-deserved break.';
        icon = Icons.wb_sunny_outlined;
        break;
      case 'week':
        message = 'No tasks this week!\nYou\'re all caught up.';
        icon = Icons.calendar_today_outlined;
        break;
      default:
        message = 'No tasks found.\nCreate your first task to get started!';
        icon = Icons.assignment_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
            ),
          ),
          const SizedBox(height: 24),
          if (filter == 'all')
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Show task creation modal
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Task'),
            ),
        ],
      ),
    );
  }
}
