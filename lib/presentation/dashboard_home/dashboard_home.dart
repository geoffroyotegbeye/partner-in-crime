import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_banner_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/progress_overview_widget.dart';
import './widgets/quick_task_modal_widget.dart';
import './widgets/task_section_widget.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock user data
  final String _userName = "Alex Johnson";
  final int _currentLevel = 12;
  int _coinBalance = 2847;
  final double _weeklyCompletionPercentage = 78.5;
  final int _streakCount = 15;
  final int _tasksCompletedToday = 4;
  final int _coinsEarnedThisWeek = 185;

  // Achievement banner state
  Map<String, dynamic>? _currentAchievement;

  // Mock task data
  final List<Map<String, dynamic>> _dueTodayTasks = [
    {
      "id": 1,
      "title": "Complete quarterly financial review",
      "category": "finance",
      "priority": "high",
      "coinReward": 25,
      "isCompleted": false,
      "dueTime": "2:00 PM",
    },
    {
      "id": 2,
      "title": "30-minute morning workout",
      "category": "health",
      "priority": "medium",
      "coinReward": 15,
      "isCompleted": false,
      "dueTime": "7:00 AM",
    },
    {
      "id": 3,
      "title": "Meditation session",
      "category": "well-being",
      "priority": "low",
      "coinReward": 10,
      "isCompleted": true,
      "dueTime": "6:30 AM",
    },
  ];

  final List<Map<String, dynamic>> _thisWeekTasks = [
    {
      "id": 4,
      "title": "Prepare presentation for client meeting",
      "category": "productivity",
      "priority": "high",
      "coinReward": 30,
      "isCompleted": false,
      "dueTime": "Tomorrow 10:00 AM",
    },
    {
      "id": 5,
      "title": "Update investment portfolio",
      "category": "finance",
      "priority": "medium",
      "coinReward": 20,
      "isCompleted": false,
      "dueTime": "Wednesday",
    },
    {
      "id": 6,
      "title": "Schedule annual health checkup",
      "category": "health",
      "priority": "medium",
      "coinReward": 15,
      "isCompleted": false,
      "dueTime": "Friday",
    },
    {
      "id": 7,
      "title": "Read 2 chapters of productivity book",
      "category": "well-being",
      "priority": "low",
      "coinReward": 12,
      "isCompleted": false,
      "dueTime": "Weekend",
    },
  ];

  final List<Map<String, dynamic>> _suggestedTasks = [
    {
      "id": 8,
      "title": "Set up automated savings plan",
      "category": "finance",
      "priority": "medium",
      "coinReward": 25,
      "isCompleted": false,
    },
    {
      "id": 9,
      "title": "Learn a new productivity technique",
      "category": "productivity",
      "priority": "low",
      "coinReward": 18,
      "isCompleted": false,
    },
    {
      "id": 10,
      "title": "Plan healthy meal prep for next week",
      "category": "health",
      "priority": "medium",
      "coinReward": 20,
      "isCompleted": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkForNewAchievements();
  }

  void _checkForNewAchievements() {
    // Simulate achievement unlock
    if (_streakCount >= 15) {
      setState(() {
        _currentAchievement = {
          'id': 'streak_master',
          'title': 'Streak Master!',
          'description': 'You\'ve maintained a 15-day streak. Keep it up!',
          'badgeIcon': 'local_fire_department',
          'coinReward': 50,
        };
      });
    }
  }

  Future<void> _refreshData() async {
    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Update data here in real implementation
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Dashboard refreshed'),
          ],
        ),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showQuickTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => QuickTaskModalWidget(
        onTaskCreated: () {
          setState(() {
            // Refresh task lists in real implementation
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Achievement Banner
              if (_currentAchievement != null)
                SliverToBoxAdapter(
                  child: AchievementBannerWidget(
                    achievement: _currentAchievement,
                    onDismiss: () {
                      setState(() {
                        _currentAchievement = null;
                      });
                    },
                  ),
                ),

              // Greeting Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: GreetingHeaderWidget(
                    userName: _userName,
                    currentLevel: _currentLevel,
                    coinBalance: _coinBalance,
                  ),
                ),
              ),

              // Progress Overview
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ProgressOverviewWidget(
                    weeklyCompletionPercentage: _weeklyCompletionPercentage,
                    streakCount: _streakCount,
                    tasksCompletedToday: _tasksCompletedToday,
                    coinsEarnedThisWeek: _coinsEarnedThisWeek,
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Due Today Section
              SliverToBoxAdapter(
                child: TaskSectionWidget(
                  title: 'Due Today',
                  tasks: _dueTodayTasks,
                  accentColor: AppTheme.errorLight,
                  emptyMessage: 'No tasks due today',
                  onViewAll: () {
                    Navigator.pushNamed(context, '/tasks-list');
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // This Week Section
              SliverToBoxAdapter(
                child: TaskSectionWidget(
                  title: 'This Week',
                  tasks: _thisWeekTasks,
                  accentColor: AppTheme.primaryLight,
                  emptyMessage: 'No upcoming tasks this week',
                  onViewAll: () {
                    Navigator.pushNamed(context, '/weekly-tasks');
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Suggested Section
              SliverToBoxAdapter(
                child: TaskSectionWidget(
                  title: 'Suggested',
                  tasks: _suggestedTasks,
                  accentColor: AppTheme.secondaryLight,
                  emptyMessage: 'Complete more tasks to unlock suggestions',
                  onViewAll: () {
                    Navigator.pushNamed(context, '/suggested-tasks');
                  },
                ),
              ),

              // Bottom padding for FAB
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // Home tab active
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task_alt',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'store',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.taskManagement);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.progressVisualization);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.marketplace);
              break;
            case 4:
              Navigator.pushNamed(context, AppRoutes.userProfile);
              break;
          }
        },
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickTaskModal,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
