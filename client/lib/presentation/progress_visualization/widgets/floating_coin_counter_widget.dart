import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class FloatingCoinCounterWidget extends StatefulWidget {
  final int coinCount;
  final VoidCallback? onTap;

  const FloatingCoinCounterWidget({
    Key? key,
    required this.coinCount,
    this.onTap,
  }) : super(key: key);

  @override
  State<FloatingCoinCounterWidget> createState() =>
      _FloatingCoinCounterWidgetState();
}

class _FloatingCoinCounterWidgetState extends State<FloatingCoinCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _shimmerController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));

    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.8),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2)),
                ]),
            child: Stack(children: [
              // Shimmer effect
              AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                                    stops: const [
                              0.0,
                              0.5,
                              1.0
                            ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    transform: GradientRotation(
                                        _shimmerAnimation.value)))));
                  }),

              // Coin counter content
              Row(mainAxisSize: MainAxisSize.min, children: [
                CustomIconWidget(iconName: 'coin', size: 20, color: Colors.white),
                const SizedBox(width: 6),
                Text(_formatCoinCount(widget.coinCount),
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ]),
            ])));
  }

  String _formatCoinCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}