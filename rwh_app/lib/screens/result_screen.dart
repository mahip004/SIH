import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

import '../providers/user_provider.dart';
import 'water_availability_data.dart';
import 'rainfall_data.dart'; // your rainfall map
import 'structure.dart'; // import RWHStructure

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double waterAvailable = 0.0;
  RWHStructure? rwh;
  String costEstimation = "";
  int scarcityDays = 120;

  @override
  void initState() {
    super.initState();
    calculateWaterAvailability();
  }

  Future<void> calculateWaterAvailability() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Create RWHStructure object dynamically
    rwh = RWHStructure(
      roofArea: userProvider.roofArea,
      numberOfDwellers: userProvider.numberOfDwellers,
      dryDays: scarcityDays,
      limitedSpace: userProvider.limitedSpace,
    );

    // Get state from coordinates
    String? state;
    if (userProvider.latitude != null && userProvider.longitude != null) {
      state = await getStateFromCoordinates(userProvider.latitude!, userProvider.longitude!);
    }

    // Get rainfall for state, default to 800 mm
    int annualRainfall = state != null ? ((stateRainfall[state] ?? 800).toInt()) : 800;

    // Calculate water availability
    if (userProvider.roofType.toLowerCase() == "flat") {
      final value = WaterAvailability.getFlatAvailability(userProvider.roofArea, annualRainfall);
      if (value != null) waterAvailable = value * 1000 * userProvider.runoffCoefficient;
    } else if (userProvider.roofType.toLowerCase() == "sloping") {
      final value = WaterAvailability.getSlopingAvailability(userProvider.roofArea, annualRainfall);
      if (value != null) waterAvailable = value * 1000 * userProvider.runoffCoefficient;
    }

    costEstimation =
        "Estimated cost: ₹${(rwh!.storageVolume / 100).toStringAsFixed(0)} – ₹${(rwh!.storageVolume / 80).toStringAsFixed(0)}\n"
        "Benefit: Can store ~${(rwh!.storageVolume / 1000).toStringAsFixed(1)} KL of water";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (rwh == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final storageDim = rwh!.storageDimensions;
    final recharge = rwh!.rechargeStructure;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feasibility Report", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A66C2),
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A66C2)),
              ),
              const SizedBox(height: 20),
              _buildInsightCard(
                icon: FontAwesomeIcons.houseChimney,
                title: "Storage Structure",
                value:
                    "${rwh!.storageType}\nVolume: ${rwh!.storageVolume.toStringAsFixed(0)} L\nDimensions: ${storageDim['diameter']!.toStringAsFixed(1)} m dia × ${storageDim['height']!.toStringAsFixed(1)} m height",
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.draftingCompass,
                title: "Recharge Structure",
                value:
                    "${recharge['type']}\nRecommended Dimensions: ${recharge['dimensions']}\nEstimated Runoff Available: ${waterAvailable.toStringAsFixed(0)} L/year",
                imagePath: "assets/recharge_sketch.png",
              ),
              _buildInsightCard(
                icon: FontAwesomeIcons.coins,
                title: "Cost Estimation & Benefit",
                value: costEstimation,
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
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

// Reverse geocoding function
Future<String?> getStateFromCoordinates(double? latitude, double? longitude) async {
  if (latitude == null || longitude == null) return null;
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      return placemarks.first.administrativeArea;
    }
  } catch (e) {
    debugPrint("Error in reverse geocoding: $e");
  }
  return null;
}
