import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../helpers/location_helper.dart'; // ✅ import your location helper

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  List<double> rainfall = [];
  List<String> days = [];
  bool isLoading = true;

  final int checkedFeasibilityCount = 120;
  final int adoptedHarvestingCount = 35;

  // --- Replace with your Visual Crossing API key ---
  final String apiKey = 'RWV2WZCCLJYBSLMAH7KFGZN5C';

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _initLocationAndFetch();
  }

  Future<void> _initLocationAndFetch() async {
    final loc = await LocationHelper.getSavedLocation(); // get saved location
    setState(() {
      latitude = loc?.latitude ?? 28.6139; // fallback
      longitude = loc?.longitude ?? 77.2090;
    });
    await fetchRainfallData();
  }

  Future<void> fetchRainfallData() async {
    if (latitude == null || longitude == null) return;

    try {
      final uri = Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$latitude,$longitude/last7days?unitGroup=metric&include=days&key=$apiKey&contentType=json');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> daysData = data['days'];
        List<double> rainfallTemp = [];
        List<String> daysTemp = [];

        for (var day in daysData) {
          rainfallTemp.add((day['precip'] as num).toDouble());
          daysTemp.add(DateTime.parse(day['datetime']).weekdayName());
        }

        setState(() {
          rainfall = rainfallTemp;
          days = daysTemp;
          isLoading = false;
        });
      } else {
        debugPrint('Failed to fetch rainfall data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching rainfall data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Insights"),
        backgroundColor: const Color(0xFF0A66C2),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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

extension WeekdayName on DateTime {
  String weekdayName() {
    const names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return names[this.weekday - 1];
  }
}
