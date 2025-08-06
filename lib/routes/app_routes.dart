import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/goal_setup_wizard/goal_setup_wizard.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/dashboard_home/dashboard_home.dart';
import '../presentation/task_management/task_management.dart';
import '../presentation/task_completion_proof/task_completion_proof.dart';
import '../presentation/progress_visualization/progress_visualization.dart';
import '../presentation/marketplace/marketplace.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/settings/settings.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String login = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String goalSetupWizard = '/goal-setup-wizard';
  static const String registration = '/registration-screen';
  static const String dashboardHome = '/dashboard-home';
  static const String taskManagement = '/task-management';
  static const String taskCompletionProof = '/task-completion-proof';
  static const String progressVisualization = '/progress-visualization';
  static const String marketplace = '/marketplace';
  static const String userProfile = '/user-profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    goalSetupWizard: (context) => const GoalSetupWizard(),
    registration: (context) => const RegistrationScreen(),
    dashboardHome: (context) => const DashboardHome(),
    taskManagement: (context) => const TaskManagement(),
    taskCompletionProof: (context) => const TaskCompletionProof(),
    progressVisualization: (context) => const ProgressVisualization(),
    marketplace: (context) => const Marketplace(),
    userProfile: (context) => const UserProfile(),
    settings: (context) => const Settings(),
    // TODO: Add your other routes here
  };
}
