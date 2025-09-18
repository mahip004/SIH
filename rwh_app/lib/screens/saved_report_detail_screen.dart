import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/report_model.dart';

class SavedReportDetailScreen extends StatelessWidget {
  final ReportModel report;

  const SavedReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      "Saved Report",
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
                        Icons.description,
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
                                  "Feasibility Report",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A73E8),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Generated on ${report.formattedDate}",
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

                      // Basic Information
                      _buildInsightCard(
                        icon: FontAwesomeIcons.home,
                        title: "Property Details",
                        value: "State: ${report.state}\n"
                            "Soil Type: ${report.soilType}\n"
                            "Number of Dwellers: ${report.numberOfDwellers}\n"
                            "Roof Area: ${report.roofArea.toStringAsFixed(1)} m²\n"
                            "Roof Type: ${report.roofType}\n"
                            "Roof Material: ${report.roofMaterial}\n"
                            "Open Space: ${report.openSpace.toStringAsFixed(1)} m²",
                        gradientColors: const [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                      ),

                      // Storage Tank
                      _buildInsightCard(
                        icon: FontAwesomeIcons.database,
                        title: "Storage Tank",
                        value: "Volume: ${report.tankCapacityLitres.toStringAsFixed(0)} L\n"
                            "Dimensions: ${report.storageDimensions?['diameter']?.toStringAsFixed(1) ?? 'N/A'} m dia × "
                            "${report.storageDimensions?['height']?.toStringAsFixed(1) ?? 'N/A'} m height\n"
                            "${report.pipeInfo ?? 'No pipe information available'}",
                        gradientColors: const [Color(0xFF1A73E8), Color(0xFF2A93D5)],
                      ),

                      // Recharge Structure
                      _buildInsightCard(
                        icon: FontAwesomeIcons.seedling,
                        title: "Recharge Structure",
                        value: "${report.suggestedStructure}\n"
                            "Recommended Dimensions: ${report.rechargeStructure?['dimensions'] ?? 'N/A'}\n"
                            "Estimated Runoff Available: ${report.waterAvailable.toStringAsFixed(0)} L/year",
                        imagePath: report.rechargeStructure?['image'],
                        gradientColors: const [
                          Color(0xFF26A69A),
                          Color(0xFF4DB6AC)
                        ],
                      ),

                      // Water Availability
                      _buildInsightCard(
                        icon: FontAwesomeIcons.water,
                        title: "Runoff Generation Capacity",
                        value: "${report.waterAvailable.toStringAsFixed(0)} litres/year (with runoff coefficient ${report.runoffCoefficient})",
                        gradientColors: const [
                          Color(0xFF5C6BC0),
                          Color(0xFF7986CB)
                        ],
                      ),

                      // Cost Estimation
                      _buildInsightCard(
                        icon: FontAwesomeIcons.coins,
                        title: "Cost Estimation & Benefit",
                        value: report.costEstimation,
                        gradientColors: const [
                          Color(0xFFFF9800),
                          Color(0xFFFFB74D)
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Back Button
                      Container(
                        width: double.infinity,
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
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Back to Reports"),
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
                        child: imagePath.startsWith('http')
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  'assets/recharge_sketch.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
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
}
