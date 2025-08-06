import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _coinController;
  late AnimationController _backgroundController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _coinRotationAnimation;
  late Animation<double> _backgroundAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Coin animation controller
    _coinController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    // Coin rotation animation
    _coinRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _coinController,
      curve: Curves.linear,
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoController.forward();
    _coinController.repeat();
    _backgroundController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate app initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserProgressData(),
        _syncVirtualCoinBalance(),
        _prepareCachedTaskInformation(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 3000));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
      });

      // Show retry option after 5 seconds
      await Future.delayed(const Duration(seconds: 5));
      if (mounted && _hasError) {
        _showRetryOption();
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadUserProgressData() async {
    // Simulate loading user progress
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _syncVirtualCoinBalance() async {
    // Simulate syncing coin balance
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _prepareCachedTaskInformation() async {
    // Simulate preparing cached tasks
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    // Mock navigation logic based on user status
    final bool isAuthenticated = _mockIsAuthenticated();
    final bool isNewUser = _mockIsNewUser();

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/dashboard-home');
    } else if (isNewUser) {
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  bool _mockIsAuthenticated() {
    // Mock authentication status - in real app, check stored tokens
    return false;
  }

  bool _mockIsNewUser() {
    // Mock new user status - in real app, check if user has completed onboarding
    return true;
  }

  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            _errorMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _hasError = false;
                  _errorMessage = '';
                });
                _initializeApp();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _coinController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide system status bar for full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _coinController,
          _backgroundController,
        ]),
        builder: (context, child) {
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppTheme.lightTheme.colorScheme.secondary,
                    AppTheme.lightTheme.colorScheme.primary,
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.secondary,
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to center content
                  const Spacer(flex: 2),

                  // App Logo with Animation
                  _buildAnimatedLogo(),

                  SizedBox(height: 8.h),

                  // Loading Coin Animation
                  _buildLoadingCoin(),

                  SizedBox(height: 4.h),

                  // Loading Text
                  _buildLoadingText(),

                  // Spacer to push content up
                  const Spacer(flex: 3),

                  // App Version
                  _buildVersionInfo(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return FadeTransition(
      opacity: _logoFadeAnimation,
      child: ScaleTransition(
        scale: _logoScaleAnimation,
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 12.w,
              ),
              SizedBox(height: 1.h),
              Text(
                'PIC',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCoin() {
    return RotationTransition(
      turns: _coinRotationAnimation,
      child: Container(
        width: 16.w,
        height: 16.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'monetization_on',
            color: Colors.white,
            size: 8.w,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingText() {
    return Column(
      children: [
        Text(
          _hasError
              ? 'Connection Failed'
              : (_isInitialized ? 'Ready to Go!' : 'Loading...'),
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        if (!_hasError && !_isInitialized)
          SizedBox(
            width: 40.w,
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 3,
            ),
          ),
        if (_hasError)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              'Please check your internet connection',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'Partner in Crime v1.0.0',
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: Colors.white.withValues(alpha: 0.7),
        fontSize: 10.sp,
      ),
    );
  }
}
