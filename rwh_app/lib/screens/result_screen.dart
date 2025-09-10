import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    // --- Calculations ---
    double runoffPotential = user.roofArea * 0.8 * 1; // in m³
    String suggestedStructure = user.openSpace >= 10
        ? "Recharge Pit"
        : (user.openSpace >= 5 ? "Recharge Trench" : "Recharge Shaft");

    double dailyWaterPerDweller = 135; // liters per person per day
    double totalDaysSupport = (runoffPotential * 1000) /
        (user.numberOfDwellers * dailyWaterPerDweller);

    // Dummy values for now
    String recommendedMaterial = "Concrete / Smooth Tiles (better runoff)";
    String principalAquifers = "Alluvium aquifer system (unconfined)";
    String groundwaterDepth = "Approx. 20–30 m (varies by location)";
    String runoffCapacity =
        "${(runoffPotential * 1000).toStringAsFixed(0)} liters per year";
    String costEstimation =
        "Estimated cost: ₹50,000 – ₹75,000 \nBenefit: Saves ~${(totalDaysSupport / 30).toStringAsFixed(1)} months of water supply";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feasibility Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A66C2), // LinkedIn Blue
      ),
      body: Container(
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

              // --- Insights Cards ---
              _buildInsightCard(
                icon: FontAwesomeIcons.buildingCircleArrowRight,
                title: "Recommended Rooftop Material",
                value: recommendedMaterial,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.houseChimney, // ✅ fixed icon
                title: "Suggested Structure",
                value: suggestedStructure,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.mountain,
                title: "Principal Aquifers",
                value: principalAquifers,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.water,
                title: "Depth to Groundwater",
                value: groundwaterDepth,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.cloudRain,
                title: "Runoff Generation Capacity",
                value: runoffCapacity,
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.coins,
                title: "Cost Estimation & Benefit",
                value: costEstimation,
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

  // --- Helper Card Widget ---
  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String value,
    String? imagePath,
  }) {
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
