import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final String password;

  const PasswordStrengthWidget({
    Key? key,
    required this.password,
  }) : super(key: key);

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      case 5:
        return 'Epic!';
      default:
        return 'Weak';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppTheme.lightTheme.colorScheme.error;
      case 2:
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 3:
        return AppTheme.lightTheme.colorScheme.secondary;
      case 4:
      case 5:
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(strength);

    return password.isEmpty
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Password Strength: ',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      strengthText,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: strengthColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (strength >= 4) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: Container(
                        height: 0.5.h,
                        margin: EdgeInsets.only(right: index < 4 ? 1.w : 0),
                        decoration: BoxDecoration(
                          color: index < strength
                              ? strengthColor
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
  }
}
