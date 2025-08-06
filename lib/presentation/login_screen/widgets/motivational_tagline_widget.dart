import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class MotivationalTaglineWidget extends StatefulWidget {
  const MotivationalTaglineWidget({Key? key}) : super(key: key);

  @override
  State<MotivationalTaglineWidget> createState() =>
      _MotivationalTaglineWidgetState();
}

class _MotivationalTaglineWidgetState extends State<MotivationalTaglineWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _taglines = [
    'Level up your life!',
    'Turn goals into achievements!',
    'Your journey starts here!',
    'Unlock your potential!',
    'Progress is your superpower!',
  ];

  int _currentTaglineIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _startTaglineRotation();
  }

  void _startTaglineRotation() {
    _animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _currentTaglineIndex =
                    (_currentTaglineIndex + 1) % _taglines.length;
              });
              _startTaglineRotation();
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'emoji_events',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    _taglines[_currentTaglineIndex],
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'auto_awesome',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 4.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}