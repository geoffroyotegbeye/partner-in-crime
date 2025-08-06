import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/success_animation_widget.dart';
import './widgets/welcome_header_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isTermsAccepted = false;
  bool _isLoading = false;
  bool _showSuccessAnimation = false;

  // Mock user data for demonstration
  final List<Map<String, dynamic>> _existingUsers = [
    {
      "email": "john.doe@example.com",
      "fullName": "John Doe",
    },
    {
      "email": "jane.smith@example.com",
      "fullName": "Jane Smith",
    },
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isEmailAlreadyRegistered(String email) {
    return (_existingUsers as List).any((dynamic user) =>
        (user as Map<String, dynamic>)["email"] == email.toLowerCase().trim());
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Please accept the Terms of Service and Privacy Policy'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Check if email is already registered
    if (_isEmailAlreadyRegistered(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'This email is already registered. Please use a different email or login.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          action: SnackBarAction(
            label: 'Login',
            textColor: AppTheme.lightTheme.colorScheme.tertiary,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success animation
      setState(() {
        _isLoading = false;
        _showSuccessAnimation = true;
      });
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registration failed. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _onSuccessAnimationComplete() {
    // Navigate to goal setup wizard after success animation
    Navigator.pushReplacementNamed(context, '/goal-setup-wizard');
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // App Bar with Back Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Create Account',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 10.w), // Balance the back button
                    ],
                  ),
                ),

                // Progress Indicator
                const ProgressIndicatorWidget(
                  currentStep: 1,
                  totalSteps: 3,
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Welcome Header
                        const WelcomeHeaderWidget(),

                        // Registration Form
                        RegistrationFormWidget(
                          formKey: _formKey,
                          fullNameController: _fullNameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isTermsAccepted: _isTermsAccepted,
                          onTermsChanged: (value) =>
                              setState(() => _isTermsAccepted = value),
                        ),

                        SizedBox(height: 4.h),

                        // Create Account Button
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                        height: 5.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'Creating Account...',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create Account',
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      CustomIconWidget(
                                        iconName: 'arrow_forward',
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Login Link
                        GestureDetector(
                          onTap: _navigateToLogin,
                          child: RichText(
                            text: TextSpan(
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Already have an account? '),
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Success Animation Overlay
            if (_showSuccessAnimation)
              SuccessAnimationWidget(
                onAnimationComplete: _onSuccessAnimationComplete,
              ),
          ],
        ),
      ),
    );
  }
}
