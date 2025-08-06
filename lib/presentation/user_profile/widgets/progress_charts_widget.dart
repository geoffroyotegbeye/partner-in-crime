import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressChartsWidget extends StatelessWidget {
  final Map<String, List<double>> progressData;
  final String selectedTimeframe;
  final Function(String) onTimeframeChanged;

  const ProgressChartsWidget({
    Key? key,
    required this.progressData,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Progress Charts',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              // Timeframe selector
              Container(
                padding: EdgeInsets.all(0.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.lightTheme.colorScheme.outline.withAlpha(77),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimeframeButton('Weekly', 'weekly'),
                    _buildTimeframeButton('Monthly', 'monthly'),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Line chart
          Container(
            height: 30.h,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedTimeframe == 'weekly'
                      ? 'Weekly Completion'
                      : 'Monthly Completion',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withAlpha(51),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withAlpha(153),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (selectedTimeframe == 'weekly') {
                                const days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun'
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < days.length) {
                                  return Text(
                                    days[value.toInt()],
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withAlpha(153),
                                    ),
                                  );
                                }
                              } else {
                                const months = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun'
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withAlpha(153),
                                    ),
                                  );
                                }
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getChartSpots(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.primaryColor,
                              AppTheme.lightTheme.primaryColor.withAlpha(179),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppTheme.lightTheme.primaryColor,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.lightTheme.primaryColor.withAlpha(77),
                                AppTheme.lightTheme.primaryColor.withAlpha(26),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Category breakdown
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Breakdown',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 20.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 8.w,
                            sections: _getPieChartSections(),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Legend
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Fitness', Colors.blue,
                            progressData['categories']![0]),
                        SizedBox(height: 1.h),
                        _buildLegendItem('Work', Colors.green,
                            progressData['categories']![1]),
                        SizedBox(height: 1.h),
                        _buildLegendItem('Learning', Colors.orange,
                            progressData['categories']![2]),
                        SizedBox(height: 1.h),
                        _buildLegendItem('Personal', Colors.purple,
                            progressData['categories']![3]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeButton(String label, String value) {
    final isSelected = selectedTimeframe == value;
    return GestureDetector(
      onTap: () => onTimeframeChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getChartSpots() {
    final data = progressData[selectedTimeframe] ?? [];
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  List<PieChartSectionData> _getPieChartSections() {
    final data = progressData['categories'] ?? [];
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final total = data.fold(0.0, (sum, value) => sum + value);

    return data.asMap().entries.map((entry) {
      final percentage = (entry.value / total * 100);
      return PieChartSectionData(
        value: entry.value,
        color: colors[entry.key],
        title: '${percentage.toInt()}%',
        radius: 8.w,
        titleStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem(String label, Color color, double value) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          '$label (${value.toInt()})',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
