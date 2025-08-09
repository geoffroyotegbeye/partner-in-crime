import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatsOverviewWidget extends StatelessWidget {
  final Map<String, dynamic> userStats;

  const StatsOverviewWidget({
    Key? key,
    required this.userStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics Overview',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 3.h,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Tasks',
                '${userStats['totalTasks']}',
                Icons.task_alt,
                AppTheme.lightTheme.primaryColor,
              ),
              _buildStatCard(
                'Current Streak',
                '${userStats['currentStreak']} days',
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildStatCard(
                'Completion Rate',
                '${(userStats['completionRate'] * 100).toInt()}%',
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatCard(
                'Badges Earned',
                '${userStats['badgesEarned']}',
                Icons.emoji_events,
                Colors.amber,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Additional stats
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMiniStat(
                  'Longest Streak',
                  '${userStats['longestStreak']} days',
                  Icons.trending_up,
                ),
                Container(
                  height: 8.h,
                  width: 1,
                  color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                ),
                _buildMiniStat(
                  'Daily Average',
                  '${userStats['averageDaily']}',
                  Icons.today,
                ),
                Container(
                  height: 8.h,
                  width: 1,
                  color: AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                ),
                _buildMiniStat(
                  'Member Since',
                  _formatJoinDate(),
                  Icons.calendar_month,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ],
    );
  }

  String _formatJoinDate() {
    // Format join date to show month/year
    final date = DateTime.parse('2024-01-15'); // userStats['joinDate']
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
