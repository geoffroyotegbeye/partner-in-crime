import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressBarWidget extends StatefulWidget {
  final double progress;
  final String label;
  final Color? color;

  const ProgressBarWidget({
    Key? key,
    required this.progress,
    required this.label,
    this.color,
  }) : super(key: key);

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            widget.label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          // Progress Bar Container
          Container(
            width: 70.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.h),
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    Container(
                      width: 70.w * _progressAnimation.value,
                      height: 1.5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        gradient: LinearGradient(
                          colors: [
                            widget.color ??
                                AppTheme.lightTheme.colorScheme.secondary,
                            (widget.color ??
                                    AppTheme.lightTheme.colorScheme.secondary)
                                .withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                    if (_progressAnimation.value > 0.1)
                      Positioned(
                        right: 2.w,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            width: 0.8.h,
                            height: 0.8.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 0.5.h),

          // Progress Text
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Text(
                '${(_progressAnimation.value * 100).toInt()}% Complete',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
