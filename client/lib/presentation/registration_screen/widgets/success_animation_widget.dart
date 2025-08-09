import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SuccessAnimationWidget extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SuccessAnimationWidget({
    Key? key,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<SuccessAnimationWidget> createState() => _SuccessAnimationWidgetState();
}

class _SuccessAnimationWidgetState extends State<SuccessAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _coinController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _coinAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _coinController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _coinAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _coinController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  void _startAnimation() async {
    await _scaleController.forward();
    await _coinController.forward();

    // Wait a bit before calling completion
    await Future.delayed(const Duration(milliseconds: 800));
    widget.onAnimationComplete();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon with Scale Animation
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),

            // Success Text
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _scaleAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        'Welcome Aboard!',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Your growth journey starts now',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),

            // Falling Coins Animation
            AnimatedBuilder(
              animation: _coinAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: 80.w,
                  height: 15.h,
                  child: Stack(
                    children: List.generate(8, (index) {
                      final delay = index * 0.1;
                      final animationValue =
                          (_coinAnimation.value - delay).clamp(0.0, 1.0);
                      final xOffset = (index % 4) * 20.w;
                      final yOffset = animationValue * 12.h;

                      return Positioned(
                        left: xOffset,
                        top: yOffset,
                        child: Opacity(
                          opacity: animationValue > 0
                              ? (1.0 - animationValue * 0.5)
                              : 0.0,
                          child: Transform.rotate(
                            angle:
                                animationValue * 6.28 * 2, // 2 full rotations
                            child: CustomIconWidget(
                              iconName: 'monetization_on',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),

            SizedBox(height: 2.h),

            // Reward Text
            AnimatedBuilder(
              animation: _coinAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _coinAnimation.value,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'monetization_on',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '+50 Welcome Coins Earned!',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
