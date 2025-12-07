import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyStepsChartWidget extends StatelessWidget {
  final List<int> weeklySteps;
  final double averageSteps;

  const WeeklyStepsChartWidget({
    super.key,
    required this.weeklySteps,
    required this.averageSteps,
  });

  @override
  Widget build(BuildContext context) {
    // Use current average as fallback if weekly data is empty
    final displaySteps = weeklySteps.every((s) => s == 0)
        ? List.generate(7, (i) => averageSteps.toInt())
        : weeklySteps;
    
    final maxSteps = displaySteps.isEmpty
        ? 10000.0
        : displaySteps.reduce((a, b) => a > b ? a : b).toDouble();
    final chartMax = maxSteps < 5000 ? 10000.0 : (maxSteps * 1.2).ceilToDouble().toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5FF), // Light purple background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.directions_walk,
                color: Color(0xFF87CEEB),
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AVERAGE STEPS',
                    style: TextStyle(
                      color: Color(0xFF87CEEB),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatNumber(averageSteps.toInt()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: chartMax,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${displaySteps[groupIndex]}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 2500 == 0 && value > 0) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Color(0xFF9B59B6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 50,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF9B59B6).withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  displaySteps.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: displaySteps[index].toDouble(),
                        color: const Color(0xFF87CEEB), // Light blue bars
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

