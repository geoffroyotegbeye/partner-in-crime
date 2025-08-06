import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/achievement_gallery_widget.dart';
import './widgets/animated_avatar_widget.dart';
import './widgets/floating_coin_counter_widget.dart';
import './widgets/progress_stats_panel_widget.dart';
import './widgets/world_map_widget.dart';

class ProgressVisualization extends StatefulWidget {
  const ProgressVisualization({Key? key}) : super(key: key);

  @override
  State<ProgressVisualization> createState() => _ProgressVisualizationState();
}

class _ProgressVisualizationState extends State<ProgressVisualization>
    with TickerProviderStateMixin {
  late AnimationController _environmentController;
  late AnimationController _coinController;
  late Animation<double> _coinAnimation;

  int currentLevel = 7;
  int experiencePoints = 2450;
  int totalCoins = 1247;
  bool _isStatsVisible = false;
  bool _isAchievementsVisible = false;

  final List<Map<String, dynamic>> milestones = [
    {
      'id': 1,
      'title': 'First Steps',
      'completed': true,
      'coins': 50,
      'date': '2024-07-15',
      'position': const Offset(0.2, 0.8),
    },
    {
      'id': 2,
      'title': 'Week Warrior',
      'completed': true,
      'coins': 100,
      'date': '2024-07-22',
      'position': const Offset(0.4, 0.6),
    },
    {
      'id': 3,
      'title': 'Mountain Climber',
      'completed': true,
      'coins': 150,
      'date': '2024-07-29',
      'position': const Offset(0.6, 0.4),
    },
    {
      'id': 4,
      'title': 'City Explorer',
      'completed': false,
      'coins': 200,
      'date': null,
      'position': const Offset(0.8, 0.2),
    },
  ];

  @override
  void initState() {
    super.initState();
    _environmentController =
        AnimationController(duration: const Duration(seconds: 20), vsync: this)
          ..repeat();

    _coinController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _coinAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _coinController, curve: Curves.elasticOut));

    _startCoinAnimation();
  }

  void _startCoinAnimation() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _coinController.forward().then((_) {
          if (mounted) {
            _coinController.reverse().then((_) {
              if (mounted) {
                Future.delayed(Duration(seconds: 5), _startCoinAnimation);
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _environmentController.dispose();
    _coinController.dispose();
    super.dispose();
  }

  String _getEnvironmentForLevel(int level) {
    if (level < 3) return 'forest';
    if (level < 6) return 'mountains';
    if (level < 10) return 'city';
    return 'futuristic';
  }

  Color _getEnvironmentColor(String environment) {
    switch (environment) {
      case 'forest':
        return Colors.green.shade100;
      case 'mountains':
        return Colors.blue.shade100;
      case 'city':
        return Colors.grey.shade200;
      case 'futuristic':
        return Colors.purple.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  void _showStatsPanel() {
    setState(() {
      _isStatsVisible = !_isStatsVisible;
    });
  }

  void _showAchievements() {
    setState(() {
      _isAchievementsVisible = !_isAchievementsVisible;
    });
  }

  void _onMilestoneTap(Map<String, dynamic> milestone) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text(milestone['title'],
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (milestone['completed']) ...[
                        Text('Completed on ${milestone['date']}',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                        const SizedBox(height: 8),
                        Row(children: [
                          CustomIconWidget(
                              iconName: 'coin',
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 16),
                          const SizedBox(width: 4),
                          Text('${milestone['coins']} coins earned',
                              style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ]),
                      ] else ...[
                        Text(
                            'Complete this milestone to earn ${milestone['coins']} coins!',
                            style: GoogleFonts.inter(fontSize: 14)),
                      ],
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close')),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final environment = _getEnvironmentForLevel(currentLevel);
    final environmentColor = _getEnvironmentColor(environment);

    return Scaffold(
        body: Stack(children: [
          // Background Environment
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                environmentColor,
                environmentColor.withValues(alpha: 0.3),
              ]))),

          // World Map
          WorldMapWidget(
              environment: environment,
              animationController: _environmentController,
              milestones: milestones,
              currentLevel: currentLevel,
              onMilestoneTap: _onMilestoneTap),

          // Floating Coin Counter
          Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: AnimatedBuilder(
                  animation: _coinAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: _coinAnimation.value,
                        child: FloatingCoinCounterWidget(
                            coinCount: totalCoins,
                            onTap: () {
                              // Handle coin counter tap
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Total coins: $totalCoins'),
                                      duration: Duration(seconds: 2)));
                            }));
                  })),

          // Animated Avatar
          Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 30,
              top: MediaQuery.of(context).size.height * 0.6,
              child: AnimatedAvatarWidget(
                  level: currentLevel,
                  experience: experiencePoints,
                  isMoving: _environmentController.isAnimating)),

          // Navigation Controls
          Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12)),
                      child:
                          CustomIconWidget(iconName: 'arrow_back', size: 20)))),

          // Bottom Action Buttons
          Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                        icon: Icons.bar_chart,
                        label: 'Stats',
                        onTap: _showStatsPanel,
                        isActive: _isStatsVisible),
                    _buildActionButton(
                        icon: Icons.emoji_events,
                        label: 'Achievements',
                        onTap: _showAchievements,
                        isActive: _isAchievementsVisible),
                    _buildActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: () {
                          // Handle share
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Progress shared successfully!'),
                              duration: Duration(seconds: 2)));
                        }),
                  ])),

          // Progress Stats Panel
          if (_isStatsVisible)
            ProgressStatsPanelWidget(
                onClose: () => setState(() => _isStatsVisible = false),
                totalTasks: 156,
                currentStreak: 7,
                weeklyAverage: 4.2,
                categoryBreakdown: {
                  'Fitness': 45,
                  'Learning': 38,
                  'Work': 42,
                  'Personal': 31,
                }),

          // Achievement Gallery
          if (_isAchievementsVisible)
            AchievementGalleryWidget(
                onClose: () => setState(() => _isAchievementsVisible = false),
                achievements: [
                  {
                    'title': 'Early Bird',
                    'description': 'Complete 5 morning tasks',
                    'rarity': 'common',
                    'earned': true,
                    'date': '2024-07-20',
                  },
                  {
                    'title': 'Streak Master',
                    'description': '7-day completion streak',
                    'rarity': 'rare',
                    'earned': true,
                    'date': '2024-07-25',
                  },
                  {
                    'title': 'Legend',
                    'description': 'Complete 100 total tasks',
                    'rarity': 'legendary',
                    'earned': false,
                    'date': null,
                  },
                ]),

          // Weather Effects (subtle particles)
          if (environment == 'mountains')
            Positioned.fill(
                child: IgnorePointer(
                    child: AnimatedBuilder(
                        animation: _environmentController,
                        builder: (context, child) {
                          return CustomPaint(
                              painter:
                                  SnowPainter(_environmentController.value));
                        }))),
        ]),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
          selectedItemColor: AppTheme.lightTheme.primaryColor,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'task_alt',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'trending_up',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'store',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboardHome,
                  (route) => false,
                );
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.taskManagement);
                break;
              case 2:
                // Already on progress visualization
                break;
              case 3:
                Navigator.pushNamed(context, AppRoutes.marketplace);
                break;
              case 4:
                Navigator.pushNamed(context, AppRoutes.userProfile);
                break;
            }
          },
        ));
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CustomIconWidget(
                  iconName: 'stats',
                  color: isActive
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                  size: 24),
              const SizedBox(height: 4),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary)),
            ])));
  }
}

// Custom painter for snow effect in mountains environment
class SnowPainter extends CustomPainter {
  final double animationValue;

  SnowPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (i * 50 + animationValue * 100) % size.width;
      final y = (i * 80 + animationValue * 200) % size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
