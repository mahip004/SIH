import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'water_availability_data.dart';
import 'rainfall_data.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double waterAvailable = 0.0;
  String suggestedStructure = "Calculating...";
  double tankCapacityLitres = 0.0;
  String costEstimation = "";
  int scarcityDays = 120;

  @override
  void initState() {
    super.initState();
    calculateWaterAvailability();
  }

  // Function to get nearest rainfall from available list
  double _nearestRainfall(double rainfallValue) {
    int nearestInt = WaterAvailability.rainfall.reduce(
          (a, b) => (a - rainfallValue).abs() < (b - rainfallValue).abs() ? a : b,
    );
    return nearestInt.toDouble(); // convert to double for WaterAvailability
  }

  Future<void> calculateWaterAvailability() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final roofArea = userProvider.roofArea; // double
    final roofType = userProvider.roofType.toLowerCase();
    final numberOfDwellers = userProvider.numberOfDwellers;
    final runoffCoefficient = userProvider.runoffCoefficient;

    // Tank capacity
    tankCapacityLitres = numberOfDwellers * scarcityDays * 10;

    // Get rainfall for state and nearest available value
    final state = userProvider.state;
    final rawRainfall = (stateRainfall[state] ?? 800).toDouble();
    final rainfall = _nearestRainfall(rawRainfall); // double

    // Calculate water availability
    if (roofType == "flat") {
      final value = WaterAvailability.getFlatAvailability(roofArea, rainfall);
      if (value != null) waterAvailable = value * 1000 * runoffCoefficient;
    } else if (roofType == "sloping") {
      final value = WaterAvailability.getSlopingAvailability(roofArea, rainfall);
      if (value != null) waterAvailable = value * 1000 * runoffCoefficient;
    }

    // Suggested structure
    if (waterAvailable >= tankCapacityLitres) {
      suggestedStructure = "Recharge Pit (enough collection)";
    } else if (waterAvailable >= tankCapacityLitres / 2) {
      suggestedStructure = "Recharge Trench (moderate collection)";
    } else {
      suggestedStructure = "Recharge Shaft (low collection)";
    }

    costEstimation =
    "Estimated cost: ₹${(tankCapacityLitres / 100).toStringAsFixed(0)} – ₹${(tankCapacityLitres / 80).toStringAsFixed(0)}\n"
        "Benefit: Can store ~${(tankCapacityLitres / 1000).toStringAsFixed(1)} KL of water";

    setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feasibility Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A66C2),
      ),
      body: suggestedStructure == "Calculating..."
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rainwater Harvesting Insights",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A66C2)),
              ),
              const SizedBox(height: 20),
              _buildInsightCard(
                icon: FontAwesomeIcons.houseChimney,
                title: "Suggested Structure",
                value: suggestedStructure,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.water,
                title: "Runoff Generation Capacity",
                value:
                "${waterAvailable.toStringAsFixed(0)} litres/year (with runoff coefficient)",
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.database,
                title: "Required Tank Capacity",
                value:
                "${tankCapacityLitres.toStringAsFixed(0)} litres (For ${userProvider.numberOfDwellers} persons, $scarcityDays days)",
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.coins,
                title: "Cost Estimation & Benefit",
                value: costEstimation,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.seedling,
                title: "Soil Type",
                value: userProvider.soilType,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.draftingCompass,
                title: "Sketch of Structure",
                value: "Proposed trench/recharge structure",
                imagePath: "assets/recharge_sketch.png",
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A66C2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(
      {required IconData icon,
        required String title,
        required String value,
        String? imagePath}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: const Color(0xFF0A66C2), size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(value,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imagePath, height: 160, fit: BoxFit.cover),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
