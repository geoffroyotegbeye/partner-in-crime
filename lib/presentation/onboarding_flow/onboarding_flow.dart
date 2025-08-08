import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../registration_screen/registration_screen.dart';
import './widgets/animated_coin_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

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

  // Données d'onboarding traduites en français avec SVG locaux
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Transformez vos Tâches en Récompenses !",
      "description":
          "Complétez des tâches quotidiennes et gagnez des MotiCoins. Chaque réussite vous rapproche du déblocage de contenus et récompenses exceptionnels.",
      "svgAsset": "assets/images/personal goals checklist-rafiki.svg",
      "showAnimation": true,
      "type": "intro"
    },
    {
      "title": "Regardez Votre Monde Virtuel Grandir !",
      "description":
          "En accomplissant vos tâches, observez votre environnement virtuel personnalisé évoluer. Construisez des villes, développez des îles, ou agrandissez votre espace de travail !",
      "svgAsset": "assets/images/Personal goals-amico.svg",
      "showAnimation": false,
      "type": "progress"
    },
    {
      "title": "Débloquez du Contenu Exceptionnel !",
      "description":
          "Utilisez vos MotiCoins pour accéder à des ebooks premium, des cours, des sessions de coaching et des podcasts exclusifs d'experts reconnus.",
      "svgAsset": "assets/images/Team goals-rafiki.svg",
      "showAnimation": false,
      "type": "marketplace"
    },
    {
      "title": "Suivez Votre Parcours de Réussite",
      "description":
          "Surveillez votre progression dans plusieurs catégories de vie avec de belles visualisations et célébrez chaque étape importante de votre réussite.",
      "svgAsset": "assets/images/personal growth-cuate.svg",
      "showAnimation": false,
      "type": "tracking"
    },
    {
      "title": "Rejoignez la Communauté !",
      "description":
          "Connectez-vous avec des personnes partageant les mêmes idées, participez à des défis et partagez vos réussites avec des partenaires de responsabilité.",
      "svgAsset": "assets/images/Shared goals-rafiki.svg",
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
    // Afficher un feedback visuel pour confirmer que le bouton a été pressé
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers l\'inscription...'),
        duration: Duration(milliseconds: 500),
      ),
    );
    
    // Ajouter un feedback haptique
    HapticFeedback.mediumImpact();
    
    // Navigation vers l'écran d'inscription avant la configuration des objectifs
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  void _navigateToGoalSetup() {
    // Utiliser exactement la même approche que _skipOnboarding pour cohérence
    // Feedback visuel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers l\'inscription...'),
        duration: Duration(milliseconds: 500),
      ),
    );
    
    // Feedback haptique
    HapticFeedback.mediumImpact();
    
    // Navigation vers l'écran d'inscription avant la configuration des objectifs
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
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
          top: 16.h, // Repositionné plus bas
          right: 10.w, // Repositionné à droite au lieu de gauche
          child: AnimatedCoinWidget(onTap: _onCoinTap),
        );
      case "tracking":
        return Positioned(
          top: 12.h,
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
                  'Niveau 5',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Completé',
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Passer',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 4.w,
                        ),
                      ],
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
                    svgAsset: data["svgAsset"],
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
                            width: 25.w, // Augmenté de 20.w à 25.w pour plus d'espace
                            child: _currentPage > 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppTheme.lightTheme.colorScheme.surface.withOpacity(0.8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.lightTheme.colorScheme.shadow.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        _pageController.previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h), // Réduit de 3.w à 2.w
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'arrow_back_ios',
                                            color: AppTheme
                                                .lightTheme.colorScheme.primary,
                                            size: 3.5.w, // Légèrement réduit de 4.w à 3.5.w
                                          ),
                                          SizedBox(width: 0.5.w), // Réduit de 1.w à 0.5.w
                                          Flexible( // Ajout de Flexible pour permettre au texte de s'adapter
                                            child: Text(
                                              'Retour',
                                              overflow: TextOverflow.ellipsis, // Ajoute une ellipse si le texte est trop long
                                              style: AppTheme
                                                  .lightTheme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: AppTheme
                                                    .lightTheme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.2, // Réduit de 0.5 à 0.2
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : null,
                          ),

                          // Next/Get Started Button
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Réduit de 25 à 20 pour correspondre au bouton Retour
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary,
                                  AppTheme.lightTheme.colorScheme.primary.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.2), // Réduit de 0.3 à 0.2
                                  blurRadius: 10, // Réduit de 15 à 10
                                  spreadRadius: 1, // Réduit de 2 à 1
                                  offset: const Offset(0, 3), // Réduit de 5 à 3
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.h), // Réduit pour correspondre au bouton Retour
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20), // Réduit de 25 à 20 pour correspondre au bouton Retour
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu
                                children: [
                                  Flexible( // Ajout de Flexible pour permettre au texte de s'adapter
                                    child: Text(
                                      _currentPage == _totalPages - 1
                                          ? 'Commencer'
                                          : 'Suivant',
                                      overflow: TextOverflow.ellipsis, // Ajoute une ellipse si le texte est trop long
                                      style: AppTheme.lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2, // Réduit de 0.5 à 0.3
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.5.w), // Réduit de 2.w à 1.5.w
                                  CustomIconWidget(
                                    iconName: _currentPage == _totalPages - 1
                                        ? 'rocket_launch'
                                        : 'arrow_forward_ios',
                                    color: Colors.white,
                                    size: 3.5.w, // Légèrement réduit de 4.w à 3.5.w
                                  ),
                                ],
                              ),
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
