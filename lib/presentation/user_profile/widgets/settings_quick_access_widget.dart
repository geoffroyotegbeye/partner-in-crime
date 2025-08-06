import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsQuickAccessWidget extends StatelessWidget {
  final VoidCallback onExportData;

  const SettingsQuickAccessWidget({
    Key? key,
    required this.onExportData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Privacy',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
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
                // Notification preferences
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage push notifications',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),

                Divider(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(51)),

                // Account management
                _buildSettingItem(
                  icon: Icons.account_circle,
                  title: 'Account Management',
                  subtitle: 'Update account details',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),

                Divider(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(51)),

                // Privacy controls
                _buildSettingItem(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Controls',
                  subtitle: 'Manage data sharing',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),

                Divider(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(51)),

                // Export data
                _buildSettingItem(
                  icon: Icons.download,
                  title: 'Export Data',
                  subtitle: 'Download your progress data',
                  onTap: onExportData,
                ),

                Divider(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(51)),

                // Help & Support
                _buildSettingItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'Get help or contact support',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help & Support feature coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurface.withAlpha(128),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
