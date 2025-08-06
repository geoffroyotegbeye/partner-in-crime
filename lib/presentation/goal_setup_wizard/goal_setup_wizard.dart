import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selection_card.dart';
import './widgets/custom_form_field.dart';
import './widgets/goal_template_card.dart';
import './widgets/navigation_buttons.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/schedule_calendar_grid.dart';

class GoalSetupWizard extends StatefulWidget {
  const GoalSetupWizard({Key? key}) : super(key: key);

  @override
  State<GoalSetupWizard> createState() => _GoalSetupWizardState();
}

class _GoalSetupWizardState extends State<GoalSetupWizard>
    with TickerProviderStateMixin {
  int currentStep = 1;
  final int totalSteps = 4;

  // Step 1: Category Selection
  String? selectedCategory;

  // Step 2: Goal Template Selection
  String? selectedGoalTemplate;

  // Step 3: Custom Goal Details
  final TextEditingController goalTitleController = TextEditingController();
  final TextEditingController goalDescriptionController =
      TextEditingController();
  final TextEditingController targetValueController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Step 4: Schedule Selection
  List<String> selectedDays = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock data for categories
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Productivity',
      'iconName': 'work',
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Health',
      'iconName': 'favorite',
      'color': const Color(0xFF10B981),
    },
    {
      'title': 'Finance',
      'iconName': 'account_balance_wallet',
      'color': const Color(0xFFF59E0B),
    },
    {
      'title': 'Well-being',
      'iconName': 'self_improvement',
      'color': const Color(0xFF8B5CF6),
    },
  ];

  // Mock data for goal templates
  final Map<String, List<Map<String, dynamic>>> goalTemplates = {
    'Productivity': [
      {
        'title': 'Complete Daily Tasks',
        'description':
            'Finish all planned tasks for the day with focus and efficiency',
        'iconName': 'task_alt',
        'coinReward': 50,
      },
      {
        'title': 'Time Management',
        'description':
            'Use time blocking and pomodoro technique for better productivity',
        'iconName': 'schedule',
        'coinReward': 75,
      },
      {
        'title': 'Skill Development',
        'description':
            'Dedicate time daily to learning new professional skills',
        'iconName': 'school',
        'coinReward': 100,
      },
    ],
    'Health': [
      {
        'title': 'Daily Exercise',
        'description': 'Complete 30 minutes of physical activity every day',
        'iconName': 'fitness_center',
        'coinReward': 60,
      },
      {
        'title': 'Healthy Eating',
        'description': 'Follow a balanced diet with proper nutrition tracking',
        'iconName': 'restaurant',
        'coinReward': 40,
      },
      {
        'title': 'Sleep Schedule',
        'description': 'Maintain consistent sleep pattern for 7-8 hours daily',
        'iconName': 'bedtime',
        'coinReward': 30,
      },
    ],
    'Finance': [
      {
        'title': 'Budget Tracking',
        'description': 'Monitor daily expenses and stick to monthly budget',
        'iconName': 'trending_up',
        'coinReward': 80,
      },
      {
        'title': 'Savings Goal',
        'description':
            'Save a specific amount each week towards financial goals',
        'iconName': 'savings',
        'coinReward': 90,
      },
      {
        'title': 'Investment Learning',
        'description': 'Study investment strategies and market analysis daily',
        'iconName': 'show_chart',
        'coinReward': 70,
      },
    ],
    'Well-being': [
      {
        'title': 'Meditation Practice',
        'description': 'Practice mindfulness and meditation for mental clarity',
        'iconName': 'spa',
        'coinReward': 45,
      },
      {
        'title': 'Gratitude Journal',
        'description': 'Write down three things you are grateful for each day',
        'iconName': 'edit_note',
        'coinReward': 35,
      },
      {
        'title': 'Social Connection',
        'description': 'Spend quality time with family and friends regularly',
        'iconName': 'people',
        'coinReward': 55,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    goalTitleController.dispose();
    goalDescriptionController.dispose();
    targetValueController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (currentStep < totalSteps) {
        setState(() {
          currentStep++;
        });
        _animationController.reset();
        _animationController.forward();
      } else {
        _completeGoalSetup();
      }
    }
  }

  void _previousStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep) {
      case 1:
        return selectedCategory != null;
      case 2:
        return selectedGoalTemplate != null;
      case 3:
        return formKey.currentState?.validate() ?? false;
      case 4:
        return selectedDays.isNotEmpty;
      default:
        return true;
    }
  }

  void _completeGoalSetup() {
    // Show success animation and navigate to dashboard
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Goal Created Successfully!',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'You\'ve earned 25 coins for setting up your first goal! Ready to start your journey?',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'monetization_on',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  '+25 Coins Earned!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/dashboard-home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              minimumSize: Size(double.infinity, 6.h),
            ),
            child: Text(
              'Start My Journey',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _skipStep() {
    if (currentStep == 3) {
      // Skip custom details and use template data
      _nextStep();
    }
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 1:
        return _buildCategorySelection();
      case 2:
        return _buildGoalTemplateSelection();
      case 3:
        return _buildCustomGoalDetails();
      case 4:
        return _buildScheduleSelection();
      default:
        return Container();
    }
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Focus Area',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Select the category that aligns with your current priorities and goals.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategorySelectionCard(
                title: category['title'],
                iconName: category['iconName'],
                color: category['color'],
                isSelected: selectedCategory == category['title'],
                onTap: () {
                  setState(() {
                    selectedCategory = category['title'];
                    selectedGoalTemplate = null; // Reset template selection
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalTemplateSelection() {
    final templates = goalTemplates[selectedCategory] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$selectedCategory Goals',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Choose a goal template or customize your own in the next step.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: ListView.builder(
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return GoalTemplateCard(
                title: template['title'],
                description: template['description'],
                iconName: template['iconName'],
                coinReward: template['coinReward'],
                isSelected: selectedGoalTemplate == template['title'],
                onTap: () {
                  setState(() {
                    selectedGoalTemplate = template['title'];
                    // Pre-fill form with template data
                    goalTitleController.text = template['title'];
                    goalDescriptionController.text = template['description'];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomGoalDetails() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Your Goal',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Add personal details to make this goal truly yours. You can modify the template or create something completely new.',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomFormField(
                    label: 'Goal Title',
                    hintText: 'Enter a clear, specific goal title',
                    controller: goalTitleController,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Goal title is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Goal title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  CustomFormField(
                    label: 'Goal Description',
                    hintText: 'Describe what success looks like for this goal',
                    controller: goalDescriptionController,
                    maxLines: 3,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Goal description is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Please provide a more detailed description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  CustomFormField(
                    label: 'Target Value (Optional)',
                    hintText: 'e.g., 30 minutes, 5 times, \$500',
                    controller: targetValueController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lightbulb',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 6.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Tip: Specific, measurable goals are more likely to be achieved. You\'ll earn coins for each completed task!',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Your Schedule',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Choose which days you want to work on this goal. Consistency is key to building lasting habits.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ScheduleCalendarGrid(
                  selectedDays: selectedDays,
                  onDayToggle: (day) {
                    setState(() {
                      if (selectedDays.contains(day)) {
                        selectedDays.remove(day);
                      } else {
                        selectedDays.add(day);
                      }
                    });
                  },
                ),
                SizedBox(height: 4.h),
                if (selectedDays.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'event_available',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 6.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Your Schedule Summary',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'You\'ll work on "${goalTitleController.text}" on ${selectedDays.length} day${selectedDays.length > 1 ? 's' : ''} per week: ${selectedDays.join(', ')}',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: currentStep > 1
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
        title: Text(
          'Goal Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            child: ProgressIndicatorWidget(
              currentStep: currentStep,
              totalSteps: totalSteps,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildStepContent(),
                ),
              ),
            ),
          ),
          NavigationButtons(
            onBack: currentStep > 1 ? _previousStep : null,
            onNext: _nextStep,
            onSkip: currentStep == 3 ? _skipStep : null,
            nextButtonText: currentStep == totalSteps ? 'Create Goal' : 'Next',
            showSkip: currentStep == 3,
            isNextEnabled: _validateCurrentStep(),
          ),
        ],
      ),
    );
  }
}
