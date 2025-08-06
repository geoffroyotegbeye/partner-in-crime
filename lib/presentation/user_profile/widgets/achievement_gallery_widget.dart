import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementGalleryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementGalleryWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final earnedAchievements =
        achievements.where((a) => a['earned'] == true).toList();
    final lockedAchievements =
        achievements.where((a) => a['earned'] == false).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Achievements',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${earnedAchievements.length}/${achievements.length}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Earned achievements
          if (earnedAchievements.isNotEmpty) ...[
            Text(
              'Unlocked',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(204),
              ),
            ),
            SizedBox(height: 1.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: earnedAchievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementCard(earnedAchievements[index], true);
              },
            ),
          ],

          if (earnedAchievements.isNotEmpty && lockedAchievements.isNotEmpty)
            SizedBox(height: 3.h),

          // Locked achievements
          if (lockedAchievements.isNotEmpty) ...[
            Text(
              'Locked',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(204),
              ),
            ),
            SizedBox(height: 1.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: lockedAchievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementCard(lockedAchievements[index], false);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
      Map<String, dynamic> achievement, bool isEarned) {
    final rarityColor = _getRarityColor(achievement['rarity']);

    return GestureDetector(
      onTap: () => _showAchievementDetail(achievement),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isEarned
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.colorScheme.surface.withAlpha(128),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: rarityColor,
            width: 2,
          ),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: rarityColor.withAlpha(51),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // Achievement icon and rarity
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: rarityColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomIconWidget(
                    iconName: achievement['icon'],
                    color: isEarned ? rarityColor : rarityColor.withAlpha(128),
                    size: 24,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: rarityColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    achievement['rarity'].toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: rarityColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Achievement title
            Text(
              achievement['title'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isEarned
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurface.withAlpha(128),
              ),
            ),

            const Spacer(),

            // Progress or date
            if (isEarned && achievement['earnedDate'] != null)
              Text(
                'Earned ${_formatDate(achievement['earnedDate'])}',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color:
                      AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
                ),
              )
            else if (!isEarned)
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: achievement['progress'] / achievement['target'],
                      backgroundColor: rarityColor.withAlpha(51),
                      valueColor: AlwaysStoppedAnimation<Color>(rarityColor),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${achievement['progress']}/${achievement['target']}',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetail(Map<String, dynamic> achievement) {
    // Show achievement detail modal
    // Implementation would show a modal with full achievement details
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
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
    return '${months[date.month - 1]} ${date.day}';
  }
}
