import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_gallery_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/progress_charts_widget.dart';
import './widgets/settings_quick_access_widget.dart';
import './widgets/social_features_widget.dart';
import './widgets/stats_overview_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // User profile data
  final Map<String, dynamic> _userProfile = {
    'name': 'Alex Johnson',
    'email': 'alex.johnson@email.com',
    'avatar':
        'https://images.unsplash.com/photo-1494790108755-2616b612b376?w=150',
    'level': 12,
    'currentLevelProgress': 0.75,
    'totalMotiCoins': 2847,
    'joinDate': '2024-01-15',
    'location': 'San Francisco, CA',
    'bio':
        'Productivity enthusiast and goal crusher. Always looking for new ways to improve myself and help others achieve their dreams.',
  };

  // Stats data
  final Map<String, dynamic> _userStats = {
    'totalTasks': 156,
    'currentStreak': 15,
    'longestStreak': 28,
    'badgesEarned': 12,
    'completionRate': 0.87,
    'averageDaily': 4.2,
  };

  // Achievement data
  final List<Map<String, dynamic>> _achievements = [
    {
      'id': 'early_bird',
      'title': 'Early Bird',
      'description': 'Complete 10 morning tasks',
      'rarity': 'common',
      'earned': true,
      'earnedDate': '2024-07-20',
      'progress': 10,
      'target': 10,
      'icon': 'wb_sunny',
    },
    {
      'id': 'streak_master',
      'title': 'Streak Master',
      'description': '15-day completion streak',
      'rarity': 'rare',
      'earned': true,
      'earnedDate': '2024-07-25',
      'progress': 15,
      'target': 15,
      'icon': 'local_fire_department',
    },
    {
      'id': 'century_club',
      'title': 'Century Club',
      'description': 'Complete 100 total tasks',
      'rarity': 'epic',
      'earned': true,
      'earnedDate': '2024-07-30',
      'progress': 156,
      'target': 100,
      'icon': 'emoji_events',
    },
    {
      'id': 'legendary_achiever',
      'title': 'Legendary Achiever',
      'description': 'Complete 500 total tasks',
      'rarity': 'legendary',
      'earned': false,
      'earnedDate': null,
      'progress': 156,
      'target': 500,
      'icon': 'stars',
    },
  ];

  // Progress charts data
  final Map<String, List<double>> _progressData = {
    'weekly': [3.0, 5.0, 2.0, 6.0, 4.0, 7.0, 3.0],
    'monthly': [18.0, 22.0, 15.0, 28.0, 25.0, 19.0],
    'categories': [35.0, 28.0, 22.0, 15.0], // Fitness, Work, Learning, Personal
  };

  bool _isEditingProfile = false;
  String _selectedTimeframe = 'weekly';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh profile data in real implementation
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
            const Text('Profile updated'),
          ],
        ),
        backgroundColor: AppTheme.secondaryLight,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _editProfile() {
    setState(() {
      _isEditingProfile = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                'Edit Profile',
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 4.h),

              // Profile picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 15.w,
                      backgroundImage: NetworkImage(_userProfile['avatar']),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          // Handle photo selection
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Photo selection feature coming soon!'),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'camera_alt',
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Form fields
              _buildEditField('Name', _userProfile['name']),
              SizedBox(height: 2.h),
              _buildEditField('Bio', _userProfile['bio'], maxLines: 3),
              SizedBox(height: 2.h),
              _buildEditField('Location', _userProfile['location']),

              const Spacer(),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditingProfile = false;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() {
        _isEditingProfile = false;
      });
    });
  }

  Widget _buildEditField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
              ),
            ),
            contentPadding: EdgeInsets.all(3.w),
          ),
        ),
      ],
    );
  }

  void _shareProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress shared successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Export Data',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose the data format you want to export:',
              style: GoogleFonts.inter(),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildExportOption('PDF', Icons.picture_as_pdf),
                _buildExportOption('CSV', Icons.table_chart),
                _buildExportOption('JSON', Icons.code),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(String format, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exporting data as $format...'),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 30,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            format,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
          onRefresh: _refreshProfile,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: ProfileHeaderWidget(
                  userProfile: _userProfile,
                  onEditProfile: _editProfile,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Stats Overview
              SliverToBoxAdapter(
                child: StatsOverviewWidget(
                  userStats: _userStats,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Achievement Gallery
              SliverToBoxAdapter(
                child: AchievementGalleryWidget(
                  achievements: _achievements,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Progress Charts
              SliverToBoxAdapter(
                child: ProgressChartsWidget(
                  progressData: _progressData,
                  selectedTimeframe: _selectedTimeframe,
                  onTimeframeChanged: (timeframe) {
                    setState(() {
                      _selectedTimeframe = timeframe;
                    });
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Social Features
              SliverToBoxAdapter(
                child: SocialFeaturesWidget(
                  onShareProgress: _shareProgress,
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Settings Quick Access
              SliverToBoxAdapter(
                child: SettingsQuickAccessWidget(
                  onExportData: _exportData,
                ),
              ),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Profile tab active
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboardHome,
                (route) => false,
              );
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
              // Already on user profile
              break;
          }
        },
      ),
    );
  }
}
