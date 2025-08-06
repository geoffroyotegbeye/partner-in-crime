import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_coin_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/progress_bar_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 5;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Turn Tasks into Rewards!",
      "description":
          "Complete daily tasks and earn virtual coins. Every achievement brings you closer to unlocking amazing content and rewards.",
      "imageUrl":
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "showAnimation": true,
      "type": "intro"
    },
    {
      "title": "Watch Your Virtual World Grow!",
      "description":
          "As you complete tasks, watch your personalized virtual environment evolve. Build cities, grow islands, or expand your workspace!",
      "imageUrl":
          "https://images.pexels.com/photos/1647962/pexels-photo-1647962.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "showAnimation": false,
      "type": "progress"
    },
    {
      "title": "Unlock Amazing Content!",
      "description":
          "Use your earned coins to access premium ebooks, courses, coaching sessions, and exclusive podcasts from industry experts.",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/11/29/06/15/book-1867171_1280.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "showAnimation": false,
      "type": "marketplace"
    },
    {
      "title": "Track Your Success Journey",
      "description":
          "Monitor your progress across multiple life categories with beautiful visualizations and celebrate every milestone achievement.",
      "imageUrl":
          "https://images.unsplash.com/photo-1551288049-bebda4e38f71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "showAnimation": false,
      "type": "tracking"
    },
    {
      "title": "Join the Community!",
      "description":
          "Connect with like-minded individuals, participate in challenges, and share your achievements with accountability partners.",
      "imageUrl":
          "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "showAnimation": false,
      "type": "community"
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToGoalSetup();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.mediumImpact();
    _navigateToGoalSetup();
  }

  void _navigateToGoalSetup() {
    Navigator.pushReplacementNamed(context, '/goal-setup-wizard');
  }

  void _onCoinTap() {
    HapticFeedback.lightImpact();
    // Show coin animation preview
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tap coins like this to earn rewards! 🎉',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildInteractiveElements() {
    final currentData = _onboardingData[_currentPage];

    switch (currentData["type"]) {
      case "intro":
        return Positioned(
          bottom: 25.h,
          left: 10.w,
          child: AnimatedCoinWidget(onTap: _onCoinTap),
        );
      case "progress":
        return Positioned(
          bottom: 20.h,
          left: 15.w,
          child: ProgressBarWidget(
            progress: 0.7,
            label: "Health Goals",
            color: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );
      case "tracking":
        return Positioned(
          bottom: 22.h,
          right: 10.w,
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 6.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Level 5',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Achiever',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Background Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.lightTheme.scaffoldBackgroundColor,
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),

              // Skip Button
              Positioned(
                top: 2.h,
                right: 4.w,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                  child: Text(
                    'Skip',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Page View
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  HapticFeedback.selectionClick();
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return OnboardingPageWidget(
                    title: data["title"],
                    description: data["description"],
                    imageUrl: data["imageUrl"],
                    showAnimation: data["showAnimation"] ?? false,
                    onAnimationTap:
                        data["showAnimation"] == true ? _onCoinTap : null,
                  );
                },
              ),

              // Interactive Elements
              _buildInteractiveElements(),

              // Bottom Navigation Area
              Positioned(
                bottom: 4.h,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page Indicator
                      PageIndicatorWidget(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                      ),

                      SizedBox(height: 4.h),

                      // Navigation Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous Button (invisible for first page)
                          SizedBox(
                            width: 20.w,
                            child: _currentPage > 0
                                ? TextButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'arrow_back_ios',
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          size: 4.w,
                                        ),
                                        Text(
                                          'Back',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ),

                          // Next/Get Started Button
                          ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 1.5.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _currentPage == _totalPages - 1
                                      ? 'Get Started'
                                      : 'Next',
                                  style: AppTheme.lightTheme.textTheme.bodyLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: _currentPage == _totalPages - 1
                                      ? 'rocket_launch'
                                      : 'arrow_forward_ios',
                                  color: Colors.white,
                                  size: 4.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
