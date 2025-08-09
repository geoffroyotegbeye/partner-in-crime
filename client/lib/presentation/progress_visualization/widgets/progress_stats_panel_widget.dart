import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProgressStatsPanelWidget extends StatefulWidget {
  final VoidCallback onClose;
  final int totalTasks;
  final int currentStreak;
  final double weeklyAverage;
  final Map<String, int> categoryBreakdown;

  const ProgressStatsPanelWidget({
    Key? key,
    required this.onClose,
    required this.totalTasks,
    required this.currentStreak,
    required this.weeklyAverage,
    required this.categoryBreakdown,
  }) : super(key: key);

  @override
  State<ProgressStatsPanelWidget> createState() =>
      _ProgressStatsPanelWidgetState();
}

class _ProgressStatsPanelWidgetState extends State<ProgressStatsPanelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                  offset: Offset(
                      0,
                      MediaQuery.of(context).size.height *
                          0.6 *
                          _slideAnimation.value),
                  child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, -5)),
                              ]),
                          child: Column(children: [
                            // Handle bar
                            Container(
                                margin: const EdgeInsets.only(top: 12),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(2))),

                            // Header
                            Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Progress Statistics',
                                          style: GoogleFonts.inter(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                      IconButton(
                                          onPressed: _handleClose,
                                          icon: CustomIconWidget(
                                              iconName: 'close',
                                              size: 24,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface)),
                                    ])),

                            // Stats content
                            Expanded(
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Key metrics row
                                          Row(children: [
                                            Expanded(
                                                child: _buildStatCard(
                                                    title: 'Total Tasks',
                                                    value: widget.totalTasks
                                                        .toString(),
                                                    icon: Icons.task_alt,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary)),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: _buildStatCard(
                                                    title: 'Current Streak',
                                                    value:
                                                        '${widget.currentStreak} days',
                                                    icon: Icons
                                                        .local_fire_department,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary)),
                                          ]),
                                          const SizedBox(height: 16),

                                          // Weekly average card
                                          _buildStatCard(
                                              title: 'Weekly Average',
                                              value:
                                                  '${widget.weeklyAverage.toStringAsFixed(1)} tasks/day',
                                              icon: Icons.trending_up,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              isFullWidth: true),
                                          const SizedBox(height: 24),

                                          // Category breakdown title
                                          Text('Category Breakdown',
                                              style: GoogleFonts.inter(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface)),
                                          const SizedBox(height: 16),

                                          // Pie chart
                                          SizedBox(
                                              height: 200,
                                              child: PieChart(PieChartData(
                                                  sections:
                                                      _buildPieChartSections(),
                                                  centerSpaceRadius: 40,
                                                  sectionsSpace: 2))),
                                          const SizedBox(height: 16),

                                          // Legend
                                          _buildLegend(),
                                          const SizedBox(height: 24),
                                        ]))),
                          ])))));
        });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: CustomIconWidget(iconName: icon.toString(), size: 20, color: color)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)))),
          ]),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.w700, color: color)),
        ]));
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Colors.purple.shade400,
    ];

    final total = widget.categoryBreakdown.values.reduce((a, b) => a + b);

    return widget.categoryBreakdown.entries.map((entry) {
      final index = widget.categoryBreakdown.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / total * 100);

      return PieChartSectionData(
          value: entry.value.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          color: colors[index % colors.length],
          radius: 60,
          titleStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white));
    }).toList();
  }

  Widget _buildLegend() {
    final List<Color> colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
      Colors.purple.shade400,
    ];

    return Column(
        children: widget.categoryBreakdown.entries.map((entry) {
      final index = widget.categoryBreakdown.keys.toList().indexOf(entry.key);
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 12),
            Expanded(
                child: Text(entry.key,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface))),
            Text('${entry.value} tasks',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors[index % colors.length])),
          ]));
    }).toList());
  }
}