import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class AchievementGalleryWidget extends StatefulWidget {
  final VoidCallback onClose;
  final List<Map<String, dynamic>> achievements;

  const AchievementGalleryWidget({
    Key? key,
    required this.onClose,
    required this.achievements,
  }) : super(key: key);

  @override
  State<AchievementGalleryWidget> createState() =>
      _AchievementGalleryWidgetState();
}

class _AchievementGalleryWidgetState extends State<AchievementGalleryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleClose() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return Colors.grey.shade600;
      case 'rare':
        return Colors.blue.shade600;
      case 'epic':
        return Colors.purple.shade600;
      case 'legendary':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getRarityIcon(String rarity) {
    switch (rarity) {
      case 'common':
        return Icons.circle;
      case 'rare':
        return Icons.hexagon;
      case 'epic':
        return Icons.star;
      case 'legendary':
        return Icons.diamond;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                  offset: Offset(
                      MediaQuery.of(context).size.width * _slideAnimation.value,
                      0),
                  child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: SafeArea(
                              child: Column(children: [
                            // Header
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(children: [
                                  IconButton(
                                      onPressed: _handleClose,
                                      icon: CustomIconWidget(
                                          iconName: 'arrow_back',
                                          size: 24,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                  const SizedBox(width: 8),
                                  Text('Achievement Gallery',
                                      style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface)),
                                ])),

                            // Achievements grid
                            Expanded(
                                child: GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            childAspectRatio: 0.8),
                                    itemCount: widget.achievements.length,
                                    itemBuilder: (context, index) {
                                      final achievement =
                                          widget.achievements[index];
                                      return _buildAchievementCard(achievement);
                                    })),
                          ]))))));
        });
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isEarned = achievement['earned'] as bool;
    final rarity = achievement['rarity'] as String;
    final rarityColor = _getRarityColor(rarity);
    final rarityIcon = _getRarityIcon(rarity);

    return Container(
        decoration: BoxDecoration(
            color: isEarned
                ? rarityColor.withValues(alpha: 0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isEarned
                    ? rarityColor.withValues(alpha: 0.3)
                    : Colors.grey.shade300,
                width: 2),
            boxShadow: isEarned
                ? [
                    BoxShadow(
                        color: rarityColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1),
                  ]
                : null),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Achievement icon with rarity indicator
              Stack(alignment: Alignment.center, children: [
                Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: isEarned
                            ? rarityColor.withValues(alpha: 0.2)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                        child: CustomIconWidget(
                            iconName: 'trophy',
                            size: 40,
                            color: isEarned
                                ? rarityColor
                                : Colors.grey.shade400))),
                if (!isEarned)
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(40)),
                      child: CustomIconWidget(iconName: 'lock', size: 24, color: Colors.white)),
              ]),
              const SizedBox(height: 12),

              // Achievement title
              Text(achievement['title'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isEarned
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey.shade500)),
              const SizedBox(height: 8),

              // Achievement description
              Text(achievement['description'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isEarned
                          ? Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7)
                          : Colors.grey.shade400),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),

              // Rarity badge
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(rarity.toUpperCase(),
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: rarityColor,
                          letterSpacing: 0.5))),

              // Earning date
              if (isEarned && achievement['date'] != null) ...[
                const SizedBox(height: 8),
                Text('Earned ${achievement['date']}',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500)),
              ],
            ])));
  }
}