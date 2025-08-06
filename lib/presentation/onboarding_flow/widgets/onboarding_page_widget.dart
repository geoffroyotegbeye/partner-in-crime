import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool showAnimation;
  final VoidCallback? onAnimationTap;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.showAnimation = false,
    this.onAnimationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Container
          Container(
            width: 80.w,
            height: 40.h,
            margin: EdgeInsets.only(bottom: 4.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: imageUrl,
                    width: 80.w,
                    height: 40.h,
                    fit: BoxFit.cover,
                  ),
                  if (showAnimation)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: onAnimationTap,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme
                                        .lightTheme.colorScheme.tertiary
                                        .withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: CustomIconWidget(
                                iconName: 'play_arrow',
                                color: Colors.white,
                                size: 8.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Description
          Container(
            width: 85.w,
            child: Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
