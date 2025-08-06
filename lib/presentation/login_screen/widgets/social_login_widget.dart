import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String provider) onSocialLogin;

  const SocialLoginWidget({
    Key? key,
    required this.onSocialLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Google',
                iconName: 'g_translate',
                backgroundColor: Colors.white,
                borderColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                textColor: AppTheme.lightTheme.colorScheme.onSurface,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onSocialLogin('Google');
                },
              ),
            ),
            SizedBox(width: 3.w),

            // Apple Login
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Apple',
                iconName: 'apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onSocialLogin('Apple');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required String iconName,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: textColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                provider,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}