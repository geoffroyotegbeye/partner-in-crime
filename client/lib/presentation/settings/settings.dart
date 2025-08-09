import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Settings state
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _taskReminders = true;
  bool _achievementNotifications = true;
  bool _weeklyReports = true;
  bool _dataSharing = false;
  bool _profileVisibility = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Settings
            _buildSectionTitle('Notifications'),
            SizedBox(height: 2.h),
            _buildSettingsCard([
              _buildSwitchSetting(
                'Push Notifications',
                'Receive push notifications on your device',
                _pushNotifications,
                (value) => setState(() => _pushNotifications = value),
              ),
              _buildSwitchSetting(
                'Email Notifications',
                'Get updates via email',
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
              ),
              _buildSwitchSetting(
                'Task Reminders',
                'Remind me about upcoming tasks',
                _taskReminders,
                (value) => setState(() => _taskReminders = value),
              ),
              _buildSwitchSetting(
                'Achievement Notifications',
                'Celebrate when you unlock achievements',
                _achievementNotifications,
                (value) => setState(() => _achievementNotifications = value),
              ),
              _buildSwitchSetting(
                'Weekly Reports',
                'Get weekly progress summaries',
                _weeklyReports,
                (value) => setState(() => _weeklyReports = value),
              ),
            ]),

            SizedBox(height: 4.h),

            // Privacy Settings
            _buildSectionTitle('Privacy & Data'),
            SizedBox(height: 2.h),
            _buildSettingsCard([
              _buildSwitchSetting(
                'Data Sharing',
                'Share anonymous usage data to improve the app',
                _dataSharing,
                (value) => setState(() => _dataSharing = value),
              ),
              _buildSwitchSetting(
                'Profile Visibility',
                'Allow others to see your profile',
                _profileVisibility,
                (value) => setState(() => _profileVisibility = value),
              ),
              _buildActionSetting(
                'Delete Account',
                'Permanently delete your account and all data',
                Icons.delete,
                Colors.red,
                _showDeleteAccountDialog,
              ),
            ]),

            SizedBox(height: 4.h),

            // App Settings
            _buildSectionTitle('App Preferences'),
            SizedBox(height: 2.h),
            _buildSettingsCard([
              _buildSwitchSetting(
                'Dark Mode',
                'Use dark theme for the app',
                _darkMode,
                (value) => setState(() => _darkMode = value),
              ),
              _buildDropdownSetting(
                'Language',
                'Choose your preferred language',
                _selectedLanguage,
                _languages,
                (value) => setState(() => _selectedLanguage = value!),
              ),
              _buildActionSetting(
                'Clear Cache',
                'Clear app cache to free up storage',
                Icons.cleaning_services,
                AppTheme.lightTheme.primaryColor,
                _clearCache,
              ),
            ]),

            SizedBox(height: 4.h),

            // About
            _buildSectionTitle('About'),
            SizedBox(height: 2.h),
            _buildSettingsCard([
              _buildActionSetting(
                'Terms of Service',
                'Read our terms and conditions',
                Icons.description,
                AppTheme.lightTheme.colorScheme.onSurface,
                () => _showDialog(
                    'Terms of Service', 'Terms of service content...'),
              ),
              _buildActionSetting(
                'Privacy Policy',
                'Learn how we protect your data',
                Icons.privacy_tip,
                AppTheme.lightTheme.colorScheme.onSurface,
                () =>
                    _showDialog('Privacy Policy', 'Privacy policy content...'),
              ),
              _buildActionSetting(
                'About Partner in Crime',
                'Version 1.0.0 - Learn more about the app',
                Icons.info,
                AppTheme.lightTheme.colorScheme.onSurface,
                () => _showDialog('About',
                    'Partner in Crime v1.0.0\n\nYour AI-powered productivity companion.'),
              ),
            ]),

            SizedBox(height: 6.h),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
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
        children: children,
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
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
          DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
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
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion feature coming soon!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.inter(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          content,
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
