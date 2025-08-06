import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../widgets/custom_icon_widget.dart';
import './milestone_node_widget.dart';

class WorldMapWidget extends StatelessWidget {
  final String environment;
  final AnimationController animationController;
  final List<Map<String, dynamic>> milestones;
  final int currentLevel;
  final Function(Map<String, dynamic>) onMilestoneTap;

  const WorldMapWidget({
    Key? key,
    required this.environment,
    required this.animationController,
    required this.milestones,
    required this.currentLevel,
    required this.onMilestoneTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
          // Parallax Background Elements
          AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Stack(children: [
                  // Background Layer (slowest)
                  _buildBackgroundLayer(context, 0.1),
                  // Middle Layer
                  _buildMiddleLayer(context, 0.3),
                  // Foreground Layer (fastest)
                  _buildForegroundLayer(context, 0.5),
                  // Path between milestones
                  _buildMilestonePath(context),
                  // Milestone nodes
                  ...milestones.map((milestone) => Positioned(
                      left: MediaQuery.of(context).size.width *
                              milestone['position'].dx -
                          25,
                      top: MediaQuery.of(context).size.height *
                              milestone['position'].dy -
                          25,
                      child: MilestoneNodeWidget(
                          milestone: milestone,
                          onTap: () => onMilestoneTap(milestone)))),
                  // Scattered coins for interaction
                  ..._buildScatteredCoins(context),
                ]);
              }),
        ]));
  }

  Widget _buildBackgroundLayer(BuildContext context, double parallaxFactor) {
    final offset = animationController.value * parallaxFactor * 100;

    switch (environment) {
      case 'forest':
        return _buildForestBackground(context, offset);
      case 'mountains':
        return _buildMountainBackground(context, offset);
      case 'city':
        return _buildCityBackground(context, offset);
      case 'futuristic':
        return _buildFuturisticBackground(context, offset);
      default:
        return _buildForestBackground(context, offset);
    }
  }

  Widget _buildForestBackground(BuildContext context, double offset) {
    return Positioned.fill(
        child: CustomPaint(painter: ForestBackgroundPainter(offset)));
  }

  Widget _buildMountainBackground(BuildContext context, double offset) {
    return Positioned.fill(
        child: CustomPaint(painter: MountainBackgroundPainter(offset)));
  }

  Widget _buildCityBackground(BuildContext context, double offset) {
    return Positioned.fill(
        child: CustomPaint(painter: CityBackgroundPainter(offset)));
  }

  Widget _buildFuturisticBackground(BuildContext context, double offset) {
    return Positioned.fill(
        child: CustomPaint(painter: FuturisticBackgroundPainter(offset)));
  }

  Widget _buildMiddleLayer(BuildContext context, double parallaxFactor) {
    final offset = animationController.value * parallaxFactor * 50;

    return Positioned.fill(
        child: CustomPaint(painter: MiddleLayerPainter(environment, offset)));
  }

  Widget _buildForegroundLayer(BuildContext context, double parallaxFactor) {
    final offset = animationController.value * parallaxFactor * 25;

    return Positioned.fill(
        child:
            CustomPaint(painter: ForegroundLayerPainter(environment, offset)));
  }

  Widget _buildMilestonePath(BuildContext context) {
    return Positioned.fill(
        child: CustomPaint(painter: MilestonePathPainter(milestones)));
  }

  List<Widget> _buildScatteredCoins(BuildContext context) {
    final List<Widget> coins = [];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Generate some scattered coins for interaction
    for (int i = 0; i < 8; i++) {
      final x = (i * 123 + 50) % screenWidth;
      final y = (i * 87 + 100) % screenHeight;

      coins.add(Positioned(
          left: x.toDouble(),
          top: y.toDouble(),
          child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final bounceOffset =
                    math.sin((animationController.value * 2 * math.pi) + i) * 5;
                return Transform.translate(
                    offset: Offset(0, bounceOffset),
                    child: GestureDetector(
                        onTap: () {
                          // Simulate coin collection
                        },
                        child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.amber.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      spreadRadius: 1),
                                ]),
                            child: CustomIconWidget(
                                iconName: 'coin',
                                size: 14, color: Colors.white))));
              })));
    }

    return coins;
  }
}

// Custom painters for different environments
class ForestBackgroundPainter extends CustomPainter {
  final double offset;

  ForestBackgroundPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw trees
    paint.color = Colors.green.shade700;
    for (int i = 0; i < 15; i++) {
      final x = (i * 80 + offset) % (size.width + 100);
      final height = 60.0 + (i % 3) * 20.0;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(x - 15, size.height - height, 30.0, height),
              const Radius.circular(15)),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MountainBackgroundPainter extends CustomPainter {
  final double offset;

  MountainBackgroundPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw mountain silhouettes
    paint.color = Colors.blue.shade300.withValues(alpha: 0.7);
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final x = (i * 200 + offset * 0.5) % (size.width + 200);
      path.moveTo(x, size.height);
      path.lineTo(x + 50, size.height - 150);
      path.lineTo(x + 100, size.height - 200);
      path.lineTo(x + 150, size.height - 120);
      path.lineTo(x + 200, size.height);
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CityBackgroundPainter extends CustomPainter {
  final double offset;

  CityBackgroundPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw city buildings
    paint.color = Colors.grey.shade400;
    for (int i = 0; i < 10; i++) {
      final x = (i * 120 + offset * 0.3) % (size.width + 150);
      final height = 100.0 + (i % 4) * 50.0;
      canvas.drawRect(
          Rect.fromLTWH(x, size.height - height, 100.0, height), paint);

      // Windows
      paint.color = Colors.yellow.shade300;
      for (int j = 0; j < 3; j++) {
        for (int k = 0; k < 5; k++) {
          canvas.drawRect(
              Rect.fromLTWH(
                  x + 10 + j * 25, size.height - height + 20 + k * 15, 15, 10),
              paint);
        }
      }
      paint.color = Colors.grey.shade400;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FuturisticBackgroundPainter extends CustomPainter {
  final double offset;

  FuturisticBackgroundPainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw futuristic structures
    paint.color = Colors.purple.shade400.withValues(alpha: 0.6);
    for (int i = 0; i < 8; i++) {
      final x = (i * 150 + offset * 0.2) % (size.width + 200);
      final height = 120 + (i % 3) * 40;

      // Futuristic spires
      final path = Path();
      path.moveTo(x + 30, size.height);
      path.lineTo(x + 10, size.height - height);
      path.lineTo(x + 50, size.height - height - 30);
      path.lineTo(x + 90, size.height - height);
      path.lineTo(x + 70, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MiddleLayerPainter extends CustomPainter {
  final String environment;
  final double offset;

  MiddleLayerPainter(this.environment, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    // Add middle layer elements based on environment
    switch (environment) {
      case 'forest':
        _paintForestMiddle(canvas, size);
        break;
      case 'mountains':
        _paintMountainMiddle(canvas, size);
        break;
      case 'city':
        _paintCityMiddle(canvas, size);
        break;
      case 'futuristic':
        _paintFuturisticMiddle(canvas, size);
        break;
    }
  }

  void _paintForestMiddle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade500
      ..style = PaintingStyle.fill;

    // Bushes and shrubs
    for (int i = 0; i < 10; i++) {
      final x = (i * 100 + offset) % (size.width + 120);
      canvas.drawOval(Rect.fromLTWH(x, size.height - 40, 60, 30), paint);
    }
  }

  void _paintMountainMiddle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    // Rocky outcrops
    for (int i = 0; i < 6; i++) {
      final x = (i * 180 + offset) % (size.width + 200);
      canvas.drawOval(Rect.fromLTWH(x, size.height - 60, 80, 40), paint);
    }
  }

  void _paintCityMiddle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    // Street elements
    for (int i = 0; i < 8; i++) {
      final x = (i * 140 + offset) % (size.width + 160);
      canvas.drawRect(Rect.fromLTWH(x, size.height - 20, 80, 15), paint);
    }
  }

  void _paintFuturisticMiddle(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan.shade300.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Floating platforms
    for (int i = 0; i < 5; i++) {
      final x = (i * 200 + offset) % (size.width + 240);
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height - 80, 120, 15),
              const Radius.circular(8)),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ForegroundLayerPainter extends CustomPainter {
  final String environment;
  final double offset;

  ForegroundLayerPainter(this.environment, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    // Add foreground elements with fastest parallax
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MilestonePathPainter extends CustomPainter {
  final List<Map<String, dynamic>> milestones;

  MilestonePathPainter(this.milestones);

  @override
  void paint(Canvas canvas, Size size) {
    if (milestones.length < 2) return;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Draw winding path between milestones
    for (int i = 0; i < milestones.length - 1; i++) {
      final currentPos = milestones[i]['position'] as Offset;
      final nextPos = milestones[i + 1]['position'] as Offset;

      final currentPoint =
          Offset(size.width * currentPos.dx, size.height * currentPos.dy);
      final nextPoint =
          Offset(size.width * nextPos.dx, size.height * nextPos.dy);

      if (i == 0) {
        path.moveTo(currentPoint.dx, currentPoint.dy);
      }

      // Create curved path
      final controlPoint1 = Offset(
          currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.3,
          currentPoint.dy - 50);
      final controlPoint2 = Offset(
          currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.7,
          nextPoint.dy - 50);

      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, nextPoint.dx, nextPoint.dy);
    }

    canvas.drawPath(path, paint);

    // Draw dashed line for incomplete sections
    final incompletePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Add dashed pattern for future path
    for (int i = 0; i < milestones.length; i++) {
      if (!milestones[i]['completed']) {
        final pos = milestones[i]['position'] as Offset;
        final point = Offset(size.width * pos.dx, size.height * pos.dy);

        // Draw dashed circle around incomplete milestone
        canvas.drawCircle(point, 35, incompletePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}