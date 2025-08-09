import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class AnimatedAvatarWidget extends StatefulWidget {
  final int level;
  final int experience;
  final bool isMoving;

  const AnimatedAvatarWidget({
    Key? key,
    required this.level,
    required this.experience,
    required this.isMoving,
  }) : super(key: key);

  @override
  State<AnimatedAvatarWidget> createState() => _AnimatedAvatarWidgetState();
}

class _AnimatedAvatarWidgetState extends State<AnimatedAvatarWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _levelController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _levelPulseAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _levelController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _bounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
        CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut));

    _levelPulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _levelController, curve: Curves.easeInOut));

    if (widget.isMoving) {
      _bounceController.repeat(reverse: true);
    }

    _levelController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimatedAvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isMoving && !_bounceController.isAnimating) {
      _bounceController.repeat(reverse: true);
    } else if (!widget.isMoving && _bounceController.isAnimating) {
      _bounceController.stop();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  Color _getAvatarColorForLevel(int level) {
    if (level < 3) return Colors.green.shade600;
    if (level < 6) return Colors.blue.shade600;
    if (level < 10) return Colors.purple.shade600;
    return Colors.orange.shade600;
  }

  int _getExperienceForNextLevel() {
    return (widget.level + 1) * 500; // Simple leveling system
  }

  double _getExperienceProgress() {
    final currentLevelExp = widget.level * 500;
    final nextLevelExp = _getExperienceForNextLevel();
    final progressExp = widget.experience - currentLevelExp;
    final requiredExp = nextLevelExp - currentLevelExp;

    return math.max(0.0, math.min(1.0, progressExp / requiredExp));
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _getAvatarColorForLevel(widget.level);
    final experienceProgress = _getExperienceProgress();

    return AnimatedBuilder(
        animation: Listenable.merge([_bounceAnimation, _levelPulseAnimation]),
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Level indicator
                Transform.scale(
                    scale: _levelPulseAnimation.value,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1),
                            ]),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.star, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('LV ${widget.level}',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ]))),
                const SizedBox(height: 8),

                // Avatar with experience ring
                Stack(alignment: Alignment.center, children: [
                  // Experience progress ring
                  SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                          value: experienceProgress,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.tertiary))),

                  // Avatar circle
                  Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: avatarColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: avatarColor.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 2),
                          ]),
                      child: Center(
                          child: Icon(_getAvatarIconForLevel(widget.level), size: 30, color: Colors.white))),

                  // Movement indicator (small particles)
                  if (widget.isMoving) ...[
                    Positioned(
                        left: -5, top: 10, child: _buildMovementParticle(0)),
                    Positioned(
                        right: -3, top: 15, child: _buildMovementParticle(1)),
                    Positioned(
                        left: 5, bottom: 10, child: _buildMovementParticle(2)),
                  ],
                ]),
                const SizedBox(height: 8),

                // Experience points
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withValues(alpha: 0.3),
                            width: 1)),
                    child: Text('${widget.experience} XP',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.tertiary))),
              ]));
        });
  }

  IconData _getAvatarIconForLevel(int level) {
    if (level < 3) return Icons.person;
    if (level < 6) return Icons.hiking;
    if (level < 10) return Icons.business;
    return Icons.rocket;
  }

  Widget _buildMovementParticle(int index) {
    return AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final offset =
              math.sin(_bounceController.value * 2 * math.pi + index) * 3;
          return Transform.translate(
              offset: Offset(offset, offset * 0.5),
              child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(2))));
        });
  }
}