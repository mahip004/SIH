import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'structure.dart';
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

  Map<String, double>? storageDim;
  Map<String, dynamic>? recharge;
  late RWHStructure rwh;

  @override
  void initState() {
    super.initState();
    calculateWaterAvailability();
  }

  // Function to get nearest rainfall from available list
  double _nearestRainfall(double rainfallValue) {
    double nearestValue = WaterAvailability.rainfall.reduce(
      (a, b) => (a - rainfallValue).abs() < (b - rainfallValue).abs() ? a : b,
    );
    return nearestValue;
  }

  Future<void> calculateWaterAvailability() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final roofArea = userProvider.roofArea;
    final roofType = userProvider.roofType.toLowerCase();
    final numberOfDwellers = userProvider.numberOfDwellers;
    final runoffCoefficient = userProvider.runoffCoefficient;

    // Tank capacity
    tankCapacityLitres = numberOfDwellers * scarcityDays * 10;

    // Get rainfall for state and nearest available value
    final state = userProvider.state;
    final rawRainfall = (stateRainfall[state] ?? 800).toDouble();
    final rainfall = _nearestRainfall(rawRainfall);

    // Initialize RWHStructure object
    rwh = RWHStructure(
      roofArea: userProvider.roofArea,
      numberOfDwellers: userProvider.numberOfDwellers,
      dryDays: scarcityDays,
      limitedSpace: userProvider.limitedSpace,
    );

    storageDim = rwh.storageDimensions;
    recharge = rwh.rechargeStructure;

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
      body: suggestedStructure == "Calculating..."
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A73E8).withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF1A73E8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Calculating your results...",
                      style: TextStyle(
                        color: Color(0xFF1A73E8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A73E8).withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Custom App Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Feasibility Report",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.save_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Rainwater Harvesting Insights",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A73E8),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Based on your location and property details",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A73E8).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.insights,
                                    color: Color(0xFF1A73E8),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Storage Tank
                            _buildInsightCard(
                              icon: FontAwesomeIcons.database,
                              title: "Storage Tank",
                              value:
                                  "${rwh.storageType}\nVolume: ${rwh.storageVolume.toStringAsFixed(0)} L\n"
                                  "Dimensions: ${storageDim?['diameter']?.toStringAsFixed(1) ?? 0} m dia × "
                                  "${storageDim?['height']?.toStringAsFixed(1) ?? 0} m height",
                              gradientColors: const [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                            ),

                            // Recharge Structure
                            _buildInsightCard(
                              icon: FontAwesomeIcons.seedling,
                              title: "Recharge Structure",
                              value:
                                  "${recharge?['type'] ?? 'N/A'}\nRecommended Dimensions: ${recharge?['dimensions'] ?? 'N/A'}\n"
                                  "Estimated Runoff Available: ${waterAvailable.toStringAsFixed(0)} L/year",
                              gradientColors: const [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                            ),

                            // Other insights
                            _buildInsightCard(
                              icon: FontAwesomeIcons.water,
                              title: "Runoff Generation Capacity",
                              value:
                                  "${waterAvailable.toStringAsFixed(0)} litres/year (with runoff coefficient)",
                              gradientColors: const [Color(0xFF5C6BC0), Color(0xFF7986CB)],
                            ),
                            _buildInsightCard(
                              icon: FontAwesomeIcons.database,
                              title: "Required Tank Capacity",
                              value:
                                  "${tankCapacityLitres.toStringAsFixed(0)} litres (For ${userProvider.numberOfDwellers} persons, $scarcityDays days)",
                              gradientColors: const [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                            ),
                            _buildInsightCard(
                              icon: FontAwesomeIcons.coins,
                              title: "Cost Estimation & Benefit",
                              value: costEstimation,
                              gradientColors: const [Color(0xFFFF9800), Color(0xFFFFB74D)],
                            ),
                            _buildInsightCard(
                              icon: FontAwesomeIcons.seedling,
                              title: "Soil Type",
                              value: userProvider.soilType,
                              gradientColors: const [Color(0xFF26A69A), Color(0xFF4DB6AC)],
                            ),
                            _buildInsightCard(
                              icon: FontAwesomeIcons.draftingCompass,
                              title: "Sketch of Structure",
                              value: "Proposed trench/recharge structure",
                              imagePath: "assets/recharge_sketch.png",
                              gradientColors: const [Color(0xFF5C6BC0), Color(0xFF7986CB)],
                            ),

                            const SizedBox(height: 30),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.arrow_back),
                                      label: const Text("Back"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(0xFF1A73E8),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          side: BorderSide(
                                            color: const Color(0xFF1A73E8).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF1A73E8).withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Report saved successfully!'),
                                            backgroundColor: Colors.green[600],
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.save),
                                      label: const Text("Save Report"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1A73E8),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String value,
    String? imagePath,
    required List<Color> gradientColors,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 24, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (imagePath != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} // ✅ End of _ResultScreenState class
