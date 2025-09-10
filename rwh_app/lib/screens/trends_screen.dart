import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Dummy data ---
    final List<double> rainfall = [12, 25, 8, 18, 22, 15, 10]; // mm/day
    final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    final int checkedFeasibilityCount = 120;
    final int adoptedHarvestingCount = 35;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Insights"),
        backgroundColor: const Color(0xFF0A66C2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Weekly Rainfall Trends",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A66C2),
              ),
            ),
            const SizedBox(height: 20),

            // --- Line Chart ---
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 5,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 5,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < days.length) {
                            return Text(
                              days[index],
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 12),
                            );
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                          rainfall.length,
                              (i) => FlSpot(i.toDouble(), rainfall[i])),
                      isCurved: false,
                      color: const Color(0xFF0A66C2),
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 5,
                              color: Colors.white,
                              strokeColor: const Color(0xFF0A66C2),
                              strokeWidth: 3,
                            ),
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- Stats stacked vertically ---
            _buildStatCard(
              icon: FontAwesomeIcons.checkCircle,
              color: const Color(0xFF0A66C2),
              title: "Checked Feasibility",
              value: checkedFeasibilityCount.toString(),
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              icon: FontAwesomeIcons.water,
              color: Colors.green.shade700,
              title: "Adopted Harvesting",
              value: adoptedHarvestingCount.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(value,
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
