import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_icon_widget.dart';

class MilestoneNodeWidget extends StatefulWidget {
  final Map<String, dynamic> milestone;
  final VoidCallback onTap;

  const MilestoneNodeWidget({
    Key? key,
    required this.milestone,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MilestoneNodeWidget> createState() => _MilestoneNodeWidgetState();
}

class _MilestoneNodeWidgetState extends State<MilestoneNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Only pulse if milestone is completed and glowing
    if (widget.milestone['completed']) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.milestone['completed'] as bool;

    return GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                  scale: _isHovered ? 1.1 : 1.0,
                  child: Stack(alignment: Alignment.center, children: [
                    // Outer glow effect for completed milestones
                    if (isCompleted)
                      Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withValues(alpha: 0.5),
                                        blurRadius: 20,
                                        spreadRadius: 2),
                                  ]))),

                    // Main milestone circle
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: isCompleted
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: isCompleted
                                    ? Colors.white
                                    : Colors.grey.shade400,
                                width: 3),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2)),
                            ]),
                        child: Center(
                            child: isCompleted
                                ? CustomIconWidget(
                                    iconName: 'check', size: 24, color: Colors.white)
                                : CustomIconWidget(
                                    iconName: 'milestone', size: 20, color: Colors.grey.shade600))),

                    // Coin indicator for completed milestones
                    if (isCompleted)
                      Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                        iconName: 'coin', size: 12, color: Colors.white),
                                    const SizedBox(width: 2),
                                    Text('${widget.milestone['coins']}',
                                        style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ]))),

                    // Milestone title tooltip
                    Positioned(
                        bottom: -30,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(widget.milestone['title'],
                                style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                                textAlign: TextAlign.center))),
                  ]));
            }));
  }
}