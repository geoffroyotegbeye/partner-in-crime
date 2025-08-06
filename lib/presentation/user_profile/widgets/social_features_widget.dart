import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialFeaturesWidget extends StatelessWidget {
  final VoidCallback onShareProgress;

  const SocialFeaturesWidget({
    Key? key,
    required this.onShareProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Features',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Share progress button
          Container(
            width: double.infinity,
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share Your Progress',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Let friends see your achievements',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withAlpha(179),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onShareProgress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Share',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Leaderboard preview
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'leaderboard',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Friends Leaderboard',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'View All',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Leaderboard entries
                      _buildLeaderboardEntry(
                          '1', 'Sarah M.', '2,459 coins', '🥇'),
                      SizedBox(height: 1.h),
                      _buildLeaderboardEntry('2', 'You', '2,847 coins', '🥈'),
                      SizedBox(height: 1.h),
                      _buildLeaderboardEntry(
                          '3', 'Mike R.', '2,234 coins', '🥉'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardEntry(
      String rank, String name, String coins, String medal) {
    final isCurrentUser = name == 'You';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.lightTheme.primaryColor.withAlpha(26)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isCurrentUser
            ? Border.all(color: AppTheme.lightTheme.primaryColor, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Text(
            medal,
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(width: 3.w),
          Text(
            rank,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.w500,
                color: isCurrentUser
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            coins,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}
